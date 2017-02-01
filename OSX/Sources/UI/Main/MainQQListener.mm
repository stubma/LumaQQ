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

#import "MainQQListener.h"
#import "MainWindowController.h"
#import "AlertTool.h"
#import "SystemTool.h"
#import "ByteTool.h"
#import "TimerTaskManager.h"
#import "SoundHelper.h"
#import "Constants.h"
#import "ModelEffectTask.h"
#import "PreferenceCache.h"
#import "MessageWingTask.h"
#import "SystemMessageBlinkTask.h"
#import "SignatureChangedNotification.h"
#import "SendSMSPacket.h"
#import "SignatureOpPacket.h"
#import "TempClusterSendIMPacket.h"
#import <Growl/GrowlApplicationBridge.h>
#import "LQGrowlNotifyHelper.h"
#import "GetUserPropertyJob.h"
#import "GetFriendLevelJob.h"
#import "GetSignatureJob.h"
#import "GetRemarkJob.h"
#import "GetCustomHeadInfoJob.h"
#import "GetCustomHeadDataJob.h"

@implementation MainQQListener

- (id)initWithMainWindow:(MainWindowController*)main {
	self = [super init];
	if(self) {
		m_main = [main retain];
		m_groupManager = [[main groupManager] retain];
		m_me = [[main me] retain];
		
		m_onlines = [[NSMutableDictionary dictionary] retain];
		m_onlineCache = [[NSMutableArray array] retain];
		m_firstOnlineCheckAfterLogin = YES;
	}
	return self;
}

- (void) dealloc {
	[m_friendGroupMapping release];
	[m_main release];
	[m_groupManager release];
	[m_me release];
	[m_onlines release];
	[m_onlineCache release];
	[m_allUserQQs release];
	[super dealloc];
}

#pragma mark -
#pragma mark helper

- (void)uploadGroupNames {
	[m_main setProgressWindowHint:L(@"LQHintUploadGroupName", @"MainWindow")];
	[[m_main client] uploadGroupNames:[m_groupManager friendlyGroupNamesExceptMyFriends]];
}

- (void)uploadFriendGroups {
	int start = m_nextUploadPage * kQQMaxUploadGroupFriendCount;
	int to = start + MIN([m_allUserQQs count] - start, kQQMaxUploadGroupFriendCount);
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	for(int i = start; i < to; i++) {
		NSNumber* qq = [m_allUserQQs objectAtIndex:i];
		[dict setObject:[m_friendGroupMapping objectForKey:qq] forKey:qq];
	}
	[[m_main client] uploadFriendGroup:dict];
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventNetworkStarted:
			ret = [self handleNetworkStarted];
			break;
		case kQQEventNetworkConnectionEstablished:
			ret = [self handleConnectionEstablished:event];
			break;
		case kQQEventNetworkError:
			ret = [self handleNetworkError:event];
			break;
		case kQQEventSelectServerOK:
			ret = [self handleSelectServerOK:event];
			break;
		case kQQEventGetServerTokenOK:
			ret = [self handleGetServerTokenOK:event];
			break;
		case kQQEventGetLoginTokenOK:
			ret = [self handleGetLoginTokenOK:event];
			break;
		case kQQEventPasswordVerifyOK:
			ret = [self handlePasswordVerifyOK:event];
			break;
		case kQQEventNeedVerifyCode:
			ret = [self handleNeedVerifyCode:event];
			ret = YES;
			break;
		case kQQEventTimeoutBasic:
			ret = [self handleTimeout:event];
			break;
		case kQQEventLoginOK:
			ret = [self handleLoginOK:event];
			break;
		case kQQEventLoginFailed:
			ret = [self handleLoginFailed:event];
			break;
		case kQQEventPasswordVerifyFailed:
			ret = [self handlePasswordVerifyFailed:event];
			break;
		case kQQEventModifyInfoOK:
			ret = [self handleModifyInfoOK:event];
			break;
		case kQQEventGetUserInfoOK:
			ret = [self handleGetUserInfoOK:event];
			break;
		case kQQEventChangeStatusOK:
			ret = [self handleChangeStatusOK:event];
			break;
		case kQQEventFriendStatusChanged:
			ret = [self handleFriendStatusChanged:event];
			break;
		case kQQEventGetFriendListOK:
			ret = [self handleGetFriendListOK:event];
			break;
		case kQQEventGetFriendGroupOK:
			ret = [self handleGetFriendGroupOK:event];
			break;
		case kQQEventDownloadGroupNamesOK:
			ret = [self handleDownloadGroupNameOK:event];
			break;
		case kQQEventKeepAliveOK:
			ret = [self handleKeepAliveOK:event];
			break;
		case kQQEventGetOnlineFriendOK:
			ret = [self handleGetOnlineFriendOK:event];
			break;
		case kQQEventGetUserPropertyOK:
			ret = [self handleGetUserPropertyOK:event];
			break;
		case kQQEventGetFriendLevelOK:
			ret = [self handleGetFriendLevelOK:event];
			break;
		case kQQEventGetSignatureOK:
			ret = [self handleGetSignatureOK:event];
			break;
		case kQQEventModifySigatureOK:
			ret = [self handleModifySignatureOK:event];
			break;
		case kQQEventBatchGetFriendRemarkOK:
			ret = [self handleBatchGetFriendRemarkOK:event];
			break;
		case kQQEventClusterGetMessageSettingOK:
			ret = [self handleGetClusterMessageSettingOK:event];
			break;
		case kQQEventClusterGetInfoOK:
			ret = [self handleGetClusterInfoOK:event];
			break;
		case kQQEventClusterGetVersionIdOK:
			ret = [self handleGetClusterVersionIdOK:event];
			break;
		case kQQEventClusterBatchGetCardOK:
			ret = [self handleBatchGetClusterNameCardOK:event];
			break;
		case kQQEventClusterGetSubjectsOK:
			ret = [self handleGetSubjectsOK:event];
			break;
		case kQQEventClusterGetSubjectsFailed:
			ret = [self handleGetSubjectsFailed:event];
			break;
		case kQQEventClusterUpdateOrganizationOK:
			ret = [self handleUpdateOrganizationOK:event];
			break;
		case kQQEventClusterUpdateOrganizationFailed:
			ret = [self handleUpdateOrganizationFailed:event];
			break;
		case kQQEventClusterGetMemberInfoOK:
			ret = [self handleGetMemberInfoOK:event];
			break;
		case kQQEventClusterGetOnlineMemberOK:
			ret = [self handleGetOnlineMemberOK:event];
			break;
		case kQQEventTempClusterGetInfoOK:
			ret = [self handleGetTempClusterInfoOK:event];
			break;
		case kQQEventRemoveFriendFromListOK:
			ret = [self handleRemoveFriendFromServerListOK:event];
			break;
		case kQQEventSendIMOK:
			ret = [self handleSendIMOK:event];
			break;
		case kQQEventClusterSendIMOK:
			ret = [self handleSendClusterIMOK:event];
			break;
		case kQQEventSMSSent:
			ret = [self handleSMSSent:event];
			break;
		case kQQEventTempClusterSendIMOK:
			ret = [self handleSendTempClusterIMOK:event];
			break;
		case kQQEventReceivedIM:
			ret = [self handleReceivedIM:event];
			break;
		case kQQEventReceivedSystemNotification:
			ret = [self handleReceivedSystemNotification:event];
			break;
		case kQQEventClusterExitOK:
			ret = [self handleExitClusterOK:event];
			break;
		case kQQEventTempClusterExitOK:
			ret = [self handleExitTempClusterOK:event];
			break;
		case kQQEventUploadGroupNamesOK:
			ret = [self handleUploadGroupNameOK:event];
			break;
		case kQQEventUploadGroupNamesFailed:
			ret = [self handleUploadGroupNameFailed:event];
			break;
		case kQQEventUploadFriendGroupOK:
			ret = [self handleUploadFriendGroupOK:event];
			break;
		case kQQEventUploadFriendGroupFailed:
			ret = [self handleUploadFriendGroupFailed:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleConnectionTimeout:(QQNotification*)event {
	if([event connectionId] == [[m_main client] mainConnectionId]) {
		// restore from auto hide
		[m_main onRestoreFromAutoHide:self];
		
		[m_main shutdownNetwork];
		[m_main restartNetwork];
	}
	return NO;
}

- (BOOL)handleNetworkError:(QQNotification*)event {
	if([event connectionId] == [[m_main client] mainConnectionId]) {
		// restore from auto hide
		[m_main onRestoreFromAutoHide:self];
		
		[m_main shutdownNetwork];
		[m_main restartNetwork];
	}
	return NO;
}

- (BOOL)handleSelectServerOK:(QQNotification*)event {
	[m_main setHint:L(@"LQHintGetServerToken", @"MainWindow")];
	return YES;
}

- (BOOL)handleGetServerTokenOK:(QQNotification*)event {
	[m_main setHint:L(@"LQHintGetLoginToken", @"MainWindow")];
	return YES;
}

- (BOOL)handleGetLoginTokenOK:(QQNotification*)event {
	[m_main setHint:L(@"LQHintVerifyPassword", @"MainWindow")];
	return YES;
}

- (BOOL)handlePasswordVerifyOK:(QQNotification*)event {
	[m_main setHint:L(@"LQHintLogin", @"MainWindow")];
	return YES;
}

- (BOOL)handleGetUserInfoOK:(QQNotification*)event {
	GetUserInfoReplyPacket* packet = (GetUserInfoReplyPacket*)[event object];
	
	// set user info in global
	User* u = [m_groupManager user:[[packet contact] QQ]];
	if(u) {
		[u setContact:[packet contact]];
		[[[m_main client] user] setContact:[packet contact]];
		
		if([u QQ] == [m_me QQ]) {
			[m_me setContact:[packet contact]];
			
			// set mm icon if I am mm
			[m_main refreshDockIcon];
			
			// refresh UI
			[m_main refreshStatusUI];
			
			// set flag
			[m_main setMyInfoGot:YES];
		} else
			[[m_main userOutline] reloadItem:u];
	}
	
	return NO;
}

- (BOOL)handleModifyInfoOK:(QQNotification*)event {
	ModifyInfoPacket* packet = (ModifyInfoPacket*)[event outPacket];
	if([[packet user] QQ] == [m_me QQ]) {
		[(HeadControl*)[[m_main headItem] view] setHead:[[packet contact] head]];
	}
	return NO;
}

- (BOOL)handleConnectionEstablished:(QQNotification*)event {
	if([event connectionId] == [[m_main client] mainConnectionId]) {
		[m_main setHint:L(@"LQHintSelectServer", @"MainWindow")];
	}		
	return NO;
}

- (BOOL)handleNetworkStarted {
	[m_main setHint:L(@"LQHintConnectInitialServer", @"MainWindow")];
	return YES;
}

- (BOOL)handleNeedVerifyCode:(QQNotification*)event {
	GetLoginTokenReplyPacket* packet = (GetLoginTokenReplyPacket*)[event object];
	
	if([[[m_main verifyCodeWindowController] window] isVisible])
		[[m_main verifyCodeWindowController] refresh:packet];
	else
		[[m_main verifyCodeWindowController] beginSheet:packet];
	return YES;
}

- (BOOL)handleTimeout:(QQNotification*)event {
	OutPacket* packet = (OutPacket*)[event outPacket];
	
	switch([packet command]) {
		case kQQCommandGetLoginToken:
		case kQQCommandLogin:
			[m_main shutdownNetwork];
			[m_main restartNetwork];
			return YES;
		case kQQCommandKeepAlive:
			[self handleConnectionTimeout:event];
			return YES;
		case kQQCommandGetFriendGroup:
		case kQQCommandGetFriendList:
			[[m_main client] sendPacket:packet];
			return NO;
		case kQQCommandCluster:
			switch([(ClusterCommandPacket*)packet subCommand]) {
				case kQQSubCommandClusterUpdateOrganization:
					return [self handleUpdateOrganizationTimeout:event];
				case kQQSubCommandClusterSubOp:
					return [self handleClusterSubOpTimeout:event];
			}
			return NO;
		case kQQCommandUploadGroupFriend:
			[m_main showProgressWindow:NO];
			return YES;
		case kQQCommandGroupDataOp:
			GroupDataOpPacket* gop = (GroupDataOpPacket*)packet;
			switch([gop subCommand]) {
				case kQQSubCommandDownloadGroupName:
					[[m_main client] sendPacket:packet];
					return NO;
				case kQQSubCommandUploadGroupName:
					[self handleUploadGroupNameTimeout:event];
					return YES;
			}
			return NO;
		default:
			return NO;
	}
}

- (BOOL)handleLoginOK:(QQNotification*)event {
	// growl
	[[GrowlApplicationBridge growlDelegate] loginSuccess:m_me
										   lastLoginTime:[[[m_main client] user] lastLoginTime]
												 loginIp:[[[m_main client] user] ip]];
	
	// load groups
	[m_groupManager loadGroups];
	[m_me release];
	m_me = [m_groupManager user:[m_me QQ]];
	[m_main setMe:m_me];
	
	// check friend count
	if([m_groupManager friendCount] == 0) {
		// if zero, downloading friends
		[m_main setHint:L(@"LQHintDownloadGroupName", @"MainWindow")];
		[[m_main client] downloadGroupNames];
	} else {
		// initialize friend list UI
		[m_main setHint:L(@"LQHintInitializeUI", @"MainWindow")];
		[m_main initializeMainPane];
		[[m_main loginIndicator] stopAnimation:self];
		[[m_main mainTab] selectTabViewItemAtIndex:1];
		[[m_main window] setShowsToolbarButton:YES];
		[[m_main window] display];
		
		// install jobs
		GetUserPropertyJob* pJob = [[[GetUserPropertyJob alloc] init] autorelease];
		GetSignatureJob* sJob = [[[GetSignatureJob alloc] init] autorelease];
		GetCustomHeadInfoJob* iJob = [[[GetCustomHeadInfoJob alloc] init] autorelease];
		GetCustomHeadDataJob* dJob = [[[GetCustomHeadDataJob alloc] init] autorelease];
		[pJob addLinkJob:sJob];
		[pJob addLinkJob:iJob];
		[iJob addLinkJob:dJob];
		[[m_main jobController] startJob:pJob];
		[[m_main jobController] startJob:[[[GetFriendLevelJob alloc] init] autorelease]];
		
		// get online friend
		[[m_main client] getOnlineFriend];
		
		// refresh cluster
		[m_main refreshClusters:[m_groupManager allClusters]];
	}
	
	// play sound
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	if([cache isEnableSound])
		[[SoundHelper shared] playSound:kLQSoundLogin QQ:[m_me QQ]];
	
	return YES;
}

- (BOOL)handlePasswordVerifyFailed:(QQNotification*)event {
	PasswordVerifyReplyPacket* packet = (PasswordVerifyReplyPacket*)[event object];
	
	[AlertTool showWarning:[m_main window]
					 title:L(@"LQAlertTitle2", @"MainWindow")
				   message:[packet errorMessage]
				  delegate:m_main
			didEndSelector:@selector(loginFailedAlertDidEnd:returnCode:contextInfo:)];
	
	return YES;
}

- (BOOL)handleLoginFailed:(QQNotification*)event {
	[m_main shutdownNetwork];
	[m_main restartNetwork];
	return YES;
}

- (BOOL)handleChangeStatusOK:(QQNotification*)event {	
	// refresh ui
	[m_main setChangingStatus:NO];
	[m_main refreshStatusUI];
	
	return NO;
}

- (BOOL)handleFriendStatusChanged:(QQNotification*)event {
	FriendStatusChangedPacket* packet = [event object];
	FriendStatusChangedNotification* notify = [packet friendStatus];
	User* user = [m_groupManager user:[notify QQ]];
	if(user) {
		// copy info
		[user copyWithFriendStatusChangedNotification:notify];
		
		// get preference
		PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
		BOOL onlineTip = [cache isUserOnlineTipEnabled];
		
		// if user becomes online, flash name
		if([notify status] == kQQStatusAway || 
		   [notify status] == kQQStatusOnline ||
		   [notify status] == kQQStatusBusy ||
		   [notify status] == kQQStatusMute ||
		   [notify status] == kQQStatusQMe) {
			if(![user isVisible]) {
				[user setOnlining:YES];
				[[TimerTaskManager sharedManager] addTask:[ModelEffectTask taskWithMainWindow:m_main object:user]];
				
				// if not disable online tip, play sound
				
				if(onlineTip) {
					// play sound
					[[SoundHelper shared] playSound:kLQSoundUserOnline QQ:[m_me QQ]];
					
					// growl
					[[GrowlApplicationBridge growlDelegate] userOnline:user
															mainWindow:m_main];
				}
			}
		} else if(onlineTip) {
			// growl
			[[GrowlApplicationBridge growlDelegate] userOffline:user mainWindow:m_main];
		}
		
		// refresh ui
		if([notify QQ] == [m_me QQ])
			[m_main refreshStatusUI];
		else {
			[user setStatus:[notify status]];
			[[m_main userOutline] reloadItem:user];
		}
		
		// sort users
		Group* group = [m_groupManager group:[user groupIndex]];
		if(group) {
			[group sort];
			[[m_main userOutline] reloadItem:group reloadChildren:YES];
		}
	}
	return NO;
}

- (BOOL)handleGetFriendListOK:(QQNotification*)event {
	GetFriendListReplyPacket* packet = (GetFriendListReplyPacket*)[event object];
	
	// add friends
	[m_groupManager addFriends:[packet friends]];
	
	// finished?
	if([packet finished]) {
		if(![m_main isRefreshingFriendList]) {
			// initialize friend list UI
			[m_main setHint:L(@"LQHintInitializeUI", @"MainWindow")];
			[m_main initializeMainPane];
			[[m_main loginIndicator] stopAnimation:self];
			[[m_main mainTab] selectTabViewItemAtIndex:1];
			[[m_main window] setShowsToolbarButton:YES];
			[[m_main window] display];
		} else
			[m_main setRefreshingFriendList:NO];
		
		// install jobs
		GetUserPropertyJob* pJob = [[[GetUserPropertyJob alloc] init] autorelease];
		GetSignatureJob* sJob = [[[GetSignatureJob alloc] init] autorelease];
		GetCustomHeadInfoJob* iJob = [[[GetCustomHeadInfoJob alloc] init] autorelease];
		GetCustomHeadDataJob* dJob = [[[GetCustomHeadDataJob alloc] init] autorelease];
		[pJob addLinkJob:sJob];
		[pJob addLinkJob:iJob];
		[iJob addLinkJob:dJob];
		[[m_main jobController] startJob:pJob];
		[[m_main jobController] startJob:[[[GetFriendLevelJob alloc] init] autorelease]];
		[[m_main jobController] startJob:[[[GetRemarkJob alloc] init] autorelease]];
		
		// get online friend
		[[m_main client] getOnlineFriend];
	} else {
		[[m_main client] getFriendList:[packet nextStartPosition]];
	}
	
	return YES;
}

- (BOOL)handleGetFriendGroupOK:(QQNotification*)event {
	GetFriendGroupReplyPacket* packet = (GetFriendGroupReplyPacket*)[event object];
	
	// add friend groups
	[m_groupManager addFriendGroups:[packet friendGroups]];
	
	// finished?
	if([packet finished]) {
		[m_main setHint:L(@"LQHintDownloadFriend", @"MainWindow")];
		[[m_main client] getFriendList];
		
		// refresh cluster
		[m_main refreshClusters:[m_groupManager allClusters]];
	} else {
		[[m_main client] getFriendGroup:[packet nextStartPosition]];
	}
	
	return YES;
}

- (BOOL)handleDownloadGroupNameOK:(QQNotification*)event {
	GroupDataOpReplyPacket* packet = (GroupDataOpReplyPacket*)[event object];
	
	[m_groupManager initializeGroups:[packet groupNames]];
	if([m_main isRefreshingFriendList]) {
		[m_main reloadUsers];
		[m_main reloadClusters];
		[m_main reloadRecent];
	}
	[m_main setHint:L(@"LQHintDownloadFriendGroup", @"MainWindow")];
	[[m_main client] getFriendGroup];
	
	return YES;
}

- (BOOL)handleGetOnlineFriendOK:(QQNotification*)event {
	GetOnlineOpReplyPacket* packet = (GetOnlineOpReplyPacket*)[event object];
	
	// get preference
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	
	// refresh cache
	[m_onlineCache addObjectsFromArray:[packet friends]];
	
	// check new online friend, if has, play sound. If user forbid online hint, don't play sound
	if(!m_firstOnlineCheckAfterLogin) {
		NSEnumerator* e = [[packet friends] objectEnumerator];
		while(FriendStatus* fs = [e nextObject]) {
			if(![m_onlines objectForKey:fs]) {
				// sound
				if([cache isUserOnlineTipEnabled])
					[[SoundHelper shared] playSound:kLQSoundUserOnline QQ:[m_me QQ]];
				
				// growl
				User* user = [m_groupManager user:[fs QQ]];
				if(user)
					[[GrowlApplicationBridge growlDelegate] userOnline:user
															mainWindow:m_main];
			}
		}
	} else
		m_firstOnlineCheckAfterLogin = NO;
	
	// construct a new hash
	NSMutableDictionary* newOnlines = [NSMutableDictionary dictionary];
	NSEnumerator* e = [m_onlineCache objectEnumerator];
	FriendStatus* fs = nil;
	while(fs = [e nextObject]) {
		[newOnlines setObject:fs forKey:fs];
		
		// set status
		User* u = [m_groupManager user:[fs QQ]];
		if(u)
			[u copyWithFriendStatus:fs];
	}
	
	// then remove the users which is not in new onlines
	e = [m_onlines keyEnumerator];
	while(fs = [e nextObject]) {
		if(![newOnlines objectForKey:fs]) {
			User* u = [m_groupManager user:[fs QQ]];
			if(u) {
				[u setStatus:kQQStatusOffline];
				
				// growl
				[[GrowlApplicationBridge growlDelegate] userOffline:u mainWindow:m_main];
			}
		}
	}
	
	// swap online array
	[newOnlines retain];
	[m_onlines release];
	m_onlines = newOnlines;
	
	// refresh outline
	[m_groupManager sortAll];
	[[m_main userOutline] reloadData];
	
	return YES;
}

- (BOOL)handleKeepAliveOK:(QQNotification*)event {
	KeepAliveReplyPacket* packet = (KeepAliveReplyPacket*)[event object];
	
	// save online count
	m_onlineUserCount = [packet online];
	
	// clear online cache, because keep alive will trigger a get online friend request
	[m_onlineCache removeAllObjects];
	
	return YES;
}

- (BOOL)handleGetUserPropertyOK:(QQNotification*)event {
	PropertyOpReplyPacket* packet = (PropertyOpReplyPacket*)[event object];
	
	// set properties
	[m_groupManager setUserProperty:[packet properties]];

	return NO;
}

- (BOOL)handleGetFriendLevelOK:(QQNotification*)event {
	LevelOpReplyPacket* packet = (LevelOpReplyPacket*)[event object];
	
	// set levels
	[m_groupManager setFriendLevel:[packet levels]];
	
	return NO;
}

- (BOOL)handleGetSignatureOK:(QQNotification*)event {
	SignatureOpReplyPacket* packet = (SignatureOpReplyPacket*)[event object];
	
	// for update, so don't check sequence here
	[m_groupManager setSignature:[packet signatures]];
	
	return NO;
}

- (BOOL)handleModifySignatureOK:(QQNotification*)event {
	SignatureOpPacket* packet = (SignatureOpPacket*)[event outPacket];
	if([[packet user] QQ] == [[m_main me] QQ])
		[[m_main me] setSignature:[packet signature]];
	return NO;
}

- (BOOL)handleBatchGetFriendRemarkOK:(QQNotification*)event {
	FriendDataOpReplyPacket* packet = (FriendDataOpReplyPacket*)[event object];
	
	// set remark
	[m_groupManager setRemarks:[packet remarks]];
	
	return NO;
}

- (BOOL)handleGetClusterMessageSettingOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	NSEnumerator* e = [[packet messageSettings] objectEnumerator];
	while(ClusterMessageSetting* setting = [e nextObject]) {
		if([setting messageSetting] != kQQClusterMessageClearServerSetting) {
			Cluster* cluster = [m_groupManager cluster:[setting internalId]];
			if(cluster)
				[m_main changeClusterMessageSetting:cluster newMessageSetting:[setting messageSetting]];
		}
	}
	return NO;
}

- (BOOL)handleGetTempClusterInfoOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	
	// save cluster info
	[m_groupManager setClusterInfo:[packet info]];
	
	// set member
	Cluster* tempCluster = [m_groupManager cluster:[packet internalId]];
	if(tempCluster) {
		// set member
		[tempCluster clearMembers];
		[m_groupManager setMembers:[packet internalId] members:[packet members]];
		
		// refresh ui
		[[m_main clusterOutline] reloadItem:tempCluster];
	}
	return NO;
}

- (BOOL)handleGetClusterInfoOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = (ClusterCommandReplyPacket*)[event object];
	
	// save cluster info
	[m_groupManager setClusterInfo:[packet info]];
	
	// set member
	Cluster* c = [m_groupManager cluster:[packet internalId]];
	if(c) {
		[c clearMembers];
		[m_groupManager setMembers:[packet internalId] members:[packet members]];
		
		// get member info, divide into small packet because we only can get 30 members once
		NSArray* members = [c members];
		int count = [members count];
		int packets = (count - 1) / kQQMaxMemberInfoRequest + 1;
		for(int i = 0; i < packets; i++) {
			NSArray* temp = [members subarrayWithRange:NSMakeRange(i * kQQMaxMemberInfoRequest, MIN(kQQMaxMemberInfoRequest, count - i * kQQMaxMemberInfoRequest))];
			[[m_main client] getMemberInfo:[packet internalId] members:temp];
		}
		
		// get cluster version id
		[[m_main client] getVersionId:[packet internalId]];
	}
	
	// refresh outline
	[[m_main clusterOutline] reloadData];
	
	return NO;
}

- (BOOL)handleGetClusterVersionIdOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = (ClusterCommandReplyPacket*)[event object];
	
	// get cluster
	Cluster* c = [m_groupManager cluster:[packet internalId]];
	if(c) {
		if([packet clusterNameCardVersionId] > [c nameCardVersionId]) {
			[[m_main client] batchGetClusterNameCard:[c internalId] versionId:[c nameCardVersionId]];
			[c setNameCardVersionId:[packet clusterNameCardVersionId]];
		}
	}
	
	return NO;
}

- (BOOL)handleBatchGetClusterNameCardOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = (ClusterCommandReplyPacket*)[event object];
	
	// get cluster
	Cluster* c = [m_groupManager cluster:[packet internalId]];
	if(c) {
		ClusterBatchGetCardPacket* request = (ClusterBatchGetCardPacket*)[event outPacket];
		[m_groupManager setClusterNameCards:[c internalId] nameCards:[packet clusterNameCards]];
		if([packet nextStartPosition] != 0) {
			[[m_main client] batchGetClusterNameCard:[c internalId] 
									versionId:[request clusterNameCardVersionId] 
								startPosition:[packet nextStartPosition]];
		} else
			[[m_main clusterOutline] reloadItem:c reloadChildren:YES];
	}
	
	return NO;
}

- (BOOL)handleGetSubjectsOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = (ClusterCommandReplyPacket*)[event object];
	
	[m_groupManager setSubjects:[packet internalId] subjects:[packet subClusters]];
	
	Cluster* c = [m_groupManager cluster:[packet internalId]];
	if(c) {
		Dummy* subjects = [c subjectsDummy];
		[subjects setOperationSuffix:kStringEmpty];
		[[m_main clusterOutline] reloadItem:subjects];
	}
	return YES;
}

- (BOOL)handleGetSubjectsFailed:(QQNotification*)event {
	return [self handleClusterSubOpTimeout:event];
}

- (BOOL)handleClusterSubOpTimeout:(QQNotification*)event {
	ClusterCommandPacket* packet = (ClusterCommandPacket*)[event outPacket];
	
	switch([packet subSubCommand]) {
		case kQQSubSubCommandGetSubjects:
			Cluster* c = [m_groupManager cluster:[packet parentId]];
			if(c) {
				Dummy* subjects = [c subjectsDummy];
				[subjects setOperationSuffix:kStringEmpty];
				[[m_main clusterOutline] reloadItem:subjects];
			}
			break;
	}
	
	return YES;
}

- (BOOL)handleUpdateOrganizationOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = (ClusterCommandReplyPacket*)[event object];
	
	// save organizations
	[m_groupManager setOrganizations:[packet internalId] organizations:[packet organizations]];
	
	// get cluster
	Cluster* c = [m_groupManager cluster:[packet internalId]];
	if(c) {
		Dummy* organizations = [c organizationsDummy];
		[organizations setOperationSuffix:kStringEmpty];
		[[m_main clusterOutline] reloadItem:organizations];
	}
	
	// refresh outline
	[[m_main clusterOutline] reloadData];
	
	return YES;
}

- (BOOL)handleUpdateOrganizationFailed:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = (ClusterCommandReplyPacket*)[event object];
	
	// get cluster
	Cluster* c = [m_groupManager cluster:[packet internalId]];
	if(c) {
		Dummy* organizations = [c organizationsDummy];
		[organizations setOperationSuffix:kStringEmpty];
		[[m_main clusterOutline] reloadItem:organizations];
	}
	
	return YES;
}

- (BOOL)handleUpdateOrganizationTimeout:(QQNotification*)event {
	ClusterCommandPacket* packet = (ClusterCommandPacket*)[event outPacket];
	
	// get cluster
	Cluster* c = [m_groupManager cluster:[packet internalId]];
	if(c) {
		Dummy* organizations = [c organizationsDummy];
		[organizations setOperationSuffix:kStringEmpty];
		[[m_main clusterOutline] reloadItem:organizations];
	}

	return YES;
}

- (BOOL)handleGetMemberInfoOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = (ClusterCommandReplyPacket*)[event object];
	
	// set member infos
	[m_groupManager setMemberInfos:[packet memberInfos]];
	
	// get online members
	[[m_main client] getOnlineMember:[packet internalId]];
	
	// sort cluster
	Cluster* c = [m_groupManager cluster:[packet internalId]];
	if(c)
		[c sortAll];
		
	// refresh outline
	[[m_main clusterOutline] reloadData];
	
	return NO;
}

- (BOOL)handleGetOnlineMemberOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = (ClusterCommandReplyPacket*)[event object];
	
	// set status
	[m_groupManager setOnlineMembers:[packet memberQQs]];
	
	// sort cluster
	Cluster* c = [m_groupManager cluster:[packet internalId]];
	if(c)
		[c sortAll];
	
	// refresh outline
	[[m_main clusterOutline] reloadData];
	
	return NO;
}

- (BOOL)handleRemoveFriendFromServerListOK:(QQNotification*)event {
	FriendDataOpPacket* packet = (FriendDataOpPacket*)[event outPacket];
	User* user = [[m_groupManager user:[packet QQ]] retain];
	
	// get dest group
	NSNumber* key = [NSNumber numberWithUnsignedInt:[user QQ]];
	NSNumber* toGroupInteger = [[m_main removeFriendGroupMapping] objectForKey:key];
	
	if(toGroupInteger) {
		// clear mapping
		[[m_main removeFriendGroupMapping] removeObjectForKey:key];
		
		// get dest group, if dest group isn't friendly, move user
		// if dest group is blacklist, remove self from his friend list
		int toGroup = [toGroupInteger intValue];
		Group* group = [m_groupManager group:toGroup];
		if(group != nil && ![group isFriendly]) {
			Group* oldGroup = [m_groupManager group:[user groupIndex]];
			[m_groupManager moveUser:user toGroupIndex:toGroup];
			if(oldGroup)
				[[m_main userOutline] reloadItem:oldGroup reloadChildren:YES];
			[[m_main userOutline] reloadItem:group reloadChildren:YES];
			if([group isBlacklist]) {
				[[m_main client] removeSelfFrom:[user QQ]];
				
				// clear messages from this user
				[[m_main messageQueue] removeMessageFromUser:[user QQ]];
			}
		} else
			[m_main removeUserFromOutline:user];
	} else
		[m_main removeUserFromOutline:user];
	
	[user release];
	return NO;
}

- (BOOL)handleExitTempClusterOK:(QQNotification*)event {
	return [self handleExitClusterOK:event];
}

- (BOOL)handleExitClusterOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	Cluster* cluster = [m_groupManager cluster:[packet internalId]];
	if(cluster) {
		[m_groupManager removeCluster:cluster];
		[[m_main clusterOutline] reloadData];
	}
	return NO;
}

- (BOOL)handleSendIMOK:(QQNotification*)event {
	// add to recent contact
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	
	// get receiver object
	SendIMPacket* packet = (SendIMPacket*)[event outPacket];
	User* user = [m_groupManager user:[packet receiver]];

	// check user friendship
	if(user) {
		Group* group = [m_groupManager group:[user groupIndex]];
		if((group == nil || [group isStranger] && ![group isBlacklist]) && [cache keepStrangerInRecentContact] || group && [group isFriendly]) {
			[m_groupManager addRecentContact:user];
			[m_main reloadRecent];
		}
	}
	
	return NO;
}

- (BOOL)handleSendClusterIMOK:(QQNotification*)event {
	// get cluster object
	ClusterSendIMExPacket* packet = (ClusterSendIMExPacket*)[event outPacket];
	Cluster* cluster = [m_groupManager cluster:[packet internalId]];
	
	// add to recent
	if(cluster) {
		[m_groupManager addRecentContact:cluster];
		[m_main reloadRecent];
	}
	
	return NO;
}

- (BOOL)handleSMSSent:(QQNotification*)event {
	SendSMSPacket* request = (SendSMSPacket*)[event outPacket];
	NSEnumerator* e = [[request mobiles] objectEnumerator];
	while(NSString* mobile = [e nextObject]) {
		Mobile* m = [m_groupManager mobile:mobile];
		if(m)
			[m_groupManager addRecentContact:m];
	}
	e = [[request QQs] objectEnumerator];
	while(NSNumber* qq = [e nextObject]) {
		User* u = [m_groupManager user:[qq intValue]];
		if(u)
			[m_groupManager addRecentContact:u];
	}
	[m_main reloadRecent];
	
	return NO;
}

- (BOOL)handleSendTempClusterIMOK:(QQNotification*)event {
	TempClusterSendIMPacket* packet = (TempClusterSendIMPacket*)[event outPacket];
	Cluster* cluster = [m_groupManager cluster:[packet internalId]];
	
	// add to recent
	if(cluster) {
		[m_groupManager addRecentContact:cluster];
		[m_main reloadRecent];
	}
	
	return NO;
}

- (BOOL)handleReceivedIM:(QQNotification*)event {
	// if hot key is not enabled, the friend list is not populated, so cache the event
	// until the main UI is ready
	if(![m_main hotKeyEnabled]) {
		[[m_main postponedEventCache] addObject:event];
		return YES;
	}
	
	// save old system message count
	int oldSystemMessageCount = [[m_main messageQueue] systemMessageCount];
	
	BOOL enqueued = NO;
	BOOL jumpIcon = YES;
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	ReceivedIMPacket* packet = [event object];
	ReceivedIMPacketHeader* header = [packet imHeader];
	switch([header type]) {
		case kQQIMTypeFriend:
		case kQQIMTypeFriendEx:
		case kQQIMTypeStranger:
		case kQQIMTypeStrangerEx:
			// check normal im type
			if([[packet normalIMHeader] normalIMType] != kQQNormalIMTypeText)
				break;
			
			// get user relationship with me
			BOOL bBlacklist;
			BOOL bIAmHisStranger;
			BOOL bHeIsMyStranger;
			BOOL bNoUser;
			
			// get user and group
			User* user = [m_groupManager user:[header sender]];
			Group* g = (user == nil) ? nil : [m_groupManager group:[user groupIndex]];
			
			// check relationship
			bIAmHisStranger = ([header type] == kQQIMTypeStranger || [header type] == kQQIMTypeStrangerEx);
			bNoUser = user == nil || g == nil;
			bHeIsMyStranger = bNoUser || [g isStranger];
			bBlacklist = !bNoUser && [g isBlacklist];
			
			// if user is in blacklist, don't push message into queue
			// or if user is stranger and you set to reject stranger message, don't push...
			if(bBlacklist)
				break;
			if(bNoUser && bIAmHisStranger)
				break;
			if(bHeIsMyStranger && [cache rejectStrangerMessage])
				break;
			
			// create user if user is nil
			if(user == nil) {
				// create user add to friend or stranger group
				user = [[[User alloc] initWithQQ:[header sender] domain:m_main] autorelease];
				[m_groupManager addUser:user groupIndex:[m_groupManager strangerGroupIndex]];
				[[m_main userOutline] reloadItem:[m_groupManager strangerGroup] reloadChildren:YES];						
				[[m_main client] getUserInfo:[user QQ]];
			}
				
			// get user group, if group is nil, make group point to stranger group
			g = [m_groupManager group:[user groupIndex]];
			if(g == nil) {
				[m_groupManager addUser:user groupIndex:[m_groupManager strangerGroupIndex]];
				[[m_main userOutline] reloadItem:[m_groupManager strangerGroup] reloadChildren:YES];
				g = [m_groupManager strangerGroup];
				[user setGroupIndex:[m_groupManager strangerGroupIndex]];
			}
				
			// get history, add it to history
			History* history = [[m_main historyManager] getHistoryToday:[NSString stringWithFormat:@"%u", [user QQ]]];
			[history addPacket:packet];
			
			// push message to message queue
			[[m_main messageQueue] enqueue:packet];
			enqueued = YES;
			
			// check auto eject option
			// if need eject, open im window, otherwise play sound
			BOOL hasKeyWindow = [[m_main windowRegistry] isNormalIMWindowOrTabFocused:[NSNumber numberWithUnsignedInt:[user QQ]]
																		   mainWindow:m_main];
			if([cache autoEjectMessage] || hasKeyWindow) {
				// open im window
				NSWindowController* winController = [[m_main windowRegistry] showNormalIMWindowOrTab:user mainWindow:m_main];
				
				// activate im window
				[NSApp activateIgnoringOtherApps:YES];
				[[winController window] orderFront:self];
				[[winController window] makeKeyWindow];
				
				// no jump
				enqueued = NO;
				jumpIcon = NO;
			} else {
				[user increaseMessageCount];
				[g increaseMessageCount];
				if([user messageCount] + [user mobileMessageCount] + [user tempSessionMessageCount] == 1) {
					[[TimerTaskManager sharedManager] addTask:[ModelEffectTask taskWithMainWindow:m_main object:user]];
					[[TimerTaskManager sharedManager] addTask:[ModelEffectTask taskWithMainWindow:m_main object:g]];
				}		
			}		
				
			// a window is opened, no sound needed
			if(!hasKeyWindow) {
				// sound
				if([cache isEnableSound])
					[[SoundHelper shared] playSound:kLQSoundUserMessage QQ:[m_me QQ]];
				
				// growl
				[[GrowlApplicationBridge growlDelegate] normalIM:user
														  packet:packet
													  mainWindow:m_main];
			}
				
			// if message if from mobile QQ, then set mobile chatting flag to this user
			if([[packet normalIM] fromMobileQQ]) {
				if(![user mobileChatting]) {
					[user setMobileChatting:YES];
					[[m_main userOutline] reloadItem:user];
				}
			} else {
				if([user mobileChatting]) {
					[user setMobileChatting:NO];
					[[m_main userOutline] reloadItem:user];
				}
			}
			break;
		case kQQIMTypeTempSession:
			// get user
			user = [m_groupManager user:[header sender]];
			if(user == nil) {
				user = [[[User alloc] initWithQQ:[header sender] domain:m_main] autorelease];				
				TempSessionIM* im = [packet tempSessionIM];
				[user setNick:[im nick]];
				
				// add to uesr registry
				[m_groupManager addUser:user groupIndex:kGroupIndexUndefined];
			}
			
			// get group
			g = [m_groupManager group:[user groupIndex]];
			
			// check relationship
			bBlacklist = g != nil && [g isBlacklist];
				
			// if user is in blacklist, don't push message into queue
			// or if user is stranger and you set to reject stranger message, don't push...
			if(bBlacklist)
				break;
			if([cache rejectStrangerMessage])
				break;
			
			// get history, add it to history
			history = [[m_main historyManager] getHistoryToday:[NSString stringWithFormat:@"%u_tempsession", [user QQ]]];
			[history addPacket:packet];
			
			// push message to message queue
			[[m_main messageQueue] enqueue:packet];
			enqueued = YES;
			
			// check auto eject option
			// if need eject, open im window, otherwise play sound
			hasKeyWindow = [[m_main windowRegistry] isTempSessionIMWindowOrTabFocused:[NSNumber numberWithUnsignedInt:[user QQ]] mainWindow:m_main];
			if([cache autoEjectMessage] || hasKeyWindow) {
				// open im window
				NSWindowController* winController = [[m_main windowRegistry] showTempSessionIMWindowOrTab:user mainWindow:m_main];
				
				// activate im window
				[NSApp activateIgnoringOtherApps:YES];
				[[winController window] orderFront:self];
				[[winController window] makeKeyWindow];
				
				// no jump
				enqueued = NO;
				jumpIcon = NO;
			} else {
				[user increaseTempSessionMessageCount];
				if(g) {					
					[g increaseMessageCount];
					if([user messageCount] + [user mobileMessageCount] + [user tempSessionMessageCount] == 1) {
						[[TimerTaskManager sharedManager] addTask:[ModelEffectTask taskWithMainWindow:m_main object:user]];
						[[TimerTaskManager sharedManager] addTask:[ModelEffectTask taskWithMainWindow:m_main object:g]];
					}	
				}
			}		
				
			// if no window is opened, show sound and growl hint
			if(!hasKeyWindow) {
				// sound
				if([cache isEnableSound])
					[[SoundHelper shared] playSound:kLQSoundUserMessage QQ:[m_me QQ]];
				
				// growl
				[[GrowlApplicationBridge growlDelegate] tempSessionIM:user
															   packet:packet
														   mainWindow:m_main];
			}
				
			break;
		case kQQIMTypeMobileQQ:
			// get user and group
			user = [m_groupManager user:[header sender]];
			g = (user == nil) ? nil : [m_groupManager group:[user groupIndex]];
			
			// create user if user is nil
			if(user == nil) {
				// create user add to friend or stranger group
				user = [[[User alloc] initWithQQ:[header sender] domain:m_main] autorelease];
				[m_groupManager addUser:user groupIndex:[m_groupManager strangerGroupIndex]];
				[[m_main userOutline] reloadItem:[m_groupManager strangerGroup] reloadChildren:YES];						
				[[m_main client] getUserInfo:[user QQ]];
			}
				
			// get user group, if group is nil, make group point to stranger group
			g = [m_groupManager group:[user groupIndex]];
			if(g == nil) {
				[m_groupManager addUser:user groupIndex:[m_groupManager strangerGroupIndex]];
				[[m_main userOutline] reloadItem:[m_groupManager strangerGroup] reloadChildren:YES];
				g = [m_groupManager strangerGroup];
				[user setGroupIndex:[m_groupManager strangerGroupIndex]];
			}
				
			// get history, add it to history
			history = [[m_main historyManager] getHistoryToday:[NSString stringWithFormat:@"%u_mobile", [user QQ]]];
			[history addPacket:packet];
			
			// push message to message queue
			[[m_main messageQueue] enqueue:packet];
			enqueued = YES;
			
			// check auto eject option
			// if need eject, open im window, otherwise play sound
			hasKeyWindow = [[m_main windowRegistry] isMobileIMWindowOrTabFocused:[NSNumber numberWithUnsignedInt:[user QQ]]
																	  mainWindow:m_main];
			if([cache autoEjectMessage] || hasKeyWindow) {
				// open im window
				NSWindowController* winController = [[m_main windowRegistry] showMobileIMWindowOrTab:user mainWindow:m_main];
				
				// activate im window
				[NSApp activateIgnoringOtherApps:YES];
				[[winController window] orderFront:self];
				[[winController window] makeKeyWindow];
				
				// no jump
				enqueued = NO;
				jumpIcon = NO;
			} else {
				[user increaseMobileMessageCount];
				[g increaseMessageCount];
				if([user mobileMessageCount] + [user messageCount] + [user tempSessionMessageCount] == 1) {
					[[TimerTaskManager sharedManager] addTask:[ModelEffectTask taskWithMainWindow:m_main object:user]];
					[[TimerTaskManager sharedManager] addTask:[ModelEffectTask taskWithMainWindow:m_main object:g]];
				}		
			}			
				
			// a window is opened, no sound needed
			if(!hasKeyWindow) {
				// sound
				if([cache isEnableSound])
					[[SoundHelper shared] playSound:kLQSoundUserMessage QQ:[m_me QQ]];
				
				// growl
				[[GrowlApplicationBridge growlDelegate] mobileIMFromUser:user
																  packet:packet
															  mainWindow:m_main];
			}
				
			break;
		case kQQIMTypeMobileQQ2:
			// get mobile, if can't, create one
			MobileIM* mobileIM = [packet mobileIM];
			Mobile* mobile = [m_groupManager mobile:[mobileIM mobile]];
			if(mobile == nil) {
				mobile = [[[Mobile alloc] initWithMobile:[mobileIM mobile] domain:m_main] autorelease];
				[m_groupManager addMobile:mobile];
				[[m_main mobileTable] reloadData];
			}
				
			// get history, add it to history
			history = [[m_main historyManager] getHistoryToday:[mobile mobile]];
			[history addPacket:packet];
				
			// enqueue
			[[m_main messageQueue] enqueue:packet];
			enqueued = YES;
			
			// check auto eject option
			hasKeyWindow = [[m_main windowRegistry] isMobileIMWindowOrTabFocusedByMobile:[mobile mobile]
																			  mainWindow:m_main];
			if([cache autoEjectMessage] || hasKeyWindow) {
				// open im window
				NSWindowController* winController = [[m_main windowRegistry] showMobileIMWindowOrTabByMobile:mobile mainWindow:m_main];
				
				// activate im window
				[NSApp activateIgnoringOtherApps:YES];
				[[winController window] orderFront:self];
				[[winController window] makeKeyWindow];
				
				// no jump
				enqueued = NO;
				jumpIcon = NO;
			} else {
				[mobile increaseMessageCount];
				if([mobile messageCount] == 1) {
					[[TimerTaskManager sharedManager] addTask:[ModelEffectTask taskWithMainWindow:m_main object:mobile]];
				}		
			}
			
			// if window is not opened, show sound and growl hint
			if(!hasKeyWindow) {
				// sound
				if([cache isEnableSound])
					[[SoundHelper shared] playSound:kLQSoundUserMessage QQ:[m_me QQ]];
				
				// growl
				[[GrowlApplicationBridge growlDelegate] mobileIM:mobile
														  packet:packet
													  mainWindow:m_main];
			}
			break;
		case kQQIMTypeTempCluster:
			// get temp cluter
			ClusterIM* clusterIM = [packet clusterIM];
			Cluster* tempCluster = [m_groupManager cluster:[clusterIM internalId]];
			BOOL noSuchCluster = tempCluster == nil;
			
			// get parent cluster, if nil, add it
			Cluster* parentCluster = [m_groupManager cluster:[clusterIM parentInternalId]];
			if(parentCluster == nil) {
				// add cluster
				if([clusterIM parentInternalId] != 0) {
					parentCluster = [[[Cluster alloc] initWithInternalId:[clusterIM parentInternalId] domain:m_main] autorelease];
					[m_groupManager addCluster:parentCluster];
					[[m_main clusterOutline] reloadData];
					[[m_main client] getClusterInfo:[parentCluster internalId]];
				}
			} else if([parentCluster memberCount] == 0)
				[[m_main client] getClusterInfo:[parentCluster internalId]];
			
			// if temp cluster nil, create temp cluster and add it
			if(tempCluster == nil) {
				// add 
				tempCluster = [[[Cluster alloc] initWithInternalId:[clusterIM internalId] domain:m_main] autorelease];
				[tempCluster setPermanent:NO];
				[tempCluster setTempType:([clusterIM parentInternalId] == 0 ? kQQTempClusterTypeDialog : kQQTempClusterTypeSubject)];
				[tempCluster setParentId:[clusterIM parentInternalId]];
				[m_groupManager addCluster:tempCluster];
				
				// refresh ui
				[[m_main clusterOutline] reloadData];
				
				// get temp cluster info
				if([tempCluster isSubject])
					[[m_main client] getSubjectInfo:[tempCluster internalId] parent:[tempCluster parentId]];
				else if([tempCluster isDialog])
					[[m_main client] getDialogInfo:[tempCluster internalId]];
			} 
				
			// get temp cluster info if necessary
			if(noSuchCluster && [[tempCluster info] version] < [clusterIM versionId]) {
				// get cluster info
				if([clusterIM parentInternalId] == 0)
					[[m_main client] getDialogInfo:[tempCluster internalId]];
				else
					[[m_main client] getSubjectInfo:[tempCluster internalId]
											 parent:[clusterIM parentInternalId]];
			}
				
			// if sender is me, don't push to queue
			if([clusterIM sender] != [m_me QQ]) {	
				// get history, save it to history
				History* history = [[m_main historyManager] getHistoryToday:[NSString stringWithFormat:@"%u", [tempCluster internalId]]];
				
				if([[m_main windowRegistry] isClusterIMWindowOrTabFocused:[NSNumber numberWithUnsignedInt:[tempCluster internalId]]
															   mainWindow:m_main]) {
					// push message
					[[m_main messageQueue] enqueue:packet];
					
					// get window
					NSWindowController* winController = [[m_main windowRegistry] showClusterIMWindowOrTab:tempCluster mainWindow:m_main];
					
					// activate im window
					[NSApp activateIgnoringOtherApps:YES];
					[[winController window] orderFront:self];
					[[winController window] makeKeyWindow];
					
					// save history
					[history addPacket:packet];
					
					jumpIcon = NO;
				} else {
					[[m_main messageQueue] enqueue:packet];
					enqueued = YES;
					
					// add to history
					[history addPacket:packet];
					
					// increase messsage count
					[tempCluster increaseMessageCount];
					[[TimerTaskManager sharedManager] addTask:[ModelEffectTask taskWithMainWindow:m_main object:tempCluster]];					
					
					// sound
					if([cache isEnableSound])
						[[SoundHelper shared] playSound:kLQSoundClusterMessage QQ:[m_me QQ]];
					
					// growl
					User* u = [m_groupManager user:[clusterIM sender]];
					if(u == nil)
						u = [[[User alloc] initWithQQ:[clusterIM sender] domain:m_main] autorelease];
					[[GrowlApplicationBridge growlDelegate] clusterIM:tempCluster
																 user:u
															   packet:packet
														   mainWindow:m_main];
				}
			}
			break;
		case kQQIMTypeCluster:
		case kQQIMTypeClusterUnknown:
			Cluster* cluster = [m_groupManager cluster:[header sender]];
			if(cluster == nil) {
				// add cluster
				cluster = [[[Cluster alloc] initWithInternalId:[header sender] domain:m_main] autorelease];
				[m_groupManager addCluster:cluster];
				[[m_main clusterOutline] reloadData];
				[[m_main client] getClusterInfo:[cluster internalId]];
			} else if([[cluster info] version] < [[packet clusterIM] versionId]) {
				// check version id, get info if local info is out of date
				[[cluster info] setVersion:[[packet clusterIM] versionId]];
				[[m_main client] getClusterInfo:[header sender]];
			}
			
			// if sender is me, don't push to queue
			if([[packet clusterIM] sender] != [m_me QQ]) {	
				// get history, save it to history
				History* history = [[m_main historyManager] getHistoryToday:[NSString stringWithFormat:@"%u", [cluster internalId]]];
				
				if([[m_main windowRegistry] isClusterIMWindowOrTabFocused:[NSNumber numberWithUnsignedInt:[cluster internalId]]
															   mainWindow:m_main]) {
					// push message
					[[m_main messageQueue] enqueue:packet];
					
					// get window
					NSWindowController* winController = [[m_main windowRegistry] showClusterIMWindowOrTab:cluster mainWindow:m_main];
					
					// activate im window
					[NSApp activateIgnoringOtherApps:YES];
					[[winController window] orderFront:self];
					[[winController window] makeKeyWindow];
					
					// save history
					[history addPacket:packet];
					
					jumpIcon = NO;
				} else {
					// check other cluster message setting
					switch([cluster messageSetting]) {
						case kQQClusterMessageAutoEject:
							[[m_main messageQueue] enqueue:packet];
							NSWindowController* winController = [[m_main windowRegistry] showClusterIMWindowOrTab:cluster mainWindow:m_main];
							
							// activate im window
							[NSApp activateIgnoringOtherApps:YES];
							[[winController window] orderFront:self];
							[[winController window] makeKeyWindow];
							
							// play sound
							[[SoundHelper shared] playSound:kLQSoundClusterMessage QQ:[m_me QQ]];
							
							// no jump
							enqueued = NO;
							jumpIcon = NO;		
							
							// add to history
							[history addPacket:packet];
							break;
						case kQQClusterMessageDisplayCount:
							[[m_main messageQueue] enqueue:packet];
							[cluster increaseMessageCount];
							[[m_main clusterOutline] reloadItem:cluster];
							jumpIcon = NO;
							
							// add to history
							[history addPacket:packet];
							break;
						case kQQClusterMessageAcceptNoPrompt:							
							// add to history
							[history addPacket:packet];
							break;
						case kQQClusterMessageAccept:
							[[m_main messageQueue] enqueue:packet];
							enqueued = YES;
							
							// add to history
							[history addPacket:packet];
							
							// increase message count
							[cluster increaseMessageCount];
							[[TimerTaskManager sharedManager] addTask:[ModelEffectTask taskWithMainWindow:m_main object:cluster]];
							
							// sound
							if([cache isEnableSound])
								[[SoundHelper shared] playSound:kLQSoundClusterMessage QQ:[m_me QQ]];
								
							// growl
							User* u = [m_groupManager user:[[packet clusterIM] sender]];
							if(u == nil)
								u = [[[User alloc] initWithQQ:[[packet clusterIM] sender] domain:m_main] autorelease];
							[[GrowlApplicationBridge growlDelegate] clusterIM:cluster
																		 user:u
																	   packet:packet
																   mainWindow:m_main];
							break;
						case kQQClusterMessageBlock:
							// play sound
							if([cache isEnableSound])
								[[SoundHelper shared] playSound:kLQSoundMessageBlocked QQ:[m_me QQ]];
							break;
					}	
				}
			}
			break;
		case kQQIMTypeRequestJoinCluster:
			if(![m_main shouldBlockRequest:[[packet clusterNotification] sourceQQ]]) {				
				// get history, add it to history
				History* history = [[m_main historyManager] getHistoryToday:@"10000"];
				[history addPacket:packet];
				
				// add to queue
				[[m_main messageQueue] enqueue:packet];
				enqueued = YES;
				
				// play sound
				if([cache isEnableSound])
					[[SoundHelper shared] playSound:kLQSoundSystemMessage QQ:[m_me QQ]];
				
				// growl
				[[GrowlApplicationBridge growlDelegate] systemIM:packet mainWindow:m_main];
			}
			break;
		case kQQIMTypeApprovedJoinCluster:			
			// get history, add it to history
			history = [[m_main historyManager] getHistoryToday:@"10000"];
			[history addPacket:packet];
			
			// add to queue
			[[m_main messageQueue] enqueue:packet];
			enqueued = YES;
			cluster = [m_groupManager cluster:[header sender]];
			if(cluster == nil) {
				cluster = [[Cluster alloc] initWithInternalId:[header sender] domain:m_main];
				[cluster setExternalId:[[packet clusterNotification] externalId]];
				[m_groupManager addCluster:cluster];
				[[m_main clusterOutline] reloadData];
				[[m_main client] getClusterInfo:[cluster internalId]];
				[cluster release];
			}
				
			// play sound
			if([cache isEnableSound])
				[[SoundHelper shared] playSound:kLQSoundGoodSystemMessage QQ:[m_me QQ]];
				
			// growl
			[[GrowlApplicationBridge growlDelegate] systemIM:packet mainWindow:m_main];
			break;
		case kQQIMTypeClusterCreated:			
			// get history, add it to history
			history = [[m_main historyManager] getHistoryToday:@"10000"];
			[history addPacket:packet];
			
			// add to queue
			[[m_main messageQueue] enqueue:packet];
			enqueued = YES;
			cluster = [m_groupManager cluster:[header sender]];
			if(cluster == nil) {
				cluster = [[Cluster alloc] initWithInternalId:[header sender] domain:m_main];
				[cluster setExternalId:[[packet clusterNotification] externalId]];
				[m_groupManager addCluster:cluster];
				[[m_main clusterOutline] reloadData];
				[[m_main client] getClusterInfo:[cluster internalId]];
				[cluster release];
			}
				
			// play sound
			if([cache isEnableSound])
				[[SoundHelper shared] playSound:kLQSoundSystemMessage QQ:[m_me QQ]];
				
			// growl
			[[GrowlApplicationBridge growlDelegate] systemIM:packet mainWindow:m_main];
			break;
		case kQQIMTypeRejectedJoinCluster:			
			// get history, add it to history
			history = [[m_main historyManager] getHistoryToday:@"10000"];
			[history addPacket:packet];
			
			// add to queue
			[[m_main messageQueue] enqueue:packet];
			enqueued = YES;
			
			// play sound
			if([cache isEnableSound])
				[[SoundHelper shared] playSound:kLQSoundBadSystemMessage QQ:[m_me QQ]];
			
			// growl
			[[GrowlApplicationBridge growlDelegate] systemIM:packet mainWindow:m_main];
			break;
		case kQQIMTypeJoinedCluster:			
			// get history, add it to history
			history = [[m_main historyManager] getHistoryToday:@"10000"];
			[history addPacket:packet];
			
			// add to queue
			[[m_main messageQueue] enqueue:packet];
			enqueued = YES;
			
			// ensure we have this cluster object
			ClusterNotification* n = [packet clusterNotification];
			if([n sourceQQ] == [m_me QQ]) {
				cluster = [m_groupManager cluster:[header sender]];
				if(cluster == nil) {
					cluster = [[Cluster alloc] initWithInternalId:[header sender] domain:m_main];
					[cluster setExternalId:[[packet clusterNotification] externalId]];
					[m_groupManager addCluster:cluster];
					[[m_main clusterOutline] reloadData];
					[[m_main client] getClusterInfo:[cluster internalId]];
					[cluster release];
				}
			}
				
			// play sound
			if([cache isEnableSound])
				[[SoundHelper shared] playSound:kLQSoundSystemMessage QQ:[m_me QQ]];
				
			// growl
			[[GrowlApplicationBridge growlDelegate] systemIM:packet mainWindow:m_main];
			break;
		case kQQIMTypeExitedCluster:			
			// get history, add it to history
			history = [[m_main historyManager] getHistoryToday:@"10000"];
			[history addPacket:packet];
			
			// add to queue
			[[m_main messageQueue] enqueue:packet];
			enqueued = YES;
			n = [packet clusterNotification];
			if([n sourceQQ] == [m_me QQ]) {
				cluster = [m_groupManager cluster:[header sender]];
				if(cluster) {
					[m_groupManager removeCluster:cluster];
					[[m_main clusterOutline] reloadData];
				}
			}
				
			// play sound
			if([cache isEnableSound])
				[[SoundHelper shared] playSound:kLQSoundSystemMessage QQ:[m_me QQ]];
				
			// growl
			[[GrowlApplicationBridge growlDelegate] systemIM:packet mainWindow:m_main];
			break;
		case kQQIMTypeSystem:
			SystemIM* systemIM = [packet systemIM];
			switch([systemIM type]) {
				case kQQSystemIMTypeKickOut:
					// growl
					[[GrowlApplicationBridge growlDelegate] kickedOut:m_me];
					
					// restore from auto hide
					[m_main onRestoreFromAutoHide:self];
					
					// show alert
					[AlertTool showWarning:[m_main window]
									 title:L(@"LQWarning")
								   message:L(@"LQWarningKickedOut", @"MainWindow")
								  delegate:m_main
							didEndSelector:@selector(kickedOutAlertDidEnd:returnCode:contextInfo:)];
					
					// play sound
					if([cache isEnableSound])
						[[SoundHelper shared] playSound:kLQSoundKickedOut QQ:[m_me QQ]];
					break;
			}
			break;
		case kQQIMTypeSignatureChangedNotification:
			SignatureChangedNotification* scn = [packet signatureNotification];
			user = [m_groupManager user:[scn QQ]];
			if(user) {
				[user copyWithSignatureChangedNotification:scn];
				[[m_main userOutline] reloadItem:user];
			}
			break;
		case kQQIMTypeCustomHeadChangedNotification:
			// set custom head
			NSArray* heads = [packet customHeads];
			NSEnumerator* e = [heads objectEnumerator];
			while(CustomHead* head = [e nextObject]) {
				user = [m_groupManager user:[head QQ]];
				if(user)
					[user setCustomHead:head];
			}
				
			// start job
			if(![[m_main jobController] hasJob:kJobGetCustomHeadData])
				[[m_main jobController] startJob:[[[GetCustomHeadDataJob alloc] initWithCustomHeads:heads] autorelease]];
			break;
	}
	
	// check jump icon option
	if(enqueued) {		
		// jump icon if necessary
		if(jumpIcon && [cache jumpIconWhenReceivedIM])
			[NSApp requestUserAttention:NSCriticalRequest];
		
		// refresh dock icon as well as side widow
		[m_main refreshDockIcon];
		
		// show animation if necessary
		if(![cache disableDockIconAnimation])
			[[TimerTaskManager sharedManager] addTask:[MessageWingTask taskWithMainWindow:m_main]];
		
		// if system message count became 1, start blink task
		if(oldSystemMessageCount == 0 && [[m_main messageQueue] systemMessageCount] == 1)
			[[TimerTaskManager sharedManager] addTask:[SystemMessageBlinkTask taskWithMainWindow:m_main]];
	}
	
	return YES;
}

- (BOOL)handleReceivedSystemNotification:(QQNotification*)event {
	// if hot key is not enabled, the friend list is not populated, so cache the event
	// until the main UI is ready
	if(![m_main hotKeyEnabled]) {
		[[m_main postponedEventCache] addObject:event];
		return YES;
	}
	
	// system message, bad, good or neutral? on means good, off means bad, mix means...
	NSCellStateValue state = NSMixedState;
	
	// get old system message count
	int oldSystemMessageCount = [[m_main messageQueue] systemMessageCount];
	
	SystemNotificationPacket* packet = [event object];
	switch([packet subCommand]) {
		case kQQSubCommandOtherRequestAddMeEx:
			if(![m_main shouldBlockRequest:[packet sourceQQ]])
				[[m_main messageQueue] enqueue:packet];
			break;
		case kQQSubCommandOtherApproveMyRequest:
		case kQQSubCommandOtherApproveMyRequestAndAddMe:
			// add user in my friend list
			state = NSOnState;
			[m_main addFriend:[packet sourceQQ]];
			[[m_main messageQueue] enqueue:packet];
			break;
		case kQQSubCommandOtherAddMeEx:
			// add to stranger
			User* user = [m_groupManager user:[packet sourceQQ]];
			if(user == nil) {
				user = [[User alloc] initWithQQ:[packet sourceQQ] domain:m_main];
				[m_groupManager addUser:user groupIndex:[m_groupManager strangerGroupIndex]];
				[[m_main userOutline] reloadItem:[m_groupManager strangerGroup] reloadChildren:YES];
				[[m_main client] getUserInfo:[user QQ]];
				[user release];
			} 
			[[m_main messageQueue] enqueue:packet];
			break;
		case kQQSubCommandOtherRejectMyRequest:
			state = NSOffState;
			[[m_main messageQueue] enqueue:packet];
			break;
		default:
			return YES;
	}
	
	// add to history
	History* history = [[m_main historyManager] getHistoryToday:@"10000"];
	[history addPacket:packet];
	
	// check jump icon option
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	if([cache jumpIconWhenReceivedIM])
		[NSApp requestUserAttention:NSCriticalRequest];
	if(![cache disableDockIconAnimation])
		[[TimerTaskManager sharedManager] addTask:[MessageWingTask taskWithMainWindow:m_main]];
	else
		[m_main refreshDockIcon];
	
	// if system message count became 1, start blink task
	if(oldSystemMessageCount == 0 && [[m_main messageQueue] systemMessageCount] == 1)
		[[TimerTaskManager sharedManager] addTask:[SystemMessageBlinkTask taskWithMainWindow:m_main]];
	
	// play sound
	if([cache isEnableSound]) {
		if(state == NSMixedState)
			[[SoundHelper shared] playSound:kLQSoundSystemMessage QQ:[m_me QQ]];
		else if(state == NSOnState)
			[[SoundHelper shared] playSound:kLQSoundGoodSystemMessage QQ:[m_me QQ]];
		else
			[[SoundHelper shared] playSound:kLQSoundBadSystemMessage QQ:[m_me QQ]];
	}
	
	// growl
	[[GrowlApplicationBridge growlDelegate] systemIM:packet mainWindow:m_main];
	
	return YES;
}

- (BOOL)handleUploadGroupNameOK:(QQNotification*)event {
	// set hint
	[m_main setProgressWindowHint:L(@"LQHintUploadFriendGroup", @"MainWindow")];	
	
	// get mapping
	m_friendGroupMapping = [[m_groupManager friendGroupMapping] retain];
	m_nextUploadPage = 0;
	
	if(m_allUserQQs)
		[m_allUserQQs release];
	m_allUserQQs = [[m_friendGroupMapping allKeys] retain];
	[self uploadFriendGroups];
	return YES;
}

- (BOOL)handleUploadGroupNameFailed:(QQNotification*)event {
	[m_main showProgressWindow:NO];
	return YES;
}

- (BOOL)handleUploadGroupNameTimeout:(QQNotification*)event {
	[m_main showProgressWindow:NO];
	return YES;
}

- (BOOL)handleUploadFriendGroupOK:(QQNotification*)event {
	m_nextUploadPage++;
	if(m_nextUploadPage * kQQMaxUploadGroupFriendCount >= [m_friendGroupMapping count])
		[m_main showProgressWindow:NO];
	else
		[self uploadFriendGroups];
	return YES;
}

- (BOOL)handleUploadFriendGroupFailed:(QQNotification*)event {
	[m_main showProgressWindow:NO];
	return YES;
}

#pragma mark -
#pragma mark url connection delegate

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection autorelease];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[connection autorelease];
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)onlineUserCount {
	return m_onlineUserCount;
}

@end
