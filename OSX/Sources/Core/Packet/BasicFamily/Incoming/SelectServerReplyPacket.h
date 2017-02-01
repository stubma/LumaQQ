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
#import "BasicInPacket.h"

////////// format 1 //////////
// header
// --- encrypt start (random key in request packet) ---
// next request time, 2 bytes, non-zero means need redirect
// unknown 1 byte
// unknown 4 bytes
// unknown 4 bytes
// server ip redirect to, 4 bytes
// --- encrypt end ---
// tail

/////////// format 2 /////////
// header
// --- encrypt start (random key in request packet) ---
// next request time, 2 bytes, zero means no need to redirect
// --- encrypt end ---
// tail

@interface SelectServerReplyPacket : BasicInPacket {
	UInt16 m_nextTimes;
	char m_unknown1;
	UInt32 m_unknown2;
	UInt32 m_unknown3;
	char m_redirectServerIp[4];
}

// getter and setter
- (UInt16)nextTimes;
- (char)unknown1;
- (UInt32)unknown2;
- (UInt32)unknown3;
- (char*)redirectServerIp;

@end
