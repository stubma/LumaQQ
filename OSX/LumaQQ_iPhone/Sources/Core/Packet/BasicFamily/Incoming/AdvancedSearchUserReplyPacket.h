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

////////// format 1 //////////
// header
// ---- encrypt start (session key) --------
// sub command, 1 byte, 0x01, means search normal user
// reply code, 1 byte, 0x01 means no more result and the body ends here
// next page number, 2 bytes
// ------- AdvancedSearchedUser start -----
// qq number, 4 bytes
// gender index, 1 byte
// age, 2 bytes
// online, 1 byte, 0x01 means yes, 0x00 means no
// length of nick, 1 byte
// nick
// province index, 2 bytes
// city index, 2 bytes
// head, 2 bytes
// unknown 1 byte
// ----- AdvancedSearchUser end -------
// ---- encrypt end -----
// tail

@interface AdvancedSearchUserReplyPacket : BasicInPacket {
	UInt16 m_nextPage;
	NSMutableArray* m_searchedUsers;
}

// getter and setter
- (UInt16)nextPage;
- (NSArray*)searchedUsers;

@end
