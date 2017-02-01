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
#import <UIKit/UITable.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIButtonBarButton.h>
#import <UIKit/UITableCellDisclosureView.h>
#import <UIKit/UIAnimation.h>
#import "UIController.h"
#import "QQClient.h"
#import "GroupManager.h"
#import "Cluster.h"
#import "UIUnit.h"
#import "UserTableDataSource.h"
#import "ClusterTableDataSource.h"
#import "MyselfTableDataSource.h"
#import "MessageTableDataSource.h"
#import "SearchTableDataSource.h"
#import "RecentTableDataSource.h"
#import "HistoryTableDataSource.h"
#import "MoreTableDataSource.h"
#import "JobController.h"
#import "UISwipeDeleteTable.h"

// ui tag
#define kTagMyself 1
#define kTagUsers 2
#define kTagClusters 3
#define kTagMessage 4
#define kTagRecent 5
#define kTagHistory 6
#define kTagSearch 7
#define kTagCustomize 10000

@class MessageManager;

@interface UIMain : NSObject <UIUnit, QQListener> {
	UIView* _view;
	UITable* _userTable;
	UITable* _clusterTable;
	UITable* _messageTable;
	UITable* _recentTable;
	UITable* _moreTable;
	UISwipeDeleteTable* _historyTable;
	UIPreferencesTable* _searchTable;
	UIPreferencesTable* _myselfTable;
	UIButtonBar* _buttonBar;
	UIImageView* _myselfDecorator;
	CGRect _buttonBarFrame;
	
	// data source
	UserTableDataSource* _userDataSource;
	ClusterTableDataSource* _clusterDataSource;
	MyselfTableDataSource* _myselfDataSource;
	MessageTableDataSource* _messageDataSource;
	SearchTableDataSource* _searchTableDataSource;
	RecentTableDataSource* _recentTableDataSource;
	MoreTableDataSource* _moreTableDataSource;
	HistoryTableDataSource* _historyTableDataSource;
	
	// track selected view
	int _oldSelectedUserTableCell;
	int _oldSelectedClusterTableCell;
	int _oldSelectedMessageTableCell;
	int _oldSelectedRecentTableCell;
	int _oldSelectedHistoryTableCell;
	int _selectedTag;
	
	// track old online user
	NSMutableArray* _onlineUsers;
	
	// track customize status
	BOOL _customizing;
	
	// controller
	UIController* _uiController;
	
	// other
	QQClient* _client;
	GroupManager* _groupManager;
	MessageManager* _messageManager;
	int _alertType;
	BOOL _relogin;
	UIAlertSheet* _alertSheet;
	UInt16 _waitingSequence;
	
	// for delete user
	int _destGroupIndex;
	User* _userToBeRemoved;
	NSData* _deleteUserAuthInfo;
	
	// data
	NSMutableDictionary* _data;
}

- (UIView*)_activeView;
- (void)_switchToView:(UIView*)view;
- (UIAnimation*)_getHideViewAnimation:(UIView*)view;
- (UIAnimation*)_getShowViewAnimation:(UIView*)view parent:(UIView*)superview;
- (void)_refreshMessageButtonBadge;
- (void)_refreshApplicationBadge;
- (void)_logout;
- (void)_relogin;
- (void)_decorateMyselfIcon;
- (UIButtonBar*)_createButtonBar;
- (void)_createMyselfDecorator;
- (UIView*)_viewWithTag:(int)tag;
- (void)_resetNavigationButton;
- (UIButtonBar*)_buttonBar;

- (void)reloadClusterPanel;
- (void)reloadUserPanel;
- (GroupManager*)groupManager;
- (QQClient*)client;
- (void)startClusterJob:(NSArray*)clusters;

- (void)friendJobTerminated:(JobController*)jobController;
- (void)clusterJobTerminated:(JobController*)jobController;
- (void)uploadJobTerminated:(JobController*)jobController;

- (void)myselfButtonClicked:(UIButtonBarButton*)button;
- (void)userButtonClicked:(UIButtonBarButton*)button;
- (void)clusterButtonClicked:(UIButtonBarButton*)button;
- (void)searchButtonClicked:(UIButtonBarButton*)button;
- (void)messageButtonClicked:(UIButtonBarButton*)button;
- (void)recentButtonClicked:(UIButtonBarButton*)button;
- (void)customizeButtonClicked:(UIButtonBarButton*)button;
- (void)historyButtonClicked:(UIButtonBarButton*)button;
- (void)viewMyInfoButtonClicked:(UIPushButton*)button;
- (void)applyStatusChangeButtonClicked:(UIPushButton*)button;

- (void)handleGroupExpandStatusChanged:(NSNotification*)notification;
- (void)handleClusterExpandStatusChanged:(NSNotification*)notification;
- (void)handleMessageSourcePopulated:(NSNotification*)notification;
- (void)handleHasMessageUnreadSourcePopulated:(NSNotification*)notification;
- (void)handleWillSuspend:(NSNotification*)notification;
- (void)handleWillResume:(NSNotification*)notification;
- (void)handleCellDoubleTapped:(NSNotification*)notification;
- (void)handleGroupNameChanged:(NSNotification*)notification;
- (void)handleGroupWillBeCreated:(NSNotification*)notification;
- (void)handleUserRemarkNameChanged:(NSNotification*)notification;
- (void)handleWantToDeleteGroup:(NSNotification*)notification;
- (void)handleClusterExited:(NSNotification*)notification;
- (void)handleClusterMessagetSettingChanged:(NSNotification*)notification;
- (void)handlePreferenceChanged:(NSNotification*)notification;
- (void)handleUserWillBeMovedToGroup:(NSNotification*)notification;
- (void)handleUserRemoved:(NSNotification*)notification;
- (void)handleKickedOutBySystem:(NSNotification*)notification;
- (void)handleFriendGroupRebuilt:(NSNotification*)notification;
- (void)handleSendIMOK:(NSNotification*)notification;

- (void)userDisclosureClicked:(UITableCellDisclosureView*)view;
- (void)clusterDisclosureClicked:(UITableCellDisclosureView*)view;
- (void)groupDisclosureClicked:(UITableCellDisclosureView*)view;
- (void)messageDisclosureClicked:(UITableCellDisclosureView*)view;
- (void)recentDisclosureClicked:(UITableCellDisclosureView*)view;
- (void)historyDisclosureClicked:(UITableCellDisclosureView*)view;

- (BOOL)handleGetOnlineFriendOK:(QQNotification*)event;
- (BOOL)handleGetClusterInfoOK:(QQNotification*)event;
- (BOOL)handleGetClusterVersionIdOK:(QQNotification*)event;
- (BOOL)handleBatchGetClusterNameCardOK:(QQNotification*)event;
- (BOOL)handleGetOnlineMemberOK:(QQNotification*)event;
- (BOOL)handleGetClusterVersionIdOK:(QQNotification*)event;
- (BOOL)handleGetMemberInfoOK:(QQNotification*)event;
- (BOOL)handleGetSignatureOK:(QQNotification*)event;
- (BOOL)handleGetFriendLevelOK:(QQNotification*)event;
- (BOOL)handleGetUserPropertyOK:(QQNotification*)event;
- (BOOL)handleBatchGetFriendRemarkOK:(QQNotification*)event;
- (BOOL)handleChangeStatusOK:(QQNotification*)event;
- (BOOL)handleFriendStatusChanged:(QQNotification*)event;
- (BOOL)handleGetUserInfoOK:(QQNotification*)event;
- (BOOL)handleReceivedIM:(QQNotification*)event;
- (BOOL)handleReceivedSystemNotification:(QQNotification*)event;
- (BOOL)handleGetMessageSettingOK:(QQNotification*)event;
- (BOOL)handleNetworkError:(QQNotification*)event;
- (BOOL)handleConnectionTimeout:(QQNotification*)event;
- (BOOL)handleGetAuthInfoOK:(QQNotification*)event;
- (BOOL)handleDeleteFriendOK:(QQNotification*)event;
- (BOOL)handleRemoveFriendFromListOK:(QQNotification*)event;
- (BOOL)handleUploadGroupNameOK:(QQNotification*)event;

@end
