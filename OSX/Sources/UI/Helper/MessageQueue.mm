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

#import "MessageQueue.h"
#import "ReceivedIMPacket.h"

@implementation MessageQueue

- (id) init {
	self = [super init];
	if (self != nil) {
		m_queue = [[NSMutableArray array] retain];
		m_systemMessageCount = 0;
		m_clusterExcludeList = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_queue release];
	[m_clusterExcludeList release];
	[super dealloc];
}

- (void)enqueue:(InPacket*)packet {
	[m_queue addObject:packet];
	if([packet isSystemMessage])
		m_systemMessageCount++;
}

- (void)moveToTop:(InPacket*)packet {
	if([m_queue containsObject:packet]) {
		[m_queue removeObject:packet];
		[m_queue insertObject:packet atIndex:0];
	}
}

- (void)moveFirstUserMessageToFront:(UInt32)QQ {
	InPacket* packet = [self getUserMessage:QQ remove:YES];
	if(packet)
		[m_queue insertObject:packet atIndex:0];
}

- (void)moveFirstTempSessionMessageToFront:(UInt32)QQ {
	InPacket* packet = [self getTempSessionMessage:QQ remove:YES];
	if(packet)
		[m_queue insertObject:packet atIndex:0];
}

- (void)moveFirstClusterMessageToFront:(UInt32)internalId {
	InPacket* packet = [self getClusterMessage:internalId remove:YES];
	if(packet)
		[m_queue insertObject:packet atIndex:0];
}

- (void)moveFirstMobileMessageToFront:(UInt32)QQ {
	InPacket* packet = [self getMobileMessage:QQ remove:YES];
	if(packet)
		[m_queue insertObject:packet atIndex:0];
}

- (void)moveFristMobileMessageToFrontByMobile:(NSString*)mobile {
	InPacket* packet = [self getMobileMessageByMobile:mobile remove:YES];
	if(packet)
		[m_queue insertObject:packet atIndex:0];
}

- (int)pendingMessageCount {
	if([m_clusterExcludeList count] == 0)
		return [m_queue count];
	else {
		int count = [m_queue count];
		for(int i = count - 1; i >= 0; i--) {
			InPacket* packet = [m_queue objectAtIndex:i];
			if([packet isMemberOfClass:[ReceivedIMPacket class]]) {
				ReceivedIMPacketHeader* header = [(ReceivedIMPacket*)packet imHeader];
				switch([header type]) {
					case kQQIMTypeCluster:
					case kQQIMTypeTempCluster:
					case kQQIMTypeClusterUnknown:
						if([m_clusterExcludeList containsObject:[NSNumber numberWithUnsignedInt:[header sender]]])
							count--;
						break;
				}
			}
		}
		return count;
	}
}

- (int)systemMessageCount {
	return m_systemMessageCount;
}

- (InPacket*)getMessage:(BOOL)remove {
	int count = [m_queue count];
	if(count > 0) {
		for(int i = 0; i < count; i++) {
			InPacket* packet = [m_queue objectAtIndex:i];
			
			// special care for cluster message, because user can block cluster message
			// check exclude cluster list, to skip excluded cluster message
			if([packet isClusterMessage]) {
				if([m_clusterExcludeList containsObject:[packet packetOwner]])
					continue;
			}
			
			// if system message, decrease count
			if(remove) {
				[[packet retain] autorelease];
				[m_queue removeObjectAtIndex:i];
				if([packet isSystemMessage])
					m_systemMessageCount--;
			}
			
			return packet;
		}
	} 
	
	return nil;
}

- (InPacket*)getUserMessage:(UInt32)QQ remove:(BOOL)remove {
	int count = [m_queue count];
	for(int i = 0; i < count; i++) {
		InPacket* inPacket = [m_queue objectAtIndex:i];
		if([inPacket isMemberOfClass:[ReceivedIMPacket class]]) {
			ReceivedIMPacketHeader* header = [(ReceivedIMPacket*)inPacket imHeader];
			switch([header type]) {
				case kQQIMTypeFriend:
				case kQQIMTypeFriendEx:
				case kQQIMTypeStranger:
				case kQQIMTypeStrangerEx:
					if([header sender] == QQ) {
						[inPacket retain];
						if(remove)
							[m_queue removeObjectAtIndex:i];
						return [inPacket autorelease];
					}
					break;
			}
		}
	}
	return nil;
}

- (InPacket*)getTempSessionMessage:(UInt32)QQ remove:(BOOL)remove {
	int count = [m_queue count];
	for(int i = 0; i < count; i++) {
		InPacket* inPacket = [m_queue objectAtIndex:i];
		if([inPacket isMemberOfClass:[ReceivedIMPacket class]]) {
			ReceivedIMPacketHeader* header = [(ReceivedIMPacket*)inPacket imHeader];
			switch([header type]) {
				case kQQIMTypeTempSession:
					if([header sender] == QQ) {
						[inPacket retain];
						if(remove)
							[m_queue removeObjectAtIndex:i];
						return [inPacket autorelease];
					}
					break;
			}
		}
	}
	return nil;
}

- (InPacket*)getMobileMessage:(UInt32)QQ remove:(BOOL)remove {
	int count = [m_queue count];
	for(int i = 0; i < count; i++) {
		InPacket* inPacket = [m_queue objectAtIndex:i];
		if([inPacket isMemberOfClass:[ReceivedIMPacket class]]) {
			ReceivedIMPacketHeader* header = [(ReceivedIMPacket*)inPacket imHeader];
			switch([header type]) {
				case kQQIMTypeMobileQQ:
					if([header sender] == QQ) {
						[inPacket retain];
						if(remove)
							[m_queue removeObjectAtIndex:i];
						return [inPacket autorelease];
					}
					break;
			}
		}
	}
	return nil;
}

- (InPacket*)getMobileMessageByMobile:(NSString*)mobile remove:(BOOL)remove {
	int count = [m_queue count];
	for(int i = 0; i < count; i++) {
		InPacket* inPacket = [m_queue objectAtIndex:i];
		if([inPacket isMemberOfClass:[ReceivedIMPacket class]]) {
			ReceivedIMPacketHeader* header = [(ReceivedIMPacket*)inPacket imHeader];
			switch([header type]) {
				case kQQIMTypeMobileQQ2:
					MobileIM* mobileIM = [(ReceivedIMPacket*)inPacket mobileIM];
					if([[mobileIM mobile] isEqualToString:mobile]) {
						[inPacket retain];
						if(remove)
							[m_queue removeObjectAtIndex:i];
						return [inPacket autorelease];
					}
					break;
			}
		}
	}
	return nil;
}

- (void)removeMessageFromUser:(UInt32)QQ {
	//
	// remove all messages from a user
	// this is used when you move a user to blacklist
	//
	
	int count = [m_queue count];
	for(int i = count - 1; i >= 0; i--) {
		InPacket* inPacket = [m_queue objectAtIndex:i];
		if([inPacket isMemberOfClass:[ReceivedIMPacket class]]) {
			ReceivedIMPacketHeader* header = [(ReceivedIMPacket*)inPacket imHeader];
			switch([header type]) {
				case kQQIMTypeFriend:
				case kQQIMTypeFriendEx:
				case kQQIMTypeStranger:
				case kQQIMTypeStrangerEx:
				case kQQIMTypeMobileQQ:
				case kQQIMTypeTempSession:
					if([header sender] == QQ) {
						[m_queue removeObjectAtIndex:i];
					}
					break;
			}
		}
	}
}

- (InPacket*)getClusterMessage:(UInt32)internalId remove:(BOOL)remove {
	int count = [m_queue count];
	for(int i = 0; i < count; i++) {
		InPacket* inPacket = [m_queue objectAtIndex:i];
		if([inPacket isMemberOfClass:[ReceivedIMPacket class]]) {
			ReceivedIMPacketHeader* header = [(ReceivedIMPacket*)inPacket imHeader];
			switch([header type]) {
				case kQQIMTypeCluster:
				case kQQIMTypeTempCluster:
				case kQQIMTypeClusterUnknown:
					if([header sender] == internalId) {
						[inPacket retain];
						if(remove)
							[m_queue removeObjectAtIndex:i];
						return [inPacket autorelease];
					}
					break;
			}
		}
	}
	return nil;
}

- (BOOL)moveNextSystemMessageToFirst {
	int count = [m_queue count];
	for(int i = 0; i < count; i++) {
		InPacket* inPacket = [m_queue objectAtIndex:i];
		if([inPacket isSystemMessage]) {
			[inPacket retain];
			[m_queue removeObjectAtIndex:i];
			[m_queue insertObject:inPacket atIndex:0];
			[inPacket release];
			return YES;
		}
	}
	
	return NO;
}

- (void)setExcludeClusterInUnread:(UInt32)internalId {
	NSNumber* cId = [NSNumber numberWithUnsignedInt:internalId];
	if(![m_clusterExcludeList containsObject:cId])
		[m_clusterExcludeList addObject:cId];
}

- (void)restoreClusterInUnread:(UInt32)internalId {
	[m_clusterExcludeList removeObject:[NSNumber numberWithUnsignedInt:internalId]];
}

@end
