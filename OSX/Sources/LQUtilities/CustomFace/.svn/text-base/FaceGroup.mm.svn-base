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

#import "FaceGroup.h"
#import "Constants.h"

#define _kKeyName @"Name"
#define _kKeyFaces @"Faces"

@implementation FaceGroup

- (id) init {
	self = [super init];
	if (self != nil) {
		m_name = kStringEmpty;
		m_faces = [[NSMutableArray array] retain];
	}
	return self;
}

- (id)initWithName:(NSString*)name {
	self = [super init];
	if (self != nil) {
		m_name = [name retain];
		m_faces = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_name release];
	[m_faces release];
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:m_name forKey:_kKeyName];
	[encoder encodeObject:m_faces forKey:_kKeyFaces];
}

- (id)initWithCoder:(NSCoder *)decoder {
	m_name = [[decoder decodeObjectForKey:_kKeyName] retain];
	m_faces = [[decoder decodeObjectForKey:_kKeyFaces] retain];
	
	if(m_name == nil)
		m_name = kStringEmpty;
	if(m_faces == nil)
		m_faces = [[NSMutableArray array] retain];
	return self;
}

- (FaceGroup*)shallowCopy {
	FaceGroup* copy = [[[FaceGroup alloc] initWithName:m_name] autorelease];
	return copy;
}

- (NSComparisonResult)compare:(FaceGroup*)group {
	return [m_name compare:[group name]];
}

- (Face*)face:(int)index {
	if(index < 0 || index >= [m_faces count])
		return nil;
	return [m_faces objectAtIndex:index];
}

- (int)faceCount {
	return [m_faces count];
}

- (NSString*)name {
	return m_name;
}

- (void)setName:(NSString*)name {
	[name retain];
	[m_name release];
	m_name = name;
}

- (NSArray*)faces {
	return m_faces;
}

- (void)addFace:(Face*)face {
	[m_faces addObject:face];
}

- (void)removeFace:(int)index {
	[m_faces removeObjectAtIndex:index];
}

@end
