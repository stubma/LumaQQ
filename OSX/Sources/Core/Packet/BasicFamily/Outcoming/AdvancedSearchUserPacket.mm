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

#import "AdvancedSearchUserPacket.h"


@implementation AdvancedSearchUserPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandAdvancedSearch;
		m_subCommand = kQQSubCommandSearchNormalUser;
		m_page = 0;
		m_online = YES;
		m_hasCam = NO;
		m_ageIndex = 0;
		m_genderIndex = 0;
		m_provinceIndex = 0;
		m_cityIndex = 0;
	}
	return self;
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeByte:m_subCommand];
	[buf writeUInt16:m_page];
	[buf writeByte:(m_online ? 0x01 : 0x00)];
	[buf writeByte:(m_hasCam ? 0x01 : 0x00)];
	[buf writeByte:m_ageIndex];
	[buf writeByte:m_genderIndex];
	[buf writeUInt16:m_provinceIndex];
	[buf writeUInt16:m_cityIndex];
}

#pragma mark -
#pragma mark getter and setter

- (UInt16)page {
	return m_page;
}

- (void)setPage:(UInt16)page {
	m_page = page;
}

- (BOOL)online {
	return m_online;
}

- (void)setOnline:(BOOL)online; {
	m_online = online;
}
- (BOOL)hasCam {
	return m_hasCam;
}

- (void)setHasCam:(BOOL)hasCam {
	m_hasCam = hasCam;
}

- (UInt8)ageIndex {
	return m_ageIndex;
}

- (void)setAgeIndex:(UInt8)ageIndex {
	m_ageIndex = ageIndex;
}

- (UInt8)genderIndex {
	return m_genderIndex;
}

- (void)setGenderIndex:(UInt8)genderIndex {
	m_genderIndex = genderIndex;
}

- (UInt16)provinceIndex {
	return m_provinceIndex;
}

- (void)setProvinceIndex:(UInt16)provinceIndex {
	m_provinceIndex = provinceIndex;
}

- (UInt16)cityIndex {
	return m_cityIndex;
}

- (void)setCityIndex:(UInt16)cityIndex {
	m_cityIndex = cityIndex;
}

@end
