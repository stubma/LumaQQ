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

#import "QQOutlineView.h"
#import "QQOutlineViewDataSource.h"

@implementation QQOutlineView

- (void)draggedImage:(NSImage *)anImage beganAt:(NSPoint)aPoint {
	// reload outline view to make group unexpandable
	[[self dataSource] outlineViewBeginDragging:self];
	[self saveExpandedStatus];
	[self reloadData];
}

- (void)draggedImage:(NSImage *)anImage endedAt:(NSPoint)aPoint operation:(NSDragOperation)operation {
	// end dragging, restore expanded status
	[[self dataSource] outlineViewEndDragging:self];
	[self reloadData];
	[self restoreExpandedStatus];
}

- (void)draggedImage:(NSImage *)anImage endedAt:(NSPoint)aPoint deposited:(BOOL)flag {
	// end dragging, restore expanded status
	[[self dataSource] outlineViewEndDragging:self];
	[self reloadData];
	[self restoreExpandedStatus];
}

- (void) dealloc {
	if(m_expandedItems)
		[m_expandedItems release];
	if(m_tooltipTracker)
		[m_tooltipTracker release];
	[super dealloc];
}

#pragma mark -
#pragma mark API

- (void)setTooltipDelegate:(id)delegate {
	if(m_tooltipTracker == nil) {
		m_tooltipTracker = [[SmoothTooltipTracker smoothTooltipTrackerForView:self
																 withDelegate:delegate] retain];
	}
}

- (void)expandAll {
	id dataSource = [self dataSource];
	int count = [dataSource outlineView:self numberOfChildrenOfItem:nil];
	for(int i = 0; i < count; i++) {
		id item = [dataSource outlineView:self child:i ofItem:nil];
		[self expandItem:item];
	}
}

- (void)saveExpandedStatus {
	if(m_expandedItems == nil)
		m_expandedItems = [[NSMutableArray array] retain];
	[m_expandedItems removeAllObjects];
	id dataSource = [self dataSource];
	int count = [dataSource outlineView:self numberOfChildrenOfItem:nil];
	for(int i = 0; i < count; i++) {
		id item = [dataSource outlineView:self child:i ofItem:nil];
		if([self isItemExpanded:item])
			[m_expandedItems addObject:item];
	}
}

- (void)restoreExpandedStatus {
	// collapse all
	id dataSource = [self dataSource];
	int count = [dataSource outlineView:self numberOfChildrenOfItem:nil];
	for(int i = 0; i < count; i++) {
		id item = [dataSource outlineView:self child:i ofItem:nil];
		[self collapseItem:item];
	}
	
	// expand
	if(m_expandedItems) {
		NSEnumerator* e = [m_expandedItems objectEnumerator];
		while(id item = [e nextObject])
			[self expandItem:item];
	}
}

@end
