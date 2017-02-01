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

#import "PacketParser.h"
#import "QQConstants.h"
#import "ByteTool.h"
#import "GetLoginTokenReplyPacket.h"
#import "LoginReplyPacket.h"
#import "KeepAliveReplyPacket.h"
#import "PasswordVerifyReplyPacket.h"
#import "GetKeyReplyPacket.h"
#import "ChangeStatusReplyPacket.h"
#import "GetOnlineOpReplyPacket.h"
#import "GetUserInfoReplyPacket.h"
#import "GetFriendListReplyPacket.h"
#import "GetFriendGroupReplyPacket.h"
#import "GroupDataOpReplyPacket.h"
#import "LevelOpReplyPacket.h"
#import "PropertyOpReplyPacket.h"
#import "SignatureOpReplyPacket.h"
#import "FriendDataOpReplyPacket.h"
#import "TempSessionOpReplyPacket.h"
#import "ClusterCommandReplyPacket.h"
#import "ModifyInfoReplyPacket.h"
#import "AuthQuestionOpReplyPacket.h"
#import "PrivacyOpReplyPacket.h"
#import "SearchUserReplyPacket.h"
#import "AdvancedSearchUserReplyPacket.h"
#import "AddFriendReplyPacket.h"
#import "SendSMSReplyPacket.h"
#import "AuthInfoOpReplyPacket.h"
#import "AuthorizeReplyPacket.h"
#import "DeleteFriendReplyPacket.h"
#import "ReceivedIMPacket.h"
#import "SendIMReplyPacket.h"
#import "SelectServerReplyPacket.h"
#import "SystemNotificationPacket.h"
#import "RemoveSelfReplyPacket.h"
#import "UploadFriendGroupReplyPacket.h"
#import "FriendStatusChangedPacket.h"
#import "WeatherOpReplyPacket.h"
#import "GetServerTokenReplyPacket.h"
#import "GetCustomHeadInfoReplyPacket.h"
#import "GetCustomHeadDataReplyPacket.h"

@implementation PacketParser

- (void) dealloc {
	[super dealloc];
}

- (InPacket*)packetWithData:(NSData*)data user:(QQUser*)user {
	// get bytes
	const char* bytes = (const char*)[data bytes];
	
	InPacket* packet = nil;;
	
	if(bytes[0] == kQQHeaderBasicFamily) {		
		UInt16 command = [ByteTool getUInt16:bytes offset:3];		
		switch(command) {
			case kQQCommandSelectServer:
				packet = [[SelectServerReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandGetServerToken:
				packet = [[GetServerTokenReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandGetLoginToken:
				packet = [[GetLoginTokenReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandPasswordVerify:
				packet = [[PasswordVerifyReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandLogin:
				packet = [[LoginReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandKeepAlive:
				packet = [[KeepAliveReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandFriendStatusChanged:
				packet = [[FriendStatusChangedPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandGetKey:
				packet = [[GetKeyReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandChangeStatus:
				packet = [[ChangeStatusReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandGetOnlineOp:
				packet = [[GetOnlineOpReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandGetUserInfo:
				packet = [[GetUserInfoReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandModifyInfo:
				packet = [[ModifyInfoReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandGetFriendList:
				packet = [[GetFriendListReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandGetFriendGroup:
				packet = [[GetFriendGroupReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandGroupDataOp:
				packet = [[GroupDataOpReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandLevelOp:
				packet = [[LevelOpReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandPropertyOp:
				packet = [[PropertyOpReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandSignatureOp:
				packet = [[SignatureOpReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandFriendDataOp:
				packet = [[FriendDataOpReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandCluster:
				packet = [[ClusterCommandReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandAuthQuestionOp:
				packet = [[AuthQuestionOpReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandPrivacyOp:
				packet = [[PrivacyOpReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandSearch:
				packet = [[SearchUserReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandAdvancedSearch:
				packet = [[AdvancedSearchUserReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandAddFriend:
				packet = [[AddFriendReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandAuthInfoOp:
				packet = [[AuthInfoOpReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandAuthorize:
				packet = [[AuthorizeReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandDeleteFriend:
				packet = [[DeleteFriendReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandSystemNotification:
				packet = [[SystemNotificationPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandReceivedIM:
				packet = [[ReceivedIMPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandSendIM:
				packet = [[SendIMReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandRemoveSelf:
				packet = [[RemoveSelfReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandUploadGroupFriend:
				packet = [[UploadFriendGroupReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandSendSMS:
				packet = [[SendSMSReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandTempSessionOp:
				packet = [[TempSessionOpReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandWeatherOp:
				packet = [[WeatherOpReplyPacket alloc] initWithData:data user:user];
				break;
		}
	} else if(bytes[0] == kQQHeaderAuxiliaryFamily) {
		UInt16 command = bytes[1] & 0xFF;
		switch(command) {
			case kQQCommandGetCustomHeadInfo:
				packet = [[GetCustomHeadInfoReplyPacket alloc] initWithData:data user:user];
				break;
			case kQQCommandGetCustomHeadData:
				packet = [[GetCustomHeadDataReplyPacket alloc] initWithData:data user:user];
				break;
		}
	} else
		NSLog(@"Unknown header: %d", bytes[0]);
	
	if(packet) {
		[packet setTimeReceived:[[NSDate date] timeIntervalSince1970]];
		return [packet autorelease];
	} else 
		return nil;
}

@end
