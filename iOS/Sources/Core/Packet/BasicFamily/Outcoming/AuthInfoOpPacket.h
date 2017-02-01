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

///////// format 1 //////////
// header
// ---- encrypt start (session key) -----
// sub command, 1 byte, 0x01, means get auth info
// sub sub command, 2 bytes
// user qq number you wanna get auth info or cluster external id you wanna join, 4 bytes, when you want to modify user info, all zero
// ---- encrypt end ----
// tail

///////// format 1 //////////
// header
// ---- encrypt start (session key) -----
// sub command, 1 byte, 0x02, means get auth info by verify code
// sub sub command, 2 bytes
// user qq you wanna add as friend or cluster external id you wanna join, 4 bytes
// length of verify code, 2 bytes
// verify code
// cookie length, 2 bytes. The cookie is retrieved from a url returned by reply packet
// cookie
// ----- encrypt end -----
// tail

@interface AuthInfoOpPacket : BasicOutPacket {
	UInt16 m_subSubCommand;
	UInt32 m_QQ;
	NSData* m_authInfo;
	NSString* m_cookie;
	NSString* m_verifyCode;
}

// getter and setter
- (UInt16)subSubCommand;
- (void)setSubSubCommand:(UInt16)subSubCommand;
- (UInt32)QQ;
- (void)setQQ:(UInt32)QQ;
- (UInt32)externalId;
- (void)setExternalId:(UInt32)externalId;
- (NSData*)authInfo;
- (void)setAuthInfo:(NSData*)authInfo;
- (NSString*)cookie;
- (void)setCookie:(NSString*)cookie;
- (NSString*)verifyCode;
- (void)setVerifyCode:(NSString*)verifyCode;

@end
