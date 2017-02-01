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

#import <Foundation/Foundation.h>
#import "QQListener.h"
#import "IMServiceCallback.h"

@class QQClient;

@interface IMService : NSObject <QQListener> {
	QQClient* _client;
	
	// message send queue and sending related variables
	NSMutableArray* _sendQueue;
	NSMutableArray* _objQueue;
	NSMutableArray* _callbackQueue;
	BOOL _sending;
	UInt16 _waitingSequence;
	int _fragmentCount;
	int _nextFragmentIndex;
	NSMutableData* _msgData;
}

// init
- (id)initWithClient:(QQClient*)client;

- (void)send:(NSString*)msg to:(id)obj callback:(id<IMServiceCallback>)callback;

- (void)_sendNextMessage;

- (BOOL)handleSendIMOK:(QQNotification*)event;
- (BOOL)handleSendIMTimeout:(QQNotification*)event;
- (BOOL)handleClusterSendIMFailed:(QQNotification*)event;
- (BOOL)handleClusterSendIMOK:(QQNotification*)event;
- (BOOL)handleClusterSendIMTimeout:(QQNotification*)event;

@end
