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
#import "ShortcutTextField.h"
#import "AnimatedWindowController.h"

@class MainWindowController;

@interface PreferenceWindowController : AnimatedWindowController {
	IBOutlet NSView* m_basicView;
	IBOutlet NSView* m_hotKeyView;
	IBOutlet NSView* m_soundView;
	IBOutlet NSView* m_recentContactView;

	// basic panel
	IBOutlet NSMatrix* m_mxWindow;
	IBOutlet NSMatrix* m_mxOverall;
	IBOutlet NSMatrix* m_mxUpload;
	
	// hot key panel
	IBOutlet ShortcutTextField* m_hotKeyExtractMessage;
	IBOutlet ShortcutTextField* m_hotKeyScreenscrap;
	
	// sound panel
	IBOutlet NSButton* m_chkEnableSound;
	IBOutlet NSPopUpButton* m_pbSoundType;
	IBOutlet NSButton* m_btnPlay;
	IBOutlet NSButton* m_btnBrowse;
	IBOutlet NSTextView* m_txtSoundFile;
	IBOutlet NSTextField* m_lblSoundSchema;
	IBOutlet NSTextField* m_lblSoundType;
	IBOutlet NSTextField* m_lblSoundFile;
	IBOutlet NSPopUpButton* m_pbSoundSchema;
	
	// recent contact panel
	IBOutlet NSButton* m_chkKeepStrangerInRecentContactList;
	IBOutlet NSTextField* m_txtMaxRecentContact;
	
	MainWindowController* m_mainWindowController;
	
	// for temp use
	NSMutableDictionary* m_soundFiles;
}

- (id)initWithMainWindow:(MainWindowController*)mainWindowController;

// helper
- (void)enableSoundBox:(BOOL)enable;
- (NSString*)validate;
- (void)savePreference;

// actions
- (IBAction)onOK:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onEnableSound:(id)sender;
- (IBAction)onSoundTypeChanged:(id)sender;
- (IBAction)onSoundSchemaChanged:(id)sender;
- (IBAction)onBrowse:(id)sender;
- (IBAction)onPlay:(id)sender;

@end
