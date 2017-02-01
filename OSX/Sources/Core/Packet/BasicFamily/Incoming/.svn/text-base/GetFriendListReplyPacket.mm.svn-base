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

#import "GetFriendListReplyPacket.h"
#import "Friend.h"

@implementation GetFriendListReplyPacket

- (void) dealloc {
	[m_friends release];
	[super dealloc];
}

- (void)parseBody:(ByteBuffer*)buf {
	m_nextStartPosition = [buf getUInt16];
	m_friends = [[NSMutableArray array] retain];
	while([buf hasAvailable]) {
		Friend* f = [[Friend alloc] init];
		[f read:buf];
		[m_friends addObject:f];
		[f release];
	}
}

#pragma mark -
#pragma mark helper

- (BOOL)finished {
	return m_nextStartPosition == kQQPositionEnd;
}

#pragma mark -
#pragma mark getter and setter

- (UInt16)nextStartPosition {
	return m_nextStartPosition;
}

- (NSArray*)friends {
	return m_friends;
}

@end
