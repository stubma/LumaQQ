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

#import "ClusterFaceSender.h"
#import "QQClient.h"
#import "ByteTool.h"

@implementation ClusterFaceSender

- (void) dealloc {
	[m_timer invalidate];
	[m_timer release];
	[m_client release];
	[m_faceLists release];
	[m_redirectPacket release];
	[super dealloc];
}

- (id)initWithClient:(QQClient*)client {
	self = [super init];
	if(self) {
		m_client = [client retain];
		m_faceLists = [[NSMutableArray array] retain];
		m_sending = NO;
		m_currentFace = -1;
		m_connectionId = -1;
		m_expectedConnectionId = -1;
		m_fragmentIndex = 0;
		m_sendingFragment = NO;
		m_startFragmentSequence = m_nextSequence = 1000;
		
		// start time
		m_timer = [[NSTimer scheduledTimerWithTimeInterval:0.5
												   target:self
												 selector:@selector(onTimer:)
												 userInfo:nil
												  repeats:YES] retain];
	}
	return self;
}

#pragma mark -
#pragma mark API

- (void)addCustomFaceList:(CustomFaceList*)faceList {
	[m_faceLists addObject:faceList];
	[self sendNextFace];
}

#pragma mark -
#pragma mark helper

- (void)onTimer:(NSTimer*)theTimer {
	if(m_sendingFragment) {
		if(m_fragmentIndex - m_startSendFragmentIndex < 10) {
			[self sendFragment:m_fragmentIndex++];
		} else if(m_dataReplyWaitingBeat > 40) {
			m_dataReplyWaitingBeat = 0;
			m_fragmentIndex = m_startSendFragmentIndex;
			m_nextSequence = m_startFragmentSequence;
		} else {
			m_dataReplyWaitingBeat++;
			NSLog(@"beat: %d", m_dataReplyWaitingBeat);
		}
	}
}

- (void)sendNextFace {
	if(m_sending)
		return;
	m_sending = YES;
	
	// check face list count
	if([m_faceLists count] == 0) {
		m_sending = NO;
		return;
	}
	
	// get current face list to first
	CustomFaceList* list = [m_faceLists objectAtIndex:0];
	
	// get next face need to be sent
	id delegate = [m_client delegate];
	CustomFace* face = nil;	
	while(face == nil || [face isReference] || (delegate != nil && ![delegate shouldSendCustomFace:face])) {
		// get next face
		m_currentFace++;
		while(m_currentFace >= [list count]) {
			m_currentFace = 0;
			[m_faceLists removeObjectAtIndex:0];
			if([m_faceLists count] == 0) {
				m_currentFace = -1;
				break;
			} else
				list = [m_faceLists objectAtIndex:0];
		}
		
		// if -1, no more, if not, get face object
		if(m_currentFace == -1) 
			break;
		else
			face = [list face:m_currentFace includeReference:YES];
	}
	
	// if still -1, return
	if(m_currentFace == -1) {
		m_sending = NO;
		return;
	}
	
	// set file agent key if face doesn't have one
	if([face fileAgentKey] == nil)
		[face setFileAgentKey:[[m_client user] fileAgentKey]];
	
	// check connection
	if(m_connectionId == -1)
		[self createConnection:kStartAgentServer port:kStartAgentServerPort];
	else {
		// connection already exists, request agent
		[m_client requestAgent:m_connectionId
						 owner:[face owner]
				  transferType:[face agentTransferType]
					 imageSize:[face imageSize]
					  imageMd5:[face fileMd5]
			  imageFileNameMd5:[face filenameMd5]];
	}
}

- (void)createConnection:(NSString*)ipString port:(UInt16)port {
	// check id
	if(m_connectionId != -1)
		return;
	
	// get face object
	CustomFace* face = [self getCurrentFace];
	NSAssert(face != nil, @"face should not nil");
	
	// get new connection
	Connection* conn = [[m_client mainConnection] copyWithNewAddress:ipString];
	[conn setPort:[NSNumber numberWithInt:port]];
	[conn setAdvisorId:[NSNumber numberWithInt:kQQFamilyAgent]];
	m_expectedConnectionId = [[conn connectionId] intValue];
	
	// new connection
	[m_client newConnection:conn];
}

- (void)releaseConnection {
	// check id
	if(m_connectionId == -1)
		return;
	
	[m_client releaseConnection:m_connectionId];
}

- (CustomFace*)getCurrentFace {
	if(m_currentFace == -1 || [m_faceLists count] == 0)
		return nil;
	CustomFaceList* list = [m_faceLists objectAtIndex:0];
	CustomFace* face = [list face:m_currentFace includeReference:YES];
	return face;
}

- (void)sendFragment:(int)index {
	CustomFace* face = [self getCurrentFace];
	NSData* data = [face fileData];
	int length = [data length];
	
	// check length
	if(index * kQQMaxCustomFaceFragmentLength >= length)
		return;
	
	// send fragment
	NSData* fragment = [data subdataWithRange:NSMakeRange(index * kQQMaxCustomFaceFragmentLength, MIN(kQQMaxCustomFaceFragmentLength, length - index * kQQMaxCustomFaceFragmentLength))];
	[m_client transferImageData:m_connectionId
					  sessionId:[face sessionId]
						   data:fragment
					   sequence:m_nextSequence++];
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventNetworkError:
			ret = [self handleNetworkError:event];
			break;
		case kQQEventNetworkConnectionEstablished:
			ret = [self handleConnectionEstablished:event];
			break;
		case kQQEventNetworkConnectionReleased:
			ret = [self handleConnectionReleased:event];
			break;
		case kQQEventRequestAgentOK:
			ret = [self handleRequestAgentOK:event];
			break;
		case kQQEventRequestAgentRedirect:
			ret = [self handleRequestAgentRedirect:event];
			break;
		case kQQEventRequestAgentRejected:
			ret = [self handleRequestAgentReject:event];
			break;
		case kQQEventRequestBeginOK:
			ret = [self handleRequestBeginOK:event];
			break;
		case kQQEventImageInfoAcknowledged:
			ret = [self handleImageInfoAcknowledged:event];
			break;
		case kQQEventImageDataAcknowledged:
			ret = [self handleImageDataAcknowledged:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleNetworkError:(QQNotification*)event {
	if([event connectionId] == m_connectionId) {
		// set id
		m_connectionId = -1;
		
		// if currently a face is in transfer, then restart
		if(m_currentFace != -1) {
			// get current face list
			CustomFaceList* faceList = [m_faceLists objectAtIndex:0];
			
			// call delegate
			if([m_client delegate])
				[[m_client delegate] customFaceListFailedToSend:faceList errorMessage:@"Network Error"];
			
			// remove current face list
			[m_faceLists removeObjectAtIndex:0];
			m_currentFace = -1;
			
			// send next
			m_sending = NO;
			[self sendNextFace];
		}
		
		return YES;
	}
	return NO;
}

- (BOOL)handleConnectionEstablished:(QQNotification*)event {
	if(m_expectedConnectionId == [event connectionId]) {
		// save connection id
		m_connectionId = [event connectionId];
		m_expectedConnectionId = -1;
		
		// get current face
		CustomFace* face = [self getCurrentFace];
		NSAssert(face != nil, @"face should not nil");
		
		// request agent
		[m_client requestAgent:m_connectionId
						 owner:[face owner]
				  transferType:[face agentTransferType]
					 imageSize:[face imageSize]
					  imageMd5:[face fileMd5]
			  imageFileNameMd5:[face filenameMd5]];
		
		return YES;
	}
	
	return NO;
}

- (BOOL)handleConnectionReleased:(QQNotification*)event {
	if([event connectionId] == m_connectionId) {
		// set id to -1
		m_connectionId = -1;
		
		// if has face to send, create connection
		if(m_currentFace != -1) {
			[self createConnection:[ByteTool ip2String:[m_redirectPacket redirectServerIp]]
							  port:[m_redirectPacket redirectServerPort]];
		}
		
		return YES;
	}
	
	return NO;
}

- (BOOL)handleRequestAgentOK:(QQNotification*)event {
	if([event connectionId] == m_connectionId) {
		RequestAgentReplyPacket* packet = [event object];		
		CustomFace* face = [self getCurrentFace];
		[face setServerIp:[packet serverIp]];
		[face setServerPort:[packet serverPort]];
		[face setSessionId:[packet sessionId]];
		[m_client requestSendBegin:m_connectionId
						 sessionId:[packet sessionId]
					  transferType:[face agentTransferType]];
		return YES;
	}
	
	return NO;
}

- (BOOL)handleRequestAgentRedirect:(QQNotification*)event {
	if([event connectionId] == m_connectionId) {
		if(m_redirectPacket)
			[m_redirectPacket release];
		m_redirectPacket = [[event object] retain];
		[self releaseConnection];
		return YES;
	}
	
	return NO;
}

- (BOOL)handleRequestAgentReject:(QQNotification*)event {
	if([event connectionId] == m_connectionId) {
		RequestAgentReplyPacket* packet = [event object];
		
		// get current face list
		CustomFaceList* faceList = [m_faceLists objectAtIndex:0];
		
		// call delegate
		if([m_client delegate])
			[[m_client delegate] customFaceListFailedToSend:faceList errorMessage:[packet message]];
		
		// remove current face list
		[m_faceLists removeObjectAtIndex:0];
		m_currentFace = -1;
		
		// send next
		m_sending = NO;
		[self sendNextFace];
		
		return YES;
	}
	
	return NO;
}

- (BOOL)handleRequestBeginOK:(QQNotification*)event {
	if([event connectionId] == m_connectionId) {
		CustomFace* face = [self getCurrentFace];
		[m_client transferImageInfo:m_connectionId
						  sessionId:[face sessionId]
							fileMd5:[face fileMd5]
						filenameMd5:[face filenameMd5]
						  imageSize:[face imageSize]
						   filename:[face filename]];
		[m_client transferImageInfo:m_connectionId
						  sessionId:[face sessionId]
							fileMd5:[face fileMd5]
						filenameMd5:[face filenameMd5]
						  imageSize:[face imageSize]
						   filename:[face filename]];
		return YES;
	}
	
	return NO;
}

- (BOOL)handleImageInfoAcknowledged:(QQNotification*)event {
	if([event connectionId] == m_connectionId) {
		m_fragmentIndex = 0;
		m_startSendFragmentIndex = 0;
		m_dataReplyWaitingBeat = 0;
		m_sendingFragment = YES;
		return YES;
	}
	
	return NO;
}

- (BOOL)handleImageDataAcknowledged:(QQNotification*)event {
	if([event connectionId] == m_connectionId) {
		ServerTransferPacket* packet = [event object];
		if([packet sequence] >= m_startFragmentSequence && [packet sequence] < m_nextSequence) {
			// if packet sequence isn't equal next sequence minus 1, then some error in here
			if([packet sequence] != m_nextSequence - 1) {
				// get current face list
				CustomFaceList* faceList = [m_faceLists objectAtIndex:0];
				
				// call delegate
				if([m_client delegate])
					[[m_client delegate] customFaceListFailedToSend:faceList errorMessage:@"Unknown Error"];
				
				// remove current face list
				[m_faceLists removeObjectAtIndex:0];
				m_currentFace = -1;
				
				// send next
				m_sending = NO;
				[self sendNextFace];
				
				return YES;
			}
			
			// refresh sequence
			m_sendingFragment = NO;
			m_startSendFragmentIndex += 10;
			m_fragmentIndex = m_startSendFragmentIndex;
			m_startFragmentSequence = m_nextSequence;
			m_dataReplyWaitingBeat = 0;
			
			CustomFace* face = [self getCurrentFace];
			if(m_fragmentIndex * kQQMaxCustomFaceFragmentLength >= [face imageSize]) {
				if([m_client delegate])
					[[m_client delegate] customFaceDidSent:face];
				
				m_sending = NO;
				[self sendNextFace];
			} else
				m_sendingFragment = YES;
			
			return YES;
		}
	}
	
	return NO;
}

@end
