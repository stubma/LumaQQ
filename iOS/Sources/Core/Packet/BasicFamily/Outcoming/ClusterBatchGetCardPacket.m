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

#import "ClusterBatchGetCardPacket.h"


@implementation ClusterBatchGetCardPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_subCommand = kQQSubCommandClusterBatchGetCard;
		m_clusterNameCardVersionId = 0;
		m_startPosition = 0;
	}
	return self;
}

- (void)fillBody:(ByteBuffer*)buf {
	[super fillBody:buf];
	[buf writeUInt32:m_clusterNameCardVersionId];
	[buf writeUInt32:m_startPosition];
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)clusterNameCardVersionId {
	return m_clusterNameCardVersionId;
}

- (UInt32)startPosition {
	return m_startPosition;
}

- (void)setClusterNameCardVersionId:(UInt32)versionId {
	m_clusterNameCardVersionId = versionId;
}

- (void)setStartPosition:(UInt32)start {
	m_startPosition = start;
}

@end
