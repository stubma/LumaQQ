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

#import "TreeSelectorWindowController.h"
#import "MainWindowController.h"
#import "QQCell.h"

@implementation TreeSelectorWindowController

- (id)initWithMainWindow:(MainWindowController*)mainWindowController dataSource:(id)source {
	self = [super initWithWindowNibName:@"TreeSelector"];
	if (self != nil) {
		m_mainWindowController = [mainWindowController retain];
		m_dataSource = [source retain];
		m_canClose = YES;
	}
	return self;
}

- (void) dealloc {
	[m_mainWindowController release];
	[m_dataSource release];
	[super dealloc];
}

- (void)windowDidLoad {
	// init outline
	QQCell* cell = [[[QQCell alloc] initWithQQ:[[m_mainWindowController me] QQ]] autorelease];
	[cell setCheckStyle:YES];
	[cell setShowStatus:NO];
	[cell setMemberStyle:YES];
	[[m_tree tableColumnWithIdentifier:@"0"] setDataCell:cell];
	[m_tree setDataSource:m_dataSource];
	[m_tree reloadData];
}

- (QQCell*)QQCell {
	return [[m_tree tableColumnWithIdentifier:@"0"] dataCell];
}

- (BOOL)windowShouldClose:(id)sender {
	return m_canClose;
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	[self release];
}

- (QQOutlineView*)tree {
	return m_tree;
}

- (void)setCanClose:(BOOL)value {
	m_canClose = value;
}

@end
