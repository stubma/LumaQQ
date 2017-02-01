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

////// format 1 ////////
// header
// length of passport, 2 bytes
// passport
// --- encrypt start (encrypt key in PasswordVerifyReply) ---
// unknown 2 bytes, 0x0000
// length of password challenge data, 2 bytes
// password challenge data
// the result of using password key to encrypt an empty string, 16 bytes
// Second, 1 byte, always 0x0
// IP of LAN, 4 bytes, always 0x0
// Port of LAN, 2 bytes, always 0x0
// build version, 4 bytes, always 0x0
// OEM code, 4 bytes, always 0x0
// language code, 4 bytes, always 0x0
// md5 of QQ.exe, 16 bytes
// local oicq index, 1 byte
// login status, 1 byte
// service provider number, 2 bytes, always 0x0
// keyboard code, 4 bytes, always 0x1
// login flag, 4 bytes, if has camera, 0x1, otherwise, 0x0
// the content of last 0x0091 request packet, usually it is 15 bytes
// local computer GUID, 16 bytes
// length of login token, 1 bytes
// login token
// length of buf bill, 2 bytes, but it always 0x0
// length of a reserved area for connection, 2 bytes, always 0x06
// reserved area for connection, always 0x0
// length of second reserved area, 2 bytes, always 0x140
// --- second reserved area start ---
// --- login report data start ---
// fixed byte, 1 byte, 0x1
// crc32 of computer id, 4 bytes, big endian
// fixed bytes, 2 bytes, 0x0010
// computer id, 16 bytes
// NOTE: how to generate computer id
//		1. build a byte array whose size is 28 bytes
//		2. first 6 bytes is MAC address
//		3. 7 - 8 bytes are zero
//		4. remaining 20 bytes is hard disk serial number
//		5. computer id is MD5 of the 28 bytes
// --- login report data end ---
// service provider number, 2 bytes, always 0x0
// keyboard code, 4 bytes, always 0x1
// login flag, 4 bytes, if has camera, 0x1, otherwise, 0x0
// the content of last 0x0091 request packet, usually it is 15 bytes
// --- login report data 2 start ---
// fixed byte, 1 byte, 0x2
// crc32 of guidEx, 4 bytes, big endian
// fixed bytes, 2 bytes, 0x0010
// guidEx, 16 bytes
// NOTE: how to generate guidEx: it is MD5 of first 8 bytes in 28 bytes array of login report data
// --- login report data 2 end ---
// all zero till to body end, should be 0x140 - 0x47 = 0xF9 = 249 bytes
// --- second reserved area end ---
// --- encrypt end ---
// tail

@interface LoginPacket : BasicOutPacket {
}

@end
