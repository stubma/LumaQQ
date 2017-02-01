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

#import "QQNotificationCenter.h"
#import "QQNotification.h"
#import "QQEvent.h"

@implementation QQNotificationCenter

- (id) init {
	self = [super init];
	if (self != nil) {
		m_listeners = [[NSMutableArray array] retain];
		m_listenersBackup = [[NSMutableArray array] retain];
		m_listenersChanged = NO;
	}
	return self;
}

- (void) dealloc {
	[m_listeners release];
	[m_listenersBackup release];
	[super dealloc];
}

- (void)addQQListener:(id<QQListener>)listener {
	[m_listeners addObject:listener];
	m_listenersChanged = YES;
}

- (void)removeQQListener:(id<QQListener>)listener {
	[m_listeners removeObject:listener];
	m_listenersChanged = YES;
}

- (void)postNotification:(QQNotification*)event {
	if(m_listenersChanged) {
		[m_listenersBackup removeAllObjects];
		[m_listenersBackup addObjectsFromArray:m_listeners];
		m_listenersChanged = NO;
	}
	int i;
	int count = [m_listenersBackup count];
	for(i = 0; i < count; i++) {
		id listener = [m_listenersBackup objectAtIndex:i];
		if([listener handleQQEvent:event] == YES)
			break;
	}
}

@end
