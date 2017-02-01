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
#import "BaseIMContainer.h"
#import "Cluster.h"
#import "QQSplitView.h"

#define kToolbarItemSwitchMemberView @"ToolbarItemSwitchMemberView"

@interface ClusterIMContainerController : BaseIMContainer {
	Cluster* m_cluster;
	
	IBOutlet QQSplitView* m_split;
	IBOutlet NSView* m_memberView;
	IBOutlet NSTableView* m_memberTable;
	IBOutlet NSMenu* m_memberMenu;
	IBOutlet NSTextField* m_txtNotice;
	IBOutlet NSTextField* m_txtOnline;
	IBOutlet NSBox* m_box;
}

// action
- (IBAction)onUserInfo:(id)sender;
- (IBAction)onAddAsFriend:(id)sender;
- (IBAction)onSwitchMemberView:(id)sender;
- (IBAction)onTempSession:(id)sender;

// helper
- (void)adjustSplitView:(NSSplitView*)split belowProportion:(float)belowProportion;
- (NSString*)getUserDisplayName:(User*)user QQ:(UInt32)QQ;

// qq event handler
- (BOOL)handleClusterGetInfoOK:(QQNotification*)event;
- (BOOL)handleClusterGetMemberInfoOK:(QQNotification*)event;
- (BOOL)handleClusterGetOnlineMemberOK:(QQNotification*)event;
- (BOOL)handleClusterSendIMOK:(QQNotification*)event;
- (BOOL)handleClusterSendIMFailed:(QQNotification*)event;
- (BOOL)handleTempClusterSendIMOK:(QQNotification*)event;
- (BOOL)handleTempClusterSendIMFailed:(QQNotification*)event;
- (BOOL)handleTempClusterSendIMTimeout:(QQNotification*)event;
- (BOOL)handleClusterSendIMTimeout:(QQNotification*)event;
- (BOOL)handleClusterBatchGetCardOK:(QQNotification*)event;
- (BOOL)handleTempClusterGetInfoOK:(QQNotification*)event;

@end
