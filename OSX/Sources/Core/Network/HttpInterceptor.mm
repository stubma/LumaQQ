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

#import "HttpInterceptor.h"
#import "Connection.h"
#import "NetworkLayer.h"
#import "NSData-Base64.h"
#import "NSString-Validate.h"

#define _kStatusInit 0
#define _kStatusAuthenticating 1
#define _kStatusReady 2

#define _kConnect @"CONNECT %@:%u HTTP/1.1\r\nAccept: */*\r\nContent-Type: text/html\r\nProxy-Connection: Keep-Alive\r\nContent-length: 0\r\n\r\n"
#define _kConnectWithBasicAuth @"CONNECT %@:%u HTTP/1.1\r\nProxy-Authorization: Basic %@\r\nAccept: */*\r\nContent-Type: text/html\r\nProxy-Connection: Keep-Alive\r\nContent-length: 0\r\n\r\n"

#define _kReplySuccess @"200"
#define _kReplyNeedAuth @"407"

@implementation HttpInterceptor

- (id)initWithConnection:(Connection*)conn {
	self = [super init];
	if(self) {
		m_status = _kStatusInit;
		m_connection = [conn retain];
	}
	return self;
}

- (void) dealloc {
	[m_connection release];
	[super dealloc];
}

#pragma mark -
#pragma mark Interceptor protocol

- (void)kickoff {
	NSString* s = [NSString stringWithFormat:_kConnect, [m_connection server], [[m_connection port] unsignedShortValue]];
	[m_connection write:[s cString] length:[s cStringLength]];
}

- (void)flush {
	if(m_status == _kStatusReady)
		[m_connection flush];
}

- (void)put:(NSData*)data {
	if(m_status == _kStatusReady)
		[m_connection put:data];
	else {
		NSString* reply = [NSString stringWithCString:(const char*)[data bytes]];
		
		// find "HTTP 1.x" header
		NSRange range = [reply rangeOfString:@"HTTP/1."];
		if(range.location != 0)
			return;
		
		// get reply code
		reply = [reply substringWithRange:NSMakeRange(9, 3)];
		NSLog(@"http proxy reply code: %@", reply);
		if([reply isEqualToString:_kReplySuccess]) {
			m_status = _kStatusReady;
			[[m_connection network] sendConnectionEstablishMessage:[m_connection connectionId]];
		} else if([reply isEqualToString:_kReplyNeedAuth]) {
			if(m_status == _kStatusAuthenticating) {
				[[m_connection network] sendConnectionBrokenMessage:[m_connection connectionId]];
			} else {
				// get auth string
				NSString* auth = @"";
				if(![[m_connection proxyUsername] isEmpty] && ![[m_connection proxyPassword] isEmpty])
					auth = [NSString stringWithFormat:@"%@:%@", [m_connection proxyUsername], [m_connection proxyPassword]];
				NSData* data = [NSData dataWithBytes:[auth cString] length:[auth cStringLength]];
				data = [data base64Encode];
				auth = [NSString stringWithCString:(const char*)[data bytes]];
				
				// send data
				NSString* s = [NSString stringWithFormat:_kConnectWithBasicAuth, 
					[m_connection server], 
					[[m_connection port] unsignedShortValue],
					auth];
				[m_connection write:[s cString] length:[s cStringLength]];
				
				// change status
				m_status = _kStatusAuthenticating;
			}
		} else {
			[[m_connection network] sendConnectionBrokenMessage:[m_connection connectionId]];
		}
	}
}

@end
