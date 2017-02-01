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

#import "UploadFriendGroupJob.h"


@implementation UploadFriendGroupJob

- (void) dealloc {
	[_friendGroupMapping release];
	[_allUserQQs release];
	[super dealloc];
}

- (id)initWithGroupManager:(GroupManager*)gm {
	self = [super init];
	if(self) {
		_groupManager = gm;
	}
	return self;
}

- (NSString*)jobName {
	return kJobUploadFriendGroup;
}

- (void)startJob {
	[super startJob];
	_waitingSequence = [[m_delegate client] uploadGroupNames:[_groupManager friendlyGroupNamesExceptMyFriends]];
}

- (void)_uploadFriendGroups {
	int i;
	int start = _nextUploadPage * kQQMaxUploadGroupFriendCount;
	int to = start + MIN([_allUserQQs count] - start, kQQMaxUploadGroupFriendCount);
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	for(i = start; i < to; i++) {
		NSNumber* qq = [_allUserQQs objectAtIndex:i];
		[dict setObject:[_friendGroupMapping objectForKey:qq] forKey:qq];
	}
	_waitingSequence = [[m_delegate client] uploadFriendGroup:dict];
}

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventUploadGroupNamesOK:
			ret = [self handleUploadGroupNameOK:event];
			break;
		case kQQEventUploadFriendGroupOK:
			ret = [self handleUploadFriendGroupOK:event];
			break;
		case kQQEventUploadGroupNamesFailed:
		case kQQEventUploadFriendGroupFailed:
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

- (BOOL)handleUploadGroupNameOK:(QQNotification*)event {
	OutPacket* packet = [event outPacket];
	if([packet sequence] == _waitingSequence) {
		// get mapping
		_friendGroupMapping = [[_groupManager friendGroupMapping] retain];
		_nextUploadPage = 0;
		
		// begin
		_allUserQQs = [[_friendGroupMapping allKeys] retain];
		[self _uploadFriendGroups];
		
		return YES;
	}

	return NO;
}

- (BOOL)handleUploadFriendGroupOK:(QQNotification*)event {
	OutPacket* packet = [event outPacket];
	if([packet sequence] == _waitingSequence) {
		_nextUploadPage++;
		if(_nextUploadPage * kQQMaxUploadGroupFriendCount >= [_friendGroupMapping count]) {
			if(m_delegate)
				[m_delegate jobFinished:self];
		} else
			[self _uploadFriendGroups];
		return YES;
	}
	return NO;
}

@end
