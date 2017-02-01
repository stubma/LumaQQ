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

#import "ClusterModifyCardPacket.h"


@implementation ClusterModifyCardPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_subCommand = kQQSubCommandClusterModifyCard;
	}
	return self;
}

- (void) dealloc {
	[m_name release];
	[m_phone release];
	[m_email release];
	[m_remark release];
	[super dealloc];
}

- (void)fillBody:(ByteBuffer*)buf {
	[super fillBody:buf];
	[buf writeUInt32:[[self user] QQ]];
	[buf writeUInt32:(m_allowAdminModify ? kQQClusterNameCardAllowAdminModify : 0)];
	[buf writeString:m_name withLength:YES lengthByte:1];
	[buf writeByte:m_genderIndex];
	[buf writeString:m_phone withLength:YES lengthByte:1];
	[buf writeString:m_email withLength:YES lengthByte:1];
	[buf writeString:m_remark withLength:YES lengthByte:1];
}

#pragma mark -
#pragma mark getter and setter

- (BOOL)allowAdminModify {
	return m_allowAdminModify;
}

- (void)setAllowAdminModify:(BOOL)flag {
	m_allowAdminModify = flag;
}

- (NSString*)name {
	return m_name;
}

- (void)setName:(NSString*)name {
	[name retain];
	[m_name release];
	m_name = name;
}

- (NSString*)phone {
	return m_phone;
}

- (void)setPhone:(NSString*)phone {
	[phone retain];
	[m_phone release];
	m_phone = phone;
}

- (NSString*)email {
	return m_email;
}

- (void)setEmail:(NSString*)email {
	[email retain];
	[m_email release];
	m_email = email;
}

- (NSString*)remark {
	return m_remark;
}

- (void)setRemark:(NSString*)remark {
	[remark retain];
	[m_remark release];
	m_remark = remark;
}

- (int)genderIndex {
	return m_genderIndex;
}

- (void)setGenderIndex:(int)genderIndex {
	m_genderIndex = genderIndex;
}

@end
