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
#import "SystemNotificationPacket.h"

typedef enum {
	kIMPushed,
	kIMSilentPushed,
	kIMNotPushed,
	kSysIMPushed
} MessagePushFlag;

@class UIMain, ReceivedIMPacket, User, Cluster;

@interface MessageManager : NSObject {
	NSMutableDictionary* _userMsgMap;
	NSMutableDictionary* _clusterMsgMap;
	NSMutableArray* _keyLink;
	NSMutableArray* _sysMsgs;
	int _messageCount;
	
	UIMain* _main;
	id _delegate;
}

- (id)initWithMain:(UIMain*)main;

- (MessagePushFlag)put:(ReceivedIMPacket*)packet;
- (MessagePushFlag)putSystemNotification:(SystemNotificationPacket*)packet;
- (int)itemCount;
- (int)systemItemCount;
- (int)messageCount;
- (int)displayableMessageCount;
- (id)linearLocate:(int)index;
- (NSArray*)userMessages:(User*)user;
- (NSArray*)clusterMessages:(Cluster*)cluster;
- (int)userMessageCount:(User*)user;
- (int)clusterMessageCount:(Cluster*)cluster;
- (void)removeUserMessages:(User*)user;
- (void)removeClusterMessages:(Cluster*)cluster;
- (void)removeSystemMessage:(NSDictionary*)dict;
- (void)reset;
- (id)delegate;
- (void)setDelegate:(id)delegate;
- (void)saveUnread;
- (void)loadUnread;

- (void)_putIM:(NSDictionary*)dict forCluster:(Cluster*)cluster;
- (void)_putIM:(NSDictionary*)dict forUser:(User*)user;
- (void)_putSystemIM:(NSDictionary*)dict;

@end
