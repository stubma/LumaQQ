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

#import "GetSignatureJob.h"
#import "User.h"
#import "JobDelegate.h"
#import "QQNotification.h"
#import "QQEvent.h"
#import "SignatureOpReplyPacket.h"

@implementation GetSignatureJob

- (void) dealloc {
	[m_allUsers release];
	[super dealloc];
}

- (NSString*)jobName {
	return kJobGetUserSignature;
}

- (void)startJob {
	[super startJob];
	
	// get all users
	m_allUsers = [[m_delegate groupManager] allUsers];
	
	// if not empty, get user signatures
	if([m_allUsers count] > 0) {
		m_nextSignatureStart = 0;
		m_allUsers = [[m_allUsers sortedArrayUsingSelector:@selector(compareQQ:)] retain];
		
		// create an array and fill the users who has signature
		NSMutableArray* friends = [[NSMutableArray array] retain];
		int count = [m_allUsers count];
		for(; m_nextSignatureStart < count; m_nextSignatureStart++) {
			User* u = [m_allUsers objectAtIndex:m_nextSignatureStart];
			if([u hasSignature]) {
				Signature* sig = [[Signature alloc] init];
				[sig setQQ:[u QQ]];
				[sig setLastModifiedTime:[u signatureModifiedTime]];
				[friends addObject:[sig autorelease]];
			}
			
			// until to max
			if([friends count] >= kQQMaxSignatureRequest)
				break;
		}
		
		// send packet
		if([friends count] > 0)
			_waitingSequence = [[m_delegate client] getSignature:friends];
		else {
			if(m_delegate)
				[m_delegate jobFinished:self];
		}
			
		[friends release];
	}
}

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventGetSignatureOK:
			ret = [self handleGetSignatureOK:event];
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

- (BOOL)handleGetSignatureOK:(QQNotification*)event {
	SignatureOpReplyPacket* packet = (SignatureOpReplyPacket*)[event object];
	
	// if this the packet what we are waiting for
	if(_waitingSequence == [packet sequence]) {
		// reset
		_waitingSequence = 0;
		
		// check if more friends need to be queried
		int count = [m_allUsers count];
		if(m_nextSignatureStart < count) {
			// create an array and fill the users who has signature
			NSMutableArray* friends = [[NSMutableArray array] retain];
			for(; m_nextSignatureStart < count; m_nextSignatureStart++) {
				User* u = [m_allUsers objectAtIndex:m_nextSignatureStart];
				if([u hasSignature]) {
					Signature* sig = [[Signature alloc] init];
					[sig setQQ:[u QQ]];
					[sig setLastModifiedTime:[u signatureModifiedTime]];
					[friends addObject:[sig autorelease]];
				}
				
				// until to max
				if([friends count] >= kQQMaxSignatureRequest)
					break;
			}
			
			// send packet
			_waitingSequence = [[m_delegate client] getSignature:friends];
			[friends release];
		} else {
			// release cache
			[m_allUsers release];
			m_allUsers = nil;
			
			// finished
			if(m_delegate)
				[m_delegate jobFinished:self];
		}
	} 	
	return NO;
}

@end
