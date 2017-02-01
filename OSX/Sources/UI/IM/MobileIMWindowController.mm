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

#import "MobileIMWindowController.h"
#import "MainWindowController.h"
#import "AlertTool.h"
#import "LocalizedStringTool.h"
#import "Constants.h"

// toolbar identifier
#define _kToolBarMobileIMWindow @"MobileIMWindowToolBar"

// toolbar item
#define _kToolbarItemKeySetting @"ToolbarItemKeySetting"
#define _kToolbarItemHistory @"ToolbarItemHistory"

// sheet type
#define _kSheetCloseConfirm 0

@implementation MobileIMWindowController

- (id)initWithObject:(id)obj mainWindow:(MainWindowController*)mainWindowController {
	self = [super initWithWindowNibName:@"MobileIM"];
	if(self) {
		m_sheetType = -1;
		m_mainWindowController = [mainWindowController retain];
		m_mobileIMContainer = [[MobileIMContainerController alloc] initWithObject:obj mainWindow:mainWindowController];
		[NSBundle loadNibNamed:@"MobileIMContainer" owner:m_mobileIMContainer];
	}
	return self;
}

- (void) dealloc {
	if(m_shortcutWindowController)
		[m_shortcutWindowController release];
	[m_mobileIMContainer release];
	[m_historyDrawerController release];
	[m_mainWindowController release];
	[super dealloc];
}

- (void)windowDidLoad {
	[[self window] setContentView:[m_mobileIMContainer view]];
	
	// connect
	[[m_mobileIMContainer inputBox] setDelegate:self];
	
	// set window title
	[[self window] setTitle:[m_mobileIMContainer description]];
	
	// create history drawer
	m_historyDrawerController = [[HistoryDrawerController alloc] initWithMainWindow:m_mainWindowController history:[m_mobileIMContainer history]];
	[NSBundle loadNibNamed:@"HistoryDrawer" owner:m_historyDrawerController];
	[[m_historyDrawerController drawer] setParentWindow:[self window]];
	
	// set toolbar
	NSToolbar* toolbar = [[[NSToolbar alloc] initWithIdentifier:_kToolBarMobileIMWindow] autorelease];
	[toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
	[toolbar setSizeMode:NSToolbarSizeModeSmall];
	[toolbar setAllowsUserCustomization:NO];
	[toolbar setDelegate:self];
	[[self window] setToolbar:toolbar];
	
	// register
	[[m_mainWindowController windowRegistry] registerMobileIMWindow:[m_mobileIMContainer windowKey] window:self];
	
	// add qq listener
	[[m_mainWindowController client] addQQListener:m_mobileIMContainer];
	
	// set focus
	[[self window] setInitialFirstResponder:[m_mobileIMContainer inputBox]];
	
	// post notifiaction
	[[NSNotificationCenter defaultCenter] postNotificationName:kIMContainerAttachedToWindowNotificationName
														object:[m_mobileIMContainer view]
													  userInfo:[NSDictionary dictionaryWithObject:[self window] forKey:kUserInfoAttachToWindow]];
}

- (void)windowDidBecomeKey:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	// populate messages
	[m_mobileIMContainer walkMessageQueue:[m_mainWindowController messageQueue]];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	[[m_mainWindowController windowRegistry] unregisterMobileIMWindow:[m_mobileIMContainer windowKey]];
	[[m_mainWindowController client] removeQQListener:m_mobileIMContainer];
	[self release];
}

- (BOOL)windowShouldClose:(id)sender {
	if([m_mobileIMContainer pendingMessageCount] > 0) {
		[AlertTool showConfirm:[self window]
					   message:L(@"LQWarningHasPendingMessage", @"BaseIMContainer")
				 defaultButton:L(@"LQYes")
			   alternateButton:L(@"LQNo")
					  delegate:self
				didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)];
		return NO;
	} else
		return YES;
}

- (void)windowDidEndSheet:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	switch(m_sheetType) {
		case _kSheetCloseConfirm:
			[self close];
			break;
	}
	
	m_sheetType = -1;
}

- (IBAction)showWindow:(id)sender {
	[super showWindow:sender];
	[m_mobileIMContainer walkMessageQueue:[m_mainWindowController messageQueue]];
}

#pragma mark -
#pragma mark toolbar delegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
	NSToolbarItem* item = [m_mobileIMContainer actionItem:itemIdentifier];
	if(item == nil) {
		if([itemIdentifier isEqualToString:[m_mobileIMContainer owner]]) {
			item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
			
			// create control
			HeadControl* headControl = [[[HeadControl alloc] init] autorelease];
			[m_mobileIMContainer refreshHeadControl:headControl];
			[headControl setTarget:self];
			[headControl setAction:@selector(onHeadItem:)];
			
			// set control to item
			[item setView:headControl];
			
			// set size
			[item setMinSize:NSMakeSize(24, 24)];
			[item setMaxSize:NSMakeSize(24, 24)];
			
			// set tooltip
			[item setToolTip:[NSString stringWithFormat:L(@"LQTooltipOwner", @"BaseIMContainer"), [m_mobileIMContainer description]]];
		} else if([itemIdentifier isEqualToString:_kToolbarItemHistory]) {
			item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
			[item setImage:[NSImage imageNamed:kImageChatHistory]];
			[item setTarget:self];
			[item setAction:@selector(onHistory:)];
			[item setToolTip:L(@"LQTooltipHistory", @"BaseIMContainer")];
		} else if([itemIdentifier isEqualToString:_kToolbarItemKeySetting]) {
			item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
			[item setImage:[NSImage imageNamed:kImageHotKey]];
			[item setTarget:self];
			[item setAction:@selector(onKeySetting:)];
			[item setToolTip:L(@"LQTooltipKeySetting", @"BaseIMContainer")];
		}
	} else {
		[item setTarget:self];
		[item setAction:@selector(onToolbarItem:)];
	}
	return item;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
	NSMutableArray* identifiers = [NSMutableArray arrayWithArray:[m_mobileIMContainer actionIds]];
	[identifiers insertObject:NSToolbarSeparatorItemIdentifier atIndex:0];
	[identifiers insertObject:_kToolbarItemHistory atIndex:0];
	[identifiers insertObject:_kToolbarItemKeySetting atIndex:0];
	[identifiers insertObject:NSToolbarSeparatorItemIdentifier atIndex:0];
	[identifiers insertObject:[m_mobileIMContainer owner] atIndex:0];
	return identifiers;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
	NSMutableArray* identifiers = [NSMutableArray arrayWithArray:[m_mobileIMContainer actionIds]];
	[identifiers addObject:[m_mobileIMContainer owner]];
	[identifiers addObject:_kToolbarItemHistory];
	[identifiers addObject:_kToolbarItemKeySetting];
	return identifiers;
}

#pragma mark -
#pragma mark qq text view delegate

- (void)closeKeyTriggerred:(QQTextView*)textView {
	[self close];
}

- (void)historyKeyTriggerred:(QQTextView*)textView {
	[self onHistory:textView];
}

- (void)sendKeyTriggerred:(QQTextView*)textView {
	[m_mobileIMContainer send:self];
}

- (void)switchTabKeyTriggerred:(QQTextView*)textView {
	
}

#pragma mark -
#pragma mark alert delegate

- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	if(returnCode == NSAlertDefaultReturn) {
		m_sheetType = _kSheetCloseConfirm;
	}
}

#pragma mark -
#pragma mark actions

- (IBAction)onHeadItem:(id)sender {
	[m_mobileIMContainer showOwnerInfo:sender];
}

- (IBAction)onToolbarItem:(id)sender {
	[m_mobileIMContainer performAction:[sender itemIdentifier]];
}

- (IBAction)onKeySetting:(id)sender {
	if(m_shortcutWindowController == nil) {
		m_shortcutWindowController = [[KeyboardShortcutWindowController alloc] initWithQQ:[[m_mainWindowController me] QQ]];
		[NSBundle loadNibNamed:@"KeyboardShortcutWindow" owner:m_shortcutWindowController];
	}
	
	[m_shortcutWindowController beginSheet:[self window]
							 modalDelegate:nil
							didEndSelector:nil];
}

- (IBAction)onHistory:(id)sender {
	[[m_historyDrawerController drawer] toggle:self];
}

@end
