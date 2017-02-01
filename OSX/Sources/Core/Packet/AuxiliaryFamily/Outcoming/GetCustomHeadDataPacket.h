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

#import <Cocoa/Cocoa.h>
#import "AuxiliaryOutPacket.h"

////// foramt 1 /////////
// header
// unknown 8 bytes
// length of following data, 2 bytes, exclusive
// friend qq number, 4 bytes
// unknown 1 byte, most of time it is 0x01
// timestamp of custom head, 4 bytes
// start offset from where to get head, 4 bytes
// NOTE: 0xFFFFFFFF means from the very begining
// how many bytes your want, 4 bytes
// NOTE: 0x00000000 means get all

@interface GetCustomHeadDataPacket : AuxiliaryOutPacket {
	UInt32 m_QQ;
	UInt32 m_timestamp;
	UInt32 m_offset;
	UInt32 m_length;
}

- (void)setQQ:(UInt32)QQ;
- (void)setTimestamp:(UInt32)timestamp;
- (void)setOffset:(UInt32)offset;
- (void)setLength:(UInt32)length;

@end
