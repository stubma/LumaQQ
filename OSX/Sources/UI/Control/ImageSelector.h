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
#import "ImageSelectorDataSource.h"
#import "ImageSelectorDelegate.h"
#import "SmoothTooltipTracker.h"

@interface ImageSelector : NSControl {
	id m_dataSource;
	id m_delegate;
	NSSegmentedCell* m_panelCell;
	NSSegmentedCell* m_navigateCell;
	NSSegmentedCell* m_buttonCell;
	
	NSRect m_panelCellFrame;
	NSRect m_navigateCellFrame;
	NSRect m_buttonCellFrame;
	NSRect m_gridRect;
	NSSize m_unitSize;
	
	int m_selectedPanel;
	int m_selectedPage;
	int m_totalPage;
	
	int m_rowColInPanel;
	int m_rowColInPage;
	int m_selectedRow;
	int m_selectedCol;
	int m_mouseRow;
	int m_mouseCol;
	
	BOOL m_oneShot; // if not press command key, then close window when select one image
	
	SmoothTooltipTracker* m_tooltipTracker;
}

- (int)selectedPanel;
- (int)selectedPage;
- (NSSize)minimumSize;
- (void)refreshNavigateStatus;
- (NSRect)rectForRow:(int)row column:(int)col;
- (void)rowColFromMouse:(NSPoint)pt x:(int*)pRow y:(int*)pCol;

// actions
- (IBAction)nextPage:(id)sender;
- (IBAction)previousPage:(id)sender;
- (IBAction)reloadData:(id)sender;
- (IBAction)onPanelChanged:(id)sender;
- (IBAction)onNavigate:(id)sender;
- (IBAction)onAuxiliaryButton:(id)sender;

// getter and setter
- (void)setDataSource:(id)object;
- (void)setDelegate:(id)delegate;
- (id)delegate;
- (void)setOneShot:(BOOL)oneShot;

@end
