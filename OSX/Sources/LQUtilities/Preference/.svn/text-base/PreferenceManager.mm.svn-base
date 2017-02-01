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

#import "Constants.h"
#import "PreferenceManager.h"
#import "PreferenceConstants.h"
#import "FileTool.h"

@implementation PreferenceManager

static NSMutableDictionary* cache = nil;

+ (void)initialize {
	cache = [[NSMutableDictionary dictionary] retain];
}

+ (PreferenceManager*)managerWithFile:(NSString*)filename {
	NSString* path = [FileTool getGlobalFilePath:filename];
	PreferenceManager* ret = [cache objectForKey:path];
	if(ret == nil) {
		ret = [[[PreferenceManager alloc] initWithPath:path] autorelease];
		[cache setObject:ret forKey:path];
	}
	return ret;
}

+ (PreferenceManager*)managerWithQQ:(UInt32)QQ file:(NSString*)filename {
	NSString* path = [FileTool getFilePath:QQ ForFile:filename];
	PreferenceManager* ret = [cache objectForKey:path];
	if(ret == nil) {
		ret = [[[PreferenceManager alloc] initWithPath:path] autorelease];
		[cache setObject:ret forKey:path];
	}
	return ret;
}

- (id)initWithPath:(NSString*)path {
	self = [super init];
	if(self != nil) {
		m_path = [path retain];
		[self initStore];
	}
	return self;
}

- (BOOL)initStore {
	// create directory structure for the file
	[FileTool initDirectoryForFile:m_path];
	m_dict = [[NSMutableDictionary dictionaryWithContentsOfFile:m_path] retain];
	if(m_dict == nil)
		m_dict = [[NSMutableDictionary dictionary] retain];
	return YES;
}

+ (BOOL)isPerferenceExist:(UInt32)iQQ file:(NSString*)filename {
	return [FileTool isFileExist:[FileTool getFilePath:iQQ ForFile:filename]];
}

- (void)sync {
	if(m_dict != nil) {
		if(![m_dict writeToFile:m_path atomically:YES])
			NSLog(@"Preference save failed");
	}
}

- (void) dealloc {
	[cache removeObjectForKey:m_path];
	[m_dict release];
	[m_path release];
	[super dealloc];
}

- (NSString*)stringForKey:(NSString*)key {
	return [m_dict objectForKey:key];
}

- (NSArray*)arrayForKey:(NSString*)key {
	return [m_dict objectForKey:key];
}

- (BOOL)boolForKey:(NSString*)key {
	NSNumber* number = [m_dict objectForKey:key];
	return [number boolValue];
}

- (int)integerForKey:(NSString*)key {
	NSNumber* number = [m_dict objectForKey:key];
	return [number intValue];
}

- (void)setObject:(id)value forKey:(NSString*)key {
	[m_dict setObject:value forKey:key];
}

- (id)objectForKey:(NSString*)key {
	return [m_dict objectForKey:key];
}

- (void)setBool:(BOOL)value forKey:(NSString*)key {
	[m_dict setObject:[NSNumber numberWithBool:value] forKey:key];
}

- (void)setInteger:(int)value forKey:(NSString*)key {
	[m_dict setObject:[NSNumber numberWithInt:value] forKey:key];
}

- (float)floatForKey:(NSString*)key {
	NSNumber* number = [m_dict objectForKey:key];
	return [number floatValue];
}

- (void)setFloat:(float)value forKey:(NSString*)key {
	[m_dict setObject:[NSNumber numberWithFloat:value] forKey:key];
}

@end
