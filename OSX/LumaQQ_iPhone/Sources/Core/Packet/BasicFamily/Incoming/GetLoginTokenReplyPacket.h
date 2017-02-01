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

////////////// format 1 ////////////////
// header
// -------- encrypt start (random key in request packet) ----------
// sub command, 1 byte, 0x01 or 0x03
// unknown 2 bytes, 0x0005
// reply code, 1 byte, 0x00, kQQReplyOK
// length of login token, 2 bytes
// login token
// -------- encrypt end ----------
// tail

//////////// format 2 /////////////
// header
// -------- encrypt start (random key in request packet) ----------
// sub command, 1 byte
// unknown 2 bytes, 0x0005
// reply code, 1 byte, 0x01, kQQReplyNeedVerifyCode
// length of verify code image token, 2 bytes
// verify code image token
// verify code image data length, 2 bytes
// verify code image data, PNG format
// image fragment index, 1 bytes, start from 0
// next fragment index, 1 byte
// length next image fragment token, 2 bytes
// next image fragment token
// -------- encrypt end ----------
// tail

@interface GetLoginTokenReplyPacket : BasicInPacket {
	// it could be login token or image token
	NSData* m_token;
	
	NSData* m_puzzleData;
	NSData* m_nextFragmentToken;
	int m_fragmentIndex;
	int m_nextFragmentIndex;
}

// getter and setter
- (NSData*)token;
- (void)setToken:(NSData*)token;
- (NSData*)puzzleData;
- (void)setPuzzleData:(NSData*)data;
- (NSData*)nextFragmentToken;
- (void)setNextFragmentToken:(NSData*)token;
- (int)fragmentIndex;
- (int)nextFragmentIndex;
- (BOOL)finished;

@end
