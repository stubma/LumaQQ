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

/////////// format 1 ////////////
// header
// --------- encrypt start (session key) ---------
// reply code, 1 byte
// ------ FriendStatus start --------
// friend qq, 4 bytes
// unknown 1 byte
// friend ip, 4 bytes
// friend port, 2 bytes
// unknown 1 byte
// friend status, 1 byte
// unknown 2 bytes
// unknown key
// user flag, 4 bytes
// unknown 2 bytes
// unknown 1 byte
// unknown 4 bytes
// ------ FriendStatus end --------
// (NOTE) repeat FriendStatus if has more friends
// ------- encrypt end ---------
// tail

@interface GetOnlineOpReplyPacket : BasicInPacket {
	NSArray* m_friends;
}

// helper
- (BOOL)finished;

// getter and setter
- (NSArray*)friends;
- (void)setFriends:(NSArray*)friends;

@end
