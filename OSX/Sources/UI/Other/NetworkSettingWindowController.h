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

#import <Cocoa/Cocoa.h>
#import "PreferenceManager.h"

@interface NetworkSettingWindowController : NSObject {
	// interface element
	IBOutlet NSWindow* m_winNetwork;
	IBOutlet NSPopUpButton* m_pbProtocol;
	IBOutlet NSComboBox* m_cbServer;
	IBOutlet NSComboBox* m_cbPort;
	IBOutlet NSPopUpButton* m_pbProxyType;
	IBOutlet NSTextField* m_txtProxyServer;
	IBOutlet NSTextField* m_txtProxyPort;
	IBOutlet NSTextField* m_txtProxyUsername;
	IBOutlet NSSecureTextField* m_txtProxyPassword;
	
	// user preference
	PreferenceManager* m_prefMyself;
	PreferenceManager* m_prefGlobal;
	
	// protocol selection
	int m_iProtocol;
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;
- (void)beginSheet:(NSWindow*)docWindow forQQ:(int)iQQ;

// button action
- (IBAction)onOK:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onProtocolChanged:(id)sender;
- (IBAction)onProxyTypeChanged:(id)sender;

// internal method
- (NSArray*)fillServerList;

@end
