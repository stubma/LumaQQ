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

#import "BaseJob.h"
#import "MainWindowController.h"

@implementation BaseJob

- (id) init {
	self = [super init];
	if (self != nil) {
		m_waitingSequence = 0;
		m_linkJobs = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_delegate release];
	[m_domain release];
	[m_linkJobs release];
	[super dealloc];
}

- (void)startJob:(MainWindowController*)domain {
	m_domain = [domain retain];
	[[domain client] addQQListener:self];
}

- (void)dispose:(MainWindowController*)domain {
	[[domain client] removeQQListener:self];
}

- (NSString*)jobName {
	return @"";
}

- (void)setJobDelegate:(id)delegate {
	m_delegate = [delegate retain];
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
