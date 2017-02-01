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

#import "LevelOpPacket.h"

@implementation LevelOpPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandLevelOp;
		m_subCommand = kQQSubCommandGetFriendLevel;
		m_friends = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_friends release];
	[super dealloc];
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeByte:m_subCommand];
	NSEnumerator* e = [m_friends objectEnumerator];
	NSNumber* qq = nil;
	while(qq = [e nextObject])
		[buf writeUInt32:[qq intValue]];
}

#pragma mark -
#pragma mark getter and setter

- (NSArray*)friends {
	return m_friends;
}

- (void)addFriend:(UInt32)QQ {
	[m_friends addObject:[NSNumber numberWithUnsignedInt:QQ]];
}

- (void)addFriends:(NSArray*)friends {
	[m_friends addObjectsFromArray:friends];
}

@end
