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

#import "UploadFriendGroupPacket.h"


@implementation UploadFriendGroupPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandUploadGroupFriend;
		m_groupMapping = [[NSMutableDictionary dictionary] retain];
	}
	return self;
}

- (void) dealloc {
	[m_groupMapping release];
	[super dealloc];
}

- (void)fillBody:(ByteBuffer*)buf {
	NSEnumerator* e = [m_groupMapping keyEnumerator];
	while(NSNumber* nQQ = [e nextObject]) {
		[buf writeUInt32:[nQQ unsignedIntValue]];
		[buf writeByte:[[m_groupMapping objectForKey:nQQ] intValue]];
	}
}

#pragma mark -
#pragma mark getter and setter

- (NSDictionary*)groupMapping {
	return m_groupMapping;
}

- (void)addGroupMapping:(UInt32)QQ groupIndex:(int)groupIndex {
	[m_groupMapping setObject:[NSNumber numberWithInt:groupIndex] forKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (void)setGroupMapping:(NSDictionary*)mapping {
	[m_groupMapping removeAllObjects];
	[m_groupMapping addEntriesFromDictionary:mapping];
}

@end
