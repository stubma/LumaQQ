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

#import "GetRemarkJob.h"
#import "MainWindowController.h"
#import "JobDelegate.h"

@implementation GetRemarkJob

- (NSString*)jobName {
	return kJobGetFriendRemark;
}

- (void)startJob:(MainWindowController*)domain {
	[super startJob:domain];
	
	// get friend remark
	m_remarkPage = 0;
	m_waitingSequence = [[m_domain client] batchGetRemark:m_remarkPage];
	m_remarkPage++;
}

- (BOOL)handleBatchGetFriendRemarkOK:(QQNotification*)event {
	FriendDataOpReplyPacket* packet = (FriendDataOpReplyPacket*)[event object];
	
	if([packet sequence] == m_waitingSequence) {
		// check if more friends need to be queried
		if([packet finished]) {
			// refresh outline
			[[m_domain userOutline] reloadData];
			
			// finished
			if(m_delegate)
				[m_delegate jobFinished:self];
		} else {
			m_waitingSequence = [[m_domain client] batchGetRemark:m_remarkPage];
			m_remarkPage++;
		}
	}

	return YES;
}

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventBatchGetFriendRemarkOK:
			ret = [self handleBatchGetFriendRemarkOK:event];
			break;
		case kQQEventTimeoutBasic:
			OutPacket* packet = [event outPacket];
			if([packet sequence] == m_waitingSequence) {
				// finished
				if(m_delegate)
					[m_delegate jobFinished:self];
			}
			break;
	}
	
	return ret;
}

@end
