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

#import "ModelEffectTask.h"
#import "MainWindowController.h"

@implementation ModelEffectTask

+ (ModelEffectTask*)taskWithMainWindow:(MainWindowController*)mainWindowController object:(id)object {
	ModelEffectTask* task = [[ModelEffectTask alloc] initWithMainWindow:mainWindowController
																 object:object];
	return [task autorelease];
}

- (id)initWithMainWindow:(MainWindowController*)mainWindowController object:(id)object {
	self = [super init];
	if(self) {
		m_mainWindowController = [mainWindowController retain];
		m_object = [object retain];
		m_flashTimes = 0;
	}
	return self;
}

- (void) dealloc {
	[m_mainWindowController release];
	[m_object release];
	[super dealloc];
}

- (BOOL)isEqual:(id)anObject {
	if([anObject isMemberOfClass:[ModelEffectTask class]]) {
		if(m_mainWindowController == [(ModelEffectTask*)anObject mainWindow] && 
		   [m_object isEqual:[anObject keyObject]])
			return YES;
	}
	return NO;
}

- (id)keyObject {
	return m_object;
}

- (void)doTask {
	if([m_object isMemberOfClass:[Group class]])
		[[m_mainWindowController userOutline] reloadItem:m_object];
	else if([m_object isMemberOfClass:[Cluster class]])
		[[m_mainWindowController clusterOutline] reloadItem:m_object];
	else if([m_object isMemberOfClass:[User class]]){
		if([(User*)m_object onlining])
			m_flashTimes++;
		[[m_mainWindowController userOutline] reloadItem:m_object];
	} else if([m_object isMemberOfClass:[Mobile class]])
		[[m_mainWindowController mobileTable] reloadData];
}

- (BOOL)shouldStop:(id)refObject {
	if([m_object isMemberOfClass:[User class]]) {
		User* user = (User*)m_object;
		if(m_flashTimes > 20) {
			[user setOnlining:NO];
			m_flashTimes = 0;
		}		
		if(![user onlining] && [user messageCount] <= 0 && [user mobileMessageCount] <= 0 && [user tempSessionMessageCount] <= 0 ||
		   refObject == m_mainWindowController || refObject == m_object) {
			[self doTask];
			return YES;
		}
	} else if([m_object messageCount] <= 0 || refObject == m_mainWindowController || refObject == m_object) {
		[self doTask];
		return YES;
	} 
	
	return NO;
}

- (MainWindowController*)mainWindow {
	return m_mainWindowController;
}

@end
