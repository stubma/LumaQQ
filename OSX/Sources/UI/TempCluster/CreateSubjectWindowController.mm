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

#import "CreateSubjectWindowController.h"
#import "MainWindowController.h"
#import "AlertTool.h"
#import "ArrayTool.h"
#import "NSString-Validate.h"
#import "ClusterMemberTreeDataSource.h"

#define _kSheetCreateFailed 0
#define _kSheetCreateSuccess 1

@implementation CreateSubjectWindowController

- (void)windowDidEndSheet:(NSNotification *)aNotification {
	switch(m_sheetType) {
		case _kSheetCreateFailed:
		case _kSheetCreateSuccess:
			[self close];
			break;
	}
	
	m_sheetType = -1;
}

- (id)createDataSource {
	return [[[ClusterMemberTreeDataSource alloc] initWithCluster:m_parentCluster] autorelease];
}

- (NSString*)windowTitle {
	return [NSString stringWithFormat:L(@"LQTitleCreateSubject", @"TempClusterBase"), [m_parentCluster name], [m_parentCluster externalId]];
}

- (NSString*)actionButtonTitle {
	return L(@"LQCreate");
}

- (void)initializeUI {
	[[m_treeSelector QQCell] set:[m_mainWindowController me] state:NSOnState];
	[self refreshClusterState:m_parentCluster cell:[m_treeSelector QQCell]];
	[[m_treeSelector tree] expandAll];
	[m_members addObject:[m_mainWindowController me]];
	[m_memberTable reloadData];
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
		
		// start create
		[self setHint:L(@"LQHintCreateSubject", @"TempClusterBase")];
		m_waitingSequence = [[m_mainWindowController client] createSubject:[m_txtName stringValue]
																	parent:[m_parentCluster internalId]
																   members:[ArrayTool userArray2QQArray:m_members]];
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
		case kQQEventTempClusterCreateOK:
			ret = [self handleCreateTempClusterOK:event];
			break;
		case kQQEventTempClusterCreateFailed:
			ret = [self handleCreateTempClusterFailed:event];
			break;
		case kQQEventTempClusterActivateOK:
			ret = [self handleActivateTempClusterOK:event];
			break;
		case kQQEventTempClusterActivateFailed:
			ret = [self handleActivateTempClusterFailed:event];
			break;
		case kQQEventTimeoutBasic:
			OutPacket* packet = [event outPacket];
			switch([packet command]) {
				case kQQCommandCluster:
					ClusterCommandPacket* ccp = (ClusterCommandPacket*)packet;
					switch([ccp subCommand]) {
						case kQQSubCommandTempClusterCreate:
						case kQQSubCommandTempClusterActivate:
							if(m_waitingSequence == [ccp sequence]) {
								m_sheetType = _kSheetCreateFailed;
								[AlertTool showWarning:[self window]
											   message:L(@"LQWarningCreateFailed", @"TempClusterBase")];
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
	}
	return NO;
}

- (BOOL)handleGetMemberInfoOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if([packet internalId] == [m_parentCluster internalId])
		[[m_treeSelector tree] reloadData];
	return NO;
}

- (BOOL)handleCreateTempClusterOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if(m_waitingSequence == [packet sequence]) {
		// create temp cluster object
		if(m_cluster)
			[m_cluster release];
		m_cluster = [[Cluster alloc] initWithInternalId:[packet internalId]
												 domain:m_mainWindowController];
		[m_cluster setName:[m_txtName stringValue]];
		[m_cluster setPermanent:NO];
		[m_cluster setTempType:kQQTempClusterTypeSubject];
		[m_cluster setParentId:[m_parentCluster internalId]];
		[[m_cluster info] setCreator:[[m_mainWindowController me] QQ]];
		[m_cluster setMembers:m_members];
		
		// activate it
		[self setHint:L(@"LQHintActivateSubject", @"TempClusterBase")];
		m_waitingSequence = [[m_mainWindowController client] activateSubject:[m_cluster internalId]
																	  parent:[m_parentCluster internalId]];
		
		return YES;
	}
	
	return NO;
}

- (BOOL)handleCreateTempClusterFailed:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if(m_waitingSequence == [packet sequence]) {
		[self setHint:nil];
		m_sheetType = _kSheetCreateFailed;
		[AlertTool showWarning:[self window]
					   message:L(@"LQWarningCreateFailed", @"TempClusterBase")];
		return YES;
	}
	
	return NO;
}

- (BOOL)handleActivateTempClusterOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if(m_waitingSequence == [packet sequence]) {
		[self setHint:nil];
		
		// add subject to parent cluster
		[[m_mainWindowController groupManager] addCluster:m_cluster];
		
		// refresh ui
		[[m_mainWindowController clusterOutline] reloadItem:[m_parentCluster subjectsDummy]
											 reloadChildren:YES];
		
		// show success hint
		m_sheetType = _kSheetCreateSuccess;
		[AlertTool showWarning:[self window]
						 title:L(@"LQSuccess")
					   message:L(@"LQInfoCreateSuccess", @"TempClusterBase")
					  delegate:nil
				didEndSelector:nil];
		
		return YES;
	}
	
	return NO;
}

- (BOOL)handleActivateTempClusterFailed:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if(m_waitingSequence == [packet sequence]) {
		[self setHint:nil];
		m_sheetType = _kSheetCreateFailed;
		[AlertTool showWarning:[self window]
					   message:L(@"LQWarningCreateFailed", @"TempClusterBase")];
		return YES;
	}
	
	return NO;
}

@end
