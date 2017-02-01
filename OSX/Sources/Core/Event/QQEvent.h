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

#pragma mark -
#pragma mark notification name

// qq notification name
#define kQQNotificationName @"LumaQQ"

#pragma mark -
#pragma mark mach port message

// mach port message used between network layer and qq client
#define kQQMessageCheckIn 0
#define kQQMessageShutdown 1
#define kQQMessageNewConnection 2
#define kQQMessageReleaseConnection 3
#define kQQMessageConnectionEstablished 4
#define kQQMessageConnectionCreationFailed 5
// client requests to close connectoin, and the connection is closed successfully
#define kQQMessageConnectionReleased 6
// error occurs
#define kQQMessageConnectionBroken 7
#define kQQMessageSend 8
#define kQQMessageReceived 9

#pragma mark -
#pragma mark network event

#define kQQEventNetworkStarted 0
#define kQQEventNetworkBusy 1
#define kQQEventNetworkConnectionEstablished 2
#define kQQEventNetworkConnectionReleased 3
#define kQQEventNetworkError 4

#pragma mark -
#pragma mark login related event

#define kQQEventGetLoginTokenOK 1000
#define kQQEventNeedVerifyCode 1001
#define kQQEventLoginOK 1002
#define kQQEventLoginRedirect 1003
#define kQQEventLoginFailed 1004
#define kQQEventLoginRedirectNull 1005
#define kQQEventKeepAliveOK 1006
#define kQQEventChangeStatusOK 1007
#define kQQEventSelectServerOK 1008
#define kQQEventSelectServerRedirect 1009
#define kQQEventGetServerTokenOK 1010
#define kQQEventGetServerTokenFailed 1011
#define kQQEventPasswordVerifyOK 1012
#define kQQEventPasswordVerifyFailed 1013

#pragma mark -
#pragma mark error event

#define kQQEventTimeout 0x10000000
#define kQQEventTimeoutBasic 0x10000001
#define kQQEventTimeoutAgent 0x10000002

#pragma mark -
#pragma mark other event

#define kQQEventGetKeyOK 3000
#define kQQEventGetWeatherOK 3001
#define kQQEventGetWeatherFailed 3002

#pragma mark -
#pragma mark user related event

#define kQQEventGetOnlineFriendOK 4000
#define kQQEventGetUserInfoOK 4001
#define kQQEventGetFriendListOK 4002
#define kQQEventGetFriendGroupOK 4003
#define kQQEventDownloadGroupNamesOK 4004
#define kQQEventUploadGroupNamesOK 4005
#define kQQEventUploadGroupNamesFailed 4061
#define kQQEventGetFriendLevelOK 4006
#define kQQEventGetUserPropertyOK 4007
#define kQQEventModifySigatureOK 4008
#define kQQEventModifySigatureFailed 4009
#define kQQEventDeleteSignatureOK 4010
#define kQQEventDeleteSignatureFailed 4011
#define kQQEventGetSignatureOK 4012
#define kQQEventGetSignatureFailed 4013
#define kQQEventBatchGetFriendRemarkOK 4014
#define kQQEventUploadFriendRemarkOK 4015
#define kQQEventUploadFriendRemarkFailed 4016
#define kQQEventRemoveFriendFromListOK 4017
#define kQQEventRemoveFriendFromListFailed 4018
#define kQQEventGetFriendRemarkOK 4019
#define kQQEventModifyRemarkNameOK 4057
#define kQQEventModifyRemarkNameFailed 4058
#define kQQEventModifyInfoOK 4020
#define kQQEventModifyInfoFailed 4021
#define kQQEventGetMyQuestionOK 4022
#define kQQEventModifyQuestionOK 4024
#define kQQEventModifyQuestionFailed 4025
#define kQQEventGetUserQuestionOK 4026
#define kQQEventGetUserQuestionFailed 4027
#define kQQEventAnswerQuestionOK 4028
#define kQQEventAnswerQuestionFailed 4029
#define kQQEventPrivacyOpOK 4030
#define kQQEventPrivacyOpFailed 4031
#define kQQEventSearchUserOK 4032
#define kQQEventSearchUserFailed 4033
#define kQQEventAdvancedSearchUserOK 4034
#define kQQEventAdvancedSearchUserFailed 4035
#define kQQEventAddFriendOK 4036
#define kQQEventAddFriendDenied 4037
#define kQQEventAddFriendNeedAuth 4038
#define kQQEventGetAuthInfoOK 4039
#define kQQEventGetAuthInfoNeedVerifyCode 4040
#define kQQEventGetAuthInfoByVerifyCodeOK 4041
#define kQQEventGetAuthInfoByVerifyCodeRetry 4042
#define kQQEventAuthorizeOK 4043
#define kQQEventAuthorizeFailed 4044
#define kQQEventReceivedSystemNotification 4045
#define kQQEventDeleteFriendOK 4050
#define kQQEventDeleteFriendFailed 4051
#define kQQEventReceivedIM 4052
#define kQQEventSendIMOK 4053
#define kQQEventSendIMFailed 4054
#define kQQEventRemoveSelfOK 4055
#define kQQEventRemoveSelfFailed 4056
#define kQQEventUploadFriendGroupOK 4059
#define kQQEventUploadFriendGroupFailed 4060
#define kQQEventSMSSent 4062
#define kQQEventFriendStatusChanged 4063
#define kQQEventSendTempSessionIMOK 4064
#define kQQEventSendTempSessionIMFailed 4065

#pragma mark -
#pragma mark cluster event

#define kQQEventClusterGetInfoOK 5000
#define kQQEventClusterGetInfoFailed 5001
#define kQQEventClusterGetSubjectsOK 5002
#define kQQEventClusterGetSubjectsFailed 5003
#define kQQEventClusterGetDialogsOK 5004
#define kQQEventClusterGetDialogsFailed 5005
#define kQQEventClusterUpdateOrganizationOK 5006
#define kQQEventClusterUpdateOrganizationFailed 5007
#define kQQEventClusterGetMemberInfoOK 5008
#define kQQEventClusterGetMemberInfoFailed 5009
#define kQQEventClusterGetOnlineMemberOK 5010
#define kQQEventClusterGetOnlineMemberFailed 5011
#define kQQEventClusterSearchOK 5012
#define kQQEventClusterSearchFailed 5013
#define kQQEventClusterGetCardOK 5014
#define kQQEventClusterGetCardFailed 5015
#define kQQEventClusterBatchGetCardOK 5016
#define kQQEventClusterBatchGetCardFailed 5017
#define kQQEventClusterGetMessageSettingOK 5018
#define kQQEventClusterGetMessageSettingFailed 5019
#define kQQEventClusterModifyMessageSettingOK 5020
#define kQQEventClusterModifyMessageSettingFailed 5021
#define kQQEventClusterModifyChannelSettingOK 5022
#define kQQEventClusterModifyChannelSettingFailed 5023
#define kQQEventClusterGetChannelSettingOK 5024
#define kQQEventClusterGetChannelSettingFailed 5025
#define kQQEventClusterGetLastTalkTimeOK 5026
#define kQQEventClusterGetLastTalkTimeFailed 5027
#define kQQEventClusterModifyCardOK 5028
#define kQQEventClusterModifyCardFailed 5029
#define kQQEventClusterModifyInfoOK 5030
#define kQQEventClusterModifyInfoFailed 5031
#define kQQEventClusterModifyMemberOK 5032
#define kQQEventClusterModifyMemberFailed 5033
#define kQQEventClusterSendIMOK 5034
#define kQQEventClusterSendIMFailed 5035
#define kQQEventClusterExitOK 5036
#define kQQEventClusterExitFailed 5037
#define kQQEventClusterActivateOK 5040
#define kQQEventClusterActivateFailed 5041
#define kQQEventClusterSetRoleOK 5044
#define kQQEventClusterSetRoleFailed 5045
#define kQQEventClusterTransferRoleOK 5046
#define kQQEventClusterTransferRoleFailed 5047
#define kQQEventClusterDismissOK 5048
#define kQQEventClusterDismissFailed 5049
#define kQQEventClusterJoinOK 5050
#define kQQEventClusterJoinNeedAuth 5051
#define kQQEventClusterJoinRejected 5052
#define kQQEventClusterAuthorizationSendOK 5053
#define kQQEventClusterAuthorizationSendFailed 5054
#define kQQEventClusterCommandFailed 5055
#define kQQEventClusterGetVersionIdOK 5056
#define kQQEventClusterGetVersionIdFailed 5057

#pragma mark -
#pragma mark temp cluster event

#define kQQEventTempClusterGetInfoOK 6000
#define kQQEventTempClusterGetInfoFailed 6001
#define kQQEventTempClusterExitOK 6002
#define kQQEventTempClusterExitFailed 6003
#define kQQEventTempClusterActivateOK 6004
#define kQQEventTempClusterActivateFailed 6005
#define kQQEventTempClusterSendIMOK 6006
#define kQQEventTempClusterSendIMFailed 6007
#define kQQEventTempClusterCreateOK 6008
#define kQQEventTempClusterCreateFailed 6009
#define kQQEventTempClusterModifyInfoOK 6010
#define kQQEventTempClusterModifyInfoFailed 6011
#define kQQEventTempClusterModifyMemberOK 6012
#define kQQEventTempClusterModifyMemberFailed 6013

#pragma mark -
#pragma mark agent event

#define kQQEventRequestAgentOK 7000
#define kQQEventRequestAgentRedirect 7001
#define kQQEventRequestAgentRejected 7002
#define kQQEventRequestBeginOK 7003
#define kQQEventRequestFaceOK 7004
#define kQQEventImageInfoReceived 7005
#define kQQEventImageDataReceived 7006
#define kQQEventImageDataAcknowledged 7007
#define kQQEventImageInfoAcknowledged 7008

#pragma mark -
#pragma mark custom head event

#define kQQEventGetCustomHeadInfoOK 8000
#define kQQEventGetCustomHeadDataOK 8001