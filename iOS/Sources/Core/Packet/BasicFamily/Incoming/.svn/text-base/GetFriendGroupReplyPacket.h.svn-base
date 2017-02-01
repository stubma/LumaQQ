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
#import "BasicInPacket.h"

///////// format 1 ///////////
// header
// ----- encrypt start (session key) --------
// sub command, 1 byte
// reply code, 1 byte
// unknown 4 bytes
// next start position, 4 bytes, 0 means no more
// a. friend qq or cluster internal id, 4 bytes
// b. friend type, means friend or cluster
// c. group index, but the real index is the value divide 4! for example, 0 for group 0, 4 for group 1
// (NOTE) repeat (a)(b)(c) if has more friends
// ------ encrypt end --------
// tail

@interface GetFriendGroupReplyPacket : BasicInPacket {
	UInt32 m_nextStartPosition;
	NSMutableArray* m_friendGroups;
}

// getter and setter
- (UInt32)nextStartPosition;
- (NSArray*)friendGroups;
- (BOOL)finished;

@end
