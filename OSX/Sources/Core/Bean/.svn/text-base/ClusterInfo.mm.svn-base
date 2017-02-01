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

#import "ClusterInfo.h"
#import "Constants.h"
#import "QQConstants.h"
#import "NSString-Filter.h"

@implementation ClusterInfo

- (id) init {
	self = [super init];
	if (self != nil) {
		m_parentId = 0;
		m_externalId = 0;
		m_version = 0;
	}
	return self;
}

- (void) dealloc {
	[m_name release];
	[m_notice release];
	[m_description release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone*)zone {
	ClusterInfo* newCopy = [[ClusterInfo alloc] init];
	[newCopy setInternalId:[self internalId]];
	[newCopy setExternalId:[self externalId]];
	[newCopy setParentId:[self parentId]];
	[newCopy setPermanent:[self permanent]];
	[newCopy setName:[self name]];
	[newCopy setNotice:[self notice]];
	[newCopy setDescription:[self description]];
	[newCopy setVersion:[self version]];
	[newCopy setAuthType:[self authType]];
	[newCopy setLevelFlag:[self levelFlag]];
	[newCopy setCreator:[self creator]];
	[newCopy setCategory:[self category]];
	return newCopy;
}

- (void)read:(ByteBuffer*)buf {
	m_internalId = [buf getUInt32];
	m_externalId = [buf getUInt32];
	m_permanent = [buf getByte] != 0;
	m_levelFlag = [buf getUInt32];
	m_creator = [buf getUInt32];
	m_authType = [buf getByte];
	[buf skip:6];
	m_category = [buf getUInt32];
	[buf skip:7];
	m_version = [buf getUInt32];
	
	int len = [buf getByte] & 0xFF;
	m_name = [[[buf getString:len] normalize] retain];
	
	[buf skip:2];
	
	len = [buf getByte] & 0xFF;
	m_notice = [[buf getString:len] retain];
	
	len = [buf getByte] & 0xFF;
	m_description = [[buf getString:len] retain];
}

- (void)readTemp:(ByteBuffer*)buf {
	m_permanent = [buf getByte] != 0;
	m_parentId = [buf getUInt32];
	m_internalId = [buf getUInt32];
	m_creator = [buf getUInt32];
	[buf skip:4];
	
	int len = [buf getByte] & 0xFF;
	m_name = [[[buf getString:len] normalize] retain];
}

- (void)readSearchResult:(ByteBuffer*)buf {
	m_internalId = [buf getUInt32];
	m_externalId = [buf getUInt32];
	m_permanent = [buf getByte] != 0;
	[buf skip:4];
	m_creator = [buf getUInt32];
	[buf skip:4];
	m_category = [buf getUInt32];
	[buf skip:2];
	int len = [buf getByte] & 0xFF;
	m_name = [[[buf getString:len] normalize] retain];
	[buf skip:2];
	m_authType = [buf getByte];
	len = [buf getByte] & 0xFF;
	m_description = [[buf getString:len] retain];
	[buf skip:1];
	len = [buf getByte] & 0xFF;
	[buf skip:len];
}

- (BOOL)isAdvanced {
	return (m_levelFlag & kQQFlagAdvancedCluster) != 0;
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)internalId {
	return m_internalId;
}

- (UInt32)externalId {
	return m_externalId;
}

- (UInt32)parentId {
	return m_parentId;
}

- (BOOL)permanent {
	return m_permanent;
}

- (UInt32)creator {
	return m_creator;
}

- (char)authType {
	return m_authType;
}

- (UInt32)category {
	return m_category;
}

- (UInt32)version {
	return m_version;
}

- (NSString*)name {
	return m_name ? m_name : kStringEmpty;
}

- (NSString*)notice {
	return m_notice ? m_notice : kStringEmpty;
}

- (NSString*)description {
	return m_description ? m_description : kStringEmpty;
}

- (void)setInternalId:(UInt32)internalId {
	m_internalId = internalId;
}

- (void)setExternalId:(UInt32)externalId {
	m_externalId = externalId;
}

- (void)setParentId:(UInt32)parentId {
	m_parentId = parentId;
}

- (void)setPermanent:(BOOL)permanent {
	m_permanent = permanent;
}

- (void)setCreator:(UInt32)creator {
	m_creator = creator;
}

- (void)setAuthType:(char)authType {
	m_authType = authType;
}

- (void)setCategory:(UInt32)category {
	m_category = category;
}

- (void)setVersion:(UInt32)version {
	m_version = version;
}

- (void)setName:(NSString*)name {
	[name retain];
	[m_name release];
	m_name = name;
}

- (void)setNotice:(NSString*)notice {
	[notice retain];
	[m_notice release];
	m_notice = notice;
}

- (void)setDescription:(NSString*)description {
	[description retain];
	[m_description release];
	m_description = description;
}

- (UInt32)levelFlag {
	return m_levelFlag;
}

- (void)setLevelFlag:(UInt32)levelFlag {
	m_levelFlag = levelFlag;
}

@end
