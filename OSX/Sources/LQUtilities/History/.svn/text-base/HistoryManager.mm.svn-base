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

#import "HistoryManager.h"
#import "FileTool.h"

@implementation HistoryManager

- (id)initWithQQ:(UInt32)QQ {
	self = [super init];
	if(self) {
		m_QQ = QQ;
		
		m_cache = [[NSMutableDictionary dictionary] retain];
	}
	return self;
}

- (void) dealloc {
	[m_cache release];
	[super dealloc];
}

#pragma mark -
#pragma mark API

- (History*)getHistory:(NSString*)owner year:(int)year month:(int)month day:(int)day {
	// check cache
	History* history = [m_cache objectForKey:owner];
	if(history)
		return history;
	
	// create history and return
	NSString* path = [FileTool getHistoryPath:m_QQ
										owner:owner
										 year:year
										month:month
										  day:day];
	history = [[[History alloc] initWithMyQQ:m_QQ owner:owner path:path year:year month:month day:day] autorelease];
	[m_cache setObject:history forKey:owner];
	return history;
}

- (History*)getHistoryToday:(NSString*)owner {
	// check cache
	History* history = [m_cache objectForKey:owner];
	if(history)
		return history;
	
	// create history and return
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* comp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
	return [self getHistory:owner
					   year:[comp year]
					  month:[comp month]
						day:[comp day]];
}

- (void)save {
	NSEnumerator* e = [m_cache objectEnumerator];
	while(History* history = [e nextObject])
		[history save];
}

@end
