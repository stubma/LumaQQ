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
#import "ByteBuffer.h"

@interface AdvancedSearchedUser : NSObject <NSCopying> {
	UInt32 m_QQ;
	UInt8 m_genderIndex;
	UInt16 m_age;
	BOOL m_online;
	NSString* m_nick;
	UInt16 m_provinceIndex;
	UInt16 m_cityIndex;
	UInt16 m_head;
}

- (void)read:(ByteBuffer*)buf;

// getter and setter
- (UInt32)QQ;
- (UInt8)genderIndex;
- (UInt16)age;
- (BOOL)online;
- (NSString*)nick;
- (UInt16)provinceIndex;
- (UInt16)cityIndex;
- (UInt16)head;
- (void)setQQ:(UInt32)QQ;
- (void)setGenderIndex:(UInt8)genderIndex;
- (void)setAge:(UInt16)age;
- (void)setOnline:(BOOL)online;
- (void)setNick:(NSString*)nick;
- (void)setProvinceIndex:(UInt16)provinceIndex;
- (void)setCityIndex:(UInt16)cityIndex;
- (void)setHead:(UInt16)head;

@end
