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

#import "ClusterCommandPacket.h"


@implementation ClusterCommandPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandCluster;
	}
	return self;
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeByte:m_subCommand];
	[buf writeUInt32:m_internalId];
}

#pragma mark -
#pragma mark getter and setter

- (char)subSubCommand {
	return m_subSubCommand;
}

- (void)setSubSubCommand:(char)subSubCommand {
	m_subSubCommand = subSubCommand;
}

- (UInt32)internalId {
	return m_internalId;
}

- (void)setInternalId:(UInt32)internalId {
	m_internalId = internalId;
}

- (char)tempType {
	return m_tempType;
}

- (void)setTempType:(char)tempType {
	m_tempType = tempType;
}

- (UInt32)parentId {
	return m_parentId;
}

- (void)setParentId:(UInt32)parentId {
	m_parentId = parentId;
}

- (UInt32)externalId {
	return m_externalId;
}

- (void)setExternalId:(UInt32)externalId {
	m_externalId = externalId;
}

@end
