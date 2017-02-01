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

#import "NormalIMHeader.h"
#import "QQConstants.h"

#define _kKeyType @"NormalIMHeader_Type"

@implementation NormalIMHeader

- (void) dealloc {
	[m_fileSessionKey release];
	[super dealloc];
}

- (void)read:(ByteBuffer*)buf {
	m_senderVersion = [buf getUInt16];
	m_sender = [buf getUInt32];
	m_receiver = [buf getUInt32];
	m_fileSessionKey = [[NSMutableData dataWithLength:kQQKeyLength] retain];
	[buf getBytes:(NSMutableData*)m_fileSessionKey];
	m_normalIMType = [buf getUInt16];
}

#pragma mark -
#pragma mark NSCoding protocol

- (void)encodeWithCoder:(NSCoder*)encoder {
	[encoder encodeInt32:m_normalIMType forKey:_kKeyType];
}

- (id)initWithCoder:(NSCoder*)decoder {
	m_normalIMType = [decoder decodeInt32ForKey:_kKeyType];
	return self;
}

#pragma mark -
#pragma mark getter and setter

- (UInt16)senderVersion {
	return m_senderVersion;
}

- (UInt32)sender {
	return m_sender;
}

- (UInt32)receiver {
	return m_receiver;
}

- (NSData*)fileSessionKey {
	return m_fileSessionKey;
}

- (UInt16)normalIMType {
	return m_normalIMType;
}

@end
