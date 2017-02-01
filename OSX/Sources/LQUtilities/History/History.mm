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

#import "History.h"
#import "FileTool.h"

#define _kKeyHistory @"History"

@implementation History

- (id)initWithMyQQ:(UInt32)QQ owner:(NSString*)owner path:(NSString*)path year:(int)year month:(int)month day:(int)day {
	self = [super init];
	if(self) {
		m_myQQ = QQ;
		m_owner = [owner retain];
		m_path = [path retain];
		m_year = year;
		m_month = month;
		m_day = day;
		
		// init directory
		[FileTool initDirectoryForFile:m_path];
		
		// load file if it's exist
		if([FileTool isFileExist:m_path]) {
			NSData* data = [NSData dataWithContentsOfFile:m_path];
			NSKeyedUnarchiver* unar = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
			m_history = [unar decodeObjectForKey:_kKeyHistory];
			[unar finishDecoding];
			[unar release];
			if(m_history == nil)
				m_history = [[NSMutableArray array] retain];
			else
				[m_history retain];
		} else
			m_history = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_path release];
	[m_owner release];
	[m_history release];
	[super dealloc];
}

#pragma mark -
#pragma mark API

- (void)addPacket:(InPacket*)packet {
	[m_history addObject:packet];
	m_dirty = YES;
}

- (void)addSentIM:(SentIM*)sentIM {
	[m_history addObject:sentIM];
	m_dirty = YES;
}

- (NSArray*)historyOfYear:(int)year month:(int)month day:(int)day {
	// if user want to get history before today, load from file
	// the array in History only contains history from today
	if(year < m_year || year == m_year && month < m_month || year == m_year && month == m_month && day < m_day) {
		NSString* path = [FileTool getHistoryPath:m_myQQ
											owner:m_owner
											 year:year
											month:month
											  day:day];
		if([FileTool isFileExist:path]) {
			NSData* data = [NSData dataWithContentsOfFile:path];
			NSKeyedUnarchiver* unar = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
			NSArray* array = [unar decodeObjectForKey:_kKeyHistory];
			[unar finishDecoding];
			[unar release];
			if(array)
				return array;
		}
		
		// if failed, return empty array
		return [NSArray array];
	}
	
	// get start time
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* comp = [[[NSDateComponents alloc] init] autorelease];
	[comp setHour:0];
	[comp setMinute:0];
	[comp setSecond:0];
	[comp setYear:year];
	[comp setMonth:month];
	[comp setDay:day];
	UInt32 startTime = [[calendar dateFromComponents:comp] timeIntervalSince1970];
	
	// get end time
	[comp setDay:(day + 1)];
	UInt32 endTime = [[calendar dateFromComponents:comp] timeIntervalSince1970];
	
	// find start history according to start time
	int count = [m_history count];
	int i = 0;
	for(; i < count; i++) {
		id obj = [m_history objectAtIndex:i];
		if([obj isKindOfClass:[InPacket class]] && [(InPacket*)obj timeReceived] >= startTime)
			break;
		else if([obj isKindOfClass:[SentIM class]] && [(SentIM*)obj sendTime] >= startTime)
			break;
	}
	
	// get history of specified day
	NSMutableArray* array = [NSMutableArray array];
	for(; i < count; i++) {
		id obj = [m_history objectAtIndex:i];
		if([obj isKindOfClass:[InPacket class]]) {
			if([(InPacket*)obj timeReceived] < endTime)
				[array addObject:obj];
			else
				break;
		} else if([obj isKindOfClass:[SentIM class]]) {
			if([(SentIM*)obj sendTime] < endTime)
				[array addObject:obj];
			else
				break;
		}
	}
	
	return array;
}

- (void)save {
	if(!m_dirty)
		return;
	m_dirty = NO;
	
	// get current day
	NSCalendar* calender = [NSCalendar currentCalendar];
	NSDateComponents* current = [calender components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
	int currentYear = [current year];
	int currentMonth = [current month];
	int currentDay = [current day];
	
	// tmp array
	NSMutableArray* array = [NSMutableArray array];
	int count = [m_history count];
	int i = 0;
	int year, month, day;
	
	// save
	NSDateComponents* comp = [[[NSDateComponents alloc] init] autorelease];
	[comp setHour:0];
	[comp setMinute:0];
	[comp setSecond:0];
	for(year = m_year; i < count && year <= currentYear; year++) {
		for(month = m_month; i < count && month <= currentMonth && month <= 12; month++) {
			// get date in this month
			[comp setYear:year];
			[comp setMonth:month];
			[comp setDay:1];
			NSDate* monthDate = [calender dateFromComponents:comp];
			NSRange range = [calender rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:monthDate];
			int daysInMonth = range.length;
			
			for(day = m_day; i < count && day <= currentDay && day <= daysInMonth; day++) {
				// get next day
				[comp setDay:(day + 1)];
				NSDate* nextDate = [calender dateFromComponents:comp];
				UInt32 time = [nextDate timeIntervalSince1970];
				
				// add one day history
				[array removeAllObjects];
				for(; i < count; i++) {
					id obj = [m_history objectAtIndex:i];
					if([obj isKindOfClass:[InPacket class]]) {
						if([(InPacket*)obj timeReceived] < time)
							[array addObject:obj];
						else
							break;
					} else if([obj isKindOfClass:[SentIM class]]) {
						if([(SentIM*)obj sendTime] < time)
							[array addObject:obj];
						else
							break;
					}
				}
				
				// save to file
				NSString* path = [FileTool getHistoryPath:m_myQQ
													owner:m_owner
													 year:year
													month:month
													  day:day];
				[FileTool initDirectoryForFile:path];
				NSMutableData* data = [NSMutableData data];
				NSKeyedArchiver* ar = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
				[ar setOutputFormat:NSPropertyListXMLFormat_v1_0];
				[ar encodeObject:array forKey:_kKeyHistory];
				[ar finishEncoding];
				[ar release];
				[data writeToFile:path atomically:YES];
			}
			
			day = 1;
		}
		
		month = 1;
	}
}

#pragma mark -
#pragma mark getter and setter

- (NSString*)owner {
	return m_owner;
}

- (NSString*)path {
	return m_path;
}

- (NSArray*)history {
	return m_history;
}

- (UInt32)myQQ {
	return m_myQQ;
}

@end
