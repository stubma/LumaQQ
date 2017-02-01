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

#import "FriendStatusChangedNotification.h"
#import "QQConstants.h"

@implementation FriendStatusChangedNotification

- (void)read:(ByteBuffer*)buf {
	m_QQ = [buf getUInt32];
	[buf skip:8];
	m_status = [buf getByte];
	m_version = [buf getUInt16];
	m_unknownKey = [[NSMutableData dataWithLength:kQQKeyLength] retain];
	[buf getBytes:(NSMutableData*)m_unknownKey];
	m_property = [buf getUInt32];
	
	[buf skip:13];
	int len = [buf getUInt16];
	m_statusMessage = [[buf getString:len encoding:kQQEncodingUTF8] retain];
}

- (void) dealloc {
	[m_unknownKey release];
	[m_statusMessage release];
	[super dealloc];
}

- (UInt32)QQ {
	return m_QQ;
}

- (char)status {
	return m_status;
}

- (UInt16)version {
	return m_version;
}

- (NSData*)unknownKey {
	return m_unknownKey;
}

- (UInt32)property {
	return m_property;
}

- (NSString*)statusMessage {
	return m_statusMessage;
}

@end
