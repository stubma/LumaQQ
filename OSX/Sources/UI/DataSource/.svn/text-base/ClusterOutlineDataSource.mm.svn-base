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
#import "ClusterOutlineDataSource.h"
#import "Cluster.h"
#import "QQCell.h"
#import "MainWindowController.h"
#import "LocalizedStringTool.h"

@implementation ClusterOutlineDataSource

- (void) dealloc {
	[m_groupManager release];
	[m_mainWindowController release];
	[m_childParentMapping release];
	[super dealloc];
}

- (id)initWithMainWindowController:(MainWindowController*)controller {
	self = [super init];
	if(self) {
		[controller retain];
		m_mainWindowController = controller;
		m_groupManager = [[m_mainWindowController groupManager] retain];
		m_childParentMapping = [[NSMutableDictionary dictionary] retain];
	}
	return self;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item {
	id child = nil;
	
	if(item == nil) {
		if(index == [m_groupManager clusterCount])
			child = [m_groupManager dialogsDummy];
		else
			child = [[m_groupManager clusterGroup] cluster:index];
	} else if([item isMemberOfClass:[Cluster class]]) {
		switch(index) {
			case 0:
				child = [item organizationsDummy];
				break;
			case 1:
				child = [item subjectsDummy];
				break;
		}
	} else if([item isMemberOfClass:[Dummy class]]) {
		switch([(Dummy*)item type]) {
			case kDummyDialogs:
				child = [m_groupManager dialogAtIndex:index];
				break;
			case kDummyOrganizations:
				Cluster* c = [m_groupManager cluster:[(Dummy*)item clusterInternalId]];
				int unorganizedMemberCount = [c unorganizedMemberCount];
				if(index >= unorganizedMemberCount)
					child = [c organizationInLevel:0 index:(index - unorganizedMemberCount)];
				else
					child = [c unorganizedMember:index];
				break;
			case kDummySubjects:
				c = [m_groupManager cluster:[(Dummy*)item clusterInternalId]];
				child = [c subClusterAtIndex:index];
				break;
		}
	} else if([item isMemberOfClass:[Organization class]]) {
		Cluster* c = [m_groupManager cluster:[(Organization*)item clusterInternalId]];
		if(c)
			child = [c memberInOrganization:[(Organization*)item ID] index:index];
	}
	
	// set mapping
	if(child && item)
		[m_childParentMapping setObject:item forKey:child];
	
	return child;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	if(item == nil)
		return YES;
	else if([item isMemberOfClass:[Cluster class]])
		return [item permanent];
	else if([item isMemberOfClass:[Dummy class]]) 
		return YES;
	else if([item isMemberOfClass:[Organization class]])
		return YES;
	else
		return NO;
}

- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if(item == nil)
		return [m_groupManager clusterCount] + 1; // +1 for dialogs
	else if([item isMemberOfClass:[Cluster class]])
		return [item permanent] ? 2 : 0;
	else if([item isMemberOfClass:[Dummy class]]) {
		switch([(Dummy*)item type]) {
			case kDummyDialogs:
				return [m_groupManager dialogCount];
			case kDummyOrganizations:
				Cluster* c = [m_groupManager cluster:[(Dummy*)item clusterInternalId]];
				if(c)
					return [c unorganizedMemberCount] + [c organizationCount:0];
				else
					return 0;
				break;
			case kDummySubjects:
				c = [m_groupManager cluster:[(Dummy*)item clusterInternalId]];
				return [c subClusterCount];
			default:
				return 0;
		}
	} else if([item isMemberOfClass:[Organization class]]) {
		Cluster* c = [m_groupManager cluster:[(Organization*)item clusterInternalId]];
		if(c)
			return [c memberCount:[(Organization*)item ID]];
		else
			return 0;
	} else
		return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	return item;
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
}

- (float)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
	return kSizeSmall.height + kSpacing + kSpacing;
}

- (void)outlineViewItemWillExpand:(NSNotification *)notification {
	NSOutlineView* outline = [notification object];
	NSDictionary* userInfo = [notification userInfo];
	id item = [userInfo objectForKey:@"NSObject"];
	if([item isMemberOfClass:[Dummy class]]) {
		Dummy* dummy = (Dummy*)item;
		switch([dummy type]) {
			case kDummySubjects:
				if(![dummy requested]) {
					[dummy setRequested:YES];
					
					/*
					 * In 2006, we can't get subject list any more! why? I don't know. Of coz it
					 * tencent's little secret.
					 */
//					[dummy setOperationSuffix:L(@"LQOperationSuffixGettInfo", @"MainWindow")];					
//					[[m_mainWindowController client] getSubjects:[dummy clusterInternalId]];
//					[outline reloadItem:item];
				}
				break;
			case kDummyOrganizations:
				if(![dummy requested]) {
					[dummy setOperationSuffix:L(@"LQOperationSuffixGettInfo", @"MainWindow")];
					[dummy setRequested:YES];
					[[m_mainWindowController client] getClusterInfo:[dummy clusterInternalId]];
					[[m_mainWindowController client] updateOrganization:[dummy clusterInternalId]];
					[outline reloadItem:item];
				}
				break;
		}
	}
}

- (id)outlineView:(NSOutlineView*)outlineView parentOfItem:(id)item {
	return [m_childParentMapping objectForKey:item];
}

@end
