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

/////// format 1 ////////
// header
// --- encrypt start (password key, if failed, random key in request packet) ---
// length of reply data, 2 bytes, exclusive
// reply code, 1 byte, 0x00 means ok
// the random 4 bytes in password verify data
// length of unknown token, 2 bytes
// unknown token
// length of unknown token 2, 2 bytes
// unknown token 2
// length of passport, 2 bytes
// passport
// encrypt key of login packet, 16 bytes
// unknown 4 bytes
// NOTE: reply data end here, following data is not counted in reply data length
// unknown 2 bytes
// --- encrypt end ---
// tail

/////// format 2 ////////
// header
// --- encrypt start (password key, if failed, random key in request packet) ---
// length of reply data, 2 bytes, exclusive
// reply code, 1 byte, 0x34, kQQReplyPasswordError
// the random 4 bytes in password verify data
// length of unknown token, 2 bytes, always 0x0000
// unknown token
// length of unknown token 2, 2 bytes, always 0x0000
// unknown token 2
// length of error message, 2 bytes
// error message
// NOTE: reply data end here, following data is not counted in reply data length
// unknown 2 bytes
// --- encrypt end ---
// tail

@interface PasswordVerifyReplyPacket : BasicInPacket {
	NSData* m_passport;
	NSData* m_loginKey;
	NSData* m_unknownToken1;
	NSData* m_unknownToken2;
	NSString* m_errorMessage;
}

// getter and setter
- (NSData*)passport;
- (NSData*)loginKey;
- (NSString*)errorMessage;

@end
