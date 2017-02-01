/*
 * LumaQQ - Cross platform QQ client, special edition for iPhone
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
#import <sys/types.h>
#import <sys/uio.h>
#import <Message/NetworkController.h>
#import "QQConnection.h"
#import "QQConstants.h"
#import "ByteTool.h"
#import "Interceptor.h"
#import "HttpInterceptor.h"
#import "Socks5Interceptor.h"
#import "ConnectionAdvisor.h"
#import "ConnectionDelegate.h"

static int s_nextConnectionId = 0;

@implementation QQConnection

+ (int)nextAvailableConnectionId {
	return s_nextConnectionId++;
}

- (id)initWithServer:(NSString*)server port:(int)port protocol:(NSString*)protocol {
	m_socket = -1;
	m_connId = [[NSNumber numberWithInt:[QQConnection nextAvailableConnectionId]] retain];
	m_port = [[NSNumber numberWithInt:port] retain];
	[self setServer:server];
	[self setProtocol:protocol];
	[self setProxyType:kQQProxyNone];
	return self;
}

- (id)initWithServer:(NSString*)server port:(int)port protocol:(NSString*)protocol proxyType:(NSString*)proxyType proxyServer:(NSString*)proxyServer proxyPort:(int)proxyPort proxyUsername:(NSString*)proxyUsername proxyPassword:(NSString*)proxyPassword {
	self = [self initWithServer:server
					   port:port
				   protocol:protocol];
	if(self) {
		[self setProxyType:proxyType];
		[self setProxyServer:proxyServer];
		[self setProxyPort:[NSNumber numberWithInt:proxyPort]];
		[self setProxyUsername:proxyUsername];
		[self setProxyPassword:proxyPassword];
	}
	return self;
}

- (id)copyWithNewAddress:(NSString*)newServer {
	QQConnection* copy = [[QQConnection alloc] initWithServer:newServer
												 port:[m_port intValue]
											 protocol:m_protocol
											proxyType:m_proxyType
										  proxyServer:m_proxyServer
											proxyPort:[m_proxyPort intValue]
										proxyUsername:m_proxyUsername
										proxyPassword:m_proxyPassword];
	[copy setAdvisor:m_advisor];
	[copy setInterceptor:m_interceptor];
	[copy setDelegate:m_delegate];
	return [copy autorelease];
}

- (id)copy {
	QQConnection* copy = [[QQConnection alloc] initWithServer:m_server
													 port:[m_port intValue]
												 protocol:m_protocol
												proxyType:m_proxyType
											  proxyServer:m_proxyServer
												proxyPort:[m_proxyPort intValue]
											proxyUsername:m_proxyUsername
											proxyPassword:m_proxyPassword];
	[copy setAdvisor:m_advisor];
	[copy setInterceptor:m_interceptor];
	return [copy autorelease];
}

- (void) dealloc {
	[m_delegate release];
	[m_connId release];
	[m_server release];
	[m_protocol release];
	[m_proxyType release];
	[m_proxyServer release];
	[m_proxyUsername release];
	[m_proxyPassword release];
	[m_buffer release];
	if(m_socket != -1) {
		close(m_socket);
		m_socket = -1;
	}
	[m_advisor release];
	[m_interceptor release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
	return [self retain];
}

- (void)sendConnectionBrokenMessage {
	[m_delegate performSelectorOnMainThread:@selector(connectionBroken:) withObject:self waitUntilDone:YES];
}

- (void)sendConnectionEstablishMessage {
	[m_delegate performSelectorOnMainThread:@selector(connectionEstablished:) withObject:self waitUntilDone:YES];
}

- (void)sendConnectionReleasedMessage {
	[m_delegate performSelectorOnMainThread:@selector(connectionReleased:) withObject:self waitUntilDone:YES];
}

- (void)deliverPackets:(NSArray*)array {
	[array retain];
	[m_delegate performSelectorOnMainThread:@selector(connectionHasData:) 
								 withObject:[NSArray arrayWithObjects:self, array, nil]
							  waitUntilDone:YES];
	[array release];
}

- (void)start {	
	// start to read
	[NSThread detachNewThreadSelector:@selector(readInBackgroundAndNotify:)
							 toTarget:self
						   withObject:nil];
}

- (void)readInBackgroundAndNotify:(id)param {
	NSAutoreleasePool* releasePool = [[NSAutoreleasePool alloc] init];
	
	// activate network
	NetworkController* nc = [NetworkController sharedInstance];
	if(![nc isNetworkUp]) {
		if(![nc isEdgeUp]) {
			[nc keepEdgeUp];
			[nc bringUpEdge];
			CFRunLoopRunInMode(kCFRunLoopDefaultMode,
							   5.0,
							   NO);
		}
	}
	
	// get destination server
	NSString* server = m_server;
	unsigned short port = [m_port unsignedShortValue];
	if(![m_proxyType isEqualToString:kQQProxyNone]) {
		server = m_proxyServer;
		port = [m_proxyPort unsignedShortValue];
	}		
	NSLog(@"New connection to %@, %u", server, port);
	
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
	if([m_protocol isEqualToString:kQQProtocolUDP]) {
		type = SOCK_DGRAM;
		protocol = IPPROTO_UDP;
	}
	m_socket = socket(AF_INET, type, protocol);
	if(m_socket == -1) {
		NSLog(@"Fail to create socket");
		return;
	}
	
	// connect
	if(connect(m_socket, (const struct sockaddr*)&addr, sizeof(addr)) < 0) {
		[self close];
		NSLog(@"Failed to connect to %@", server);
		return;
	}
	
	// send connection connected message because it is udp
	[self initReadBuffer];
	
	// register interceptor if necessary
	if([m_proxyType isEqualToString:kQQProxyHTTP]) {
		m_interceptor = [[HttpInterceptor alloc] initWithConnection:self];
	} else if([m_proxyType isEqualToString:kQQProxySocks5]) {
		m_interceptor = [[Socks5Interceptor alloc] initWithConnection:self];
	} else {
		// connection established
		[self sendConnectionEstablishMessage];
	}
	
	// retain self
	[self retain];
	
	// check
	if(m_socket == -1)
		return;
	
	// save conn id
	int connId = [[self connectionId] intValue];
	
	// get interceptor
	if(m_interceptor != nil)
		[m_interceptor kickoff];
	
	// waiting time
	struct timeval tv;
	tv.tv_sec = 10;
	tv.tv_usec = 0;
	
	// handle mask
	fd_set fds;
	FD_ZERO(&fds);
	FD_SET(m_socket, &fds);
	
	// select
	unsigned char buf[65535];
	int count = select(m_socket + 1, &fds, NULL, NULL, &tv);
	
	// check result
	while(m_socket != -1) {	
		if(count < 0) {
			// close
			[self close];
			
			// connection released
			[self sendConnectionReleasedMessage];
		} else if(FD_ISSET(m_socket, &fds) && count == 0) {
			// connection is alive
		} else if(FD_ISSET(m_socket, &fds)) {
			int bytes = read(m_socket, buf, sizeof(buf));
			if(bytes > 0) {
				NSData* data = [NSData dataWithBytes:buf length:bytes];
				[self socketDataRead:data];
			} else {
				// close
				[self close];
				
				// connection broken
				[self sendConnectionBrokenMessage];
			}
		} else {
			// connection is alive
		}
		
		// select again
		if(m_socket != -1) {
			FD_ZERO(&fds);
			FD_SET(m_socket, &fds);
			count = select(m_socket + 1, &fds, NULL, NULL, &tv);
		}
	}
	
	// release
	[self release];
	
	// log
	NSLog(@"Connection %u thread exit", connId);
	
	[releasePool release];
}

- (void)socketDataRead:(NSData*)data {
	// get data
	if(data && [data length] > 0) {
		// try interceptor first
		if(m_interceptor != nil)
			[m_interceptor put:data];
		else
			[self put:data];
		
		// check whether a packet is received complete
		NSMutableArray* dataArray = [NSMutableArray array];
		data = [self nextPacketRead];
		if(data)
			[dataArray addObject:data];
		
		// read all packet
		while(data = [self nextPacketRead])
			[dataArray addObject:data];
		
		// compact and send message
		if([dataArray count] > 0) {
			[self compact];
			
			// add packet data to somewhere
			[self deliverPackets:dataArray];
		}
	}
}

#pragma mark -
#pragma mark read buffer

- (void)initReadBuffer {
	[m_buffer release];
	m_buffer = [[NSMutableData dataWithLength:65536] retain];
	m_bufferPos = 0;
	m_readPos = 0;
}

- (void)put:(NSData*)data {
	if(m_buffer) {
		uint8_t* bytes = (uint8_t*)[m_buffer mutableBytes];
		memcpy(bytes + m_bufferPos, [data bytes], [data length]);
		m_bufferPos += [data length];
	}
}

- (NSData*)nextPacketRead {	
	// must have an advisor
	if(m_advisor == nil)
		return nil;
	
	//
	// get a packet encrypted data if the buffer data is more than one packet
	//
	
	// if data length is less than 2
	if(m_bufferPos - m_readPos < [m_advisor minAvailableBytes:[self isUdp]])
		return nil;
	
	// get buffer
	char* bytes = (char*)[m_buffer mutableBytes];
	
	// get packet length
	int skipByte = [m_advisor skipUselessBytes:[self isUdp]];
	int length = [m_advisor packetLength:[self isUdp] bytes:bytes readPos:m_readPos];
	m_readPos += skipByte;
	length -= skipByte;
	
	// check length
	if(length <= 0)
		length = m_bufferPos - m_readPos;
	
	// check sanity
	if(![m_advisor sanityCheck:[self isUdp]
						bytes:bytes
					  readPos:m_readPos
					bufferPos:m_bufferPos])
		return nil;
	
	// get packet
	if(m_bufferPos - m_readPos >= length && length > 0) {
		NSData* data = [NSData dataWithBytes:(bytes + m_readPos) length:length];
		m_readPos += length;
		return data;
	} else {
		m_readPos -= skipByte;
		return nil;
	}
}

- (void)compact {
	if(m_readPos == 0)
		return;
	
	// get buffer
	char* bytes = (char*)[m_buffer mutableBytes];
	
	// move data to beginning
	memmove(bytes, bytes + m_readPos, m_bufferPos - m_readPos);
	
	m_bufferPos -= m_readPos;
	m_readPos = 0;
}

- (size_t)write:(NSData*)data {
	size_t ret = [self write:[data bytes] length:[data length]];
	if(ret == -1) {
		NSLog(@"write error: %u", errno);
		return -1;
	} else {
		return ret;
	}		
}

- (size_t)write:(const char*)bytes length:(int)length {
	if(m_interceptor == nil || m_interceptor != nil && [m_interceptor isReady]) {
		if([m_advisor prependLengthWhenSend:[self isUdp]]) {
			uint8_t buffer[2];
			int realLen = length + 2;
			buffer[0] = realLen >> 8;
			buffer[1] = realLen;				
			if([self _write:(const char*)buffer length:2] == -1) {
				NSLog(@"write error: %u", errno);
				return -1;
			}
		}
	}
	
	if([self _write:bytes length:length] == -1) {
		NSLog(@"write error: %u", errno);
		return -1;
	} else
		return length;
}

- (size_t)_write:(const char*)buffer length:(int)length {
	size_t sent = 0;
	size_t ret = 0;
	ret = write(m_socket, buffer, length);
	sent += ret;
	while(ret != -1 && sent < length) {
		ret = write(m_socket, buffer + sent, length - sent);
		sent += ret;
	}
	if(ret == -1)
		return -1;
	else
		return sent;
}

- (void)close {
	if(m_socket != -1) {
		close(m_socket);
		m_socket = -1;
	}
}

#pragma mark -
#pragma mark setter and getter

- (NSNumber*)connectionId {
	return m_connId;
}

- (void)setConnectionId:(NSNumber*)connId {
	[connId retain];
	[m_connId release];
	m_connId = connId;
}

- (NSString*)protocol {
	return m_protocol;
}

- (void)setProtocol:(NSString*)protocol {
	[protocol retain];
	[m_protocol release];
	m_protocol = protocol;
}

- (NSString*)server {
	return m_server;
}

- (void)setServer:(NSString*)address {
	[address retain];
	[m_server release];
	m_server = address;
}

- (NSNumber*)port {
	return m_port;
}

- (void)setPort:(NSNumber*)port {
	[port retain];
	[m_port release];
	m_port = port;
}

- (NSString*)proxyType {
	return m_proxyType;
}

- (void)setProxyType:(NSString*)type {
	[type retain];
	[m_proxyType release];
	m_proxyType = type;
}

- (NSString*)proxyServer {
	return m_proxyServer;
}

- (void)setProxyServer:(NSString*)address {
	[address retain];
	[m_proxyServer release];
	m_proxyServer = address;
}

- (NSNumber*)proxyPort {
	return m_proxyPort;
}

- (void)setProxyPort:(NSNumber*)value {
	[value retain];
	[m_proxyPort release];
	m_proxyPort = value;
}

- (NSString*)proxyUsername {
	return m_proxyUsername;
}

- (void)setProxyUsername:(NSString*)username {
	[username retain];
	[m_proxyUsername release];
	m_proxyUsername = username;
}

- (NSString*)proxyPassword {
	return m_proxyPassword;
}

- (void)setProxyPassword:(NSString*)pass {
	[pass retain];
	[m_proxyPassword release];
	m_proxyPassword = pass;
}

- (void)setAdvisor:(id)advisor {
	[(id)advisor retain];
	[(id)m_advisor release];
	m_advisor = advisor;
}

- (int)socket {
	return m_socket;
}

- (BOOL)isUdp {
	return [m_protocol isEqualToString:kQQProtocolUDP];
}

- (void)setDelegate:(id)delegate {
	[delegate retain];
	[m_delegate release];
	m_delegate = delegate;
}

- (void)setInterceptor:(id)interceptor {
	[interceptor retain];
	[m_interceptor release];
	m_interceptor = interceptor;
}

@end
