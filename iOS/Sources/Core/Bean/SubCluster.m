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

#import "SubCluster.h"
#import "NSString-Filter.h"

@implementation SubCluster

- (void) dealloc {
	[m_name release];
	[super dealloc];
}

- (void)read:(ByteBuffer*)buf {
	m_internalId = [buf getUInt32];
	int len = [buf getByte] & 0xFF;
	m_name = [[[buf getString:len] normalize] retain];
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)internalId {
	return m_internalId;
}

- (NSString*)name {
	return m_name;
}

@end