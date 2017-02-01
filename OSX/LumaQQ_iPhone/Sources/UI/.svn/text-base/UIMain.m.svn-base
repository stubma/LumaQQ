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

#import <UIKit/UIKit.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIAlphaAnimation.h>
#import <UIKit/UIAnimator.h>
#import "UIMain.h"
#import "LocalizedStringTool.h"
#import "NSString-Validate.h"
#import "UIController.h"
#import "UIUtil.h"
#import "SoundTool.h"
#import "GroupCell.h"
#import "PreferenceTool.h"
#import "UserCell.h"
#import "ImageTool.h"
#import "ClusterCell.h"
#import "ClusterMessageSetting.h"
#import "ClusterCommandReplyPacket.h"
#import "ClusterBatchGetCardPacket.h"
#import "PropertyOpReplyPacket.h"
#import "LevelOpReplyPacket.h"
#import "SignatureOpReplyPacket.h"
#import "GetOnlineOpReplyPacket.h"
#import "FriendDataOpReplyPacket.h"
#import "GetUserInfoReplyPacket.h"
#import "GetUserPropertyJob.h"
#import "GetSignatureJob.h"
#import "GetRemarkJob.h"
#import "GetFriendLevelJob.h"
#import "MessageManager.h"
#import "GetClusterNameCardJob.h"
#import "GetClusterInfoJob.h"
#import "GetMemberInfoJob.h"
#import "GetOnlineMemberJob.h"
#import "GetMessageSettingJob.h"
#import "GetClusterVersionIdJob.h"
#import "AuthInfoOpReplyPacket.h"
#import "UploadFriendGroupJob.h"
#import "FriendStatusChangedPacket.h"
#import "MessageHistory.h"
#import "FileTool.h"

// declared in GroupCell.m
extern const float GROUP_CELL_HEIGHT;

// declared in UserCell.m
extern const float USER_CELL_HEIGHT;

// declared in ClusterCell.m
extern const float CLUSTER_CELL_HEIGHT;

// my qq
UInt32 gMyQQ;

// theme
extern Theme gTheme;

// alert type
#define _kAlertConfirmLogout 0
#define _kAlertConfirmMoveToStranger 1
#define _kAlertConfirmMoveToBlacklist 2
#define _kAlertConfirmAddUserAsFriend 3
#define _kAlertKickedOut 4
#define _kAlertDeleteUserFailed 5
#define _kAlertConfirmUpload 6
#define _kAlertConfirmDeleteAllHistory 7

@implementation UIMain

- (void) dealloc {
	// remove notification handler
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kWillResumeNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kWillSuspendNotificationName
												  object:nil];
	
	// release object
	[_view release];
	[_userTable release];
	[_clusterTable release];
	[_messageTable release];
	[_recentTable release];
	[_searchTable release];
	[_moreTable release];
	[_historyTable release];
	[_data release];
	[_onlineUsers release];
	[_userDataSource release];
	[_clusterDataSource release];
	[_myselfDataSource release];
	[_messageDataSource release];
	[_searchTableDataSource release];
	[_recentTableDataSource release];
	[_historyTableDataSource release];
	[_moreTableDataSource release];
	[_messageManager release];
	[_deleteUserAuthInfo release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitMain;
}

- (void)begin:(UIController*)uiController {
	// save controller
	_uiController = uiController;
	
	// push navigation item
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:@""] autorelease];
	[[uiController navBar] pushNavigationItem:item];
	
	// show button
	[[uiController navBar] showButtonsWithLeftTitle:L(@"Logout") rightTitle:L(@"Preference")];
	
	// set delegate
	[[uiController navBar] setDelegate:self];
	
	// listen notification
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleGroupExpandStatusChanged:)
												 name:kGroupExpandStatusChangedNotificationName
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleClusterExpandStatusChanged:)
												 name:kClusterExpandStatusChangedNotificationName
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleCellDoubleTapped:)
												 name:kCellDoubleTappedNotificationName
											   object:nil];
}

- (void)stop:(UIController*)uiController {
	[[[uiController navBar] navigationItems] removeAllObjects];
	[[uiController navBar] setDelegate:nil];
	
	// remove notification
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kGroupExpandStatusChangedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kClusterExpandStatusChangedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kCellDoubleTappedNotificationName
												  object:nil];
}

- (UIView*)view {
	if(_view == nil) {
		// init
		_oldSelectedUserTableCell = -1;
		_oldSelectedClusterTableCell = -1;
		_oldSelectedMessageTableCell = -1;
		_oldSelectedRecentTableCell = -1;
		_oldSelectedHistoryTableCell = -1;
		_messageManager = [[MessageManager alloc] initWithMain:self];
		_relogin = NO;
											  
		// create top view
		CGRect bound = [_uiController clientRect];
		_view = [[UIView alloc] initWithFrame:bound];
		
		// button bar height
		int barHeight = 45;
		bound.size.height -= barHeight;
		
		// create user table
		_userTable = [[UITable alloc] initWithFrame:bound];
		UITableColumn* col = [[[UITableColumn alloc] initWithTitle:@"User" 
														identifier:@"user"
															 width:bound.size.width] autorelease];
		[_userTable addTableColumn:col];
		[_userTable setSeparatorStyle:kTableSeparatorSingle];
		[_userTable setDelegate:self];
		[_view addSubview:_userTable];
		_selectedTag = kTagUsers;
		
		// create cluster table
		_clusterTable = [[UITable alloc] initWithFrame:bound];
		col = [[[UITableColumn alloc] initWithTitle:@"Cluster" 
										 identifier:@"cluster"
											  width:bound.size.width] autorelease];
		[_clusterTable addTableColumn:col];
		[_clusterTable setSeparatorStyle:kTableSeparatorSingle];
		[_clusterTable setDelegate:self];
		
		// create message table
		_messageTable = [[UITable alloc] initWithFrame:bound];
		_messageDataSource = [[MessageTableDataSource alloc] initWithMessageManager:_messageManager];
		col = [[[UITableColumn alloc] initWithTitle:@"Message" 
										 identifier:@"message"
											  width:bound.size.width] autorelease];
		[_messageTable addTableColumn:col];
		[_messageTable setSeparatorStyle:kTableSeparatorSingle];
		[_messageTable setDataSource:_messageDataSource];
		[_messageTable setDelegate:self];
		
		// create recent table
		_recentTable = [[UITable alloc] initWithFrame:bound];
		col = [[[UITableColumn alloc] initWithTitle:@"Recent" 
										 identifier:@"recent"
											  width:bound.size.width] autorelease];
		[_recentTable addTableColumn:col];
		[_recentTable setSeparatorStyle:kTableSeparatorSingle];
		[_recentTable setDelegate:self];
		
		// create more table
		_moreTable = [[UITable alloc] initWithFrame:bound];
		_moreTableDataSource = [[MoreTableDataSource alloc] initWithMain:self];
		col = [[[UITableColumn alloc] initWithTitle:@"More" 
										 identifier:@"more"
											  width:bound.size.width] autorelease];
		[_moreTable addTableColumn:col];
		[_moreTable setSeparatorStyle:kTableSeparatorSingle];
		[_moreTable setDataSource:_moreTableDataSource];
		[_moreTable setDelegate:self];
		
		// create history table
		_historyTable = [[UISwipeDeleteTable alloc] initWithFrame:bound];
		col = [[[UITableColumn alloc] initWithTitle:@"History" 
										 identifier:@"history"
											  width:bound.size.width] autorelease];
		[_historyTable addTableColumn:col];
		[_historyTable setSeparatorStyle:kTableSeparatorSingle];
		[_historyTable setDelegate:self];
		
		// create search table
		_searchTable = [[UIPreferencesTable alloc] initWithFrame:bound];
		_searchTableDataSource = [[SearchTableDataSource alloc] init];
		[_searchTable setDataSource:_searchTableDataSource];
		[_searchTable setDelegate:_searchTableDataSource];
		[_searchTable reloadData];
		
		// create myself table
		_myselfTable = [[UIPreferencesTable alloc] initWithFrame:bound];
		_myselfDataSource = [[MyselfTableDataSource alloc] init];
		[_myselfTable setDataSource:_myselfDataSource];
		[_myselfTable setDelegate:_myselfDataSource];
		
		// setup cell button event handler
		[[[_myselfDataSource infoCell] control] addTarget:self action:@selector(viewMyInfoButtonClicked:) forEvents:kUIMouseUp];
		[[[_myselfDataSource applyCell] control] addTarget:self action:@selector(applyStatusChangeButtonClicked:) forEvents:kUIMouseUp];
		
		// create button bar
		bound.origin.y = bound.size.height;
		bound.size.height = barHeight;
		_buttonBarFrame = bound;
		
		// add notification handle
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleWillResume:)
													 name:kWillResumeNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleWillSuspend:)
													 name:kWillSuspendNotificationName
												   object:nil];
	}
	return _view;
}

- (UIButtonBar*)_createButtonBar {
	// remove button bar
	if(_buttonBar) {
		[_buttonBar removeFromSuperview];
		[_buttonBar release];
		_buttonBar = nil;
	}
	
	// create a new one
	NSDictionary* myselfDict = [NSDictionary dictionaryWithObjectsAndKeys:self, kUIButtonBarButtonTarget,
		@"myselfButtonClicked:", kUIButtonBarButtonAction,
		[NSNumber numberWithUnsignedInt:kTagMyself], kUIButtonBarButtonTag,
		kImageMyselfButtonOff, kUIButtonBarButtonInfo,
		kImageMyselfButtonOn, kUIButtonBarButtonSelectedInfo,
		L(@"Myself"), kUIButtonBarButtonTitle,
		nil];
	NSDictionary* userDict = [NSDictionary dictionaryWithObjectsAndKeys:self, kUIButtonBarButtonTarget,
		@"userButtonClicked:", kUIButtonBarButtonAction,
		[NSNumber numberWithUnsignedInt:kTagUsers], kUIButtonBarButtonTag,
		kImageUserButtonOff, kUIButtonBarButtonInfo,
		kImageUserButtonOn, kUIButtonBarButtonSelectedInfo,
		L(@"Friends"), kUIButtonBarButtonTitle,
		nil];
	NSDictionary* clusterDict = [NSDictionary dictionaryWithObjectsAndKeys:self, kUIButtonBarButtonTarget,
		@"clusterButtonClicked:", kUIButtonBarButtonAction,
		[NSNumber numberWithUnsignedInt:kTagClusters], kUIButtonBarButtonTag,
		kImageClusterButtonOff, kUIButtonBarButtonInfo,
		kImageClusterButtonOn, kUIButtonBarButtonSelectedInfo,
		L(@"Clusters"), kUIButtonBarButtonTitle,
		nil];
	NSDictionary* messageDict = [NSDictionary dictionaryWithObjectsAndKeys:self, kUIButtonBarButtonTarget,
		@"messageButtonClicked:", kUIButtonBarButtonAction,
		[NSNumber numberWithUnsignedInt:kTagMessage], kUIButtonBarButtonTag,
		kImageMessageButtonOff, kUIButtonBarButtonInfo,
		kImageMessageButtonOn, kUIButtonBarButtonSelectedInfo,
		L(@"Message"), kUIButtonBarButtonTitle,
		nil];
	NSDictionary* searchDict = [NSDictionary dictionaryWithObjectsAndKeys:self, kUIButtonBarButtonTarget,
		@"searchButtonClicked:", kUIButtonBarButtonAction,
		[NSNumber numberWithUnsignedInt:kTagSearch], kUIButtonBarButtonTag,
		kImageSearchButtonOff, kUIButtonBarButtonInfo,
		kImageSearchButtonOn, kUIButtonBarButtonSelectedInfo,
		L(@"Search"), kUIButtonBarButtonTitle,
		nil];
	NSDictionary* recentDict = [NSDictionary dictionaryWithObjectsAndKeys:self, kUIButtonBarButtonTarget,
		@"recentButtonClicked:", kUIButtonBarButtonAction,
		[NSNumber numberWithUnsignedInt:kTagRecent], kUIButtonBarButtonTag,
		kImageRecentButtonOff, kUIButtonBarButtonInfo,
		kImageRecentButtonOn, kUIButtonBarButtonSelectedInfo,
		L(@"Recent"), kUIButtonBarButtonTitle,
		nil];
	NSDictionary* customizeDict = [NSDictionary dictionaryWithObjectsAndKeys:self, kUIButtonBarButtonTarget,
		@"customizeButtonClicked:", kUIButtonBarButtonAction,
		[NSNumber numberWithUnsignedInt:kTagCustomize], kUIButtonBarButtonTag,
		kImageCustomizeButtonOff, kUIButtonBarButtonInfo,
		kImageCustomizeButtonOn, kUIButtonBarButtonSelectedInfo,
		L(@"More"), kUIButtonBarButtonTitle,
		nil];
	NSDictionary* historyDict = [NSDictionary dictionaryWithObjectsAndKeys:self, kUIButtonBarButtonTarget,
		@"historyButtonClicked:", kUIButtonBarButtonAction,
		[NSNumber numberWithUnsignedInt:kTagHistory], kUIButtonBarButtonTag,
		kImageHistoryButtonOff, kUIButtonBarButtonInfo,
		kImageHistoryButtonOn, kUIButtonBarButtonSelectedInfo,
		L(@"History"), kUIButtonBarButtonTitle,
		nil];
	NSArray* items = [NSArray arrayWithObjects:myselfDict, userDict, clusterDict, messageDict, recentDict, searchDict, customizeDict, historyDict, nil];
	_buttonBar = [[UIButtonBar alloc] initInView:_view withFrame:_buttonBarFrame withItemList:items];
	[_buttonBar setDelegate:self];
	[_buttonBar setBarStyle:gTheme.mainButtonBarStyle];
	[_buttonBar setButtonBarTrackingMode:2];
	
	// get buttons array
	int first;
	PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
	int buttonCount = [tool intValue:kPreferenceKeyButtonBarButtonCount];
	NSArray* buttonArray = [tool arrayValue:kPreferenceKeyButtonBar];
	if(buttonArray && [buttonArray count] == buttonCount) {
		// create an int array
		int count = [buttonArray count];
		int* buttons = (int*)malloc(sizeof(int) * count);
		int i;
		for(i = 0; i < count; i++) {
			NSNumber* b = [buttonArray objectAtIndex:i];
			buttons[i] = [b intValue];
		}
		first = buttons[0];
		
		// register
		[_buttonBar registerButtonGroup:0 withButtons:buttons withCount:count];
		
		// free
		free(buttons);
	} else {
		if(buttonCount <= 0)
			buttonCount = 5;
		if(buttonCount > 7)
			buttonCount = 7;
		int* buttons = (int*)malloc(sizeof(int) * buttonCount);
		int i;
		for(i = 1; i < buttonCount; i++)
			buttons[i - 1] = i;
		buttons[buttonCount - 1] = kTagCustomize; 
		first = buttons[0];
		[_buttonBar registerButtonGroup:0 withButtons:buttons withCount:buttonCount];
		free(buttons);
	}
	[_buttonBar showButtonGroup:0 withDuration:0.0f];
	
	// create decorator
	[self _createMyselfDecorator];
	
	// go to first view
	[self _switchToView:[self _viewWithTag:first]];
	_selectedTag = first;
}

- (void)_createMyselfDecorator {
	// get myself button, add a image view to it
	UIButtonBarButton* myselfButton = [_buttonBar viewWithTag:kTagMyself];
	if(myselfButton) {
		CGRect bound = [myselfButton bounds];
		_myselfDecorator = [[[UIImageView alloc] initWithFrame:CGRectMake(bound.size.width - 22.0f, 6.0f, 11.0f, 11.0f)] autorelease];
		[myselfButton addSubview:_myselfDecorator];
	}
}

- (void)_resetNavigationButton {
	switch(_selectedTag) {
		case kTagRecent:
			[[_uiController navBar] showButtonsWithLeftTitle:L(@"Clear") rightTitle:nil];
			break;
		case kTagCustomize:
			[[_uiController navBar] showButtonsWithLeftTitle:L(@"Customize") rightTitle:nil];
			break;
		case kTagHistory:
			[[_uiController navBar] showButtonsWithLeftTitle:L(@"DeleteAll") rightTitle:nil];
			break;
		default:
			[[_uiController navBar] showButtonsWithLeftTitle:L(@"Logout") rightTitle:L(@"Preference")];
			break;
	}
}

- (void)refresh:(NSMutableDictionary*)data {
	if(data != nil) {
		// save ref
		[data retain];
		[_data release];
		_data = data;
		_client = [_data objectForKey:kDataKeyClient];
		_groupManager = [_data objectForKey:kDataKeyGroupManager];
		_customizing = NO;
		
		// set my qq
		NSNumber* qq = [_data objectForKey:kDataKeyQQ];
		gMyQQ = [qq unsignedIntValue];
		
		// reset message history
		[MessageHistory resetForQQ:gMyQQ];
		
		// create objects
		[_messageManager reset];
		[_messageManager loadUnread];
		_onlineUsers = [[NSMutableArray array] retain];
		
		// create button bar
		[self _createButtonBar];
		
		// select user panel
		[_buttonBar showSelectionForButton:kTagUsers];
		[self userButtonClicked:nil];
		
		// refresh navigation title
		[[[_uiController navBar] topItem] setTitle:[NSString stringWithFormat:@"%u", gMyQQ]];
		
		// reload table
		if(_userDataSource) {
			[_userDataSource release];
			_userDataSource = nil;
		}
		if(_clusterDataSource) {
			[_clusterDataSource release];
			_clusterDataSource = nil;
		}
		if(_recentTableDataSource) {
			[_recentTableDataSource release];
			_recentTableDataSource = nil;
		}
		if(_historyTableDataSource) {
			[_historyTableDataSource release];
			_historyTableDataSource = nil;
		}
		_userDataSource = [[UserTableDataSource alloc] initWithGroupManager:_groupManager];
		[_userTable setDataSource:_userDataSource];
		[_userTable reloadData];
		_clusterDataSource = [[ClusterTableDataSource alloc] initWithGroupManager:_groupManager messageManager:_messageManager];
		[_clusterTable setDataSource:_clusterDataSource];
		[_clusterTable reloadData];
		_recentTableDataSource = [[RecentTableDataSource alloc] initWithGroupManager:_groupManager];
		[_recentTable setDataSource:_recentTableDataSource];
		_historyTableDataSource = [[HistoryTableDataSource alloc] initWithGroupManager:_groupManager];
		[_historyTable setDataSource:_historyTableDataSource];
		[_myselfTable reloadData];
		[_messageTable reloadData];
		[_moreTableDataSource update:_moreTable];
		
		// add qq listener
		[_client addQQListener:self];
		
		// restore status message
		PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
		NSString* statusMessage = [tool stringValue:kPreferenceKeyStatusMessage];
		if(![statusMessage isEmpty])
			[_client changeStatusMessage:statusMessage];
		
		// install jobs
		JobController* jobController = [[JobController alloc] initWithContext:_data];
		GetUserPropertyJob* pJob = [[[GetUserPropertyJob alloc] init] autorelease];
		GetSignatureJob* sJob = [[[GetSignatureJob alloc] init] autorelease];
		[pJob addLinkJob:sJob];
		[jobController setTarget:self];
		[jobController setAction:@selector(friendJobTerminated:)];
		[jobController startJob:pJob];
		[jobController startJob:[[[GetFriendLevelJob alloc] init] autorelease]];
		[jobController startJob:[[[GetRemarkJob alloc] init] autorelease]];
		
		// get online friend
		[_client getOnlineFriend];
		
		// get cluster info
		NSArray* clusters = [_groupManager allClusters];
		[self startClusterJob:clusters];
		
		// process cached messages
		NSMutableArray* cachedMessages = [_data objectForKey:kDataKeyCachedMessages];
		NSMutableArray* cachedSystemNotifications = [_data objectForKey:kDataKeyCachedSystemNotifications];
		if(cachedMessages != nil || cachedSystemNotifications != nil) {
			if(cachedMessages != nil) {
				NSEnumerator* e = [cachedMessages objectEnumerator];
				ReceivedIMPacket* packet = nil;
				while(packet = [e nextObject])
					[_messageManager put:packet];
				
				[_data removeObjectForKey:kDataKeyCachedMessages];
			}
			if(cachedSystemNotifications != nil) {
				NSEnumerator* e = [cachedSystemNotifications objectEnumerator];
				SystemNotificationPacket* packet = nil;
				while(packet = [e nextObject])
					[_messageManager putSystemNotification:packet];
				
				[_data removeObjectForKey:kDataKeyCachedSystemNotifications];
			}
			
			// refresh UI
			[_userTable reloadData];
			[_clusterTable reloadData];
			[_messageTable reloadData];
		}
		
		// add notification handler which should be uninstall when logout
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleMessageSourcePopulated:)
													 name:kMessageSourcePopulatedNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleHasMessageUnreadSourcePopulated:)
													 name:kHasMessageUnreadNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleHasMessageUnreadSourcePopulated:)
													 name:kHasMessageUnreadNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleGroupNameChanged:)
													 name:kGroupNameChangedNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleGroupWillBeCreated:)
													 name:kGroupWillBeCreatedNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleUserRemarkNameChanged:)
													 name:kUserRemarkNameChangedNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleWantToDeleteGroup:)
													 name:kWantToDeleteGroupNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleClusterExited:)
													 name:kClusterExitedNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleClusterMessagetSettingChanged:)
													 name:kClusterMessagetSettingChangedNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handlePreferenceChanged:)
													 name:kPreferenceChangedNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleUserWillBeMovedToGroup:)
													 name:kUserWillBeMovedToGroupNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleUserRemoved:)
													 name:kUserRemovedNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleKickedOutBySystem:)
													 name:kKickedOutBySystemNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleFriendGroupRebuilt:)
													 name:kFriendGroupRebuiltNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleSendIMOK:)
													 name:kSendIMOKNotificationName
												   object:nil];
		
		// install status icon
		if([_messageManager displayableMessageCount] > 0)
			[UIApp addStatusBarImageNamed:@"LumaQQ_Message" removeOnAbnormalExit:YES];
		else
			[UIApp addStatusBarImageNamed:@"LumaQQ" removeOnAbnormalExit:YES];
		
		// initial message badge
		[self _refreshMessageButtonBadge];
	} else {
		// refresh navigation title
		[[[_uiController navBar] topItem] setTitle:[NSString stringWithFormat:@"%u", gMyQQ]];
		
		// reload message table
		if(_selectedTag == kTagMessage)
			[_messageTable reloadData];
		
		// refresh navigation button
		[self _resetNavigationButton];
	}
}

- (void)startClusterJob:(NSArray*)clusters {
	JobController* clusterJobController = [[JobController alloc] initWithContext:_data];
	GetClusterInfoJob* gciJob = [[[GetClusterInfoJob alloc] initWithClusters:clusters] autorelease];
	GetMessageSettingJob* gmsj = [[[GetMessageSettingJob alloc] initWithClusters:clusters] autorelease];
	GetClusterVersionIdJob* gcviJob = [[[GetClusterVersionIdJob alloc] initWithClusters:clusters] autorelease];
	GetMemberInfoJob* gmiJob = [[[GetMemberInfoJob alloc] initWithClusters:clusters] autorelease];
	GetOnlineMemberJob* gomJob = [[[GetOnlineMemberJob alloc] initWithClusters:clusters] autorelease];
	GetClusterNameCardJob* gcncJob = [[[GetClusterNameCardJob alloc] initWithClusters:clusters] autorelease];
	[gciJob addLinkJob:gmsj];
	[gmsj addLinkJob:gcviJob];
	[gcviJob addLinkJob:gmiJob];
	[gmiJob addLinkJob:gomJob];
	[gomJob addLinkJob:gcncJob];
	[clusterJobController setTarget:self];
	[clusterJobController setAction:@selector(clusterJobTerminated:)];
	[clusterJobController startJob:gciJob];
}

- (void)myselfButtonClicked:(UIButtonBarButton*)button {
	// check tag
	if(_selectedTag == kTagMyself)
		return;
	
	// update myself panel
	PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
	[_myselfDataSource updateStatusMessage:[tool stringValue:kPreferenceKeyStatusMessage]];
	[_myselfDataSource updateStatus:[[_client user] status]];
	
	// go to myself panel
	[self _switchToView:_myselfTable];
	_selectedTag = kTagMyself;
	
	// update focus
	[_myselfDataSource updateFocus:_myselfTable];
	
	// show button
	[[_uiController navBar] showButtonsWithLeftTitle:L(@"Logout") rightTitle:L(@"Preference")];
}

- (void)userButtonClicked:(UIButtonBarButton*)button {
	// check tag
	if(_selectedTag == kTagUsers)
		return;
	
	[self _switchToView:_userTable];
	_selectedTag = kTagUsers;
	
	// show button
	[[_uiController navBar] showButtonsWithLeftTitle:L(@"Logout") rightTitle:L(@"Preference")];
}

- (void)clusterButtonClicked:(UIButtonBarButton*)button {
	// check tag
	if(_selectedTag == kTagClusters)
		return;
	
	[self _switchToView:_clusterTable];
	_selectedTag = kTagClusters;
	
	// show button
	[[_uiController navBar] showButtonsWithLeftTitle:L(@"Logout") rightTitle:L(@"Preference")];
}

- (void)searchButtonClicked:(UIButtonBarButton*)button {
	// check tag
	if(_selectedTag == kTagSearch)
		return;
	
	[self _switchToView:_searchTable];
	_selectedTag = kTagSearch;
	
	// update focus
	[_searchTableDataSource updateFocus:_searchTable];
	
	// show button
	[[_uiController navBar] showButtonsWithLeftTitle:L(@"Logout") rightTitle:L(@"Preference")];
}

- (void)messageButtonClicked:(UIButtonBarButton*)button {
	// check tag
	if(_selectedTag == kTagMessage)
		return;
	
	[self _switchToView:_messageTable];
	_selectedTag = kTagMessage;
	[_messageDataSource update:_messageTable];
	
	// show button
	[[_uiController navBar] showButtonsWithLeftTitle:L(@"Logout") rightTitle:L(@"Preference")];
}

- (void)recentButtonClicked:(UIButtonBarButton*)button {
	// check tag
	if(_selectedTag == kTagRecent)
		return;
	
	[self _switchToView:_recentTable];
	_selectedTag = kTagRecent;
	[_recentTableDataSource update:_recentTable];
	
	// show button
	[[_uiController navBar] showButtonsWithLeftTitle:L(@"Clear") rightTitle:nil];
}

- (void)customizeButtonClicked:(UIButtonBarButton*)button {
	// check tag
	if(_selectedTag == kTagCustomize)
		return;
	
	[self _switchToView:_moreTable];
	_selectedTag = kTagCustomize;
	
	// show button
	[[_uiController navBar] showButtonsWithLeftTitle:L(@"Customize") rightTitle:nil];
}

- (void)historyButtonClicked:(UIButtonBarButton*)button {
	// check tag
	if(_selectedTag == kTagHistory)
		return;
	
	[self _switchToView:_historyTable];
	_selectedTag = kTagHistory;
	[_historyTableDataSource update:_historyTable];
	
	// show button
	[[_uiController navBar] showButtonsWithLeftTitle:L(@"DeleteAll") rightTitle:nil];
}

- (void)viewMyInfoButtonClicked:(UIPushButton*)button {
	NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:[_groupManager me], kDataKeyUser,
		_groupManager, kDataKeyGroupManager,
		_client, kDataKeyClient,
		kUIUnitMain, kDataKeyFrom,
		nil];
	[_uiController transitTo:kUIUnitUserInfo style:kTransitionStyleLeftSlide data:data];
}

- (void)applyStatusChangeButtonClicked:(UIPushButton*)button {
	// change status
	char status = [_myselfDataSource status];
	NSString* statusMessage = [_myselfDataSource statusMessage];
	[_client changeStatus:status message:statusMessage];
	
	// back to user panel
	[_buttonBar showSelectionForButton:kTagUsers];
	[self _switchToView:_userTable];
	_selectedTag = kTagUsers;
	
	// save to preference
	PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
	[tool setString:statusMessage forKey:kPreferenceKeyStatusMessage];
}

- (void)handleGroupExpandStatusChanged:(NSNotification*)notification {
	[_groupManager setDirty:YES];
	[_userTable reloadData];
}

- (void)_switchToView:(UIView*)view {
	if([self _activeView] == view)
		return;
	
	[[self _activeView] removeFromSuperview];
	[_view addSubview:view];
	
	// don't use animation now	
//	UIAnimation* hideAnimation = [self _getHideViewAnimation:[self _activeView]];
//	[hideAnimation setDelegate:self];
//	
//	UIAnimation* showAnimation = [self _getShowViewAnimation:view parent:_view];
//	
//	// start animation
//	[[UIAnimator sharedAnimator] addAnimations:[NSArray arrayWithObjects:hideAnimation, showAnimation, nil]
//								  withDuration:0.25
//										 start:YES];
}

- (void)handleClusterExpandStatusChanged:(NSNotification*)notification {
	Cluster* c = [notification object];
	
	// refresh table
	[_clusterTable reloadData];
}

- (void)handleMessageSourcePopulated:(NSNotification*)notification {
	[self _refreshMessageButtonBadge];
	
	// refresh status bar icon
	if([_messageManager displayableMessageCount] == 0) {
		[UIApp removeStatusBarImageNamed:@"LumaQQ_Message"];
		[UIApp addStatusBarImageNamed:@"LumaQQ" removeOnAbnormalExit:YES];
	}
}

- (void)handleHasMessageUnreadSourcePopulated:(NSNotification*)notification {
	[UIApp removeStatusBarImageNamed:@"LumaQQ"];
	[UIApp addStatusBarImageNamed:@"LumaQQ_Message" removeOnAbnormalExit:YES];
}

- (void)handleWillSuspend:(NSNotification*)notification {
	[self _refreshApplicationBadge];
}

- (void)handleWillResume:(NSNotification*)notification {
	if(_relogin == YES) {
		_relogin = NO;
		[self _relogin];
	}
}

- (void)handleCellDoubleTapped:(NSNotification*)notification {
	id obj = [notification object];
	if([obj isMemberOfClass:[User class]]) {
		// create data
		NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:obj, kDataKeyUser,
			_groupManager, kDataKeyGroupManager,
			_client, kDataKeyClient,
			kUIUnitMain, kDataKeyFrom,
			_messageManager, kDataKeyMessageManager,
			nil];
		
		// go to operation view
		[_uiController transitTo:kUIUnitUserChat style:kTransitionStyleLeftSlide data:data];
	} else if([obj isMemberOfClass:[Cluster class]]) {
		// create data
		NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:obj, kDataKeyCluster,
			_groupManager, kDataKeyGroupManager,
			_client, kDataKeyClient,
			kUIUnitMain, kDataKeyFrom,
			_messageManager, kDataKeyMessageManager,
			nil];
		
		// go to operation view
		[_uiController transitTo:kUIUnitClusterChat style:kTransitionStyleLeftSlide data:data];
	} else if([obj isMemberOfClass:[Group class]]) {
		[obj setExpanded:![obj expanded]];
		
		// trigger notification
		[[NSNotificationCenter defaultCenter] postNotificationName:kGroupExpandStatusChangedNotificationName
															object:obj];
		
		// refresh ui
		[_userTable reloadData];
	}
}

- (void)handleGroupNameChanged:(NSNotification*)notification {
	id obj = [notification object];
	NSString* name = [[notification userInfo] objectForKey:kUserInfoStringValue];
	[_groupManager setGroupName:obj name:name];
	[_userTable reloadData];
}

- (void)handleGroupWillBeCreated:(NSNotification*)notification {
	NSString* name = [[notification userInfo] objectForKey:kUserInfoStringValue];
	[_groupManager addFriendlyGroup:name];
	[_userTable reloadData];
}

- (void)handleUserRemarkNameChanged:(NSNotification*)notification {
	id obj = [notification object];
	NSString* name = [[notification userInfo] objectForKey:kUserInfoStringValue];
	[obj setRemarkName:name];
	[_groupManager setDirty:YES];
	[_client modifyRemarkName:[obj QQ] name:name];
	[_userTable reloadData];
}

- (void)handleWantToDeleteGroup:(NSNotification*)notification {
	Group* group = [notification object];
	int srcIndex = [_groupManager indexOfGroup:group];
	NSDictionary* userInfo = [notification userInfo];
	NSString* name = userInfo == nil ? nil : [userInfo objectForKey:kUserInfoStringValue];
	if(name == nil) {
		[_groupManager removeGroupAt:srcIndex];
		[_userTable reloadData];
	} else {
		int destIndex = [_groupManager groupIndexByName:name];
		if(srcIndex != -1 && destIndex != -1) {
			[_groupManager moveAllUsersFrom:srcIndex to:destIndex];
			[_groupManager removeGroupAt:srcIndex];
			[_userTable reloadData];
		}
	}
}

- (void)handleClusterExited:(NSNotification*)notification {
	Cluster* cluster = [notification object];
	[_groupManager removeCluster:cluster];
	[_clusterTable reloadData];
}

- (void)handleClusterMessagetSettingChanged:(NSNotification*)notification {
	// refresh badge
	[self _refreshMessageButtonBadge];
	
	// refresh status bar icon
	if([_messageManager displayableMessageCount] > 0) {
		[UIApp removeStatusBarImageNamed:@"LumaQQ"];
		[UIApp addStatusBarImageNamed:@"LumaQQ_Message" removeOnAbnormalExit:YES];
	} else {
		[UIApp removeStatusBarImageNamed:@"LumaQQ_Message"];
		[UIApp addStatusBarImageNamed:@"LumaQQ" removeOnAbnormalExit:YES];
	}
	
	// refresh application badge
	if([UIApp isSuspended]) 
		[self _refreshApplicationBadge];
	
	// reload cluster data
	[_clusterTable reloadData];
}

- (void)handlePreferenceChanged:(NSNotification*)notification {
	// recreate button bar
	PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
	int buttonCount = [tool intValue:kPreferenceKeyButtonBarButtonCount defaultValue:5];
	unsigned int currentCount = 0;
	[_buttonBar getVisibleButtonTags:NULL count:&currentCount maxItems:0];
	if(buttonCount != currentCount)
		[self _createButtonBar];
	
	// reload user table
	[_userTable reloadData];
	
	// reload more table
	[_moreTableDataSource update:_moreTable];
}

- (void)handleUserWillBeMovedToGroup:(NSNotification*)notification {
	User* user = [notification object];
	NSString* groupName = [[notification userInfo] objectForKey:kUserInfoStringValue];
	int srcIndex = [user groupIndex];
	int destIndex = [_groupManager groupIndexByName:groupName];
	if(srcIndex == -1 || destIndex == -1)
		return;
	
	if(srcIndex == [_groupManager strangerGroupIndex] || srcIndex == [_groupManager blacklistGroupIndex]) {
		if(srcIndex == [_groupManager strangerGroupIndex] || srcIndex == [_groupManager blacklistGroupIndex]) {
			[_groupManager moveUser:user toGroupIndex:destIndex];
			[_userTable reloadData];
		} else {
			_alertType = _kAlertConfirmAddUserAsFriend;
			[UIUtil showQuestion:L(@"ConfirmAddUserAsFriend") title:L(@"Question") delegate:self];
		}
	} else {
		if(destIndex == [_groupManager strangerGroupIndex]) {
			_destGroupIndex = destIndex;
			_userToBeRemoved = user;
			_alertType = _kAlertConfirmMoveToStranger;
			[UIUtil showQuestion:L(@"ConfirmMoveUserToStranger") title:L(@"Question") delegate:self];
		} else if(destIndex == [_groupManager blacklistGroupIndex]) {
			_destGroupIndex = destIndex;
			_userToBeRemoved = user;
			_alertType = _kAlertConfirmMoveToBlacklist;
			[UIUtil showQuestion:L(@"ConfirmMoveUserToBlacklist") title:L(@"Question") delegate:self];
		} else {
			[_groupManager moveUser:user toGroupIndex:destIndex];
			[_userTable reloadData];
		}
	}
}

- (void)handleUserRemoved:(NSNotification*)notification {
	[_userTable reloadData];
}

- (void)handleKickedOutBySystem:(NSNotification*)notification {
	// if not suspended, popup an alert
	if(![UIApp isSuspended]) {
		[UIUtil showWarning:L(@"KickedOutBySystem") title:L(@"Warning") delegate:self];
	} else {
		[self _logout];
	}
}

- (void)handleFriendGroupRebuilt:(NSNotification*)notification {
	[_groupManager sortAll];
	[_userTable reloadData];
	[_clusterTable reloadData];
}

- (void)handleSendIMOK:(NSNotification*)notification {
	NSNumber* qq = [notification object];
	[_recentTableDataSource addRecentByQQ:[qq unsignedIntValue]];
}

- (UIView*)_activeView {
	return [self _viewWithTag:_selectedTag];
}

- (UIView*)_viewWithTag:(int)tag {
	switch(tag) {
		case kTagUsers:
			return _userTable;
		case kTagClusters:
			return _clusterTable;
		case kTagMyself:
			return _myselfTable;
		case kTagMessage:
			return _messageTable;
		case kTagSearch:
			return _searchTable;
		case kTagRecent:
			return _recentTable;
		case kTagCustomize:
			return _moreTable;
		case kTagHistory:
			return _historyTable;
		default:
			return nil;
	}
}

- (void)_decorateMyselfIcon {
	if(_myselfDecorator == nil)
		[self _createMyselfDecorator];
	if(_myselfDecorator == nil)
		return;
	
	// get decorator image
	UIImage* decorator = nil;
	switch([[_client user] status]) {
		case kQQStatusOnline:
			decorator = [UIImage imageNamed:kImageOnline];
			break;
		case kQQStatusQMe:
			decorator = [UIImage imageNamed:kImageQMe];
			break;
		case kQQStatusBusy:
			decorator = [UIImage imageNamed:kImageBusy];
			break;
		case kQQStatusMute:
			decorator = [UIImage imageNamed:kImageMute];
			break;
		case kQQStatusAway:
			decorator = [UIImage imageNamed:kImageAway];
			break;
		case kQQStatusHidden:
			decorator = [UIImage imageNamed:kImageHidden];
			break;
	}
	[_myselfDecorator setImage:decorator];
}

- (void)recentDisclosureClicked:(UITableCellDisclosureView*)view {
	id obj = [_recentTableDataSource recentAtIndex:[_recentTable selectedRow]];
	
	// check type
	if(obj == nil || ![obj isMemberOfClass:[User class]])
		return;
	
	// create data
	NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:obj, kDataKeyUser,
		_groupManager, kDataKeyGroupManager,
		_client, kDataKeyClient,
		kUIUnitMain, kDataKeyFrom,
		_messageManager, kDataKeyMessageManager,
		nil];
	
	// go to operation view
	[_uiController transitTo:kUIUnitUserOperation style:kTransitionStyleLeftSlide data:data];
}

- (void)userDisclosureClicked:(UITableCellDisclosureView*)view {
	// get selected obj
	id obj = nil;
	if(_selectedTag == kTagUsers)
		obj = [_groupManager linearLocate:[_userTable selectedRow]];
	else if(_selectedTag == kTagClusters)
		obj = [_groupManager linearLocateInCluster:[_clusterTable selectedRow]];
	
	// check type
	if(obj == nil || ![obj isMemberOfClass:[User class]])
		return;
	
	// create data
	NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:obj, kDataKeyUser,
		_groupManager, kDataKeyGroupManager,
		_client, kDataKeyClient,
		kUIUnitMain, kDataKeyFrom,
		_messageManager, kDataKeyMessageManager,
		nil];
	
	// go to operation view
	[_uiController transitTo:kUIUnitUserOperation style:kTransitionStyleLeftSlide data:data];
}

- (void)clusterDisclosureClicked:(UITableCellDisclosureView*)view {
	// get selected obj
	id obj = nil;
	if(_selectedTag == kTagClusters)
		obj = [_groupManager linearLocateInCluster:[_clusterTable selectedRow]];
	
	// check type
	if(obj == nil || ![obj isMemberOfClass:[Cluster class]])
		return;
	
	// create data
	NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:obj, kDataKeyCluster,
		_groupManager, kDataKeyGroupManager,
		_client, kDataKeyClient,
		kUIUnitMain, kDataKeyFrom,
		_messageManager, kDataKeyMessageManager,
		nil];
	
	// go to operation view
	[_uiController transitTo:kUIUnitClusterOperation style:kTransitionStyleLeftSlide data:data];
}

- (void)groupDisclosureClicked:(UITableCellDisclosureView*)view {
	// get selected obj
	id obj = nil;
	if(_selectedTag == kTagUsers)
		obj = [_groupManager linearLocate:[_userTable selectedRow]];
	
	// check type
	if(obj == nil || ![obj isMemberOfClass:[Group class]])
		return;
	
	// create data
	NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:obj, kDataKeyGroup,
		_groupManager, kDataKeyGroupManager,
		_client, kDataKeyClient,
		kUIUnitMain, kDataKeyFrom,
		nil];
	
	// go to operation view
	[_uiController transitTo:kUIUnitGroupOperation style:kTransitionStyleLeftSlide data:data];
}

- (void)messageDisclosureClicked:(UITableCellDisclosureView*)view {
	int row = [_messageTable selectedRow];
	id obj = [_messageManager linearLocate:row];
	if(obj == nil)
		return;
	if([obj isMemberOfClass:[User class]]) {
		NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:_groupManager, kDataKeyGroupManager,
			_client, kDataKeyClient,
			obj, kDataKeyUser,
			kUIUnitMain, kDataKeyFrom,
			_messageManager, kDataKeyMessageManager,
			nil];
		[_uiController transitTo:kUIUnitUserChat style:kTransitionStyleLeftSlide data:data];
	} else if([obj isMemberOfClass:[Cluster class]]) {
		NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:_groupManager, kDataKeyGroupManager,
			_client, kDataKeyClient,
			obj, kDataKeyCluster,
			kUIUnitMain, kDataKeyFrom,
			_messageManager, kDataKeyMessageManager,
			nil];
		[_uiController transitTo:kUIUnitClusterChat style:kTransitionStyleLeftSlide data:data];
	} else if([obj isKindOfClass:[NSDictionary class]]) {
		NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:_groupManager, kDataKeyGroupManager,
			_client, kDataKeyClient,
			obj, kDataKeyDictionary,
			kUIUnitMain, kDataKeyFrom,
			nil];
		[_messageManager removeSystemMessage:obj];
		
		NSNumber* type = [obj objectForKey:kChatLogKeySMType];
		switch([type intValue]) {
			case kSMTypeRequestAddMe:
			case kSMTypeRequestAddMeAndAllowAddHim:
			case kSMTypeApproveMyRequest:
			case kSMTypeApproveMyRequestAndAddMe:
			case kSMTypeRejectMyRequest:
			case kSMTypeAddMe:
				[_uiController transitTo:kUIUnitUserAuth style:kTransitionStyleLeftSlide data:data];
				break;
			case kSMTypeRequestJoinCluster:
			case kSMTypeApproveJoinCluster:
			case kSMTypeRejectJoinCluster:
			case kSMTypeExitCluster:
			case kSMTypeCreateCluster:
			case kSMTypeJoinCluster:
				[_uiController transitTo:kUIUnitClusterAuth style:kTransitionStyleLeftSlide data:data];
				break;
		}
	}
}

- (void)historyDisclosureClicked:(UITableCellDisclosureView*)view {
	int row = [_historyTable selectedRow];
	id obj = [_historyTableDataSource logObjectAtRow:row];
	[_uiController transitTo:kUIUnitChatLog
					   style:kTransitionStyleLeftSlide 
						data:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							obj, kDataKeyChatModel, 
							kUIUnitMain, kDataKeyFrom, 
							_groupManager, kDataKeyGroupManager, nil]];
}

- (UIAnimation*)_getHideViewAnimation:(UIView*)view {
	UIAlphaAnimation* animation = [[UIAlphaAnimation alloc] initWithTarget:view];
	[animation setStartAlpha:1.0f];
	[animation setEndAlpha:0.0f];
	[animation setAnimationCurve:kUIAnimationCurveLinear];
	return [animation autorelease];
}

- (UIAnimation*)_getShowViewAnimation:(UIView*)view parent:(UIView*)superview {
	[superview addSubview:view];
	UIAlphaAnimation* animation = [[UIAlphaAnimation alloc] initWithTarget:view];
	[animation setStartAlpha:0.0f];
	[animation setEndAlpha:1.0f];
	[animation setAnimationCurve:kUIAnimationCurveLinear];
	return [animation autorelease];
}

- (void)_refreshMessageButtonBadge {
	// set button bar badge
	if(_messageManager == nil || [_messageManager displayableMessageCount] == 0)
		[_buttonBar setBadgeValue:nil forButton:kTagMessage];
	else
		[_buttonBar setBadgeValue:[NSString stringWithFormat:@"%u", [_messageManager displayableMessageCount]] forButton:kTagMessage];
}

- (void)_refreshApplicationBadge {
	if(_messageManager == nil || [_messageManager displayableMessageCount] == 0)
		[UIApp removeApplicationBadge];
	else
		[UIApp setApplicationBadge:[NSString stringWithFormat:@"%u", [_messageManager displayableMessageCount]]];
}

- (void)_logout {
	// remove stauts bar image
	[UIApp removeStatusBarImageNamed:@"LumaQQ"];
	[UIApp removeStatusBarImageNamed:@"LumaQQ_Message"];
	
	// remove notification handler
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kMessageSourcePopulatedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kGroupNameChangedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kGroupWillBeCreatedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kUserRemarkNameChangedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kWantToDeleteGroupNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kClusterExitedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kClusterMessagetSettingChangedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kPreferenceChangedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kUserWillBeMovedToGroupNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kUserRemovedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kKickedOutBySystemNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kFriendGroupRebuiltNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kSendIMOKNotificationName
												  object:nil];
	
	// release online users
	if(_onlineUsers != nil) {
		[_onlineUsers release];
		_onlineUsers = nil;
	}
	
	// save group
	[_groupManager saveGroups];
	
	// save unread message
	[_messageManager saveUnread];
	
	// save preference
	[[PreferenceTool toolWithQQ:gMyQQ] saveAndClear];
	
	// save recent
	[_recentTableDataSource sync];
	
	// clean
	[_client removeQQListener:self];
	[_client logout];
	[_data release];
	_data = nil;
}

- (void)_relogin {
	// get my qq str
	NSString* qqStr = [NSString stringWithFormat:@"%u", gMyQQ];
	
	// get myself.plist path
	NSString* path = [FileTool getMyselfPlistByString:qqStr];
	
	// load myself.plist
	NSMutableDictionary* plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	// go to login view
	[_uiController transitTo:kUIUnitLogin style:kTransitionStyleRightSlide data:plist];	
}

- (UIButtonBar*)_buttonBar {
	return _buttonBar;
}

- (void)reloadClusterPanel {
	[_clusterTable reloadData];
}

- (void)reloadUserPanel {
	[_userTable reloadData];
}

- (GroupManager*)groupManager {
	return _groupManager;
}

- (QQClient*)client {
	return _client;
}

#pragma mark -
#pragma mark job delegate

- (void)friendJobTerminated:(JobController*)jobController {
	[jobController autorelease];
	[_userTable reloadData];
}

- (void)clusterJobTerminated:(JobController*)jobController {
	[jobController autorelease];
	[_clusterTable reloadData];
}

- (void)uploadJobTerminated:(JobController*)jobController {
	// dismiss alert
	[_alertSheet dismiss];
	[_alertSheet release];
	_alertSheet = nil;
	
	// release job controller
	[jobController autorelease];
	
	// logout
	[self _logout];
	
	// back
	[_uiController transitTo:kUIUnitAccountManage style:kTransitionStyleRightSlide data:nil];
}

#pragma mark -
#pragma mark animation delegate

- (void)animator:(UIAnimator*)animator stopAnimation:(UIAnimation*)animation {
	if ([animation target] != nil) {
		[[animation target] removeFromSuperview];
	}
}

#pragma mark -
#pragma mark navigation bar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button {
	switch(button) {
		case kNavButtonLeft:
			switch(_selectedTag) {
				case kTagCustomize:
					if(_customizing) {
						// hide customize view and reset button
						[_buttonBar dismissCustomizeSheet:YES];
						[_view addSubview:_moreTable];
						_customizing = NO;
						[[_uiController navBar] showButtonsWithLeftTitle:L(@"Customize") rightTitle:nil];
						
						// save button array
						PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
						int buttonCount = [tool intValue:kPreferenceKeyButtonBarButtonCount defaultValue:5];
						[tool setInt:buttonCount forKey:kPreferenceKeyButtonBarButtonCount];
						int* buttons = (int*)malloc(sizeof(int) * buttonCount);
						unsigned int count;
						[_buttonBar getVisibleButtonTags:buttons count:&count maxItems:buttonCount];
						NSMutableArray* buttonArray = [NSMutableArray arrayWithCapacity:buttonCount];
						int i;
						for(i = 0; i < buttonCount; i++)
							[buttonArray addObject:[NSNumber numberWithInt:buttons[i]]];
						free(buttons);
						[tool setArray:buttonArray forKey:kPreferenceKeyButtonBar];
						
						// reload more table
						[_moreTableDataSource update:_moreTable];
					} else {
						[_moreTable removeFromSuperview];
						int buttons[] = { kTagMyself, kTagUsers, kTagClusters, kTagMessage, kTagRecent, kTagSearch, kTagHistory, kTagCustomize };
						[_buttonBar customize:buttons withCount:(sizeof(buttons) / sizeof(int))];
						[[_uiController navBar] showLeftButton:L(@"Done") withStyle:kNavButtonStyleBlue rightButton:nil withStyle:0];
						_customizing = YES;
					}
					break;
				case kTagRecent:
					[_recentTableDataSource removeAll];
					[_recentTableDataSource update:_recentTable];
					break;
				case kTagHistory:
					_alertType = _kAlertConfirmDeleteAllHistory;
					[UIUtil showQuestion:L(@"ConfirmDeleteHistory") title:L(@"Question") delegate:self];
					break;
				default:
					_alertType = _kAlertConfirmLogout;
					[UIUtil showQuestion:L(@"ConfirmLogout") title:L(@"Question") delegate:self];
					break;
			}
			break;
		case kNavButtonRight:		
			[_uiController transitTo:kUIUnitPreference style:kTransitionStyleLeftSlide data:_data];
			break;
	}
}

#pragma mark -
#pragma mark alert sheet delegate

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
	
	// 1 is ok button, the index starts from 1!
	switch(_alertType) {
		case _kAlertConfirmLogout:
			if(button == 1) {
				if([_groupManager changed]) {
					_alertType = _kAlertConfirmUpload;
					[UIUtil showQuestion:L(@"ConfirmUploadFriendGroup") title:L(@"Question") delegate:self];
				} else {
					[self _logout];
					
					// back
					[_uiController transitTo:kUIUnitAccountManage style:kTransitionStyleRightSlide data:nil];
				}
			}
			break;
		case _kAlertConfirmUpload:
			if(button == 1) {
				// start alert
				_alertSheet = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
				[_alertSheet setBodyText:L(@"UploadingGroupNames")];
				[_alertSheet presentSheetFromButtonBar:_buttonBar];
				
				// start job
				JobController* jobController = [[JobController alloc] initWithContext:_data];
				[jobController setTarget:self];
				[jobController setAction:@selector(uploadJobTerminated:)];
				UploadFriendGroupJob* job = [[[UploadFriendGroupJob alloc] initWithGroupManager:_groupManager] autorelease];
				[jobController startJob:job];
			} else {
				[self _logout];
				
				// back
				[_uiController transitTo:kUIUnitAccountManage style:kTransitionStyleRightSlide data:nil];
			}				
			break;
		case _kAlertConfirmMoveToBlacklist:
		case _kAlertConfirmMoveToStranger:
			if(button == 1) {
				// show alert
				_alertSheet = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
				[_alertSheet setBodyText:L(@"GettingDeleteAuthInfo")];
				[_alertSheet presentSheetFromButtonBar:_buttonBar];
				
				// get delete user auth info
				_waitingSequence = [_client getDeleteUserAuthInfo:[_userToBeRemoved QQ]];
			}
			break;
		case _kAlertConfirmAddUserAsFriend:
			break;
		case _kAlertConfirmDeleteAllHistory:
			if(button == 1) {
				[_historyTableDataSource deleteAll:_historyTable];
			}
			break;
		case _kAlertKickedOut:
			[self _logout];
			
			// back
			[_uiController transitTo:kUIUnitAccountManage style:kTransitionStyleRightSlide data:nil];
			break;
		case _kAlertDeleteUserFailed:
			break;
	}
}

#pragma mark -
#pragma mark table delegate

- (void)tableRowSelected:(NSNotification*)notification {
	UITable* table = [notification object];
	int row = [table selectedRow];
	if(table == _userTable) {
		if(_oldSelectedUserTableCell != row) {
			// hide old
			if(_oldSelectedUserTableCell != -1) {
				UITableCell* cell = [table visibleCellForRow:_oldSelectedUserTableCell column:0];
				if(cell != nil) {
					[cell setShowDisclosure:NO animated:YES];
					[[cell _disclosureView] removeTarget:self forEvents:kUIMouseUp];
				}
			}
			
			// show new
			UITableCell* cell = [table visibleCellForRow:row column:0];
			if(cell != nil) {
				[cell setShowDisclosure:YES animated:YES];
				if([cell isMemberOfClass:[UserCell class]])
					[[cell _disclosureView] addTarget:self action:@selector(userDisclosureClicked:) forEvents:kUIMouseUp];
				else if([cell isMemberOfClass:[GroupCell class]])
					[[cell _disclosureView] addTarget:self action:@selector(groupDisclosureClicked:) forEvents:kUIMouseUp];
			}
			
			// save
			_oldSelectedUserTableCell = row;
		} else {
			// show new
			UITableCell* cell = [table visibleCellForRow:row column:0];
			if(cell != nil) {
				[cell setShowDisclosure:YES animated:NO];
				[[cell _disclosureView] removeTarget:self forEvents:kUIMouseUp];
				if([cell isMemberOfClass:[UserCell class]])
					[[cell _disclosureView] addTarget:self action:@selector(userDisclosureClicked:) forEvents:kUIMouseUp];
				else if([cell isMemberOfClass:[GroupCell class]])
					[[cell _disclosureView] addTarget:self action:@selector(groupDisclosureClicked:) forEvents:kUIMouseUp];
			}
		}
	} else if(table == _clusterTable) {
		if(_oldSelectedClusterTableCell != row) {
			// hide old
			if(_oldSelectedClusterTableCell != -1) {
				UITableCell* cell = [table visibleCellForRow:_oldSelectedClusterTableCell column:0];
				if(cell != nil) {
					[cell setShowDisclosure:NO animated:YES];
					[[cell _disclosureView] removeTarget:self forEvents:kUIMouseUp];
				}
			}
			
			// show new
			UITableCell* cell = [table visibleCellForRow:row column:0];
			if(cell != nil) {
				[cell setShowDisclosure:YES animated:YES];
				if([cell isMemberOfClass:[UserCell class]])
					[[cell _disclosureView] addTarget:self action:@selector(userDisclosureClicked:) forEvents:kUIMouseUp];
				else if([cell isMemberOfClass:[ClusterCell class]])
					[[cell _disclosureView] addTarget:self action:@selector(clusterDisclosureClicked:) forEvents:kUIMouseUp];
			}
			
			// save
			_oldSelectedClusterTableCell = row;
		} else {
			// show new
			UITableCell* cell = [table visibleCellForRow:row column:0];
			if(cell != nil) {
				[cell setShowDisclosure:YES animated:NO];
				[[cell _disclosureView] removeTarget:self forEvents:kUIMouseUp];
				if([cell isMemberOfClass:[UserCell class]])
					[[cell _disclosureView] addTarget:self action:@selector(userDisclosureClicked:) forEvents:kUIMouseUp];
				else if([cell isMemberOfClass:[ClusterCell class]])
					[[cell _disclosureView] addTarget:self action:@selector(clusterDisclosureClicked:) forEvents:kUIMouseUp];
			}
		}
	} else if(table == _messageTable) {
		if(_oldSelectedMessageTableCell != row) {			
			// hide old
			if(_oldSelectedMessageTableCell != -1) {
				UITableCell* cell = [table visibleCellForRow:_oldSelectedMessageTableCell column:0];
				if(cell != nil) {
					[cell setShowDisclosure:NO animated:YES];
					[[cell _disclosureView] removeTarget:self forEvents:kUIMouseUp];
				}
			}
			
			// show new
			UITableCell* cell = [table visibleCellForRow:row column:0];
			if(cell != nil) {
				[cell setShowDisclosure:YES animated:YES];
				[[cell _disclosureView] addTarget:self action:@selector(messageDisclosureClicked:) forEvents:kUIMouseUp];
			}
			
			// save
			_oldSelectedMessageTableCell = row;
		} else {
			// show new
			UITableCell* cell = [table visibleCellForRow:row column:0];
			if(cell != nil) {
				[cell setShowDisclosure:YES animated:NO];
				[[cell _disclosureView] removeTarget:self forEvents:kUIMouseUp];
				[[cell _disclosureView] addTarget:self action:@selector(messageDisclosureClicked:) forEvents:kUIMouseUp];
			}
		}
	} else if(table == _recentTable) {
		if(_oldSelectedRecentTableCell != row) {			
			// hide old
			if(_oldSelectedRecentTableCell != -1) {
				UITableCell* cell = [table visibleCellForRow:_oldSelectedRecentTableCell column:0];
				if(cell != nil) {
					[cell setShowDisclosure:NO animated:YES];
					[[cell _disclosureView] removeTarget:self forEvents:kUIMouseUp];
				}
			}
			
			// show new
			UITableCell* cell = [table visibleCellForRow:row column:0];
			if(cell != nil) {
				[cell setShowDisclosure:YES animated:YES];
				[[cell _disclosureView] addTarget:self action:@selector(recentDisclosureClicked:) forEvents:kUIMouseUp];
			}
			
			// save
			_oldSelectedRecentTableCell = row;
		} else {
			// show new
			UITableCell* cell = [table visibleCellForRow:row column:0];
			if(cell != nil) {
				[cell setShowDisclosure:YES animated:NO];
				[[cell _disclosureView] removeTarget:self forEvents:kUIMouseUp];
				[[cell _disclosureView] addTarget:self action:@selector(recentDisclosureClicked:) forEvents:kUIMouseUp];
			}
		}
	} else if(table == _historyTable) {
		if(_oldSelectedHistoryTableCell != row) {			
			// hide old
			if(_oldSelectedHistoryTableCell != -1) {
				UITableCell* cell = [table visibleCellForRow:_oldSelectedHistoryTableCell column:0];
				if(cell != nil) {
					[cell setShowDisclosure:NO animated:YES];
					[[cell _disclosureView] removeTarget:self forEvents:kUIMouseUp];
				}
			}
			
			// show new
			UITableCell* cell = [table visibleCellForRow:row column:0];
			if(cell != nil) {
				[cell setShowDisclosure:YES animated:YES];
				[[cell _disclosureView] addTarget:self action:@selector(historyDisclosureClicked:) forEvents:kUIMouseUp];
			}
			
			// save
			_oldSelectedHistoryTableCell = row;
		} else {
			// show new
			UITableCell* cell = [table visibleCellForRow:row column:0];
			if(cell != nil) {
				[cell setShowDisclosure:YES animated:NO];
				[[cell _disclosureView] removeTarget:self forEvents:kUIMouseUp];
				[[cell _disclosureView] addTarget:self action:@selector(historyDisclosureClicked:) forEvents:kUIMouseUp];
			}
		}
	} else if(table == _moreTable) {
		int tag = [_moreTableDataSource tagAtRow:[_moreTable selectedRow]];
		switch(tag) {
			case kTagMyself:
				[self myselfButtonClicked:nil];
				break;
			case kTagUsers:
				[self userButtonClicked:nil];
				break;
			case kTagClusters:
				[self clusterButtonClicked:nil];
				break;
			case kTagMessage:
				[self messageButtonClicked:nil];
				break;
			case kTagHistory:
				[self historyButtonClicked:nil];
				break;
			case kTagCustomize:
				[self customizeButtonClicked:nil];
				break;
			case kTagSearch:
				[self searchButtonClicked:nil];
				break;
			case kTagRecent:
				[self recentButtonClicked:nil];
				break;
		}
	}
}

- (void)table:(UITable*)table deleteRow:(int)row {
	if(table == _historyTable) {
		[_historyTableDataSource table:table deleteRow:row];
	}
}

#pragma mark -
#pragma mark qq event handle

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventUploadGroupNamesOK:
			ret = [self handleUploadGroupNameOK:event];
			break;
		case kQQEventGetOnlineFriendOK:
			ret = [self handleGetOnlineFriendOK:event];
			break;
		case kQQEventFriendStatusChanged:
			ret = [self handleFriendStatusChanged:event];
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
		case kQQEventClusterGetMemberInfoOK:
			ret = [self handleGetMemberInfoOK:event];
			break;
		case kQQEventClusterGetOnlineMemberOK:
			ret = [self handleGetOnlineMemberOK:event];
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
		case kQQEventBatchGetFriendRemarkOK:
			ret = [self handleBatchGetFriendRemarkOK:event];
			break;
		case kQQEventChangeStatusOK:
			ret = [self handleChangeStatusOK:event];
			break;
		case kQQEventGetUserInfoOK:
			ret = [self handleGetUserInfoOK:event];
			break;
		case kQQEventReceivedIM:
			ret = [self handleReceivedIM:event];
			break;
		case kQQEventReceivedSystemNotification:
			ret = [self handleReceivedSystemNotification:event];
			break;
		case kQQEventClusterGetMessageSettingOK:
			ret = [self handleGetMessageSettingOK:event];
			break;
		case kQQEventNetworkError:
			ret = [self handleNetworkError:event];
			break;
		case kQQEventGetAuthInfoOK:
			ret = [self handleGetAuthInfoOK:event];
			break;
		case kQQEventDeleteFriendOK:
			ret = [self handleDeleteFriendOK:event];
			break;
		case kQQEventRemoveFriendFromListOK:
			ret = [self handleRemoveFriendFromListOK:event];
			break;
		case kQQEventRemoveFriendFromListFailed:
		{
			OutPacket* packet = [event outPacket];
			if([packet sequence] == _waitingSequence) {
				// dismiss alert
				[_alertSheet dismiss];
				[_alertSheet release];
				_alertSheet = nil;
				
				return YES;
			}
			break;
		}	
		case kQQEventDeleteFriendFailed:
		case kQQEventTimeoutBasic:
		{
			OutPacket* packet = [event outPacket];
			switch([packet command]) {
				case kQQCommandKeepAlive:
					[self handleConnectionTimeout:event];
					return YES;
				default:
					if([packet sequence] == _waitingSequence) {
						switch([packet command]) {
							case kQQCommandDeleteFriend:
								// dismiss alert
								[_alertSheet dismiss];
								[_alertSheet release];
								_alertSheet = nil;
								
								// show a message
								_alertType = _kAlertDeleteUserFailed;
								[UIUtil showWarning:L(@"DeleteUserFailed") title:L(@"Fail") delegate:self];
								break;
							case kQQCommandFriendDataOp:
								// dismiss alert
								[_alertSheet dismiss];
								[_alertSheet release];
								_alertSheet = nil;
								break;
						}
						return YES;
					}
					break;
			}
			break;
		}
	}
	
	return ret;
}

- (BOOL)handleNetworkError:(QQNotification*)event {
	if([event connectionId] == [_client mainConnectionId]) {
		if([UIApp isSuspended]) {
			// logout
			[self _logout];
			
			// set flag so that we will automatically relogin when we resume
			_relogin = YES;
		} else {
			// logout
			[self _logout];
			
			// relogin
			[self _relogin];
		}
	}
	return NO;
}

- (BOOL)handleConnectionTimeout:(QQNotification*)event {
	if([event connectionId] == [_client mainConnectionId]) {
		if([UIApp isSuspended]) {
			// logout
			[self _logout];
			
			// set flag so that we will automatically relogin when we resume
			_relogin = YES;
		} else {
			// logout
			[self _logout];
			
			// relogin
			[self _relogin];
		}
	}
	return NO;
}

- (BOOL)handleGetMessageSettingOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	NSEnumerator* e = [[packet messageSettings] objectEnumerator];
	ClusterMessageSetting* setting;
	while(setting = [e nextObject]) {		
		// save to cluster
		if([setting messageSetting] != kQQClusterMessageClearServerSetting) {
			Cluster* c = [_groupManager cluster:[setting internalId]];
			if(c) {
				[c setMessageSetting:[setting messageSetting]];
				[_groupManager setDirty:YES];
			}
		}
	}
	return NO;
}

- (BOOL)handleGetUserInfoOK:(QQNotification*)event {
	GetUserInfoReplyPacket* packet = (GetUserInfoReplyPacket*)[event object];
	
	// set user info in global
	User* u = [_groupManager user:[[packet contact] QQ]];
	if(u) {
		[u setContact:[packet contact]];
		[[_client user] setContact:[packet contact]];
		
		// refresh table
		[_userTable reloadData];
	}
	
	return NO;
}

- (BOOL)handleChangeStatusOK:(QQNotification*)event {
	[self _decorateMyselfIcon];
	return YES;
}

- (BOOL)handleFriendStatusChanged:(QQNotification*)event {
	FriendStatusChangedPacket* packet = [event object];
	FriendStatusChangedNotification* notify = [packet friendStatus];
	User* user = [_groupManager user:[notify QQ]];
	if(user) {
		// copy info
		[user copyWithFriendStatusChangedNotification:notify];
		
		// sort users
		Group* group = [_groupManager group:[user groupIndex]];
		if(group) {
			[group sort];
			[_userTable reloadData];
		}
	}
	return NO;
}

- (BOOL)handleGetOnlineFriendOK:(QQNotification*)event {
	GetOnlineOpReplyPacket* packet = (GetOnlineOpReplyPacket*)[event object];
	
	// get new onlines
	NSMutableArray* newOnlines = (NSMutableArray*)[packet friends];

	// if finished, refresh status
	if([packet finished]) {		
		// construct a new hash
		NSMutableDictionary* tempMap = [NSMutableDictionary dictionary];
		NSEnumerator* e = [newOnlines objectEnumerator];
		FriendStatus* fs = nil;
		while(fs = [e nextObject]) {
			[tempMap setObject:fs forKey:fs];
			
			// set status
			User* u = [_groupManager user:[fs QQ]];
			if(u)
				[u copyWithFriendStatus:fs];
		}
		
		// then remove the users which is not in new onlines
		e = [_onlineUsers objectEnumerator];
		while(fs = [e nextObject]) {
			if(![tempMap objectForKey:fs]) {
				User* u = [_groupManager user:[fs QQ]];
				if(u) {
					[u setStatus:kQQStatusOffline];
				}
			}
		}
		
		// swap online array
		[newOnlines retain];
		[_onlineUsers release];
		_onlineUsers = newOnlines;
		
		// refresh outline
		[_groupManager sortAll];
		[_userTable reloadData];
	} 	
	
	return YES;
}

- (BOOL)handleGetClusterInfoOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = (ClusterCommandReplyPacket*)[event object];
	
	// save cluster info
	[_groupManager setClusterInfo:[packet info]];
	
	// set member
	Cluster* c = [_groupManager cluster:[packet internalId]];
	if(c) {
		[c clearMembers];
		[_groupManager setMembers:[packet internalId] members:[packet members]];
	}
	
	return NO;
}

- (BOOL)handleGetClusterVersionIdOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = (ClusterCommandReplyPacket*)[event object];
	
	// get cluster
	Cluster* c = [_groupManager cluster:[packet internalId]];
	if(c) {
		if([packet clusterNameCardVersionId] > [c nameCardVersionId]) {
			[c setNameCardVersionId:[packet clusterNameCardVersionId]];
		}
	}
	
	return NO;
}

- (BOOL)handleBatchGetClusterNameCardOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = (ClusterCommandReplyPacket*)[event object];
	
	// get cluster
	Cluster* c = [_groupManager cluster:[packet internalId]];
	if(c) {
		ClusterBatchGetCardPacket* request = (ClusterBatchGetCardPacket*)[event outPacket];
		[_groupManager setClusterNameCards:[c internalId] nameCards:[packet clusterNameCards]];
	}
	
	return NO;
}

- (BOOL)handleGetMemberInfoOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = (ClusterCommandReplyPacket*)[event object];
	
	// set member infos
	[_groupManager setMemberInfos:[packet memberInfos]];
	
	// sort cluster
	Cluster* c = [_groupManager cluster:[packet internalId]];
	if(c)
		[c sortAll];
	
	return NO;
}

- (BOOL)handleGetOnlineMemberOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = (ClusterCommandReplyPacket*)[event object];
	
	// set status
	[_groupManager setOnlineMembers:[packet memberQQs]];
	
	// sort cluster
	Cluster* c = [_groupManager cluster:[packet internalId]];
	if(c)
		[c sortAll];
	
	// refresh outline
	[_clusterTable reloadData];
	
	return NO;
}

- (BOOL)handleGetUserPropertyOK:(QQNotification*)event {
	PropertyOpReplyPacket* packet = (PropertyOpReplyPacket*)[event object];
	
	// set properties
	[_groupManager setUserProperty:[packet properties]];
	
	return NO;
}

- (BOOL)handleGetFriendLevelOK:(QQNotification*)event {
	LevelOpReplyPacket* packet = (LevelOpReplyPacket*)[event object];
	
	// set levels
	[_groupManager setFriendLevel:[packet levels]];
	
	return NO;
}

- (BOOL)handleGetSignatureOK:(QQNotification*)event {
	SignatureOpReplyPacket* packet = (SignatureOpReplyPacket*)[event object];
	
	// for update, so don't check sequence here
	[_groupManager setSignature:[packet signatures]];
	
	return NO;
}

- (BOOL)handleBatchGetFriendRemarkOK:(QQNotification*)event {
	FriendDataOpReplyPacket* packet = (FriendDataOpReplyPacket*)[event object];
	
	// set remark
	[_groupManager setRemarks:[packet remarks]];
	
	return NO;
}

- (BOOL)handleReceivedIM:(QQNotification*)event {
	MessagePushFlag flag = [_messageManager put:[event object]];
	if(flag == kIMPushed || flag == kSysIMPushed) {
		// reload table
		if(_selectedTag == kTagMessage)
			[_messageTable reloadData];
		
		// refresh badge
		[self _refreshMessageButtonBadge];
		
		// refresh application badge
		if([UIApp isSuspended]) 
			[self _refreshApplicationBadge];
		
		// play sound
		PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
		if([tool booleanValue:kPreferenceKeyDisableSound] == NO) {
			if(flag == kIMPushed)
				[SoundTool playUserMessageSound];
			else if(flag == kSysIMPushed)
				[SoundTool playSystemMessageSound];
		}
	} 
	
	return YES;
}

- (BOOL)handleReceivedSystemNotification:(QQNotification*)event {
	SystemNotificationPacket* packet = [event object];
	if([_messageManager putSystemNotification:packet]) {
		// reload table
		if(_selectedTag == kTagMessage)
			[_messageTable reloadData];
		
		// refresh badge
		[self _refreshMessageButtonBadge];
		
		// refresh application badge
		if([UIApp isSuspended]) 
			[self _refreshApplicationBadge];
		
		// play sound
		PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
		if([tool booleanValue:kPreferenceKeyDisableSound] == NO) {
			[SoundTool playSystemMessageSound];
		}
	}
	
	return YES;
}

- (BOOL)handleRemoveFriendFromListOK:(QQNotification*)event {
	OutPacket* packet = [event outPacket];
	if([packet sequence] == _waitingSequence) {
		// remove user and reload user table
		[_groupManager moveUser:_userToBeRemoved toGroupIndex:_destGroupIndex];
		
		// dismiss alert
		[_alertSheet dismiss];
		[_alertSheet release];
		_alertSheet = nil;
		
		// reload table
		[_userTable reloadData];
		
		return YES;
	}
	return NO;
}

- (BOOL)handleDeleteFriendOK:(QQNotification*)event {
	OutPacket* packet = [event outPacket];
	if([packet sequence] == _waitingSequence) {
		[_alertSheet setBodyText:L(@"RemovingUserFromServerList")];
		_waitingSequence = [_client removeFriendFromServerList:[_userToBeRemoved QQ]];
		
		return YES;
	}
	return NO;
}

- (BOOL)handleGetAuthInfoOK:(QQNotification*)event {
	AuthInfoOpReplyPacket* packet = (AuthInfoOpReplyPacket*)[event object];
	if(_waitingSequence == [packet sequence]) {
		// get auth info
		if(_deleteUserAuthInfo) {
			[_deleteUserAuthInfo release];
			_deleteUserAuthInfo = nil;
		}
		_deleteUserAuthInfo = [packet authInfo];
		[_deleteUserAuthInfo retain];
		
		// delete user
		[_alertSheet setBodyText:L(@"DeletingUser")];
		_waitingSequence = [_client deleteFriend:[_userToBeRemoved QQ] authInfo:_deleteUserAuthInfo];
		
		return YES;
	}
	return NO;
}

- (BOOL)handleUploadGroupNameOK:(QQNotification*)event {
	if(_alertSheet != nil)
		[_alertSheet setBodyText:L(@"UploadingFriendGroup")];
	return NO;
}

@end
