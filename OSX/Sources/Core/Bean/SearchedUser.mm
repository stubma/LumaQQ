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

#import "SearchedUser.h"
#import "NSString-Filter.h"

@implementation SearchedUser

- (id)copyWithZone:(NSZone*)zone {
    SearchedUser* newCopy = [[SearchedUser alloc] init];
	[newCopy setQQ:[self QQ]];
	[newCopy setHead:[self head]];
	[newCopy setNick:[self nick]];
	[newCopy setProvince:[self province]];
    return newCopy;
}

- (void)read:(ByteBuffer*)buf {
	NSString* qqStr = [buf getStringUntil:0x1E];
	m_QQ = [qqStr intValue];
	
	m_nick = [[[buf getStringUntil:0x1E] normalize] retain];
	m_province = [[buf getStringUntil:0x1E] retain];
	
	NSString* headStr = [buf getStringUntil:0x1E];
	m_head = [headStr intValue];
	
	[buf getStringUntil:0x1F];
}

- (void) dealloc {
	[m_nick release];
	[m_province release];
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

- (void)setQQ:(UInt32)QQ {
	m_QQ = QQ;
}

- (void)setHead:(UInt16)head {
	m_head = head;
}

- (void)setNick:(NSString*)nick {
	[nick retain];
	[m_nick release];
	m_nick = nick;
}

- (void)setProvince:(NSString*)province {
	[province retain];
	[m_province release];
	m_province = province;
}

- (UInt32)QQ {
	return m_QQ;
}

- (UInt16)head {
	return m_head;
}

- (NSString*)nick {
	return m_nick;
}

- (NSString*)province {
	return m_province;
}

@end
