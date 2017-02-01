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

#import "MainWindowController.h"
#import "LoginWindowController.h"
#import "QQNotification.h"
#import "AlertTool.h"
#import "ImageTool.h"
#import "PreferenceCache.h"
#import "User.h"
#import "RecentOutlineModel.h"
#import "UserOutlineModel.h"
#import "ClusterOutlineModel.h"
#import "MobileOutlineModel.h"
#import "FontTool.h"
#import "FriendStatus.h"
#import "QQCell.h"
#import "OutlineModel.h"
#import "ClusterCommandPacket.h"
#import "ClusterSubOpPacket.h"
#import "NSString-Validate.h"
#import "UserInfoWindowController.h"
#import "WindowRegistry.h"
#import "ModifyInfoPacket.h"
#import "KeepAliveReplyPacket.h"
#import "SearchWindowController.h"
#import "ModelEffectTask.h"
#import "FriendDataOpPacket.h"
#import "LocalizedStringTool.h"
#import "NormalIMWindowController.h"
#import "HotKeyManager.h"
#import "SystemNotificationPacket.h"
#import "ClusterAuthWindowController.h"
#import "UserAuthWindowController.h"
#import "LumaQQApplication.h"
#import "SoundHelper.h"
#import "TimerTaskManager.h"
#import "GroupDataOpPacket.h"
#import "SendIMPacket.h"
#import "ClusterSendIMExPacket.h"
#import "FileTool.h"
#import "ClusterBatchGetCardPacket.h"
#import "ParentLocatableOutlineDataSource.h"
#import "FriendStatusChangedNotification.h"
#import "FriendStatusChangedPacket.h"
#import "MessageWingTask.h"
#import "SystemMessageBlinkTask.h"
#import "AnimationHelper.h"
#import "ScreenscrapHelper.h"
#import "CreateSubjectWindowController.h"
#import "CreateDialogWindowController.h"
#import "SmoothTooltipTrackerDelegate.h"
#import <Growl/GrowlApplicationBridge.h>
#import "LQGrowlNotifyHelper.h"
#import "GetRemarkJob.h"
#import "GetSignatureJob.h"

// main tab view item label
#define _kTabViewItemMain @"Main"
#define _kTabViewItemLogin @"Login"

// toolbar identifier
#define _kToolItemHead @"ToolbarItemMyHead"
#define _kToolItemQBar @"ToolbarItemQBar"

// user outline menu item tags
#define _kMenuItemDeleteGroup 995
#define _kMenuItemRenameGroup 996
#define _kMenuItemNewGroup 997
#define _kMenuItemModifyRemarkName 998
#define _kMenuItemChatWithUser 999
#define _kMenuItemUserInfo 1000
#define _kMenuItemAddFriend 1001
#define _kMenuItemQuicklyAddFriend 1002
#define _kMenuItemdDeleteFriend 1003
#define _kMenuItemMoveToBlacklist 1004
#define _kMenuItemSendSMSToQQ 1005
#define _kMenuItemTempSessionToFriend 1006

// cluster outline item tags
#define _kMenuItemChatInCluster 1999
#define _kMenuItemViewInfo 2000
#define _kMenuItemAddAsFriend 2001
#define _kMenuItemTempSession 2002
#define _kMenuItemAddCluster 2003
#define _kMenuItemExitCluster 2004
#define _kMenuItemCreateCluster 2005 // removed already, but keep this constant
#define _kMenuItemUpdateOrganization 2006
#define _kMenuItemEditOrganization 2007
#define _kMenuItemCreateSubject 2008
#define _kMenuItemCreateDialog 2009
#define _kMenuItemMessageSetting 2010
#define _kMenuItemApplyForAllClusters 3000
#define _kMenuItemMessageSettingAccept 3001
#define _kMenuItemMessageSettingAutoEject 3002
#define _kMenuItemMessageSettingAcceptNoPrompt 3003
#define _kMenuItemMessageSettingDisplayCount 3004
#define _kMenuItemMessageSettingBlock 3005

// recent table item tags
#define _kMenuItemRemoveFromRecentContact 4000
#define _kMenuItemClearAllRecentContacts 4001

// mobile table item tags
#define _kMenuItemNewMobile 5000
#define _kMenuItemModifyMobileInfo 5001
#define _kMenuItemDeleteMobile 5002
#define _kMenuItemSendSMS 5003

// action menu item tags
#define _kMenuItemRefreshSignature 6000
#define _kMenuItemRefreshRemark 6001
#define _kMenuItemRefreshFriendList 6002

// sheet type
#define _kSheetLoginFailed 0
#define _kSheetNetworkError 1
#define _kSheetMoveToBlacklist 2
#define _kSheetInputQQ 3
#define _kSheetInputRemarkName 4
#define _kSheetUploadFriendGroupConfirmYes 5
#define _kSheetUploadFriendGroupConfirmNo 6
#define _kSheetUploadFriendGroup 7
#define _kSheetInputNewGroup 8
#define _kSheetInputRenameGroup 9
#define _kSheetInputDeleteGroup 10
#define _kSheetDeleteGroup 11
#define _kSheetNewMobile 12
#define _kSheetModifyMobile 13
#define _kSheetKickedOut 14
#define _kSheetInputQQForTempSession 15
#define _kSheetInputStatusMessage 16

// animation type
#define _kAnimationAutoHide 0
#define _kAnimationRestoreFromAutoHide 1
#define _kAnimationSideWindowMove 2

// modify font type
#define _kFontNick 0
#define _kFontSignature 1

// modify color type
#define _kColorOutlineBackground 0
#define _kColorNickFont 1
#define _kColorSignatureFont 2

@implementation MainWindowController

#pragma mark -
#pragma mark override super

- (id)initWithQQ:(int)iQQ password:(NSData*)password passwordMd5:(NSData*)passwordMd5 loginStatus:(char)loginStatus connection:(Connection*)connection {
	self = [super initWithWindowNibName:@"MainWindow"];
	if(self != nil) {
		m_changingStatus = YES;
		m_myInfoGot = NO;
		m_enableHotKey = NO;
		m_searchFlag = kFlagSearchByName | kFlagSearchByNick | kFlagSearchByQQ | kFlagSearchBySignature;
		m_windowRegistry = [[WindowRegistry alloc] init];
		m_messageQueue = [[MessageQueue alloc] init];
		m_postponedEventCache = [[NSMutableArray array] retain];
		m_requestBlockingCache = [[NSMutableArray array] retain];
		m_addFriendGroupMapping = [[NSMutableDictionary dictionary] retain];
		m_removeFriendGroupMapping = [[NSMutableDictionary dictionary] retain];
		m_sheetType = -1;
		m_ignoreHideOnClose = NO;
		m_autoHided = NO;
		m_filtering = NO;
		m_UIInitialized = NO;
		m_refreshingFriendList = NO;
		
		// save password key
		[password retain];
		[m_password release];
		m_password = password;
		
		// save password md5
		[passwordMd5 retain];
		[m_passwordMd5 release];
		m_passwordMd5 = passwordMd5;
		
		// save login status
		m_loginStatus = loginStatus;
		
		// save init connection
		[connection retain];
		[m_connection release];
		m_connection = connection;
		
		// initialize group manager
		m_groupManager = [[GroupManager alloc] initWithQQ:iQQ domain:self];
		m_faceManager = [[FaceManager alloc] initWithQQ:iQQ];
		[m_faceManager load];
		
		// init history manager
		m_historyManager = [[HistoryManager alloc] initWithQQ:iQQ];
		
		// get my object
		m_me = [[m_groupManager user:iQQ] retain];
		
		// initialize qbar plugin
		m_pluginManager = [[PluginManager alloc] initWithDomain:self];
		[m_pluginManager loadPlugins];
		
		// initialize tooltip control
		m_tooltipController = [[OutlineTooltipController alloc] initWithMainWindow:self];
		[NSBundle loadNibNamed:@"OutlineTooltip" owner:m_tooltipController];
		
		// initialze job controller
		m_jobController = [[JobController alloc] initWithMain:self];
	}
	return self;
}

- (void) dealloc {		
	[super dealloc];
}

- (void)windowDidLoad {					
	// initialize search field
	[m_searchField setTarget:self];
	[m_searchField setAction:@selector(onFilter:)];
	
	// initial outline tab
	[m_outlineSwitcher setStyleNamed:@"Unified"];
	[m_outlineSwitcher setCanCloseOnlyTab:NO];
	[m_outlineSwitcher setShowCloseTabButton:NO];
	[m_outlineSwitcher setUpHead:YES];
	[m_outlineSwitcher setSizeCellsToFit:YES];
	[m_outlineSwitcher setShowLabel:NO];
	
	// set drawer delegate
	[m_displaySettingDrawer setDelegate:self];
	
	// set qbar view delegate
	[m_qbarView setDelegate:self];
	
	// initialize preference
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	[cache reload];
	
	// initialize button
	[m_btnSearchWizard setToolTip:L(@"LQTooltipSearch", @"MainWindow")];
	[m_btnDisplaySetting setToolTip:L(@"LQTooltipDisplaySetting", @"MainWindow")];
	
	// initialize outline view data source
	m_userDataSource = [[UserOutlineDataSource alloc] initWithMainWindow:self];
	m_clusterDataSource = [[ClusterOutlineDataSource alloc] initWithMainWindowController:self];
	[m_userDataSource setShowOnlineOnly:[cache showOnlineOnly]];
	[m_userDataSource setShowLargeHead:[cache showLargeUserHead]];
	m_recentDataSource = [[RecentTableDataSource alloc] initWithGroupManager:m_groupManager];
	m_mobileDataSource = [[MobileTableDataSource alloc] initWithGroupManager:m_groupManager];
	
	//
	// initialize outline
	//
	
	[[m_userOutline tableColumnWithIdentifier:@"0"] setDataCell:[[[QQCell alloc] initWithQQ:[m_me QQ]] autorelease]];
	[m_userOutline setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
	[m_userOutline setAutoresizesOutlineColumn:YES];
	[m_userOutline setGridStyleMask:([cache showHorizontalLine] ? NSTableViewSolidHorizontalGridLineMask : NSTableViewGridNone)];
	[m_userOutline setUsesAlternatingRowBackgroundColors:[cache alternatingRowBackground]];
	[m_userOutline setBackgroundColor:[cache background]];
	[m_userOutline setIntercellSpacing:NSMakeSize(0, 0)];
	[m_userOutline setTarget:self];
	[m_userOutline setDoubleAction:@selector(onDoubleClick:)];
	[m_userOutline setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];
	[m_userOutline registerForDraggedTypes:[NSArray arrayWithObject:NSStringPboardType]];
	[m_userOutline setTooltipDelegate:self];
	
	QQCell* cell = [[[QQCell alloc] initWithQQ:[m_me QQ]] autorelease];
	[cell setMemberStyle:YES];
	[[m_clusterOutline tableColumnWithIdentifier:@"0"] setDataCell:cell];
	[m_clusterOutline setAutoresizesOutlineColumn:YES];
	[m_clusterOutline setGridStyleMask:([cache showHorizontalLine] ? NSTableViewSolidHorizontalGridLineMask : NSTableViewGridNone)];
	[m_clusterOutline setUsesAlternatingRowBackgroundColors:[cache alternatingRowBackground]];
	[m_clusterOutline setBackgroundColor:[cache background]];
	[m_clusterOutline setTarget:self];
	[m_clusterOutline setDoubleAction:@selector(onDoubleClick:)];
	[m_clusterOutline setTooltipDelegate:self];
	
	cell = [[[QQCell alloc] initWithQQ:[m_me QQ]] autorelease];
	[cell setLargeClusterHeadStyle:YES];
	[cell setIgnoreLargeUserHeadPreference:YES];
	[[m_recentTable tableColumnWithIdentifier:@"0"] setDataCell:cell];
	[m_recentTable setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
	[m_recentTable setDataSource:m_recentDataSource];
	[m_recentTable setBackgroundColor:[cache background]];
	[m_recentTable setUsesAlternatingRowBackgroundColors:[cache alternatingRowBackground]];
	[m_recentTable setIntercellSpacing:NSMakeSize(0, 0)];
	[m_recentTable setTarget:self];
	[m_recentTable setDoubleAction:@selector(onDoubleClick:)];
	[m_recentTable setTooltipDelegate:self];
	
	cell = [[[QQCell alloc] initWithQQ:[m_me QQ]] autorelease];
	[[m_mobileTable tableColumnWithIdentifier:@"0"] setDataCell:cell];
	[m_mobileTable setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
	[m_mobileTable setDataSource:m_mobileDataSource];
	[m_mobileTable setBackgroundColor:[cache background]];
	[m_mobileTable setUsesAlternatingRowBackgroundColors:[cache alternatingRowBackground]];
	[m_mobileTable setIntercellSpacing:NSMakeSize(0, 0)];
	[m_mobileTable setTarget:self];
	[m_mobileTable setDoubleAction:@selector(onDoubleClick:)];
	[m_mobileTable setTooltipDelegate:self];
	
	[m_tabGroup selectTabViewItemAtIndex:0];
	
	// initialize toolbar, we need set window frame according to hideToolbar option
	if([cache hideToolbar])
		[self restoreLastFrame];
	m_toolbar = [[NSToolbar alloc] initWithIdentifier:@"MainWindowToolBar"];
	[m_toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
	[m_toolbar setAllowsUserCustomization:NO];
	[m_toolbar setDelegate:self];
	[[self window] setToolbar:m_toolbar];
	if(![cache hideToolbar])
		[self restoreLastFrame];
	
	// initialize menu
	[m_messageSettingMenu setDelegate:self];
	
	// initialize window
	if([cache alwaysOnTop])
		[[self window] setLevel:NSScreenSaverWindowLevel];
	
	// initial side view
	[m_sideView setMainWindowController:self];
	
	// create main qq listener
	m_mainQQListener = [[MainQQListener alloc] initWithMainWindow:self];
	
	// register window
	[WindowRegistry registerMainWindow:[m_me QQ] window:self];
	
	// add notification observer
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleUserDidRemovedNotification:)
												 name:kUserDidRemovedNotificationName
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleUserDidMovedNotification:)
												 name:kUserDidMovedNotificationName
											   object:nil];	
	
	// check update
	NSURL* url = [NSURL URLWithString:@"http://lumaqq.linuxsir.org/update/update.txt"];
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	m_updateChecker = [[NSURLDownload alloc] initWithRequest:request delegate:self];
	[m_updateChecker setDeletesFileUponFailure:YES];
	[m_updateChecker setDestination:kLQFileUpdate allowOverwrite:YES];
	[m_updateChecker request];
	
	// start login process
	[self restartNetwork];
}

- (IBAction)showWindow:(id)sender {
	[super showWindow:sender];
	
	// restore frame origin, showwindow will do some mystic thing to change window frame
	[self restoreLastFrameOrigin];
	
	// register hotkey
	if(![self registerExtractMessageHotKey] || ![self registerScreenscrapHotKey]) {
		[AlertTool showWarning:[self window]
					   message:L(@"LQWarningHotKeyRegisterFailed", @"MainWindow")];
	}
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	// detach delegate
	[m_userOutline setDelegate:nil];
	[m_clusterOutline setDelegate:nil];
	[m_mobileTable setDelegate:nil];
	[m_recentTable setDelegate:nil];
	
	// remove notification observers
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kUserDidRemovedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kUserDidMovedNotificationName
												  object:nil];
	
	// stop related timer task
	[[TimerTaskManager sharedManager] removeTasks:self];
	
	// cancel updater
	if(m_updateChecker) {
		[m_updateChecker cancel];
		[m_updateChecker release];
		m_updateChecker = nil;
	}
	
	// save info
	[self saveImportantInfo];
	
	// clear job
	[m_jobController terminate];
	
	// shutdown network
	[self shutdownNetwork];
	
	// release
	[m_client removeQQListener:m_mainQQListener];
	[m_client release];
	[m_client dealloc];
	m_client = nil;
	[m_toolbar release];
	[WindowRegistry unregisterMainWindow:[m_me QQ]];
	
	// get system perference
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	
	// unregister hot key
	[[HotKeyManager sharedHotKeyManager] unregisterHotKeyByString:[cache extractMessageHotKey]
															owner:[m_me QQ]];
	[[HotKeyManager sharedHotKeyManager] unregisterHotKeyByString:[cache screenscrapHotKey]
															owner:[m_me QQ]];
	
	// remove active window
	if([LumaQQApplication activeMainWindow] == self) {
		[LumaQQApplication setActiveMainWindow:nil];
		[NSApp setApplicationIconImage:[NSImage imageNamed:kImageQQGGOffline]];
	}
	
	// unload qbar plugins
	[m_pluginManager unloadPlugins];
	
	// release
	if(m_sideWindow) {
		[m_sideWindow close];
		[m_sideWindow release];
		m_sideWindow = nil;
	}
	if(m_tooltipController) {
		[m_tooltipController hideTooltip];
		[m_tooltipController release];
		m_tooltipController = nil;
	}		
	[m_jobController release];
	m_jobController = nil;
	[m_pluginManager release];
	m_pluginManager = nil;
	[m_me release];
	m_me = nil;
	[m_mainQQListener release];
	m_mainQQListener = nil;
	[m_userDataSource release];
	m_userDataSource = nil;
	[m_clusterDataSource release];
	m_clusterDataSource = nil;
	[m_recentDataSource release];
	m_recentDataSource = nil;
	[m_mobileDataSource release];
	m_mobileDataSource = nil;
	[m_password release];
	m_password = nil;
	[m_passwordMd5 release];
	m_passwordMd5 = nil;
	[m_connection release];
	m_connection = nil;
	[m_groupManager release];
	m_groupManager = nil;
	[m_faceManager release];
	m_faceManager = nil;
	[m_historyManager release];
	m_historyManager = nil;
	[m_windowRegistry release];
	m_windowRegistry = nil;
	[m_messageQueue release];
	m_messageQueue = nil;
	[m_postponedEventCache release];
	m_postponedEventCache = nil;
	[m_requestBlockingCache release];
	m_requestBlockingCache = nil;
	[m_addFriendGroupMapping release];
	m_addFriendGroupMapping = nil;
	[m_removeFriendGroupMapping release];
	m_removeFriendGroupMapping = nil;
	
	[self release];
}

- (BOOL)windowShouldClose:(id)sender {	
	// if hide on close
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	if(!m_ignoreHideOnClose && [cache hideOnClose]) {
		[[self window] orderOut:self];
	} else if([m_groupManager changed] && [cache uploadFriendGroupMode] != kLQUploadNever) {
		if([cache uploadFriendGroupMode] == kLQUploadAsk) {
			[AlertTool showConfirm:[self window]
						   message:L(@"LQWarningUploadConfirm", @"MainWindow")
					 defaultButton:L(@"LQYes")
				   alternateButton:L(@"LQNo")
						  delegate:self
					didEndSelector:@selector(uploadFriendGroupAlertDidEnd:returnCode:contextInfo:)];
		} else {
			[self showProgressWindow:YES];
			[m_mainQQListener uploadGroupNames];
		}
		
		return NO;
	}

	return m_ignoreHideOnClose ? YES : ![cache hideOnClose];
}

- (void)windowDidBecomeKey:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	[LumaQQApplication setActiveMainWindow:self];
	[self refreshDockIcon];
}

- (void)windowDidEndSheet:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	switch(m_sheetType) {
		case _kSheetLoginFailed:
		case _kSheetNetworkError:
		case _kSheetKickedOut:
			[self shutdownNetwork];
			[self returnToLogin];
			break;
		case _kSheetInputQQ:
			[m_windowRegistry showAddFriendWindow:[[m_txtInput stringValue] intValue] mainWindow:self];
			break;
		case _kSheetInputStatusMessage:
			PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
			[cache setStatusMessage:[m_txtInput stringValue]];
			[[cache statusHistory] addObject:[m_txtInput stringValue]];
			[m_client changeStatusMessage:[m_txtInput stringValue]];
			break;
		case _kSheetInputQQForTempSession:
			User* user = [m_groupManager user:[[m_txtInput stringValue] intValue]];
			if(user == nil)
				user = [[[User alloc] initWithQQ:[[m_txtInput stringValue] intValue] domain:self] autorelease];
			[m_windowRegistry showTempSessionIMWindowOrTab:user mainWindow:self];
			break;
		case _kSheetInputRemarkName:
			user = [m_userOutline itemAtRow:[m_userOutline selectedRow]];
			if(user) {
				NSString* name = [m_txtInput stringValue];
				[user setRemarkName:name];
				[m_client modifyRemarkName:[user QQ] name:name];
				[m_userOutline reloadItem:user];
			}
			break;
		case _kSheetInputNewGroup:
			[m_groupManager addFriendlyGroup:[m_txtInput stringValue]];
			[m_userOutline reloadData];
			break;
		case _kSheetInputRenameGroup:
			Group* group = [m_userOutline itemAtRow:[m_userOutline selectedRow]];
			if(group) {
				[m_groupManager setGroupName:group name:[m_txtInput stringValue]];
				[m_userOutline reloadItem:group];
			}
			break;
		case _kSheetMoveToBlacklist:
			// open delete user window
			if(m_userToBeDeleted) {
				[m_removeFriendGroupMapping setObject:[NSNumber numberWithInt:[m_groupManager blacklistGroupIndex]]
											   forKey:[NSNumber numberWithUnsignedInt:[m_userToBeDeleted QQ]]];
				[m_windowRegistry showDeleteUserWindow:m_userToBeDeleted mainWindow:self];
			}
			break;
		case _kSheetUploadFriendGroupConfirmNo:
		case _kSheetUploadFriendGroup:
			[m_groupManager saveGroups];
			[self close];
			break;
		case _kSheetUploadFriendGroupConfirmYes:
			[self showProgressWindow:YES];
			[m_mainQQListener uploadGroupNames];
			break;
		case _kSheetDeleteGroup:
			group = [m_userOutline itemAtRow:[m_userOutline selectedRow]];
			int index = [m_groupManager indexOfGroup:group];
			if(index == m_moveFriendsInDeleteGroupTo) {
				[AlertTool showWarning:[self window] message:L(@"LQWarningMoveToSameAsToBeDeleted", @"MainWindow")];
			} else {
				[m_groupManager moveAllUsersFrom:index to:m_moveFriendsInDeleteGroupTo];
				[m_groupManager removeGroupAt:index];
				[m_userOutline reloadData];
			}
			break;
		case _kSheetNewMobile:
			Mobile* mobile = [[[Mobile alloc] initWithName:[m_txtMobileName stringValue] mobile:[m_txtMobileNumber stringValue] domain:self] autorelease];
			[m_groupManager addMobile:mobile];
			[m_mobileTable reloadData];
			break;
		case _kSheetModifyMobile:
			mobile = [m_groupManager mobileAtIndex:[m_mobileTable selectedRow]];
			[mobile setName:[m_txtMobileName stringValue]];
			[mobile setMobile:[m_txtMobileNumber stringValue]];
			[m_mobileTable reloadData];
			break;
	}
	
	m_sheetType = -1;
}

- (void)windowDidMove:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	// check auto hide setting
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	if([cache autoHideMainWindow]) {			
		// first, check whether a sheet is displayed, if yes, don't perform auto hiding
		NSWindow* sheet = [[self window] attachedSheet];
		if(sheet) 
			return;
		
		// get new frame
		NSRect frame = [[self window] frame];
		
		// get screen size
		NSRect screenFrame = [[NSScreen mainScreen] frame];
		
		// check intersect
		BOOL left = frame.origin.x < 0;
		BOOL right = NSMaxX(frame) > NSMaxX(screenFrame);
		BOOL top = NSMaxY(frame) > NSMaxY(screenFrame);
		BOOL bottom = frame.origin.y < 0;
		
		// check side
		if(left || right || top || bottom) {
			// set flag
			m_autoHided = YES;
			
			// get view bound
			NSRect viewBound = [m_sideView bounds];
			
			// create side window
			m_sideWindow = [[NSWindow alloc] initWithContentRect:viewBound
														   styleMask:NSBorderlessWindowMask
															 backing:NSBackingStoreBuffered
															   defer:YES];
			[m_sideWindow setReleasedWhenClosed:NO];
			[m_sideWindow setLevel:NSScreenSaverWindowLevel];
			
			// add side view
			[[m_sideWindow contentView] addSubview:m_sideView];
			[m_txtSide setStringValue:[[NSNumber numberWithUnsignedInt:[m_me QQ]] description]];
			
			// set next responder
			[m_sideWindow setInitialFirstResponder:m_sideView];
			[m_txtSide setNextResponder:m_sideView];
			[m_ivSide setNextResponder:m_sideView];
			
			// set frame
			if(right) {
				frame.origin.x = NSMaxX(screenFrame) - NSWidth(viewBound);
				[m_sideView setDockSide:kSideRight];
			} else if(left) {
				frame.origin.x = 0;
				[m_sideView setDockSide:kSideLeft];
			}
			if(bottom) {
				frame.origin.y = 0;
				[m_sideView setDockSide:kSideBottom];
			} else if(top) {
				frame.origin.y = NSMaxY(screenFrame) - NSHeight(viewBound);
				[m_sideView setDockSide:kSideTop];
			}				
			frame.size = viewBound.size;
			
			// set side window frame
			[m_sideWindow setFrameOrigin:frame.origin];
			
			// forbid autoresize because it will mess UI
			[[[self window] contentView] setAutoresizesSubviews:NO];
			
			// set window background
			[m_sideWindow setBackgroundColor:[NSColor lightGrayColor]];
			
			// start animation
			m_animationType = _kAnimationAutoHide;
			[AnimationHelper moveWindow:[self window]
								   from:[[self window] frame]
									 to:frame
							   delegate:self];
		}
	}
}

#pragma mark -
#pragma mark actions

- (IBAction)onCancel:(id)sender {
	// shutdown network
	[self shutdownNetwork];
	
	// return to login window
	[self returnToLogin];
}

- (IBAction)onHeadItem:(id)sender {	
	// get head bound
	NSRect bound = [(HeadControl*)[m_headItem view] bounds];	
	
	// calculate
	bound = [(HeadControl*)[m_headItem view] convertRect:bound toView:nil];
	
	// create a mouse event and popup menu
	NSEvent* event = [NSEvent mouseEventWithType:NSLeftMouseDown
										location:bound.origin
								   modifierFlags:NSLeftMouseDownMask
									   timestamp:0
									windowNumber:[[self window] windowNumber]
										 context:[[self window] graphicsContext]
									 eventNumber:0
									  clickCount:0
										pressure:0];
	[NSMenu popUpContextMenu:m_headMenu
				   withEvent:event
					 forView:m_tabMain];
}

- (IBAction)onOnline:(id)sender {
	if([[m_client user] status] != kQQStatusOnline) {
		// set flag
		m_changingStatus = YES;
		
		// save status message
		[[PreferenceCache cache:[m_me QQ]] setStatusMessage:L(@"LQStatusOnline")];
		
		// change status or login
		if([[m_client user] status] == kQQStatusOffline) {
			m_loginStatus = kQQStatusOnline;
			[self restartNetwork];
		} else
			[m_client changeStatus:kQQStatusOnline];
	}
}

- (IBAction)onAway:(id)sender {
	if([[m_client user] status] != kQQStatusAway) {
		// set flag
		m_changingStatus = YES;
		
		// save status message
		[[PreferenceCache cache:[m_me QQ]] setStatusMessage:L(@"LQStatusAway")];
		
		// change status or login
		if([[m_client user] status] == kQQStatusOffline) {
			m_loginStatus = kQQStatusAway;
			[self restartNetwork];
		} else
			[m_client changeStatus:kQQStatusAway];
	}
}

- (IBAction)onHidden:(id)sender {
	if([[m_client user] status] != kQQStatusHidden) {
		// set flag
		m_changingStatus = YES;
		
		// save status message
		[[PreferenceCache cache:[m_me QQ]] setStatusMessage:L(@"LQStatusHidden")];
		
		// change status or login
		if([[m_client user] status] == kQQStatusOffline) {
			m_loginStatus = kQQStatusHidden;
			[self restartNetwork];
		} else
			[m_client changeStatus:kQQStatusHidden];
	}
}

- (IBAction)onOffline:(id)sender {
	if([[m_client user] status] != kQQStatusOffline) {
		// save status message
		[[PreferenceCache cache:[m_me QQ]] setStatusMessage:L(@"LQStatusOffline")];
		
		// shutdown network layer
		[self shutdownNetwork];
		
		// refresh ui
		[self refreshStatusUI];
	}
}

- (IBAction)onBusy:(id)sender {
	if([[m_client user] status] != kQQStatusBusy) {
		// set flag
		m_changingStatus = YES;
		
		// save status message
		[[PreferenceCache cache:[m_me QQ]] setStatusMessage:L(@"LQStatusBusy")];
		
		// change status or login
		if([[m_client user] status] == kQQStatusOffline) {
			m_loginStatus = kQQStatusBusy;
			[self restartNetwork];
		} else
			[m_client changeStatus:kQQStatusBusy];
	}
}

- (IBAction)onMute:(id)sender {
	if([[m_client user] status] != kQQStatusMute) {
		// set flag
		m_changingStatus = YES;
		
		// save status message
		[[PreferenceCache cache:[m_me QQ]] setStatusMessage:L(@"LQStatusMute")];
		
		// change status or login
		if([[m_client user] status] == kQQStatusOffline) {
			m_loginStatus = kQQStatusMute;
			[self restartNetwork];
		} else
			[m_client changeStatus:kQQStatusMute];
	}
}

- (IBAction)onQMe:(id)sender {
	if([[m_client user] status] != kQQStatusQMe) {
		// set flag
		m_changingStatus = YES;
		
		// save status message
		[[PreferenceCache cache:[m_me QQ]] setStatusMessage:L(@"LQStatusQMe")];
		
		// change status or login
		if([[m_client user] status] == kQQStatusOffline) {
			m_loginStatus = kQQStatusQMe;
			[self restartNetwork];
		} else
			[m_client changeStatus:kQQStatusQMe];
	}
}

- (IBAction)onMyInfo:(id)sender {
	[m_windowRegistry showUserInfoWindow:m_me mainWindow:self];
}

- (IBAction)onStatusHistory:(id)sender {
	NSString* title = [sender title];
	if(title) {
		// save status message
		PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
		[cache setStatusMessage:title];
		
		// set status message
		[m_client changeStatusMessage:title];
	}
}

- (IBAction)onChangeStatusMessage:(id)sender {
	m_sheetType = _kSheetInputStatusMessage;
	[m_txtInputTitle setStringValue:L(@"LQHintInputStatusMessage", @"MainWindow")];
	[m_txtInput setStringValue:kStringEmpty];
	[NSApp beginSheet:m_inputWindow
	   modalForWindow:[self window]
		modalDelegate:self
	   didEndSelector:@selector(inputSheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
}

- (IBAction)onClearStatusHistory:(id)sender {
	[[PreferenceCache cache:[m_me QQ]] clearStatusHistory];
}

- (IBAction)onRealName:(id)sender {
	if([m_realNameItem state]) {
		m_searchFlag ^= kFlagSearchByName;
		[m_realNameItem setState:NSOffState];
	} else {
		m_searchFlag |= kFlagSearchByName;
		[m_realNameItem setState:NSOnState];
	}
	[[m_searchField cell] setSearchMenuTemplate:m_searchMenu];
	
	[self onFilter:m_searchField];
}

- (IBAction)onNickName:(id)sender {
	if([m_nickNameItem state]) {
		m_searchFlag ^= kFlagSearchByNick;
		[m_nickNameItem setState:NSOffState];
	} else {
		m_searchFlag |= kFlagSearchByNick;
		[m_nickNameItem setState:NSOnState];
	}
	[[m_searchField cell] setSearchMenuTemplate:m_searchMenu];
	
	[self onFilter:m_searchField];
}

- (IBAction)onQQNumber:(id)sender {
	if([m_qqItem state]) {
		m_searchFlag ^= kFlagSearchByQQ;
		[m_qqItem setState:NSOffState];
	} else {
		m_searchFlag |= kFlagSearchByQQ;
		[m_qqItem setState:NSOnState];
	}	
	[[m_searchField cell] setSearchMenuTemplate:m_searchMenu];
	
	[self onFilter:m_searchField];
}

- (IBAction)onSignature:(id)sender {
	if([m_signatureItem state]) {
		m_searchFlag ^= kFlagSearchBySignature;
		[m_signatureItem setState:NSOffState];
	} else {
		m_searchFlag |= kFlagSearchBySignature;
		[m_signatureItem setState:NSOnState];
	}		
	[[m_searchField cell] setSearchMenuTemplate:m_searchMenu];
	
	[self onFilter:m_searchField];
}

- (IBAction)onFilter:(id)sender {
	// set search criteria
	NSString* text = [(NSControl*)sender stringValue];
	if(text == nil || [text isEmpty]) {
		// we think the filtering is end
		if(m_filtering) {
			m_filtering = NO;
			[m_userDataSource rollbackShowOnlineOnlyOption];
			[m_userOutline restoreExpandedStatus];
			[m_tabGroup selectTabViewItemAtIndex:m_savedOutlineIndex];
		}
		
		// clear search criteria
		[m_userDataSource setSearchMode:kFlagSearchNone];
	} else {
		// if not filtering, save expand status and expand all
		// also, forbid show online only temporarily
		if(!m_filtering) {
			m_filtering = YES;
			m_savedOutlineIndex = [m_tabGroup indexOfTabViewItem:[m_tabGroup selectedTabViewItem]];
			[m_userDataSource saveShowOnlineOnlyOption];
			[m_userDataSource setShowOnlineOnly:NO];
			[m_userOutline saveExpandedStatus];
			[m_userOutline expandAll];
			[m_tabGroup selectTabViewItemAtIndex:0];
		}
		
		// set search criteria
		[m_userDataSource setSearchMode:m_searchFlag];
		[m_userDataSource setSearchText:text];
	}
	
	// refresh outline
	[m_userOutline reloadData];
}

- (IBAction)onClearFilter:(id)sender {
	// clear search field and reset search mode
	[m_searchField setStringValue:kStringEmpty];
	[m_userDataSource setSearchMode:kFlagSearchNone];
	[m_userDataSource setSearchText:kStringEmpty];
	
	// we think the filtering is end
	if(m_filtering) {
		m_filtering = NO;
		[m_userDataSource rollbackShowOnlineOnlyOption];
		[m_userOutline restoreExpandedStatus];
		[m_tabGroup selectTabViewItemAtIndex:m_savedOutlineIndex];
	}

	[m_userOutline reloadData];
}

- (IBAction)onSearch:(id)sender {
	// get start page
	NSString* label = [[m_tabGroup selectedTabViewItem] label];
	NSString* startPage = kTabViewItemSearchWhat;
	if([label isEqualToString:kTabViewItemFriends])
		startPage = kTabViewItemSearchUser;
	else if([label isEqualToString:kTabViewItemClusters])
		startPage = kTabViewItemSearchCluster;
	
	// show search wizard
	[m_windowRegistry showSearchWizard:[m_me QQ]
							mainWindow:self 
						pageIdentifier:startPage];
}

- (IBAction)onActionButton:(id)sender {
	// get head bound
	NSRect bound = [sender bounds];	
	
	// calculate
	bound = [sender convertRect:bound toView:nil];
	
	// create a mouse event and popup menu
	NSEvent* event = [NSEvent mouseEventWithType:NSLeftMouseDown
										location:bound.origin
								   modifierFlags:NSLeftMouseDownMask
									   timestamp:0
									windowNumber:[[self window] windowNumber]
										 context:[[self window] graphicsContext]
									 eventNumber:0
									  clickCount:0
										pressure:0];
	[NSMenu popUpContextMenu:m_actionMenu
				   withEvent:event
					 forView:sender];
}

- (IBAction)onRefreshFriendList:(id)sender {
	if(![self isRefreshingFriendList]) {
		[self setRefreshingFriendList:YES];
		[[TimerTaskManager sharedManager] clear];
		[m_client downloadGroupNames];
	}
}

- (IBAction)onRefreshFriendRemark:(id)sender {
	[m_jobController startJob:[[[GetRemarkJob alloc] init] autorelease]];
}

- (IBAction)onRefreshFriendSignature:(id)sender {
	[m_jobController startJob:[[[GetSignatureJob alloc] init] autorelease]];
}

- (IBAction)onDisplaySetting:(id)sender {
	// set proper size of drawer
	[m_displaySettingDrawer setContentSize:[m_displaySettingDrawer maxContentSize]];
	
	// show it or close it
	[m_displaySettingDrawer toggle:self];
}

- (IBAction)onDisplaySettingOK:(id)sender {
	// set flag, actual setting saving is done in delegate method
	m_displaySettingShouldChange = YES;
	
	[m_displaySettingDrawer toggle:self];
}

- (IBAction)onDisplaySettingCancel:(id)sender {
	m_displaySettingShouldChange = NO;
	[m_displaySettingDrawer toggle:self];
}

- (IBAction)onChat:(id)sender {
	switch([sender tag]) {
		case _kMenuItemChatInCluster:
			id obj = [m_clusterOutline itemAtRow:[m_clusterOutline selectedRow]];
			if([obj isMemberOfClass:[Cluster class]])
				[m_windowRegistry showClusterIMWindowOrTab:(Cluster*)obj mainWindow:self];
			else if([obj isMemberOfClass:[User class]]) {
				//
				// check if it's my friend, if it is, open normal im window, if not, open temp session im window
				//
				
				// get user and group
				User* user = (User*)obj;
				Group* g = [m_groupManager group:[user groupIndex]];
				
				// g is null, then open temp session im window
				if(g)
					[m_windowRegistry showNormalIMWindowOrTab:user mainWindow:self];
				else
					[m_windowRegistry showTempSessionIMWindowOrTab:user mainWindow:self];
			}
			break;
		case _kMenuItemChatWithUser:
			User* user = [m_userOutline itemAtRow:[m_userOutline selectedRow]];
			[m_windowRegistry showNormalIMWindowOrTab:user mainWindow:self];
			break;
	}
}

- (IBAction)onUserInfo:(id)sender {
	User* user = [m_userOutline itemAtRow:[m_userOutline selectedRow]];
	[m_windowRegistry showUserInfoWindow:user mainWindow:self];
}

- (IBAction)onAddUser:(id)sender {
	[m_windowRegistry showSearchWizard:[m_me QQ]
							mainWindow:self 
						pageIdentifier:kTabViewItemSearchUser];
}

- (IBAction)onQuicklyAddUser:(id)sender {
	m_sheetType = _kSheetInputQQ;
	[m_txtInputTitle setStringValue:L(@"LQHintInputQQ", @"MainWindow")];
	[m_txtInput setStringValue:kStringEmpty];
	[NSApp beginSheet:m_inputWindow
	   modalForWindow:[self window]
		modalDelegate:self
	   didEndSelector:@selector(inputSheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
}

- (IBAction)onModifyRemarkName:(id)sender {
	m_sheetType = _kSheetInputRemarkName;
	[m_txtInputTitle setStringValue:L(@"LQHintInputRemarkName", @"MainWindow")];
	[m_txtInput setStringValue:kStringEmpty];
	[NSApp beginSheet:m_inputWindow
	   modalForWindow:[self window]
		modalDelegate:self
	   didEndSelector:@selector(inputSheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
}

- (IBAction)onDeleteUser:(id)sender {
	User* user = [m_userOutline itemAtRow:[m_userOutline selectedRow]];
	[self deleteUser:user];
}

- (IBAction)onMoveToBlacklist:(id)sender {
	User* user = [m_userOutline itemAtRow:[m_userOutline selectedRow]];
	[self moveUserToBlacklist:user];
}

- (IBAction)onInputOK:(id)sender {
	// check qq input
	if((m_sheetType == _kSheetInputQQ || m_sheetType == _kSheetInputQQForTempSession) && [[m_txtInput stringValue] intValue] == 0) {
		[m_txtInputTitle setStringValue:L(@"LQHintErrorQQ", @"MainWindow")];
	} else {
		// close input sheet
		[NSApp endSheet:m_inputWindow returnCode:YES];
		[m_inputWindow orderOut:self];
	}
}

- (IBAction)onInputCancel:(id)sender {
	// close input sheet
	[NSApp endSheet:m_inputWindow returnCode:NO];
	[m_inputWindow orderOut:self];
}

- (IBAction)onViewInfo:(id)sender {
	id object = [m_clusterOutline itemAtRow:[m_clusterOutline selectedRow]];
	if([object isMemberOfClass:[User class]]) {
		Cluster* cluster = [self parentClusterOf:object];
		[m_windowRegistry showUserInfoWindow:(User*)object cluster:cluster mainWindow:self];
	} else if([object isMemberOfClass:[Cluster class]]) {
		Cluster* c = (Cluster*)object;
		if([c permanent])
			[m_windowRegistry showClusterInfoWindow:c mainWindow:self];
		else if([c isSubject]) { 
			Cluster* parent = [m_groupManager cluster:[c parentId]];
			if(parent) {
				if([parent memberCount] == 0)
					[m_client getClusterInfo:[parent internalId]];
				if([c memberCount] == 0)
					[m_client getSubjectInfo:[c internalId] parent:[parent internalId]];
				
				[m_windowRegistry showTempClusterInfoWindow:c
													 parent:parent
												 mainWindow:self];
			}
		} else if([c isDialog]) {
			if([c memberCount] == 0)
				[m_client getDialogInfo:[c internalId]];
			
			[m_windowRegistry showTempClusterInfoWindow:c
												 parent:nil
											 mainWindow:self];
		}
	}
}

- (IBAction)onAddAsFriend:(id)sender {
	User* user = [m_clusterOutline itemAtRow:[m_clusterOutline selectedRow]];
	if(user) {
		[m_windowRegistry showAddFriendWindow:[user QQ]
										 head:[user head]
										 nick:[user nick]
								   mainWindow:self];
	}
}

- (IBAction)onTempSession:(id)sender {
	User* user = nil;
	if([sender tag] == _kMenuItemTempSessionToFriend) {
		int row = [m_userOutline selectedRow];
		id obj = [m_userOutline itemAtRow:row];
		if([obj isMemberOfClass:[User class]])
			[m_windowRegistry showTempSessionIMWindowOrTab:obj mainWindow:self];
		else {
			m_sheetType = _kSheetInputQQForTempSession;
			[m_txtInputTitle setStringValue:L(@"LQHintInputQQForTempSession", @"MainWindow")];
			[m_txtInput setStringValue:kStringEmpty];
			[NSApp beginSheet:m_inputWindow
			   modalForWindow:[self window]
				modalDelegate:self
			   didEndSelector:@selector(inputSheetDidEnd:returnCode:contextInfo:)
				  contextInfo:nil];
		}
	} else if([sender tag] == _kMenuItemTempSession) {
		int row = [m_clusterOutline selectedRow];
		user = [m_clusterOutline itemAtRow:row];
		[m_windowRegistry showTempSessionIMWindowOrTab:user mainWindow:self];
	}
}

- (IBAction)onAddCluster:(id)sender {
	[m_windowRegistry showSearchWizard:[m_me QQ]
							mainWindow:self 
						pageIdentifier:kTabViewItemSearchCluster];
}

- (IBAction)onExitCluster:(id)sender {
	int row = [m_clusterOutline selectedRow];
	Cluster* cluster = [m_clusterOutline itemAtRow:row];
	if(cluster) {
		[cluster setOperationSuffix:L(@"LQOperationSuffixExitCluster", @"MainWindow")];
		[m_clusterOutline reloadItem:cluster];
		if([cluster permanent])
			[m_client exitCluster:[cluster internalId]];
		else if([cluster isSubject]) {
			Cluster* parent = [m_groupManager cluster:[cluster parentId]];
			if(parent)
				[m_client exitSubject:[cluster internalId] parent:[parent internalId]];
		} else if([cluster isDialog])
			[m_client exitDialog:[cluster internalId]];
	}
}

- (IBAction)onUpdateOrganization:(id)sender {
	Cluster* cluster = nil;
	id obj = [m_clusterOutline itemAtRow:[m_clusterOutline selectedRow]];
	if([obj isMemberOfClass:[Cluster class]])
		cluster = (Cluster*)obj;
	else if([obj isMemberOfClass:[Dummy class]])
		cluster = [m_clusterDataSource outlineView:m_clusterOutline parentOfItem:obj];
	
	// update
	if(cluster) {
		[[cluster organizationsDummy] setOperationSuffix:L(@"LQOperationSuffixGettInfo", @"MainWindow")];
		[[cluster organizationsDummy] setRequested:YES];
		[m_client getClusterInfo:[cluster internalId]];
		[m_client updateOrganization:[cluster internalId]];
		[m_clusterOutline reloadItem:[cluster organizationsDummy]];
	}
}

- (IBAction)onEditOrganization:(id)sender {
	
}

- (IBAction)onCreateSubject:(id)sender {
	// find permanent cluster
	Cluster* cluster = nil;
	id obj = [m_clusterOutline itemAtRow:[m_clusterOutline selectedRow]];
	if([obj isMemberOfClass:[Cluster class]])
		cluster = (Cluster*)obj;
	else if([obj isMemberOfClass:[Dummy class]])
		cluster = [m_clusterDataSource outlineView:m_clusterOutline parentOfItem:obj];
	
	// open window
	if(cluster) {
		// get cluster info if no member in it
		if([cluster memberCount] == 0)
			[m_client getClusterInfo:[cluster internalId]];
		
		CreateSubjectWindowController* csw = [[CreateSubjectWindowController alloc] initWithTempCluster:nil
																						  parentCluster:cluster
																							 mainWindow:self];
		[csw showWindow:self];
	}
}

- (IBAction)onCreateDialog:(id)sender {
	CreateDialogWindowController* cdw = [[CreateDialogWindowController alloc] initWithTempCluster:nil
																					parentCluster:nil
																					   mainWindow:self];
	[cdw showWindow:self];
}

- (IBAction)onDoubleClick:(id)sender {	
	if(sender == m_userOutline) {
		int row = [m_userOutline selectedRow];
		if(row == -1)
			return;
		id obj = [m_userOutline itemAtRow:row];
		if([obj isMemberOfClass:[User class]]) {
			User* user = (User*)obj;
			[m_windowRegistry showNormalIMWindowOrTab:user mainWindow:self];
		} else if([obj isMemberOfClass:[Group class]]) {
			if([m_userOutline isItemExpanded:obj])
				[m_userOutline collapseItem:obj];
			else
				[m_userOutline expandItem:obj];
		}
	} else if(sender == m_clusterOutline) {
		int row = [m_clusterOutline selectedRow];
		if(row == -1)
			return;
		id obj = [m_clusterOutline itemAtRow:row];
		if([obj isMemberOfClass:[Cluster class]]) {
			Cluster* cluster = (Cluster*)obj;
			[m_windowRegistry showClusterIMWindowOrTab:cluster mainWindow:self];
		} else if(![obj isMemberOfClass:[User class]]) {
			if([m_clusterOutline isItemExpanded:obj])
				[m_clusterOutline collapseItem:obj];
			else
				[m_clusterOutline expandItem:obj];
		}
	} else if(sender == m_recentTable) {
		int row = [m_recentTable selectedRow];
		if(row == -1)
			return;
		id obj = [m_recentDataSource tableView:m_recentTable
					 objectValueForTableColumn:[m_recentTable tableColumnWithIdentifier:@"0"]
										   row:row];
		if([obj isMemberOfClass:[User class]])
			[m_windowRegistry showNormalIMWindowOrTab:(User*)obj mainWindow:self];
		else if([obj isMemberOfClass:[Cluster class]])
			[m_windowRegistry showClusterIMWindowOrTab:(Cluster*)obj mainWindow:self];
		else if([obj isMemberOfClass:[Mobile class]])
			[m_windowRegistry showMobileIMWindowOrTabByMobile:(Mobile*)obj mainWindow:self];
	} else if(sender == m_mobileTable) {
		int row = [m_mobileTable selectedRow];
		if(row == -1)
			return;
		[self onSendSMSToMobile:m_mobileTable];
	}
}

- (IBAction)onApplyForAllClusters:(id)sender {
	[sender setState:(![sender state])];
	
	if([sender state] == NSOnState) {
		// get selected cluster or parent cluster
		int selectedRow = [m_clusterOutline selectedRow];
		id object = selectedRow == -1 ? nil : [m_clusterOutline itemAtRow:selectedRow];
		
		Cluster* cluster = nil;
		if([object isMemberOfClass:[Cluster class]])
			cluster = (Cluster*)object;
		else
			cluster = [self parentClusterOf:object];
		
		char setting = [cluster messageSetting];
		NSEnumerator* e = [[m_groupManager allClusters] objectEnumerator];
		while(Cluster* cluster = [e nextObject]) {
			[cluster setMessageSetting:setting];
		}
	}
}

- (IBAction)onClusterMessageSetting:(id)sender {
	// get selected cluster or parent cluster
	int selectedRow = [m_clusterOutline selectedRow];
	id object = selectedRow == -1 ? nil : [m_clusterOutline itemAtRow:selectedRow];
	
	Cluster* cluster = nil;
	if([object isMemberOfClass:[Cluster class]])
		cluster = (Cluster*)object;
	else
		cluster = [self parentClusterOf:object];
	
	// change setting
	char newSetting = 0;
	switch([sender tag]) {
		case _kMenuItemMessageSettingAccept:
			newSetting = kQQClusterMessageAccept;
			break;
		case _kMenuItemMessageSettingAcceptNoPrompt:
			newSetting = kQQClusterMessageAcceptNoPrompt;
			break;
		case _kMenuItemMessageSettingAutoEject:
			newSetting = kQQClusterMessageAutoEject;
			break;
		case _kMenuItemMessageSettingBlock:
			newSetting = kQQClusterMessageBlock;
			break;
		case _kMenuItemMessageSettingDisplayCount:
			newSetting = kQQClusterMessageDisplayCount;
			break;
	}
	
	// check apply for all state
	NSMenuItem* item = [m_messageSettingMenu itemWithTag:_kMenuItemApplyForAllClusters];
	if([item state] == NSOnState) {	
		NSEnumerator* e = [[m_groupManager allClusters] objectEnumerator];
		while(Cluster* c = [e nextObject]) 
			[self changeClusterMessageSetting:c newMessageSetting:newSetting];
	} else
		[self changeClusterMessageSetting:cluster newMessageSetting:newSetting];
	
	// because we save message setting in groups.plist, so we set dirty flag in group manager
	[m_groupManager setDirty:YES];
	
	// refresh dock icon
	[self refreshDockIcon];
}

- (IBAction)onExtractMessage:(id)sender {
	if(!m_enableHotKey)
		return;
	
	BOOL bExtracted = NO;
	NSArray* mainWindows = [WindowRegistry mainWindowArray];
	int count = [mainWindows count];
	MainWindowController* main = nil;
	for(int i = -1; i < count; i++) {
		// if extracted, refresh dock icon of that main window
		// but we need refresh it again if the dest main window isn't me, to reflect correct
		// info in dock icon of mine
		if(bExtracted) {
			[main refreshDockIcon];
			if(main != self)
				[self refreshDockIcon];
			break;
		}
			
		// get main window controller, first we check ourselves, them others
		if(i == -1)
			main = self;
		else {
			main = [mainWindows objectAtIndex:i];
			if(main == self)
				continue;
		}			
		
		// get message
		while([[main messageQueue] pendingMessageCount] > 0 && !bExtracted) {
			InPacket* packet = [[main messageQueue] getMessage:NO];
			if([packet isMemberOfClass:[ReceivedIMPacket class]]) {
				ReceivedIMPacketHeader* header = [(ReceivedIMPacket*)packet imHeader];
				switch([header type]) {
					case kQQIMTypeFriend:
					case kQQIMTypeFriendEx:
					case kQQIMTypeStranger:
					case kQQIMTypeStrangerEx:
						User* user = [[main groupManager] user:[header sender]];
						if(user) {
							// open message window
							NSWindowController* winController = [m_windowRegistry showNormalIMWindowOrTab:user mainWindow:main];
							
							// activate im window
							[NSApp activateIgnoringOtherApps:YES];
							[[winController window] orderFront:main];
							[[winController window] makeKeyWindow];	
							
							bExtracted = YES;
						}
						break;
					case kQQIMTypeTempSession:
						user = [[main groupManager] user:[header sender]];
						if(user) {
							// open message window
							NSWindowController* winController = [m_windowRegistry showTempSessionIMWindowOrTab:user mainWindow:main];
							
							// activate im window
							[NSApp activateIgnoringOtherApps:YES];
							[[winController window] orderFront:main];
							[[winController window] makeKeyWindow];	
							
							bExtracted = YES;
						}
						break;
					case kQQIMTypeMobileQQ:
						user = [[main groupManager] user:[header sender]];
						if(user) {
							// open message window
							NSWindowController* winController = [m_windowRegistry showMobileIMWindowOrTab:user mainWindow:main];
							
							// activate im window
							[NSApp activateIgnoringOtherApps:YES];
							[[winController window] orderFront:main];
							[[winController window] makeKeyWindow];	
							
							bExtracted = YES;
						}
						break;
					case kQQIMTypeMobileQQ2:
						MobileIM* mobileIM = [(ReceivedIMPacket*)packet mobileIM];
						Mobile* mobile = [[main groupManager] mobile:[mobileIM mobile]];
						if(mobile) {
							// open message window
							NSWindowController* winController = [m_windowRegistry showMobileIMWindowOrTabByMobile:mobile mainWindow:main];
							
							// activate im window
							[NSApp activateIgnoringOtherApps:YES];
							[[winController window] orderFront:main];
							[[winController window] makeKeyWindow];	
							
							bExtracted = YES;
						}
						break;
					case kQQIMTypeCluster:
					case kQQIMTypeTempCluster:
					case kQQIMTypeClusterUnknown:						
						// open message window
						Cluster* cluster = [[main groupManager] cluster:[header sender]];
						if(cluster) {
							NSWindowController* winController = [m_windowRegistry showClusterIMWindowOrTab:cluster mainWindow:main];
							
							// activate im window
							[NSApp activateIgnoringOtherApps:YES];
							[[winController window] orderFront:main];
							[[winController window] makeKeyWindow];
							
							bExtracted = YES;
						} 
						break;
					case kQQIMTypeRequestJoinCluster:
					case kQQIMTypeApprovedJoinCluster:
					case kQQIMTypeRejectedJoinCluster:
					case kQQIMTypeClusterCreated:
					case kQQIMTypeClusterRoleChanged:
					case kQQIMTypeJoinedCluster:
					case kQQIMTypeExitedCluster:
						[[main messageQueue] getMessage:YES];
						NSWindowController* caw = [[main windowRegistry] showClusterAuthWindow:packet mainWindow:main];
						
						// activate im window
						[NSApp activateIgnoringOtherApps:YES];
						[[caw window] orderFront:main];
						[[caw window] makeKeyWindow];
						bExtracted = YES;
						break;
					default:
						// no one will accept this message, remove it
						[[main messageQueue] getMessage:YES];
						break;
				}
			} else if([packet isMemberOfClass:[SystemNotificationPacket class]]) {
				[[main messageQueue] getMessage:YES];
				NSWindowController* uaw = [[main windowRegistry] showUserAuthWindow:packet mainWindow:main];
				
				// activate im window
				[NSApp activateIgnoringOtherApps:YES];
				[[uaw window] orderFront:main];
				[[uaw window] makeKeyWindow];
				bExtracted = YES;
			}
		} // while
	} // for
	
	// finally, if no message extracted, show me
	if(!bExtracted) {
		// no message now, make main window front
		// if I am not key window, active me
		// if I am, active others
		if([[self window] isKeyWindow]) {
			NSEnumerator* e = [WindowRegistry mainWindowEnumerator];
			while(MainWindowController* main = [e nextObject]) {
				if(main != self && ![main autoHided]) {
					[[main window] orderFront:self];
					[[main window] makeKeyWindow];
					break;
				}
			}
		} else {
			[NSApp activateIgnoringOtherApps:YES];
			if(!m_autoHided) {
				[[self window] orderFront:self];
				[[self window] makeKeyWindow];
			}
		}
	} 
}

- (IBAction)onPreference:(id)sender {
	[WindowRegistry showPreferenceWindow:self];
}

- (IBAction)onRemoveFromRecentContact:(id)sender {
	int row = [m_recentTable selectedRow];
	if(row == -1)
		return;
	
	[m_groupManager removeRecentContactAtIndex:row];
	[m_recentTable reloadData];
}

- (IBAction)onClearAllRecentContacts:(id)sender {
	[m_groupManager removeAllRecentContacts];
	[m_recentTable reloadData];
}

- (IBAction)onOpenFaceManager:(id)sender {
	[m_windowRegistry showFaceManagerWindow:[m_me QQ] mainWindow:self];
}

- (IBAction)onSystemMessageList:(id)sender {
	if([m_messageQueue systemMessageCount] > 0) {
		[m_messageQueue moveNextSystemMessageToFirst];
		[self onExtractMessage:self];
	} else
		[WindowRegistry showSystemMessageWindow:self];
}

- (IBAction)onNewGroup:(id)sender {
	m_sheetType = _kSheetInputNewGroup;
	[m_txtInputTitle setStringValue:L(@"LQHintInputGroupName", @"MainWindow")];
	[m_txtInput setStringValue:kStringEmpty];
	[NSApp beginSheet:m_inputWindow
	   modalForWindow:[self window]
		modalDelegate:self
	   didEndSelector:@selector(inputSheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
}

- (IBAction)onRenameGroup:(id)sender {
	Group* group = [m_userOutline itemAtRow:[m_userOutline selectedRow]];
	int index = [m_groupManager indexOfGroup:group];
	if(index == 0) {
		[AlertTool showWarning:[self window] message:L(@"LQWarningCantRenameDefaultFriendlyGroup", @"MainWindow")];
	} else if(![group isFriendly]) {
		[AlertTool showWarning:[self window] message:L(@"LQWarningCantRenameUnfriendlyGroup", @"MainWindow")];
	} else {
		m_sheetType = _kSheetInputRenameGroup;
		[m_txtInputTitle setStringValue:L(@"LQHintInputGroupName", @"MainWindow")];
		[m_txtInput setStringValue:kStringEmpty];
		[NSApp beginSheet:m_inputWindow
		   modalForWindow:[self window]
			modalDelegate:self
		   didEndSelector:@selector(inputSheetDidEnd:returnCode:contextInfo:)
			  contextInfo:nil];
	}
}

- (IBAction)onDeleteGroup:(id)sender {
	Group* group = [m_userOutline itemAtRow:[m_userOutline selectedRow]];
	if(![group isFriendly]) {
		[AlertTool showWarning:[self window]
					   message:L(@"LQWarningCantDeleteUnfriendlyGroup", @"MainWindow")];
	} else if([m_groupManager indexOfGroup:group] == 0) {
		[AlertTool showWarning:[self window]
					   message:L(@"LQWarningCantDeleteDefaultFriendlyGroup", @"MainWindow")];
	} else if([group userCount] == 0) {
		[m_groupManager removeGroup:group];
		[m_userOutline reloadData];
	} else {
		[self showGroupSelectWindow];
	}
}

- (IBAction)onLogoutAndClose:(id)sender {
	m_ignoreHideOnClose = YES;
	if([self windowShouldClose:self])
		[self close];
}

- (IBAction)onGroupSelectOK:(id)sender {
	m_moveFriendsInDeleteGroupTo = [m_cbGroup indexOfSelectedItem];
	[NSApp endSheet:m_groupSelectWindow returnCode:YES];
	[m_groupSelectWindow orderOut:self];
}

- (IBAction)onGroupSelectCancel:(id)sender {
	[NSApp endSheet:m_groupSelectWindow returnCode:NO];
	[m_groupSelectWindow orderOut:self];
}

- (IBAction)onModifyNickFont:(id)sender {
	m_modifyFont = _kFontNick;
	
	NSFontManager* fm = [NSFontManager sharedFontManager];
	[fm setDelegate:self];
	[fm setAction:@selector(onFontChanged:)];
	[fm setSelectedFont:[FontTool nickFontWithPreference:[m_me QQ]] isMultiple:NO];
	[fm orderFrontFontPanel:self];
}

- (IBAction)onModifySignatureFont:(id)sender {
	m_modifyFont = _kFontSignature;
	
	NSFontManager* fm = [NSFontManager sharedFontManager];
	[fm setDelegate:self];
	[fm setAction:@selector(onFontChanged:)];
	[fm setSelectedFont:[FontTool signatureFontWithPreference:[m_me QQ]] isMultiple:NO];
	[fm orderFrontFontPanel:self];
}

- (IBAction)onFontChanged:(id)sender {	
	if(m_modifyFont == -1)
		return;
	
	// get font
	NSFont* font = [NSFont fontWithName:@"Helvetica" size:[NSFont systemFontSize]];
	
	// get new font
	font = [[sender fontPanel:NO] panelConvertFont:font];
	
	// get font trait mask
	NSFontTraitMask mask = [sender traitsOfFont:font];
	
	// save font info to preference
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	switch(m_modifyFont) {
		case _kFontNick:
			[cache setNickFontName:[font familyName]];
			[cache setNickFontSize:[font pointSize]];
			[cache setNickFontStyleBold:((mask & NSBoldFontMask) != 0)];
			[cache setNickFontStyleItalic:((mask & NSItalicFontMask) != 0)];
			break;
		case _kFontSignature:
			[cache setSignatureFontName:[font familyName]];
			[cache setSignatureFontSize:[font pointSize]];
			[cache setSignatureFontStyleBold:((mask & NSBoldFontMask) != 0)];
			[cache setSignatureFontStyleItalic:((mask & NSItalicFontMask) != 0)];
			break;
	}
	
	// reload to reflect the change
	[m_userOutline reloadData];
	[m_clusterOutline reloadData];
	[m_recentTable reloadData];	
	[m_mobileTable reloadData];
}

- (IBAction)onOutlineBackgroundColorWell:(id)sender {
	m_modifyColor = _kColorOutlineBackground;
	
	NSColorPanel* panel = [NSColorPanel sharedColorPanel];
	[panel setTarget:self];
	[panel setAction:@selector(onColorChanged:)];
	[panel orderFront:self];
}

- (IBAction)onNickFontColorWell:(id)sender {
	m_modifyColor = _kColorNickFont;
	
	NSColorPanel* panel = [NSColorPanel sharedColorPanel];
	[panel setTarget:self];
	[panel setAction:@selector(onColorChanged:)];
	[panel orderFront:self];
}

- (IBAction)onSignatureFontColorWell:(id)sender {
	m_modifyColor = _kColorSignatureFont;
	
	NSColorPanel* panel = [NSColorPanel sharedColorPanel];
	[panel setTarget:self];
	[panel setAction:@selector(onColorChanged:)];
	[panel orderFront:self];
}

- (IBAction)onColorChanged:(id)sender {
	if(m_modifyColor == -1)
		return;
	
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	switch(m_modifyColor) {
		case _kColorOutlineBackground:
			[cache setBackground:[m_outlineBackgroundColorWell color]];
			[m_userOutline setBackgroundColor:[cache background]];
			[m_clusterOutline setBackgroundColor:[cache background]];
			[m_recentTable setBackgroundColor:[cache background]];
			[m_mobileTable setBackgroundColor:[cache background]];
			break;
		case _kColorNickFont:
			[cache setNickFontColor:[m_outlineDefaultFontColorWell color]];
			[m_userOutline reloadData];
			[m_clusterOutline reloadData];
			[m_recentTable reloadData];
			[m_mobileTable reloadData];
			break;
		case _kColorSignatureFont:
			[cache setSignatureFontColor:[m_signatureFontColorWell color]];
			[m_userOutline reloadData];
			[m_clusterOutline reloadData];
			[m_recentTable reloadData];
			[m_mobileTable reloadData];
			break;
	}
}

- (IBAction)onNewMobile:(id)sender {
	m_sheetType = _kSheetNewMobile;
	[m_txtMobileName setStringValue:kStringEmpty];
	[m_txtMobileNumber setStringValue:kStringEmpty];
	[NSApp beginSheet:m_mobileInfoWindow
	   modalForWindow:[self window]
		modalDelegate:self
	   didEndSelector:@selector(inputSheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
}

- (IBAction)onModifyMobile:(id)sender {
	int row = [m_mobileTable selectedRow];
	if(row != -1) {
		Mobile* m = [m_groupManager mobileAtIndex:row];
		if(m) {
			m_sheetType = _kSheetModifyMobile;
			[m_txtMobileName setStringValue:[m name]];
			[m_txtMobileNumber setStringValue:[m mobile]];
			[NSApp beginSheet:m_mobileInfoWindow
			   modalForWindow:[self window]
				modalDelegate:self
			   didEndSelector:@selector(inputSheetDidEnd:returnCode:contextInfo:)
				  contextInfo:nil];
		}
	}
}

- (IBAction)onDeleteMobile:(id)sender {
	int row = [m_mobileTable selectedRow];
	Mobile* mobile = [m_groupManager mobileAtIndex:row];
	if(mobile) {
		[m_groupManager removeMobile:mobile];
		[m_mobileTable reloadData];
	}
}

- (IBAction)onMobileInfoOK:(id)sender {
	[NSApp endSheet:m_mobileInfoWindow returnCode:YES];
	[m_mobileInfoWindow orderOut:self];
}

- (IBAction)onMobileInfoCancel:(id)sender {
	[NSApp endSheet:m_mobileInfoWindow returnCode:NO];
	[m_mobileInfoWindow orderOut:self];
}

- (IBAction)onSendSMSToQQ:(id)sender {
	User* user = [m_userOutline itemAtRow:[m_userOutline selectedRow]];
	if(user) {
		[m_windowRegistry showMobileIMWindowOrTab:user mainWindow:self];
	}
}

- (IBAction)onSendSMSToMobile:(id)sender {
	int row = [m_mobileTable selectedRow];
	Mobile* mobile = [m_groupManager mobileAtIndex:row];
	if(mobile) {
		[m_windowRegistry showMobileIMWindowOrTabByMobile:mobile mainWindow:self];
	}
}

- (IBAction)onRestoreFromAutoHide:(id)sender {
	if(m_sideWindow) {
		// clear flag
		m_autoHided = NO;
		
		// show main window, forbid autoresizing
		NSRect frame = [[self window] frame];
		[[[self window] contentView] setAutoresizesSubviews:NO];
		[[self window] setFrame:[m_sideWindow frame] display:NO];
		[[self window] setAlphaValue:0.0];
		[[self window] orderFront:self];
		
		// begin animation
		m_animationType = _kAnimationRestoreFromAutoHide;
		[AnimationHelper moveWindow:[self window]
							   from:[m_sideWindow frame]
								 to:frame
							 fadeIn:nil
							fadeOut:m_sideWindow
						   delegate:self];
	}
}

- (IBAction)onScreenscrap:(id)sender {
	ScreenscrapHelper* helper = [ScreenscrapHelper sharedHelper];
	[helper beginScreenscrap];
}

- (IBAction)onQBarPluginOK:(id)sender {
	[NSApp endSheet:m_winQBarPlugins
		 returnCode:YES];
	[m_winQBarPlugins orderOut:self];
}

- (IBAction)onQBarPluginCancel:(id)sender {
	[NSApp endSheet:m_winQBarPlugins
		 returnCode:NO];
	[m_winQBarPlugins orderOut:self];
}

#pragma mark -
#pragma mark helpers

- (BOOL)validateMenuItem:(id <NSMenuItem>)menuItem {
	if([NSStringFromSelector([menuItem action]) isEqualToString:@"performClose:"]) {
		PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
		if([cache hideOnClose])
			[menuItem setTitle:L(@"LQHide")];
		else
			[menuItem setTitle:L(@"LQClose")];
		return YES;
	} else
		return YES;
}

- (void)changeClusterMessageSetting:(Cluster*)cluster newMessageSetting:(char)newSetting {
	// if same, return
	if([cluster messageSetting] == newSetting)
		return;
	
	// include
	[m_messageQueue restoreClusterInUnread:[cluster internalId]];
	
	// change setting
	[cluster setMessageSetting:newSetting];
	switch(newSetting) {
		case kQQClusterMessageAccept:
			if([cluster messageCount] > 0)
				[[TimerTaskManager sharedManager] addTask:[ModelEffectTask taskWithMainWindow:self object:cluster]];
			break;
		case kQQClusterMessageAutoEject:
		case kQQClusterMessageBlock:
			[[TimerTaskManager sharedManager] removeTasks:cluster];
			break;
		case kQQClusterMessageDisplayCount:
		case kQQClusterMessageAcceptNoPrompt:
			[m_messageQueue setExcludeClusterInUnread:[cluster internalId]];
			[[TimerTaskManager sharedManager] removeTasks:cluster];
			[m_clusterOutline reloadItem:cluster];
			break;
	}
}

- (void)saveImportantInfo {
	// get system perference
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	
	// only save these when current tab item is Main item
	if([[[m_tabMain selectedTabViewItem] label] isEqualToString:_kTabViewItemMain]) {
		// save frame, include toolbar size
		[cache setWnidowFrame:[[self window] frame]];
		
		// save toolbar visible state
		[cache setHideToolbar:![m_toolbar isVisible]];
	}

	// save frame
	[cache sync];
	
	// save group
	[m_groupManager saveGroups];
	
	// save face
	[m_faceManager save];
	
	// save history
	[m_historyManager save];
}

- (void)refreshDockIcon {
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	NSImage* icon = [ImageTool iconWithMessageCount:[m_me isMM]
											 status:[m_me status]
											 unread:[LumaQQApplication pendingMessageCount]
										 showUnread:[cache displayUnreadCountOnDock]
										 hasMessage:([m_messageQueue pendingMessageCount] > 0)];
	[NSApp setApplicationIconImage:icon];
	if(m_autoHided) {
		icon = [ImageTool iconWithMessageCount:[m_me isMM]
										status:[m_me status]
										unread:[m_messageQueue pendingMessageCount]
									showUnread:[cache displayUnreadCountOnDock]
									hasMessage:([m_messageQueue pendingMessageCount] > 0)];
		[m_ivSide setImage:icon];
	}
}

- (BOOL)registerExtractMessageHotKey {
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	HotKey* hotKey = [HotKey hotKeyWithOwner:[m_me QQ]
								   string:[cache extractMessageHotKey]
								   target:self
								   action:@selector(onExtractMessage:)];
	return [[HotKeyManager sharedHotKeyManager] registerHotKey:hotKey];
}

- (BOOL)registerScreenscrapHotKey {
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	HotKey* hotKey = [HotKey hotKeyWithOwner:[m_me QQ]
									  string:[cache screenscrapHotKey]
									  target:self
									  action:@selector(onScreenscrap:)];
	return [[HotKeyManager sharedHotKeyManager] registerHotKey:hotKey];
}

- (void)removeUserFromOutline:(User*)user {
	Group* g = [m_groupManager group:[user groupIndex]];
	if([m_groupManager removeUser:user] && g) {
		[m_userOutline reloadItem:g reloadChildren:YES];
	}
}

- (void)restoreLastFrameOrigin {
	// load file
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	
	NSRect frame = [cache windowFrame];
	if(frame.origin.x != 0)
		[[self window] setFrameTopLeftPoint:NSMakePoint(frame.origin.x, frame.origin.y + frame.size.height)];
}

- (void)restoreLastFrame {
	// load file
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	
	NSRect frame = [cache windowFrame];
	if(frame.origin.x != 0)
		[[self window] setFrame:frame display:YES];
}

- (void)shutdownNetwork {	
	// play sound
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	if([cache isEnableSound])
		[[SoundHelper shared] playSound:kLQSoundLogout QQ:[m_me QQ]];
	
	// growl
	if([[m_client user] logged])
		[[GrowlApplicationBridge growlDelegate] logout:m_me];
	
	// logout
	[m_client logout];
	
	// shutdown network
	[m_client shutdownNetworkLayer];
}

- (void)restartNetwork {
	// show window, start animate, set hint
	[m_tabMain selectTabViewItemAtIndex:0];
	[self setToolbarVisibility:NO];
	[[self window] setShowsToolbarButton:NO];
	[[self window] setTitle:[NSString stringWithFormat:@"%d", [m_me QQ]]];
	[m_piLogin startAnimation:self];
	[m_txtHint setStringValue:L(@"LQHintInitialize", @"MainWindow")];
	
	// create qq client object
	if(m_client) {
		[m_client release];
		[m_client dealloc];
		m_client = nil;
	}
	m_client = [[QQClient alloc] initWithConnection:m_connection];
	[m_client setDelegate:self];
	
	// add self as a qq listener
	[m_client addQQListener:m_mainQQListener];
	
	// create qq user
	QQUser* user = [[QQUser alloc] initWithQQ:[m_me QQ] passwordKey:m_password passwordMd5:m_passwordMd5];
	[user setLoginStatus:m_loginStatus];
	[m_client setQQUser:user];
	[user release];
	
	// re-activate qbar plugin because we created a new qq client
	id<QBarPlugin> plugin = [m_qbarView plugin];
	if(plugin)
		[plugin pluginReactivated];
	
	// start network layer
	[m_client startNetworkLayer];
}

- (void)returnToLogin {	
	// reset control status
	[m_piLogin stopAnimation:self];
	
	// close main window, reopen login window
	[self close];
	LoginWindowController* loginWindowController = [[LoginWindowController alloc] init];
	[loginWindowController showWindow:self];
	[[loginWindowController window] center];
}

- (void)refreshStatusUI {
	[m_me setStatus:[[m_client user] status]];
	[(HeadControl*)[m_headItem view] setObjectValue:m_me];
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	[(HeadControl*)[m_headItem view] setToolTip:[cache statusMessage]];
	[self refreshDockIcon];
}

- (void)initializeMainPane {
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	[self setToolbarVisibility:![cache hideToolbar]];
	
	// initialize outline view
	[m_userOutline setDataSource:m_userDataSource];
	[m_userOutline setDelegate:m_userDataSource];
	[m_groupManager sortAll];
	[m_userOutline reloadData];
	[m_clusterOutline setDataSource:m_clusterDataSource];
	[m_clusterOutline setDelegate:m_clusterDataSource];
	[m_clusterOutline reloadData];
	
	// restore expand status
	NSArray* groups = [m_groupManager allUserGroups];
	NSEnumerator* e = [groups objectEnumerator];
	while(Group* g = [e nextObject]) {
		if([g expanded])
			[m_userOutline expandItem:g];
	}
	
	// set flag
	m_UIInitialized = YES;
}

// must be called after loadGroups or GetFriendGroup finished
- (void)refreshClusters:(NSArray*)clusters {	
	// get message setting of all cluster
	[m_client getMessageSetting:[m_groupManager allClusterInternalIds]];
	
	// get cluster info
	NSEnumerator* e = [clusters objectEnumerator];
	while(Cluster* c = [e nextObject]) {
		if([c externalId] == 0) {
			// zero means this cluster's info is not present
			[m_client getClusterInfo:[c internalId]];
		} 
	}
}

- (void)reloadUsers {
	[m_userOutline reloadData];
}

- (void)reloadClusters {
	[m_clusterOutline reloadData];
}

- (void)reloadRecent {
	[m_recentTable reloadData];
}

- (void)addRequestBlockingEntry:(UInt32)QQ {
	[m_requestBlockingCache addObject:[NSNumber numberWithUnsignedInt:QQ]];
}

- (BOOL)shouldBlockRequest:(UInt32)QQ {
	return [m_requestBlockingCache containsObject:[NSNumber numberWithUnsignedInt:QQ]];
}

- (void)addAddFriendGroupMapping:(UInt32)QQ groupIndex:(int)groupIndex {
	[m_addFriendGroupMapping setObject:[NSNumber numberWithInt:groupIndex] forKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (Group*)destinationGroupAddedTo:(UInt32)QQ {
	NSNumber* key = [NSNumber numberWithUnsignedInt:QQ];
	NSNumber* index = [m_addFriendGroupMapping objectForKey:key];
	[m_addFriendGroupMapping removeObjectForKey:key];
	Group* group = [m_groupManager group:[index intValue]];
	if(group == nil || ![group isFriendly])
		return [m_groupManager group:0];
	else
		return group;
}

- (int)destinationGroupIndexAddedTo:(UInt32)QQ {
	NSNumber* key = [NSNumber numberWithUnsignedInt:QQ];
	NSNumber* index = [m_addFriendGroupMapping objectForKey:key];
	[m_addFriendGroupMapping removeObjectForKey:key];
	if(index)
		return [index intValue];
	else
		return kGroupIndexUndefined;
}

- (void)addFriend:(UInt32)QQ {
	// add user in my friend list, first we check add cache to decide which group
	User* user = [m_groupManager user:QQ];
	if(user == nil) {
		user = [[User alloc] initWithQQ:QQ domain:self];
		Group* group = [self destinationGroupAddedTo:[user QQ]];
		[m_groupManager addUser:user group:group];
		[m_userOutline reloadItem:group reloadChildren:YES];
		[m_client getUserInfo:[user QQ]];
		[m_client getSignatureByQQ:[user QQ]];
		[user release];
	} else if(![m_groupManager isUserFriendly:user]) {
		int oldGroupIndex = [m_groupManager moveUser:user toGroupIndex:[self destinationGroupIndexAddedTo:[user QQ]]];
		Group* oldGroup = [m_groupManager group:oldGroupIndex];
		if(oldGroup)
			[m_userOutline reloadItem:oldGroup reloadChildren:YES];
		Group* newGroup = [m_groupManager group:[user groupIndex]];
		if(newGroup)
			[m_userOutline reloadItem:newGroup reloadChildren:YES];
		[m_client getUserInfo:[user QQ]];
		[m_client getSignatureByQQ:[user QQ]];
	}
}

- (void)moveUser:(UInt32)QQ toGroup:(Group*)group reload:(BOOL)reload {
	// get user
	User* user = [m_groupManager user:QQ];
	if(user == nil)
		return;
	
	// get source group
	Group* srcGroup = [m_groupManager group:[user groupIndex]];
	if(srcGroup == nil)
		return;
	
	// check user group
	if(![srcGroup isUser] || ![group isUser])
		return;
	
	// check src and dest group, decide what to do
	if([srcGroup isFriendly]) {
		if([group isFriendly])
			[m_groupManager moveUser:user toGroup:group];
		else if([group isStranger]) {
			[m_removeFriendGroupMapping setObject:[NSNumber numberWithInt:[m_groupManager indexOfGroup:group]] forKey:[NSNumber numberWithUnsignedInt:[user QQ]]];
			[self deleteUser:user];
		} else if([group isBlacklist]) {
			[m_removeFriendGroupMapping setObject:[NSNumber numberWithInt:[m_groupManager indexOfGroup:group]] forKey:[NSNumber numberWithUnsignedInt:[user QQ]]];
			[self moveUserToBlacklist:user];
		}
	} else if([srcGroup isStranger]) {
		if([group isFriendly]) {
			AddFriendWindowController* afw = [m_windowRegistry showAddFriendWindow:[user QQ] mainWindow:self];
			[afw setDestinationGroupIndex:[m_groupManager indexOfGroup:group]];
			[afw onOK:self];
		} else if([group isStranger])
			[m_groupManager moveUser:user toGroup:group];
		else if([group isBlacklist]) {
			[m_removeFriendGroupMapping setObject:[NSNumber numberWithInt:[m_groupManager blacklistGroupIndex]] forKey:[NSNumber numberWithUnsignedInt:[user QQ]]];
			[self moveUserToBlacklist:user];
		}
	} else if([srcGroup isBlacklist]) {
		if([group isFriendly]) {
			AddFriendWindowController* afw = [m_windowRegistry showAddFriendWindow:[user QQ] mainWindow:self];
			[afw setDestinationGroupIndex:[m_groupManager indexOfGroup:group]];
			[afw onOK:self];
		} else if([group isStranger])
			[m_groupManager moveUser:user toGroup:group];
		else if([group isBlacklist])
			[m_groupManager moveUser:user toGroup:group];
	}
		
	// reload
	if(reload) {
		[m_userOutline reloadItem:srcGroup reloadChildren:YES];
		[m_userOutline reloadItem:group reloadChildren:YES];
	}
}

- (void)deleteUser:(User*)user {
	if([m_groupManager isUserFriendly:user]) {
		[m_windowRegistry showDeleteUserWindow:user
									mainWindow:self];	
	} else {
		[self removeUserFromOutline:user];
	}
}

- (void)moveUserToBlacklist:(User*)user {
	if(![m_groupManager isUserBlacklist:user]) {
		m_userToBeDeleted = user;
		[AlertTool showConfirm:[self window]
					   message:L(@"LQWarningMoveToBlacklistConfirm", @"MainWindow")
				 defaultButton:L(@"LQNo")
			   alternateButton:L(@"LQYes")
					  delegate:self
				didEndSelector:@selector(moveToBlacklistAlertDidEnd:returnCode:contextInfo:)];
	}
}

- (BOOL)needUploadFriendGroup {
	return [m_groupManager dirty] && [[PreferenceCache cache:[m_me QQ]] uploadFriendGroupMode] != kLQUploadNever;
}

- (void)showProgressWindow:(BOOL)show {
	if(show) {
		[NSApp beginSheet:m_progressWindow
		   modalForWindow:[self window]
			modalDelegate:self
		   didEndSelector:nil
			  contextInfo:nil];
		[m_txtProgressHint setStringValue:kStringEmpty];
		[m_progressBar startAnimation:self];
	} else {
		m_sheetType = _kSheetUploadFriendGroup;
		[m_progressBar stopAnimation:self];
		[NSApp endSheet:m_progressWindow];
		[m_progressWindow orderOut:self];
	}
}

- (void)showGroupSelectWindow {
	[NSApp beginSheet:m_groupSelectWindow
	   modalForWindow:[self window]
		modalDelegate:self
	   didEndSelector:@selector(deleteGroupAlertDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
	[m_cbGroup reloadData];
	[m_cbGroup selectItemAtIndex:0];
}

- (void)setProgressWindowHint:(NSString*)hint {
	[m_txtProgressHint setStringValue:hint];
}

- (void)handleUserDidRemovedNotification:(NSNotification*)notification {
	if([[notification userInfo] objectForKey:kUserInfoDomain] == self) {
		// get user and group object
		User* user = [notification object];
		Group* group = [[notification userInfo] objectForKey:kUserInfoFromGroup];
		if(user == nil || group == nil)
			return;
		
		// stop message blinking
		if([user messageCount] + [user mobileMessageCount] + [user tempSessionMessageCount] > 0) {
			[group setMessageCount:([group messageCount] - [user messageCount] - [user mobileMessageCount] - [user tempSessionMessageCount])];
			[user setMessageCount:0];
			[user setMobileMessageCount:0];
			[user setTempSessionMessageCount:0];
			[[TimerTaskManager sharedManager] removeTasks:user];
			if([group messageCount] == 0)
				[[TimerTaskManager sharedManager] removeTasks:group];
		}
		
		// clear user message from message queue
		[m_messageQueue removeMessageFromUser:[user QQ]];
		[self refreshDockIcon];
	}
}

- (void)handleUserDidMovedNotification:(NSNotification*)notification {
	if([[notification userInfo] objectForKey:kUserInfoDomain] == self) {
		// get user and group object
		User* user = [notification object];
		Group* fromGroup = [[notification userInfo] objectForKey:kUserInfoFromGroup];
		Group* toGroup = [[notification userInfo] objectForKey:kUserInfoToGroup];
		if(user == nil || fromGroup == nil || toGroup == nil)
			return;
		
		// stop message blinking
		if([user messageCount] + [user mobileMessageCount] + [user tempSessionMessageCount] > 0) {
			int oldCount = [toGroup messageCount];
			[fromGroup setMessageCount:([fromGroup messageCount] - [user messageCount] - [user mobileMessageCount] - [user tempSessionMessageCount])];
			[toGroup setMessageCount:([toGroup messageCount] + [user messageCount] + [user mobileMessageCount] + [user tempSessionMessageCount])];
			if([fromGroup messageCount] == 0)
				[[TimerTaskManager sharedManager] removeTasks:fromGroup];
			if(oldCount == 0)
				[[TimerTaskManager sharedManager] addTask:[ModelEffectTask taskWithMainWindow:self object:toGroup]];
		}
	}
}

- (Cluster*)parentClusterOf:(id)item {
	id parent = [m_clusterDataSource outlineView:m_clusterOutline parentOfItem:item];
	while(parent && ![parent isMemberOfClass:[Cluster class]])
		parent = [m_clusterDataSource outlineView:m_clusterOutline parentOfItem:parent];
	return parent;
}

- (void)setHint:(NSString*)hint {
	[m_txtHint setStringValue:hint];
}

- (void)setToolbarVisibility:(BOOL)value {
	[m_toolbar setVisible:value];
	[[NSNotificationCenter defaultCenter] postNotificationName:kMainToolbarToggledVisibilityNotificationName
														object:[self window]];
}

#pragma mark -
#pragma mark tooltip tracker delegate

- (void)showTooltipAtPoint:(NSPoint)screenPoint {
	// get window base point
	NSPoint winPoint = [[self window] convertScreenToBase:screenPoint];

	// get current tab view item label, get object under point
	id obj = nil;
	NSString* label = [[m_tabGroup selectedTabViewItem] label];
	if([label isEqualToString:kTabViewItemFriends]) {
		NSPoint point = [m_userOutline convertPoint:winPoint fromView:nil];
		int row = [m_userOutline rowAtPoint:point];
		if(row != -1)
			obj = [m_userOutline itemAtRow:row];
	} else if([label isEqualToString:kTabViewItemClusters]) {
		NSPoint point = [m_clusterOutline convertPoint:winPoint fromView:nil];
		int row = [m_clusterOutline rowAtPoint:point];
		if(row != -1)
			obj = [m_clusterOutline itemAtRow:row];
	} else if([label isEqualToString:kTabViewItemMobiles]) {
		NSPoint point = [m_mobileTable convertPoint:winPoint fromView:nil];
		int row = [m_mobileTable rowAtPoint:point];
		if(row != -1)
			obj = [m_mobileDataSource tableView:m_mobileTable
					  objectValueForTableColumn:[[m_mobileTable tableColumns] objectAtIndex:0]
											row:row];
	} else if([label isEqualToString:kTabViewItemRecent]) {
		NSPoint point = [m_recentTable convertPoint:winPoint fromView:nil];
		int row = [m_recentTable rowAtPoint:point];
		if(row != -1)
			obj = [m_recentDataSource tableView:m_recentTable
					  objectValueForTableColumn:[[m_recentTable tableColumns] objectAtIndex:0]
											row:row];
	}

	[m_tooltipController showTooltip:obj at:screenPoint];
}

- (void)hideTooltip {
	[m_tooltipController hideTooltip];
}

#pragma mark -
#pragma mark check update delegate

- (void)downloadDidFinish:(NSURLDownload *)download {
	[m_updateChecker release];
	m_updateChecker = nil;
	
	// load update.txt
	NSString* string = [NSString stringWithContentsOfFile:kLQFileUpdate
												 encoding:NSUTF8StringEncoding
													error:nil];
	
	// get version
	NSString* version = [string substringToIndex:[kLumaQQVersionString length]];
	
	// validate
	const char* bytes = [version UTF8String];
	for(int i = 0; i < strlen(bytes); i++) {
		if(bytes[i] < '0' || bytes[i] > '9')
			return;
	}
	
	// check
	if([version compare:kLumaQQVersionString] == NSOrderedDescending) {
		NSRange range = [string rangeOfString:@"What's New:"];
		NSString* desc = range.location == NSNotFound ? @"" : [string substringFromIndex:range.location];
		NSString* message = [NSString stringWithFormat:L(@"LQWarningUpdate", @"MainWindow"), desc];
		[AlertTool showWarning:[self window]
						 title:L(@"LQAlertTitle3", @"MainWindow")
					   message:message
					  delegate:nil
				didEndSelector:nil];
	}
}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error {
	[m_updateChecker release];
	m_updateChecker = nil;
}

#pragma mark -
#pragma mark qq client delegate

- (BOOL)shouldReceiveCustomFace:(CustomFace*)face {
	if([m_faceManager hasFace:[[face filename] stringByDeletingPathExtension]])
		return NO;
	else if([m_faceManager hasReceivedFace:[face filename]])
		return NO;
	else
		return YES;
}

- (void)customFaceDidReceived:(CustomFace*)face data:(NSData*)data {
	NSString* path = [FileTool getReceivedCustomFacePath:[m_me QQ] file:[face filename]];
	[FileTool initDirectoryForFile:path];
	[data writeToFile:path atomically:YES];
	
	// trigger notification
	[[NSNotificationCenter defaultCenter] postNotificationName:kCustomFaceDidReceivedNotificationName
														object:[face filename]];
}

- (void)customFaceFailedToReceive:(CustomFace*)face {
	[[NSNotificationCenter defaultCenter] postNotificationName:kCustomFaceFailedToReceiveNotificationName
														object:[face filename]];
}

- (BOOL)shouldSendCustomFace:(CustomFace*)face {
	return YES;
}

- (BOOL)shouldShowFakeCamera {
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	return [cache showFakeCamera];
}

- (void)customFaceListFailedToSend:(CustomFaceList*)faceList errorMessage:(NSString*)errorMessage {
	[[NSNotificationCenter defaultCenter] postNotificationName:kCustomFaceListFailedToSendNotificationName
														object:faceList
													  userInfo:[NSDictionary dictionaryWithObject:errorMessage forKey:kUserInfoErrorMessage]];
}

- (void)customFaceDidSent:(CustomFace*)face {
	[[NSNotificationCenter defaultCenter] postNotificationName:kCustomFaceDidSentNotificationName
														object:face];
}

- (BOOL)shouldReceiveCustomHead:(CustomHead*)head {
	NSString* path = [FileTool getCustomHeadPath:[m_me QQ] md5:[head md5]];
	return ![FileTool isFileExist:path]; 
}

- (void)customHeadDidReceived:(CustomHead*)head data:(NSData*)data {
	// if data is nil, then the head is already get
	if(data) {
		// save to disk
		NSString* path = [FileTool getCustomHeadPath:[m_me QQ] md5:[head md5]];
		[FileTool initDirectoryForFile:path];
		[data writeToFile:path atomically:YES];
		
		// refresh UI
		User* u = [m_groupManager user:[head QQ]];
		if(u) {
			[m_userOutline reloadItem:u];	
			[m_clusterOutline reloadItem:u];
			[m_recentTable reloadData];
		}
	}
	
	// post notification
	NSDictionary* dict = (data == nil) ? [NSDictionary dictionary] : [NSDictionary dictionaryWithObject:data forKey:kUserInfoCustomHeadData];
	[[NSNotificationCenter defaultCenter] postNotificationName:kCustomHeadDidReceivedNotificationName
														object:head
													  userInfo:dict];
}

- (void)customHeadFailedToReceive:(CustomHead*)head {
	// post notification
	[[NSNotificationCenter defaultCenter] postNotificationName:kCustomHeadFailedToReceiveNotificationName
														object:head
													  userInfo:nil];
}

#pragma mark -
#pragma mark toolbar delegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
	if([itemIdentifier isEqualToString:_kToolItemHead]) {
		// create tool item
		if(!m_headItem) {
			m_headItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
			
			// create control
			HeadControl* m_headControl = [[HeadControl alloc] init];
			[m_headControl setOwner:[m_me QQ]];
			[m_headControl setObjectValue:m_me];
			[m_headControl setTarget:self];
			[m_headControl setAction:@selector(onHeadItem:)];
			
			// set control to item
			[m_headItem setView:m_headControl];
			[m_headControl release];
			
			// set size
			[m_headItem setMinSize:NSMakeSize(40, 40)];
			[m_headItem setMaxSize:NSMakeSize(40, 40)];
		}
		return m_headItem;
	} else if([itemIdentifier isEqualToString:_kToolItemQBar]) {
		// create toolbar item
		NSToolbarItem* item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
		[item setView:m_qbarView];
		[item setMinSize:NSMakeSize(20, [m_qbarView frame].size.height)];
		[item setMaxSize:NSMakeSize(1000, [m_qbarView frame].size.height)];
		
		// load QBar plugin
		PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
		id<QBarPlugin> plugin = [m_pluginManager QBarPluginWithName:[cache activeQBarName]];
		if(plugin)
			[m_qbarView setQBarPlugin:plugin];
		return item;
	} else
		return nil;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
	return [NSArray arrayWithObjects:_kToolItemHead, NSToolbarSeparatorItemIdentifier, _kToolItemQBar, nil];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
	return [NSArray arrayWithObjects:_kToolItemHead, NSToolbarSeparatorItemIdentifier, _kToolItemQBar, nil];
}

#pragma mark -
#pragma mark menu delegate

- (int)numberOfItemsInMenu:(NSMenu *)menu {
	if(menu == m_headMenu)
		return 13 + [[PreferenceCache cache:[m_me QQ]] statusHistoryCount];
	else
		return [[menu itemArray] count];
}

- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(int)index shouldCancel:(BOOL)shouldCancel {
	if(menu == m_headMenu) {
		//
		// for menu of head item
		//
		
		[item setEnabled:(!m_changingStatus)];
		
		switch(index) {
			case 0:
				[item setEnabled:m_myInfoGot];
				break;
			case 1:
				break;
			case 2:
				PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
				[item setTitle:[NSString stringWithFormat:L(@"LQMenuItemStatusMessage", @"MainWindow"), [cache statusMessage]]];
				break;
			case 3:
				cache = [PreferenceCache cache:[m_me QQ]];
				[item setEnabled:([cache statusHistoryCount] > 0)];
				break;
			case 4:	
				break;
			case 5:
				[item setState:([[m_client user] status] == kQQStatusOnline)];
				[item setImage:[NSImage imageNamed:kImageOnline]];
				break;
			case 6:
				[item setState:([[m_client user] status] == kQQStatusQMe)];
				[item setImage:[NSImage imageNamed:kImageQMe]];
				break;
			case 7:
				[item setState:([[m_client user] status] == kQQStatusAway)];
				[item setImage:[NSImage imageNamed:kImageAway]];
				break;
			case 8:
				[item setState:([[m_client user] status] == kQQStatusBusy)];
				[item setImage:[NSImage imageNamed:kImageBusy]];
				break;
			case 9:
				[item setState:([[m_client user] status] == kQQStatusMute)];
				[item setImage:[NSImage imageNamed:kImageMute]];
				break;
			case 10:
				[item setState:([[m_client user] status] == kQQStatusHidden)];
				[item setImage:[NSImage imageNamed:kImageHidden]];
				break;
			case 11:
				[item setState:([[m_client user] status] == kQQStatusOffline)];
				[item setImage:[NSImage imageNamed:kImageOffline]];
				break;
			case 12:
				[item setEnabled:YES];
				break;
			default:
				cache = [PreferenceCache cache:[m_me QQ]];
				[item setTitle:[[cache statusHistory] objectAtIndex:(index - 13)]];
				[item setTarget:self];
				[item setAction:@selector(onStatusHistory:)];
				break;
		}
	} else if(menu == m_actionMenu) {
		//
		// for action menu
		//
		
		switch([item tag]) {
			case _kMenuItemRefreshRemark:
				if([m_jobController hasJob:kJobGetFriendRemark]) {
					[item setTitle:L(@"LQMenuItemRefreshingRemark", @"MainWindow")];
					[item setEnabled:NO];
				} else {
					[item setTitle:L(@"LQMenuItemRefreshRemark", @"MainWindow")];
					[item setEnabled:YES];
				}
				break;
			case _kMenuItemRefreshSignature:
				if([m_jobController hasJob:kJobGetUserSignature]) {
					[item setTitle:L(@"LQMenuItemRefreshingSignature", @"MainWindow")];
					[item setEnabled:NO];
				} else {
					[item setTitle:L(@"LQMenuItemRefreshSignature", @"MainWindow")];
					[item setEnabled:YES];
				}
				break;
			case _kMenuItemRefreshFriendList:
				if([self isUIInitialized] && ![self isRefreshingFriendList]) {
					[item setTitle:L(@"LQMenuItemRefreshFriendList", @"MainWindow")];
					[item setEnabled:YES];
				} else {
					[item setTitle:L(@"LQMenuItemRefreshingFriendList", @"MainWindow")];
					[item setEnabled:NO];
				}
				break;
		}
	} else if(menu == [m_userOutline menu]) {
		//
		// for context menu of user outline
		//
		
		int selectedRow = [m_userOutline selectedRow];
		id object = selectedRow == -1 ? nil : [m_userOutline itemAtRow:selectedRow];
		
		if(object == nil) {
			switch([item tag]) {
				case _kMenuItemNewGroup:
				case _kMenuItemTempSessionToFriend:
					[item setEnabled:YES];
					break;
				default:
					[item setEnabled:NO];
					break;
			}
		} else if([object isMemberOfClass:[Group class]]) {
			switch([item tag]) {
				case _kMenuItemAddFriend:
				case _kMenuItemQuicklyAddFriend:
				case _kMenuItemNewGroup:
				case _kMenuItemRenameGroup:
				case _kMenuItemDeleteGroup:
				case _kMenuItemTempSessionToFriend:
					[item setEnabled:YES];
					break;
				default:
					[item setEnabled:NO];
					break;
			}
		} else if([object isMemberOfClass:[User class]]) {
			User* u = (User*)object;
			
			switch([item tag]) {
				case _kMenuItemChatWithUser:
				case _kMenuItemUserInfo:
				case _kMenuItemAddFriend:
				case _kMenuItemQuicklyAddFriend:
				case _kMenuItemdDeleteFriend:
				case _kMenuItemModifyRemarkName:
				case _kMenuItemNewGroup:
				case _kMenuItemSendSMSToQQ:
				case _kMenuItemTempSessionToFriend:
					[item setEnabled:YES];
					break;
				case _kMenuItemMoveToBlacklist:
					Group* g = [m_groupManager group:[u groupIndex]];
					if(g == nil || [g isUser] && [g isBlacklist] || ![g isUser])
						[item setEnabled:NO];
					else
						[item setEnabled:YES];
					break;
				default:
					[item setEnabled:NO];
					break;
			}
		}
	} else if(menu == m_messageSettingMenu) {
		// get selected cluster or parent cluster
		int selectedRow = [m_clusterOutline selectedRow];
		id object = selectedRow == -1 ? nil : [m_clusterOutline itemAtRow:selectedRow];
		
		if(object == nil)
			[item setEnabled:NO];
		else {
			Cluster* cluster = nil;
			if([object isMemberOfClass:[Cluster class]])
				cluster = (Cluster*)object;
			else
				cluster = [self parentClusterOf:object];
			
			[item setEnabled:YES];
			if(cluster) {
				switch([item tag]) {
					case _kMenuItemMessageSettingAccept:
						[item setState:([cluster messageSetting] == kQQClusterMessageAccept)];
						break;
					case _kMenuItemMessageSettingAcceptNoPrompt:
						[item setState:([cluster messageSetting] == kQQClusterMessageAcceptNoPrompt)];
						break;
					case _kMenuItemMessageSettingAutoEject:
						[item setState:([cluster messageSetting] == kQQClusterMessageAutoEject)];
						break;
					case _kMenuItemMessageSettingBlock:
						[item setState:([cluster messageSetting] == kQQClusterMessageBlock)];
						break;
					case _kMenuItemMessageSettingDisplayCount:
						[item setState:([cluster messageSetting] == kQQClusterMessageDisplayCount)];
						break;
				}
			}
		}
	} else if(menu == [m_clusterOutline menu]) {
		//
		// for context menu of cluster outline
		//
		
		if([item tag] == _kMenuItemMessageSetting)
			[item setEnabled:YES];
		else {
			int selectedRow = [m_clusterOutline selectedRow];
			id object = selectedRow == -1 ? nil : [m_clusterOutline itemAtRow:selectedRow];
			
			if(object == nil) {
				switch([item tag]) {
					case _kMenuItemAddCluster:
						[item setEnabled:YES];
						break;
					default:
						[item setEnabled:NO];
						break;
				}
			}
			else if([object isMemberOfClass:[Cluster class]]) {
				switch([item tag]) {
					case _kMenuItemViewInfo:
						// set title
						[item setTitle:([m_me isSuperUser:(Cluster*)object] ? L(@"LQMenuItemModifyInfo", @"MainWindow") : L(@"LQMenuItemViewInfo", @"MainWindow"))];
						[item setEnabled:YES];
						break;
					case _kMenuItemChatInCluster:
					case _kMenuItemAddCluster:
					case _kMenuItemExitCluster:
					case _kMenuItemCreateCluster:
					case _kMenuItemUpdateOrganization:
					case _kMenuItemEditOrganization:
					case _kMenuItemCreateSubject:
						[item setEnabled:YES];
						break;
					default:
						[item setEnabled:NO];
						break;
				}
			} else if([object isMemberOfClass:[User class]]) {
				switch([item tag]) {
					case _kMenuItemViewInfo:
						[item setTitle:L(@"LQMenuItemViewInfo", @"MainWindow")];
						[item setEnabled:YES];
						break;
					case _kMenuItemChatInCluster:
					case _kMenuItemAddAsFriend:
					case _kMenuItemTempSession:
					case _kMenuItemAddCluster:
					case _kMenuItemCreateCluster:
						[item setEnabled:YES];
						break;
					default:
						[item setEnabled:NO];
						break;
				}
			} else if([object isMemberOfClass:[Dummy class]]) {
				switch([(Dummy*)object type]) {
					case kDummyDialogs:
						switch([item tag]) {
							case _kMenuItemViewInfo:
								[item setTitle:L(@"LQMenuItemViewInfo", @"MainWindow")];
								[item setEnabled:NO];
								break;
							case _kMenuItemAddCluster:
							case _kMenuItemCreateCluster:
							case _kMenuItemCreateDialog:
								[item setEnabled:YES];
								break;
							default:
								[item setEnabled:NO];
								break;
						}
						break;
					case kDummyOrganizations:
						switch([item tag]) {
							case _kMenuItemViewInfo:
								[item setTitle:L(@"LQMenuItemViewInfo", @"MainWindow")];
								[item setEnabled:NO];
								break;
							case _kMenuItemAddCluster:
							case _kMenuItemCreateCluster:
							case _kMenuItemUpdateOrganization:
							case _kMenuItemEditOrganization:
								[item setEnabled:YES];
								break;
							default:
								[item setEnabled:NO];
								break;
						}
						break;
					case kDummySubjects:
						switch([item tag]) {
							case _kMenuItemViewInfo:
								[item setTitle:L(@"LQMenuItemViewInfo", @"MainWindow")];
								[item setEnabled:NO];
								break;
							case _kMenuItemAddCluster:
							case _kMenuItemCreateCluster:
							case _kMenuItemCreateSubject:
								[item setEnabled:YES];
								break;
							default:
								[item setEnabled:NO];
								break;
						}
						break;
				}
			} else if([object isMemberOfClass:[Organization class]]) {
				switch([item tag]) {
					case _kMenuItemViewInfo:
						[item setTitle:L(@"LQMenuItemViewInfo", @"MainWindow")];
						[item setEnabled:NO];
						break;
					case _kMenuItemAddCluster:
					case _kMenuItemCreateCluster:
					case _kMenuItemUpdateOrganization:
					case _kMenuItemEditOrganization:
						[item setEnabled:YES];
						break;
					default:
						[item setEnabled:NO];
						break;
				}
			}
		}
	} else if(menu == [m_mobileTable menu]) {
		int row = [m_mobileTable selectedRow];
		id obj = row == -1 ? nil : [m_groupManager mobileAtIndex:row];
		
		if(obj == nil) {
			switch([item tag]) {
				case _kMenuItemNewMobile:
					[item setEnabled:YES];
					break;
				default:
					[item setEnabled:NO];
					break;
			}
		} else {
			[item setEnabled:YES];
		}
	} else if(menu == [m_recentTable menu]) {
		int row = [m_recentTable selectedRow];
		id obj = row == -1 ? nil : [[m_groupManager recentContacts] objectAtIndex:row];
		
		if(obj == nil) {
			switch([item tag]) {
				case _kMenuItemRemoveFromRecentContact:
					[item setEnabled:NO];
					break;
				default:
					[item setEnabled:YES];
					break;
			}
		} else
			[item setEnabled:YES];
	}
	return YES;
}

#pragma mark -
#pragma mark psm tab bar control delegate

- (void)tabBar:(PSMTabBarControl*)aTabBar willAddTabForItem:(NSTabViewItem*)tabViewItem {	
	// install real identifier needed by psm tab bar control
	switch([[tabViewItem identifier] intValue]) {
		case 0:
			OutlineModel* model = [[[UserOutlineModel alloc] initWithClasses:[NSArray arrayWithObject:[User class]]
																  mainWindow:self] autorelease];
			[tabViewItem setIdentifier:[model controller]];
			break;
		case 1:
			model = [[[ClusterOutlineModel alloc] initWithClasses:[NSArray arrayWithObject:[Cluster class]]
													   mainWindow:self] autorelease];
			[tabViewItem setIdentifier:[model controller]];
			break;
		case 2:
			model = [[[MobileOutlineModel alloc] initWithClasses:[NSArray arrayWithObject:[Mobile class]]
													  mainWindow:self] autorelease];
			[tabViewItem setIdentifier:[model controller]];
			break;
		case 3:
			model = [[[RecentOutlineModel alloc] initWithClasses:[NSArray arrayWithObjects:[User class], [Cluster class], [Mobile class], nil]
													  mainWindow:self] autorelease];
			[tabViewItem setIdentifier:[model controller]];
			break;			
	}
}

#pragma mark -
#pragma mark tab view delegate

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
	if(tabView == m_tabMain) {
		if([[tabViewItem label] isEqualToString:_kTabViewItemMain]) {
			// save groups, to clear the dirty flag
			[m_groupManager saveGroups];
			
			// enable hot key
			m_enableHotKey = YES;
			
			// process postponed event
			NSEnumerator* e = [m_postponedEventCache objectEnumerator];
			while(QQNotification* event = [e nextObject]) {
				switch([event eventId]) {
					case kQQEventReceivedIM:
						[m_mainQQListener handleReceivedIM:event];
						break;
					case kQQEventReceivedSystemNotification:
						[m_mainQQListener handleReceivedSystemNotification:event];
						break;
				}
			}
			[m_postponedEventCache removeAllObjects];
		} else
			m_enableHotKey = NO;
	}
}

#pragma mark -
#pragma mark drawer delegate

- (void)drawerWillOpen:(NSNotification *)notification {
	// set initial status
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	[m_chkShowLargeUserHead setState:[cache showLargeUserHead]];
	[m_chkShowRealName setState:[cache showRealName]];
	[m_chkShowNickName setState:[cache showNickName]];
	[m_chkShowFriendLevel setState:[cache showLevel]];
	[m_chkShowOnlineOnly setState:[cache showOnlineOnly]];
	[m_chkShowSignature setState:[cache showSignature]];
	[m_chkShowUserProperty setState:[cache showUserProperty]];
	[m_chkShowStatusMessage setState:[cache showStatusMessage]];
	[m_chkShowClusterNameCard setState:[cache showClusterNameCard]];
	[m_chkShowHorizontalLine setState:[cache showHorizontalLine]];
	[m_chkAlternatingRowBackground setState:[cache alternatingRowBackground]];
	[m_outlineBackgroundColorWell setColor:[cache background]];
	[m_outlineDefaultFontColorWell setColor:[cache nickFontColor]];
	[m_signatureFontColorWell setColor:[cache signatureFontColor]];
	
	// save preference in case user wanna rollback
	[cache sync];
}

- (void)drawerWillClose:(NSNotification *)notification {
	PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
	if(m_displaySettingShouldChange) {
		// set new setting
		[cache setShowLargeUserHead:[m_chkShowLargeUserHead state]];
		[cache setShowRealName:[m_chkShowRealName state]];
		[cache setShowNickName:[m_chkShowNickName state]];
		[cache setShowLevel:[m_chkShowFriendLevel state]];
		[cache setShowOnlineOnly:[m_chkShowOnlineOnly state]];
		[cache setShowSignature:[m_chkShowSignature state]];
		[cache setShowStatusMessage:[m_chkShowStatusMessage state]];
		[cache setShowUserProperty:[m_chkShowUserProperty state]];
		[cache setShowClusterNameCard:[m_chkShowClusterNameCard state]];
		[cache setShowHorizontalLine:[m_chkShowHorizontalLine state]];
		[cache setAlternatingRowBackground:[m_chkAlternatingRowBackground state]];
		[cache setBackground:[m_outlineBackgroundColorWell color]];
		[cache setNickFontColor:[m_outlineDefaultFontColorWell color]];
		[cache setSignatureFontColor:[m_signatureFontColorWell color]];
	} else
		[cache reload];
	
	// change data source
	[m_userDataSource setShowOnlineOnly:[cache showOnlineOnly]];
	[m_userDataSource setShowLargeHead:[cache showLargeUserHead]];
	
	// set outline
	[m_userOutline setGridStyleMask:([cache showHorizontalLine] ? NSTableViewSolidHorizontalGridLineMask : NSTableViewGridNone)];
	[m_userOutline setUsesAlternatingRowBackgroundColors:[cache alternatingRowBackground]];
	[m_userOutline setBackgroundColor:[cache background]];
	[m_clusterOutline setGridStyleMask:([cache showHorizontalLine] ? NSTableViewSolidHorizontalGridLineMask : NSTableViewGridNone)];
	[m_clusterOutline setUsesAlternatingRowBackgroundColors:[cache alternatingRowBackground]];
	[m_clusterOutline setBackgroundColor:[cache background]];
	[m_recentTable setGridStyleMask:([cache showHorizontalLine] ? NSTableViewSolidHorizontalGridLineMask : NSTableViewGridNone)];
	[m_recentTable setUsesAlternatingRowBackgroundColors:[cache alternatingRowBackground]];
	[m_recentTable setBackgroundColor:[cache background]];
	[m_mobileTable setGridStyleMask:([cache showHorizontalLine] ? NSTableViewSolidHorizontalGridLineMask : NSTableViewGridNone)];
	[m_mobileTable setUsesAlternatingRowBackgroundColors:[cache alternatingRowBackground]];
	[m_mobileTable setBackgroundColor:[cache background]];
	
	// refresh outline
	[m_userOutline reloadData];
	[m_clusterOutline reloadData];
	[m_recentTable reloadData];
	[m_mobileTable reloadData];
	
	// clear modify flag
	m_modifyColor = -1;
	m_modifyFont = -1;
	
	// close color panel and font panel
	if([NSColorPanel sharedColorPanelExists])
		[[NSColorPanel sharedColorPanel] orderOut:self];
	if([NSFontPanel sharedFontPanelExists])
		[[NSFontPanel sharedFontPanel] orderOut:self];
}

- (void)drawerDidClose:(NSNotification *)notification {
	[m_displaySettingDrawer setContentSize:NSMakeSize(100, 100)];
}

#pragma mark -
#pragma mark alert delegate

- (void)moveToBlacklistAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	if(returnCode == NSAlertAlternateReturn)
		m_sheetType = _kSheetMoveToBlacklist;
}

- (void)loginFailedAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	m_sheetType = _kSheetLoginFailed;
}

- (void)networkErrorAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	m_sheetType = _kSheetNetworkError;
}

- (void)kickedOutAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	m_sheetType = _kSheetKickedOut;
}

- (void)inputSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void*)contextInfo {
	if(returnCode == NO)
		m_sheetType = -1;
}

- (void)uploadFriendGroupAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	m_sheetType = (returnCode == YES) ? _kSheetUploadFriendGroupConfirmYes : _kSheetUploadFriendGroupConfirmNo;
}

- (void)deleteGroupAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	if(returnCode == YES)
		m_sheetType = _kSheetDeleteGroup;
}

- (void)qbarPluginSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void*)contextInfo {
	if(returnCode == YES) {
		int row = [m_pluginTable selectedRow];
		id<QBarPlugin> plugin = [m_pluginManager QBarPluginAtIndex:row];
		if(plugin) {
			// save plugin name
			PreferenceCache* cache = [PreferenceCache cache:[m_me QQ]];
			[cache setActiveQBarName:[plugin pluginName]];
			
			// set plugin
			[m_qbarView setQBarPlugin:plugin];
		}
	}
}

#pragma mark -
#pragma mark table view data source

- (int)numberOfRowsInTableView:(NSTableView *)aTableView {
	if(aTableView == m_pluginTable)
		return [m_pluginManager QBarPluginCount];
	else
		return 0;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
	if(aTableView == m_pluginTable) {
		id<QBarPlugin> plugin = [m_pluginManager QBarPluginAtIndex:rowIndex];
		if(plugin) {
			switch([[aTableColumn identifier] intValue]) {
				case 0:
					return [plugin isActivated] ? L(@"LQActive") : L(@"LQInactive");
				case 1:
					return [plugin pluginName];
				case 2:
					return [plugin pluginDescription];
			}
		} 
	} 
	
	return kStringEmpty;
}

#pragma mark -
#pragma mark combo box data source

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index {
	int toBeDeleted = -1;
	int row = [m_userOutline selectedRow];
	if(row != -1) {
		id object = [m_userOutline itemAtRow:row];
		if([object isMemberOfClass:[Group class]])
			toBeDeleted = [m_groupManager indexOfGroup:object];
	}
	
	Group* group = [m_groupManager group:index];
	if(toBeDeleted == index)
		return [NSString stringWithFormat:@"%@ <%@>", [group name], L(@"LQHintToBeDeleted", @"MainWindow")];
	else
		return [group name];
}

- (int)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	return [m_groupManager friendlyGroupCount];
}

#pragma mark -
#pragma mark QBarView delegate

- (void)qBarViewAddButtonPressed:(QBarView*)qBar {
	[m_txtQBarPluginCount setStringValue:[NSString stringWithFormat:L(@"LQHintQBarPluginFound", @"MainWindow"), [m_pluginManager QBarPluginCount]]];
	[NSApp beginSheet:m_winQBarPlugins
	   modalForWindow:[self window]
		modalDelegate:self
	   didEndSelector:@selector(qbarPluginSheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
}

#pragma mark -
#pragma mark animation delegate

- (void)animationDidEnd:(NSAnimation *)animation {
	switch(m_animationType) {
		case _kAnimationAutoHide:
			// get start frame
			NSDictionary* dict = [[(NSViewAnimation*)animation viewAnimations] objectAtIndex:0];
			NSRect frame = [[dict objectForKey:NSViewAnimationStartFrameKey] rectValue];
			
			// hide main window
			[[self window] orderOut:self];
			
			// make frame inside screen
			frame.origin.y = MAX(frame.origin.y, 0);
			frame.origin.x = MAX(frame.origin.x, 0);
			NSRect screenFrame = [[NSScreen mainScreen] frame];
			if(NSMaxX(frame) > NSMaxX(screenFrame))
				frame.origin.x = NSMaxX(screenFrame) - NSWidth(frame);
			
			// hide main window and restore frame
			[[self window] setFrame:frame display:NO];
			[[[self window] contentView] setAutoresizesSubviews:YES];
			
			// show side window
			[m_sideWindow orderFront:self];
			
			// refresh icon
			[self refreshDockIcon];
			break;
		case _kAnimationRestoreFromAutoHide:
			[m_sideWindow close];
			[m_sideWindow release];
			m_sideWindow = nil;
			[[self window] makeKeyWindow];
			[[[self window] contentView] setAutoresizesSubviews:YES];
			break;
	}
	
	m_animationType = -1;
}

#pragma mark -
#pragma mark setter and getter

- (QQClient*)client {
	return m_client;
}

- (ContactInfo*)contact {
	return [m_me contact];
}

- (void)setContactInfo:(ContactInfo*)contact {
	[m_me setContact:contact];
}

- (GroupManager*)groupManager {
	return m_groupManager;
}

- (FaceManager*)faceManager {
	return m_faceManager;
}

- (User*)me {
	return m_me;
}

- (void)setMe:(User*)me {
	[me retain];
	[m_me release];
	m_me = me;
}

- (UInt32)onlineUserCount {
	return [m_mainQQListener onlineUserCount];
}

- (WindowRegistry*)windowRegistry {
	return m_windowRegistry;
}

- (MessageQueue*)messageQueue {
	return m_messageQueue;
}

- (NSOutlineView*)userOutline {
	return m_userOutline;
}

- (NSOutlineView*)clusterOutline {
	return m_clusterOutline;
}

- (NSTableView*)mobileTable {
	return m_mobileTable;
}

- (HistoryManager*)historyManager {
	return m_historyManager;
}

- (NSButton*)systemMessageListButton {
	return m_btnSystemMessageList;
}

- (NSImageView*)sideImageView {
	return m_ivSide;
}

- (BOOL)autoHided {
	return m_autoHided;
}

- (VerifyCodeWindowController*)verifyCodeWindowController {
	return m_verifyCodeWindowController;
}

- (BOOL)isMyInfoGot {
	return m_myInfoGot;
}

- (void)setMyInfoGot:(BOOL)flag {
	m_myInfoGot = flag;
}

- (NSProgressIndicator*)loginIndicator {
	return m_piLogin;
}

- (NSTabView*)mainTab {
	return m_tabMain;
}

- (void)setChangingStatus:(BOOL)flag {
	m_changingStatus = flag;
}

- (NSMutableDictionary*)removeFriendGroupMapping {
	return m_removeFriendGroupMapping;
}

- (NSMutableArray*)postponedEventCache {
	return m_postponedEventCache;
}

- (BOOL)hotKeyEnabled {
	return m_enableHotKey;
}

- (NSToolbarItem*)headItem {
	return m_headItem;
}

- (PluginManager*)pluginManager {
	return m_pluginManager;
}

- (NSString*)currentOutlineLabel {
	return [[m_tabGroup selectedTabViewItem] label];
}

- (JobController*)jobController {
	return m_jobController;
}

- (BOOL)isUIInitialized {
	return m_UIInitialized;
}

- (BOOL)isRefreshingFriendList {
	return m_refreshingFriendList;
}

- (void)setRefreshingFriendList:(BOOL)flag {
	m_refreshingFriendList = flag;
}

@end