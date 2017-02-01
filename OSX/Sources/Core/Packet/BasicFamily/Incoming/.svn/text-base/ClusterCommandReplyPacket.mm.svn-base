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

#import "ClusterCommandReplyPacket.h"

@implementation ClusterCommandReplyPacket

- (void) dealloc {
	[m_info release];
	[m_members release];
	[m_errorMessage release];
	[m_subClusters release];
	[m_organizations release];
	[m_memberInfos release];
	[m_memberQQs release];
	[m_infos release];
	[m_clusterNameCard release];
	[m_clusterNameCards release];
	[m_messageSettings release];
	[m_lastTalkTimes release];
	[super dealloc];
}

- (void)parseBody:(ByteBuffer*)buf {
	m_subCommand = [buf getByte];
	m_reply = [buf getByte];
	switch(m_subCommand) {
		case kQQSubCommandClusterCreate: 		
			[self parseCreate:buf];
			break;
		case kQQSubCommandClusterModifyMember: 	
			[self parseModifyMember:buf];
			break;
		case kQQSubCommandClusterModifyInfo: 	
			[self parseModifyInfo:buf];
			break;
		case kQQSubCommandClusterGetInfo: 	
			[self parseGetInfo:buf];
			break;
		case kQQSubCommandClusterActivate: 		
			[self parseActivate:buf];
			break;
		case kQQSubCommandClusterSearch: 		
			[self parseSearch:buf];
			break;
		case kQQSubCommandClusterJoin: 		
			[self parseJoin:buf];
			break;
		case kQQSubCommandClusterAuthorize: 		
			[self parseAuthorize:buf];
			break;
		case kQQSubCommandClusterExit: 		
			[self parseExit:buf];
			break;
		case kQQSubCommandClusterGetOnlineMember: 	
			[self parseGetOnlineMember:buf];
			break;
		case kQQSubCommandClusterGetMemberInfo: 		
			[self parseGetMemberInfo:buf];
			break;
		case kQQSubCommandClusterModifyCard: 		
			[self parseModifyCard:buf];
			break;
		case kQQSubCommandClusterBatchGetCard: 		
			[self parseBatchGetCard:buf];
			break;
		case kQQSubCommandClusterGetCard: 		
			[self parseGetCard:buf];
			break;
		case kQQSubCommandClusterCommitOrganization: 		
			[self parseCommitOrganization:buf];
			break;
		case kQQSubCommandClusterUpdateOrganization: 		
			[self parseUpdateOrganization:buf];
			break;
		case kQQSubCommandClusterCommitMemberGroup: 		
			[self parseCommitMemberGroup:buf];
			break;
		case kQQSubCommandClusterGetVersionID: 		
			[self parseGetVersionID:buf];
			break;
		case kQQSubCommandClusterSendIMEx: 		
			[self parseSendIMEx:buf];
			break;
		case kQQSubCommandClusterSetRole: 		
			[self parseSetRole:buf];
			break;
		case kQQSubCommandClusterTransferRole: 		
			[self parseTransferRole:buf];
			break;
		case kQQSubCommandClusterDismiss: 		
			[self parseDismiss:buf];
			break;
		case kQQSubCommandTempClusterCreate: 		
			[self parseTempCreate:buf];
			break;
		case kQQSubCommandTempClusterModifyMember: 		
			[self parseTempModifyMember:buf];
			break;
		case kQQSubCommandTempClusterExit: 		
			[self parseTempExit:buf];
			break;
		case kQQSubCommandTempClusterGetInfo: 		
			[self parseTempGetInfo:buf];
			break;
		case kQQSubCommandTempClusterModifyInfo: 		
			[self parseTempModifyInfo:buf];
			break;
		case kQQSubCommandTempClusterSendIM: 		
			[self parseTempSendIM:buf];
			break;
		case kQQSubCommandClusterSubOp: 		
			[self parseSubOp:buf];
			break;
		case kQQSubCommandTempClusterActivate: 	
			[self parseTempActivate:buf];
			break;
		case kQQSubCommandClusterGetMessageSetting:
			[self parseGetMessageSetting:buf];
			break;
		case kQQSubCommandClusterModifyMessageSetting:
			[self parseModifyMessageSetting:buf];
			break;
		case kQQSubCommandClusterModifyChannelSetting:
			[self parseModifyChannelSetting:buf];
			break;
		case kQQSubCommandClusterGetChannelSetting:
			[self parseGetChannelSetting:buf];
			break;
		case kQQSubCommandClusterGetLastTalkTime:
			[self parseGetLastTalkTime:buf];
			break;
	}
	
	// if not successful
	if(m_reply != kQQReplyOK) {
		switch(m_subCommand) {
			case kQQSubCommandClusterTransferRole:
				m_internalId = [buf getUInt32];
				m_memberQQ = [buf getUInt32];
				m_errorMessage = [[buf getString] retain];
				break;
			case kQQSubCommandClusterSetRole:
				m_internalId = [buf getUInt32];
				m_errorMessage = [[buf getString] retain];
				break;
			case kQQSubCommandClusterGetCard:
				m_internalId = [buf getUInt32];
				m_memberQQ = [buf getUInt32];
				int len = [buf getByte] & 0xFF;
				m_errorMessage = [[buf getString:len] retain];
				break;
			default:
				m_errorMessage = [[buf getString] retain];
				break;
		}
	}
}

#pragma mark -
#pragma mark parse

- (void)parseCreate:(ByteBuffer*)buf {
}

- (void)parseModifyMember:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK)
		m_internalId = [buf getUInt32];
}

- (void)parseModifyInfo:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK)
		m_internalId = [buf getUInt32];
}

- (void)parseGetInfo:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_info = [[ClusterInfo alloc] init];
		[m_info read:buf];
		
		m_externalId = [m_info externalId];
		m_internalId = [m_info internalId];
		m_parentId = [m_info parentId];
		
		m_members = [[NSMutableArray array] retain];
		while([buf hasAvailable]) {
			Member* m = [[Member alloc] init];
			[m read:buf];
			[m_members addObject:m];
			[m release];
		}
	}
}

- (void)parseActivate:(ByteBuffer*)buf {
	if(m_reply = kQQReplyOK)
		m_internalId = [buf getUInt32];
}

- (void)parseSearch:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_subSubCommand = [buf getByte];
		
		m_infos = [[NSMutableArray array] retain];
		while([buf hasAvailable]) {
			ClusterInfo* info = [[ClusterInfo alloc] init];
			[info readSearchResult:buf];
			[m_infos addObject:info];
			[info release];
		}
	}
}

- (void)parseJoin:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_internalId = [buf getUInt32];
		m_authType = [buf getByte];
	}
}

- (void)parseAuthorize:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK)
		m_internalId = [buf getUInt32];
}

- (void)parseExit:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK)
		m_internalId = [buf getUInt32];
}

- (void)parseGetOnlineMember:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_internalId = [buf getUInt32];
		[buf skip:1];
		
		m_memberQQs = [[NSMutableArray array] retain];
		while([buf hasAvailable]) {
			[m_memberQQs addObject:[NSNumber numberWithUnsignedInt:[buf getUInt32]]];
		}
	}
}

- (void)parseGetMemberInfo:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_internalId = [buf getUInt32];
	
		m_memberInfos = [[NSMutableArray array] retain];
		while([buf hasAvailable]) {
			Friend* f = [[Friend alloc] init];
			[f readMember:buf];
			[m_memberInfos addObject:f];
			[f release];
		}
	}
}

- (void)parseModifyCard:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_internalId = [buf getUInt32];
		[buf skip:4];		
	}
}

- (void)parseBatchGetCard:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_internalId = [buf getUInt32];
		m_clusterNameCardVersionId = [buf getUInt32];
		m_nextStartPosition = [buf getUInt32];
		
		m_clusterNameCards = [[NSMutableArray array] retain];
		while([buf hasAvailable]) {
			ClusterNameCard* card = [[ClusterNameCard alloc] init];
			[card readBatch:buf];
			[m_clusterNameCards addObject:card];
			[card release];
		}		
	}
}

- (void)parseGetCard:(ByteBuffer*)buf {	
	m_clusterNameCard = [[ClusterNameCard alloc] init];
	if(m_reply == kQQReplyOK) {
		m_internalId = [buf getUInt32];
		[m_clusterNameCard read:buf];
	} 
}

- (void)parseCommitOrganization:(ByteBuffer*)buf {
}

- (void)parseUpdateOrganization:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_internalId = [buf getUInt32];
		[buf skip:1];
		m_organizationVersion = [buf getUInt32];
		
		m_organizations = [[NSMutableArray array] retain];
		if(m_organizationVersion > 0) {
			int count = [buf getByte] & 0xFF;
			for(int i = 0; i < count; i++) {
				QQOrganization* org = [[QQOrganization alloc] init];
				[org read:buf];
				[m_organizations addObject:org];
				[org release];
			}
		}		
	}
}

- (void)parseCommitMemberGroup:(ByteBuffer*)buf {
}

- (void)parseGetVersionID:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_internalId = [buf getUInt32];
		[buf skip:4];
		[buf skip:4];
		m_clusterNameCardVersionId = [buf getUInt32];
		[buf skip:4];
	}
}

- (void)parseSendIMEx:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK)
		m_internalId = [buf getUInt32];
}

- (void)parseSetRole:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_internalId = [buf getUInt32];
		m_clusterVersionId = [buf getUInt32];
		m_memberQQ = [buf getUInt32];
		m_memberRole = [buf getByte];
	}
}

- (void)parseTransferRole:(ByteBuffer*)buf {	
	if(m_reply == kQQReplyOK) {
		m_internalId = [buf getUInt32];
		m_memberQQ = [buf getUInt32];
		m_clusterVersionId = [buf getUInt32];
	}
}

- (void)parseDismiss:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_internalId = [buf getUInt32];
	}
}

- (void)parseTempCreate:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_tempClusterType = [buf getByte];
		m_parentId = [buf getUInt32];
		m_internalId = [buf getUInt32];
	}
}

- (void)parseTempModifyMember:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_tempClusterType = [buf getByte];
		m_parentId = [buf getUInt32];
		m_internalId = [buf getUInt32];
	}
}

- (void)parseTempExit:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_tempClusterType = [buf getByte];
		m_parentId = [buf getUInt32];
		m_internalId = [buf getUInt32];
	}
}

- (void)parseTempGetInfo:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_info = [[ClusterInfo alloc] init];
		[m_info readTemp:buf];
		
		m_externalId = [m_info externalId];
		m_internalId = [m_info internalId];
		m_parentId = [m_info parentId];
		
		m_members = [[NSMutableArray array] retain];
		while([buf hasAvailable]) {
			Member* m = [[Member alloc] init];
			[m readTemp:buf];
			[m_members addObject:m];
			[m release];
		}		
	}
}

- (void)parseTempModifyInfo:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_tempClusterType = [buf getByte];
		m_parentId = [buf getUInt32];
		m_internalId = [buf getUInt32];
	}
}

- (void)parseTempSendIM:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_tempClusterType = [buf getByte];
		m_parentId = [buf getUInt32];
		m_internalId = [buf getUInt32];
	}
}

- (void)parseSubOp:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_subSubCommand = [buf getByte];
		m_internalId = [buf getUInt32];
		m_externalId = [buf getUInt32];
		
		m_subClusters = [[NSMutableArray array] retain];
		while([buf hasAvailable]) {
			SubCluster* sc = [[SubCluster alloc] init];
			[sc read:buf];
			[m_subClusters addObject:sc];
			[sc release];
		}		
	}
}

- (void)parseTempActivate:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_tempClusterType = [buf getByte];
		m_parentId = [buf getUInt32];
		m_internalId = [buf getUInt32];
		
		m_memberQQs = [[NSMutableArray array] retain];
		while([buf hasAvailable]) {
			[m_memberQQs addObject:[NSNumber numberWithUnsignedInt:[buf getUInt32]]];
		}
	}
}

- (void)parseGetMessageSetting:(ByteBuffer*)buf {
	m_messageSettings = [[NSMutableArray array] retain];
	if(m_reply == kQQReplyOK) {
		int count = [buf getByte] & 0xFF;
		while(count-- > 0) {
			ClusterMessageSetting* setting = [[ClusterMessageSetting alloc] init];
			[setting read:buf];
			[m_messageSettings addObject:setting];
			[setting release];
		}		
	}
}

- (void)parseModifyMessageSetting:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_internalId = [buf getUInt32];
		m_externalId = [buf getUInt32];				
	}
}

- (void)parseModifyChannelSetting:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK)
		m_internalId = [buf getUInt32];
}

- (void)parseGetChannelSetting:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		m_internalId = [buf getUInt32];
		m_externalId = [buf getUInt32];
		m_mask = [buf getUInt32];
		if((m_mask & kQQClusterOperationMaskNotificationRight) != 0)
			m_notificationRight = [buf getByte];
		if((m_mask & kQQClusterOperationMaskChannel) != 0)
			m_defaultChannelId = [buf getUInt32];
	}
}

- (void)parseGetLastTalkTime:(ByteBuffer*)buf {
	if(m_reply == kQQReplyOK) {
		[buf skip:1];
		m_internalId = [buf getUInt32];
		m_externalId = [buf getUInt32];
		
		int count = [buf getUInt16];
		m_lastTalkTimes = [[NSMutableArray array] retain];
		while(count-- > 0) {
			LastTalkTime* time = [[LastTalkTime alloc] init];
			[time read:buf];
			[m_lastTalkTimes addObject:time];
			[time release];
		}
	}
}

#pragma mark -
#pragma mark getter nad setter

- (NSString*)errorMessage {
	return m_errorMessage;
}

- (UInt32)memberQQ {
	return m_memberQQ;
}

- (char)subSubCommand {
	return m_subSubCommand;
}

- (UInt32)internalId {
	return m_internalId;
}

- (UInt32)externalId {
	return m_externalId;
}

- (UInt32)parentId {
	return m_parentId;
}

- (ClusterInfo*)info {
	return m_info;
}

- (NSArray*)members {
	return m_members;
}

- (NSArray*)subClusters {
	return m_subClusters;
}

- (NSArray*)organizations {
	return m_organizations;
}

- (UInt32)organizationVersion {
	return m_organizationVersion;
}

- (NSArray*)memberInfos {
	return m_memberInfos;
}

- (NSArray*)memberQQs {
	return m_memberQQs;
}

- (NSArray*)infos {
	return m_infos;
}

- (ClusterNameCard*)clusterNameCard {
	return m_clusterNameCard;
}

- (UInt32)clusterNameCardVersionId {
	return m_clusterNameCardVersionId;
}

- (NSArray*)clusterNameCards {
	return m_clusterNameCards;
}

- (UInt32)nextStartPosition {
	return m_nextStartPosition;
}

- (NSArray*)messageSettings {
	return m_messageSettings;
}

- (UInt32)mask {
	return m_mask;
}

- (char)notificationRight {
	return m_notificationRight;
}

- (UInt32)defaultChannelId {
	return m_defaultChannelId;
}

- (NSArray*)lastTalkTimes {
	return m_lastTalkTimes;
}

- (char)tempClusterType {
	return m_tempClusterType;
}

- (UInt32)clusterVersionId {
	return m_clusterVersionId;
}

- (char)memberRole {
	return m_memberRole;
}

- (char)authType {
	return m_authType;
}

@end