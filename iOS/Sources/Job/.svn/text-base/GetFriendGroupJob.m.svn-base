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

#import "GetFriendGroupJob.h"
#import "GetFriendListReplyPacket.h"
#import "GetFriendGroupReplyPacket.h"
#import "GroupDataOpReplyPacket.h"

@implementation GetFriendGroupJob

- (id)initWithGroupManager:(GroupManager*)gm {
	self = [super init];
	if(self) {
		_groupManager = gm;
	}
	return self;
}

- (NSString*)jobName {
	return kJobGetFriendGroup;
}

- (void)startJob {
	[super startJob];
	_waitingSequence = [[m_delegate client] downloadGroupNames];
}

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventGetFriendListOK:
			ret = [self handleGetFriendListOK:event];
			break;
		case kQQEventGetFriendGroupOK:
			ret = [self handleGetFriendGroupOK:event];
			break;
		case kQQEventDownloadGroupNamesOK:
			ret = [self handleDownloadGroupNameOK:event];
			break;
		case kQQEventTimeoutBasic:
		{
			OutPacket* packet = [event outPacket];
			if([packet sequence] == _waitingSequence) {
				if(m_delegate)
					[m_delegate jobFinished:self];
				return YES;
			}
			break;
		}
	}
	
	return ret;
}

- (BOOL)handleGetFriendListOK:(QQNotification*)event {
	GetFriendListReplyPacket* packet = (GetFriendListReplyPacket*)[event object];
	if(_waitingSequence == [packet sequence]) {
		// add friends
		[_groupManager addFriends:[packet friends]];
		
		// finished?
		if([packet finished]) {
			if(m_delegate)
				[m_delegate jobFinished:self];
		} else {
			_waitingSequence = [[m_delegate client] getFriendList:[packet nextStartPosition]];
		}
		return YES;
	}
	
	return NO;
}

- (BOOL)handleGetFriendGroupOK:(QQNotification*)event {
	GetFriendGroupReplyPacket* packet = (GetFriendGroupReplyPacket*)[event object];
	if(_waitingSequence == [packet sequence]) {
		// add friend groups
		[_groupManager addFriendGroups:[packet friendGroups]];
		
		// finished?
		if([packet finished]) {
			_waitingSequence = [[m_delegate client] getFriendList];
		} else {
			_waitingSequence = [[m_delegate client] getFriendGroup:[packet nextStartPosition]];
		}
		return YES;
	}

	return NO;
}

- (BOOL)handleDownloadGroupNameOK:(QQNotification*)event {
	GroupDataOpReplyPacket* packet = (GroupDataOpReplyPacket*)[event object];
	if(_waitingSequence == [packet sequence]) {
		[_groupManager initializeGroups:[packet groupNames]];
		_waitingSequence = [[m_delegate client] getFriendGroup];
		return YES;
	}

	return NO;
}

@end
