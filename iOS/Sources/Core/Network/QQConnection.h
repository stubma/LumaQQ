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

#import <Foundation/Foundation.h>

// represent a network connection, a connection is identified by an id
@interface QQConnection : NSObject <NSCopying> {
	// connection id
	NSNumber* m_connId;
	
	// connection parameters
	NSString* m_protocol;
	NSString* m_server;
	NSNumber* m_port;
	NSString* m_proxyType;
	NSString* m_proxyServer;
	NSNumber* m_proxyPort;
	NSString* m_proxyUsername;
	NSString* m_proxyPassword;
	
	// advisor & interceptor
	id m_advisor;
	id m_interceptor;

	// socket
	int m_socket;
	
	// read buffer
	NSMutableData* m_buffer;
	int m_bufferPos;
	int m_readPos;
	
	// delegate
	id m_delegate;
}

+ (int)nextAvailableConnectionId;

// initialization
- (id)initWithServer:(NSString*)server port:(int)port protocol:(NSString*)protocol;
- (id)initWithServer:(NSString*)server port:(int)port protocol:(NSString*)protocol proxyType:(NSString*)proxyType proxyServer:(NSString*)proxyServer proxyPort:(int)proxyPort proxyUsername:(NSString*)proxyUsername proxyPassword:(NSString*)proxyPassword;
- (id)copyWithNewAddress:(NSString*)newServer;
- (id)copy;

// network
- (void)deliverPackets:(NSArray*)array;
- (void)sendConnectionBrokenMessage;
- (void)sendConnectionEstablishMessage;
- (void)sendConnectionReleasedMessage;
- (void)start;
- (void)readInBackgroundAndNotify:(id)param;
- (void)socketDataRead:(NSData*)data;

// queue operation
- (void)compact;
- (size_t)write:(NSData*)data;
- (size_t)write:(const char*)bytes length:(int)length;
- (void)close;
- (size_t)_write:(const char*)buffer length:(int)length;

// read buffer
- (void)put:(NSData*)data;
- (void)initReadBuffer;
- (NSData*)nextPacketRead;

// accessor
- (BOOL)isUdp;
- (NSNumber*)connectionId;
- (void)setConnectionId:(NSNumber*)connId;
- (NSString*)protocol;
- (void)setProtocol:(NSString*)protocol;
- (NSString*)server;
- (void)setServer:(NSString*)address;
- (NSNumber*)port;
- (void)setPort:(NSNumber*)port;
- (NSString*)proxyType;
- (void)setProxyType:(NSString*)type;
- (NSString*)proxyServer;
- (void)setProxyServer:(NSString*)address;
- (NSNumber*)proxyPort;
- (void)setProxyPort:(NSNumber*)value;
- (NSString*)proxyUsername;
- (void)setProxyUsername:(NSString*)username;
- (NSString*)proxyPassword;
- (void)setProxyPassword:(NSString*)pass;
- (void)setAdvisor:(id)advisor;
- (int)socket;
- (void)setDelegate:(id)delegate;
- (void)setInterceptor:(id)interceptor;

@end
