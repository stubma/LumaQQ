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

#import "RequestAgentReplyPacket.h"
#import "ByteTool.h"

@implementation RequestAgentReplyPacket

- (void) dealloc {
	[m_message release];
	[super dealloc];
}

#pragma mark -
#pragma mark override

- (void)parseBody:(ByteBuffer*)buf {
	[buf skip:8];
	m_reply = [buf getUInt16];
	[buf getBytes:m_serverIp length:4];
	m_serverPort = [buf getUInt16];
	m_sessionId = [buf getUInt32];
	[buf getBytes:m_redirectServerIp length:4];
	m_redirectServerPort = [buf getUInt16];
	int len = [buf getUInt16];
	m_message = [[buf getString:len] retain];
	
	// swap server ip because they are little-endian
	[ByteTool reverseIp:m_serverIp];
	[ByteTool reverseIp:m_redirectServerIp];
}

- (int)getEncryptStart {
	return [self getInPacketHeaderLength] + 8;
}

- (int)getEncryptLength {
	return m_bodyLength - 8;
}

- (int)getDecryptStart:(NSData*)data {
	return [self getInPacketHeaderLength] + 8;
}

- (int)getDecryptLength:(NSData*)data {
	return [data length] - [self getInPacketHeaderLength] - 8 - 1;
}

#pragma mark -
#pragma mark getter and setter

- (UInt16)reply {
	return m_reply;
}

- (const char*)serverIp {
	return m_serverIp;
}

- (UInt16)serverPort {
	return m_serverPort;
}

- (UInt32)sessionId {
	return m_sessionId;
}

- (const char*)redirectServerIp {
	return m_redirectServerIp;
}

- (UInt16)redirectServerPort {
	return m_redirectServerPort;
}

- (NSString*)message {
	return m_message;
}

@end
