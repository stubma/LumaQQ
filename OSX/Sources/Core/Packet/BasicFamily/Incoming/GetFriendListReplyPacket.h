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

///////// format 1 ///////////
// header
// ----- encrypt start (session key) ---------
// next start position, 2 bytes
// ----- Friend start -----
// friend qq, 4 bytes
// head, 2 bytes
// age, 1 bytes
// gender, 1 bytes
// nick length, 1 bytes
// nick
// user flag, 4 bytes
//		bit 1 => member
// 		bit 5 => mobile QQ
//		bit 6 => mobile bind
//		bit 7 => has camera
//		bit 18 => TM
// unknown 4 bytes
// ----- Friend end ------
// (NOTE) repeat Friend if has more
// ----- encrypt end -------
// tail

@interface GetFriendListReplyPacket : BasicInPacket {
	UInt16 m_nextStartPosition;
	NSMutableArray* m_friends;
}

// helper
- (BOOL)finished;

// getter and setter
- (UInt16)nextStartPosition;
- (NSArray*)friends;

@end
