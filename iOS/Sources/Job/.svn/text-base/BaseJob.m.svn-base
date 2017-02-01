/*
 * LumaQQ - Cross platform QQ client, special edition for iPhone
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

#import "BaseJob.h"
#import "QQNotification.h"

@implementation BaseJob

- (id) init {
	self = [super init];
	if (self != nil) {
		_waitingSequence = 0;
		m_linkJobs = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[(id)m_delegate release];
	[m_linkJobs release];
	[super dealloc];
}

- (void)startJob {
}

- (void)dispose {
}

- (NSString*)jobName {
	return @"";
}

- (void)setJobDelegate:(id<JobDelegate>)delegate {
	m_delegate = [(id)delegate retain];
}

- (void)addLinkJob:(id<Job>)job {
	[m_linkJobs addObject:job];
}

- (NSArray*)getLinkJobs {
	return m_linkJobs;
}

- (BOOL)handleQQEvent:(QQNotification*)event {
	return NO;
}

@end
