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

#import "Member.h"
#import "QQConstants.h"

@implementation Member

- (void)read:(ByteBuffer*)buf {
	m_QQ = [buf getUInt32];
	m_organization = [buf getByte];
	m_roleFlag = [buf getByte];
}

- (void)readTemp:(ByteBuffer*)buf {
	m_QQ = [buf getUInt32];
	m_organization = [buf getByte];
	m_roleFlag = 0;
}

#pragma mark -
#pragma mark helper

- (BOOL)isAdmin {
	return (m_roleFlag & kQQRoleAdmin) != 0;
}

- (BOOL)isStockholder {
	return (m_roleFlag & kQQRoleStockholder) != 0;
}

- (BOOL)isManaged {
	return (m_roleFlag & kQQRoleManaged) != 0;
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)QQ {
	return m_QQ;
}

- (UInt8)organization {
	return m_organization;
}

- (char)roleFlag {
	return m_roleFlag;
}

@end
