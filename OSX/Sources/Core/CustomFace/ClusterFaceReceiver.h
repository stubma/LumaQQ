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
#import "ServerTransferPacket.h"

/////////// cluster custom face receiving process ///////////////
// C -> S, request face
// S -> C, request face reply
// S -> C, transfer image basic info
// C -> S, request begin (only do once during a connection lifecycle)
// S -> C, request begin reply
// S -> C, transfer image data
// C -> S, data reply on 10K bytes basis

@class QQClient;

@interface ClusterFaceReceiver : NSObject <QQListener> {
	QQClient* m_client;
	
	NSMutableArray* m_faceLists;
	
	// current connection
	int m_connectionId;
	
	// control receiving
	BOOL m_receiving;
	int m_currentFace;
	
	// temp use
	int m_expectedConnectionId;
	ServerTransferPacket* m_imageInfoPacket;
	int m_receivedPacket;
	int m_imageSize;
	NSMutableData* m_buffer;
	NSMutableDictionary* m_fragmentCache;
	int m_nextFragmentIndex;
}

// init
- (id)initWithClient:(QQClient*)client;

// API
- (void)addCustomFaceList:(CustomFaceList*)faceList;
- (void)reset;

// helper
- (void)receiveNextFace;
- (void)createConnection;
- (void)releaseConnection;
- (CustomFace*)getCurrentFace;

// qq event handler
- (BOOL)handleNetworkError:(QQNotification*)event;
- (BOOL)handleConnectionEstablished:(QQNotification*)event;
- (BOOL)handleConnectionReleased:(QQNotification*)event;
- (BOOL)handleRequestFaceOK:(QQNotification*)event;
- (BOOL)handleRequestBeginOK:(QQNotification*)event;
- (BOOL)handleReceivedImageInfo:(QQNotification*)event;
- (BOOL)handleReceivedImageData:(QQNotification*)event;
- (BOOL)handleTimeout:(QQNotification*)event;

@end
