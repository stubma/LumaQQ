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

#import "GetUserPropertyJob.h"
#import "JobDelegate.h"
#import "QQNotification.h"
#import "QQEvent.h"
#import "PropertyOpReplyPacket.h"
#import "BaseJob.h"
#import "QQClient.h"

@implementation GetUserPropertyJob

- (NSString*)jobName {
	return kJobGetUserProperty;
}

- (void)startJob {
	[super startJob];
	
	_waitingSequence = [[m_delegate client] getUserProperty:0];
}

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventGetUserPropertyOK:
			ret = [self handleGetUserPropertyOK:event];
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

- (BOOL)handleGetUserPropertyOK:(QQNotification*)event {
	PropertyOpReplyPacket* packet = (PropertyOpReplyPacket*)[event object];

	if([packet sequence] == _waitingSequence) {
		// if not finished, go on
		if(![packet finished])
			_waitingSequence = [[m_delegate client] getUserProperty:[packet nextStartPosition]];
		else {			
			// finished
			if(m_delegate)
				[m_delegate jobFinished:self];
		}
	}
	
	return NO;
}

@end
