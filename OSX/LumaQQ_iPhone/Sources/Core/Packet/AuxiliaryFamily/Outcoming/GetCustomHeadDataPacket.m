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

#import "GetCustomHeadDataPacket.h"


@implementation GetCustomHeadDataPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandGetCustomHeadData;
		m_offset = 0xFFFFFFFF;
		m_length = 0;
		m_timestamp = 0;
	}
	return self;
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeUInt32:0];
	[buf writeUInt32:0];
	
	int pos = [buf position];
	[buf skip:2];
	
	[buf writeUInt32:m_QQ];
	[buf writeByte:0x01];
	[buf writeUInt32:m_timestamp];
	[buf writeUInt32:m_offset];
	[buf writeUInt32:m_length];
	
	[buf writeUInt16:([buf position] - pos - 2) position:pos];
}

- (void)setQQ:(UInt32)QQ {
	m_QQ = QQ;
}

- (void)setTimestamp:(UInt32)timestamp {
	m_timestamp = timestamp;
}

- (void)setOffset:(UInt32)offset {
	m_offset = offset;
}

- (void)setLength:(UInt32)length {
	m_length = length;
}

@end
