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

#import "RecentOutlineModel.h"
#import "MainWindowController.h"
#import "Constants.h"
#import "ImageTool.h"

@implementation RecentOutlineModel

- (void)handleModelMessageCountChanged:(NSNotification*)notification {
	Class klass = [[notification object] class];
	if([m_classArray containsObject:klass] && [[notification userInfo] objectForKey:kUserInfoDomain] == m_mainWindowController) {
		if([[[m_mainWindowController groupManager] recentContacts] containsObject:[notification object]]) {
			m_messageCount -= [[[notification userInfo] objectForKey:kUserInfoOldMessageCount] intValue];
			m_messageCount += [[[notification userInfo] objectForKey:kUserInfoNewMessageCount] intValue];
			[self setObjectCount:3];
		}
	}
}

- (NSImage*)icon {
	return [ImageTool imageWithName:kImageRecentContact size:NSMakeSize(16, 16)];	
}

@end
