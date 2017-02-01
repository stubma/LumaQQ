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

#import "Property.h"
#import "NSData-BytesOperation.h"

@implementation Property

- (id) init {
	self = [super init];
	if (self != nil) {
		m_name = @"";
		m_children = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_name release];
	[m_children release];
	[super dealloc];
}

- (void)load:(FileBuffer*)buffer {
	// get current offset
	int offset = [buffer offset];
	
	// check unused?
	if([buffer getInt16] == 0)
		return;
	
	// get name size, then get name
	int nameSize = [buffer getInt16:(offset + OFFSET_PROPERTY_NAME_SIZE)] - 2;
	if(nameSize <= 0)
		m_name = @"";
	else {
		// we need convert data to native endian because it uses little endian in eip file
		NSData* data = [buffer getBytes:offset size:nameSize];
		[data toNative:2 sourceIsLittleEndian:YES];
		m_name = [[NSString stringWithCharacters:(const UniChar*)[data bytes] length:(nameSize / 2)] retain];
	}
	
	// get type
	m_type = [buffer getByte:(offset + OFFSET_PROPERTY_TYPE)] & 0xFF;
	
	// get previous index
	m_previous = [buffer getInt32:(offset + OFFSET_PREV_PROPERTY)];
	
	// get next index
	m_next = [buffer getInt32:(offset + OFFSET_NEXT_PROPERTY)];
	
	// get first child index
	m_firstChild = [buffer getInt32:(offset + OFFSET_FIRST_CHILD)];
	
	// get start block
	m_startBlock = [buffer getInt32:(offset + OFFSET_PROPERTY_START_BLOCK)];
	
	// get size
	m_size = [buffer getInt32:(offset + OFFSET_PROPERTY_SIZE)];
	
	// place offset after this property
	[buffer seek:(offset + PROPERTY_SIZE)];
}

- (NSString*)name {
	return m_name;
}

- (int)size {
	return m_size;
}

- (int)startBlock {
	return m_startBlock;
}

- (BOOL)isFile {
	return m_type == PROPERTY_TYPE_FILE;
}

- (BOOL)isDirectory {
	return m_type == PROPERTY_TYPE_DIRECTORY;
}

- (BOOL)isRoot {
	return m_type == PROPERTY_TYPE_ROOT;
}

- (NSArray*)children {
	return m_children;
}

- (void)addChild:(Property*)child {
	[m_children addObject:child];
}

- (int)firstChild {
	return m_firstChild;
}

- (int)next {
	return m_next;
}

- (int)previous {
	return m_previous;
}

- (BOOL)isUnused {
	return [m_name isEqualToString:@""];
}

- (BOOL)isSmall {
	return m_size <= SMALL_FILE_SIZE;
}

@end
