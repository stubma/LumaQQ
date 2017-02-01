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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 0 2111-1307 USA
 */

#import "WorkflowUnit.h"


@implementation WorkflowUnit

+ (id)unitWithName:(NSString*)name failEvent:(int)failEvent {
	return [WorkflowUnit unitWithName:name failEvent:failEvent critical:NO];
}

+ (id)unitWithName:(NSString*)name failEvent:(int)failEvent critical:(BOOL)critical {
	return [WorkflowUnit unitWithName:name failEvent:failEvent critical:critical repeats:1];
}

+ (id)unitWithName:(NSString*)name failEvent:(int)failEvent critical:(BOOL)critical repeats:(int)repeats {
	WorkflowUnit* unit = [[WorkflowUnit alloc] initWithName:name
												  failEvent:failEvent
												   critical:critical
													repeats:repeats];
	return [unit autorelease];
}

- (id)initWithName:(NSString*)name failEvent:(int)failEvent critical:(BOOL)critical repeats:(int)repeats {
	self = [super init];
	if(self) {
		m_name = [name retain];
		m_failEvent = failEvent;
		m_critical = critical;
		m_repeats = repeats;
		m_repeatCount = 0;
	}
	return self;
}

- (void) dealloc {
	[m_name release];
	[super dealloc];
}

#pragma mark -
#pragma mark helper

- (void)increaseRepeat {
	m_repeatCount++;
}

#pragma mark -
#pragma mark getter and setter

- (NSString*)name {
	return m_name;
}

- (int)failEvent {
	return m_failEvent;
}

- (BOOL)critical {
	return m_critical;
}

- (int)repeats {
	return m_repeats;
}

- (int)repeatCount {
	return m_repeatCount;
}

@end
