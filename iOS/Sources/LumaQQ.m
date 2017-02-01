/*
 * LumaQQ - Cross platform QQ client, special edition for iPhone
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

#import <dlfcn.h>
#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>
#import "LumaQQ.h"
#import "QQConstants.h"
#import "FileTool.h"
#import "ThemeTool.h"

void LQLog(const char *text, ...) {
	if(DEBUG) {
		char debug_text[1024];
		va_list args;
		FILE *f;
		
		va_start (args, text);
		vsnprintf (debug_text, sizeof (debug_text), text, args);
		va_end (args);
		
		f = fopen("/tmp/LumaQQ.debug", "a");
		fprintf(f, "%s\n", debug_text);
		fclose(f);
	}
}

@implementation LumaQQ

- (void)applicationDidFinishLaunching:(GSEventRef)event {
	LQLog("applicationDidFinishLaunching");
	
	// init variable
	_loggedIn = NO;
	
	// load theme
	[ThemeTool class];
	
	// create UI controller
	_uiController = [[UIController alloc] init];
	
	// show account manage
	[_uiController transitTo:kUIUnitAccountManage style:kTransitionStyleUpSlide data:nil];
	
	// show window
	[_uiController show];
	
	/*
	 * Install Status Bar Icons 
	 * Install it through program is not very good because SpringBoard caches images.
	 * It's better to install them in install plist.
	 */
	if(![FileTool isFileExist:kSpringBoardStatusIconFSO])
		[FileTool copy:kLumaQQStatusIconFSO to:kSpringBoardStatusIconFSO];
	if(![FileTool isFileExist:kSpringBoardStatusIconDefault])
		[FileTool copy:kLumaQQStatusIconDefault to:kSpringBoardStatusIconDefault];
	if(![FileTool isFileExist:kSpringBoardStatusIconMessageFSO])
		[FileTool copy:kLumaQQStatusIconMessageFSO to:kSpringBoardStatusIconMessageFSO];
	if(![FileTool isFileExist:kSpringBoardStatusIconMessageDefault])
		[FileTool copy:kLumaQQStautsIconMessageDefault to:kSpringBoardStatusIconMessageDefault];
	
	// add notification handle
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleLoginNotification:)
												 name:kLoginNotificationName
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleLogoutNotification:)
												 name:kLogoutNotificationName
											   object:nil];
}

- (void)terminate {
	LQLog("terminate");
	[super terminate];
}

- (void)willSleep {
	LQLog("willSleep");
	[super willSleep];
}

- (void)didWake {
	LQLog("didWake");
	[super didWake];
}

- (void)applicationWillTerminate {	
	// release
	[_uiController release];
	
	// remove notification handle
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kLoginNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kLogoutNotificationName
												  object:nil];
	
	// remove stauts bar image
	[UIApp removeStatusBarImageNamed:@"LumaQQ"];
	[UIApp removeStatusBarImageNamed:@"LumaQQ_Message"];
	
	// remove application badge
	[UIApp removeApplicationBadge];
	
	[super applicationWillTerminate];
}

- (void)applicationWillSuspendUnderLock {
	LQLog("applicationWillSuspendUnderLock");
	[super applicationWillSuspendUnderLock];
}

- (void)applicationWillSuspendForEventsOnly {
	LQLog("applicationWillSuspendForEventsOnly");
	if(!_loggedIn)
		[super applicationWillSuspendForEventsOnly];
}

- (void)applicationWillSuspend {
	LQLog("applicationWillSuspend");
	
	// post notification
	[[NSNotificationCenter defaultCenter] postNotificationName:kWillSuspendNotificationName
														object:nil];
	
	// call super
	[super applicationWillSuspend];
}

- (void)applicationDidResume {
	LQLog("applicationDidResume");
	[super applicationDidResume];
	
	// post notification
	[[NSNotificationCenter defaultCenter] postNotificationName:kWillResumeNotificationName
														object:nil];
}

- (void)applicationDidResumeFromUnderLock {
	LQLog("applicationDidResumeFromUnderLock");
	[super applicationDidResumeFromUnderLock];
}

- (void)applicationDidResumeForEventsOnly {
	LQLog("applicationDidResumeForEventsOnly");
	[super applicationDidResumeForEventsOnly];
	
	// post notification
	[[NSNotificationCenter defaultCenter] postNotificationName:kWillResumeNotificationName
														object:nil];
}

- (void)applicationSuspend:(GSEventRef)event {
	LQLog("applicationSuspend");
	if(!_loggedIn)
		[super applicationSuspend:event];
}

- (void)handleLoginNotification:(NSNotification*)notification {
	_loggedIn = YES;
}

- (void)handleLogoutNotification:(NSNotification*)notification {
	// clear flag
	_loggedIn = NO;
	
	// remove stauts bar image
	[UIApp removeStatusBarImageNamed:@"LumaQQ"];
}

@end
