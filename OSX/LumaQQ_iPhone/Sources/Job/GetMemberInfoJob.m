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

#import "GetMemberInfoJob.h"


@implementation GetMemberInfoJob

- (void) dealloc {
	[_clusters release];
	[super dealloc];
}

- (id)initWithClusters:(NSArray*)clusters {
	self = [super init];
	if(self) {
		_clusters = [clusters retain];
		_nextCluster = 0;
		_nextPacket = 0;
	}
	return self;
}

- (Cluster*)_nextCluster {
	if(_nextCluster >= [_clusters count])
		return nil;
	else
		return [_clusters objectAtIndex:_nextCluster];
}

- (void)_getNext {
	// get member info, divide into small packet because we only can get 30 members once
	Cluster* c = [self _nextCluster];
	while(c != nil) {
		NSArray* members = [c members];
		int i;
		int count = [members count];
		int packets = (count - 1) / kQQMaxMemberInfoRequest + 1;
		
		if(_nextPacket >= packets) {
			_nextPacket = 0;
			_nextCluster++;
			c = [self _nextCluster];
		} else {
			NSArray* subMembers = [members subarrayWithRange:NSMakeRange(_nextPacket * kQQMaxMemberInfoRequest, MIN(kQQMaxMemberInfoRequest, count - _nextPacket * kQQMaxMemberInfoRequest))];
			NSMutableArray* memberQQs = [NSMutableArray arrayWithCapacity:[subMembers count]];
			NSEnumerator* e = [subMembers objectEnumerator];
			User* u;
			while(u = [e nextObject])
				[memberQQs addObject:[NSNumber numberWithUnsignedInt:[u QQ]]];
			_waitingSequence = [[m_delegate client] getMemberInfo:[c internalId] members:memberQQs];
			
			_nextPacket++;
			break;
		}
	}
	
	if(c == nil) {
		// finished
		if(m_delegate)
			[m_delegate jobFinished:self];
	}
}

- (NSString*)jobName {
	return kJobGetClusterMemberInfo;
}

- (void)startJob {
	[super startJob];
	
	[self _getNext];
}

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventClusterGetMemberInfoOK:
		case kQQEventClusterGetMemberInfoFailed:
		case kQQEventTimeoutBasic:
		{
			OutPacket* packet = [event outPacket];
			if([packet sequence] == _waitingSequence) 
				[self _getNext];
			break;
		}
	}
	
	return ret;
}

@end
