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
#import "BasicOutPacket.h"

///////// format 1 //////////
// header
// ----- encrypt start (session key) -------
// start position, 2 bytes. This start position is a index of your sorted friend qq number, start from zero
// sort return friend qq number list, 1 byte, nonzero means sort
// unknown 2 bytes
// ----- encrypt end -------
// tail

@interface GetFriendListPacket : BasicOutPacket {
	UInt16 m_startPosition;
	BOOL m_sort;
}

// getter and setter
- (UInt16)startPosition;
- (void)setStartPosition:(UInt16)startPosition;
- (BOOL)sort;
- (void)setSort:(BOOL)sort;

@end
