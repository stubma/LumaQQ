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

#import "LocalizedStringTool.h"
#import "ReceivedIMPacket.h"
#import "SystemNotificationPacket.h"
#import "Constants.h"

NSString* L(NSString* key) {
	return NSLocalizedString(key, nil);
}

NSString* LT(NSString* key, NSString* table) {
	return NSLocalizedStringFromTable(key, table, nil);
}

NSString* SM(InPacket* inPacket, NSString* clusterName, UInt32 userQQ) {
	if([inPacket isMemberOfClass:[ReceivedIMPacket class]]) {		
		ReceivedIMPacket* packet = (ReceivedIMPacket*)inPacket;
		ReceivedIMPacketHeader* header = [packet imHeader];
		ClusterNotification* notification = [packet clusterNotification];
		NSString* name = clusterName;
		if(name == nil)
			name = [NSString stringWithFormat:@"%u", [notification externalId]];
		switch([header type] & 0xFF) {
			case kQQIMTypeRequestJoinCluster:
				return [NSString stringWithFormat:L(@"MessageRequestJoinCluster"), 
					[notification sourceQQ], 
					[notification externalId],
					name, 
					[notification message]];
			case kQQIMTypeApprovedJoinCluster:
				return [NSString stringWithFormat:L(@"MessageApproveJoinCluster"),
					[notification sourceQQ],
					[notification externalId]];
			case kQQIMTypeRejectedJoinCluster:
				return [NSString stringWithFormat:L(@"MessageRejectJoinCluster"),
					[notification sourceQQ],
					[notification externalId],
					[notification message]];
			case kQQIMTypeClusterCreated:
				return [NSString stringWithFormat:L(@"MessageClusterCreated"),
					[notification externalId],
					[notification sourceQQ]];
			case kQQIMTypeClusterRoleChanged:
				switch([notification rootCause]) {
					case kQQClusterAdminRoleSet:
						if(userQQ == [notification sourceQQ])
							return [NSString stringWithFormat:L(@"MessageYouAreAdminNow"), name];
						else
							return [NSString stringWithFormat:L(@"MessageAdminRoleSet"),
								[notification sourceQQ],
								name];
						break;
					case kQQClusterAdminRoleUnset:
						if(userQQ == [notification sourceQQ])
							return [NSString stringWithFormat:L(@"MessageYouAreNotAdminNow"), name];
						else
							return [NSString stringWithFormat:L(@"MessageAmdinRoleUnset"),
								[notification sourceQQ],
								name];
						break;
					case (char)(kQQClusterOwnerRoleSet & 0xFF):
						if(userQQ == [notification destQQ])
							return [NSString stringWithFormat:L(@"MessageYouAreClusterOwner"),
								[notification externalId],
								name];
						else
							return [NSString stringWithFormat:L(@"MessageOwnerChanged"),
								[notification destQQ],
								[notification externalId],
								name];
						break;
				}
				break;
			case kQQIMTypeJoinedCluster:
				if([notification sourceQQ] == userQQ)
					return [NSString stringWithFormat:L(@"MessageYouJoinedCluster"), [notification externalId]];
				else
					return [NSString stringWithFormat:L(@"MessageJoinedCluster"), [notification sourceQQ], [notification externalId]];
				break;
			case kQQIMTypeExitedCluster:
				switch([notification rootCause]) {
					case kQQExitClusterActive:
						return [NSString stringWithFormat:L(@"MessageMemberExit"),
							[notification sourceQQ],
							[notification externalId],
							name];
					case kQQExitClusterPassive:
						if([notification sourceQQ] == userQQ) 
							return [NSString stringWithFormat:L(@"MessageYouAreKickedByAdmin"),
								[notification externalId],
								name,
								[notification destQQ]];
						else
							return [NSString stringWithFormat:L(@"MessageKickedByAdmin"),
								[notification sourceQQ],
								[notification externalId],
								name,
								[notification destQQ]];
						break;
					case kQQExitClusterDismissed:
						return [NSString stringWithFormat:L(@"MessageClusterDismissed"), [notification externalId]];
				}
				break;
		}
	} else if([inPacket isMemberOfClass:[SystemNotificationPacket class]]) {
		SystemNotificationPacket* packet = (SystemNotificationPacket*)inPacket;
		switch([packet subCommand]) {
			case kQQSubCommandOtherAddMeEx:
				return [NSString stringWithFormat:L(@"MessageOtherAddedMe"), userQQ];
			case kQQSubCommandOtherApproveMyRequest:
				return [NSString stringWithFormat:L(@"MessageApproveAddHim"), userQQ];
			case kQQSubCommandOtherApproveMyRequestAndAddMe:
				return [NSString stringWithFormat:L(@"MessageApproveAddHimAndAddMe"), userQQ];
			case kQQSubCommandOtherRejectMyRequest:
				return [NSString stringWithFormat:L(@"MessageRejectAddHim"), userQQ, [packet message]];
			case kQQSubCommandOtherRequestAddMeEx:
				return [NSString stringWithFormat:L(@"MessageRequestAddMe"), userQQ, [packet message]];
		}
	}
	
	return kStringEmpty;
}