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

#import "LoginReplyPacket.h"


@implementation LoginReplyPacket : BasicInPacket

- (void) dealloc {
	[m_sessionKey release];
	[m_authToken release];
	[m_clientKey release];
	[m_errorMessage release];
	[super dealloc];
}

#pragma mark -
#pragma mark override super

- (void)parseBody:(ByteBuffer*)buf {
	m_reply = [buf getByte];
	
	switch(m_reply) {
		case kQQReplyOK:
			m_sessionKey = [[NSMutableData dataWithLength:kQQKeyLength] retain];
			[buf getBytes:(NSMutableData*)m_sessionKey];
			
			m_QQ = [buf getUInt32];
			[buf getBytes:m_ip length:4];
			m_port = [buf getUInt16];
			
			[buf getBytes:m_serverIp length:4];
			m_serverPort = [buf getUInt16];
			m_loginTime = [buf getUInt32];
			
			[buf skip:50];

			m_clientKey = [[NSMutableData dataWithLength:32] retain];
			[buf getBytes:(NSMutableData*)m_clientKey];
			
			[buf skip:12];
			[buf getBytes:m_lastLoginIp length:4];
			m_lastLoginTime = [buf getUInt32];
			break;
		case kQQReplyRedirect:
			m_QQ = [buf getUInt32];
			[buf skip:10];
			[buf getBytes:m_redirectServerIp length:4];
			break;
		case kQQReplyPasswordError:
			[buf skip:8];
			// fall through
		case kQQReplyServerBusy:
		case kQQReplyLoginFailed:
			m_errorMessage = [[buf getString:[buf available]] retain];
			break;
	}
}

- (NSData*)getDecryptKey {
	return [m_user passwordKey];
}

- (NSData*)getFallbackDecryptKey {
	return [m_user initialKey];
}

#pragma mark -
#pragma mark helper

- (BOOL)isRedirectIpNull {
	return *((UInt32*)m_redirectServerIp) == 0;
}

#pragma mark -
#pragma mark getter and setter

- (NSData*)sessionKey {
	return m_sessionKey;
}

- (UInt32)QQ {
	return m_QQ;
}

- (const char*)ip {
	return m_ip;
}

- (UInt16)port {
	return m_port;
}

- (const char*)serverIp {
	return m_serverIp;
}

- (UInt16)serverPort {
	return m_serverPort;
}

- (UInt32)loginTime {
	return m_loginTime;
}

- (NSData*)authToken {
	return m_authToken;
}

- (NSData*)clientKey {
	return m_clientKey;
}

- (const char*)lastLoginIp {
	return m_lastLoginIp;
}

- (UInt32)lastLoginTime {
	return m_lastLoginTime;
}

- (const char*)redirectServerIp {
	return m_redirectServerIp;
}

- (NSString*)errorMessage {
	return m_errorMessage;
}

@end
