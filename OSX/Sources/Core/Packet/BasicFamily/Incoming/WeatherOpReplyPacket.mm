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

#import "WeatherOpReplyPacket.h"
#import "Weather.h"
#import "NSString-Validate.h"

@implementation WeatherOpReplyPacket

- (void)parseBody:(ByteBuffer*)buf {
	m_weathers = [[NSMutableArray array] retain];
	
	m_subCommand = [buf getByte];
	m_reply = [buf getByte];
	
	int len = [buf getByte] & 0xFF;
	if(len > 0) {
		m_province = [[buf getString:len] retain];
		
		len = [buf getByte] & 0xFF;
		m_city = [[buf getString:len] retain];
		[buf skip:2];
		
		if([m_city isEmpty]) {
			[m_city release];
			len = [buf getByte] & 0xFF;
			m_city = [[buf getString:len] retain];
		} else {
			len = [buf getByte] & 0xFF;
			[buf skip:len];
		}
		
		m_days = [buf getByte] & 0xFF;
		
		for(int i = 0; i < m_days; i++) {
			Weather* weather = [[Weather alloc] init];
			[weather read:buf];
			[m_weathers addObject:weather];
			[weather release];
		}
		
		[buf skip:2];
	} else {
		m_province = @"";
		m_city = @"";
	}
}

- (void) dealloc {
	[m_weathers release];
	[m_province release];
	[m_city release];
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

- (int)days {
	return m_days;
}

- (NSString*)province {
	return m_province;
}

- (NSString*)city {
	return m_city;
}

- (NSArray*)weathers {
	return m_weathers;
}

@end
