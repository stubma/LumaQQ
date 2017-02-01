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

#import "MobileIM.h"
#import "QQConstants.h"

#define _kKeyQQ @"MobileIM_QQ"
#define _kKeyMobile @"MobileIM_Mobile"
#define _kKeySendTime @"MobileIM_SendTime"
#define _kKeyMessage @"MobileIM_Message"

@implementation MobileIM

- (void) dealloc {
	[m_name release];
	[m_mobile release];
	[m_message release];
	[super dealloc];
}

- (void)readMobileQQ:(ByteBuffer*)buf {
	[buf skip:1];
	m_QQ = [buf getUInt32];
	m_header = [buf getUInt16];
	m_name = [[buf getStringUntil:0 maxLength:kQQMaxSMSSenderName] retain];
	[buf skip:1];
	m_sendTime = [buf getUInt32];
	[buf skip:1];
	m_message = [[buf getStringUntil:0] retain];
}

- (void)readMobileQQ2:(ByteBuffer*)buf {
	[buf skip:1];
	m_mobile = [[buf getStringUntil:0 maxLength:kQQMaxMobileLength] retain];
	[buf skip:2];
	m_sendTime = [buf getUInt32];
	[buf skip:1];
	m_message = [[buf getStringUntil:0] retain];
}

#pragma mark -
#pragma mark NSCoding protocol

- (void)encodeWithCoder:(NSCoder*)encoder {
	[encoder encodeInt32:m_QQ forKey:_kKeyQQ];
	[encoder encodeObject:m_mobile forKey:_kKeyMobile];
	[encoder encodeInt32:m_sendTime forKey:_kKeySendTime];
	[encoder encodeObject:m_message forKey:_kKeyMessage];
}

- (id)initWithCoder:(NSCoder*)decoder {
	m_QQ = [decoder decodeInt32ForKey:_kKeyQQ];
	m_mobile = [[decoder decodeObjectForKey:_kKeyMobile] retain];
	m_sendTime = [decoder decodeInt32ForKey:_kKeySendTime];
	m_message = [[decoder decodeObjectForKey:_kKeyMessage] retain];
	return self;
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)QQ {
	return m_QQ;
}

- (NSString*)mobile {
	return m_mobile;
}

- (UInt16)header {
	return m_header;
}

- (NSString*)name {
	return m_name;
}

- (UInt32)sendTime {
	return m_sendTime;
}

- (NSString*)message {
	return m_message;
}

@end
