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

#import "LumaQQApplication.h"
#import "ApplicationController.h"
#import "LoginWindowController.h"
#import "WindowRegistry.h"
#import "HotKeyManager.h"
#import "LQCrashHandler.h"
#import "LQGrowlDelegate.h"

OSErr LumaQQAEEventHandlerCallback(const AppleEvent* theAppleEvent, AppleEvent* reply, long handlerRefcon) {
	if([LumaQQApplication activeMainWindow])
		[[LumaQQApplication activeMainWindow] performSelector:@selector(onExtractMessage:) withObject:nil];
	return eventNotHandledErr;
}

@implementation ApplicationController

- (void)awakeFromNib {
	[m_miShiftClose setTarget:nil];
	[m_miShiftClose setAction:@selector(shiftClose:)];
}

- (BOOL)validateMenuItem:(id <NSMenuItem>)menuItem {
	if(menuItem == m_miShiftClose) {
		[menuItem setTitle:L(@"LQLogoutAndClose")];
		if([LumaQQApplication activeMainWindow] && [[[LumaQQApplication activeMainWindow] window] isKeyWindow])
			return YES;
		else
			return NO;
	} else 
		return YES;
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	[LQCrashHandler enableCrashCatching:[LumaQQApplication class] selector:@selector(applicationWillCrash)];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {	
	// install apple event handler
	AEInstallEventHandler(kCoreEventClass, 
						  kAEReopenApplication, 
						  NewAEEventHandlerUPP(LumaQQAEEventHandlerCallback), 
						  0, 
						  false);
	
	// setup growl
	LQGrowlDelegate* delegate = [[[LQGrowlDelegate alloc] init] autorelease];
	[delegate setup];
	
	// open first login window
	[self newLogin:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	[[HotKeyManager sharedHotKeyManager] clean];
	NSEnumerator* e = [[NSApp windows] objectEnumerator];
	while(NSWindow* win = [e nextObject]) {
		[win close];
	}
}

- (IBAction)newLogin:(id)sender {
	// open new login window
	LoginWindowController* loginController = [[LoginWindowController alloc] init];
	[loginController showWindow:self];
	[[loginController window] center];
}

- (IBAction)showPreference:(id)sender {
	if([LumaQQApplication activeMainWindow])
		[[LumaQQApplication activeMainWindow] performSelector:@selector(onPreference:) withObject:sender];
}

- (IBAction)showSearchWizard:(id)sender {
	if([LumaQQApplication activeMainWindow])
		[[LumaQQApplication activeMainWindow] performSelector:@selector(onSearch:) withObject:sender];
}

- (IBAction)showCustomFaceManager:(id)sender {
	if([LumaQQApplication activeMainWindow])
		[[LumaQQApplication activeMainWindow] performSelector:@selector(onOpenFaceManager:) withObject:sender];
}

- (IBAction)showSystemMessageList:(id)sender {
	if([LumaQQApplication activeMainWindow])
		[[LumaQQApplication activeMainWindow] performSelector:@selector(onSystemMessageList:) withObject:sender];
}

- (IBAction)shiftClose:(id)sender {
	if([LumaQQApplication activeMainWindow])
		[[LumaQQApplication activeMainWindow] performSelector:@selector(onLogoutAndClose:) withObject:sender];
}

- (IBAction)startLuminance:(id)sender {
	[WindowRegistry showLuminanceWindow];
}

- (IBAction)startQConsole:(id)sender {
	[WindowRegistry showQConsole];
}

@end
