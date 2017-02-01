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

#import "TimerTask.h"


@implementation TimerTask

- (id) init {
	self = [super init];
	if (self != nil) {
		m_interval = 500;
		m_nextTriggerTime = m_interval;
	}
	return self;
}

- (id)initWithInterval:(UInt32)interval {
	self = [super init];
	if (self != nil) {
		m_interval = interval;
		m_nextTriggerTime = m_interval;
	}
	return self;
}

- (void)adjustNextTriggerTime {
	m_nextTriggerTime += m_interval;
}

- (void)doTask {
}

- (BOOL)shouldStop:(id)refObject {
	return NO;
}

- (BOOL)shouldExecute:(UInt32)currentTime {
	return m_nextTriggerTime <= currentTime;
}

- (id)keyObject {
	return nil;
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)nextTriggerTime {
	return m_nextTriggerTime;
}

- (void)setNextTriggerTime:(UInt32)time {
	m_nextTriggerTime = time;
}

- (UInt32)interval {
	return m_interval;
}

- (void)setInterval:(UInt32)interval {
	m_interval = interval;
}

@end
