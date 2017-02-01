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
#import "ContactInfo.h"

///////// format 1 //////////
// header
// ----- encrypt start (session key) ------
// length of auth info, 1 byte
// auth info
// old password
// separator, 1 byte, 0x1F
// new password
// separator, 1 byte, 0x1F
// (NOTE) in 2006, tencent forbids modifying password thru this packet, so left them blank
// nick
// separator, 1 byte, 0x1F
// country
// separator, 1 byte, 0x1F
// province
// separator, 1 byte, 0x1F
// zipcode
// separator, 1 byte, 0x1F
// address
// separator, 1 byte, 0x1F
// telephone
// separator, 1 byte, 0x1F
// age
// separator, 1 byte, 0x1F
// gender
// separator, 1 byte, 0x1F
// name
// separator, 1 byte, 0x1F
// email
// separator, 1 byte, 0x1F
// pager sn (i don't known what it is)
// separator, 1 byte, 0x1F
// pager
// separator, 1 byte, 0x1F
// pager service provider
// separator, 1 byte, 0x1F
// pager base num (totally nonsense)
// separator, 1 byte, 0x1F
// page type
// separator, 1 byte, 0x1F
// occupation
// separator, 1 byte, 0x1F
// hompage
// separator, 1 byte, 0x1F
// authorization type
// separator, 1 byte, 0x1F
// unknown 1
// separator, 1 byte, 0x1F
// unknown 2
// separator, 1 byte, 0x1F
// head image index
// separator, 1 byte, 0x1F
// mobile
// separator, 1 byte, 0x1F
// mobile type
// separator, 1 byte, 0x1F
// introduction
// separator, 1 byte, 0x1F
// city
// separator, 1 byte, 0x1F
// unknown 3
// separator, 1 byte, 0x1F
// unknown 4
// separator, 1 byte, 0x1F
// unknown 5
// separator, 1 byte, 0x1F
// unknown 6
// separator, 1 byte, 0x1F
// flag indicates contact visibility for other persons
// separator, 1 byte, 0x1F
// college
// separator, 1 byte, 0x1F
// horoscope index
// separator, 1 byte, 0x1F
// zodiac index
// separator, 1 byte, 0x1F
// blood type index
// separator, 1 byte, 0x1F
// user flag
// separator, 1 byte, 0x1F
// unknown 7
// separator, 1 byte, 0x1F
// ---- encrypt end -----
// tail

// NOTE: the field is similar as ContactInfo, but it doesn't have QQ number after new password

@interface ModifyInfoPacket : BasicOutPacket {
	NSData* m_authInfo;
	ContactInfo* m_contact;
}

// getter and setter
- (ContactInfo*)contact;
- (void)setContact:(ContactInfo*)contact;
- (NSData*)authInfo;
- (void)setAuthInfo:(NSData*)authInfo;

@end
