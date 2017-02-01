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

#import "AdvancedSearchedUser.h"
#import "NSString-Filter.h"

@implementation AdvancedSearchedUser

- (id)copyWithZone:(NSZone*)zone {
    AdvancedSearchedUser* newCopy = [[AdvancedSearchedUser alloc] init];
	[newCopy setQQ:[self QQ]];
	[newCopy setHead:[self head]];
	[newCopy setNick:[self nick]];
	[newCopy setProvinceIndex:[self provinceIndex]];
	[newCopy setCityIndex:[self cityIndex]];
	[newCopy setGenderIndex:[self genderIndex]];
	[newCopy setAge:[self age]];
	[newCopy setOnline:[self online]];
    return newCopy;
}

- (void)read:(ByteBuffer*)buf {
	m_QQ = [buf getUInt32];
	m_genderIndex = [buf getByte];
	m_age = [buf getUInt16];
	m_online = [buf getByte] == 0x01;
	
	int len = [buf getByte] & 0xFF;
	m_nick = [[[buf getString:len] normalize] retain];
	
	m_provinceIndex = [buf getUInt16];
	m_cityIndex = [buf getUInt16];
	m_head = [buf getUInt16];
	[buf skip:1];
}

- (void) dealloc {
	[m_nick release];
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

- (void)setQQ:(UInt32)QQ {
	m_QQ = QQ;
}

- (void)setGenderIndex:(UInt8)genderIndex {
	m_genderIndex = genderIndex;
}

- (void)setAge:(UInt16)age {
	m_age = age;
}

- (void)setOnline:(BOOL)online {
	m_online = online;
}

- (void)setNick:(NSString*)nick {
	[nick retain];
	[m_nick release];
	m_nick = nick;
}

- (void)setProvinceIndex:(UInt16)provinceIndex {
	m_provinceIndex = provinceIndex;
}

- (void)setCityIndex:(UInt16)cityIndex {
	m_cityIndex = cityIndex;
}

- (void)setHead:(UInt16)head {
	m_head = head;
}

- (UInt32)QQ {
	return m_QQ;
}

- (UInt8)genderIndex {
	return m_genderIndex;
}

- (UInt16)age {
	return m_age;
}

- (BOOL)online {
	return m_online;
}

- (NSString*)nick {
	return m_nick;
}

- (UInt16)provinceIndex {
	return m_provinceIndex;
}

- (UInt16)cityIndex {
	return m_cityIndex;
}

- (UInt16)head {
	return m_head;
}

@end
