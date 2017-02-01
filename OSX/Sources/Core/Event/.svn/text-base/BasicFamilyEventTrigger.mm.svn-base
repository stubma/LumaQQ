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

#import "BasicFamilyEventTrigger.h"
#import "QQConstants.h"
#import "GetServerTokenReplyPacket.h"
#import "GetLoginTokenReplyPacket.h"
#import "EventRouter.h"
#import "LoginReplyPacket.h"
#import "PasswordVerifyReplyPacket.h"
#import "KeepAliveReplyPacket.h"
#import "GetKeyReplyPacket.h"
#import "ChangeStatusReplyPacket.h"
#import "TempSessionOpReplyPacket.h"
#import "GroupDataOpReplyPacket.h"
#import "PropertyOpReplyPacket.h"
#import "SignatureOpReplyPacket.h"
#import "FriendDataOpReplyPacket.h"
#import "ClusterCommandReplyPacket.h"
#import "ModifyInfoReplyPacket.h"
#import "AuthQuestionOpReplyPacket.h"
#import "PrivacyOpReplyPacket.h"
#import "SearchUserReplyPacket.h"
#import "AdvancedSearchUserReplyPacket.h"
#import "AddFriendReplyPacket.h"
#import "AuthInfoOpReplyPacket.h"
#import "AuthorizeReplyPacket.h"
#import "DeleteFriendReplyPacket.h"
#import "ClusterModifyInfoPacket.h"
#import "SendIMReplyPacket.h"
#import "SelectServerReplyPacket.h"
#import "RemoveSelfReplyPacket.h"
#import "UploadFriendGroupReplyPacket.h"
#import "WeatherOpReplyPacket.h"

@implementation BasicFamilyEventTrigger

+ (void)trigger:(QQClient*)client packet:(InPacket*)packet outPacket:(OutPacket*)outPacket connectionId:(int)connectionId {
	QQNotification* event = nil;
	switch([packet command]) {
		case kQQCommandSelectServer:
			event = [self processSelectServerReply:packet];
			break;
		case kQQCommandGetServerToken:
			event = [self processGetServerTokenReply:packet];
			break;
		case kQQCommandGetLoginToken:
			event = [self processGetLoginTokenReply:packet];
			break;
		case kQQCommandPasswordVerify:
			event = [self processPasswordVerifyReply:packet];
			break;
		case kQQCommandLogin:
			event = [self processLoginReply:packet];
			break;
		case kQQCommandKeepAlive:
			event = [self processKeepAliveReply:packet];
			break;
		case kQQCommandGetKey:
			event = [self processGetKeyReply:packet];
			break;
		case kQQCommandChangeStatus:
			event = [self processChangeStatusReply:packet];
			break;
		case kQQCommandGetOnlineOp:
			event = [self processGetOnlineOpReply:packet];
			break;
		case kQQCommandGetUserInfo:
			event = [self processGetUserInfoReply:packet];
			break;
		case kQQCommandGetFriendList:
			event = [self processGetFriendListReply:packet];
			break;
		case kQQCommandGetFriendGroup:
			event = [self processGetFriendGroupReply:packet];
			break;
		case kQQCommandGroupDataOp:
			event = [self processGroupDataOpReply:packet];
			break;
		case kQQCommandLevelOp:
			event = [self processFriendLevelOpReply:packet];
			break;
		case kQQCommandPropertyOp:
			event = [self processPropertyOpReply:packet];
			break;
		case kQQCommandSignatureOp:
			event = [self processSignatureOpReply:packet];
			break;
		case kQQCommandFriendDataOp:
			event = [self processFriendDataOpReply:packet];
			break;
		case kQQCommandCluster:
			event = [self processClusterReply:packet];
			break;
		case kQQCommandModifyInfo:
			event = [self processModifyInfoReply:packet client:client];
			break;
		case kQQCommandAuthQuestionOp:
			event = [self processAuthQuestionOpReply:packet];
			break;
		case kQQCommandPrivacyOp:
			event = [self processPrivacyOpReply:packet];
			break;
		case kQQCommandSearch:
			event = [self processSearchUserReply:packet];
			break;
		case kQQCommandAdvancedSearch:
			event = [self processAdvancedSearchUserReply:packet];
			break;
		case kQQCommandAddFriend:
			event = [self processAddFriendReply:packet];
			break;
		case kQQCommandAuthInfoOp:
			event = [self processAuthInfoOpReply:packet];
			break;
		case kQQCommandAuthorize:
			event = [self processAuthorizeReply:packet];
			break;
		case kQQCommandSystemNotification:
			event = [self processSystemNotification:packet];
			break;
		case kQQCommandDeleteFriend:
			event = [self processDeleteFriendReply:packet];
			break;
		case kQQCommandReceivedIM:
			event = [self processReceivedIM:packet];
			break;
		case kQQCommandSendIM:
			event = [self processSendIMReply:packet];
			break;
		case kQQCommandRemoveSelf:
			event = [self processRemoveSelfReply:packet];
			break;
		case kQQCommandUploadGroupFriend:
			event = [self processUploadFriendGroupReply:packet];
			break;
		case kQQCommandSendSMS:
			event = [self processSendSMSReply:packet];
			break;
		case kQQCommandFriendStatusChanged:
			event = [self processFriendStatusChanged:packet];
			break;
		case kQQCommandTempSessionOp:
			event = [self processTempSessionOpReply:packet];
			break;
		case kQQCommandWeatherOp:
			event = [self processWeatherOpReply:packet];
			break;
	}
	
	// trigger event
	if(event) {
		[event retain];
		[event setConnectionId:connectionId];
		[event setOutPacket:outPacket];
		[client trigger:event];
		[event release];
		
		// special concern on cluster failed event
		switch([packet command]) {
			case kQQCommandCluster:
				ClusterCommandReplyPacket* p = (ClusterCommandReplyPacket*)packet;
				if([p reply] != kQQReplyOK) {
					event = [[QQNotification alloc] initWithId:kQQEventClusterCommandFailed
														packet:p
													 outPacket:outPacket];
					[client trigger:event];
					[event release];
				}
				break;
		}
	}
}

+ (QQNotification*)processPasswordVerifyReply:(InPacket*)packet {
	PasswordVerifyReplyPacket* p = (PasswordVerifyReplyPacket*)packet;
	NSLog(@"Password Verify %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
	QQNotification* event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventPasswordVerifyOK : kQQEventPasswordVerifyFailed)
														packet:p];
	return [event autorelease];
}

+ (QQNotification*)processGetServerTokenReply:(InPacket*)packet {
	GetServerTokenReplyPacket* p = (GetServerTokenReplyPacket*)packet;
	NSLog(@"Get Server Token %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
	QQNotification* event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventGetServerTokenOK : kQQEventGetServerTokenFailed)
														packet:p];
	return [event autorelease];
}

+ (QQNotification*)processWeatherOpReply:(InPacket*)packet {
	WeatherOpReplyPacket* p = (WeatherOpReplyPacket*)packet;
	NSLog(@"Weather Op %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
	QQNotification* event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventGetWeatherOK : kQQEventGetWeatherFailed)
														packet:p];
	return [event autorelease];
}

+ (QQNotification*)processTempSessionOpReply:(InPacket*)packet {
	QQNotification* event = nil;
	TempSessionOpReplyPacket* p = (TempSessionOpReplyPacket*)packet;
	switch([p subCommand]) {
		case kQQSubCommandSendTempSessionIM:
			switch([p reply]) {
				case kQQReplyOK:
				case kQQReplyTempSesionIMCached:
					NSLog(@"Send Temp Session IM OK");
					event = [[QQNotification alloc] initWithId:kQQEventSendTempSessionIMOK packet:p];
					break;
				default:
					NSLog(@"Send Temp Session IM Failed");
					event = [[QQNotification alloc] initWithId:kQQEventSendTempSessionIMFailed packet:p];
					break;
			}
			break;
	}
	
	if(event)
		return [event autorelease];
	else
		return nil;
}

+ (QQNotification*)processFriendStatusChanged:(InPacket*)packet {
	NSLog(@"Friend Status Changed");
	QQNotification* event = [[QQNotification alloc] initWithId:kQQEventFriendStatusChanged packet:packet];
	return [event autorelease];
}

+ (QQNotification*)processSendSMSReply:(InPacket*)packet {
	NSLog(@"SMS Sent");
	QQNotification* event = [[QQNotification alloc] initWithId:kQQEventSMSSent packet:packet];
	return [event autorelease];
}

+ (QQNotification*)processUploadFriendGroupReply:(InPacket*)packet {
	UploadFriendGroupReplyPacket* p = (UploadFriendGroupReplyPacket*)packet;
	NSLog(@"Upload Friend Group %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
	QQNotification* event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventUploadFriendGroupOK : kQQEventUploadFriendGroupFailed)
														packet:p];
	return [event autorelease];
}

+ (QQNotification*)processRemoveSelfReply:(InPacket*)packet {
	RemoveSelfReplyPacket* p = (RemoveSelfReplyPacket*)packet;
	NSLog(@"Remove Self %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
	QQNotification* event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventRemoveSelfOK : kQQEventRemoveSelfFailed)
														packet:p];
	return [event autorelease];
}

+ (QQNotification*)processSelectServerReply:(InPacket*)packet {
	QQNotification* event = nil;
	SelectServerReplyPacket* p = (SelectServerReplyPacket*)packet;
	if([p nextTimes] != 0) {
		NSLog(@"Select Server Redirect");
		event = [[QQNotification alloc] initWithId:kQQEventSelectServerRedirect packet:p];
	} else {
		NSLog(@"Select Server OK");
		event = [[QQNotification alloc] initWithId:kQQEventSelectServerOK packet:p];
	}
	return [event autorelease];
}

+ (QQNotification*)processSendIMReply:(InPacket*)packet {
	SendIMReplyPacket* p = (SendIMReplyPacket*)packet;
	NSLog(@"Send IM %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
	QQNotification* event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventSendIMOK : kQQEventSendIMFailed)
														packet:p];
	return [event autorelease];
}

+ (QQNotification*)processReceivedIM:(InPacket*)packet {
	NSLog(@"Receive IM");
	QQNotification* event = [[QQNotification alloc] initWithId:kQQEventReceivedIM packet:packet];
	return [event autorelease];
}

+ (QQNotification*)processDeleteFriendReply:(InPacket*)packet {
	DeleteFriendReplyPacket* p = (DeleteFriendReplyPacket*)packet;
	NSLog(@"Delete Friend %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
	QQNotification* event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventDeleteFriendOK : kQQEventDeleteFriendFailed)
														packet:p];
	return [event autorelease];
}

+ (QQNotification*)processSystemNotification:(InPacket*)packet {
	NSLog(@"Receive System Notification");
	QQNotification* event = [[QQNotification alloc] initWithId:kQQEventReceivedSystemNotification packet:packet];
	return [event autorelease];
}

+ (QQNotification*)processAuthorizeReply:(InPacket*)packet {
	AuthorizeReplyPacket* p = (AuthorizeReplyPacket*)packet;
	NSLog(@"Authorize %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
	QQNotification* event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventAuthorizeOK : kQQEventAuthorizeFailed)
														packet:p];
	return [event autorelease];
}

+ (QQNotification*)processAuthInfoOpReply:(InPacket*)packet {
	QQNotification* event = nil;
	AuthInfoOpReplyPacket* p = (AuthInfoOpReplyPacket*)packet;
	switch([p subCommand]) {
		case kQQSubCommandGetAuthInfo:
			switch([p reply]) {
				case kQQReplyOK:
					NSLog(@"Get Auth Info Ok");
					event = [[QQNotification alloc] initWithId:kQQEventGetAuthInfoOK packet:p];
					break;
				case kQQReplyNeedVerifyCode:
					NSLog(@"Get Auth Info Need Verify Code");
					event = [[QQNotification alloc] initWithId:kQQEventGetAuthInfoNeedVerifyCode packet:p];
					break;
			}
			break;
		case kQQSubCommandGetAuthInfoByVerifyCode:
			NSLog(@"Submit Auth Info %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventGetAuthInfoByVerifyCodeOK : kQQEventGetAuthInfoByVerifyCodeRetry)
												packet:p];
			break;
	}
	
	if(event)
		return [event autorelease];
	else
		return nil;
}

+ (QQNotification*)processAddFriendReply:(InPacket*)packet {
	QQNotification* event = nil;
	AddFriendReplyPacket* p = (AddFriendReplyPacket*)packet;
	switch([p reply]) {
		case kQQReplyOK:
			switch([p authType]) {
				case kQQAuthNo:
					NSLog(@"Add Friend OK");
					event = [[QQNotification alloc] initWithId:kQQEventAddFriendOK packet:p];
					break;
				case kQQAuthReject:
					NSLog(@"Add Friend Denied");
					event = [[QQNotification alloc] initWithId:kQQEventAddFriendDenied packet:p];
					break;
				case kQQAuthNeed:
				case kQQAuthQuestion:
					NSLog(@"Add Friend Need Auth");
					event = [[QQNotification alloc] initWithId:kQQEventAddFriendNeedAuth packet:p];
					break;
				default:
					NSLog(@"Unknown Auth Type");
					break;
			}
			break;
		case kQQReplyAlreadyFriend:
			NSLog(@"Add Friend - Already");
			event = [[QQNotification alloc] initWithId:kQQEventAddFriendOK packet:p];
			break;
		default:
			NSLog(@"Unknown Add Friend Reply Code");
			break;
	}
	
	if(event)
		return [event autorelease];
	else
		return nil;
}

+ (QQNotification*)processAdvancedSearchUserReply:(InPacket*)packet {
	AdvancedSearchUserReplyPacket* p = (AdvancedSearchUserReplyPacket*)packet;
	NSLog(@"Advanced Search User %@", ([p reply] == kQQReplyOK || [p reply] == kQQReplyNoMoreResult) ? @"OK" : @"Failed");
	QQNotification* event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventAdvancedSearchUserOK : kQQEventAdvancedSearchUserFailed)
														packet:p];
	return [event autorelease];
}

+ (QQNotification*)processSearchUserReply:(InPacket*)packet {
	SearchUserReplyPacket* p = (SearchUserReplyPacket*)packet;
	NSLog(@"Search User %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
	QQNotification* event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventSearchUserOK : kQQEventSearchUserFailed)
														packet:p];
	return [event autorelease];
}

+ (QQNotification*)processPrivacyOpReply:(InPacket*)packet {
	PrivacyOpReplyPacket* p = (PrivacyOpReplyPacket*)packet;
	NSLog(@"Privacy Op %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
	QQNotification* event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventPrivacyOpOK : kQQEventPrivacyOpFailed)
										packet:p];
	return [event autorelease];
}

+ (QQNotification*)processAuthQuestionOpReply:(InPacket*)packet {
	QQNotification* event = nil;
	AuthQuestionOpReplyPacket* p = (AuthQuestionOpReplyPacket*)packet;
	switch([p subCommand]) {
		case kQQSubCommandGetMyQuestion:
			NSLog(@"Get My Question OK");
			event = [[QQNotification alloc] initWithId:kQQEventGetMyQuestionOK packet:p];
			break;
		case kQQSubCommandModifyQuestion:
			NSLog(@"Modify Question %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventModifyQuestionOK : kQQEventModifyQuestionFailed)
												packet:p];
			break;
		case kQQSubCommandGetUserQuestion:
			NSLog(@"Get User Question %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventGetUserQuestionOK : kQQEventGetUserQuestionFailed)
												packet:p];
			break;
		case kQQSubCommandAnswerQuestion:
			NSLog(@"Answer Question %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventAnswerQuestionOK : kQQEventAnswerQuestionFailed)
												packet:p];
			break;
	}
	
	if(event)
		return [event autorelease];
	else
		return nil;
}

+ (QQNotification*)processClusterReply:(InPacket*)packet {
	QQNotification* event = nil;
	ClusterCommandReplyPacket* p = (ClusterCommandReplyPacket*)packet;
	switch([p subCommand]) {
		case kQQSubCommandClusterCreate: 		
			break;
		case kQQSubCommandClusterModifyMember: 	
			NSLog(@"Modify Member Info %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterModifyMemberOK : kQQEventClusterModifyMemberFailed)
												packet:p];
			break;
		case kQQSubCommandClusterModifyInfo: 
			NSLog(@"Modify Cluster Info %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterModifyInfoOK : kQQEventClusterModifyInfoFailed)
												packet:p];
			break;
		case kQQSubCommandClusterGetInfo:
			NSLog(@"Get Cluster Info %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterGetInfoOK : kQQEventClusterGetInfoFailed)
												packet:p];
			break;
		case kQQSubCommandClusterActivate: 
			NSLog(@"Activate Cluster %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterActivateOK : kQQEventClusterActivateFailed)
												packet:p];
			break;
		case kQQSubCommandClusterSearch: 	
			NSLog(@"Search Cluster %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterSearchOK : kQQEventClusterSearchFailed)
												packet:p];
			break;
		case kQQSubCommandClusterJoin: 	
			switch([p authType]) {
				case kQQClusterAuthNo:
					NSLog(@"Cluster Join OK");
					event = [[QQNotification alloc] initWithId:kQQEventClusterJoinOK packet:p];
					break;
				case kQQClusterAuthNeed:
					NSLog(@"Cluster Join Need Auth");
					event = [[QQNotification alloc] initWithId:kQQEventClusterJoinNeedAuth packet:p];
					break;
				case kQQClusterAuthReject:
					NSLog(@"Cluster Join Reject");
					event = [[QQNotification alloc] initWithId:kQQEventClusterJoinRejected packet:p];
					break;
			}
			break;
		case kQQSubCommandClusterAuthorize: 	
			NSLog(@"Cluster Authorization Send %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterAuthorizationSendOK : kQQEventClusterAuthorizationSendFailed)
												packet:p];
			break;
		case kQQSubCommandClusterExit: 	
			NSLog(@"Eixt Cluster %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterExitOK : kQQEventClusterExitFailed)
												packet:p];
			break;
		case kQQSubCommandClusterGetOnlineMember: 
			NSLog(@"Get Online Member %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterGetOnlineMemberOK : kQQEventClusterGetOnlineMemberFailed)
												packet:p];
			break;
		case kQQSubCommandClusterGetMemberInfo: 
			NSLog(@"Get Member Info %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterGetMemberInfoOK : kQQEventClusterGetMemberInfoFailed)
												packet:p];
			break;
		case kQQSubCommandClusterModifyCard: 		
			NSLog(@"Modify Card %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterModifyCardOK : kQQEventClusterModifyCardFailed)
												packet:p];
			break;
		case kQQSubCommandClusterBatchGetCard: 	
			NSLog(@"Batch Get Cluster Name Card %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterBatchGetCardOK : kQQEventClusterBatchGetCardFailed)
												packet:p];
			break;
		case kQQSubCommandClusterGetCard: 		
			NSLog(@"Get Cluster Name Card %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterGetCardOK : kQQEventClusterGetCardFailed)
												packet:p];
			break;
		case kQQSubCommandClusterCommitOrganization: 		
			break;
		case kQQSubCommandClusterUpdateOrganization: 		
			NSLog(@"Update Organization %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterUpdateOrganizationOK : kQQEventClusterUpdateOrganizationFailed)
												packet:p];
			break;
		case kQQSubCommandClusterCommitMemberGroup: 		
			break;
		case kQQSubCommandClusterGetVersionID: 
			NSLog(@"Get Version ID %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterGetVersionIdOK : kQQEventClusterGetVersionIdFailed)
												packet:p];
			break;
		case kQQSubCommandClusterSendIMEx: 	
			NSLog(@"Cluster Send IM Ex %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterSendIMOK : kQQEventClusterSendIMFailed)
												packet:p];
			break;
		case kQQSubCommandClusterSetRole: 	
			NSLog(@"Cluster Set Role %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterSetRoleOK : kQQEventClusterSetRoleFailed)
												packet:p];
			break;
		case kQQSubCommandClusterTransferRole: 		
			NSLog(@"Cluster Transfer Role %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterTransferRoleOK : kQQEventClusterTransferRoleFailed)
												packet:p];
			break;
		case kQQSubCommandClusterDismiss: 	
			NSLog(@"Cluster Dismiss %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterDismissOK : kQQEventClusterDismissFailed)
												packet:p];
			break;
		case kQQSubCommandTempClusterCreate: 		
			NSLog(@"Create Temp Cluster %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventTempClusterCreateOK : kQQEventTempClusterCreateFailed)
												packet:p];
			break;
		case kQQSubCommandTempClusterModifyMember: 		
			NSLog(@"Modify Temp Cluster Member %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventTempClusterModifyMemberOK : kQQEventTempClusterModifyMemberFailed)
												packet:p];
			break;
		case kQQSubCommandTempClusterExit: 		
			NSLog(@"Exit Temp Cluster %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventTempClusterExitOK : kQQEventTempClusterExitFailed)
												packet:p];
			break;
		case kQQSubCommandTempClusterGetInfo: 	
			NSLog(@"Get Temp Cluster Info %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventTempClusterGetInfoOK : kQQEventTempClusterGetInfoFailed)
												packet:p];
			break;
		case kQQSubCommandTempClusterModifyInfo: 		
			NSLog(@"Modify Temp Cluster Info %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventTempClusterModifyInfoOK : kQQEventTempClusterModifyInfoFailed)
												packet:p];
			break;
		case kQQSubCommandTempClusterSendIM: 		
			NSLog(@"Send Temp Cluster IM %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventTempClusterSendIMOK : kQQEventTempClusterSendIMFailed)
												packet:p];
			break;
		case kQQSubCommandClusterSubOp:
			switch([p subSubCommand]) {
				case kQQSubSubCommandGetSubjects:
					NSLog(@"Get Subject List %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
					event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterGetSubjectsOK : kQQEventClusterGetSubjectsFailed)
														packet:p];
					break;
				case kQQSubSubCommandGetDialogs:
					NSLog(@"Get Dialog List %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
					event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterGetDialogsOK : kQQEventClusterGetDialogsFailed)
														packet:p];
					break;
				default:
					NSLog(@"Unknown Sub Sub Command of kQQSubCommandClusterSubOp");
					break;
			}
			break;
		case kQQSubCommandTempClusterActivate: 	
			NSLog(@"Activate Temp Cluster %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventTempClusterActivateOK : kQQEventTempClusterActivateFailed)
												packet:p];
			break;
		case kQQSubCommandClusterGetMessageSetting:
			NSLog(@"Get Message Setting %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterGetMessageSettingOK : kQQEventClusterGetMessageSettingFailed)
												packet:p];
			break;
		case kQQSubCommandClusterModifyMessageSetting:
			NSLog(@"Modify Message Setting %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterModifyMessageSettingOK : kQQEventClusterModifyMessageSettingFailed)
												packet:p];
			break;
		case kQQSubCommandClusterModifyChannelSetting:
			NSLog(@"Modify Channel Setting %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterModifyChannelSettingOK : kQQEventClusterModifyChannelSettingFailed)
												packet:p];
			break;
		case kQQSubCommandClusterGetChannelSetting:
			NSLog(@"Get Channel Setting %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterGetChannelSettingOK : kQQEventClusterGetChannelSettingFailed)
												packet:p];
			break;
		case kQQSubCommandClusterGetLastTalkTime:
			NSLog(@"Get Last Talk Time %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventClusterGetLastTalkTimeOK : kQQEventClusterGetLastTalkTimeFailed)
												packet:p];
			break;
	}
	
	if(event)
		return [event autorelease];
	else
		return nil;
}

+ (QQNotification*)processModifyInfoReply:(InPacket*)packet client:(QQClient*)client {
	QQNotification* event = nil;
	ModifyInfoReplyPacket* p = (ModifyInfoReplyPacket*)packet;
	if([p QQ] == [[client user] QQ]) {
		NSLog(@"Modify Info OK");
		event = [[QQNotification alloc] initWithId:kQQEventModifyInfoOK packet:p];
	} else {
		NSLog(@"Modify Info Failed");
		event = [[QQNotification alloc] initWithId:kQQEventModifyInfoFailed packet:p];
	}
	
	if(event)
		return [event autorelease];
	else
		return nil;
}

+ (QQNotification*)processFriendDataOpReply:(InPacket*)packet {
	QQNotification* event = nil;
	FriendDataOpReplyPacket* p = (FriendDataOpReplyPacket*)packet;
	switch([p subCommand]) {
		case kQQSubCommandBatchGetFriendRemark:
			NSLog(@"Batch Get Friend Remark OK");
			event = [[QQNotification alloc] initWithId:kQQEventBatchGetFriendRemarkOK packet:p];
			break;
		case kQQSubCommandUploadFriendRemark:
			NSLog(@"Upload Friend Remark %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventUploadFriendRemarkOK : kQQEventUploadFriendRemarkFailed)
												packet:p];
			break;
		case kQQSubCommandRemoveFriendFromList:
			NSLog(@"Remove Friend From List %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventRemoveFriendFromListOK : kQQEventRemoveFriendFromListFailed)
												packet:p];
			break;
		case kQQSubCommandGetFriendRemark:
			NSLog(@"Get Friend Remark OK");
			event = [[QQNotification alloc] initWithId:kQQEventGetFriendRemarkOK packet:p];
			break;
		case kQQSubCommandModifyRemarkName:
			NSLog(@"Modify Remark Name %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventModifyRemarkNameOK : kQQEventModifyRemarkNameFailed)
												packet:p];
			break;
	}
	
	if(event)
		return [event autorelease];
	else
		return nil;
}

+ (QQNotification*)processSignatureOpReply:(InPacket*)packet {
	QQNotification* event = nil;
	SignatureOpReplyPacket* p = (SignatureOpReplyPacket*)packet;
	switch([p subCommand]) {
		case kQQSubCommandModifySignature:
			switch([p reply]) {
				case kQQReplyOK:
					NSLog(@"Modify Signature OK");
					event = [[QQNotification alloc] initWithId:kQQEventModifySigatureOK packet:p];
					break;
				default:
					NSLog(@"Modify Signature Failed");
					event = [[QQNotification alloc] initWithId:kQQEventModifySigatureFailed packet:p];
					break;
			}
			break;
		case kQQSubCommandDeleteSignature:
			switch([p reply]) {
				case kQQReplyOK:
					NSLog(@"Delete Signature OK");
					event = [[QQNotification alloc] initWithId:kQQEventDeleteSignatureOK packet:p];
					break;
				default:
					NSLog(@"Delete Signature Failed");
					event = [[QQNotification alloc] initWithId:kQQEventDeleteSignatureFailed packet:p];
					break;
			}
			break;
		case kQQSubCommandGetSignature:
			switch([p reply]) {
				case kQQReplyOK:
					NSLog(@"Get Signature OK");
					event = [[QQNotification alloc] initWithId:kQQEventGetSignatureOK packet:p];
					break;
				default:
					NSLog(@"Get Signature Failed");
					event = [[QQNotification alloc] initWithId:kQQEventGetSignatureFailed packet:p];
					break;
			}
			break;
		default:
			NSLog(@"Unknown Signature Op Sub Command");
			break;
	}
	
	if(event)
		return [event autorelease];
	else
		return nil;
}

+ (QQNotification*)processPropertyOpReply:(InPacket*)packet {
	NSLog(@"Get User Property OK");
	QQNotification* event = [[QQNotification alloc] initWithId:kQQEventGetUserPropertyOK packet:packet];
	return [event autorelease];
}

+ (QQNotification*)processFriendLevelOpReply:(InPacket*)packet {
	NSLog(@"Get Friend Level OK");
	QQNotification* event = [[QQNotification alloc] initWithId:kQQEventGetFriendLevelOK packet:packet];
	return [event autorelease];
}

+ (QQNotification*)processGroupDataOpReply:(InPacket*)packet {
	QQNotification* event = nil;
	GroupDataOpReplyPacket* p = (GroupDataOpReplyPacket*)packet;
	switch([p subCommand]) {
		case kQQSubCommandDownloadGroupName:
			switch([p reply]) {
				case kQQReplyOK:
					NSLog(@"Download Group Names OK");
					event = [[QQNotification alloc] initWithId:kQQEventDownloadGroupNamesOK packet:p];
					break;
				default:
					NSLog(@"Unknown Download Group Name Reply Code");
					break;
			}
			break;
		case kQQSubCommandUploadGroupName:
			NSLog(@"Upload Group Name %@", ([p reply] == kQQReplyOK) ? @"OK" : @"Failed");
			event = [[QQNotification alloc] initWithId:(([p reply] == kQQReplyOK) ? kQQEventUploadGroupNamesOK : kQQEventUploadGroupNamesFailed)
												packet:p];
			break;
	}
	return [event autorelease];
}

+ (QQNotification*)processGetFriendGroupReply:(InPacket*)packet {
	NSLog(@"Get Friend Group OK");
	QQNotification* event = [[QQNotification alloc] initWithId:kQQEventGetFriendGroupOK packet:packet];
	return [event autorelease];
}

+ (QQNotification*)processGetFriendListReply:(InPacket*)packet {
	NSLog(@"Get Friend List OK");
	QQNotification* event = [[QQNotification alloc] initWithId:kQQEventGetFriendListOK packet:packet];
	return [event autorelease];
}

+ (QQNotification*)processGetUserInfoReply:(InPacket*)packet {
	NSLog(@"Get User Info OK");
	QQNotification* event = [[QQNotification alloc] initWithId:kQQEventGetUserInfoOK packet:packet];
	return [event autorelease];
}

+ (QQNotification*)processGetOnlineOpReply:(InPacket*)packet {
	NSLog(@"Get Online Friend OK");
	QQNotification* event = [[QQNotification alloc] initWithId:kQQEventGetOnlineFriendOK packet:packet];
	return [event autorelease];
}

+ (QQNotification*)processChangeStatusReply:(InPacket*)packet {
	QQNotification* event = nil;
	ChangeStatusReplyPacket* p = (ChangeStatusReplyPacket*)packet;
	switch([p reply]) {
		case kQQReplyChangeStatusOK:
			NSLog(@"Change Status OK");
			event = [[QQNotification alloc] initWithId:kQQEventChangeStatusOK packet:p];
			break;
		default:
			NSLog(@"Unknown change status reply code");
			break;
	}
	
	if(event)
		return [event autorelease];
	else
		return nil;
}

+ (QQNotification*)processGetLoginTokenReply:(InPacket*)packet {
	QQNotification* event = nil;
	GetLoginTokenReplyPacket* p = (GetLoginTokenReplyPacket*)packet;
	switch([p reply]) {
		case kQQReplyOK:
			NSLog(@"Get Login Token OK");
			event = [[QQNotification alloc] initWithId:kQQEventGetLoginTokenOK packet:p];
			break;
		case kQQReplyNeedVerifyCode:
			NSLog(@"Need Verify Code");
			event = [[QQNotification alloc] initWithId:kQQEventNeedVerifyCode packet:p];
			break;
	}
	
	if(event)
		return [event autorelease];
	else
		return nil;
}

+ (QQNotification*)processLoginReply:(InPacket*)packet {
	QQNotification* event = nil;
	LoginReplyPacket* p = (LoginReplyPacket*)packet;
	switch([p reply]) {
		case kQQReplyOK:
			NSLog(@"Login OK");
			event = [[QQNotification alloc] initWithId:kQQEventLoginOK packet:p];
			break;
		case kQQReplyRedirect:
			NSLog(@"Login Redirect");
			if([p isRedirectIpNull])
				event = [[QQNotification alloc] initWithId:kQQEventLoginRedirectNull packet:p];
			else
				event = [[QQNotification alloc] initWithId:kQQEventLoginRedirect packet:p];
			break;
		case kQQReplyPasswordError:
		case kQQReplyServerBusy:
		case kQQReplyLoginFailed:
			NSLog(@"Login Failed");
			event = [[QQNotification alloc] initWithId:kQQEventLoginFailed packet:p];
			break;
	}
	
	if(event)
		return [event autorelease];
	else
		return nil;
}

+ (QQNotification*)processKeepAliveReply:(InPacket*)packet {
	QQNotification* event = nil;
	KeepAliveReplyPacket* p = (KeepAliveReplyPacket*)packet;
	switch([p reply]) {
		case kQQReplyOK:
			NSLog(@"Keep Alive OK");
			event = [[QQNotification alloc] initWithId:kQQEventKeepAliveOK packet:p];
			break;
		default:
			NSLog(@"Uknown Keep Alive reply code");
			break;
	}
	
	if(event)
		return [event autorelease];
	else
		return nil;
}

+ (QQNotification*)processGetKeyReply:(InPacket*)packet {
	QQNotification* event = nil;
	GetKeyReplyPacket* p = (GetKeyReplyPacket*)packet;
	switch([p reply]) {
		case kQQReplyOK:
			NSLog(@"Get Key OK");
			event = [[QQNotification alloc] initWithId:kQQEventGetKeyOK packet:p];
			break;
		default:
			NSLog(@"Unknown get key reply code");
	}
	
	if(event)
		return [event autorelease];
	else
		return nil;
}

@end
