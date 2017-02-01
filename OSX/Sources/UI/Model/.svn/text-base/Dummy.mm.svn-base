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

#import "Dummy.h"
#import "Constants.h"

#define _kKeyType @"Type"
#define _kKeyName @"Name"
#define _kKeyClusterInternalId @"ClusterInternalId"

@implementation Dummy

- (id)initWithType:(int)type {
	self = [super init];
	if(self) {
		m_type = type;
		m_clusterInternalId = 0;
		m_requested = NO;
		m_operationSuffix = kStringEmpty;
	}
	return self;
}

- (id)initWithType:(int)type name:(NSString*)name {
	self = [super init];
	if(self) {
		m_type = type;
		[self setName:name];
		m_clusterInternalId = 0;
		m_requested = NO;
		m_operationSuffix = kStringEmpty;
	}
	return self;
}

- (void) dealloc {
	[m_name release];
	[m_operationSuffix release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
	return [self retain];
}

#pragma mark -
#pragma mark NSCoding protocol

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt:m_type forKey:_kKeyType];
	[encoder encodeObject:m_name forKey:_kKeyName];
	[encoder encodeInt32:m_clusterInternalId forKey:_kKeyClusterInternalId];
}

- (id)initWithCoder:(NSCoder *)decoder {
	m_type = [decoder decodeIntForKey:_kKeyType];
	m_name = [[decoder decodeObjectForKey:_kKeyName] retain];
	m_clusterInternalId = [decoder decodeInt32ForKey:_kKeyClusterInternalId];
	m_operationSuffix = kStringEmpty;
	return self;
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)clusterInternalId {
	return m_clusterInternalId;
}

- (void)setClusterInternalId:(UInt32)clusterInternalId {
	m_clusterInternalId = clusterInternalId;
}

- (int)type {
	return m_type;
}

- (void)setType:(int)type {
	m_type = type;
}

- (NSString*)name {
	return m_name ? m_name : kStringEmpty;
}

- (void)setName:(NSString*)name {
	[name retain];
	[m_name release];
	m_name = name;
}

- (BOOL)requested {
	return m_requested;
}

- (void)setRequested:(BOOL)requested {
	m_requested = requested;
}

- (NSString*)operationSuffix {
	return m_operationSuffix;
}

- (void)setOperationSuffix:(NSString*)suffix {
	[suffix retain];
	[m_operationSuffix release];
	m_operationSuffix = suffix;
}

@end
