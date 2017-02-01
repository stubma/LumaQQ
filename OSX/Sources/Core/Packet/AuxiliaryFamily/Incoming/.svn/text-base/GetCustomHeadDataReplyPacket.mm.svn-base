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

#import "GetCustomHeadDataReplyPacket.h"


@implementation GetCustomHeadDataReplyPacket

- (void)parseBody:(ByteBuffer*)buf {
	if(m_version == kQQVersionCurrent)
		return;
	
	[buf skip:11];
	
	m_QQ = [buf getUInt32];
	m_timestamp = [buf getUInt32];
	m_fileSize = [buf getUInt32];
	m_offset = [buf getUInt32];
	m_data = [[NSMutableData dataWithLength:[buf getUInt32]] retain];
	[buf getBytes:(NSMutableData*)m_data];
}

- (void) dealloc {
	[m_data release];
	[super dealloc];
}

- (UInt32)QQ {
	return m_QQ;
}

- (UInt32)timestamp {
	return m_timestamp;
}

- (UInt32)fileSize {
	return m_fileSize;
}

- (UInt32)offset {
	return m_offset;
}

- (NSData*)data {
	return m_data;
}

@end
