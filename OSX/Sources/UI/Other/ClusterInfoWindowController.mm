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

#import "ClusterInfoWindowController.h"
#import "MainWindowController.h"
#import "ImageTool.h"
#import "ClusterNameCard.h"
#import "LocalizedStringTool.h"
#import "NSString-Validate.h"
#import "GroupManager.h"
#import "AlertTool.h"
#import "TreeSelectorWindowController.h"

// workflow name
#define _kWorkflowGetInfos @"GetInfos"
#define _kWorkflowModifyInfos @"ModifyInfos"
#define _kWorkflowModifyMessageSetting @"ModifyMessageSettingWorkflow"
#define _kWorkflowModifyCard @"ModifyCardWorkflow"
#define _kWorkflowGetCard @"GetCardWorkflow"

// workflow unit name
#define _kWorkflowUnitGetCard @"GetCard"
#define _kWorkflowUnitModifyCard @"ModifyCard"
#define _kWorkflowUnitModifyMessageSetting @"ModifyMessageSetting"
#define _kWorkflowUnitGetMessageSetting @"GetMessageSetting"
#define _kWorkflowUnitGetChannelSetting @"GetChannelSetting"
#define _kWorkflowUnitModifyChannelSetting @"ModifyChannelSetting"
#define _kWorkflowUnitGetLastTalkTime @"GetLastTalkTime"
#define _kWorkflowUnitGetClusterInfo @"GetClusterInfo"
#define _kWorkflowUnitModifyClusterInfo @"ModifyClusterInfo"
#define _kWorkflowUnitAddMember @"AddMember"
#define _kWorkflowUnitRemoveMember @"RemoveMember"

// sheet type
#define _kSheetOperationFinishedAndNeedCloseWindow 0

@implementation ClusterInfoWindowController

- (id)initWithCluster:(Cluster*)cluster mainWindow:(MainWindowController*)mainWindowController {
	self = [super initWithWindowNibName:@"ClusterInfo"];
	if(self) {
		m_cluster = [cluster retain];
		m_mainWindowController = [mainWindowController retain];
		m_members = [[NSMutableArray arrayWithArray:[cluster members]] retain];
		m_sheetType = -1;
	}
	return self;
}

- (void) dealloc {
	[m_members release];
	[m_cluster release];
	[m_mainWindowController release];
	[super dealloc];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	if(m_moderator) {
		[m_moderator cancel];
		[m_moderator release];
		m_moderator = nil;
	}
	if(m_oldMembers)
		[m_oldMembers release];
	if(m_newMembers)
		[m_newMembers release];
	
	[[m_mainWindowController windowRegistry] unregisterClusterInfoWindow:[m_cluster internalId]];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSWindowWillCloseNotification 
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kQQCellDidSelectedNotificationName
												  object:nil];
	if(m_treeSelector)
		[m_treeSelector close];
	[self release];
}

- (void)windowDidLoad {
	// init table
	[[m_memberTable tableColumnWithIdentifier:@"0"] setDataCell:[[[NSImageCell alloc] init] autorelease]];
	QQCell* qqCell = [[QQCell alloc] init];
	[qqCell setSearchStyle:YES];
	[qqCell setShowStatus:NO];
	[[m_memberTable tableColumnWithIdentifier:@"1"] setDataCell:[qqCell autorelease]];
	
	// init window title
	if(![[m_cluster name] isEmpty])
		[[self window] setTitle:[NSString stringWithFormat:L(@"LQTitle", @"ClusterInfo"), [m_cluster name]]];
	else
		[[self window] setTitle:[NSString stringWithFormat:L(@"LQTitle", @"ClusterInfo"), [NSString stringWithFormat:@"%u", [m_cluster externalId]]]];
	
	// show first tab
	[m_tabMain selectTabViewItemAtIndex:0];
	
	// refresh button
	[self updateMemberPanelButtons];
	
	// refresh category combo box
	[m_cbLevel1 reloadData];
	[m_cbLevel2 reloadData];
	[m_cbLevel3 reloadData];
	
	// reload
	[self reloadInfo];
	
	// add listener to alert notification
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleTreeSelectorWindowWillClose:)
												 name:NSWindowWillCloseNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleQQCellDidSelected:)
												 name:kQQCellDidSelectedNotificationName
											   object:nil];
	
	// start to get infos
	m_moderator = [[WorkflowModerator alloc] initWithName:_kWorkflowGetInfos dataSource:self];
	m_apply = YES;
	m_showAlert = NO;
	[self buildWorkflow:_kWorkflowGetInfos];
	[m_moderator start:[m_mainWindowController client]];
}

- (void)windowDidMove:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	if(m_treeSelector) {
		NSRect frame = [[self window] frame];
		frame.origin.x += frame.size.width;
		frame.size.width = 250;
		
		[[m_treeSelector window] setFrame:frame display:NO];
	}
}

- (void)windowDidEndSheet:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	switch(m_sheetType) {
		case _kSheetOperationFinishedAndNeedCloseWindow:
			[self close];
			break;
	}
	
	m_sheetType = -1;
}

#pragma mark -
#pragma mark actions

- (IBAction)onOK:(id)sender {
	m_apply = NO;
	[self startModify];
}

- (IBAction)onCancel:(id)sender {
	if([self isSuperUser])
		[self close];
	else {
		switch([[[m_tabMain selectedTabViewItem] identifier] intValue]) {
			case 4:
				m_apply = YES;
				m_showAlert = YES;
				[self buildWorkflow:_kWorkflowModifyCard];
				[m_moderator start:[m_mainWindowController client]];
				break;
			case 3:
				m_apply = YES;
				m_showAlert = YES;
				[self buildWorkflow:_kWorkflowModifyMessageSetting];
				[m_moderator start:[m_mainWindowController client]];
				break;
			default:
				m_apply = YES;
				m_showAlert = NO;
				[self buildWorkflow:_kWorkflowGetInfos];
				[m_moderator start:[m_mainWindowController client]];
				break;
		}
	}
}

- (IBAction)onApply:(id)sender {
	if([self isSuperUser]) {
		m_apply = YES;
		[self startModify];
	} else
		[self close];
}

- (IBAction)onRemoveMember:(id)sender {
	QQCell* cell = m_treeSelector ? [m_treeSelector QQCell] : nil;
	int row = [m_memberTable selectedRow];
	User* u = [m_members objectAtIndex:row];
	[m_members removeObjectAtIndex:row];
	Group* g = [[m_mainWindowController groupManager] group:[u groupIndex]];
	if(cell) {
		[cell set:u state:NSOffState];
		[self refreshGroupState:g cell:cell];
	}		
	if(g)
		[[m_treeSelector tree] reloadItem:g reloadChildren:YES];
	[m_memberTable reloadData];
	[self updateMemberPanelButtons];
}

- (IBAction)onSetMembers:(id)sender {
	if(m_treeSelector)
		return;
	
	// get window frame
	NSRect frame = [[self window] frame];
	frame.origin.x += frame.size.width;
	frame.size.width = 250;
	
	// create and show at right side of window
	m_treeSelector = [[TreeSelectorWindowController alloc] initWithMainWindow:m_mainWindowController
																   dataSource:self];
	[m_treeSelector showWindow:self];
	[[m_treeSelector window] setFrame:frame display:NO];
	
	// set flags
	QQCell* cell = [m_treeSelector QQCell];
	NSEnumerator* e = [m_members objectEnumerator];
	while(User* u = [e nextObject])
		[cell set:u state:NSOnState];
	e = [[[m_mainWindowController groupManager] friendlyGroups] objectEnumerator];
	while(Group* g = [e nextObject]) {
		[self refreshGroupState:g cell:cell];
	}
}

- (IBAction)onAddAsFriend:(id)sender {
	User* user = [m_members objectAtIndex:[m_memberTable selectedRow]];
	[[m_mainWindowController windowRegistry] showAddFriendWindow:[user QQ]
															head:[user head]
															nick:[user nick]
													  mainWindow:m_mainWindowController];
}

#pragma mark -
#pragma mark alert delegate

- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	if(!m_apply) {
		m_sheetType = _kSheetOperationFinishedAndNeedCloseWindow;
	}
}

#pragma mark -
#pragma mark helper

- (void)buildWorkflow:(NSString*)name {
	[m_moderator reset:name];
	
	if([_kWorkflowGetInfos isEqualToString:name]) {
		[m_moderator addUnit:_kWorkflowUnitGetClusterInfo failEvent:kQQEventClusterGetInfoFailed];
		[m_moderator addUnit:_kWorkflowUnitGetLastTalkTime failEvent:kQQEventClusterGetLastTalkTimeFailed];
		[m_moderator addUnit:_kWorkflowUnitGetMessageSetting failEvent:kQQEventClusterGetMessageSettingFailed];
		[m_moderator addUnit:_kWorkflowUnitGetChannelSetting failEvent:kQQEventClusterGetChannelSettingFailed];
		[m_moderator addUnit:_kWorkflowUnitGetCard failEvent:kQQEventClusterGetCardFailed];
	} else if([_kWorkflowModifyInfos isEqualToString:name]) {
		[m_moderator addUnit:_kWorkflowUnitModifyClusterInfo failEvent:kQQEventClusterModifyInfoFailed];
		[m_moderator addUnit:_kWorkflowUnitModifyChannelSetting failEvent:kQQEventClusterModifyChannelSettingFailed];
		[self diffMembers];
		[m_moderator addUnit:_kWorkflowUnitAddMember failEvent:kQQEventClusterModifyMemberFailed];
		[m_moderator addUnit:_kWorkflowUnitRemoveMember failEvent:kQQEventClusterModifyMemberFailed];
	} else if([_kWorkflowGetCard isEqualToString:name]) {
		[m_moderator addUnit:_kWorkflowUnitGetCard failEvent:kQQEventClusterGetCardFailed critical:YES];
	} else if([_kWorkflowModifyCard isEqualToString:name]) {
		[m_moderator addUnit:_kWorkflowUnitModifyCard failEvent:kQQEventClusterModifyCardFailed critical:YES];
	} else if([_kWorkflowModifyMessageSetting isEqualToString:name]) {
		[m_moderator addUnit:_kWorkflowUnitModifyMessageSetting failEvent:kQQEventClusterModifyMessageSettingFailed critical:YES];
	}
}

- (void)diffMembers {
	if(m_oldMembers)
		[m_oldMembers release];
	if(m_newMembers)
		[m_newMembers release];
	
	m_oldMembers = [[NSMutableArray array] retain];
	NSEnumerator* e = [[m_cluster members] objectEnumerator];
	while(User* u = [e nextObject])
		[m_oldMembers addObject:[NSNumber numberWithUnsignedInt:[u QQ]]];
	m_newMembers = [[NSMutableArray array] retain];
	e = [m_members objectEnumerator];
	while(User* u = [e nextObject])
		[m_newMembers addObject:[NSNumber numberWithUnsignedInt:[u QQ]]];
	
	// remove common objects
	int oldCount = [m_oldMembers count];
	int newCount = [m_newMembers count];
	for(int i = oldCount - 1; i >= 0; i--) {
		[m_newMembers removeObject:[m_oldMembers objectAtIndex:i]];
		if([m_newMembers count] < newCount) {
			newCount = [m_newMembers count];
			[m_oldMembers removeObjectAtIndex:i];
		}
	}
}

- (void)startModify {
	switch([[[m_tabMain selectedTabViewItem] identifier] intValue]) {
		case 0:
		case 1:
		case 2:
			m_showAlert = YES;
			[self buildWorkflow:_kWorkflowModifyInfos];
			[m_moderator start:[m_mainWindowController client]];			
			break;
		case 3:
			m_showAlert = YES;
			[self buildWorkflow:_kWorkflowModifyMessageSetting];
			[m_moderator start:[m_mainWindowController client]];
			break;
		case 4:
			m_showAlert = YES;
			[self buildWorkflow:_kWorkflowModifyCard];
			[m_moderator start:[m_mainWindowController client]];
			break;
	}
}

- (void)handleTreeSelectorWindowWillClose:(NSNotification*)notification {
	if(m_treeSelector) {
		if([notification object] == [m_treeSelector window])
			m_treeSelector = nil;
	}
}

- (void)handleQQCellDidSelected:(NSNotification*)notification {
	QQCell* cell = [notification object];
	if([[m_treeSelector QQCell] identifier] != [cell identifier]) 
		return;
	
	id obj = [[notification userInfo] objectForKey:kUserInfoObjectValue];
	int state = [[[notification userInfo] objectForKey:kUserInfoState] intValue];
	if([obj isMemberOfClass:[Group class]]) {
		Group* g = (Group*)obj;
		NSEnumerator* e = [[g users] objectEnumerator];
		while(User* u = [e nextObject]) {
			if(state == NSOnState) {
				[cell set:u state:NSOnState];
				if(![m_members containsObject:u])
					[m_members addObject:u];
			} else {
				[cell set:u state:NSOffState];
				[m_members removeObject:u];
			}				
		}
		
		// refresh
		[[m_treeSelector tree] reloadItem:g reloadChildren:YES];
		
		// reload
		[m_memberTable reloadData];		
	} else if([obj isMemberOfClass:[User class]]) {
		User* u = (User*)obj;
		Group* g = [[m_mainWindowController groupManager] group:[u groupIndex]];
		[self refreshGroupState:g cell:cell];
		[[m_treeSelector tree] reloadItem:g];
		
		// add/remove users
		if([cell state:u] == NSOnState) {
			if(![m_members containsObject:u])
				[m_members addObject:u];
		} else
			[m_members removeObject:u];
		[m_memberTable reloadData];
	}
}

- (void)refreshGroupState:(Group*)g cell:(QQCell*)cell {
	if(g && [g isUser]) {
		int count = [g userCount];
		NSEnumerator* e = [[g users] objectEnumerator];
		while(User* user = [e nextObject]) {
			if([cell state:user] == NSOnState)
				count--;
		}
		if(count == 0)
			[cell set:g state:NSOnState];
		else if(count == [g userCount])
			[cell set:g state:NSOffState];
		else
			[cell set:g state:NSMixedState];
	}
}

- (void)updateMemberPanelButtons {
	int row = [m_memberTable selectedRow];
	if(row == -1) {
		[m_btnAddAsFriend setEnabled:NO];
		[m_btnRemove setEnabled:NO];
	} else {
		User* user = [m_members objectAtIndex:row];
		Group* g = [[m_mainWindowController groupManager] group:[user groupIndex]];
		[m_btnAddAsFriend setEnabled:(g == nil || ![g isFriendly])];
		[m_btnRemove setEnabled:(![user isSuperUser:m_cluster])];
	}
}

- (void)reloadInfo {
	// basic panel
	[m_txtId setStringValue:[NSString stringWithFormat:@"%u", [m_cluster externalId]]];
	[m_txtCreator setStringValue:[NSString stringWithFormat:@"%u", [[m_cluster info] creator]]];
	[m_txtName setStringValue:[m_cluster name]];
	[m_txtNotice setString:[[m_cluster info] notice]];
	[m_txtDescription setString:[[m_cluster info] description]];
	NSImage* image = [ImageTool imageWithName:kImageCluster size:kSizeLarge];
	[m_headControl setHead:kHeadUseImage];
	[m_headControl setImage:image];
	[m_headControl setShowStatus:NO];
	int level = CATEGORYLEVEL([[m_cluster info] category]);
	if(level >= 1)
		[m_cbLevel1 selectItemAtIndex:CATEGORYLEVEL1INDEX([[m_cluster info] category])];
	if(level >= 2)
		[m_cbLevel2 selectItemAtIndex:CATEGORYLEVEL2INDEX([[m_cluster info] category])];
	if(level >= 3)
		[m_cbLevel3 selectItemAtIndex:CATEGORYLEVEL3INDEX([[m_cluster info] category])];
	
	// basic panel
	[m_matrixAuth selectCellWithTag:[[m_cluster info] authType]];
	[m_matrixNotification selectCellWithTag:[m_cluster notificationRight]];
	
	// member panel
	[m_memberTable reloadData];
	
	// message panel
	[m_matrixMessage selectCellWithTag:[m_cluster messageSetting]];
	[m_chkSaveInServer setState:[m_cluster saveMessageSettingInServer]];
	
	// name card panel
	ClusterNameCard* card = [[m_mainWindowController me] nameCard:[m_cluster internalId]];
	[m_txtNameCardName setStringValue:[card name]];
	[m_txtPhone setStringValue:[card phone]];
	[m_txtEmail setStringValue:[card email]];
	[m_txtRemark setString:[card remark]];
	[m_pbGender selectItemAtIndex:[card genderIndex]];
	[m_chkManaged setState:[[m_mainWindowController me] isManaged:m_cluster]];
}

- (BOOL)isSuperUser {
	return [[m_mainWindowController me] isSuperUser:m_cluster];
}

- (NSString*)titleOfCancelUpdateButton {
	return [self isSuperUser] ? L(@"LQCancel") : L(@"LQUpdate");
}

- (NSString*)titleOfApplyCloseButton {
	return [self isSuperUser] ? L(@"LQApply") : L(@"LQClose");
}

#pragma mark -
#pragma mark workflow data source

- (BOOL)acceptEvent:(int)eventId {
	switch(eventId) {
		case kQQEventClusterGetMemberInfoOK:
			return YES;
		default:
			return NO;
	}
}

- (void)workflowStart:(NSString*)workflowName {
	[m_piBusy setHidden:NO];
	[m_piBusy startAnimation:self];
	[m_btnModify setEnabled:NO];
	[m_btnCancel setEnabled:[self isSuperUser]];
	[m_btnApply setEnabled:NO];
}

- (UInt16)executeWorkflowUnit:(NSString*)unitName hint:(NSString*)hint {
	[m_txtHint setStringValue:hint];
	
	if([_kWorkflowUnitGetCard isEqualToString:unitName])
		return [[m_mainWindowController client] getClusterNameCard:[m_cluster internalId]
																QQ:[[m_mainWindowController me] QQ]];
	else if([_kWorkflowUnitModifyCard isEqualToString:unitName])
		return [[m_mainWindowController client] modifyCard:[m_cluster internalId]
													  name:[m_txtNameCardName stringValue]
											   genderIndex:[m_pbGender indexOfSelectedItem]
													 phone:[m_txtPhone stringValue]
													 email:[m_txtEmail stringValue]
													remark:[m_txtRemark string]
										  allowAdminModify:[m_chkManaged state]];
	else if([_kWorkflowUnitModifyMessageSetting isEqualToString:unitName]) {
		if([m_chkSaveInServer state])
			return [[m_mainWindowController client] modifyMessageSetting:[m_cluster internalId]
															  externalId:[m_cluster externalId]
														  messageSetting:[m_matrixMessage selectedTag]];
		else					
			return [[m_mainWindowController client] modifyMessageSetting:[m_cluster internalId]
															  externalId:[m_cluster externalId]
														  messageSetting:kQQClusterMessageClearServerSetting];
	} else if([_kWorkflowUnitGetMessageSetting isEqualToString:unitName])
		return [[m_mainWindowController client] getMessageSetting:[[m_mainWindowController groupManager] allClusterInternalIds]];
	else if([_kWorkflowUnitGetChannelSetting isEqualToString:unitName])
		return [[m_mainWindowController client] getChannelSetting:[m_cluster internalId]
													   externalId:[m_cluster externalId]];
	else if([_kWorkflowUnitModifyChannelSetting isEqualToString:unitName])
		return [[m_mainWindowController client] modifyChannelSetting:[m_cluster internalId]
												   notificationRight:[m_matrixNotification selectedTag]];
	else if([_kWorkflowUnitGetLastTalkTime isEqualToString:unitName])
		return [[m_mainWindowController client] getLastTalkTime:[m_cluster internalId]
													 externalId:[m_cluster externalId]];
	else if([_kWorkflowUnitGetClusterInfo isEqualToString:unitName])
		return [[m_mainWindowController client] getClusterInfo:[m_cluster internalId]];
	else if([_kWorkflowUnitModifyClusterInfo isEqualToString:unitName]) {
		UInt32 cId;
		if([m_cbLevel3 indexOfSelectedItem] == -1 &&
		   [m_cbLevel2 indexOfSelectedItem] == -1 &&
		   [m_cbLevel1 indexOfSelectedItem] == -1)
			cId = 0;
		else if([m_cbLevel3 indexOfSelectedItem] == -1 &&
				[m_cbLevel2 indexOfSelectedItem] == -1)
			cId = LEVEL1ID([m_cbLevel1 indexOfSelectedItem]);
		else if([m_cbLevel3 indexOfSelectedItem] == -1)
			cId = LEVEL2ID([m_cbLevel1 indexOfSelectedItem], [m_cbLevel2 indexOfSelectedItem]);
		else 
			cId = LEVEL3ID([m_cbLevel1 indexOfSelectedItem], [m_cbLevel2 indexOfSelectedItem], [m_cbLevel3 indexOfSelectedItem]);
		
		return [[m_mainWindowController client] modifyClusterInfo:[m_cluster internalId]
														 authType:[m_matrixAuth selectedTag]
														 category:cId
															 name:[m_txtName stringValue]
														   notice:[m_txtNotice string]
													  description:[m_txtDescription string]];
	} else if([_kWorkflowUnitAddMember isEqualToString:unitName])
		return [[m_mainWindowController client] addMember:[m_cluster internalId] members:m_newMembers];
	else if([_kWorkflowUnitRemoveMember isEqualToString:unitName])
		return [[m_mainWindowController client] removeMember:[m_cluster internalId] members:m_oldMembers];
	else
		return 0;
}

- (NSString*)workflowUnitHint:(NSString*)unitName {
	if([_kWorkflowUnitGetCard isEqualToString:unitName])
		return L(@"LQHintGetCard", @"ClusterInfo");
	else if([_kWorkflowUnitModifyCard isEqualToString:unitName])
		return L(@"LQHintModifyCard", @"ClusterInfo");
	else if([_kWorkflowUnitModifyMessageSetting isEqualToString:unitName])
		return L(@"LQHintModifyMessageSetting", @"ClusterInfo");
	else if([_kWorkflowUnitGetMessageSetting isEqualToString:unitName])
		return L(@"LQHintGetMessageSetting", @"ClusterInfo");
	else if([_kWorkflowUnitGetChannelSetting isEqualToString:unitName])
		return L(@"LQHintGetChannelSetting", @"ClusterInfo");
	else if([_kWorkflowUnitModifyChannelSetting isEqualToString:unitName])
		return L(@"LQHintModifyChannelSetting", @"ClusterInfo");
	else if([_kWorkflowUnitGetLastTalkTime isEqualToString:unitName])
		return L(@"LQHintGetLastTalkTime", @"ClusterInfo");
	else if([_kWorkflowUnitGetClusterInfo isEqualToString:unitName])
		return L(@"LQHintGetClusterInfo", @"ClusterInfo");
	else if([_kWorkflowUnitModifyClusterInfo isEqualToString:unitName])
		return L(@"LQHintModifyClusterInfo", @"ClusterInfo");
	else if([_kWorkflowUnitAddMember isEqualToString:unitName])
		return L(@"LQHintAddMember", @"ClusterInfo");
	else if([_kWorkflowUnitRemoveMember isEqualToString:unitName])
		return L(@"LQHintRemoveMember", @"ClusterInfo");
	else
		return kStringEmpty;
}

- (void)workflow:(NSString*)workflowName end:(BOOL)success {
	// refresh ui
	[m_piBusy stopAnimation:self];
	[m_piBusy setHidden:YES];
	[m_txtHint setStringValue:kStringEmpty];
	[m_btnModify setEnabled:YES];
	[m_btnCancel setEnabled:YES];
	[m_btnApply setEnabled:YES];
	
	// get message
	NSString* message = kStringEmpty;
	if([_kWorkflowModifyCard isEqualToString:workflowName])
		message = success ? L(@"LQInfoModifyCardOK", @"ClusterInfo") : L(@"LQInfoModifyCardFailed", @"ClusterInfo");
	else if([_kWorkflowModifyInfos isEqualToString:workflowName])
		message = success ? L(@"LQInfoModifyInfoOK", @"ClusterInfo") : L(@"LQInfoModifyInfoFailed", @"ClusterInfo");
	else if([_kWorkflowModifyMessageSetting isEqualToString:workflowName])
		message = success ? L(@"LQInfoModifyMessageSettingOK", @"ClusterInfo") : L(@"LQInfoModifyMessageSettingFailed", @"ClusterInfo");
	
	// show alert sheet
	if(m_showAlert) {
		[AlertTool showWarning:[self window]
						 title:(success ? L(@"LQSuccess") : L(@"LQFailed"))
					   message:message
					  delegate:self
				didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)];	
	}
}

- (BOOL)needExecuteWorkflowUnit:(NSString*)unitName {
	if([_kWorkflowUnitAddMember isEqualToString:unitName])
		return [m_newMembers count] > 0;
	else if([_kWorkflowUnitRemoveMember isEqualToString:unitName])
		return [m_oldMembers count] > 0;
	else
		return YES;
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventClusterGetMessageSettingOK:
			ret = [self handleGetMessageSettingOK:event];
			break;
		case kQQEventClusterGetLastTalkTimeOK:
			ret = [self handleGetLastTalkTimeOK:event];
			break;
		case kQQEventClusterGetChannelSettingOK:
			ret = [self handleGetChannelSettingOK:event];
			break;
		case kQQEventClusterGetInfoOK:
			ret = [self handleGetClusterInfoOK:event];
			break;
		case kQQEventClusterGetMemberInfoOK:
			ret = [self handleGetMemberInfoOK:event];
			break;
		case kQQEventClusterGetCardOK:
			ret = [self handleGetCardOK:event];
			break;
		case kQQEventClusterModifyMessageSettingOK:
			ret = [self handleModifyMessageSettingOK:event];
			break;
		case kQQEventClusterModifyCardOK:
			ret = [self handleModifyCardOK:event];
			break;
		case kQQEventClusterModifyInfoOK:
			ret = [self handleModifyClusterInfoOK:event];
			break;
		case kQQEventClusterModifyChannelSettingOK:
			ret = [self handleModifyChannelSettingOK:event];
			break;
		case kQQEventClusterModifyMemberOK:
			ret = [self handleModifyMemberOK:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleGetMessageSettingOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	NSEnumerator* e = [[packet messageSettings] objectEnumerator];
	while(ClusterMessageSetting* setting = [e nextObject]) {		
		// refresh ui
		if([setting internalId] == [m_cluster internalId]) {
			if([setting messageSetting] == kQQClusterMessageClearServerSetting)
				[m_chkSaveInServer setState:NSOffState];
			else {
				[m_chkSaveInServer setState:NSOnState];
				[m_matrixMessage selectCellWithTag:[setting messageSetting]];
			}
		}
	}
	return YES;
}

- (BOOL)handleGetLastTalkTimeOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	NSEnumerator* e = [[packet lastTalkTimes] objectEnumerator];
	while(LastTalkTime* time = [e nextObject]) {
		User* user = [[m_mainWindowController groupManager] user:[time QQ]];
		if(user)
			[user setLastTalkTime:[m_cluster internalId] time:([time days] * 24 * 3600)];
	}
	
	// reload
	[m_memberTable reloadData];
	
	return YES;
}

- (BOOL)handleGetChannelSettingOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	[m_cluster setNotificationRight:[packet notificationRight]];
	[m_matrixNotification selectCellWithTag:[packet notificationRight]];
	return YES;
}

- (BOOL)handleGetClusterInfoOK:(QQNotification*)event {
	[m_members removeAllObjects];
	[m_members addObjectsFromArray:[m_cluster members]];
	[self reloadInfo];
	
	// refresh ui
	if([self isSuperUser]) {
		[m_btnModify setHidden:NO];
		[m_btnRemove setHidden:NO];
		[m_btnSetMembers setHidden:NO];
		[m_btnCancel setTitle:L(@"LQCancel")];
		[m_btnApply setTitle:L(@"LQApply")];
	} else {
		[m_btnModify setHidden:YES];
		[m_btnRemove setHidden:YES];
		[m_btnSetMembers setHidden:YES];
		[m_btnCancel setTitle:L(@"LQUpdate")];
		[m_btnApply setTitle:L(@"LQClose")];
	}
	return NO;
}

- (BOOL)handleGetMemberInfoOK:(QQNotification*)event {
	[self reloadInfo];
	return NO;
}

- (BOOL)handleGetCardOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	[[m_mainWindowController me] setNameCard:[m_cluster internalId] card:[packet clusterNameCard]];
	[self reloadInfo];
	return YES;
}

- (BOOL)handleModifyMessageSettingOK:(QQNotification*)event {
	[m_cluster setMessageSetting:[m_matrixMessage selectedTag]];
	return YES;
}

- (BOOL)handleModifyCardOK:(QQNotification*)event {
	return NO;
}

- (BOOL)handleModifyClusterInfoOK:(QQNotification*)event {
	return YES;
}

- (BOOL)handleModifyChannelSettingOK:(QQNotification*)event {
	return YES;
}

- (BOOL)handleModifyMemberOK:(QQNotification*)event {
	return YES;
}

#pragma mark -
#pragma mark table datasource

- (int)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [m_members count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
	User* user = [m_members objectAtIndex:rowIndex];
	switch([[aTableColumn identifier] intValue]) {
		case 0:
			if([user isCreator:m_cluster])
				return [NSImage imageNamed:kImageClusterCreator];
			else if([user isAdmin:m_cluster])
				return [NSImage imageNamed:kImageClusterAdmin];
			else if([user isStockholder:m_cluster])
				return [NSImage imageNamed:kImageClusterStockholder];
			else
				return nil;
			return nil;
		case 1:
			return user;
		case 2:
			return [user nick];
		case 3:
			return [user isMM] ? L(@"LQFemale") : L(@"LQMale");
		case 4:
			UInt32 time = [user lastTalkTime:[m_cluster internalId]];
			if(time == 0)
				return kStringEmpty;
			else {
				NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
				NSDateFormatter* df = [[[NSDateFormatter alloc] init] autorelease];
				[df setDateStyle:NSDateFormatterShortStyle];
				return [df stringFromDate:date];
			};
		default:
			return kStringEmpty;
	}
}

#pragma mark - 
#pragma mark table delegate

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
	[self updateMemberPanelButtons];
}

#pragma mark -
#pragma mark tab view delegate

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
	// close selector if current tab item is not member tab
	if(m_treeSelector) {
		if(![[tabViewItem identifier] isEqual:@"2"]) {
			[m_treeSelector close];
			m_treeSelector = nil;
		}
	}
	
	// change button title
	if(![self isSuperUser]) {
		switch([[tabViewItem identifier] intValue]) {
			case 3:
			case 4:
				[m_btnCancel setTitle:L(@"LQModify")];
				[m_btnApply setTitle:L(@"LQClose")];
				break;
			default:
				[m_btnCancel setTitle:L(@"LQUpdate")];
				[m_btnApply setTitle:L(@"LQClose")];
				break;
		}
	} 
}

#pragma mark -
#pragma mark tree selector data source

- (float)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
	return kSizeSmall.height + 2;
}

- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if(item == nil)
		return [[m_mainWindowController groupManager] friendlyGroupCount];
	else if([item isMemberOfClass:[Group class]])
		return [item userCount];
	else
		return 0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	if([item isMemberOfClass:[Group class]])
		return [item userCount] > 0;
	else
		return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	return item;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item {
	if(item == nil)
		return [[m_mainWindowController groupManager] group:index];
	else if([item isMemberOfClass:[Group class]])
		return [item user:index];
	else
		return nil;
}

- (id)outlineView:(NSOutlineView*)outlineView parentOfItem:(id)item {
	return nil;
}

#pragma mark -
#pragma mark level combo box data source

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index {
	if(aComboBox == m_cbLevel1)
		return LEVEL1VALUE(index);
	else if(aComboBox == m_cbLevel2)
		return LEVEL2VALUE([m_cbLevel1 indexOfSelectedItem], index);
	else if(aComboBox == m_cbLevel3)
		return LEVEL3VALUE([m_cbLevel1 indexOfSelectedItem], [m_cbLevel2 indexOfSelectedItem], index);
	else
		return kStringEmpty;
}

- (int)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	if(aComboBox == m_cbLevel1)
		return LEVEL1COUNT;
	else if(aComboBox == m_cbLevel2)
		return LEVEL2COUNT([m_cbLevel1 indexOfSelectedItem]);
	else if(aComboBox == m_cbLevel3)
		return LEVEL3COUNT([m_cbLevel1 indexOfSelectedItem], [m_cbLevel2 indexOfSelectedItem]);
	else
		return 0;
}

#pragma mark -
#pragma mark level combo box delegate

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
	NSComboBox* combo = [notification object];
	if(combo == m_cbLevel1) {
		[m_cbLevel2 setStringValue:kStringEmpty];
		[m_cbLevel3 setStringValue:kStringEmpty];
		[m_cbLevel2 reloadData];
		[m_cbLevel3 reloadData];
	} else if(combo == m_cbLevel2) {
		[m_cbLevel3 setStringValue:kStringEmpty];
		[m_cbLevel3 reloadData];
	}
}

@end
