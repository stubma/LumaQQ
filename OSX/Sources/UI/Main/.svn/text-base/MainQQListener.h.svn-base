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
#import "QQListener.h"
#import "QQNotification.h"
#import "GroupManager.h"
#import "User.h"

@class MainWindowController;

@interface MainQQListener : NSObject <QQListener> {
	MainWindowController* m_main;
	GroupManager* m_groupManager;
	User* m_me;
	
	// online friends cache
	NSMutableDictionary* m_onlines;
	NSMutableArray* m_onlineCache;
	BOOL m_firstOnlineCheckAfterLogin;
	
	// online users
	UInt32 m_onlineUserCount;
	
	// all users qq cache, used for get level
	NSArray* m_allUserQQs;
	
	// used for upload group friend
	NSDictionary* m_friendGroupMapping;
	int m_nextUploadPage;
}

- (id)initWithMainWindow:(MainWindowController*)main;

// getter and setter
- (UInt32)onlineUserCount;

// helper
- (void)uploadGroupNames;
- (void)uploadFriendGroups;

// qq event handler
- (BOOL)handleNetworkStarted;
- (BOOL)handleConnectionEstablished:(QQNotification*)event;
- (BOOL)handleConnectionTimeout:(QQNotification*)event;
- (BOOL)handleSelectServerOK:(QQNotification*)event;
- (BOOL)handleGetServerTokenOK:(QQNotification*)event;
- (BOOL)handleGetLoginTokenOK:(QQNotification*)event;
- (BOOL)handlePasswordVerifyOK:(QQNotification*)event;
- (BOOL)handleNeedVerifyCode:(QQNotification*)event;
- (BOOL)handleTimeout:(QQNotification*)event;
- (BOOL)handleLoginOK:(QQNotification*)event;
- (BOOL)handleLoginFailed:(QQNotification*)event;
- (BOOL)handlePasswordVerifyFailed:(QQNotification*)event;
- (BOOL)handleGetUserInfoOK:(QQNotification*)event;
- (BOOL)handleModifyInfoOK:(QQNotification*)event;
- (BOOL)handleNetworkError:(QQNotification*)event;
- (BOOL)handleChangeStatusOK:(QQNotification*)event;
- (BOOL)handleFriendStatusChanged:(QQNotification*)event;
- (BOOL)handleGetFriendListOK:(QQNotification*)event;
- (BOOL)handleGetFriendGroupOK:(QQNotification*)event;
- (BOOL)handleDownloadGroupNameOK:(QQNotification*)event;
- (BOOL)handleGetOnlineFriendOK:(QQNotification*)event;
- (BOOL)handleKeepAliveOK:(QQNotification*)event;
- (BOOL)handleGetUserPropertyOK:(QQNotification*)event;
- (BOOL)handleGetFriendLevelOK:(QQNotification*)event;
- (BOOL)handleGetSignatureOK:(QQNotification*)event;
- (BOOL)handleModifySignatureOK:(QQNotification*)event;
- (BOOL)handleBatchGetFriendRemarkOK:(QQNotification*)event;
- (BOOL)handleGetClusterMessageSettingOK:(QQNotification*)event;
- (BOOL)handleGetClusterInfoOK:(QQNotification*)event;
- (BOOL)handleGetClusterVersionIdOK:(QQNotification*)event;
- (BOOL)handleBatchGetClusterNameCardOK:(QQNotification*)event;
- (BOOL)handleGetSubjectsOK:(QQNotification*)event;
- (BOOL)handleGetSubjectsFailed:(QQNotification*)event;
- (BOOL)handleClusterSubOpTimeout:(QQNotification*)event;
- (BOOL)handleUpdateOrganizationOK:(QQNotification*)event;
- (BOOL)handleUpdateOrganizationFailed:(QQNotification*)event;
- (BOOL)handleUpdateOrganizationTimeout:(QQNotification*)event;
- (BOOL)handleGetMemberInfoOK:(QQNotification*)event;
- (BOOL)handleGetOnlineMemberOK:(QQNotification*)event;
- (BOOL)handleRemoveFriendFromServerListOK:(QQNotification*)event;
- (BOOL)handleReceivedIM:(QQNotification*)event;
- (BOOL)handleReceivedSystemNotification:(QQNotification*)event;
- (BOOL)handleExitClusterOK:(QQNotification*)event;
- (BOOL)handleExitTempClusterOK:(QQNotification*)event;
- (BOOL)handleSendIMOK:(QQNotification*)event;
- (BOOL)handleSendClusterIMOK:(QQNotification*)event;
- (BOOL)handleSMSSent:(QQNotification*)event;
- (BOOL)handleSendTempClusterIMOK:(QQNotification*)event;
- (BOOL)handleUploadGroupNameOK:(QQNotification*)event;
- (BOOL)handleUploadGroupNameFailed:(QQNotification*)event;
- (BOOL)handleUploadGroupNameTimeout:(QQNotification*)event;
- (BOOL)handleUploadFriendGroupOK:(QQNotification*)event;
- (BOOL)handleUploadFriendGroupFailed:(QQNotification*)event;
- (BOOL)handleGetTempClusterInfoOK:(QQNotification*)event;

@end
