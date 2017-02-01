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

#import "TimerTaskManager.h"

#define _kTimerEventTriggerInterval 250

static TimerTaskManager* s_instance = nil;

@implementation TimerTaskManager

+ (TimerTaskManager*)sharedManager {
	if(s_instance == nil) {
		s_instance = [[TimerTaskManager alloc] init];
	}
	return s_instance;
}

- (id) init {
	self = [super init];
	if (self != nil) {
		m_tasks = [[NSMutableArray array] retain];
		m_currentTime = 0;
		m_timer = [[NSTimer scheduledTimerWithTimeInterval:(_kTimerEventTriggerInterval / 1000.0)
												   target:self
												 selector:@selector(onTimer:)
												 userInfo:nil
												  repeats:YES] retain];
	}
	return self;
}

- (void) dealloc {
	if(m_timer) {
		if([m_timer isValid])
			[m_timer invalidate];
		[m_timer release];
	}	
	[m_tasks release];
	[super dealloc];
}

- (void)addTask:(TimerTask*)task {
	if(![m_tasks containsObject:task]) {
		[task setNextTriggerTime:(m_currentTime + [task interval])];
		[m_tasks addObject:task];
	}
}

- (void)removeTasks:(id)refObject {
	int count = [m_tasks count];
	for(int i = count - 1; i >= 0; i--) {
		TimerTask* task = [m_tasks objectAtIndex:i];
		if([task shouldStop:refObject])
			[m_tasks removeObjectAtIndex:i];
	}
}

- (void)clear {
	[m_tasks removeAllObjects];
}

- (void)onTimer:(NSTimer*)theTimer {
	m_currentTime += _kTimerEventTriggerInterval;
	int count = [m_tasks count];
	for(int i = count - 1; i >= 0; i--) {
		TimerTask* task = [m_tasks objectAtIndex:i];
		if([task shouldStop:nil])
			[m_tasks removeObjectAtIndex:i];
		else if([task shouldExecute:m_currentTime]) {
			[task doTask];
			[task adjustNextTriggerTime];
		}
	}
}

@end
