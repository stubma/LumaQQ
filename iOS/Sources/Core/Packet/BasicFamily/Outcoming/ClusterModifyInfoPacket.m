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

#import "ClusterModifyInfoPacket.h"


@implementation ClusterModifyInfoPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_subCommand = kQQSubCommandClusterModifyInfo;
	}
	return self;
}

- (void) dealloc {
	[m_name release];
	[m_notice release];
	[m_description release];
	[super dealloc];
}

- (void)fillBody:(ByteBuffer*)buf {
	[super fillBody:buf];
	[buf writeByte:kQQClusterTypePermanent];
	[buf writeByte:m_authType];
	[buf writeUInt32:0];
	[buf writeUInt32:m_category];
	[buf writeString:m_name withLength:YES lengthByte:1];
	[buf writeUInt16:0];
	[buf writeString:m_notice withLength:YES lengthByte:1];
	[buf writeString:m_description withLength:YES lengthByte:1];
}

#pragma mark -
#pragma mark getter and setter

- (char)authType {
	return m_authType;
}

- (void)setAuthType:(char)authType {
	m_authType = authType;
}

- (UInt32)category {
	return m_category;
}

- (void)setCategory:(UInt32)category {
	m_category = category;
}

- (NSString*)name {
	return m_name;
}

- (void)setName:(NSString*)name {
	[name retain];
	[m_name release];
	m_name = name;
}

- (NSString*)notice {
	return m_notice;
}

- (void)setNotice:(NSString*)notice {
	[notice retain];
	[m_notice release];
	m_notice = notice;
}

- (NSString*)description {
	return m_description;
}

- (void)setDescription:(NSString*)desc {
	[desc retain];
	[m_description release];
	m_description = desc;
}

@end
