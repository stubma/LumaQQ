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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 0 2111-1307 USA
 */

#import <Cocoa/Cocoa.h>
#import "QQListener.h"
#import "SearchedUserDataSource.h"
#import "SearchClusterDataSource.h"

#define kTabViewItemSearchWhat @"SearchWhat"
#define kTabViewItemSearchUser @"SearchUser"
#define kTabViewItemSearchCluster @"SearchCluster"

@class MainWindowController;

@interface SearchWindowController : NSWindowController <QQListener> {
	MainWindowController* m_mainWindowController;
	
	IBOutlet NSTextField* m_txtTitle;
	IBOutlet NSTextField* m_txtMessage;
	IBOutlet NSButton* m_btnBack;
	IBOutlet NSButton* m_btnNext;
	IBOutlet NSButton* m_btnFinished;
	IBOutlet NSProgressIndicator* m_piBusy;
	IBOutlet NSTextField* m_txtHint;
	IBOutlet NSTabView* m_tabMain;
	IBOutlet NSTabView* m_tabSearchUser;
	IBOutlet NSTabView* m_tabSearchCluster;
	
	// search what panel
	IBOutlet NSMatrix* m_matrixSearchWhat;
	IBOutlet NSTextField* m_txtOnlines;
	
	// search user panel
	IBOutlet NSPopUpButton* m_pbUserSearchMode;
	IBOutlet NSTextField* m_txtQQ;
	IBOutlet NSTextField* m_txtNick;
	IBOutlet NSButton* m_chkOnline;
	IBOutlet NSButton* m_chkHasCamera;
	IBOutlet NSComboBox* m_cbProvince;
	IBOutlet NSComboBox* m_cbCity;
	IBOutlet NSComboBox* m_cbAge;
	IBOutlet NSComboBox* m_cbGender;
	IBOutlet NSTableView* m_userTable;
	IBOutlet NSButton* m_btnNextUserPage;
	IBOutlet NSButton* m_btnPrevUserPage;
	IBOutlet NSTextField* m_txtUserPage;
	IBOutlet NSButton* m_btnViewUserInfo;
	IBOutlet NSButton* m_btnViewAllUser;
	IBOutlet NSButton* m_btnAddFriend;
		
	// search cluster panel
	IBOutlet NSPopUpButton* m_pbClusterSearchMode;
	IBOutlet NSTextField* m_txtClusterId;
	IBOutlet NSComboBox* m_cbLevel1;
	IBOutlet NSComboBox* m_cbLevel2;
	IBOutlet NSComboBox* m_cbLevel3;
	IBOutlet NSTableView* m_clusterTable;
	IBOutlet NSButton* m_btnNextClusterPage;
	IBOutlet NSButton* m_btnPrevClusterPage;
	IBOutlet NSTextField* m_txtClusterPage;
	IBOutlet NSButton* m_btnViewClusterInfo;
	IBOutlet NSButton* m_btnViewCreatorInfo;
	IBOutlet NSButton* m_btnViewAllCluster;
	IBOutlet NSButton* m_btnJoinCluster;
	
	NSString* m_initialItemIdentifier;
	
	int m_nextPage;
	BOOL m_operating;
	UInt16 m_waitingSequence;
	
	SearchedUserDataSource* m_userDataSource;
	NSMutableArray* m_userCache;
	
	SearchClusterDataSource* m_clusterDataSource;
	NSMutableArray* m_clusterCache;
}

- (id)initWithMainWindowController:(MainWindowController*)controller;

// actions
- (IBAction)onNext:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onFinished:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onUserSearchModeChanged:(id)sender;
- (IBAction)onClusterSearchModeChanged:(id)sender;
- (IBAction)onSearchUser:(id)sender;
- (IBAction)onSearchCluster:(id)sender;
- (IBAction)onViewUserInfo:(id)sender;
- (IBAction)onViewClusterInfo:(id)sender;
- (IBAction)onViewCreatorInfo:(id)sender;
- (IBAction)onViewAllUser:(id)sender;
- (IBAction)onViewAllCluster:(id)sender;
- (IBAction)onNextPageUser:(id)sender;
- (IBAction)onPrevPageUser:(id)sender;
- (IBAction)onNextPageCluster:(id)sender;
- (IBAction)onPrevPageCluster:(id)sender;
- (IBAction)onAddFriend:(id)sender;
- (IBAction)onJoinCluster:(id)sender;

// helper
- (void)refreshTitleMessage;
- (void)showErrorMessage:(NSString*)error;
- (void)goToNextPage;
- (void)gotoPreviousPage;
- (NSString*)canSearch;
- (NSString*)canNext;
- (void)refreshSearchModeTabView;
- (void)refreshControls;
- (void)startHint:(NSString*)hint;
- (void)stopHint;
- (void)searchUser:(int)page;
- (void)showUserPage:(int)page;
- (void)searchCluster;
- (void)onUserTableDoubleClick;
- (void)onClusterTableDoubleClick;

// getter and setter
- (void)setInitialIdentifier:(NSString*)identifier;

// qq event handler
- (BOOL)handleSearchUserOK:(QQNotification*)event;
- (BOOL)handleSearchUserFailed:(QQNotification*)event;
- (BOOL)handleAdvancedSearchUserOK:(QQNotification*)event;
- (BOOL)handleAdvancedSearchUserFailed:(QQNotification*)event;
- (BOOL)handleTimeOut:(QQNotification*)event;
- (BOOL)handleSearchClusterOK:(QQNotification*)event;
- (BOOL)handleSearchClusterFailed:(QQNotification*)event;

@end
