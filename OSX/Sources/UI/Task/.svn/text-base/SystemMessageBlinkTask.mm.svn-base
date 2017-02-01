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

#import "SystemMessageBlinkTask.h"
#import "Constants.h"
#import "MainWindowController.h"

@implementation SystemMessageBlinkTask

+ (SystemMessageBlinkTask*)taskWithMainWindow:(MainWindowController*)mainWindowController {
	SystemMessageBlinkTask* task = [[SystemMessageBlinkTask alloc] initWithMainWindow:mainWindowController];
	return [task autorelease];
}

- (id)initWithMainWindow:(MainWindowController*)mainWindowController {
	self = [super initWithInterval:500];
	if(self) {
		m_mainWindowController = [mainWindowController retain];
		m_flag = NO;
	}
	return self;
}

- (void) dealloc {
	[m_mainWindowController release];
	[super dealloc];
}

- (BOOL)isEqual:(id)anObject {
	if([anObject isMemberOfClass:[SystemMessageBlinkTask class]]) {
		if(m_mainWindowController == [(SystemMessageBlinkTask*)anObject mainWindow] && 
		   [[self keyObject] isEqual:[anObject keyObject]])
			return YES;
	}
	return NO;
}

- (id)keyObject {
	return kTaskSystemMessageBlink;
}

- (void)doTask {
	if(m_flag)
		[[m_mainWindowController systemMessageListButton] setImage:[NSImage imageNamed:kImageSystemMessageListButton]];
	else
		[[m_mainWindowController systemMessageListButton] setImage:nil];
	
	m_flag = !m_flag;
}

- (BOOL)shouldStop:(id)refObject {
	if([[m_mainWindowController messageQueue] systemMessageCount] <= 0 ||
	   refObject == m_mainWindowController || 
	   [refObject isEqual:kTaskSystemMessageBlink]) {
		[[m_mainWindowController systemMessageListButton] setImage:[NSImage imageNamed:kImageSystemMessageListButton]];
		return YES;	
	} else
		return NO;
}

- (MainWindowController*)mainWindow {
	return m_mainWindowController;
}

@end
