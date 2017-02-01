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

#import "QQOrganization.h"


@implementation QQOrganization

- (void)read:(ByteBuffer*)buf {
	m_id = [buf getByte] & 0xFF;
	m_path = [buf getUInt32];
	
	int len = [buf getByte] & 0xFF;
	m_name = [[buf getString:len] retain];
}

#pragma mark -
#pragma mark getter and setter

- (UInt8)ID {
	return m_id;
}

- (UInt32)path {
	return m_path;
}

- (NSString*)name {
	return m_name;
}

@end
