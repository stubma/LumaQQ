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

#import <sys/types.h>
#import <sys/uio.h>
#import <unistd.h>
#import "Connection.h"
#import "QQConstants.h"
#import "ByteTool.h"
#import "Interceptor.h"
#import "NetworkLayer.h"

static int s_nextConnectionId = 0;

@implementation Connection

+ (int)nextAvailableConnectionId {
	return s_nextConnectionId++;
}

- (id)initWithServer:(NSString*)server port:(int)port protocol:(NSString*)protocol {
	m_socket = -1;
	m_connId = [[NSNumber numberWithInt:[Connection nextAvailableConnectionId]] retain];
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
	Connection* copy = [[Connection alloc] initWithServer:newServer
												 port:[m_port intValue]
											 protocol:m_protocol
											proxyType:m_proxyType
										  proxyServer:m_proxyServer
											proxyPort:[m_proxyPort intValue]
										proxyUsername:m_proxyUsername
										proxyPassword:m_proxyPassword];
	[copy setAdvisorId:m_advisorId];
	return [copy autorelease];
}

- (void) dealloc {
	[m_connId release];
	[m_advisorId release];
	[m_sendQueue release];
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
	[(id)m_advisor release];
	[m_network release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
	return [self retain];
}

#pragma mark -
#pragma mark encode and decode

- (NSData*)serialize {
	NSMutableData* data = [NSMutableData data];
	NSArchiver* ar = [[NSArchiver alloc] initForWritingWithMutableData:data];
	[ar encodeObject:m_connId];
	[ar encodeObject:m_advisorId];
	[ar encodeObject:m_protocol];
	[ar encodeObject:m_server];
	[ar encodeObject:m_port];
	[ar encodeObject:m_proxyType];
	[ar encodeObject:m_proxyServer];
	[ar encodeObject:m_proxyPort];
	[ar encodeObject:m_proxyUsername];
	[ar encodeObject:m_proxyPassword];
	[ar release];
	return data;
}

+ (Connection*)deserialize:(NSData*)data {
	NSUnarchiver* unar = [[NSUnarchiver alloc] initForReadingWithData:data];
	Connection* con = [[Connection alloc] init];
	[con setConnectionId:[unar decodeObject]];
	[con setAdvisorId:[unar decodeObject]];
	[con setProtocol:[unar decodeObject]];
	[con setServer:[unar decodeObject]];
	[con setPort:[unar decodeObject]];
	[con setProxyType:[unar decodeObject]];
	[con setProxyServer:[unar decodeObject]];
	[con setProxyPort:[unar decodeObject]];
	[con setProxyUsername:[unar decodeObject]];
	[con setProxyPassword:[unar decodeObject]];
	[unar release];
	return [con autorelease];
}

#pragma mark -
#pragma mark queue operation

- (BOOL)sendQueueEmpty {
	return [m_sendQueue count] == 0;
}

- (NSData*)nextPacketData {
	if([m_sendQueue count] > 0) {
		NSData* data = [[m_sendQueue objectAtIndex:0] retain];
		[m_sendQueue removeObjectAtIndex:0];
		return [data autorelease];
	} else
		return nil;
}

- (void)addPacketData:(NSData*)data {
	if(m_sendQueue == nil)
		m_sendQueue = [[NSMutableArray array] retain];
	[m_sendQueue addObject:data];
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

- (void)flush {
	while(NSData* data = [self nextPacketData]) {			
		// if need prepend length
		if([m_advisor prependLengthWhenSend:[self isUdp]]) {
			uint8_t buffer[2];
			int length = [data length] + 2;
			buffer[0] = length >> 8;
			buffer[1] = length;				
			[self write:(const char*)buffer length:2];
		}

		// flush data
		[self write:data];
	}
}

- (void)write:(NSData*)data {
	size_t ret = write(m_socket, [data bytes], [data length]);
	if(ret == -1)
		NSLog(@"write error: %u", errno);
}

- (void)write:(const char*)bytes length:(int)length {
	size_t ret = write(m_socket, bytes, length);
	if(ret == -1)
		NSLog(@"write error: %u", errno);
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

- (NSNumber*)advisorId {
	return m_advisorId;
}

- (void)setAdvisorId:(NSNumber*)advisorId {
	[advisorId retain];
	[m_advisorId release];
	m_advisorId = advisorId;
}

- (void)setAdvisor:(id<ConnectionAdvisor>)advisor {
	[(id)advisor retain];
	[(id)m_advisor release];
	m_advisor = advisor;
}

- (void)setSocket:(int)socket {
	m_socket = socket;
}

- (int)socket {
	return m_socket;
}

- (BOOL)isUdp {
	return [m_protocol isEqualToString:kQQProtocolUDP];
}

- (void)setNetwork:(NetworkLayer*)network {
	[network retain];
	[m_network release];
	m_network = network;
}

- (NetworkLayer*)network {
	return m_network;
}

@end
