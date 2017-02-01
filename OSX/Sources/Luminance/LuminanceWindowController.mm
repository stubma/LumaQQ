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

#import "LuminanceWindowController.h"
#import "WindowRegistry.h"
#import "LuminanceView.h"
#import "LuminanceViewController.h"
#import "MainWindowController.h"
#import "LumaQQApplication.h"

// toolbar identifier
#define _kToolItemAddGeneral @"ToolbarItemGeneral"
#define _kToolItemAddActiveQQ @"ToolbarItemAddActiveQQ"
#define _kToolItemStartCatch @"ToolbarItemStartCatch"

@implementation LuminanceWindowController

- (id) init {
	self = [super initWithWindowNibName:@"Luminance"];
	return self;
}

- (void)windowDidLoad {
	m_toolbar = [[NSToolbar alloc] initWithIdentifier:@"LuminanceToolBar"];
	[m_toolbar setDisplayMode:NSToolbarDisplayModeLabelOnly];
	[m_toolbar setAllowsUserCustomization:NO];
	[m_toolbar setDelegate:self];
	[[self window] setToolbar:m_toolbar];
	
	// set initial general item
	NSTabViewItem* item = [m_tabView tabViewItemAtIndex:0];	
	LuminanceViewController* viewController = [[LuminanceViewController alloc] init];
	if([NSBundle loadNibNamed:@"LuminanceView" owner:viewController]) {
		LuminanceView* view = [viewController view];
		[view setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		[item setView:view];
	}
	[viewController release];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	// stop debug
	NSEnumerator* e = [[m_tabView tabViewItems] objectEnumerator];
	while(NSTabViewItem* item = [e nextObject]) {
		LuminanceView* view = [item view];
		[view endDebug];
	}
	
	[WindowRegistry unregisterLuminanceWindow];
	[self release];
}

#pragma mark -
#pragma mark actions

- (IBAction)onAddGeneral:(id)sender {
	NSTabViewItem* item = [[NSTabViewItem alloc] init];
	[item setLabel:@"General"];
	
	LuminanceViewController* viewController = [[LuminanceViewController alloc] init];
	if([NSBundle loadNibNamed:@"LuminanceView" owner:viewController]) {
		LuminanceView* view = [viewController view];
		[view setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		[item setView:view];
	}
	[viewController release];
	
	[m_tabView addTabViewItem:item];
	[item release];
}

- (IBAction)onAddActiveQQ:(id)sender {
	MainWindowController* main = [LumaQQApplication activeMainWindow];
	if(main != nil) {
		NSTabViewItem* item = [[NSTabViewItem alloc] init];
		[item setLabel:[NSString stringWithFormat:@"%u", [[main me] QQ]]];
		
		LuminanceViewController* viewController = [[LuminanceViewController alloc] init];
		if([NSBundle loadNibNamed:@"LuminanceView" owner:viewController]) {
			LuminanceView* view = [viewController view];
			[view setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
			[view setMainWindowController:main];
			[item setView:view];
		}
		[viewController release];
		
		[m_tabView addTabViewItem:item];
		[item release];
	}
}

- (IBAction)onCatch:(id)sender {
	LuminanceView* view = [self activeView];
	if([view isDebugging])
		[view endDebug];
	else
		[view beginDebug];
	[self updateToolItems];
}

#pragma mark -
#pragma mark helper

- (LuminanceView*)activeView {
	NSView* view = [[m_tabView selectedTabViewItem] view];
	if([view class] == [LuminanceView class])
		return (LuminanceView*)view;
	else
		return nil;
}

- (NSToolbarItem*)itemWithIdenifier:(NSString*)identifier {
	NSEnumerator* e = [[m_toolbar items] objectEnumerator];
	while(NSToolbarItem* item = [e nextObject]) {
		if([[item itemIdentifier] isEqual:identifier])
			return item;
	}
	return nil;
}

- (void)updateToolItems {
	NSToolbarItem* item = [self itemWithIdenifier:_kToolItemStartCatch];
	if(item == nil)
		return;
	
	LuminanceView* view = [self activeView];
	if(view == nil || ![view isDebugging])
		[item setLabel:@"Start Catch"];
	else
		[item setLabel:@"Stop Catch"];
	
	if(view != nil && [view canDebug]) {
		[item setTarget:self];
		[item setAction:@selector(onCatch:)];
	} else {
		[item setTarget:nil];
		[item setAction:nil];
	}
}

#pragma mark -
#pragma mark tab view delegate

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
	[self updateToolItems];
}

#pragma mark -
#pragma mark toolbar delegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
	if([itemIdentifier isEqualToString:_kToolItemAddGeneral]) {
		// create toolbar item
		NSToolbarItem* item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
		[item setLabel:@"Add General"];
		[item setTarget:self];
		[item setAction:@selector(onAddGeneral:)];
		return item;
	} else if([itemIdentifier isEqualToString:_kToolItemAddActiveQQ]) {
		// create toolbar item
		NSToolbarItem* item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
		[item setLabel:@"Add Active QQ"];
		[item setTarget:self];
		[item setAction:@selector(onAddActiveQQ:)];
		return item;
	} else if([itemIdentifier isEqualToString:_kToolItemStartCatch]) {
		// create toolbar item
		NSToolbarItem* item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
		LuminanceView* view = [self activeView];
		if(view == nil || ![view isDebugging])
			[item setLabel:@"Start Catch"];
		else
			[item setLabel:@"Stop Catch"];
		if(view != nil && [view canDebug]) {
			[item setTarget:self];
			[item setAction:@selector(onCatch:)];
		}
		return item;
	} else
		return nil;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
	return [NSArray arrayWithObjects:_kToolItemAddGeneral, _kToolItemAddActiveQQ, NSToolbarSeparatorItemIdentifier, _kToolItemStartCatch, nil];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
	return [NSArray arrayWithObjects:_kToolItemAddGeneral, _kToolItemAddActiveQQ, NSToolbarSeparatorItemIdentifier, _kToolItemStartCatch, nil];
}

@end
