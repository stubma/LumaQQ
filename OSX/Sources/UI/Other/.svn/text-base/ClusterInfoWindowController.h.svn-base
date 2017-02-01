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
#import "Cluster.h"
#import "HeadControl.h"
#import "TreeSelectorWindowController.h"
#import "WorkflowModerator.h"
#import "QQCell.h"
#import "Group.h"

@class MainWindowController;

@interface ClusterInfoWindowController : NSWindowController <WorkflowDataSource> {
	Cluster* m_cluster;
	MainWindowController* m_mainWindowController;
	
	// info panel
	IBOutlet NSTextField* m_txtId;
	IBOutlet NSTextField* m_txtCreator;
	IBOutlet NSTextField* m_txtName;
	IBOutlet HeadControl* m_headControl;
	IBOutlet NSComboBox* m_cbLevel1;
	IBOutlet NSComboBox* m_cbLevel2;
	IBOutlet NSComboBox* m_cbLevel3;
	IBOutlet NSTextView* m_txtNotice;
	IBOutlet NSTextView* m_txtDescription;
	
	// basic panel
	IBOutlet NSMatrix* m_matrixAuth;
	IBOutlet NSMatrix* m_matrixNotification;
	
	// member panel
	IBOutlet NSTableView* m_memberTable;
	IBOutlet NSButton* m_btnRemove;
	IBOutlet NSButton* m_btnAddAsFriend;
	IBOutlet NSButton* m_btnSetMembers;
	
	// message panel
	IBOutlet NSMatrix* m_matrixMessage;
	IBOutlet NSButton* m_chkSaveInServer;
	
	// name card panel
	IBOutlet NSTextField* m_txtNameCardName;
	IBOutlet NSPopUpButton* m_pbGender;
	IBOutlet NSTextField* m_txtPhone;
	IBOutlet NSTextField* m_txtEmail;
	IBOutlet NSTextView* m_txtRemark;
	IBOutlet NSButton* m_chkManaged;
	
	// other
	IBOutlet NSProgressIndicator* m_piBusy;
	IBOutlet NSTextField* m_txtHint;
	IBOutlet NSButton* m_btnModify;
	IBOutlet NSButton* m_btnApply;
	IBOutlet NSButton* m_btnCancel;
	IBOutlet NSTabView* m_tabMain;
	
	// member backup
	NSMutableArray* m_members;
	
	// temp array for add/remove members
	NSMutableArray* m_oldMembers;
	NSMutableArray* m_newMembers;
	
	// apply flag
	BOOL m_apply;
	BOOL m_showAlert;
	
	// selector flag
	TreeSelectorWindowController* m_treeSelector;
	
	// workflow
	WorkflowModerator* m_moderator;
	
	// check sheet type
	int m_sheetType;
}

- (id)initWithCluster:(Cluster*)cluster mainWindow:(MainWindowController*)mainWindowController;

// helper
- (BOOL)isSuperUser;
- (NSString*)titleOfCancelUpdateButton;
- (NSString*)titleOfApplyCloseButton;
- (void)reloadInfo;
- (void)handleTreeSelectorWindowWillClose:(NSNotification*)notification;
- (void)handleQQCellDidSelected:(NSNotification*)notification;
- (void)updateMemberPanelButtons;
- (void)startModify;
- (void)buildWorkflow:(NSString*)name;
- (void)diffMembers;
- (void)refreshGroupState:(Group*)g cell:(QQCell*)cell;

// action
- (IBAction)onOK:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onApply:(id)sender;
- (IBAction)onRemoveMember:(id)sender;
- (IBAction)onSetMembers:(id)sender;
- (IBAction)onAddAsFriend:(id)sender;

// qq event handler
- (BOOL)handleGetMessageSettingOK:(QQNotification*)event;
- (BOOL)handleGetLastTalkTimeOK:(QQNotification*)event;
- (BOOL)handleGetChannelSettingOK:(QQNotification*)event;
- (BOOL)handleGetClusterInfoOK:(QQNotification*)event;
- (BOOL)handleGetMemberInfoOK:(QQNotification*)event;
- (BOOL)handleGetCardOK:(QQNotification*)event;
- (BOOL)handleModifyMessageSettingOK:(QQNotification*)event;
- (BOOL)handleModifyCardOK:(QQNotification*)event;
- (BOOL)handleModifyClusterInfoOK:(QQNotification*)event;
- (BOOL)handleModifyChannelSettingOK:(QQNotification*)event;
- (BOOL)handleModifyMemberOK:(QQNotification*)event;

@end
