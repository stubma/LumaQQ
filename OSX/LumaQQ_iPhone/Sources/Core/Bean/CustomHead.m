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

#import "CustomHead.h"
#import "QQConstants.h"

#define _kKeyQQ @"QQ"
#define _kKeyTimestamp @"Timestamp"
#define _kKeyMd5 @"Md5"

@implementation CustomHead

- (void) dealloc {
	[m_md5 release];
	[super dealloc];
}

- (void)read:(ByteBuffer*)buf {
	m_QQ = [buf getUInt32];
	m_timestamp = [buf getUInt32];
	m_md5 = [[NSMutableData dataWithLength:kQQKeyLength] retain];
	[buf getBytes:(NSMutableData*)m_md5];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt32:m_QQ forKey:_kKeyQQ];
	[encoder encodeInt:m_timestamp forKey:_kKeyTimestamp];
	[encoder encodeObject:m_md5 forKey:_kKeyMd5];
}

- (id)initWithCoder:(NSCoder *)decoder {
	m_QQ = [decoder decodeInt32ForKey:_kKeyQQ];
	m_timestamp = [decoder decodeInt32ForKey:_kKeyTimestamp];
	m_md5 = [[decoder decodeObjectForKey:_kKeyMd5] retain];
	return self;
}

- (UInt32)QQ {
	return m_QQ;
}

- (UInt32)timestamp {
	return m_timestamp;
}

- (NSData*)md5 {
	return m_md5;
}

@end
