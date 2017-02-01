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

#import "SearchWindowController.h"
#import "MainWindowController.h"
#import "NSString-Validate.h"
#import "AlertTool.h"
#import "LocalizedStringTool.h"
#import "SearchUserPacket.h"
#import "SearchUserReplyPacket.h"
#import "AdvancedSearchUserPacket.h"
#import "AdvancedSearchUserReplyPacket.h"
#import "ClusterSearchPacket.h"
#import "WindowRegistry.h"
#import "ClusterCommandReplyPacket.h"
#import "QQCell.h"

#define _kTabViewItemByClusterID @"ByClusterID"
#define _kTabViewItemByCategory @"ByCategory"
#define _kTabViewItemListOnlines @"ListOnlines"
#define _kTabViewItemSearchAccurately @"SearchAccurately"
#define _kTabViewItemAdvancedSearch @"AdvancedSearch"

@implementation SearchWindowController

- (id)initWithMainWindowController:(MainWindowController*)controller {
	self = [super initWithWindowNibName:@"Search"];
	if(self) {
		m_mainWindowController = [controller retain];
		m_operating = NO;
		m_userDataSource = [[SearchedUserDataSource alloc] init];
		m_userCache = [[NSMutableArray array] retain];
		m_clusterDataSource = [[SearchClusterDataSource alloc] init];
		m_clusterCache = [[NSMutableArray array] retain];
		m_nextPage = 0;
		m_waitingSequence = 0;
	}
	return self;
}

- (void) dealloc {
	[m_mainWindowController release];
	[m_initialItemIdentifier release];
	[m_userDataSource release];
	[m_userCache release];
	[m_clusterDataSource release];
	[m_clusterCache release];
	[super dealloc];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	[[m_mainWindowController client] removeQQListener:self];
	[[m_mainWindowController windowRegistry] unregisterSearchWizard:[[m_mainWindowController me] QQ]];
	[self release];
}

- (void)windowDidLoad {
	// set iniital page
	if(m_initialItemIdentifier == nil)
		[m_tabMain selectTabViewItemWithIdentifier:kTabViewItemSearchWhat];
	else
		[m_tabMain selectTabViewItemWithIdentifier:m_initialItemIdentifier];
	
	// set online count hint
	[m_txtOnlines setStringValue:[NSString stringWithFormat:L(@"LQHintOnlineCount", @"Search"), [m_mainWindowController onlineUserCount]]];
	
	// refresh title and message
	[self refreshTitleMessage];
	
	// refresh navigate button
	[self refreshControls];
	
	// set search mode
	[self refreshSearchModeTabView];
	
	// refresh combo box
	[m_cbAge reloadData];
	[m_cbAge selectItemAtIndex:0];
	[m_cbGender reloadData];
	[m_cbGender selectItemAtIndex:0];
	[m_cbProvince reloadData];
	[m_cbProvince selectItemAtIndex:0];
	[m_cbCity reloadData];
	[m_cbCity selectItemAtIndex:0];
	
	// initialize table
	[m_userTable setDataSource:m_userDataSource];
	[[m_userTable tableColumnWithIdentifier:@"0"] setDataCell:[[[QQCell alloc] initWithQQ:[[m_mainWindowController me] QQ]] autorelease]];
	[m_userTable setTarget:self];
	[m_userTable setDoubleAction:@selector(onUserTableDoubleClick)];
	[m_clusterTable setDataSource:m_clusterDataSource];
	[[m_clusterTable tableColumnWithIdentifier:@"0"] setDataCell:[[[QQCell alloc] initWithQQ:[[m_mainWindowController me] QQ]] autorelease]];
	[m_clusterTable setTarget:self];
	[m_clusterTable setDoubleAction:@selector(onClusterTableDoubleClick)];
	
	// add qq listener
	[[m_mainWindowController client] addQQListener:self];
}

#pragma mark -
#pragma mark actions

- (IBAction)onNext:(id)sender {
	NSString* error = [self canNext];
	if(error == nil)
		[self goToNextPage];
	else
		[self showErrorMessage:error];
}

- (IBAction)onBack:(id)sender {
	[self gotoPreviousPage];
}

- (IBAction)onFinished:(id)sender {
	[self close];
}

- (IBAction)onCancel:(id)sender {
	[self close];
}

- (IBAction)onUserSearchModeChanged:(id)sender {
	[self refreshSearchModeTabView];
}

- (IBAction)onClusterSearchModeChanged:(id)sender {
	[self refreshSearchModeTabView];
}

- (IBAction)onSearchUser:(id)sender {
	// check status
	if(m_operating)
		return;
	
	// validate
	NSString* error = [self canSearch];
	if(error != nil) {
		[self showErrorMessage:error];
		m_operating = NO;
		return;
	}
	
	// clear cache
	[m_userCache removeAllObjects];
	
	// search
	m_nextPage = 0;
	[self searchUser:m_nextPage++];
}

- (IBAction)onSearchCluster:(id)sender {
	// check status
	if(m_operating)
		return;
	
	// validate
	NSString* error = [self canSearch];
	if(error != nil) {
		[self showErrorMessage:error];
		m_operating = NO;
		return;
	}
	
	// clear cache
	[m_clusterCache removeAllObjects];
	
	// search cluster
	[self searchCluster];
}

- (IBAction)onViewUserInfo:(id)sender {
	// get user page
	int row = [m_userTable selectedRow];
	if(row == -1)
		return;
	NSArray* page = [[m_userTable dataSource] users];
	
	// get object
	id object = [page objectAtIndex:row];
	
	// get qq
	UInt32 QQ = [object QQ];
	
	// get user object
	User* u = [[m_mainWindowController groupManager] user:QQ];
	if(!u)
		u = [[User alloc] initWithQQ:QQ domain:m_mainWindowController];
	
	// show user info
	[[m_mainWindowController windowRegistry] showUserInfoWindow:u mainWindow:m_mainWindowController];
	
	// release
	[u release];
}

- (IBAction)onViewCreatorInfo:(id)sender {
	// get cluster page
	int row = [m_clusterTable selectedRow];
	if(row == -1)
		return;
	NSArray* page = [[m_clusterTable dataSource] clusters];
	
	ClusterInfo* info = [page objectAtIndex:row];
	
	// show user info
	User* u = [[m_mainWindowController groupManager] user:[info creator]];
	if(u == nil) 
		u = [[[User alloc] initWithQQ:[info creator] domain:m_mainWindowController] autorelease];
	[[m_mainWindowController windowRegistry] showUserInfoWindow:u
													 mainWindow:m_mainWindowController];
}

- (IBAction)onViewClusterInfo:(id)sender {
	// get cluster page
	int row = [m_clusterTable selectedRow];
	if(row == -1)
		return;
	NSArray* page = [[m_clusterTable dataSource] clusters];
	
	ClusterInfo* info = [page objectAtIndex:row];	
	Cluster* c = [[Cluster alloc] initWithInternalId:[info internalId] domain:m_mainWindowController];
	[c setClusterInfo:info];
	[[m_mainWindowController windowRegistry] showClusterInfoWindow:[c autorelease]
														mainWindow:m_mainWindowController];
}

- (IBAction)onViewAllUser:(id)sender {
	NSMutableArray* users = [NSMutableArray array];
	NSEnumerator* e = [m_userCache objectEnumerator];
	while(NSArray* array = [e nextObject])
		[users addObjectsFromArray:array];
	
	// refresh table
	[m_userDataSource setUsers:users];
	[m_userTable reloadData];
}

- (IBAction)onViewAllCluster:(id)sender {
	
}

- (IBAction)onNextPageUser:(id)sender {
	// check cache
	int count = [m_userCache count];
	if(m_nextPage < count) {
		[self showUserPage:m_nextPage++];
		[m_txtUserPage setStringValue:[NSString stringWithFormat:@"Page %u", m_nextPage]];
	} else
		[self searchUser:m_nextPage++];
}

- (IBAction)onPrevPageUser:(id)sender {
	[self showUserPage:(m_nextPage - 2)];
	m_nextPage--;
	[m_txtUserPage setStringValue:[NSString stringWithFormat:@"Page %u", m_nextPage]];
	[self refreshControls];
}

- (IBAction)onNextPageCluster:(id)sender {
	
}

- (IBAction)onPrevPageCluster:(id)sender {
	
}

- (IBAction)onAddFriend:(id)sender {
	// get user page
	int row = [m_userTable selectedRow];
	if(row == -1)
		return;
	NSArray* page = [[m_userTable dataSource] users];
	
	// get object
	id object = [page objectAtIndex:row];
	
	// open add friend window
	[[m_mainWindowController windowRegistry] showAddFriendWindow:[object QQ]
															head:[object head]
															nick:[object nick]
													  mainWindow:m_mainWindowController];
}

- (IBAction)onJoinCluster:(id)sender {
	// get user page
	int row = [m_clusterTable selectedRow];
	if(row == -1)
		return;
	NSArray* page = [[m_clusterTable dataSource] clusters];
	
	// get object
	id object = [page objectAtIndex:row];
	
	// open join cluster window
	[[m_mainWindowController windowRegistry] showJoinClusterWindow:[object internalId]
															object:object
														mainWindow:m_mainWindowController];
}

#pragma mark -
#pragma mark helper

- (void)showUserPage:(int)page {
	[m_userDataSource setUsers:[m_userCache objectAtIndex:page]];
	[m_userTable reloadData];
	[self refreshControls];
}

- (void)searchCluster {
	// check status
	if(m_operating)
		return;
	m_operating = YES;
	
	// refresh control
	[self refreshControls];
	
	// start ui
	[self startHint:L(@"LQHintSearchCluster", @"Search")];
	
	// search
	m_waitingSequence = [[m_mainWindowController client] searchCluster:[[m_txtClusterId stringValue] intValue]];
}

- (void)searchUser:(int)page {
	// check status
	if(m_operating)
		return;
	m_operating = YES;
	
	// refresh control
	[self refreshControls];
	
	// start ui
	[self startHint:L(@"LQHintSearchUser", @"Search")];
	
	switch([m_pbUserSearchMode indexOfSelectedItem]) {
		case 0:
			m_waitingSequence = [[m_mainWindowController client] searchOnlineUsers:page];
			break;
		case 1:
			// check qq number
			UInt32 QQ = [[m_txtQQ stringValue] intValue];
			if(QQ == 0)
				m_waitingSequence = [[m_mainWindowController client] searchUserByNick:[m_txtNick stringValue] page:page];
			else
				m_waitingSequence = [[m_mainWindowController client] searchUserByQQ:QQ page:page];
			break;
		case 2:
			m_waitingSequence = [[m_mainWindowController client] advancedSearchUser:[m_chkOnline state]
														 hasCam:[m_chkHasCamera state]
													   ageIndex:[m_cbAge indexOfSelectedItem]
													genderIndex:[m_cbGender indexOfSelectedItem]
												  provinceIndex:[m_cbProvince indexOfSelectedItem]
													  cityIndex:[m_cbCity indexOfSelectedItem]
														   page:page];
			break;
	}
}

- (void)refreshSearchModeTabView {
	switch([m_pbUserSearchMode indexOfSelectedItem]) {
		case 0:
			[m_tabSearchUser selectTabViewItemWithIdentifier:_kTabViewItemListOnlines];
			break;
		case 1:
			[m_tabSearchUser selectTabViewItemWithIdentifier:_kTabViewItemSearchAccurately];
			break;
		case 2:
			[m_tabSearchUser selectTabViewItemWithIdentifier:_kTabViewItemAdvancedSearch];
			break;
	}
	switch([m_pbClusterSearchMode indexOfSelectedItem]) {
		case 0:
			[m_tabSearchCluster selectTabViewItemWithIdentifier:_kTabViewItemByClusterID];
			break;
		case 1:
			[m_tabSearchCluster selectTabViewItemWithIdentifier:_kTabViewItemByCategory];
			break;
	}
}

- (void)refreshTitleMessage {	
	// check identifier
	id identifier = [[m_tabMain selectedTabViewItem] identifier];
	if([kTabViewItemSearchWhat isEqual:identifier]) {
		[m_txtTitle setStringValue:L(@"LQTitleSearchWhat", @"Search")];
		[m_txtMessage setStringValue:L(@"LQMessageSearchWhat", @"Search")];
	} else if([kTabViewItemSearchUser isEqual:identifier]) {
		[m_txtTitle setStringValue:L(@"LQTitleSearchUser", @"Search")];
		[m_txtMessage setStringValue:L(@"LQMessageSearchUser", @"Search")];
	} else if([kTabViewItemSearchCluster isEqual:identifier]) {
		[m_txtTitle setStringValue:L(@"LQTitleSearchCluster", @"Search")];
		[m_txtMessage setStringValue:L(@"LQMessageSearchCluster", @"Search")];
	}
}

- (void)refreshControls {
	id identifier = [[m_tabMain selectedTabViewItem] identifier];
	[m_btnBack setEnabled:(![kTabViewItemSearchWhat isEqual:identifier] && !m_operating)];
	[m_btnNext setEnabled:(![kTabViewItemSearchUser isEqual:identifier] && ![kTabViewItemSearchCluster isEqual:identifier] && !m_operating)];
	[m_btnFinished setEnabled:([kTabViewItemSearchUser isEqual:identifier] || [kTabViewItemSearchCluster isEqual:identifier] && !m_operating)];
	[m_btnNextUserPage setEnabled:(m_nextPage > 0 && !m_operating)];
	[m_btnPrevUserPage setEnabled:(m_nextPage > 1 && !m_operating)];
	[m_btnNextClusterPage setEnabled:(m_nextPage > 0 && !m_operating)];
	[m_btnPrevClusterPage setEnabled:(m_nextPage > 1 && !m_operating)];
	[m_btnViewUserInfo setEnabled:([m_userTable selectedRow] != -1)];
	[m_btnViewClusterInfo setEnabled:([m_clusterTable selectedRow] != -1)];
	[m_btnViewCreatorInfo setEnabled:([m_clusterTable selectedRow] != -1)];
	[m_btnAddFriend setEnabled:([m_userTable selectedRow] != -1)];
	[m_btnJoinCluster setEnabled:([m_clusterTable selectedRow] != -1)];
}

- (void)showErrorMessage:(NSString*)error {
	[AlertTool showWarning:[self window] message:error];
}

- (void)goToNextPage {
	id identifier = [[m_tabMain selectedTabViewItem] identifier];
	if([kTabViewItemSearchWhat isEqual:identifier]) {
		if([m_matrixSearchWhat selectedRow] == 0)
			[m_tabMain selectTabViewItemWithIdentifier:kTabViewItemSearchUser];
		else
			[m_tabMain selectTabViewItemWithIdentifier:kTabViewItemSearchCluster];
	} else if([kTabViewItemSearchUser isEqual:identifier]) {
	} else if([kTabViewItemSearchCluster isEqual:identifier]) {
	}
	
	// refresh title and message
	[self refreshTitleMessage];
	[self refreshControls];
}

- (void)gotoPreviousPage {
	id identifier = [[m_tabMain selectedTabViewItem] identifier];
	if([kTabViewItemSearchWhat isEqual:identifier]) {
	} else if([kTabViewItemSearchUser isEqual:identifier]) {
		[m_tabMain selectTabViewItemWithIdentifier:kTabViewItemSearchWhat];
	} else if([kTabViewItemSearchCluster isEqual:identifier]) {
		[m_tabMain selectTabViewItemWithIdentifier:kTabViewItemSearchWhat];
	}
	
	// refresh title and message
	[self refreshTitleMessage];
	[self refreshControls];
}

- (NSString*)canNext {
	id identifier = [[m_tabMain selectedTabViewItem] identifier];
	if([kTabViewItemSearchUser isEqual:identifier]) {
		if([m_userTable selectedRow] == -1)
			return L(@"LQWarningSelectUser", @"Search");
	} else if([kTabViewItemSearchCluster isEqual:identifier]) {
		if([m_clusterTable selectedRow] == -1)
			return L(@"LQWarningSelectCluster", @"Search");
	} 
	
	return nil;
}

- (NSString*)canSearch {
	id identifier = [[m_tabMain selectedTabViewItem] identifier];
	if([kTabViewItemSearchWhat isEqual:identifier]) {
		return nil;
	} else if([kTabViewItemSearchUser isEqual:identifier]) {
		switch([m_pbUserSearchMode indexOfSelectedItem]) {
			case 1:
				// all empty
				if([[m_txtQQ stringValue] isEmpty] &&
				   [[m_txtNick stringValue] isEmpty])
					return L(@"LQWarningAllEmpty", @"Search");
				
				// check qq format
				if(![[m_txtQQ stringValue] isEmpty]) {
					UInt32 QQ = [[m_txtQQ stringValue] intValue];
					if(QQ < 10001)
						return L(@"LQWarningInvalidQQ", @"Search");
				}
					
				return nil;
			default:
				return nil;
		}
	} else if([kTabViewItemSearchCluster isEqual:identifier]) {
		switch([m_pbClusterSearchMode indexOfSelectedItem]) {
			case 0:
				if([[m_txtClusterId stringValue] intValue] == 0)
					return L(@"LQWarningInvalidClusterId", @"Search");
			default:
				return nil;
		}
	} else
		return nil;
}

- (void)startHint:(NSString*)hint {
	[m_piBusy setHidden:NO];
	[m_piBusy startAnimation:self];
	[m_txtHint setStringValue:hint];
}

- (void)stopHint {
	[m_piBusy setHidden:YES];
	[m_piBusy stopAnimation:self];
	[m_txtHint setStringValue:kStringEmpty];
}

- (void)onUserTableDoubleClick {
	[self onViewUserInfo:self];
}

- (void)onClusterTableDoubleClick {
	[self onViewClusterInfo:self];
}

#pragma mark -
#pragma mark getter and setter

- (void)setInitialIdentifier:(NSString*)identifier {
	[identifier retain];
	[m_initialItemIdentifier release];
	m_initialItemIdentifier = identifier;
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	// check sequence
	Packet* packet = (Packet*)[event object];
	if([packet sequence] != m_waitingSequence)
		return ret;
	
	switch([event eventId]) {
		case kQQEventSearchUserOK:
			ret = [self handleSearchUserOK:event];
			break;
		case kQQEventSearchUserFailed:
			ret = [self handleSearchUserFailed:event];
			break;
		case kQQEventAdvancedSearchUserOK:
			ret = [self handleAdvancedSearchUserOK:event];
			break;
		case kQQEventAdvancedSearchUserFailed:
			ret = [self handleAdvancedSearchUserFailed:event];
			break;
		case kQQEventClusterSearchOK:
			ret = [self handleSearchClusterOK:event];
			break;
		case kQQEventClusterSearchFailed:
			ret = [self handleSearchClusterFailed:event];
			break;
		case kQQEventTimeoutBasic:
			ret = [self handleTimeOut:event];
			break;
	}
	return ret;
}

- (BOOL)handleSearchUserOK:(QQNotification*)event {
	if(!m_operating)
		return NO;
	
	SearchUserPacket* packet = (SearchUserPacket*)[event outPacket];
	if([[packet user] QQ] == [[m_mainWindowController me] QQ]) {
		// refresh ui
		m_operating = NO;
		[self stopHint];
		[self refreshControls];
		
		SearchUserReplyPacket* reply = (SearchUserReplyPacket*)[event object];
		[m_userCache addObject:[reply searchedUsers]];
		[self showUserPage:(m_nextPage - 1)];
		[m_txtUserPage setStringValue:[NSString stringWithFormat:@"Page %u", m_nextPage]];
	}
	
	return NO;
}

- (BOOL)handleSearchUserFailed:(QQNotification*)event {
	if(!m_operating)
		return NO;
	
	SearchUserPacket* packet = (SearchUserPacket*)[event outPacket];
	if([[packet user] QQ] == [[m_mainWindowController me] QQ]) {
		// refresh ui
		m_operating = NO;
		[self stopHint];
		[self refreshControls];
		
		[self showErrorMessage:L(@"LQWarningSearchUserFailed", @"Search")];
	}
	
	return NO;
}

- (BOOL)handleAdvancedSearchUserOK:(QQNotification*)event {
	if(!m_operating)
		return NO;
	
	AdvancedSearchUserPacket* packet = (AdvancedSearchUserPacket*)[event outPacket];
	if([[packet user] QQ] == [[m_mainWindowController me] QQ]) {
		// refresh ui
		m_operating = NO;
		[self stopHint];
		[self refreshControls];
		
		AdvancedSearchUserReplyPacket* reply = (AdvancedSearchUserReplyPacket*)[event object];
		[m_userCache addObject:[reply searchedUsers]];
		[self showUserPage:(m_nextPage - 1)];
		[m_txtUserPage setStringValue:[NSString stringWithFormat:@"Page %u", m_nextPage]];
	}
	
	return NO;
}

- (BOOL)handleAdvancedSearchUserFailed:(QQNotification*)event {
	if(!m_operating)
		return NO;
	
	AdvancedSearchUserPacket* packet = (AdvancedSearchUserPacket*)[event outPacket];
	if([[packet user] QQ] == [[m_mainWindowController me] QQ]) {
		// refresh ui
		m_operating = NO;
		[self stopHint];
		[self refreshControls];
		
		[self showErrorMessage:L(@"LQWarningSearchUserFailed", @"Search")];
	}
	
	return NO;
}

- (BOOL)handleTimeOut:(QQNotification*)event {
	OutPacket* packet = (OutPacket*)[event outPacket];
	
	switch([packet command]) {
		case kQQCommandSearch:
		case kQQCommandAdvancedSearch:
			// refresh ui
			m_operating = NO;
			[self stopHint];
			[self refreshControls];
			
			[self showErrorMessage:L(@"LQWarningSearchTimeout", @"Search")];
			break;
		case kQQCommandCluster:
			switch([(ClusterCommandPacket*)packet subCommand]) {
				case kQQSubCommandClusterSearch:
					// refresh ui
					m_operating = NO;
					[self stopHint];
					[self refreshControls];
					
					[self showErrorMessage:L(@"LQWarningSearchTimeout", @"Search")];
					break;
			}
	}
	
	return NO;
}

- (BOOL)handleSearchClusterOK:(QQNotification*)event {
	if(!m_operating)
		return NO;
	
	ClusterSearchPacket* packet = (ClusterSearchPacket*)[event outPacket];
	if([[packet user] QQ] == [[m_mainWindowController me] QQ]) {
		// refresh ui
		m_operating = NO;
		[self stopHint];
		[self refreshControls];
		
		ClusterCommandReplyPacket* reply = (ClusterCommandReplyPacket*)[event object];
		[m_clusterCache addObject:[reply infos]];
		[m_clusterDataSource setClusters:[reply infos]];
		[m_clusterTable reloadData];
	}
	
	return NO;
}

- (BOOL)handleSearchClusterFailed:(QQNotification*)event {
	if(!m_operating)
		return NO;
	
	ClusterCommandPacket* packet = (ClusterCommandPacket*)[event outPacket];
	if([[packet user] QQ] == [[m_mainWindowController me] QQ]) {
		// refresh ui
		m_operating = NO;
		[self stopHint];
		[self refreshControls];
		
		ClusterCommandReplyPacket* reply = (ClusterCommandReplyPacket*)[event object];
		if([reply errorMessage])
			[self showErrorMessage:[reply errorMessage]];
		else
			[self showErrorMessage:L(@"LQWarningSearchClusterFailed", @"Search")];
	}
	
	return NO;
}

#pragma mark -
#pragma mark combobox data source

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index {
	if(index == 0)
		return L(@"LQAny");
	else if(aComboBox == m_cbAge)
		return AGE(index);
	else if(aComboBox == m_cbGender)
		return GENDER(index);
	else if(aComboBox == m_cbProvince)
		return PROVINCE(index);
	else if(aComboBox == m_cbCity) {
		int province = [m_cbProvince indexOfSelectedItem];
		return CITY(province, index);
	} else
		return kStringEmpty;
}

- (int)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	if(aComboBox == m_cbAge)
		return AGECOUNT + 1;
	else if(aComboBox == m_cbGender)
		return GENDERCOUNT + 1;
	else if(aComboBox == m_cbProvince)
		return PROVINCECOUNT + 1;
	else if(aComboBox == m_cbCity) {
		int province = [m_cbProvince indexOfSelectedItem];
		if(province == 0)
			return 1;
		else
			return CITYCOUNT(province) + 1;
	} else
		return 0;
}

#pragma mark -
#pragma mark combobox delegate

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
	NSComboBox* comboBox = [notification object];
	if(comboBox == m_cbProvince) {
		[m_cbCity reloadData];
		[m_cbCity selectItemAtIndex:0];
	}
}

#pragma mark -
#pragma mark tableview delegate

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
	[self refreshControls];
}

@end
