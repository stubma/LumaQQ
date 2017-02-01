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

#import "CustomFaceList.h"

@implementation CustomFaceList

- (id) init {
	self = [super init];
	if (self != nil) {
		m_faces = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_faces release];
	[super dealloc];
}

- (int)count {
	return [m_faces count];
}

- (void)addCustomFace:(CustomFace*)face {
	[m_faces addObject:face];
}

- (CustomFace*)face:(int)index {
	return [self face:index includeReference:NO];
}

- (CustomFace*)face:(int)index includeReference:(BOOL)flag {
	if(index < 0 || index >= [m_faces count])
		return nil;
	
	if(flag)
		return [m_faces objectAtIndex:index];
	
	int count = [m_faces count];
	for(int i = 0; i < count; i++) {
		CustomFace* face = [m_faces objectAtIndex:i];
		if(![face isReference]) {
			if(index == 0)
				return face;
			else
				index--;
		}
	}
	
	return nil;
}

@end
