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

#import <Cocoa/Cocoa.h>
#import "Connection.h"
#import "Interceptor.h"

@interface NetworkLayer : NSObject {
	// mach port
	NSPort* m_localPort;
	NSPort* m_clientPort;
	NSRunLoop* m_loop;
	
	// need shutdown?
	BOOL m_bShutdown;
	
	// connection registry
	NSMutableDictionary* m_connectionRegistry;
	
	// advisor registry
	NSMutableDictionary* m_advisorRegistry;
	
	// interceptor map
	NSMutableDictionary* m_interceptorRegistry;
}

// thread entry point
- (void)threadEntryPoint:(id)param;
- (void)readInBackgroundAndNotify:(id)param;

// helper
- (void)sendConnectionReleasedMessage:(NSNumber*)connId;
- (void)sendConnectionEstablishMessage:(NSNumber*)connId;
- (void)sendConnectionBrokenMessage:(NSNumber*)connId;
- (void)flushConnection:(Connection*)connection;
- (BOOL)releaseConnection:(NSNumber*)connId;
- (Connection*)getConnection:(NSNumber*)connId;
- (void)registerConnectionAdvisor:(int)advisorId advisor:(id<ConnectionAdvisor>)advisor;
- (id<Interceptor>)getInterceptor:(Connection*)conn;

// udp handle
- (void)socketDataRead:(NSNotification*)notification;

// message handler
- (void)handleNewConnectionMessage:(NSPortMessage*)portMessage;
- (void)handleReleaseConnectionMessage:(NSPortMessage*)portMessage;
- (void)handleSendMessage:(NSPortMessage*)portMessage;

@end
