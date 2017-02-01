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
#import "AuxiliaryInPacket.h"

///////// format 1 ////////
// header
// unknown 8 bytes
// length of following data, 2 bytes, exclusive
// unknown 1 byte
// friend qq, 4 bytes
// custom head timestamp, 4 bytes
// custom head file size, 4 bytes
// data offset, 4 bytes
// data length, 4 bytes
// data

// NOTE: remember the sender version could be client version, if so, no packet body

@interface GetCustomHeadDataReplyPacket : AuxiliaryInPacket {
	UInt32 m_QQ;
	UInt32 m_timestamp;
	UInt32 m_fileSize;
	UInt32 m_offset;
	NSData* m_data;
}

- (UInt32)QQ;
- (UInt32)timestamp;
- (UInt32)fileSize;
- (UInt32)offset;
- (NSData*)data;

@end
