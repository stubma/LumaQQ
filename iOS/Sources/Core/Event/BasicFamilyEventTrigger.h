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
#import "QQClient.h"
#import "InPacket.h"

@interface BasicFamilyEventTrigger : NSObject {
}

+ (void)trigger:(QQClient*)client packet:(InPacket*)packet outPacket:(OutPacket*)outPacket connectionId:(int)connectionId;

+ (QQNotification*)processSelectServerReply:(InPacket*)packet;
+ (QQNotification*)processGetServerTokenReply:(InPacket*)packet;
+ (QQNotification*)processGetLoginTokenReply:(InPacket*)packet;
+ (QQNotification*)processPasswordVerifyReply:(InPacket*)packet;
+ (QQNotification*)processLoginReply:(InPacket*)packet;
+ (QQNotification*)processKeepAliveReply:(InPacket*)packet;
+ (QQNotification*)processGetKeyReply:(InPacket*)packet;
+ (QQNotification*)processChangeStatusReply:(InPacket*)packet;
+ (QQNotification*)processGetOnlineOpReply:(InPacket*)packet;
+ (QQNotification*)processGetUserInfoReply:(InPacket*)packet;
+ (QQNotification*)processGetFriendListReply:(InPacket*)packet;
+ (QQNotification*)processGetFriendGroupReply:(InPacket*)packet;
+ (QQNotification*)processGroupDataOpReply:(InPacket*)packet;
+ (QQNotification*)processFriendLevelOpReply:(InPacket*)packet;
+ (QQNotification*)processPropertyOpReply:(InPacket*)packet;
+ (QQNotification*)processSignatureOpReply:(InPacket*)packet;
+ (QQNotification*)processFriendDataOpReply:(InPacket*)packet;
+ (QQNotification*)processClusterReply:(InPacket*)packet;
+ (QQNotification*)processModifyInfoReply:(InPacket*)packet client:(QQClient*)client;
+ (QQNotification*)processAuthQuestionOpReply:(InPacket*)packet;
+ (QQNotification*)processPrivacyOpReply:(InPacket*)packet;
+ (QQNotification*)processSearchUserReply:(InPacket*)packet;
+ (QQNotification*)processAdvancedSearchUserReply:(InPacket*)packet;
+ (QQNotification*)processAddFriendReply:(InPacket*)packet;
+ (QQNotification*)processAuthInfoOpReply:(InPacket*)packet;
+ (QQNotification*)processAuthorizeReply:(InPacket*)packet;
+ (QQNotification*)processSystemNotification:(InPacket*)packet;
+ (QQNotification*)processDeleteFriendReply:(InPacket*)packet;
+ (QQNotification*)processReceivedIM:(InPacket*)packet;
+ (QQNotification*)processSendIMReply:(InPacket*)packet;
+ (QQNotification*)processRemoveSelfReply:(InPacket*)packet;
+ (QQNotification*)processUploadFriendGroupReply:(InPacket*)packet;
+ (QQNotification*)processSendSMSReply:(InPacket*)packet;
+ (QQNotification*)processFriendStatusChanged:(InPacket*)packet;
+ (QQNotification*)processTempSessionOpReply:(InPacket*)packet;
+ (QQNotification*)processWeatherOpReply:(InPacket*)packet;

@end
