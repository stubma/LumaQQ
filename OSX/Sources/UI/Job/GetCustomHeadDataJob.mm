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

#import "GetCustomHeadDataJob.h"
#import "CustomHead.h"
#import "JobController.h"
#import "FileTool.h"
#import "MainWindowController.h"
#import "JobDelegate.h"
#import "Constants.h"

@implementation GetCustomHeadDataJob

- (id) init {
	self = [super init];
	if (self != nil) {
		m_next = 0;
		m_customHeads = [[NSMutableArray array] retain];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(customHeadReceived:)
													 name:kCustomHeadDidReceivedNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(customHeadFailedToReceive:)
													 name:kCustomHeadFailedToReceiveNotificationName
												   object:nil];
	}
	return self;
}

- (id)initWithCustomHeads:(NSArray*)heads {
	self = [self init];
	if (self != nil) {
		[m_customHeads addObjectsFromArray:heads];
	}
	return self;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kCustomHeadDidReceivedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kCustomHeadFailedToReceiveNotificationName
												  object:nil];
	
	[m_customHeads release];
	[super dealloc];
}

- (NSString*)jobName {
	return kJobGetCustomHeadData;
}

- (void)startJob:(MainWindowController*)domain {
	[super startJob:domain];
	
	if([m_customHeads count] == 0) {
		// build user list
		NSArray* users = [[m_domain groupManager] allUsers];
		NSEnumerator* e = [users objectEnumerator];
		while(User* u = [e nextObject]) {
			if([u hasCustomHead] && [u customHead] != nil)
				[m_customHeads addObject:[u customHead]];
		}
	}
	
	// begin
	if([self getNext] == NO) {
		if(m_delegate)
			[m_delegate jobFinished:self];
	}
}

- (BOOL)getNext {
	if(m_next >= [m_customHeads count])
		return NO;
	
	CustomHead* head = [m_customHeads objectAtIndex:m_next];
	[[m_domain client] getCustomHeadData:head];
	m_next++;
	return YES;
}

- (void)customHeadReceived:(NSNotification*)notification {
	if([self getNext] == NO) {
		if(m_delegate)
			[m_delegate jobFinished:self];
	}
}

- (void)customHeadFailedToReceive:(NSNotification*)notification {
	if([self getNext] == NO) {
		if(m_delegate)
			[m_delegate jobFinished:self];
	}
}

@end
