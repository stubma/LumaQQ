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

#import "GetCustomHeadInfoJob.h"
#import "JobController.h"
#import "GetCustomHeadInfoReplyPacket.h"
#import "User.h"
#import "QQEvent.h"
#import "BaseJob.h"
#import "JobDelegate.h"

@implementation GetCustomHeadInfoJob

- (id) init {
	self = [super init];
	if (self != nil) {
		m_nextPage = 0;
		m_timeoutCount = 0;
		m_friends = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_friends release];
	if(m_timer) {
		if([m_timer isValid])
			[m_timer invalidate];
		[m_timer release];
	}
	[super dealloc];
}

- (void)onTimer:(NSTimer*)theTimer {
	if([[NSDate date] timeIntervalSince1970] - m_lastTime >= 10.0) {
		m_timeoutCount++;
		if(m_timeoutCount >= 5) {
			// stop timer
			[m_timer invalidate];
			
			// notify delegate
			if(m_delegate)
				[m_delegate jobFinished:self];
		} else {
			m_nextPage--;
			[self sendNext];
			m_lastTime = [[NSDate date] timeIntervalSince1970];
		}
	}
}

- (BOOL)sendNext {
	int start = m_nextPage * kQQMaxGetCustomHeadInfoRequest;
	if(start >= [m_friends count])
		return NO;
	int end = MIN(start + kQQMaxGetCustomHeadInfoRequest, [m_friends count]);
	
	NSArray* sub = [m_friends subarrayWithRange:NSMakeRange(start, end - start)];
	[[m_delegate client] getCustomHeadInfo:sub];
	m_nextPage++;
	m_lastTime = [[NSDate date] timeIntervalSince1970];
	return YES;
}

- (NSString*)jobName {
	return kJobGetCustomHeadInfo;
}

- (void)startJob {
	[super startJob];
	
	// build user list
	NSArray* users = [[m_delegate groupManager] allUsers];
	NSEnumerator* e = [users objectEnumerator];
	User* u;
	while(u = [e nextObject]) {
		if([u hasCustomHead])
			[m_friends addObject:[NSNumber numberWithUnsignedInt:[u QQ]]];
	}
	
	// start timer
	m_timer = [[NSTimer scheduledTimerWithTimeInterval:10.0
											   target:self
											 selector:@selector(onTimer:)
											 userInfo:nil
											  repeats:YES] retain];
	
	// send request
	[self sendNext];
}

- (BOOL)handleGetCustomHeadInfoOK:(QQNotification*)event {
	GetCustomHeadInfoReplyPacket* packet = (GetCustomHeadInfoReplyPacket*)[event object];
	NSEnumerator* e = [[packet customHeads] objectEnumerator];
	CustomHead* head;
	while(head = [e nextObject]) {
		User* u = [[m_delegate groupManager] user:[head QQ]];
		if(u)
			[u setCustomHead:head];
	}
	
	// next
	if([self sendNext] == NO) {
		// stop timer
		[m_timer invalidate];
		
		// notify delegate
		if(m_delegate)
			[m_delegate jobFinished:self];
	}
	
	return YES;
}

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventGetCustomHeadInfoOK:
			ret = [self handleGetCustomHeadInfoOK:event];
			break;
	}
	
	return ret;
}

@end
