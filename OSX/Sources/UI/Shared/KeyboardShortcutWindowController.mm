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

#import "KeyboardShortcutWindowController.h"
#import "PreferenceCache.h"

@implementation KeyboardShortcutWindowController

- (id)initWithQQ:(UInt32)QQ {
	self = [super init];
	if(self) {
		m_QQ = QQ;
	}
	return self;
}

- (void)beginSheet:(NSWindow*)docWindow modalDelegate:(id)delegate didEndSelector:(SEL)selector {
	m_loaded = NO;
	[NSApp beginSheet:m_keyboardShortcutWindow
	   modalForWindow:docWindow
		modalDelegate:delegate
	   didEndSelector:selector
		  contextInfo:nil];
}

- (void)awakeFromNib {
	// set alignment
	[m_txtCloseWindow setAlignment:NSCenterTextAlignment];
	[m_txtHistory setAlignment:NSCenterTextAlignment];
	[m_txtNewLine setAlignment:NSCenterTextAlignment];
	[m_txtSendMessage setAlignment:NSCenterTextAlignment];
	[m_txtSwitchTab setAlignment:NSCenterTextAlignment];
	
	// set delegate
	[m_txtCloseWindow setDelegate:self];
	[m_txtHistory setDelegate:self];
	[m_txtNewLine setDelegate:self];
	[m_txtSendMessage setDelegate:self];
	[m_txtSwitchTab setDelegate:self];
}

- (void)loadPreferenceValue {
	// load preference
	PreferenceCache* cache = [PreferenceCache cache:m_QQ];
	[m_txtCloseWindow setString:[cache closeKey]];
	[m_txtHistory setString:[cache historyKey]];
	[m_txtNewLine setString:[cache newLineKey]];
	[m_txtSendMessage setString:[cache sendKey]];
	[m_txtSwitchTab setString:[cache switchTabKey]];
}

- (void)windowDidBecomeKey:(NSNotification *)aNotification {
	if([aNotification object] != m_keyboardShortcutWindow)
		return;
	
	if(!m_loaded)
		[self loadPreferenceValue];
	m_loaded = YES;
}

#pragma mark -
#pragma mark shortcut text view delegate

- (void)shortcutDidChanged:(ShortcutTextField*)field {
	NSColor* red = [NSColor redColor];
	NSColor* white = [NSColor whiteColor];
	
	// collect other shortcut
	NSArray* array = [NSArray arrayWithObjects:m_txtCloseWindow, m_txtHistory, m_txtNewLine, m_txtSendMessage, m_txtSwitchTab, nil];
 	
	// clear background
	NSEnumerator* e = [array objectEnumerator];
	while(ShortcutTextField* f = [e nextObject])
		[f setBackgroundColor:white];
	
	// check if any conflict
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	 e = [array objectEnumerator];
	while(ShortcutTextField* f = [e nextObject]) {
		if([dict objectForKey:[f string]] == nil) 
			[dict setObject:f forKey:[f string]];
		else {
			[f setBackgroundColor:red];
			[[dict objectForKey:[f string]] setBackgroundColor:red];
		}
	}
	
	// get red back count
	int count = 0;
	e = [array objectEnumerator];
	while(ShortcutTextField* f = [e nextObject]) {
		if([[f backgroundColor] isEqualTo:red])
			count++;
	}
	
	// set button status
	[m_btnOK setEnabled:(count == 0)];
}

#pragma mark -
#pragma mark actions

- (IBAction)onCancel:(id)sender {
	[NSApp endSheet:m_keyboardShortcutWindow returnCode:NSOKButton];
	[m_keyboardShortcutWindow orderOut:self];
}

- (IBAction)onOK:(id)sender {
	// save shortcut
	PreferenceCache* cache = [PreferenceCache cache:m_QQ];
	[cache setSendKey:[m_txtSendMessage string]];
	[cache setSwitchTabKey:[m_txtSwitchTab string]];
	[cache setNewLineKey:[m_txtNewLine string]];
	[cache setHistoryKey:[m_txtHistory string]];
	[cache setCloseKey:[m_txtCloseWindow string]];
	
	// end sheet
	[NSApp endSheet:m_keyboardShortcutWindow returnCode:NSCancelButton];
	[m_keyboardShortcutWindow orderOut:self];
}

#pragma mark -
#pragma mark getter and setter

- (NSWindow*)keyboardShortcutWindow {
	return m_keyboardShortcutWindow;
}

@end
