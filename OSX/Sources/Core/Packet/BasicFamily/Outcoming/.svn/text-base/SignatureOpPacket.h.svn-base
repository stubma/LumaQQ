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

/////// format 1 /////////
// header
// ------ encrypt start (session key) -----
// sub command, 1 byte, 0x01, means modify signature
// length of auth info, 1 byte
// auth info
// unknown 1 byte
// length of signature, 1 byte
// signature
// ------ encrypt end -----
// tail

///////// format 2 ////////
// header
// ------ encrypt start (session key) -----
// sub command, 1 byte, 0x02, means delete signature
// length of auth info, 1 byte
// auth info
// ------ encrypt end ------
// tail

////////// format 3 //////////
// ------ encrypt start (session key) -----
// sub command, 1 byte, 0x03, means get signature
// unknown 1 byte
// the count of qq numbers which you want to get signature, 1 byte
// a. friend qq, 4 bytes
// b. signature local modified time, 4 bytes
// (NOTE) if more, repeat (a)(b), no more than 33
// ------- encrypt end ------
// tail

@interface SignatureOpPacket : BasicOutPacket {
	// for 0x01
	NSString* m_signature;
	
	// for 0x03
	// an array of Signature object
	NSMutableArray* m_friends;
	
	// auth info
	NSData* m_authInfo;
}

// getter and setter
- (NSString*)signature;
- (void)setSignature:(NSString*)signature;
- (NSArray*)friends;
- (void)addFriends:(NSArray*)friends;
- (void)addFriend:(UInt32)QQ;
- (NSData*)authInfo;
- (void)setAuthInfo:(NSData*)authInfo;

@end
