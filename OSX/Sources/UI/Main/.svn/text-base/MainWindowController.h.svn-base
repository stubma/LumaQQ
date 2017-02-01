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
#import "VerifyCodeWindowController.h"
#import "MainQQListener.h"
#import "QQClient.h"
#import "PSMTabBarControl.h"
#import "GetLoginTokenReplyPacket.h"
#import "SystemNotificationPacket.h"
#import "PasswordVerifyReplyPacket.h"
#import "LoginReplyPacket.h"
#import "FriendDataOpPacket.h"
#import "GetUserInfoReplyPacket.h"
#import "ClusterSendIMExPacket.h"
#import "SendIMPacket.h"
#import "ModifyInfoPacket.h"
#import "ChangeStatusPacket.h"
#import "GroupManager.h"
#import "ClusterBatchGetCardPacket.h"
#import "GetFriendListReplyPacket.h"
#import "GetFriendGroupReplyPacket.h"
#import "HeadControl.h"
#import "UserOutlineDataSource.h"
#import "ClusterOutlineDataSource.h"
#import "RecentTableDataSource.h"
#import "GroupDataOpReplyPacket.h"
#import "GetOnlineOpReplyPacket.h"
#import "GroupDataOpPacket.h"
#import "KeepAliveReplyPacket.h"
#import "PropertyOpReplyPacket.h"
#import "LevelOpReplyPacket.h"
#import "SignatureOpReplyPacket.h"
#import "FriendDataOpReplyPacket.h"
#import "ClusterCommandReplyPacket.h"
#import "ClusterCommandPacket.h"
#import "FriendStatusChangedPacket.h"
#import "FriendStatusChangedNotification.h"
#import "WindowRegistry.h"
#import "MessageQueue.h"
#import "FaceManager.h"
#import "HistoryManager.h"
#import "MobileTableDataSource.h"
#import "SideView.h"
#import "QQOutlineView.h"
#import "QQTableView.h"
#import "QBarView.h"
#import "PluginManager.h"
#import "OutlineTooltipController.h"
#import "JobController.h"

// outline tab view item label
#define kTabViewItemFriends @"Friends"
#define kTabViewItemClusters @"Clusters"
#define kTabViewItemMobiles @"Mobiles"
#define kTabViewItemRecent @"Recent"

@interface MainWindowController : NSWindowController {
	// ui controls
	IBOutlet NSProgressIndicator* m_piLogin;
	IBOutlet NSTextField* m_txtHint;
	IBOutlet NSTabView* m_tabMain;
	IBOutlet NSTabView* m_tabGroup;
	IBOutlet NSMenu* m_headMenu;
	IBOutlet NSSearchField* m_searchField;
	IBOutlet QQOutlineView* m_userOutline;
	IBOutlet QQOutlineView* m_clusterOutline;
	IBOutlet QQTableView* m_recentTable;
	IBOutlet QQTableView* m_mobileTable;
	IBOutlet NSDrawer* m_displaySettingDrawer;
	
	IBOutlet NSMenu* m_searchMenu;
	IBOutlet NSMenuItem* m_realNameItem;
	IBOutlet NSMenuItem* m_nickNameItem;
	IBOutlet NSMenuItem* m_qqItem;
	IBOutlet NSMenuItem* m_signatureItem;
	
	IBOutlet NSMenu* m_messageSettingMenu;
	
	// verify code window
	IBOutlet VerifyCodeWindowController* m_verifyCodeWindowController;
	
	// display setting drawer
	IBOutlet NSButton* m_chkShowLargeUserHead;
	IBOutlet NSButton* m_chkShowRealName;
	IBOutlet NSButton* m_chkShowNickName;
	IBOutlet NSButton* m_chkShowFriendLevel;
	IBOutlet NSButton* m_chkShowOnlineOnly;
	IBOutlet NSButton* m_chkShowSignature;
	IBOutlet NSButton* m_chkShowUserProperty;
	IBOutlet NSButton* m_chkShowStatusMessage;
	IBOutlet NSButton* m_chkShowClusterNameCard;
	IBOutlet NSButton* m_chkShowHorizontalLine;
	IBOutlet NSButton* m_chkAlternatingRowBackground;
	IBOutlet NSColorWell* m_outlineBackgroundColorWell;
	IBOutlet NSColorWell* m_outlineDefaultFontColorWell;
	IBOutlet NSColorWell* m_signatureFontColorWell;
	
	// input window
	IBOutlet NSWindow* m_inputWindow;
	IBOutlet NSTextField* m_txtInputTitle;
	IBOutlet NSTextField* m_txtInput;
	
	// progress window
	IBOutlet NSWindow* m_progressWindow;
	IBOutlet NSTextField* m_txtProgressHint;
	IBOutlet NSProgressIndicator* m_progressBar;
	
	// group select window
	IBOutlet NSWindow* m_groupSelectWindow;
	IBOutlet NSComboBox* m_cbGroup;
	
	// mobile info window
	IBOutlet NSWindow* m_mobileInfoWindow;
	IBOutlet NSTextField* m_txtMobileName;
	IBOutlet NSTextField* m_txtMobileNumber;
	
	// button
	IBOutlet NSButton* m_btnSearchWizard;
	IBOutlet NSButton* m_btnDisplaySetting;
	IBOutlet NSButton* m_btnSystemMessageList;
	IBOutlet NSMenu* m_actionMenu;
	
	// for auto hide
	IBOutlet SideView* m_sideView;
	IBOutlet NSTextField* m_txtSide;
	IBOutlet NSImageView* m_ivSide;
	
	// for switch outline
	IBOutlet PSMTabBarControl* m_outlineSwitcher;
	
	// QBar
	IBOutlet QBarView* m_qbarView;
	
	// qbar select window
	IBOutlet NSWindow* m_winQBarPlugins;
	IBOutlet NSTableView* m_pluginTable;
	IBOutlet NSTextField* m_txtQBarPluginCount;
	
	// plugin manager
	PluginManager* m_pluginManager;
	
	// main qq listener
	MainQQListener* m_mainQQListener;
	
	// indication filtering status
	BOOL m_filtering;
	
	// save current tab view item index when search user
	int m_savedOutlineIndex;
	
	// window registry
	WindowRegistry* m_windowRegistry;
	
	// for display setting
	BOOL m_displaySettingShouldChange;
	
	// toolbar
	NSToolbar* m_toolbar;
	NSToolbarItem* m_headItem;
	
	// qq client
	QQClient* m_client;
	
	// user info
	User* m_me;
	NSData* m_password;
	NSData* m_passwordMd5;
	char m_loginStatus;
	Connection* m_connection;
	
	// ui flag
	BOOL m_changingStatus;
	BOOL m_myInfoGot;
	
	// search mode flag
	int m_searchFlag;
	
	// group manager
	GroupManager* m_groupManager;
	
	// face manager
	FaceManager* m_faceManager;
	
	// history manager
	HistoryManager* m_historyManager;
	
	// message queue
	MessageQueue* m_messageQueue;
	NSMutableArray* m_postponedEventCache;
	
	// data source
	UserOutlineDataSource* m_userDataSource;
	ClusterOutlineDataSource* m_clusterDataSource;
	RecentTableDataSource* m_recentDataSource;
	MobileTableDataSource* m_mobileDataSource;
	
	// flag to control the hotkey enablement
	BOOL m_enableHotKey;
	
	// flag to indicate UI initialization status
	// if it is true, then friend list must be got
	BOOL m_UIInitialized;
	
	// flag to indicate we are refreshing friend list
	BOOL m_refreshingFriendList;
	
	// cache for block request
	NSMutableArray* m_requestBlockingCache;
	
	// cache for add/remove friend, map qq number to group index
	NSMutableDictionary* m_addFriendGroupMapping;
	NSMutableDictionary* m_removeFriendGroupMapping;
	
	// for update
	NSURLDownload* m_updateChecker;
	
	// check sheet type
	int m_sheetType;
	
	// for delete user
	User* m_userToBeDeleted;
	
	// flag to control hide on close
	BOOL m_ignoreHideOnClose;
	
	// for delete group
	int m_moveFriendsInDeleteGroupTo;
	
	// modify what font
	int m_modifyFont;
	
	// modify what color
	int m_modifyColor;
	
	// for auto hide
	BOOL m_autoHided;
	NSWindow* m_sideWindow;
	
	// for animation
	int m_animationType;
	
	// floating tooltip
	OutlineTooltipController* m_tooltipController;
	
	// job controller
	JobController* m_jobController;
}

// init
- (id)initWithQQ:(int)iQQ password:(NSData*)password passwordMd5:(NSData*)passwordMd5 loginStatus:(char)loginStatus connection:(Connection*)connection;

// action
- (IBAction)onCancel:(id)sender;
- (IBAction)onHeadItem:(id)sender;
- (IBAction)onOnline:(id)sender;
- (IBAction)onAway:(id)sender;
- (IBAction)onHidden:(id)sender;
- (IBAction)onOffline:(id)sender;
- (IBAction)onBusy:(id)sender;
- (IBAction)onMute:(id)sender;
- (IBAction)onQMe:(id)sender;
- (IBAction)onStatusHistory:(id)sender;
- (IBAction)onChangeStatusMessage:(id)sender;
- (IBAction)onClearStatusHistory:(id)sender;
- (IBAction)onMyInfo:(id)sender;
- (IBAction)onRealName:(id)sender;
- (IBAction)onNickName:(id)sender;
- (IBAction)onQQNumber:(id)sender;
- (IBAction)onSignature:(id)sender;
- (IBAction)onFilter:(id)sender;
- (IBAction)onClearFilter:(id)sender;
- (IBAction)onSearch:(id)sender;
- (IBAction)onActionButton:(id)sender;
- (IBAction)onRefreshFriendList:(id)sender;
- (IBAction)onRefreshFriendRemark:(id)sender;
- (IBAction)onRefreshFriendSignature:(id)sender;
- (IBAction)onDisplaySetting:(id)sender;
- (IBAction)onDisplaySettingOK:(id)sender;
- (IBAction)onDisplaySettingCancel:(id)sender;
- (IBAction)onChat:(id)sender;
- (IBAction)onUserInfo:(id)sender;
- (IBAction)onAddUser:(id)sender;
- (IBAction)onQuicklyAddUser:(id)sender;
- (IBAction)onDeleteUser:(id)sender;
- (IBAction)onMoveToBlacklist:(id)sender;
- (IBAction)onInputOK:(id)sender;
- (IBAction)onInputCancel:(id)sender;
- (IBAction)onViewInfo:(id)sender;
- (IBAction)onAddAsFriend:(id)sender;
- (IBAction)onTempSession:(id)sender;
- (IBAction)onAddCluster:(id)sender;
- (IBAction)onExitCluster:(id)sender;
- (IBAction)onUpdateOrganization:(id)sender;
- (IBAction)onEditOrganization:(id)sender;
- (IBAction)onCreateSubject:(id)sender;
- (IBAction)onCreateDialog:(id)sender;
- (IBAction)onDoubleClick:(id)sender;
- (IBAction)onExtractMessage:(id)sender;
- (IBAction)onApplyForAllClusters:(id)sender;
- (IBAction)onClusterMessageSetting:(id)sender;
- (IBAction)onPreference:(id)sender;
- (IBAction)onRemoveFromRecentContact:(id)sender;
- (IBAction)onClearAllRecentContacts:(id)sender;
- (IBAction)onOpenFaceManager:(id)sender;
- (IBAction)onSystemMessageList:(id)sender;
- (IBAction)onModifyRemarkName:(id)sender;
- (IBAction)onNewGroup:(id)sender;
- (IBAction)onRenameGroup:(id)sender;
- (IBAction)onDeleteGroup:(id)sender;
- (IBAction)onLogoutAndClose:(id)sender;
- (IBAction)onGroupSelectOK:(id)sender;
- (IBAction)onGroupSelectCancel:(id)sender;
- (IBAction)onModifyNickFont:(id)sender;
- (IBAction)onModifySignatureFont:(id)sender;
- (IBAction)onFontChanged:(id)sender;
- (IBAction)onOutlineBackgroundColorWell:(id)sender;
- (IBAction)onNickFontColorWell:(id)sender;
- (IBAction)onSignatureFontColorWell:(id)sender;
- (IBAction)onColorChanged:(id)sender;
- (IBAction)onNewMobile:(id)sender;
- (IBAction)onModifyMobile:(id)sender;
- (IBAction)onDeleteMobile:(id)sender;
- (IBAction)onMobileInfoOK:(id)sender;
- (IBAction)onMobileInfoCancel:(id)sender;
- (IBAction)onSendSMSToQQ:(id)sender;
- (IBAction)onSendSMSToMobile:(id)sender;
- (IBAction)onRestoreFromAutoHide:(id)sender;
- (IBAction)onScreenscrap:(id)sender;
- (IBAction)onQBarPluginOK:(id)sender;
- (IBAction)onQBarPluginCancel:(id)sender;

// helper
- (void)shutdownNetwork;
- (void)returnToLogin;
- (void)restartNetwork;
- (void)refreshStatusUI;
- (void)initializeMainPane;
- (void)restoreLastFrame;
- (void)restoreLastFrameOrigin;
- (void)refreshClusters:(NSArray*)clusters;
- (void)removeUserFromOutline:(User*)user;
- (void)reloadUsers;
- (void)reloadClusters;
- (void)reloadRecent;
- (void)addRequestBlockingEntry:(UInt32)QQ;
- (BOOL)shouldBlockRequest:(UInt32)QQ;
- (void)addAddFriendGroupMapping:(UInt32)QQ groupIndex:(int)groupIndex;
- (Group*)destinationGroupAddedTo:(UInt32)QQ;
- (int)destinationGroupIndexAddedTo:(UInt32)QQ;
- (BOOL)registerExtractMessageHotKey;
- (BOOL)registerScreenscrapHotKey;
- (void)refreshDockIcon;
- (void)addFriend:(UInt32)QQ;
- (void)moveUser:(UInt32)QQ toGroup:(Group*)group reload:(BOOL)reload;
- (void)deleteUser:(User*)user;
- (void)moveUserToBlacklist:(User*)user;
- (BOOL)needUploadFriendGroup;
- (void)showProgressWindow:(BOOL)show;
- (void)setProgressWindowHint:(NSString*)hint;
- (void)showGroupSelectWindow;
- (void)handleUserDidRemovedNotification:(NSNotification*)notification;
- (void)handleUserDidMovedNotification:(NSNotification*)notification;
- (Cluster*)parentClusterOf:(id)item;
- (void)setHint:(NSString*)hint;
- (void)saveImportantInfo;
- (void)changeClusterMessageSetting:(Cluster*)cluster newMessageSetting:(char)newSetting;
- (void)setToolbarVisibility:(BOOL)value;

// delegate
- (void)loginFailedAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;
- (void)networkErrorAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;
- (void)kickedOutAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;
- (void)inputSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void*)contextInfo;
- (void)moveToBlacklistAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;
- (void)uploadFriendGroupAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;
- (void)deleteGroupAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;
- (void)qbarPluginSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void*)contextInfo;

// setter and getter
- (QQClient*)client;
- (ContactInfo*)contact;
- (void)setContactInfo:(ContactInfo*)contact;
- (NSMutableDictionary*)removeFriendGroupMapping;
- (GroupManager*)groupManager;
- (FaceManager*)faceManager;
- (User*)me;
- (void)setMe:(User*)me;
- (UInt32)onlineUserCount;
- (WindowRegistry*)windowRegistry;
- (MessageQueue*)messageQueue;
- (NSOutlineView*)userOutline;
- (NSOutlineView*)clusterOutline;
- (NSTableView*)mobileTable;
- (HistoryManager*)historyManager;
- (NSButton*)systemMessageListButton;
- (NSImageView*)sideImageView;
- (BOOL)autoHided;
- (VerifyCodeWindowController*)verifyCodeWindowController;
- (BOOL)isMyInfoGot;
- (void)setMyInfoGot:(BOOL)flag;
- (NSProgressIndicator*)loginIndicator;
- (NSTabView*)mainTab;
- (void)setChangingStatus:(BOOL)flag;
- (NSMutableArray*)postponedEventCache;
- (BOOL)hotKeyEnabled;
- (NSToolbarItem*)headItem;
- (PluginManager*)pluginManager;
- (NSString*)currentOutlineLabel;
- (JobController*)jobController;
- (BOOL)isUIInitialized;
- (BOOL)isRefreshingFriendList;
- (void)setRefreshingFriendList:(BOOL)flag;

@end
