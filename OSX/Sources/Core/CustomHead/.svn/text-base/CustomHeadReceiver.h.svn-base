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
#import "Connection.h"
#import "StatusListener.h"
#import "CustomHead.h"

@class QQClient;

@interface CustomHeadReceiver : NSObject <QQListener, StatusListener> {
	QQClient* m_client;
	
	Connection* m_connection;
	NSMutableArray* m_customHeads;
	BOOL m_getting;
	CustomHead* m_currentHead;
	UInt32 m_headSize;
	UInt32 m_oldSize;
	char* m_test;
	NSTimeInterval m_lastTime;
	char* m_buffer;
	NSTimer* m_timer;
	int m_timeoutCount;
}

// init
- (id)initWithClient:(QQClient*)client;

// helper
- (void)getNextHead;
- (void)onTimer:(NSTimer*)timer;
- (BOOL)isAllReceived;
- (void)nextHole:(UInt32*)offset length:(UInt32*)length start:(UInt32)start;

// API
- (NSNumber*)connectionId;
- (void)addCustomHead:(CustomHead*)head;

// qq event
- (BOOL)handleGetCustomHeadDataOK:(QQNotification*)event;

@end
