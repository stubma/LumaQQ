/*
 * LumaQQ - Cross platform QQ client, special edition for Mac
 *
 * Copyright (C) 2007 luma <stubma@163.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

#import <netinet/in.h>
#import <arpa/inet.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <unistd.h>
#import <netdb.h>
#import "QQConstants.h"
#import "NetworkLayer.h"
#import "QQEvent.h"
#import "ByteTool.h"
#import "NSNumber-Serialization.h"
#import "NSString-Validate.h"
#import "HttpInterceptor.h"
#import "Socks5Interceptor.h"

@implementation NetworkLayer

- (id) init {
	self = [super init];
	if (self != nil) {
		m_connectionRegistry = [[NSMutableDictionary dictionary] retain];
		m_advisorRegistry = [[NSMutableDictionary dictionary] retain];
		m_interceptorRegistry = [[NSMutableDictionary dictionary] retain];
	}
	return self;
}

- (void) dealloc {
	[m_loop release];
	[m_connectionRegistry release];
	[m_advisorRegistry release];
	[m_interceptorRegistry release];
	[super dealloc];
}

#pragma mark -
#pragma mark thread entry

- (void)threadEntryPoint:(id)param {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	// get client port
	m_clientPort = (NSMachPort*)param;
	
	// create my port
	m_localPort = [[NSMachPort port] retain];
	
	// send delegate and add to run loop
	[m_localPort setDelegate:self];
	[[NSRunLoop currentRunLoop] addPort:m_localPort forMode:NSDefaultRunLoopMode];
	
	// send check in message
	NSPortMessage* msg = [[NSPortMessage alloc] initWithSendPort:m_clientPort
													 receivePort:m_localPort
													  components:nil];
	if(msg) {
		[msg setMsgid:kQQMessageCheckIn];
		[msg sendBeforeDate:[NSDate date]];
		[msg release];
	}
	
	// start run loop
	m_loop = [[NSRunLoop currentRunLoop] retain];
	NSDate* endDate = [[NSDate distantFuture] retain];
	while(!m_bShutdown) {
		[m_loop runMode:NSDefaultRunLoopMode beforeDate:endDate];
	}
	[endDate release];
	
	// remove port
	[m_loop removePort:m_localPort forMode:NSDefaultRunLoopMode];
	
	// send all unsent packet in all connections
	NSEnumerator* e = [m_connectionRegistry objectEnumerator];
	Connection* connection = nil;
	while(connection = [e nextObject]) {
		[self flushConnection:connection];
		[connection close];
	}
	
	// log
	NSLog(@"Network is shutdown");
	
	// release object
	[m_localPort release];	
	[pool release];
}

- (void)readInBackgroundAndNotify:(id)param {
	NSAutoreleasePool* releasePool = [[NSAutoreleasePool alloc] init];
	
	// retain self
	[self retain];
	
	// get connection
	Connection* conn = (Connection*)param;
	
	// check
	if([conn socket] == -1)
		return;
	
	// get interceptor
	id<Interceptor> interceptor = [m_interceptorRegistry objectForKey:conn];
	if(interceptor)
		[interceptor kickoff];
	
	// waiting time
	struct timeval tv;
	tv.tv_sec = 10;
	tv.tv_usec = 0;
	
	// handle mask
	fd_set fds;
	FD_ZERO(&fds);
	FD_SET([conn socket], &fds);
	
	// select
	unsigned char buf[65535];
	int count = select([conn socket] + 1, &fds, NULL, NULL, &tv);
	
	// check result
	while([conn socket] != -1) {	
		if(count < 0) {
			[self releaseConnection:[conn connectionId]];
			
			// send message
			[self sendConnectionReleasedMessage:[conn connectionId]];
		} else if(FD_ISSET([conn socket], &fds) && count == 0) {
			// connection is alive
		} else if(FD_ISSET([conn socket], &fds)) {
			int bytes = read([conn socket], buf, sizeof(buf));
			if(bytes > 0) {
				NSData* data = [[NSData dataWithBytes:buf length:bytes] retain];
				[[NSNotificationCenter defaultCenter] postNotificationName:kQQSocketDataAvailableNotificationName
																	object:conn
																  userInfo:[[[NSDictionary dictionaryWithObject:data forKey:kUserInfoDataItem] retain] autorelease]];
				[data release];
			} else {
				[self releaseConnection:[conn connectionId]];
				
				// notify
				[self sendConnectionBrokenMessage:[conn connectionId]];
			}
		} else {
			// connection is alive
		}
		
		// select again
		if([conn socket] != -1) {
			FD_ZERO(&fds);
			FD_SET([conn socket], &fds);
			count = select([conn socket] + 1, &fds, NULL, NULL, &tv);
		}
	}
	
	// release
	[self release];
	
	// log
	NSLog(@"Connection %u thread exit", [[conn connectionId] intValue]);
	
	[releasePool release];
}

#pragma mark -
#pragma mark port delegate

- (void)handlePortMessage:(NSPortMessage*)portMessage {
	unsigned int msgid = [portMessage msgid];
	
	switch(msgid) {
		case kQQMessageShutdown:
			m_bShutdown = YES;
			break;
		case kQQMessageNewConnection:
			[self handleNewConnectionMessage:portMessage];
			break;
		case kQQMessageReleaseConnection:
			[self handleReleaseConnectionMessage:portMessage];
			break;
		case kQQMessageSend:
			[self handleSendMessage:portMessage];
			break;
	}
}

#pragma mark -
#pragma mark message handler

- (void)handleNewConnectionMessage:(NSPortMessage*)portMessage {
	NSLog(@"New connection");
	
	// get connection object
	NSArray* component = [portMessage components];
	Connection* connection = [Connection deserialize:[component objectAtIndex:0]];
	
	// set network
	[connection setNetwork:self];
	
	// install advisor for connection
	id<ConnectionAdvisor> advisor = [m_advisorRegistry objectForKey:[connection advisorId]];
	if(advisor)
		[connection setAdvisor:advisor];
	
	// get protocol string
	NSString* protocolStr = [connection protocol];
	
	// get destination server
	NSString* server = [connection server];
	unsigned short port = [[connection port] unsignedShortValue];
	if(![[connection proxyType] isEqualToString:kQQProxyNone]) {
		server = [connection proxyServer];
		port = [[connection proxyPort] unsignedShortValue];
	}		
	
	// check dest
	if(!server)
		return;
	
	// create socket address
	struct sockaddr_in addr;
	struct hostent* hostAddr;
	if ((hostAddr = gethostbyname([server cString])) == NULL)
		addr.sin_addr.s_addr = inet_addr((const char*)[server cString]);
	else {
		bzero(&addr, sizeof(addr));
		bcopy(hostAddr->h_addr, (char *)&addr.sin_addr, hostAddr->h_length);
	}
	addr.sin_len = sizeof(addr);
	addr.sin_family = AF_INET;
	addr.sin_port = htons(port);
	
	// create socket
	int socketfd = -1;
	int type = SOCK_STREAM;
	int protocol = IPPROTO_TCP;
	if([protocolStr isEqualToString:kQQProtocolUDP]) {
		type = SOCK_DGRAM;
		protocol = IPPROTO_UDP;
	}
	socketfd = socket(AF_INET, type, protocol);
	if(socketfd == -1) {
		NSLog(@"Fail to create socket");
		return;
	}
	
	// connect
	if(connect(socketfd, (const sockaddr*)&addr, sizeof(addr)) < 0) {
		close(socketfd);
		NSLog(@"Failed to connect to %@", server);
		return;
	}

	// set socket and file handle to connection
	[connection setSocket:socketfd];
	
	// add connection as a observer
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(socketDataRead:)
												 name:kQQSocketDataAvailableNotificationName
											   object:connection];
	
	// add to registry
	[m_connectionRegistry setObject:connection forKey:[connection connectionId]];
	
	// send connection connected message because it is udp
	[connection initReadBuffer];
	
	// register interceptor if necessary
	if([[connection proxyType] isEqualToString:kQQProxyHTTP]) {
		[m_interceptorRegistry setObject:[[[HttpInterceptor alloc] initWithConnection:connection] autorelease]
								  forKey:connection];
	} else if([[connection proxyType] isEqualToString:kQQProxySocks5]) {
		[m_interceptorRegistry setObject:[[[Socks5Interceptor alloc] initWithConnection:connection] autorelease]
								  forKey:connection];
	} else {
		[self sendConnectionEstablishMessage:[connection connectionId]];
	}

	// start to read
	[NSThread detachNewThreadSelector:@selector(readInBackgroundAndNotify:)
							 toTarget:self
						   withObject:connection];
}

- (void)handleReleaseConnectionMessage:(NSPortMessage*)portMessage {
	// get connection id
	NSArray* component = [portMessage components];
	NSNumber* connId = [NSNumber deserialize:[component objectAtIndex:0]];
	
	// get connection
	Connection* connection = [m_connectionRegistry objectForKey:connId];
	if(connection == nil) {
		// if not found, log it, but we still trigger a connection release message
		NSLog(@"Didn't find connection of id: %d", [connId intValue]);
	} else 
		[self releaseConnection:[connection connectionId]];
	
	// send message
	[self sendConnectionReleasedMessage:connId];
}

- (void)handleSendMessage:(NSPortMessage*)portMessage {
	// get connection id
	NSArray* component = [portMessage components];
	NSNumber* connId = [NSNumber deserialize:[component objectAtIndex:0]];
	
	// get connection
	Connection* connection = [m_connectionRegistry objectForKey:connId];
	
	// get packet encrypted data
	NSData* encryptData = [component objectAtIndex:1];
	
	// send or save it to queue
	[connection addPacketData:encryptData];
	[self flushConnection:connection];
}

#pragma mark -
#pragma mark socket handle

- (void)socketDataRead:(NSNotification*)notification {
	// get file handle
	Connection* conn = [notification object];
	
	// get connection id
	NSNumber* connId = [conn connectionId];
	if(connId != nil) {
		// get data
		NSData* data = [[notification userInfo] objectForKey:kUserInfoDataItem];
		if(data && [data length] > 0) {
			// try interceptor first
			id<Interceptor> interceptor = [m_interceptorRegistry objectForKey:conn];
			if(interceptor)
				[interceptor put:data];
			else
				[conn put:data];
			
			// check whether a packet is received complete
			NSMutableArray* component = [NSMutableArray arrayWithObject:[connId serialize]];
			data = [conn nextPacketRead];
			if(data)
				[component addObject:data];
			
			// read all packet
			while(data = [conn nextPacketRead])
				[component addObject:data];
			
			// compact and send message
			if([component count] > 1) {
				[conn compact];
				
				// create message and send
				NSPortMessage* msg = [[NSPortMessage alloc] initWithSendPort:m_clientPort
																 receivePort:m_localPort
																  components:component];
				if(msg) {
					[msg setMsgid:kQQMessageReceived];
					[msg sendBeforeDate:[NSDate date]];
					[msg release];
				}
			}
		}
	}
}

#pragma mark -
#pragma mark helper

- (void)sendConnectionReleasedMessage:(NSNumber*)connId {
	NSArray* array = [NSArray arrayWithObject:[connId serialize]];
	NSPortMessage* msg = [[NSPortMessage alloc] initWithSendPort:m_clientPort
													 receivePort:m_localPort
													  components:array];
	if(msg) {
		[msg setMsgid:kQQMessageConnectionReleased];
		[msg sendBeforeDate:[NSDate date]];
		[msg release];
	}
}

- (void)sendConnectionEstablishMessage:(NSNumber*)connId {
	NSArray* array = [NSArray arrayWithObject:[connId serialize]];
	NSPortMessage* msg = [[NSPortMessage alloc] initWithSendPort:m_clientPort
													 receivePort:m_localPort
													  components:array];
	if(msg) {
		[msg setMsgid:kQQMessageConnectionEstablished];
		[msg sendBeforeDate:[NSDate date]];
		[msg release];
	}
}

- (void)sendConnectionBrokenMessage:(NSNumber*)connId {
	NSArray* array = [NSArray arrayWithObject:[connId serialize]];
	NSPortMessage* msg = [[NSPortMessage alloc] initWithSendPort:m_clientPort
													 receivePort:m_localPort
													  components:array];
	if(msg) {
		[msg setMsgid:kQQMessageConnectionBroken];
		[msg sendBeforeDate:[NSDate date]];
		[msg release];
	}
}

- (void)registerConnectionAdvisor:(int)advisorId advisor:(id<ConnectionAdvisor>)advisor {
	[m_advisorRegistry setObject:advisor forKey:[NSNumber numberWithInt:advisorId]];
}

//
// Send all packet in a connection send queue
//
- (void)flushConnection:(Connection*)connection {
	id<Interceptor> interceptor = [m_interceptorRegistry objectForKey:connection];
	if(interceptor)
		[interceptor flush];
	else
		[connection flush];
}

//
// this method can only be invoked in stream event handler
//
- (BOOL)releaseConnection:(NSNumber*)connId {
	BOOL ret = NO;
	
	@synchronized (self) {
		// get connection
		Connection* connection = [m_connectionRegistry objectForKey:connId];
		
		if(connection) {	
			NSLog(@"Release connection: %d", [connId intValue]);
			
			// remove notification handler
			[[NSNotificationCenter defaultCenter] removeObserver:self
														 name:kQQSocketDataAvailableNotificationName
													   object:connection];
			
			// remove connection from registry and remove interceptor mapping
			[connection retain];
			[m_connectionRegistry removeObjectForKey:connId];
			[m_interceptorRegistry removeObjectForKey:connection];
			
			// close stream
			[connection close];
			[connection release];
			
			ret = YES;
		}
	}

	return ret;
}

- (Connection*)getConnection:(NSNumber*)connId {
	return [m_connectionRegistry objectForKey:connId];
}

- (id<Interceptor>)getInterceptor:(Connection*)conn {
	return [m_interceptorRegistry objectForKey:conn];
}

@end
