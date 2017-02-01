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
#import "FriendRemark.h"

////////// format 0x00 ///////////
// header
// ------ encrypt start (session key) -----
// sub command, 1 byte, 0x00, means batch get remarks
// page number, 1 byte, start from 1, if zero, means not used
// ------- encrypt end -----
// tail

////////// format 0x01 /////////
// header
// ----- encrypt start (session key) -------
// sub command, 1 byte, 0x01, means upload remark
// page number, 1 byte, not used
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
// ------ encrypt end ------
// tail

///////////// format 0x02 //////////////
// header
// ------ encrypt start (session key) --------
// sub command, 1 byte, 0x02, means remove friend from server list
// friend qq number, 4 bytes
// ------ encrypt end ------
// tail

////////// format 0x03 //////////
// header
// ------ encrypt start (session key) --------
// sub command, 1 byte, 0x03, means get friend remark
// friend qq number, 4 bytes
// ------ encrypt end ------
// tail

////////// format 0x05 /////////////
// --- encrypt start (session key) ---
// sub command, 1 byte, 0x05, means modify remark name
// friend qq number, 4 bytes
// length of remark name, 1 byte
// remark name
// --- encrypt end ---
// tail

@interface FriendDataOpPacket : BasicOutPacket {
	char m_page;
	
	// for 0x01
	FriendRemark* m_remark;
	
	// for 0x02, 0x03
	UInt32 m_QQ;
	
	// for 0x05
	NSString* m_name;
}

// getter and setter
- (char)page;
- (void)setPage:(char)page;
- (FriendRemark*)remark;
- (void)setRemark:(FriendRemark*)remark;
- (UInt32)QQ;
- (void)setQQ:(UInt32)QQ;
- (NSString*)name;
- (void)setName:(NSString*)name;

@end
