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

#import "Predicate.h"


@implementation Predicate

- (void) dealloc
{
	[m_property release];
	[m_value release];
	[super dealloc];
}

- (int)op {
	return m_op;
}

- (void)setOp:(int)op {
	m_op = op;
}

- (NSString*)property {
	return m_property;
}

- (void)setProperty:(NSString*)property {
	[property retain];
	[m_property release];
	m_property = property;
}

- (id)value {
	return m_value;
}

- (void)setValue:(id)value {
	[value retain];
	[m_value release];
	m_value = value;
}

@end
