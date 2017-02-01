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

#import "LumaQQApplication.h"
#import "KeyDevour.h"
#import "WindowRegistry.h"
#import "MainWindowController.h"

static MainWindowController* m_activeMainWindow = nil;

@implementation LumaQQApplication

- (void)sendEvent:(NSEvent *)anEvent {
	switch([anEvent type]) {
		case NSKeyDown:
			if(([anEvent modifierFlags] & NSCommandKeyMask) != 0) {
				NSWindow* keyWindow = [self keyWindow];
				if(keyWindow) {
					NSResponder* responder = [keyWindow firstResponder];
					if(responder && [responder conformsToProtocol:@protocol(KeyDevour)] && [(id<KeyDevour>)responder eatKey:anEvent]) {
						[responder tryToPerform:@selector(keyDown:) with:anEvent];
						return;
					}
				}	
			}
			break;
		case NSKeyUp:
			if(([anEvent modifierFlags] & NSCommandKeyMask) != 0) {
				NSWindow* keyWindow = [self keyWindow];
				if(keyWindow) {
					NSResponder* responder = [keyWindow firstResponder];
					if(responder && [responder conformsToProtocol:@protocol(KeyDevour)] && [(id<KeyDevour>)responder eatKey:anEvent]) {
						[responder tryToPerform:@selector(keyUp:) with:anEvent];
						return;
					}
				}	
			}
			break;
	}
	
	[super sendEvent:anEvent];
}

+ (void)applicationWillCrash {
	NSEnumerator* e = [WindowRegistry mainWindowEnumerator];
	while(MainWindowController* main = [e nextObject]) {
		[[main client] logout];
		[main saveImportantInfo];
	}
}

+ (MainWindowController*)activeMainWindow {
	return m_activeMainWindow;
}

+ (void)setActiveMainWindow:(MainWindowController*)main {
	[main retain];
	[m_activeMainWindow release];
	m_activeMainWindow = main;
}

+ (int)pendingMessageCount {
	int count = 0;
	NSEnumerator* e = [WindowRegistry mainWindowEnumerator];
	while(MainWindowController* main = [e nextObject])
		count += [[main messageQueue] pendingMessageCount];
	return count;
}

- (void)orderFrontStandardAboutPanel:(id)sender {
	[WindowRegistry showAboutWindow];
}

@end
