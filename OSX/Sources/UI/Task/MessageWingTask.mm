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

#import "MessageWingTask.h"
#import "MainWindowController.h"
#import "PreferenceCache.h"
#import "ImageTool.h"
#import "LumaQQApplication.h"

@implementation MessageWingTask

+ (MessageWingTask*)taskWithMainWindow:(MainWindowController*)mainWindowController {
	MessageWingTask* task = [[MessageWingTask alloc] initWithMainWindow:mainWindowController];
	return [task autorelease];
}

- (id)initWithMainWindow:(MainWindowController*)mainWindowController {
	self = [super initWithInterval:250];
	if(self) {
		m_mainWindowController = [mainWindowController retain];
		m_hasMessage = NO;
	}
	return self;
}

- (void) dealloc {
	[m_mainWindowController release];
	[super dealloc];
}

- (BOOL)isEqual:(id)anObject {
	return [[self keyObject] isEqual:[anObject keyObject]];
}

- (id)keyObject {
	return kTaskDockIconAnimation;
}

- (void)doTask {	
	User* me = [m_mainWindowController me];
	PreferenceCache* cache = [PreferenceCache cache:[me QQ]];
	NSImage* icon = [ImageTool iconWithMessageCount:[me isMM]
											 status:[me status]
											 unread:[LumaQQApplication pendingMessageCount]
										 showUnread:[cache displayUnreadCountOnDock]
										 hasMessage:m_hasMessage];
	[NSApp setApplicationIconImage:icon];
	if([m_mainWindowController autoHided]) {
		icon = [ImageTool iconWithMessageCount:[me isMM]
										status:[me status]
										unread:[[m_mainWindowController messageQueue] pendingMessageCount]
									showUnread:[cache displayUnreadCountOnDock]
									hasMessage:m_hasMessage];
		[[m_mainWindowController sideImageView] setImage:icon];
	}
	m_hasMessage = !m_hasMessage;
}

- (BOOL)shouldStop:(id)refObject {
	PreferenceCache* cache = [PreferenceCache cache:[[m_mainWindowController me] QQ]];
	if([[m_mainWindowController messageQueue] pendingMessageCount] <= 0 || 
	   [cache disableDockIconAnimation] ||
	   refObject == m_mainWindowController || 
	   [refObject isEqual:kTaskDockIconAnimation]) {
		return YES;	
	} else
		return NO;
}

@end
