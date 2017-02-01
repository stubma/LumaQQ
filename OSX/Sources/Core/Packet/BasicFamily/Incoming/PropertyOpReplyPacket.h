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

/////////// format 1 ///////////
// header
// ------ encrypt start (session key) -------
// sub command, 1 byte, 0x01, means get user property
// next start position, 2 bytes
// length of extended user flag, 1 byte
// ------ UserProperty start ----------
// friend qq, 4 bytes
// user flag ex, length is specified above.
// NOTE: The extended user flag can grow continuously so we can't use mask to check it. We use bit number, start
// 		from 1. Take bit number 0xC for instance, first do a division: 0xC / 0x8 and we get result 1 and remainder
// 		is 4, so we get second byte and right shift 4 bit, then check the lowest bit is 1 or not.
// ------- UserProperty end ----------
// ------ encrypt end -------
// tail

@interface PropertyOpReplyPacket : BasicInPacket {
	UInt16 m_nextStartPosition;
	NSMutableArray* m_properties;
}

- (BOOL)finished;

// getter and setter
- (UInt16)nextStartPosition;
- (NSArray*)properties;

@end
