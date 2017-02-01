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

////// format 1 ///////
// header
// random key
// --- encrypt start (random key) ---
// length of verify data, 2 bytes, exclusive
// language code, 4 bytes
// time zone offset, 2 bytes, evaluated by minutes, for example, China is GMT+8, so this value is 8*60 = 480 = 0x01E0. However, QQ fills it with 0x010E? Maybe a typo
// length of login token, 1 byte
// login token
// length of password challenge data, 2 bytes
// password challenge data, it is encrypted by password key, the plain content is [password MD5] + [4 random bytes]
// length of evil data, 2 bytes, mostly it is 0x0014
// evil data, see _generateEvilData to know how to generate it
// NOTE: verify data ends here, following data is not counted in length
// length of padding data, 2 bytes, exclusive. usually there is 97 bytes before padding (exclude random key and header), so it is 0x0003 
// padding any bytes until body length is 100 bytes, usually there will be 97 bytes before padding, so 3 bytes to be padded
// --- encrypt end ---
// tail

@interface PasswordVerifyPacket : BasicOutPacket {
	NSMutableData* _passwordChallenge;
}

// internal
- (void)_generateEvilData:(ByteBuffer*)buf;
- (NSData*)_mixLoginTokenMD5:(const UInt8*)loginTokenMD5 randomKeyMD5:(const UInt8*)randomKeyMD5;

@end
