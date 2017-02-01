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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 0 2111-1307 USA
 */

#import "TempSessionIM.h"

#define _kKeyNick @"TempSessionIM_Nick"
#define _kKeyTime @"TempSessionIM_Time"
#define _kKeyData @"TempSessionIM_Data"
#define _kKeyStyle @"TempSessionIM_Style"

@implementation TempSessionIM

- (void)read:(ByteBuffer*)buf {
	m_sender = [buf getUInt32];
	[buf skip:4];
	
	int len = [buf getByte] & 0xFF;
	m_nick = [[buf getString:len] retain];
	
	len = [buf getByte] & 0xFF;
	m_site = [[buf getString:len] retain];
	
	[buf skip:1];
	
	m_sendTime = [buf getUInt32];
	
	len = [buf getUInt16];
	
	int fontStyleLen = [buf getByte:([buf position] + len - 1)] & 0xFF;
	m_messageData = [[NSMutableData dataWithLength:(len - fontStyleLen)] retain];
	[buf getBytes:(NSMutableData*)m_messageData];
	
	m_fontStyle = [[FontStyle alloc] init];
	[m_fontStyle read:buf];
}

- (void) dealloc {
	[m_nick release];
	[m_site release];
	[m_messageData release];
	[m_fontStyle release];
	[super dealloc];
}

#pragma mark -
#pragma mark NSCoding protocol

- (void)encodeWithCoder:(NSCoder*)encoder {
	[encoder encodeObject:m_nick forKey:_kKeyNick];
	[encoder encodeInt32:m_sendTime forKey:_kKeyTime];
	[encoder encodeObject:m_messageData forKey:_kKeyData];
	[encoder encodeObject:m_fontStyle forKey:_kKeyStyle];
}

- (id)initWithCoder:(NSCoder*)decoder {
	m_nick = [[decoder decodeObjectForKey:_kKeyNick] retain];
	m_sendTime = [decoder decodeInt32ForKey:_kKeyTime];
	m_messageData = [[decoder decodeObjectForKey:_kKeyData] retain];
	m_fontStyle = [[decoder decodeObjectForKey:_kKeyStyle] retain];
	return self;
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)sender {
	return m_sender;
}

- (NSString*)nick {
	return m_nick;
}

- (NSString*)site {
	return m_site;
}

- (NSData*)messageData {
	return m_messageData;
}

- (UInt32)sendTime {
	return m_sendTime;
}

- (FontStyle*)fontStyle {
	return m_fontStyle;
}

@end
