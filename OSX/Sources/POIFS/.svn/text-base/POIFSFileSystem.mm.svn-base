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

#import "POIFSFileSystem.h"


@implementation POIFSFileSystem

- (id)initWithPath:(NSString*)path {
	self = [super init];
	if(self) {
		m_file = [[NSFileHandle fileHandleForReadingAtPath:path] retain];
		if(m_file) {
			m_buffer = [[FileBuffer alloc] initWithFile:m_file];
			[m_buffer setLittleEndian:YES];
			UInt64 magic = [m_buffer getUInt64];
			if(magic != kPOIFSMagicNumber) {
				[m_buffer release];
				[m_file closeFile];
				[m_file release];
				m_buffer = nil;
				m_file = nil;
			}
		} 
	}
	return self;
}

- (void) dealloc {
	if(m_buffer)
		[m_buffer release];
	if(m_file) {
		[m_file closeFile];
		[m_file release];
	}
	if(m_root)
		[m_root release];
	delete m_bat;
	delete m_sbat;
	[super dealloc];
}

- (void)load {
	if(!m_file)
		return;
	
	// get bat array count
	int batBlockCount = [m_buffer getInt32:OFFSET_BAT_COUNT];
	
	// get start block of xbat and count
	int xbatStart = [m_buffer getInt32:OFFSET_XBAT_START];
	int xbatBlockCount = [m_buffer getInt32:OFFSET_XBAT_COUNT];
	
	// calculate total bat count
	m_batCount = batBlockCount * INDEX_COUNT;
	
	// allocate memory
	m_bat = new int[m_batCount];
	
	// load bat block array
	[m_buffer seek:OFFSET_BAT_ARRAY];
	int readCount = MIN(BAT_ARRAY_MAX, batBlockCount);
	int* batBlocks = new int[batBlockCount];
	for(int i = 0; i < readCount; i++)
		batBlocks[i] = [m_buffer getInt32];
	
	// load bat
	int index = 0;
	for(int i = 0; i < readCount; i++) {
		[self seekBlock:batBlocks[i]];
		for(int j = 0; j < INDEX_COUNT; j++, index++)
			m_bat[index] = [m_buffer getInt32];
	}		
	
	// get left bat blocks
	int leftCount = batBlockCount - readCount;
	
	// load xbat
	int batBlocksPos = BAT_ARRAY_MAX;
	int xbatBlock = xbatStart;
	while(xbatBlockCount-- > 0) {
		[self seekBlock:xbatBlock];
		
		// load left bat block number
		readCount = MIN(leftCount, INDEX_COUNT);
		for(int j = 0; j < readCount; j++) {
			batBlocks[batBlocksPos + j] = [m_buffer getInt32];
		}
		
		// load bat
		for(int j = 0; j < readCount; j++) {
			[self seekBlock:batBlocks[batBlocksPos + j]];
			for(int i = 0; i < INDEX_COUNT; i++, index++)
				m_bat[index] = [m_buffer getInt32];
		}
		
		// adjust left count
		leftCount -= readCount;
		batBlocksPos += readCount;

		// go to next xbat
		xbatBlock = [self nextBlock:xbatBlock];
	}
	delete batBlocks;
	
	// load sbat
	int sbatStart = [m_buffer getInt32:OFFSET_SBAT_START];
	if(sbatStart == FLAG_END)
		m_sbat = new int[0];
	else {
		int sbatCount = [m_buffer getInt32:OFFSET_SBAT_COUNT];
		m_sbatCount = sbatCount * INDEX_COUNT;
		m_sbat = new int[m_sbatCount];
		for(int i = 0, block = sbatStart; i < sbatCount; i++) {
			[self seekBlock:block];
			block = [self nextBlock:block];
			for(int j = 0; j < INDEX_COUNT; j++)
				m_sbat[j + i * INDEX_COUNT] = [m_buffer getInt32];
		}
	}	
	
	// get properties start block
	m_propStart = [m_buffer getInt32:OFFSET_PROPERTIES_START_BLOCK];
	NSAssert(m_propStart != FLAG_END, @"Error: No Properties Block");
	
	// load all properties	
	NSMutableArray* properties = [NSMutableArray array];
	int block = m_propStart;
	while(block != FLAG_END) {
		[self seekBlock:block];
		for(int i = 0; i < PROPERTY_COUNT; i++) {
			Property* p = [[[Property alloc] init] autorelease];
			[p load:m_buffer];
			if(![p isUnused])
				[properties addObject:p];
		}
		block = [self nextBlock:block];
	}
	
	// set root entry
	m_root = [[properties objectAtIndex:0] retain];
	m_sbatStart = [m_root startBlock];
	
	// establish parent-child relationship
	NSMutableArray* array = [NSMutableArray array];
	NSEnumerator* e = [properties objectEnumerator];
	while(Property* p = [e nextObject]) {
		if([p firstChild] != -1) {
			[array addObject:[properties objectAtIndex:[p firstChild]]];
			
			while([array count] > 0) {
				// populate child
				Property* child = [array objectAtIndex:0];
				[array removeObjectAtIndex:0];
				
				// add child
				[p addChild:child];
				
				// push next and prev
				if([child next] != -1)
					[array addObject:[properties objectAtIndex:[child next]]];
				if([child previous] != -1)
					[array addObject:[properties objectAtIndex:[child previous]]];
			}
		}
	}
}

- (NSData*)getFileBytes:(Property*)property {
	if(m_file == nil)
		return nil;
	
	if([property isFile]) {
		NSMutableData* data = [NSMutableData data];
		
		int block = [property startBlock];
		BOOL small = [property isSmall];
		int size = [property size];
		while(block != FLAG_END) {
			// seek
			if(small)
				[self seekSmallBlock:block];
			else
				[self seekBlock:block];
			
			// read data
			[data appendData:[m_buffer getBytes:MIN(size, (small ? SMALL_BLOCK_SIZE : BLOCK_SIZE))]];
			size -= (small ? SMALL_BLOCK_SIZE : BLOCK_SIZE);
			
			// next block
			if(small)
				block = [self nextSmallBlock:block];
			else
				block = [self nextBlock:block];
		}
		
		return data;
	} else
		return nil;
}

- (int)totalSizeByPath:(NSString*)parentPath {
	Property* parent = [self property:parentPath];
	return [self totalSize:parent];
}

- (int)totalSize:(Property*)property {
	if(property == nil)
		return 0;
	else if([property isFile])
		return [property size];
	else {
		int size = 0;
		NSEnumerator* e = [[property children] objectEnumerator];
		while(Property* child = [e nextObject])
			size += [self totalSize:child];
		return size;
	}
}

- (Property*)property:(NSString*)path {
	if(m_root == nil)
		return nil;
	
	NSArray* components = [path pathComponents];
	
	Property* parent = nil;
	Property* ret = nil;
	NSEnumerator* e = [components objectEnumerator];
	while(NSString* component = [e nextObject]) {
		ret = [self subProperty:component parent:parent];
		if(ret == nil)
			return nil;
		else
			parent = ret;
	}
	return ret;
}

- (Property*)subProperty:(NSString*)pathComponent parent:(Property*)parent  {
	if(m_root == nil)
		return nil;
	
	if(parent == nil) {
		if([pathComponent isEqualToString:@"/"])
			return m_root;
		else
			return nil;
	} else if([parent isFile]) {
		return nil;
	} else {
		NSEnumerator* e = [[parent children] objectEnumerator];
		while(Property* p = [e nextObject]) {
			if([[p name] caseInsensitiveCompare:pathComponent] == NSOrderedSame)
				return p;
		}
		return nil;
	}
}

- (void)seekProperty:(int)index {
	int chain = index / PROPERTY_COUNT;
	int block = m_propStart;
	while(chain-- > 0)
		block = [self nextBlock:block];
	[m_buffer seek:(BLOCK_SIZE + BLOCK_SIZE * block + (index % PROPERTY_COUNT) * PROPERTY_SIZE)];
}

- (int)nextBlock:(int)index {
	if(index < 0 || index >= m_batCount)
		return FLAG_END;
	else
		return m_bat[index];
}

- (int)nextSmallBlock:(int)index {
	if(index < 0 || index >= m_sbatCount)
		return FLAG_END;
	else
		return m_sbat[index];
}

- (void)seekBlock:(int)block {
	[m_buffer seek:(BLOCK_SIZE + BLOCK_SIZE * block)];
}

- (void)seekSmallBlock:(int)block {
	int chain = block / SMALL_BLOCK_COUNT;
	int bigBlock = m_sbatStart;
	while(chain-- > 0)
		bigBlock = [self nextBlock:bigBlock];	
	[m_buffer seek:(BLOCK_SIZE + BLOCK_SIZE * bigBlock + (block % SMALL_BLOCK_COUNT) * SMALL_BLOCK_SIZE)];
}

@end
