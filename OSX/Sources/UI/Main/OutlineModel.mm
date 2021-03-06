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

#import "OutlineModel.h"
#import "Constants.h"

@implementation OutlineModel


- (id)initWithClasses:(NSArray*)classArray mainWindow:(MainWindowController*)mainWindowController {
	self = [super init];
	if (self != nil) {
		m_messageCount = 0;
		m_mainWindowController = mainWindowController;
		m_classArray = [classArray retain];
		m_objController = [[NSObjectController alloc] initWithContent:self];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleModelMessageCountChanged:)
													 name:kModelMessageCountChangedNotificationName
												   object:nil];
	}
	return self;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kModelMessageCountChangedNotificationName
												  object:nil];
	[m_objController release];
	[m_classArray release];
	[super dealloc];
}

- (void)handleModelMessageCountChanged:(NSNotification*)notification {
	Class klass = [[notification object] class];
	if([m_classArray containsObject:klass] && [[notification userInfo] objectForKey:kUserInfoDomain] == m_mainWindowController) {
		m_messageCount -= [[[notification userInfo] objectForKey:kUserInfoOldMessageCount] intValue];
		m_messageCount += [[[notification userInfo] objectForKey:kUserInfoNewMessageCount] intValue];
		[self setObjectCount:3];
	}
}

#pragma mark -
#pragma mark PSMTabModel protocol

- (BOOL)isProcessing {
	return NO;
}

- (void)setIsProcessing:(BOOL)value {
	
}

- (NSImage*)icon {
	return nil;
}

- (void)setIcon:(NSImage*)icon {
	
}

- (NSString*)iconName {
	return kStringEmpty;
}

- (void)setIconName:(NSString*)iconName {
	
}

- (int)objectCount {
	return m_messageCount;
}

- (void)setObjectCount:(int)value {
}

- (NSObjectController*)controller {
	return m_objController;
}

@end
