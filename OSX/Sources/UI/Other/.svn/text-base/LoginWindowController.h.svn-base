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
#import "NetworkSettingWindowController.h"
#import "PreferenceManager.h"

@interface LoginWindowController : NSWindowController {
	// interface element
	IBOutlet NSComboBox* m_cbQQNumber;
	IBOutlet NSSecureTextField* m_txtPassword;
	IBOutlet NSButton* m_chkRememberPassword;
	IBOutlet NSButton* m_chkHiddenLogin;
	
	// network setting window controller
	IBOutlet NetworkSettingWindowController* m_controllerNetworkSettingWindow;
	
	// lumaqq preferences
	PreferenceManager* m_preference;
	
	// check sheet type
	int m_sheetType;
}

// alert delegate
- (void)passwordInconsistentAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;

// helper
- (void)login;
- (void)restoreStatus:(UInt32)QQ;

// button action
- (IBAction)onCancel:(id)sender;
- (IBAction)onLogin:(id)sender;
- (IBAction)onNetwork:(id)sender;

@end
