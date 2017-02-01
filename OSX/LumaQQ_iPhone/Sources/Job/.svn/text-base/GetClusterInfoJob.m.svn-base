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

#import "GetClusterInfoJob.h"


@implementation GetClusterInfoJob

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

- (void)_getNextClusterInfo {
	if(_next >= [_clusters count]) {
		// finished
		if(m_delegate)
			[m_delegate jobFinished:self];
	} else {
		Cluster* c = [_clusters objectAtIndex:_next++];
		_waitingSequence = [[m_delegate client] getClusterInfo:[c internalId]];
	}
}

- (NSString*)jobName {
	return kJobGetClusterInfo;
}

- (void)startJob {
	[super startJob];

	[self _getNextClusterInfo];
}

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventClusterGetInfoOK:
		case kQQEventClusterGetInfoFailed:
		case kQQEventTimeoutBasic:
		{
			OutPacket* packet = [event outPacket];
			if([packet sequence] == _waitingSequence) 
				[self _getNextClusterInfo];
			break;
		}
	}
	
	return ret;
}

@end
