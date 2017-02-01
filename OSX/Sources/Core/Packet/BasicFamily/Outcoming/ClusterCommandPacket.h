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

#import <Cocoa/Cocoa.h>
#import "BasicOutPacket.h"

@interface ClusterCommandPacket : BasicOutPacket {
	char m_subSubCommand;
	UInt32 m_internalId;
	UInt32 m_externalId;
	char m_tempType;
	UInt32 m_parentId;
}

// getter and setter
- (UInt32)internalId;
- (void)setInternalId:(UInt32)internalId;
- (char)tempType;
- (void)setTempType:(char)tempType;
- (UInt32)parentId;
- (void)setParentId:(UInt32)parentId;
- (char)subSubCommand;
- (void)setSubSubCommand:(char)subSubCommand;
- (UInt32)externalId;
- (void)setExternalId:(UInt32)externalId;

@end
