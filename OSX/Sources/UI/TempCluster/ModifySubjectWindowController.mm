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

#import "ModifySubjectWindowController.h"
#import "MainWindowController.h"
#import "AlertTool.h"
#import "ArrayTool.h"
#import "NSString-Validate.h"
#import "ClusterMemberTreeDataSource.h"

#define _kSheetModifyFailed 0
#define _kSheetModifySuccess 1

@implementation ModifySubjectWindowController

- (id)initWithTempCluster:(Cluster*)cluster parentCluster:(Cluster*)parentCluster mainWindow:(MainWindowController*)mainWindowController {
	self = [super initWithTempCluster:cluster
						parentCluster:parentCluster
						   mainWindow:mainWindowController];
	if (self != nil) {
		m_addArray = [[NSMutableArray array] retain];
		m_removeArray = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_addArray release];
	[m_removeArray release];
	[super dealloc];
}

- (id)createDataSource {
	return [[[ClusterMemberTreeDataSource alloc] initWithCluster:m_parentCluster] autorelease];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	[[m_mainWindowController windowRegistry] unregisterTempClusterInfoWindow:[m_cluster internalId]];
	[super windowWillClose:aNotification];
}

- (void)windowDidEndSheet:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	switch(m_sheetType) {
		case _kSheetModifyFailed:
		case _kSheetModifySuccess:
			[self close];
			break;
	}
	
	m_sheetType = -1;
}

- (void)initializeUI {
	[m_txtName setStringValue:[m_cluster name]];
	
	[m_members addObjectsFromArray:[m_cluster members]];
	[m_memberTable reloadData];
	
	NSEnumerator* e = [m_members objectEnumerator];
	while(User* user = [e nextObject])
		[[m_treeSelector QQCell] set:user state:NSOnState];
	[self refreshClusterState:m_parentCluster cell:[m_treeSelector QQCell]];
	[[m_treeSelector tree] expandAll];
	
	// if no member here, means temp cluster info is not got
	if([m_cluster memberCount] == 0) {
		[m_btnAction setEnabled:NO];
		[self setHint:L(@"LQHintGetSubjectInfo", @"TempClusterBase")];
	}
}

- (NSString*)windowTitle {
	return [NSString stringWithFormat:L(@"LQTitleModifySubject", @"TempClusterBase"), [m_cluster name]];
}

- (NSString*)actionButtonTitle {
	return L(@"LQModify");
}

- (void)handleQQCellDidSelected:(NSNotification*)notification {
	QQCell* cell = [notification object];
	if([[m_treeSelector QQCell] identifier] != [cell identifier]) 
		return;
	
	id obj = [[notification userInfo] objectForKey:kUserInfoObjectValue];
	NSCellStateValue state = (NSCellStateValue)[[[notification userInfo] objectForKey:kUserInfoState] intValue];
	if([obj isMemberOfClass:[User class]]) {
		// can't remove me, I must in the member list
		User* user = (User*)obj;
		
		// refresh cluster state
		[self refreshClusterState:m_parentCluster cell:cell];
		
		// if not me, add/remove from member list
		if([user QQ] != [[m_mainWindowController me] QQ]) {
			if(state == NSOnState) {
				if([m_members containsObject:user])
					return;
				[m_members addObject:user];
			} else
				[m_members removeObject:user];
			[m_memberTable reloadData];
		}
		
		// refresh tree selector
		[[m_treeSelector tree] reloadData];
	} else if([obj isMemberOfClass:[Cluster class]]) {		
		NSEnumerator* e = [[(Cluster*)obj members] objectEnumerator];
		while(User* user = [e nextObject]) {
			[cell set:user state:state];	
			if([user QQ] != [[m_mainWindowController me] QQ]) {
				if(state == NSOnState) {
					if(![m_members containsObject:user])
						[m_members addObject:user];
				} else {
					[m_members removeObject:user];
				}
			}
		}
		[m_memberTable reloadData];
		
		[[m_treeSelector tree] reloadData];
	}
}

- (IBAction)onAction:(id)sender {
	if([[m_txtName stringValue] isEmpty]) {
		[AlertTool showWarning:[self window]
					   message:L(@"LQWarningEmptyName", @"TempClusterBase")];
	} else if([m_members count] < 2) {
		[AlertTool showWarning:[self window]
					   message:L(@"LQWarningNeedMoreMember", @"TempClusterBase")];
	} else {
		// close member selection panel
		[m_treeSelector close];
		m_treeSelector = nil;
		
		// disable button
		[m_btnAction setEnabled:NO];
		
		// get add and remove list
		[m_addArray addObjectsFromArray:m_members];
		[m_removeArray addObjectsFromArray:[m_cluster members]];
		NSEnumerator* e = [m_removeArray objectEnumerator];
		while(User* user = [e nextObject]) {
			if([m_addArray containsObject:user]) {
				[m_addArray removeObject:user];
				[m_removeArray removeObject:user];
			}
		}
		
		// start modify
		[self setHint:L(@"LQHintModifySubjectName", @"TempClusterBase")];
		m_waitingSequence = [[m_mainWindowController client] modifySubjectInfo:[m_cluster internalId]
																		parent:[m_parentCluster internalId]
																		  name:[m_txtName stringValue]];
	}
}

#pragma mark -
#pragma mark helper

- (void)refreshClusterState:(Cluster*)c cell:(QQCell*)cell {
	if(c) {
		int count = [c memberCount];
		NSEnumerator* e = [[c members] objectEnumerator];
		while(User* user = [e nextObject]) {
			if([cell state:user] == NSOnState)
				count--;
		}
		if(count == 0)
			[cell set:c state:NSOnState];
		else if(count == [c memberCount])
			[cell set:c state:NSOffState];
		else
			[cell set:c state:NSMixedState];
	}
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventClusterGetInfoOK:
			ret = [self handleGetClusterInfoOK:event];
			break;
		case kQQEventClusterGetMemberInfoOK:
			ret = [self handleGetMemberInfoOK:event];
			break;
		case kQQEventTempClusterGetInfoOK:
			ret = [self handleGetTempClusterInfoOK:event];
			break;
		case kQQEventTempClusterModifyInfoOK:
			ret = [self handleModifyTempClusterInfoOK:event];
			break;
		case kQQEventTempClusterModifyInfoFailed:
			ret = [self handleModifyTempClusterInfoFailed:event];
			break;
		case kQQEventTempClusterModifyMemberOK:
			ret = [self handleModifyTempClusterMemberOK:event];
			break;
		case kQQEventTempClusterModifyMemberFailed:
			ret = [self handleModifyTempClusterMemberFailed:event];
			break;
		case kQQEventTimeoutBasic:
			OutPacket* packet = [event outPacket];
			switch([packet command]) {
				case kQQCommandCluster:
					ClusterCommandPacket* ccp = (ClusterCommandPacket*)packet;
					switch([ccp subCommand]) {
						case kQQSubCommandTempClusterModifyInfo:
						case kQQSubCommandTempClusterModifyMember:
							if(m_waitingSequence == [ccp sequence]) {
								m_sheetType = _kSheetModifyFailed;
								[AlertTool showWarning:[self window]
											   message:L(@"LQWarningModifyFailed", @"TempClusterBase")];
							}
							break;
					}
					break;
			}
			break;
	}
	
	return ret;
}

- (BOOL)handleGetClusterInfoOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if([packet internalId] == [m_parentCluster internalId]) {
		[self refreshClusterState:m_parentCluster cell:[m_treeSelector QQCell]];
		[[m_treeSelector tree] reloadData];
		[m_memberTable reloadData];
	}
	return NO;
}

- (BOOL)handleGetMemberInfoOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if([packet internalId] == [m_parentCluster internalId]) {
		[m_memberTable reloadData];
		[[m_treeSelector tree] reloadData];
	}
	return NO;
}

- (BOOL)handleGetTempClusterInfoOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if([packet internalId] == [m_cluster internalId]) {
		[m_txtName setStringValue:[[packet info] name]];
		
		[m_members removeAllObjects];
		[m_members addObjectsFromArray:[m_cluster members]];
		[m_memberTable reloadData];
		
		[[m_treeSelector QQCell] clearState];
		NSEnumerator* e = [m_members objectEnumerator];
		while(User* user = [e nextObject])
			[[m_treeSelector QQCell] set:user state:NSOnState];
		[self refreshClusterState:m_parentCluster cell:[m_treeSelector QQCell]];
		[[m_treeSelector tree] expandAll];
		
		[self setHint:nil];
		[m_btnAction setEnabled:YES];
	}
	return NO;
}

- (BOOL)handleModifyTempClusterInfoOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if(m_waitingSequence == [packet sequence]) {
		if([m_addArray count] != 0) {
			[self setHint:L(@"LQHintAddSubjectMember", @"TempClusterBase")];
			m_waitingSequence = [[m_mainWindowController client] addSubjectMember:[m_cluster internalId]
																		   parent:[m_parentCluster internalId]
																		  members:[ArrayTool userArray2QQArray:m_addArray]];
			[m_addArray removeAllObjects];
		} else if([m_removeArray count] != 0) {
			[self setHint:L(@"LQHintRemoveSubjectMember", @"TempClusterBase")];
			m_waitingSequence = [[m_mainWindowController client] removeSubjectMember:[m_cluster internalId]
																			  parent:[m_parentCluster internalId]
																			 members:[ArrayTool userArray2QQArray:m_removeArray]];
			[m_removeArray removeAllObjects];
		} else {
			// refresh temp cluster info
			[[m_mainWindowController client] getSubjectInfo:[m_cluster internalId]
													 parent:[m_parentCluster internalId]];
			
			// show success info
			[self setHint:nil];
			m_sheetType = _kSheetModifySuccess;
			[AlertTool showWarning:[self window]
						   message:L(@"LQInfoModifySuccess", @"TempClusterBase")];
		}
		return YES;
	}
	
	return NO;
}

- (BOOL)handleModifyTempClusterInfoFailed:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if(m_waitingSequence == [packet sequence]) {
		[self setHint:nil];
		m_sheetType = _kSheetModifyFailed;
		[AlertTool showWarning:[self window]
					   message:L(@"LQWarningModifyFailed", @"TempClusterBase")];
		return YES;
	}
	
	return NO;
}

- (BOOL)handleModifyTempClusterMemberOK:(QQNotification*)event {
	return [self handleModifyTempClusterInfoOK:event];
}

- (BOOL)handleModifyTempClusterMemberFailed:(QQNotification*)event {
	return [self handleModifyTempClusterInfoFailed:event];
}

@end
