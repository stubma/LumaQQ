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

#import "TempSessionIMWindowController.h"
#import "MainWindowController.h"
#import "AlertTool.h"
#import "LocalizedStringTool.h"
#import "Constants.h"
#import "ByteTool.h"
#import "NSData-MD5.h"
#import "NSData-BytesOperation.h"

// toolbar identifier
#define _kToolBarTempSessionIMWindow @"TempSessionIMWindowToolBar"

// toolbar item
#define _kToolbarItemKeySetting @"ToolbarItemKeySetting"
#define _kToolbarItemHistory @"ToolbarItemHistory"

// sheet type
#define _kSheetCloseConfirm 0

@implementation TempSessionIMWindowController

- (id)initWithUser:(User*)user mainWindow:(MainWindowController*)mainWindowController {
	self = [super initWithWindowNibName:@"TempSessionIM"];
	if(self) {
		m_sheetType = -1;
		m_mainWindowController = [mainWindowController retain];
		m_tempSessionIMContainer = [[TempSessionIMContainerController alloc] initWithObject:user mainWindow:mainWindowController];
		[NSBundle loadNibNamed:@"TempSessionIMContainer" owner:m_tempSessionIMContainer];
	}
	return self;
}

- (void) dealloc {
	if(m_shortcutWindowController)
		[m_shortcutWindowController release];
	[m_tempSessionIMContainer release];
	[m_historyDrawerController release];
	[m_mainWindowController release];
	[super dealloc];
}

- (void)windowDidLoad {
	[[self window] setContentView:[m_tempSessionIMContainer view]];
	
	// connect
	[[m_tempSessionIMContainer inputBox] setDelegate:self];
	
	// set window title
	[[self window] setTitle:[m_tempSessionIMContainer description]];
	
	// create history drawer
	m_historyDrawerController = [[HistoryDrawerController alloc] initWithMainWindow:m_mainWindowController history:[m_tempSessionIMContainer history]];
	[NSBundle loadNibNamed:@"HistoryDrawer" owner:m_historyDrawerController];
	[[m_historyDrawerController drawer] setParentWindow:[self window]];
	
	// set toolbar
	NSToolbar* toolbar = [[[NSToolbar alloc] initWithIdentifier:_kToolBarTempSessionIMWindow] autorelease];
	[toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
	[toolbar setSizeMode:NSToolbarSizeModeSmall];
	[toolbar setAllowsUserCustomization:NO];
	[toolbar setDelegate:self];
	[[self window] setToolbar:toolbar];
	
	// register
	[[m_mainWindowController windowRegistry] registerTempSessionIMWindow:[m_tempSessionIMContainer windowKey] window:self];
	
	// add qq listener
	[[m_mainWindowController client] addQQListener:m_tempSessionIMContainer];
	
	// add observers
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleIMContainerModelDidChangedNotification:)
												 name:kIMContainerModelDidChangedNotificationName
											   object:nil];
	
	// set focus
	[[self window] setInitialFirstResponder:[m_tempSessionIMContainer inputBox]];
	
	// post notifiaction
	[[NSNotificationCenter defaultCenter] postNotificationName:kIMContainerAttachedToWindowNotificationName
														object:[m_tempSessionIMContainer view]
													  userInfo:[NSDictionary dictionaryWithObject:[self window] forKey:kUserInfoAttachToWindow]];
}

- (void)windowDidBecomeKey:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	// populate messages
	[m_tempSessionIMContainer walkMessageQueue:[m_mainWindowController messageQueue]];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kIMContainerModelDidChangedNotificationName
												  object:nil];	
	[[m_mainWindowController windowRegistry] unregisterTempSessionIMWindow:[m_tempSessionIMContainer windowKey]];
	[[m_mainWindowController client] removeQQListener:m_tempSessionIMContainer];
	[self release];
}

- (BOOL)windowShouldClose:(id)sender {
	if([m_tempSessionIMContainer pendingMessageCount] > 0) {
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
	[m_tempSessionIMContainer walkMessageQueue:[m_mainWindowController messageQueue]];
}

- (void)handleIMContainerModelDidChangedNotification:(NSNotification*)notification {
	id model = [notification object];
	if([model isEqualTo:[m_tempSessionIMContainer model]]) {
		// get head control
		NSToolbar* toolbar = [[self window] toolbar];
		NSToolbarItem* headItem = [[toolbar items] objectAtIndex:0];
		HeadControl* headControl = (HeadControl*)[headItem view];
		
		// refresh
		[headControl setOwner:[[m_mainWindowController me] QQ]];
		[headControl setObjectValue:model];
		[headControl display];
	}
}

#pragma mark -
#pragma mark toolbar delegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
	NSToolbarItem* item = [m_tempSessionIMContainer actionItem:itemIdentifier];
	if(item == nil) {
		if([itemIdentifier isEqualToString:[m_tempSessionIMContainer owner]]) {
			item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
			
			// create control
			HeadControl* headControl = [[[HeadControl alloc] init] autorelease];
			[m_tempSessionIMContainer refreshHeadControl:headControl];
			[headControl setTarget:self];
			[headControl setAction:@selector(onHeadItem:)];
			
			// set control to item
			[item setView:headControl];
			
			// set size
			[item setMinSize:NSMakeSize(24, 24)];
			[item setMaxSize:NSMakeSize(24, 24)];
			
			// set tooltip
			[item setToolTip:[NSString stringWithFormat:L(@"LQTooltipOwner", @"BaseIMContainer"), [m_tempSessionIMContainer description]]];
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
	NSMutableArray* identifiers = [NSMutableArray arrayWithArray:[m_tempSessionIMContainer actionIds]];
	[identifiers insertObject:NSToolbarSeparatorItemIdentifier atIndex:0];
	[identifiers insertObject:_kToolbarItemHistory atIndex:0];
	[identifiers insertObject:_kToolbarItemKeySetting atIndex:0];
	[identifiers insertObject:NSToolbarSeparatorItemIdentifier atIndex:0];
	[identifiers insertObject:[m_tempSessionIMContainer owner] atIndex:0];
	return identifiers;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
	NSMutableArray* identifiers = [NSMutableArray arrayWithArray:[m_tempSessionIMContainer actionIds]];
	[identifiers addObject:[m_tempSessionIMContainer owner]];
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
	[m_tempSessionIMContainer send:self];
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
	[m_tempSessionIMContainer showOwnerInfo:sender];
}

- (IBAction)onToolbarItem:(id)sender {
	[m_tempSessionIMContainer performAction:[sender itemIdentifier]];
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
