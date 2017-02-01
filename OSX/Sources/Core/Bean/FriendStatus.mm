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

#import "FriendStatus.h"
#import "QQConstants.h"

@implementation FriendStatus

- (void) dealloc {
	[m_unknownKey release];
	[super dealloc];
}

- (void)read:(ByteBuffer*)buf {
	m_QQ = [buf getUInt32];
	[buf skip:1];
	[buf getBytes:m_ip length:4];
	m_port = [buf getUInt16];
	[buf skip:1];
	m_status = [buf getByte];
	[buf skip:2];
	m_unknownKey = [[NSMutableData dataWithLength:kQQKeyLength] retain];
	[buf getBytes:(NSMutableData*)m_unknownKey];
	m_userFlag = [buf getUInt32];
	[buf skip:7];
}

- (BOOL)isEqual:(id)anObject {
	if([anObject isKindOfClass:[FriendStatus class]])
		return m_QQ == [anObject QQ];
	else
		return NO;
}

- (unsigned)hash {
	return m_QQ;
}

- (id)copyWithZone:(NSZone *)zone {
	return [self retain];
}

#pragma mark - 
#pragma mark getter and setter

- (UInt32)QQ {
	return m_QQ;
}

- (const char*)ip {
	return m_ip;
}

- (UInt16)port {
	return m_port;
}

- (char)status {
	return m_status;
}

- (NSData*)unknownKey {
	return m_unknownKey;
}

- (int)userFlag {
	return m_userFlag;
}

@end
