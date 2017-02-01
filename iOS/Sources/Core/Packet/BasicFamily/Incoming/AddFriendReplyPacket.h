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

///////// format 1 /////////
// header
// ------ encrypt start (session key) ------
// user qq number you wanna add, 4 bytes
// reply code, 1 byte
// (NOTE) if reply is not kQQReplyOK, body ends here
// user auth type, 1 byte
// ----- encrypt end ------
// tail

@interface AddFriendReplyPacket : BasicInPacket {
	UInt32 m_QQ;
	char m_authType;
}

// getter and setter
- (UInt32)QQ;
- (char)authType;

@end
