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

#import <Foundation/Foundation.h>
#import "BasicOutPacket.h"

////////// format 1 ///////////
// header
// random key, 16 bytes
// --- encrypt start (random key) ---
// request times, 2 bytes, start from 0
// unknown 1 byte
// unknown 4 bytes
// unknown 4 bytes
// previous server ip, 4 bytes, if it's the first time, all zero
// --- encrypt end ---
// tail

@interface SelectServerPacket : BasicOutPacket {
	UInt16 m_times;
	char m_unknown1;
	UInt32 m_unknown2;
	UInt32 m_unknown3;
	char m_previousServerIp[4];
}

// getter and setter
- (UInt16)times;
- (void)setTimes:(UInt16)times;
- (char)unknown1;
- (void)setUnknown1:(char)unknown1;
- (UInt32)unknown2;
- (void)setUnknown2:(UInt32)unknown2;
- (UInt32)unknown3;
- (void)setUnknown3:(UInt32)unknown3;
- (char*)previousServerIp;
- (void)setPreviousServerIp:(const char*)ip;

@end
