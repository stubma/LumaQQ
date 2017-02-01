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

///////// format 1 //////////
// header
// ---- encrypt start (session key) ------
// sub command, 1 byte, 0x01, means search normal user
// page number, 2 bytes, start from 0
// online, 1 byte, 0x00 means no, 0x01 means not
// has camera, 1 byte, 0x00 means no, 0x01 means not
// age index in combobox, 1 byte
// gender index in combobox, 1 byte
// province index in combobox, 2 bytes
// city index in combobox, 2 bytes
// ----- encrypt end -----
// tail

@interface AdvancedSearchUserPacket : BasicOutPacket {
	UInt16 m_page;
	BOOL m_online;
	BOOL m_hasCam;
	UInt8 m_ageIndex;
	UInt8 m_genderIndex;
	UInt16 m_provinceIndex;
	UInt16 m_cityIndex;
}

// getter and setter
- (UInt16)page;
- (void)setPage:(UInt16)page;
- (BOOL)online;
- (void)setOnline:(BOOL)online;
- (BOOL)hasCam;
- (void)setHasCam:(BOOL)hasCam;
- (UInt8)ageIndex;
- (void)setAgeIndex:(UInt8)ageIndex;
- (UInt8)genderIndex;
- (void)setGenderIndex:(UInt8)genderIndex;
- (UInt16)provinceIndex;
- (void)setProvinceIndex:(UInt16)provinceIndex;
- (UInt16)cityIndex;
- (void)setCityIndex:(UInt16)cityIndex;

@end
