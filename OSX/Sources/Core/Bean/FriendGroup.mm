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

#import "FriendGroup.h"
#import "QQConstants.h"

@implementation FriendGroup

- (void)read:(ByteBuffer*)buf {
	m_QQ = [buf getUInt32];
	m_type = [buf getByte];
	m_groupIndex = [buf getByte] / 4;
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)QQ {
	return m_QQ;
}

- (char)type {
	return m_type;
}

- (char)groupIndex {
	return m_groupIndex;
}

#pragma mark -
#pragma mark helper

- (BOOL)isUser {
	return (m_type & kQQTypeUser) != 0;
}

- (BOOL)isCluster {
	return (m_type & kQQTypeCluster) != 0;
}

@end
