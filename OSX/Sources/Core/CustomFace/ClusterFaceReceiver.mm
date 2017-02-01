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

#import "ClusterFaceReceiver.h"
#import "QQClientDelegate.h"
#import "Connection.h"
#import "ByteTool.h"
#import "QQClient.h"
#import "RequestFaceReplyPacket.h"
#import "RequestBeginReplyPacket.h"

@implementation ClusterFaceReceiver

- (void) dealloc {
	[m_client release];
	[m_faceLists release];
	[m_buffer release];
	[m_fragmentCache release];
	if(m_imageInfoPacket)
		[m_imageInfoPacket release];
	[super dealloc];
}

- (id)initWithClient:(QQClient*)client {
	self = [super init];
	if(self) {
		m_client = [client retain];
		m_faceLists = [[NSMutableArray array] retain];
		m_buffer = [[NSMutableData data] retain];
		m_fragmentCache = [[NSMutableDictionary dictionary] retain];
		m_connectionId = -1;
		m_receiving = NO;
		m_currentFace = -1;
		m_expectedConnectionId = -1;
	}
	return self;
}

#pragma mark -
#pragma mark API

- (void)addCustomFaceList:(CustomFaceList*)faceList {
	[m_faceLists addObject:faceList];
	[self receiveNextFace];
}

- (void)reset {
	m_receiving = NO;
	m_currentFace = -1;
	m_connectionId = -1;
	[m_faceLists removeAllObjects];
}

#pragma mark -
#pragma mark helper

- (void)receiveNextFace {
	// check flag
	if(m_receiving)
		return;
	m_receiving = YES;
	
	// check next face list array
	if([m_faceLists count] == 0) {
		m_receiving = NO;
		return;
	}
	
	// get current face list to first
	CustomFaceList* list = [m_faceLists objectAtIndex:0];
	
	// get next face need to be received
	id delegate = [m_client delegate];
	CustomFace* face = nil;	
	while(face == nil || [face isReference] || (delegate != nil && ![delegate shouldReceiveCustomFace:face])) {
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
		m_receiving = NO;
		return;
	}
	
	// check connection
	if(m_connectionId == -1)
		[self createConnection];
	else {
		// get current connection
		Connection* conn = [m_client getConnection:m_connectionId];
		
		// get face agent ip string
		NSString* agentIp = [ByteTool ip2String:[face serverIp]];
		
		// compare ip, if not same, release connection
		if([agentIp isEqualToString:[conn server]])
			[m_client requestFace:m_connectionId sessionId:[face sessionId] owner:[face owner] encryptKey:[face fileAgentKey]];
		else
			[self releaseConnection];
	}
}

- (void)createConnection {
	// check id
	if(m_connectionId != -1)
		return;
	
	// get face object
	CustomFace* face = [self getCurrentFace];
	NSAssert(face != nil, @"face should not nil");
	
	// get new connection
	Connection* conn = [[m_client mainConnection] copyWithNewAddress:[ByteTool ip2String:[face serverIp]]];
	[conn setPort:[NSNumber numberWithInt:[face serverPort]]];
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
		case kQQEventRequestBeginOK:
			ret = [self handleRequestBeginOK:event];
			break;
		case kQQEventRequestFaceOK:
			ret = [self handleRequestFaceOK:event];
			break;
		case kQQEventImageDataReceived:
			ret = [self handleReceivedImageData:event];
			break;
		case kQQEventImageInfoReceived:
			ret = [self handleReceivedImageInfo:event];
			break;
		case kQQEventTimeoutAgent:
			ret = [self handleTimeout:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleTimeout:(QQNotification*)event {
	if(m_connectionId = [event connectionId]) {
		// if currently a face is in transfer, then restart
		if(m_currentFace != -1) {
			// call delegate
			if([m_client delegate])
				[[m_client delegate] customFaceFailedToReceive:[self getCurrentFace]];
			
			// receive next
			m_receiving = NO;
			[self receiveNextFace];
		}
		
		return YES;
	}
	
	return NO;
}

- (BOOL)handleNetworkError:(QQNotification*)event {
	if([event connectionId] == m_connectionId) {
		// set id
		m_connectionId = -1;
		
		// if currently a face is in transfer, then restart
		if(m_currentFace != -1) {
			// call delegate
			if([m_client delegate])
				[[m_client delegate] customFaceFailedToReceive:[self getCurrentFace]];
			
			// receive next
			m_receiving = NO;
			[self receiveNextFace];
		}
		
		return YES;
	}
	return NO;
}

- (BOOL)handleRequestFaceOK:(QQNotification*)event {
	if([event connectionId] == m_connectionId) {
		RequestFaceReplyPacket* packet = (RequestFaceReplyPacket*)[event object];
		if([packet unknown] != 0) {
			// call delegate
			if([m_client delegate])
				[[m_client delegate] customFaceFailedToReceive:[self getCurrentFace]];
			
			// receive next
			m_receiving = NO;
			[self receiveNextFace];
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
		
		// request face
		[m_client requestFace:m_connectionId sessionId:[face sessionId] owner:[face owner] encryptKey:[face fileAgentKey]];
		
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
			// call delegate
			if([m_client delegate])
				[[m_client delegate] customFaceFailedToReceive:[self getCurrentFace]];
			
			m_receiving = NO;
			[self receiveNextFace];
		}

		return YES;
	}
	
	return NO;
}

- (BOOL)handleRequestBeginOK:(QQNotification*)event {
	if([event connectionId] == m_connectionId) {
		RequestBeginReplyPacket* packet = (RequestBeginReplyPacket*)[event object];
		[m_client requestData:m_connectionId sessionId:[packet sessionId]];
		return YES;
	}
	return NO;
}

- (BOOL)handleReceivedImageInfo:(QQNotification*)event {
	if([event connectionId] == m_connectionId) {
		CustomFace* face = [self getCurrentFace];
		NSAssert(face != nil, @"Face shouldn't be nil");
		
		// save packet
		m_imageInfoPacket = [[event object] retain];
		m_imageSize = [m_imageInfoPacket imageSize];
		m_receivedPacket = 0;
		
		// initialize
		[m_buffer setLength:0];
		[m_fragmentCache removeAllObjects];
		m_nextFragmentIndex = 1;
		
		// request begin
		[m_client requestReceiveBegin:m_connectionId
							sessionId:[m_imageInfoPacket sessionId]
						 transferType:kQQAgentReceive
						   encryptKey:[face fileAgentKey]];
		return YES;
	}
	return NO;
}

- (BOOL)handleReceivedImageData:(QQNotification*)event {
	if([event connectionId] == m_connectionId) {
		// get packet
		ServerTransferPacket* packet = (ServerTransferPacket*)[[event object] retain];
		UInt32 sessionId = [packet sessionId];
		m_receivedPacket++;
		
		if([packet sequence] % 10 == 0)
			[m_client replyTransferData:m_connectionId sessionId:sessionId];
		
		// check fragment index
		if([packet sequence] != m_nextFragmentIndex) {
			[m_fragmentCache setObject:packet forKey:[NSNumber numberWithInt:[packet sequence]]];
			[packet release];			
			return YES;
		} else {
			// append data
			do {
				[packet release];
				NSData* data = [packet imageData];
				[m_buffer appendData:data];
				m_imageSize -= [data length];
				
				m_nextFragmentIndex++;
				NSNumber* key = [NSNumber numberWithInt:m_nextFragmentIndex];
				packet = [m_fragmentCache objectForKey:key];
				if(packet) {
					[packet retain];
					[m_fragmentCache removeObjectForKey:key];
				}					
			} while(packet);
			
			// if already received all image data, notify delegate
			if(m_imageSize <= 0) {
				// last reply
				[m_client replyTransferData:m_connectionId sessionId:sessionId];
				m_receivedPacket = 0;
				
				// get face object
				CustomFace* face = [self getCurrentFace];
				NSAssert(face != nil, @"Face shouldn't be nil");	
				
				// delegate
				if([m_client delegate])
					[[m_client delegate] customFaceDidReceived:face data:m_buffer];
				
				// receive next face
				m_receiving = NO;
				[self receiveNextFace];
			}
		}
		
		return YES;
	}
	return NO;
}

@end
