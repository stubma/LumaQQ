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

#import "ClusterGetMessageSettingPacket.h"


@implementation ClusterGetMessageSettingPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_subCommand = kQQSubCommandClusterGetMessageSetting;
		m_clusters = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_clusters release];
	[super dealloc];
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeByte:m_subCommand];
	[buf writeUInt16:[m_clusters count]];
	NSEnumerator* e = [m_clusters objectEnumerator];
	NSNumber* internalId;
	while(internalId = [e nextObject]) {
		[buf writeUInt32:[internalId unsignedIntValue]];
		[buf writeUInt32:0];
		[buf writeByte:0];
	}
}

#pragma mark -
#pragma mark getter and setter

- (NSArray*)clusters {
	return m_clusters;
}

- (void)setClusters:(NSArray*)clusters {
	[m_clusters addObjectsFromArray:clusters];
}

- (void)addCluster:(UInt32)internalId {
	[m_clusters addObject:[NSNumber numberWithInt:internalId]];
}

@end
