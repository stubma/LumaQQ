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

#import "Constants.h"
#import "Organization.h"

#define _kKeyName @"Name"
#define _kKeyPath @"Path"
#define _kKeyID @"ID"
#define _kKeyClusterInternalId @"ClusterInternalId"

@implementation Organization

- (id)initWithQQOrganization:(QQOrganization*)qqOrg {
	self = [super init];
	if(self) {
		[self setID:[qqOrg ID]];
		[self setName:[qqOrg name]];
		[self setPath:[qqOrg path]];
	}
	return self;
}

- (void) dealloc {
	[m_name release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
	return [self retain];
}

#pragma mark -
#pragma mark compare

- (NSComparisonResult)compare:(Organization*)org {
	return [m_name compare:[org name]];
}

#pragma mark -
#pragma mark helper

// get org level, start from 0
- (int)level {
	if(m_path > 0x00FFFFFF)
		return 0;
	else if(m_path > 0x0003FFFF)
		return 1;
	else if(m_path > 0x00000FFF)
		return 2;
	else
		return 3;
}

#pragma mark -
#pragma mark NSCoding protocol

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt:m_path forKey:_kKeyPath];
	[encoder encodeInt:m_id forKey:_kKeyID];
	[encoder encodeObject:m_name forKey:_kKeyName];
	[encoder encodeInt32:m_clusterInternalId forKey:_kKeyClusterInternalId];
}

- (id)initWithCoder:(NSCoder *)decoder {
	m_path = [decoder decodeIntForKey:_kKeyPath];
	m_id = [decoder decodeIntForKey:_kKeyID];
	m_name = [[decoder decodeObjectForKey:_kKeyName] retain];
	m_clusterInternalId = [decoder decodeInt32ForKey:_kKeyClusterInternalId];
	return self;
}

#pragma mark -
#pragma mark getter and setter

- (UInt8)ID {
	return m_id;
}

- (void)setID:(UInt8)ID {
	m_id = ID;
}

- (UInt32)path {
	return m_path;
}

- (void)setPath:(UInt32)path {
	m_path = path;
}

- (UInt32)clusterInternalId {
	return m_clusterInternalId;
}

- (void)setClusterInternalId:(UInt32)internalId {
	m_clusterInternalId = internalId;
}

- (NSString*)name {
	return m_name ? m_name : kStringEmpty;
}

- (void)setName:(NSString*)name {
	[name retain];
	[m_name release];
	m_name = name;
}

@end
