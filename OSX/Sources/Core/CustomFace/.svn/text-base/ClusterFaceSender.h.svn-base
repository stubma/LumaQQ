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

#import <Cocoa/Cocoa.h>
#import "QQListener.h"
#import "CustomFaceList.h"
#import "RequestAgentReplyPacket.h"

///////// cluster face send process ///////////
// C -> S, request agent
// S -> C, request agent reply, if redirect, repeat
// C -> S, request begin
// S -> C, request begin reply
// C -> S, send image info
// S -> C, request transfer data
// C -> S, transfer data
// S -> C, reply transfer data every 10 packets, or last

@class QQClient;

@interface ClusterFaceSender : NSObject <QQListener> {
	QQClient* m_client;
	
	NSMutableArray* m_faceLists;
	
	// current connection
	int m_connectionId;
	
	// control sending
	BOOL m_sending;
	int m_currentFace;
	
	// temp use
	int m_expectedConnectionId;
	RequestAgentReplyPacket* m_redirectPacket;
	int m_fragmentIndex;
	int m_startSendFragmentIndex;
	NSTimer* m_timer;
	BOOL m_sendingFragment;
	int m_dataReplyWaitingBeat;
	UInt16 m_startFragmentSequence;
	UInt16 m_nextSequence;
}

// init
- (id)initWithClient:(QQClient*)client;

// API
- (void)addCustomFaceList:(CustomFaceList*)faceList;

// helper
- (void)sendNextFace;
- (void)createConnection:(NSString*)ipString port:(UInt16)port;
- (void)releaseConnection;
- (CustomFace*)getCurrentFace;
- (void)sendFragment:(int)index;
- (void)onTimer:(NSTimer*)theTimer;

// qq event handler
- (BOOL)handleNetworkError:(QQNotification*)event;
- (BOOL)handleConnectionEstablished:(QQNotification*)event;
- (BOOL)handleConnectionReleased:(QQNotification*)event;
- (BOOL)handleRequestAgentOK:(QQNotification*)event;
- (BOOL)handleRequestAgentRedirect:(QQNotification*)event;
- (BOOL)handleRequestAgentReject:(QQNotification*)event;
- (BOOL)handleRequestBeginOK:(QQNotification*)event;
- (BOOL)handleImageInfoAcknowledged:(QQNotification*)event;
- (BOOL)handleImageDataAcknowledged:(QQNotification*)event;

@end
