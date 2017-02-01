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


#import "BaseExecutor.h"


@implementation BaseExecutor

- (id) init {
	self = [super init];
	if (self != nil) {
		m_params = [[NSMutableDictionary dictionary] retain];
	}
	return self;
}

- (void) dealloc {
	[m_params release];
	[super dealloc];
}

- (void)setObject:(id)object forKey:(NSString*)key {
	[m_params setObject:object forKey:key];
}

- (id)objectForKey:(NSString*)key {
	return [m_params objectForKey:key];
}

- (void)addObject:(id)object forKey:(NSString*)key {
	id array = [self objectForKey:key];
	if(array == nil) {
		array = [NSMutableArray array];
		[self setObject:array forKey:key];
	}
	[array addObject:object];
}

- (void)execute:(CommandContext*)context {
	
}

@end
