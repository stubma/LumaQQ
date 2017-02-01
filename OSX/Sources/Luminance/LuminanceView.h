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
#import "MainWindowController.h"
#import "DebugListener.h"

@interface LuminanceView : NSView <DebugListener> {
	IBOutlet NSTableView* m_packetView;
	IBOutlet NSTextView* m_txtEncrypted;
	IBOutlet NSTextView* m_txtDecrypted;
	IBOutlet NSTextField* m_lblHint;
	IBOutlet NSMenu* m_textMenu;
	IBOutlet NSMenu* m_decryptMenu;
	IBOutlet NSMenu* m_encryptMenu;
	
	MainWindowController* m_main;
	
	// packet list
	NSMutableArray* m_debugObjects;
	NSMutableDictionary* m_unecryptedMap;
	NSMutableDictionary* m_encryptedMap;
	
	// data interpreter
	NSMutableArray* m_interpreters;
	NSMutableArray* m_evaluatedResults;
	NSData* m_selected;
	
	// key list
	NSMutableArray* m_keyNames;
	NSMutableArray* m_keys;
	
	// debug flag
	BOOL m_debugging;
}

// API
- (void)beginDebug;
- (void)endDebug;
- (BOOL)isDebugging;
- (BOOL)canDebug;
- (void)addKey:(NSData*)key name:(NSString*)keyName;

// helper
- (NSString*)packetKey:(Packet*)packet;

// getter and setter
- (void)setMainWindowController:(MainWindowController*)main;

@end
