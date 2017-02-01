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

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface ClusterInfo : NSObject <NSCopying> {
	UInt32 m_internalId;
	UInt32 m_externalId;
	UInt32 m_parentId;
	BOOL m_permanent;
	UInt32 m_levelFlag;
	UInt32 m_creator;
	char m_authType;
	UInt32 m_category;
	UInt32 m_version;
	NSString* m_name;
	NSString* m_notice;
	NSString* m_description;
}

- (void)read:(ByteBuffer*)buf;
- (void)readTemp:(ByteBuffer*)buf;
- (void)readSearchResult:(ByteBuffer*)buf;
- (BOOL)isAdvanced;

// getter and setter
- (UInt32)internalId;
- (UInt32)externalId;
- (UInt32)parentId;
- (BOOL)permanent;
- (UInt32)creator;
- (UInt32)levelFlag;
- (char)authType;
- (UInt32)category;
- (UInt32)version;
- (NSString*)name;
- (NSString*)notice;
- (NSString*)description;
- (void)setLevelFlag:(UInt32)levelFlag;
- (void)setInternalId:(UInt32)internalId;
- (void)setExternalId:(UInt32)externalId;
- (void)setParentId:(UInt32)parentId;
- (void)setPermanent:(BOOL)permanent;
- (void)setCreator:(UInt32)creator;
- (void)setAuthType:(char)authType;
- (void)setCategory:(UInt32)category;
- (void)setVersion:(UInt32)version;
- (void)setName:(NSString*)name;
- (void)setNotice:(NSString*)notice;
- (void)setDescription:(NSString*)description;

@end
