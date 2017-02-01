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

#import "GetUserPropertyJob.h"
#import "MainWindowController.h"
#import "JobDelegate.h"

@implementation GetUserPropertyJob

- (NSString*)jobName {
	return kJobGetUserProperty;
}

- (void)startJob:(MainWindowController*)domain {
	[super startJob:domain];
	
	m_waitingSequence = [[m_domain client] getUserProperty:0];
}

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventGetUserPropertyOK:
			ret = [self handleGetUserPropertyOK:event];
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

- (BOOL)handleGetUserPropertyOK:(QQNotification*)event {
	PropertyOpReplyPacket* packet = (PropertyOpReplyPacket*)[event object];

	if([packet sequence] == m_waitingSequence) {
		// if not finished, go on
		if(![packet finished])
			m_waitingSequence = [[m_domain client] getUserProperty:[packet nextStartPosition]];
		else {			
			// finished
			if(m_delegate)
				[m_delegate jobFinished:self];
		}
	}
	
	return NO;
}

@end
