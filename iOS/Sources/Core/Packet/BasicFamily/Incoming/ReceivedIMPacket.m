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

#import "ReceivedIMPacket.h"
#import "CustomHead.h"
#import "ByteTool.h"

#define _kKeyIMHeader @"ReceivedIMPacket_IMHeader"
#define _kKeyNormalIMHeader @"ReceivedIMPacket_NormalIMHeader"
#define _kKeyNormalIM @"ReceivedIMPacket_NormalIM"
#define _kKeyClusterIM @"ReceivedIMPacket_ClusterIM"
#define _kKeyMobileIM @"ReceivedIMPacket_MobileIM"
#define _kKeyClusterNotification @"ReceivedIMPacket_ClusterNotification"
#define _kKeyTempSesionIM @"ReceivedIMPacket_TempSesionIM"

@implementation ReceivedIMPacket

- (void) dealloc {
	[m_imHeader release];
	[m_normalIM release];
	[m_normalIMHeader release];
	[m_clusterIM release];
	[m_mobileIM release];
	[m_systemIM release];
	[m_tempSessionIM release];
	[m_clusterNotification release];
	[m_signatureNotification release];
	[m_customHeads release];
	[super dealloc];
}

- (BOOL)isServerInitiative {
	return YES;
}

- (void)parseBody:(ByteBuffer*)buf {
	// read header
	m_imHeader = [[ReceivedIMPacketHeader alloc] init];
	[m_imHeader read:buf];
	
	switch([m_imHeader type]) {
		case kQQIMTypeFriend:
		case kQQIMTypeStranger:
		case kQQIMTypeFriendEx:
		case kQQIMTypeStrangerEx:
			m_normalIMHeader = [[NormalIMHeader alloc] init];
			[m_normalIMHeader read:buf];
			switch([m_normalIMHeader normalIMType]) {
				case kQQNormalIMTypeText:
					if([m_imHeader type] == kQQIMTypeFriendEx || [m_imHeader type] == kQQIMTypeStrangerEx) {
						m_normalIM = [[NormalIM alloc] init];
						[m_normalIM readEx:buf];
					} else {
						m_normalIM = [[NormalIM alloc] init];
						[m_normalIM read:buf];
					}
					break;
			}
			break;
		case kQQIMTypeTempSession:
			m_tempSessionIM = [[TempSessionIM alloc] init];
			[m_tempSessionIM read:buf];
			break;
		case kQQIMTypeMobileQQ:
			m_mobileIM = [[MobileIM alloc] init];
			[m_mobileIM readMobileQQ:buf];
			break;
		case kQQIMTypeMobileQQ2:
			m_mobileIM = [[MobileIM alloc] init];
			[m_mobileIM readMobileQQ2:buf];
			break;
		case kQQIMTypeCluster:
			m_clusterIM = [[ClusterIM alloc] init];
			[m_clusterIM read:buf];
			break;
		case kQQIMTypeClusterUnknown:
			m_clusterIM = [[ClusterIM alloc] init];
			[m_clusterIM read0020:buf];
			break;
		case kQQIMTypeTempCluster:
			m_clusterIM = [[ClusterIM alloc] init];
			[m_clusterIM read002A:buf];
			
			// for temp cluster, the sender in header is still parent internal id
			// I think no good comes from this, so I set back to temp cluster internal id
			[m_imHeader setSender:[m_clusterIM internalId]];
			break;
		case kQQIMTypeJoinedCluster:
			m_clusterNotification = [[ClusterNotification alloc] init];
			[m_clusterNotification read0021:buf];
			break;
		case kQQIMTypeExitedCluster:
			m_clusterNotification = [[ClusterNotification alloc] init];
			[m_clusterNotification read0022:buf];
			break;
		case kQQIMTypeRequestJoinCluster:
			m_clusterNotification = [[ClusterNotification alloc] init];
			[m_clusterNotification read0023:buf];
			break;
		case kQQIMTypeApprovedJoinCluster:
			m_clusterNotification = [[ClusterNotification alloc] init];
			[m_clusterNotification read0024:buf];
			break;
		case kQQIMTypeRejectedJoinCluster:
			m_clusterNotification = [[ClusterNotification alloc] init];
			[m_clusterNotification read0025:buf];
			break;
		case kQQIMTypeClusterCreated:
			m_clusterNotification = [[ClusterNotification alloc] init];
			[m_clusterNotification read0026:buf];
			break;
		case kQQIMTypeClusterRoleChanged:
			m_clusterNotification = [[ClusterNotification alloc] init];
			[m_clusterNotification read002C:buf];
			break;
		case kQQIMTypeSystem:
			m_systemIM = [[SystemIM alloc] init];
			[m_systemIM read:buf];
			break;
		case kQQIMTypeSignatureChangedNotification:
			m_signatureNotification = [[SignatureChangedNotification alloc] init];
			[m_signatureNotification read:buf];
			break;
		case kQQIMTypeCustomHeadChangedNotification:
			m_customHeads = [[NSMutableArray array] retain];
			int count = [buf getByte] & 0xFF;
			while(count-- > 0) {
				CustomHead* head = [[[CustomHead alloc] init] autorelease];
				[head read:buf];
				[m_customHeads addObject:head];
			}
			break;
	}
}

- (void)encodeWithCoder:(NSCoder*)encoder {
	[encoder encodeObject:m_imHeader forKey:_kKeyIMHeader];
	
	switch([m_imHeader type]) {
		case kQQIMTypeFriend:
		case kQQIMTypeStranger:
		case kQQIMTypeFriendEx:
		case kQQIMTypeStrangerEx:
			[encoder encodeObject:m_normalIMHeader forKey:_kKeyNormalIMHeader];
			[encoder encodeObject:m_normalIM forKey:_kKeyNormalIM];
			break;
		case kQQIMTypeTempSession:
			[encoder encodeObject:m_tempSessionIM forKey:_kKeyTempSesionIM];
			break;
		case kQQIMTypeCluster:
		case kQQIMTypeTempCluster:
		case kQQIMTypeClusterUnknown:
			[encoder encodeObject:m_clusterIM forKey:_kKeyClusterIM];
			break;
		case kQQIMTypeMobileQQ:
		case kQQIMTypeMobileQQ2:
			[encoder encodeObject:m_mobileIM forKey:_kKeyMobileIM];
			break;
		case kQQIMTypeJoinedCluster:
		case kQQIMTypeExitedCluster:
		case kQQIMTypeRequestJoinCluster:
		case kQQIMTypeApprovedJoinCluster:
		case kQQIMTypeRejectedJoinCluster:
		case kQQIMTypeClusterCreated:
		case kQQIMTypeClusterRoleChanged:
			[encoder encodeObject:m_clusterNotification forKey:_kKeyClusterNotification];
			break;
	}
	
	[super encodeWithCoder:encoder];
}

- (id)initWithCoder:(NSCoder*)decoder {
	m_imHeader = [[decoder decodeObjectForKey:_kKeyIMHeader] retain];
	
	switch([m_imHeader type]) {
		case kQQIMTypeFriend:
		case kQQIMTypeStranger:
		case kQQIMTypeFriendEx:
		case kQQIMTypeStrangerEx:
			m_normalIMHeader = [[decoder decodeObjectForKey:_kKeyNormalIMHeader] retain];
			m_normalIM = [[decoder decodeObjectForKey:_kKeyNormalIM] retain];
			break;
		case kQQIMTypeTempSession:
			m_tempSessionIM = [[decoder decodeObjectForKey:_kKeyTempSesionIM] retain];
			break;
		case kQQIMTypeCluster:
		case kQQIMTypeTempCluster:
		case kQQIMTypeClusterUnknown:
			m_clusterIM = [[decoder decodeObjectForKey:_kKeyClusterIM] retain];
			break;
		case kQQIMTypeMobileQQ:
		case kQQIMTypeMobileQQ2:
			m_mobileIM = [[decoder decodeObjectForKey:_kKeyMobileIM] retain];
			break;
		case kQQIMTypeJoinedCluster:
		case kQQIMTypeExitedCluster:
		case kQQIMTypeRequestJoinCluster:
		case kQQIMTypeApprovedJoinCluster:
		case kQQIMTypeRejectedJoinCluster:
		case kQQIMTypeClusterCreated:
		case kQQIMTypeClusterRoleChanged:
			m_clusterNotification = [[decoder decodeObjectForKey:_kKeyClusterNotification] retain];
			break;
	}
	
	return [super initWithCoder:decoder];
}

- (BOOL)isSystemMessage {
	switch([m_imHeader type]) {
		case kQQIMTypeJoinedCluster:
		case kQQIMTypeExitedCluster:
		case kQQIMTypeRequestJoinCluster:
		case kQQIMTypeApprovedJoinCluster:
		case kQQIMTypeRejectedJoinCluster:
		case kQQIMTypeClusterCreated:
		case kQQIMTypeClusterRoleChanged:
			return YES;
	}
	
	return NO;
}

- (BOOL)isClusterMessage {
	switch([m_imHeader type]) {
		case kQQIMTypeCluster:
		case kQQIMTypeTempCluster:
		case kQQIMTypeClusterUnknown:
			return YES;
	}
	
	return NO;
}

- (id)packetOwner {
	return [NSNumber numberWithUnsignedInt:[m_imHeader sender]];
}

#pragma mark -
#pragma mark getter and setter

- (ReceivedIMPacketHeader*)imHeader {
	return m_imHeader;
}

- (NormalIMHeader*)normalIMHeader {
	return m_normalIMHeader;
}

- (NormalIM*)normalIM {
	return m_normalIM;
}

- (ClusterIM*)clusterIM {
	return m_clusterIM;
}

- (MobileIM*)mobileIM {
	return m_mobileIM;
}

- (SystemIM*)systemIM {
	return m_systemIM;
}

- (ClusterNotification*)clusterNotification {
	return m_clusterNotification;
}

- (SignatureChangedNotification*)signatureNotification {
	return m_signatureNotification;
}

- (TempSessionIM*)tempSessionIM {
	return m_tempSessionIM;
}

- (NSArray*)customHeads {
	return m_customHeads;
}

- (NSData*)messageData {
	switch([m_imHeader type]) {
		case kQQIMTypeFriend:
		case kQQIMTypeStranger:
		case kQQIMTypeFriendEx:
		case kQQIMTypeStrangerEx:
			switch([m_normalIMHeader normalIMType]) {
				case kQQNormalIMTypeText:
					return [m_normalIM messageData];
			}
			break;
		case kQQIMTypeTempSession:
			return [m_tempSessionIM messageData];
		case kQQIMTypeCluster:
		case kQQIMTypeClusterUnknown:
		case kQQIMTypeTempCluster:
			return [m_clusterIM messageData];
	}
	return nil;
}

- (UInt32)sendTime {
	switch([m_imHeader type]) {
		case kQQIMTypeFriend:
		case kQQIMTypeStranger:
		case kQQIMTypeFriendEx:
		case kQQIMTypeStrangerEx:
			switch([m_normalIMHeader normalIMType]) {
				case kQQNormalIMTypeText:
					return [m_normalIM sendTime];
			}
			break;
		case kQQIMTypeTempSession:
			return [m_tempSessionIM sendTime];
		case kQQIMTypeCluster:
		case kQQIMTypeClusterUnknown:
		case kQQIMTypeTempCluster:
			return [m_clusterIM sendTime];
	}
	return 0;
}

- (void)debug {
	switch([m_imHeader type]) {
		case kQQIMTypeFriend:
		case kQQIMTypeStranger:
		case kQQIMTypeFriendEx:
		case kQQIMTypeStrangerEx:
			NSLog(@"IM - Friend - Sender %u - Message %@", [m_normalIMHeader sender], [ByteTool getString:[[m_normalIM messageData] bytes] length:[[m_normalIM messageData] length]]);
			break;
		case kQQIMTypeTempSession:
			NSLog(@"IM - TempSession - Sender %u - Message %@", [m_tempSessionIM sender], [ByteTool getString:[[m_tempSessionIM messageData] bytes] length:[[m_tempSessionIM messageData] length]]);
			break;
		case kQQIMTypeMobileQQ2:
		case kQQIMTypeMobileQQ:
			NSLog(@"IM - Mobile - Sender %@ - Message %@", [m_mobileIM name], [m_mobileIM message]);
			break;
		case kQQIMTypeTempCluster:
		case kQQIMTypeClusterUnknown:
		case kQQIMTypeCluster:
			NSLog(@"IM - Cluster - Sender %u - Message %@", [m_clusterIM sender], [ByteTool getString:[[m_clusterIM messageData] bytes] length:[[m_clusterIM messageData] length]]);
			break;
		case kQQIMTypeJoinedCluster:
			NSLog(@"IM - JoinedCluster - Source %u", [m_clusterNotification sourceQQ]);
			break;
		case kQQIMTypeExitedCluster:
			NSLog(@"IM - ExitedCluster - Source %u", [m_clusterNotification sourceQQ]);
			break;
		case kQQIMTypeRequestJoinCluster:
			NSLog(@"IM - RequestJoinCluster - Source %u", [m_clusterNotification sourceQQ]);
			break;
		case kQQIMTypeApprovedJoinCluster:
			NSLog(@"IM - ApprovedJoinCluster - Source %u", [m_clusterNotification sourceQQ]);
			break;
		case kQQIMTypeRejectedJoinCluster:
			NSLog(@"IM - RejectedJoinCluster - Source %u", [m_clusterNotification sourceQQ]);
			break;
		case kQQIMTypeClusterCreated:
			NSLog(@"IM - ClusterCreated - Source %u", [m_clusterNotification sourceQQ]);
			break;
		case kQQIMTypeClusterRoleChanged:
			NSLog(@"IM - ClusterRoleChanged - Source %u", [m_clusterNotification sourceQQ]);
			break;
		case kQQIMTypeSystem:
			NSLog(@"IM - System - Message %@", [m_systemIM message]);
			break;
		case kQQIMTypeSignatureChangedNotification:
			NSLog(@"IM - SignatureChanged - Source %u", [m_signatureNotification QQ]);
			break;
		case kQQIMTypeCustomHeadChangedNotification:
			NSLog(@"IM - CustomHeadChanged");
			break;
		default:
			NSLog(@"IM - Unknown %d", [m_imHeader type]);
			break;
	}
}

@end
