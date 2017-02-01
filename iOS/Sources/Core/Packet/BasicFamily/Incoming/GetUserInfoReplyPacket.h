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
#import "ContactInfo.h"

//////////// format 1 ////////////
// header
// ------ encrypt start (session key) ---------
// ----- ContactInfo start ------
// (NOTE) all field is string format
// qq number
// separator, 1 byte, 0x1E
// nick
// separator, 1 byte, 0x1E
// country
// separator, 1 byte, 0x1E
// province
// separator, 1 byte, 0x1E
// zipcode
// separator, 1 byte, 0x1E
// address
// separator, 1 byte, 0x1E
// telephone
// separator, 1 byte, 0x1E
// age
// separator, 1 byte, 0x1E
// gender
// separator, 1 byte, 0x1E
// name
// separator, 1 byte, 0x1E
// email
// separator, 1 byte, 0x1E
// pager sn (i don't known what it is)
// separator, 1 byte, 0x1E
// pager
// separator, 1 byte, 0x1E
// pager service provider
// separator, 1 byte, 0x1E
// pager base num (totally nonsense)
// separator, 1 byte, 0x1E
// page type
// separator, 1 byte, 0x1E
// occupation
// separator, 1 byte, 0x1E
// hompage
// separator, 1 byte, 0x1E
// authorization type
// separator, 1 byte, 0x1E
// unknown 1
// separator, 1 byte, 0x1E
// unknown 2
// separator, 1 byte, 0x1E
// head image index
// separator, 1 byte, 0x1E
// mobile
// separator, 1 byte, 0x1E
// mobile type
// separator, 1 byte, 0x1E
// introduction
// separator, 1 byte, 0x1E
// city
// separator, 1 byte, 0x1E
// unknown 3
// separator, 1 byte, 0x1E
// unknown 4
// separator, 1 byte, 0x1E
// unknown 5
// separator, 1 byte, 0x1E
// unknown 6
// separator, 1 byte, 0x1E
// flag indicates contact visibility for other persons
// separator, 1 byte, 0x1E
// college
// separator, 1 byte, 0x1E
// horoscope index
// separator, 1 byte, 0x1E
// zodiac index
// separator, 1 byte, 0x1E
// blood type index
// separator, 1 byte, 0x1E
// user flag
// separator, 1 byte, 0x1E
// unknown 7
// ----- ContactInfo end -------
// ----- encrypt end -------
// tail

@interface GetUserInfoReplyPacket : BasicInPacket {
	ContactInfo* m_contact;
}

// getter and setter
- (ContactInfo*)contact;

@end
