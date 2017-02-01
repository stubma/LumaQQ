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

#import "UserOutlineDataSource.h"
#import "Group.h"
#import "User.h"
#import "QQCell.h"
#import "QQConstants.h"
#import "PreferenceCache.h"
#import "QQOutlineView.h"
#import "MainWindowController.h"

#define _kVerySmallHeight 0.0001

@implementation UserOutlineDataSource

- (void) dealloc {
	[m_mainWindowController release];
	[super dealloc];
}

- (id)initWithMainWindow:(MainWindowController*)mainWindowController {
	self = [super init];
	if(self) {
		m_mainWindowController = [mainWindowController retain];
		m_dragging = NO;
	}
	return self;
}

#pragma mark -
#pragma mark data source implementation

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item {
	if(item == nil)
		return [[m_mainWindowController groupManager] group:index];
	else if([item isMemberOfClass:[Group class]])
		return [item user:index];
	else
		return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	if(m_dragging)
		return NO;
	else if(item == nil)
		return YES;
	else if([item isMemberOfClass:[Group class]])
		return [item userCount] > 0;
	else
		return NO;
}

- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if(item == nil)
		return [[m_mainWindowController groupManager] userGroupCount];
	else if([item isMemberOfClass:[Group class]])
		return [item userCount];
	else
		return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	return item;
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
}

- (float)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
	// online only option is first
	if(m_showOnlineOnly && [item isMemberOfClass:[User class]]) {
		if([(User*)item status] == kQQStatusOffline)
			return _kVerySmallHeight;
	}
	
	// get height according large/small head mode
	int height = m_showLargeHead ? kSizeLarge.height : kSizeSmall.height;
	
	// search
	BOOL notFiltered = YES;	
	if((m_searchMode & kFlagSearchByName) != 0)
		notFiltered = [self searchByRemark:item];
	if(!notFiltered && (m_searchMode & kFlagSearchByNick) != 0)
		notFiltered = [self searchByNick:item];
	if(!notFiltered && (m_searchMode & kFlagSearchByQQ) != 0)
		notFiltered = [self searchByQQ:item];
	if(!notFiltered && (m_searchMode & kFlagSearchBySignature) != 0)
		notFiltered = [self searchBySignature:item];
	
	// if need to be filtered
	if(!notFiltered)
		return _kVerySmallHeight;
	
	// last is default
	if([item isMemberOfClass:[Group class]])
		return kSizeSmall.height + kSpacing + kSpacing;
	else
		return height + kSpacing + kSpacing;	
}

- (BOOL)searchByQQ:(id)item {
	if([item isMemberOfClass:[User class]]) {
		User* u = (User*)item;
		NSString* qqStr = [NSString stringWithFormat:@"%u", [u QQ]];
		NSRange range = [qqStr rangeOfString:m_searchText options:NSCaseInsensitiveSearch];
		if(range.location == NSNotFound)
			return NO;
	}
	
	return YES;
}

- (BOOL)searchByNick:(id)item {
	if([item isMemberOfClass:[User class]]) {
		User* u = (User*)item;
		if(![u nick])
			return NO;
		else {
			NSRange range = [[u nick] rangeOfString:m_searchText options:NSCaseInsensitiveSearch];
			if(range.location == NSNotFound)
				return NO;
		}
	}
	
	return YES;
}

- (BOOL)searchByRemark:(id)item {
	if([item isMemberOfClass:[User class]]) {
		User* u = (User*)item;
		if(![u remarkName])
			return NO;
		else {
			NSRange range = [[u remarkName] rangeOfString:m_searchText options:NSCaseInsensitiveSearch];
			if(range.location == NSNotFound)
				return NO;
		}
	}
	
	return YES;
}

- (BOOL)searchBySignature:(id)item {
	if([item isMemberOfClass:[User class]]) {
		User* u = (User*)item;
		if(![u signature])
			return NO;
		else {
			NSRange range = [[u signature] rangeOfString:m_searchText options:NSCaseInsensitiveSearch];
			if(range.location == NSNotFound)
				return NO;
		}
	}
	
	return YES;
}

- (void)saveShowOnlineOnlyOption {
	m_showOnlineOnlyBackup = m_showOnlineOnly;
}

- (void)rollbackShowOnlineOnlyOption {
	m_showOnlineOnly = m_showOnlineOnlyBackup;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard {
	id item = [items objectAtIndex:0];
	if([item isMemberOfClass:[User class]]) {
		// set dragged user qq number
		[pboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
		[pboard setString:[NSString stringWithFormat:@"%u", [item QQ]] forType:NSStringPboardType];
		return YES;
	} else
		return NO;
}

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(int)index {	
	if(item != nil && [item isMemberOfClass:[Group class]] && index == -1)
		return NSDragOperationMove;
	else
		return NSDragOperationNone;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(int)index {	
	if(item != nil && [item isMemberOfClass:[Group class]]) {
		NSPasteboard* pboard = [info draggingPasteboard];
		NSString* sQQ = [pboard stringForType:NSStringPboardType];
		if(sQQ) {
			UInt32 QQ = [sQQ intValue];
			[m_mainWindowController moveUser:QQ toGroup:item reload:NO];
			return YES;
		}
	} 
	
	return NO;
}

- (void)outlineViewBeginDragging:(QQOutlineView*)outlineView {
	m_dragging = YES;
}

- (void)outlineViewEndDragging:(QQOutlineView*)outlineView {
	m_dragging = NO;
}

- (void)outlineViewItemWillExpand:(NSNotification *)notification {
	NSDictionary* userInfo = [notification userInfo];
	id item = [userInfo objectForKey:@"NSObject"];
	if([item isMemberOfClass:[Group class]]) {
		[item setExpanded:YES];
		[[m_mainWindowController groupManager] setDirty:YES];
	}
}

- (void)outlineViewItemWillCollapse:(NSNotification *)notification {
	NSDictionary* userInfo = [notification userInfo];
	id item = [userInfo objectForKey:@"NSObject"];
	if([item isMemberOfClass:[Group class]]) {
		[item setExpanded:NO];
		[[m_mainWindowController groupManager] setDirty:YES];
	}
}

#pragma mark -
#pragma mark getter and setter

- (void)setSearchMode:(int)searchMode {
	m_searchMode = searchMode;
}

- (void)setSearchText:(NSString*)searchText {
	[searchText retain];
	[m_searchText release];
	m_searchText = searchText;
}

- (void)setShowOnlineOnly:(BOOL)showOnlineOnly {
	m_showOnlineOnly = showOnlineOnly;
}

- (void)setShowLargeHead:(BOOL)showLargeHead {
	m_showLargeHead = showLargeHead;
}

@end
