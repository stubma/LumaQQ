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

#import "GetMessageSettingJob.h"


@implementation GetMessageSettingJob

- (void) dealloc {
	[_clusters release];
	[super dealloc];
}

- (id)initWithClusters:(NSArray*)clusters {
	self = [super init];
	if(self) {
		_clusters = [clusters retain];
		_next = 0;
	}
	return self;
}

- (NSString*)jobName {
	return kJobGetClusterMessageSetting;
}

- (void)startJob {
	[super startJob];
	
	NSMutableArray* ids = [NSMutableArray array];
	NSEnumerator* e = [_clusters objectEnumerator];
	Cluster* c;
	while(c = [e nextObject])
		[ids addObject:[NSNumber numberWithUnsignedInt:[c internalId]]];
	_waitingSequence = [[m_delegate client] getMessageSetting:ids];
}

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventClusterGetMessageSettingOK:
		case kQQEventClusterGetMessageSettingFailed:
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

@end
