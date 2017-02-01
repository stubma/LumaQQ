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

#import "Constants.h"
#import "LoginWindowController.h"
#import "PreferenceConstants.h"
#import "AlertTool.h"
#import "MainWindowController.h"
#import "NSData-MD5.h"
#import "NSData-Base64.h"
#import "Connection.h"
#import "QQConstants.h"
#import "LocalizedStringTool.h"
#import "FileTool.h"
#import "BasicConnectionAdvisor.h"
#import "NSString-Validate.h"
#import "NSMutableData-CustomAppending.h"
#import "NSData-QQCrypt.h"

// sheet type
#define _kSheetPasswordInconsistent 0

@implementation LoginWindowController : NSWindowController

- (id) init {
	self = [super initWithWindowNibName:@"Login"];
	if(self != nil) {
		m_sheetType = -1;
	}
	return self;
}

- (void)windowDidLoad {	
	// place window center
	[[self window] center];
	
	// get preference
	m_preference = [[PreferenceManager managerWithFile:kLQFileGlobal] retain];
	
	// reload login history
	[m_cbQQNumber reloadData];
	
	// set last qq number
	int iLastQQ = [m_preference integerForKey:kLQGlobalLastQQ];
	if(iLastQQ != 0)
		[m_cbQQNumber setStringValue:[NSString stringWithFormat:@"%d", iLastQQ]];
	
	// set initial responder
	if(iLastQQ == 0)
		[[self window] setInitialFirstResponder:m_cbQQNumber];
	else
		[[self window] setInitialFirstResponder:m_txtPassword];
	
	// if remember password, set password
	[self restoreStatus:iLastQQ];
}

- (void)windowWillClose:(NSNotification *)aNotification { 
	if([aNotification object] != [self window])
		return;
	
	[self release];
}

- (void)windowDidEndSheet:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	switch(m_sheetType) {
		case _kSheetPasswordInconsistent:
			[self login];
			break;
	}
	
	m_sheetType = -1;
}

- (void) dealloc {
	[m_preference release];
	[super dealloc];
}

#pragma mark -
#pragma mark IBAction

- (IBAction)onCancel:(id)sender {
	// close login window
	[self close];
}

- (IBAction)onLogin:(id)sender {
	// get qq number
	NSString* sQQ = [m_cbQQNumber stringValue];
	UInt32 iQQ = [sQQ intValue];
	
	// main window is already exist?
	if([WindowRegistry isMainWindowOpened:iQQ]) {
		[self close];
		MainWindowController* main = [WindowRegistry getMainWindow:iQQ];
		[[main window] orderFront:self];
		return;
	}
	
	// check qq number
	if(iQQ == 0) {
		// open alert
		[AlertTool showWarning:[self window] message:L(@"LQEmptyQQ", @"Login")];
		return;
	}
	if(iQQ <= 10000) {
		// qq number begins from 10001
		[AlertTool showWarning:[self window] message:L(@"LQInvalidQQ", @"Login")];
		return;
	}
	
	// check empty password
	if([[m_txtPassword stringValue] isEmpty]) {
		[AlertTool showWarning:[self window] message:L(@"LQWarningEmptyPassword", @"Login")];
		return;
	}
	
	// login
	[self login];
}

- (IBAction)onNetwork:(id)sender {
	UInt32 iQQ = [[m_cbQQNumber stringValue] intValue];
	
	// check qq number
	if(iQQ == 0) {
		[AlertTool showWarning:[self window] message:L(@"LQEmptyQQ", @"Login")];
		return;
	}
	
	// open network setting window
	[m_controllerNetworkSettingWindow beginSheet:[self window] forQQ:iQQ];
}

#pragma mark -
#pragma mark helper

- (void)restoreStatus:(UInt32)QQ {
	PreferenceManager* prefMyself = [PreferenceManager managerWithQQ:QQ file:kLQFileMyself];
	[m_chkRememberPassword setState:[prefMyself boolForKey:kLQLoginRememberPassword]];
	[m_chkHiddenLogin setState:[prefMyself boolForKey:kLQLoginHidden]];
	if([m_chkRememberPassword state]) {
		// get base64 of saved password
		NSString* sBase64 = [prefMyself stringForKey:kLQLoginPassword];
		
		// base64 decode
		const char* buffer = [sBase64 UTF8String];
		NSData* oldPassData = [NSData dataWithBytes:buffer length:strlen(buffer)];
		oldPassData = [oldPassData base64Decode];
		
		// get key
		NSMutableData* key = [NSMutableData data];
		[key appendSInt32:QQ littleEndian:NO];
		[key appendSInt32:QQ littleEndian:NO];
		[key appendSInt32:QQ littleEndian:NO];
		[key appendSInt32:QQ littleEndian:NO];
		
		// decrypt
		oldPassData = [oldPassData QQDecrypt:key];
		
		if(oldPassData == nil)
			[m_txtPassword setStringValue:@""];
		else {
			// get password string
			NSString* pass = [NSString stringWithCString:(const char*)[oldPassData bytes] length:[oldPassData length]];
			
			// set
			[m_txtPassword setStringValue:pass];
		}
	} else
		[m_txtPassword setStringValue:kStringEmpty];
}

- (void)login {
	// get qq number
	NSString* sQQ = [m_cbQQNumber stringValue];
	UInt32 iQQ = [sQQ intValue];
	
	// get preference
	PreferenceManager* prefMyself = [PreferenceManager managerWithQQ:iQQ file:kLQFileMyself];
	
	// get input password, max password length is 16
	NSString* sPassword = [m_txtPassword stringValue];
	if([sPassword length] > 16)
		sPassword = [sPassword substringToIndex:16];
	
	// get md5 and double md5 of input password
	const char* buffer = [sPassword UTF8String];
	NSData* passData = [NSData dataWithBytes:buffer length:strlen(buffer)];
	NSData* passMd5 = [passData MD5];
	NSData* passDoubleMD5 = [passMd5 MD5];
	
	// get remember password flag
	BOOL bRememberPassword = [m_chkRememberPassword state];
	if(bRememberPassword) {
		// get key
		NSMutableData* key = [NSMutableData data];
		[key appendSInt32:iQQ littleEndian:NO];
		[key appendSInt32:iQQ littleEndian:NO];
		[key appendSInt32:iQQ littleEndian:NO];
		[key appendSInt32:iQQ littleEndian:NO];
		
		// encrypt
		passData = [passData QQEncrypt:key];
		
		// base64
		passData = [passData base64Encode];
		
		// set to pref
		[prefMyself setObject:[NSString stringWithCString:(const char*)[passData bytes] length:[passData length]]
					   forKey:kLQLoginPassword];
	}
	
	//
	// save login history
	//
	
	// get login history array
	NSArray* arrLoginHistory = [m_preference arrayForKey:kLQGlobalLoginHistory];
	NSMutableArray* newArray;
	if(arrLoginHistory)
		newArray = [NSMutableArray arrayWithArray:arrLoginHistory];
	else
		newArray = [NSMutableArray array];
	
	// add qq number to array
	NSNumber* nQQ = [NSNumber numberWithUnsignedInt:iQQ];
	if(![newArray containsObject:nQQ])
		[newArray addObject:nQQ];
	
	// save it
	[m_preference setObject:newArray forKey:kLQGlobalLoginHistory];
	
	// save last QQ
	[m_preference setInteger:iQQ forKey:kLQGlobalLastQQ];
	
	// save global plist
	[m_preference sync];
	
	// set remember password and login hidden flag
	[prefMyself setBool:bRememberPassword forKey:kLQLoginRememberPassword];
	[prefMyself setBool:[m_chkHiddenLogin state] forKey:kLQLoginHidden];
	
	// initial preference if the value is not set
	NSString* sTemp = [prefMyself stringForKey:kLQLoginServer];
	if(!sTemp && [sTemp length] == 0) {
		[prefMyself setObject:LQTCPServers[0] forKey:kLQLoginServer];
	}		
	int port = [prefMyself integerForKey:kLQLoginPort];
	if(port == 0)
		[prefMyself setInteger:443 forKey:kLQLoginPort];
	sTemp = [prefMyself stringForKey:kLQLoginProtocol];
	if(!sTemp && [sTemp length] == 0)
		[prefMyself setObject:kLQProtocolTCP forKey:kLQLoginProtocol];
	sTemp = [prefMyself stringForKey:kLQLoginProxyType];
	if(!sTemp && [sTemp length] == 0)
		[prefMyself setObject:kLQProxyNone forKey:kLQLoginProxyType];
	
	// check version, delete group.plist if version is not match
	NSString* version = [prefMyself stringForKey:kLQVersionCurrent];
	if(version == nil || [version compare:kLumaQQVersionString] != NSOrderedSame) {
		NSString* path = [FileTool getFilePath:iQQ ForFile:kLQFileGroups];
		[FileTool deleteFile:path];
		[prefMyself setObject:kLumaQQVersionString forKey:kLQVersionCurrent];
	}
	
	// save to disk
	[prefMyself sync];
	
	// create connection object
	Connection* connection = [[Connection alloc] initWithServer:[prefMyself stringForKey:kLQLoginServer]
													   port:[prefMyself integerForKey:kLQLoginPort]
												   protocol:[prefMyself stringForKey:kLQLoginProtocol]
												  proxyType:[prefMyself stringForKey:kLQLoginProxyType]
												proxyServer:[prefMyself stringForKey:kLQLoginProxyServer]
												  proxyPort:[prefMyself integerForKey:kLQLoginProxyPort]
											  proxyUsername:[prefMyself stringForKey:kLQLoginProxyUsername]
											  proxyPassword:[prefMyself stringForKey:kLQLoginProxyPassword]];
	[connection setAdvisorId:[NSNumber numberWithInt:kQQFamilyBasic]];
	
	// hide self, open main window, begin login process
	MainWindowController* mainWindowController = [[MainWindowController alloc] initWithQQ:iQQ
																				 password:passDoubleMD5
																			  passwordMd5:passMd5
																			  loginStatus:([m_chkHiddenLogin state] ? kQQStatusHidden : kQQStatusOnline)
																			   connection:connection];
	[self close];
	[mainWindowController showWindow:self];
}

#pragma mark -
#pragma mark login history combobox data source

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index {
	NSArray* arrLoginHistory = [m_preference arrayForKey:kLQGlobalLoginHistory];
	if(arrLoginHistory)
		return [arrLoginHistory objectAtIndex:index];
	else
		return nil;
}

- (int)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	NSArray* arrLoginHistory = [m_preference arrayForKey:kLQGlobalLoginHistory];
	if(arrLoginHistory)
		return [arrLoginHistory count];
	else
		return 0;
}

#pragma mark -
#pragma mark login history combobox delegate

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
	// change selection and get selected qq number and validate it
	NSComboBox* combobox = [notification object];
	int index = [combobox indexOfSelectedItem];
	[combobox selectItemAtIndex:index];
	NSString* sQQ = [combobox stringValue];
	int iQQ = [sQQ intValue];
	[self restoreStatus:iQQ];
}

#pragma mark -
#pragma mark password textfield delegate

- (void)controlTextDidChange:(NSNotification *)aNotification {
}

#pragma mark -
#pragma mark alert delegate

- (void)passwordInconsistentAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	if(returnCode == NSAlertAlternateReturn) {
		m_sheetType = _kSheetPasswordInconsistent;
	}
}

@end
