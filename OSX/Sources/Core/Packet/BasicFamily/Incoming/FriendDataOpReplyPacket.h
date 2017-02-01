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
#import "BasicInPacket.h"
#import "FriendRemark.h"

///////// format 1 /////////
// header
// ----- encrypt start (session key) ------
// sub command, 1 byte, 0x00, means batch get remarks
// reply code, 1 byte
// ------ FriendRemark start ------
// qq number, 4 bytes
// unknown 1 byte, 0x00
// length of name, 1 byte
// name
// length of mobile, 1 byte
// mobile
// length of telephone, 1 byte
// telephone
// length of address, 1 byte
// address
// length of email, 1 byte
// email
// length of zipcode, 1 byte
// zipcode
// length of note, 1 bytes
// note
// ------- FriendRemark end ------
// (NOTE) if more, repeat FriendRemark
// ----- encrypt end ------
// tail

//////////// format 2 ////////////
// header
// ----- encrypt start (session key) ------
// sub command, 1 byte, 0x01 or 0x02 or 0x05
// reply code, 1 byte
// ----- encrypt end ------
// tail

//////////// format 3 /////////////
// header
// ----- encrypt start (session key) ------
// sub command, 1 byte, 0x03
// ------ FriendRemark start (NOTE: it may not exist, means this friend doesn't has remark) ------
// qq number, 4 bytes
// unknown 1 byte, 0x00
// length of name, 1 byte
// name
// length of mobile, 1 byte
// mobile
// length of telephone, 1 byte
// telephone
// length of address, 1 byte
// address
// length of email, 1 byte
// email
// length of zipcode, 1 byte
// zipcode
// length of note, 1 bytes
// note
// ------- FriendRemark end ------
// ----- encrypt end ------
// tail

@interface FriendDataOpReplyPacket : BasicInPacket {
	// for 0x00
	NSMutableArray* m_remarks;
	
	// for 0x03
	FriendRemark* m_remark;
}

- (BOOL)finished;

// getter and setter
- (NSArray*)remarks;
- (FriendRemark*)remark;

@end
