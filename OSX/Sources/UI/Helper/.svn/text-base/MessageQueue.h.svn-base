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
#import "InPacket.h"

@interface MessageQueue : NSObject {
	NSMutableArray* m_queue;
	
	int m_systemMessageCount;
	NSMutableArray* m_clusterExcludeList;
}

- (int)pendingMessageCount;
- (int)systemMessageCount;
- (void)enqueue:(InPacket*)packet;
- (void)moveToTop:(InPacket*)packet;
- (void)moveFirstUserMessageToFront:(UInt32)QQ;
- (void)moveFirstTempSessionMessageToFront:(UInt32)QQ;
- (void)moveFirstClusterMessageToFront:(UInt32)internalId;
- (void)moveFirstMobileMessageToFront:(UInt32)QQ;
- (void)moveFristMobileMessageToFrontByMobile:(NSString*)mobile;
- (InPacket*)getMessage:(BOOL)remove;
- (InPacket*)getUserMessage:(UInt32)QQ remove:(BOOL)remove;
- (InPacket*)getTempSessionMessage:(UInt32)QQ remove:(BOOL)remove;
- (InPacket*)getMobileMessage:(UInt32)QQ remove:(BOOL)remove;
- (InPacket*)getMobileMessageByMobile:(NSString*)mobile remove:(BOOL)remove;
- (InPacket*)getClusterMessage:(UInt32)internalId remove:(BOOL)remove;
- (void)removeMessageFromUser:(UInt32)QQ;
- (BOOL)moveNextSystemMessageToFirst;
- (void)setExcludeClusterInUnread:(UInt32)internalId;
- (void)restoreClusterInUnread:(UInt32)internalId;

@end
