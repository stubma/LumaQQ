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

#import "GetFriendLevelJob.h"
#import "User.h"
#import "JobDelegate.h"
#import "OutPacket.h"
#import "QQEvent.h"
#import "LevelOpReplyPacket.h"
#import "QQNotification.h"

@implementation GetFriendLevelJob

- (void) dealloc {
	[m_allUserQQs release];
	[super dealloc];
}

- (NSString*)jobName {
	return kJobGetFriendLevel;
}

- (void)startJob {
	[super startJob];
	
	// get all user qq number array
	m_allUserQQs = [[m_delegate groupManager] allUserQQs];
	
	// if not empty, get friend level
	if([m_allUserQQs count] > 0) {
		m_getLevelTimes = 0;
		m_allUserQQs = [[m_allUserQQs sortedArrayUsingSelector:@selector(compare:)] retain];
		int start = m_getLevelTimes * kQQMaxLevelRequest;
		NSArray* subArray = [[m_allUserQQs subarrayWithRange:NSMakeRange(start, MIN(kQQMaxLevelRequest, [m_allUserQQs count] - start))] retain];
		_waitingSequence = [[m_delegate client] getFriendLevel:subArray];
		[subArray release];
		m_getLevelTimes++;
	}
}

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventGetFriendLevelOK:
			ret = [self handleGetFriendLevelOK:event];
			break;
		case kQQEventTimeoutBasic:
		{
			OutPacket* packet = [event outPacket];
			if([packet sequence] == _waitingSequence) {
				// finished
				if(m_delegate)
					[m_delegate jobFinished:self];
			}
			break;
		}
	}
	
	return ret;
}

- (BOOL)handleGetFriendLevelOK:(QQNotification*)event {
	LevelOpReplyPacket* packet = (LevelOpReplyPacket*)[event object];

	if([packet sequence] == _waitingSequence) {
		// check if more friends need to be queried
		int start = m_getLevelTimes * kQQMaxLevelRequest;
		if([m_allUserQQs count] <= start) {
			// finished
			[m_allUserQQs release];
			m_allUserQQs = nil;
			
			// finished
			if(m_delegate)
				[m_delegate jobFinished:self];
		} else {
			// go on next
			NSArray* subArray = [[m_allUserQQs subarrayWithRange:NSMakeRange(start, MIN(kQQMaxLevelRequest, [m_allUserQQs count] - start))] retain];
			_waitingSequence = [[m_delegate client] getFriendLevel:subArray];
			[subArray release];
			m_getLevelTimes++;
		}
	}
	
	return NO;
}

@end
