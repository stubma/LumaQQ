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

/////////////////// format 1 //////////////////
// header
// random key
// ------- encrypt start (random key) --------
// sub command, 1 byte, 0x01, kQQSubCommandGetLoginToken
// unknown 2 bytes, 0x0005
// unknown 4 bytes, 0x0000 0x0000
// ------- encrypt end ----------
// tail

////////////////// format 2 //////////////////
// header
// random key
// ------- encrypt start (random key) --------
// sub command, 1 byte, 0x02, kQQSubCommandSubmitVerifyCode
// unknown 2 bytes, 0x0005
// unknown 4 bytes, 0x0000 0x0000
// length of verify code, 2 bytes
// verify code, if you want refresh verify code, fill any value (QQ use "2006")
// length of verify code image token, 2 bytes
// verify code image token
// ------- encrypt end ----------
// tail

//////// format 3 ////////
// header
// random key
// ------- encrypt start (random key) --------
// length of server token, 1 byte
// server token
// sub command, 1 byte, 0x03, kQQSubCommandGetLoginTokenEx
// unknown 2 bytes, 0x0005
// unknown 4 bytes, 0x0000 0x0000
// image fragment index, 1 byte
// length of image fragment token, 2 bytes
// image fragment token
// ------- encrypt end ----------
// tail

////////////////// format 4 //////////////////
// header
// random key
// ------- encrypt start (random key) --------
// length of server token, 1 byte
// server token
// sub command, 1 byte, 0x04, kQQSubCommandSubmitVerifyCodeEx
// unknown 2 bytes, 0x0005
// unknown 4 bytes, 0x0000 0x0000
// length of verify code, 2 bytes
// verify code, if you want refresh verify code, fill any value (QQ use "2006")
// length of verify code image token, 2 bytes
// verify code image token
// ------- encrypt end ----------
// tail

@interface GetLoginTokenPacket : BasicOutPacket {
	NSData* m_puzzleToken;
	NSString* m_verifyCode;
	int m_fragmentIndex;
}

// getter and setter
- (NSString*)verifyCode;
- (void)setVerifyCode:(NSString*)code;
- (void)setPuzzleToken:(NSData*)token;
- (int)fragmentIndex;
- (void)setFragmentIndex:(int)index;

@end
