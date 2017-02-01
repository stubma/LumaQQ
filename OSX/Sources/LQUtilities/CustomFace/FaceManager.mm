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

#import "FaceManager.h"
#import "FileTool.h"
#import "Constants.h"
#import "LocalizedStringTool.h"

#define _kKeyGroups @"Groups"

@implementation FaceManager

- (id)initWithQQ:(UInt32)QQ {
	self = [super init];
	if (self != nil) {
		m_QQ = QQ;
		m_groups = [[NSMutableArray array] retain];
		m_faceRegistry = [[NSMutableDictionary dictionary] retain];
		m_dirty = NO;
	}
	return self;
}

- (void) dealloc {
	[m_groups release];
	[m_faceRegistry release];
	[super dealloc];
}

- (UInt32)QQ {
	return m_QQ;
}

- (void)load {
	NSString* filePath = [FileTool getFilePath:m_QQ ForFile:kLQFileFaces];
	NSData* data = [NSData dataWithContentsOfFile:filePath];
	if(data) {		
		NSKeyedUnarchiver* unar = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		NSMutableArray* groups = [unar decodeObjectForKey:_kKeyGroups];
		[unar finishDecoding];
		[unar release];
		
		// save groups
		if(groups) {
			if(m_groups)
				[m_groups release];
			
			m_groups = [groups retain];
		}
		
		// hash all faces
		int groupIndex = 0;
		NSEnumerator* gEnum = [m_groups objectEnumerator];
		while(FaceGroup* g = [gEnum nextObject]) {
			NSEnumerator* fEnum = [[g faces] objectEnumerator];
			while(Face* f = [fEnum nextObject]) {
				[f setGroupIndex:groupIndex];
				[m_faceRegistry setObject:f forKey:[f md5]];
			}
			groupIndex++;
		}
	}
	
	// create default group
	if([m_groups count] == 0)
		[m_groups addObject:[[[FaceGroup alloc] initWithName:L(@"LQDefaultGroup", @"FaceManager")] autorelease]];
}

- (void)save {
	if(!m_dirty)
		return;
	
	m_dirty = NO;	
	NSString* filePath = [FileTool getFilePath:m_QQ ForFile:kLQFileFaces];
	NSMutableData* data = [NSMutableData data];
	NSKeyedArchiver* ar = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[ar setOutputFormat:NSPropertyListXMLFormat_v1_0];
	[ar encodeObject:m_groups forKey:_kKeyGroups];
	[ar finishEncoding];
	[data writeToFile:filePath atomically:YES];
}

- (void)addFace:(Face*)face groupIndex:(int)index {
	FaceGroup* g = [self group:index];
	if(g) {
		[g addFace:face];
		[face setGroupIndex:index];
		[m_faceRegistry setObject:face forKey:[face md5]];
		m_dirty = YES;
	}
}

- (void)addGroup:(FaceGroup*)group {
	[m_groups addObject:group];
	m_dirty = YES;
}

- (int)indexOfGroup:(FaceGroup*)group {
	return [m_groups indexOfObject:group];
}

- (NSArray*)groups {
	return m_groups;
}

- (void)sortGroups {
	[m_groups sortUsingSelector:@selector(compare:)];
}

- (FaceGroup*)group:(int)index {
	if(index < 0 || index >= [self groupCount])
		return nil;
	return [m_groups objectAtIndex:index];
}

- (void)removeGroup:(int)index {
	// clear face registry
	FaceGroup* g = [m_groups objectAtIndex:index];
	NSEnumerator* e = [[g faces] objectEnumerator];
	while(Face* f = [e nextObject])
		[m_faceRegistry removeObjectForKey:[f md5]];
	[m_groups removeObjectAtIndex:index];
	m_dirty = YES;
}

- (int)faceCount:(int)groupIndex {
	FaceGroup* g = [self group:groupIndex];
	if(g) 
		return [g faceCount];
	else
		return 0;
}

- (BOOL)hasGroup:(NSString*)name {
	NSEnumerator* e = [m_groups objectEnumerator];
	while(FaceGroup* g = [e nextObject]) {
		if([[g name] caseInsensitiveCompare:name] == NSOrderedSame)
			return YES;
	}
	return NO;
}

- (BOOL)hasFace:(NSString*)md5 {
	return [m_faceRegistry objectForKey:md5] != nil;
}

- (BOOL)hasReceivedFace:(NSString*)filename {
	return [FileTool isFileExist:[FileTool getReceivedCustomFacePath:m_QQ file:filename]];
}

- (Face*)face:(int)groupIndex atIndex:(int)faceIndex {
	FaceGroup* g = [self group:groupIndex];
	if(g)
		return [g face:faceIndex];
	else
		return nil;
}

- (void)removeFace:(int)groupIndex face:(int)faceIndex {
	FaceGroup* g = [self group:groupIndex];
	if(g) {
		Face* face = [self face:groupIndex atIndex:faceIndex];
		[g removeFace:faceIndex];
		[face setGroupIndex:-1];
		[m_faceRegistry removeObjectForKey:[face md5]];
		m_dirty = YES;
	}
}

- (Face*)face:(NSString*)md5 {
	return [m_faceRegistry objectForKey:md5];
}

- (int)groupCount {
	return [m_groups count];
}

@end
