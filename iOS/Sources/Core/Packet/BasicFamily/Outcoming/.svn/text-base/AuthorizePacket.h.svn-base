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

/////// format 0x02 ///////
// header
// ----- encrypt start (session key) ------
// sub command, 1 byte, 0x02, means normal authorization
// user qq you wanna add, 4 bytes
// unknown 2 bytes
// length of auth info, 2 bytes
// auth info
// flag indicates whether allow user add me as friend, 1 byte, 0x00 means no, 0x01 means yes
// the dest group you wanna add user to, 1 byte, start from 0 (my friends group)
// length of attached message, 1 byte
// attached message
// ------ encrypt end -----
// tail

//////// format 0x03 /////////
// header
// ----- encrypt start (session key) ------
// sub command, 1 byte, 0x03, means approve authorization and add him too
// user qq you wanna reply, 4 bytes
// unknown 2 bytes
// length of message, 1 byte
// message
// --- encrypt end ---
// tail

//////// format 0x04 /////////
// header
// ----- encrypt start (session key) ------
// sub command, 1 byte, 0x04, means approve authorization
// user qq you wanna reply, 4 bytes
// unknown 2 bytes
// ---- encrypt end -----
// tail

//////// format 0x05 /////////
// header
// ----- encrypt start (session key) ------
// sub command, 1 byte, 0x05, means reject authorization
// user qq you wanna reply, 4 bytes
// unknown 2 bytes
// length of reject message, 1 byte
// reject message
// ---- encrypt end -----
// tail

//////// format 0x10 /////////
// header
// ----- encrypt start (session key) ------
// sub command, 1 byte, 0x10, means double authorization
// user qq you wanna add, 4 bytes
// unknown 2 bytes
// length of auth info, 2 bytes
// auth info
// length of question auth info, 2 bytes
// question auth info
// flag indicates whether allow user add me as friend, 1 byte, 0x00 means no, 0x01 means yes
// the dest group you wanna add user to, 1 byte, start from 0 (my friends group)
// ----- encrypt end -----
// tail

@interface AuthorizePacket : BasicOutPacket {
	UInt32 m_QQ;
	NSData* m_authInfo;
	BOOL m_allowAddMe;
	int m_destGroup;
	NSString* m_message;
	NSData* m_questionAuthInfo;
}

// getter and setter
- (UInt32)QQ;
- (void)setQQ:(UInt32)QQ;
- (NSData*)authInfo;
- (void)setAuthInfo:(NSData*)authInfo;
- (BOOL)allowAddMe;
- (void)setAllowAddMe:(BOOL)allowAddMe;
- (int)destGroup;
- (void)setDestGroup:(int)destGroup;
- (NSString*)message;
- (void)setMessage:(NSString*)message;
- (NSData*)questionAuthInfo;
- (void)setQuestionAuthInfo:(NSData*)questionAuthInfo;

@end
