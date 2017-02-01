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

#import "PreferenceTool.h"
#import "FileTool.h"
#import "Constants.h"

static NSMutableDictionary* _pMap;

@implementation PreferenceTool

+ (void)initialize {
	_pMap = [[NSMutableDictionary dictionary] retain];
}

+ (PreferenceTool*)toolWithQQ:(UInt32)QQ {
	NSNumber* key = [NSNumber numberWithUnsignedInt:QQ];
	PreferenceTool* tool = [_pMap objectForKey:key];
	if(tool == nil) {
		tool = [[[PreferenceTool alloc] initWithQQ:QQ] autorelease];
		[_pMap setObject:tool forKey:key];
	}
	return tool;
}

- (void) dealloc {
	[_preferences release];
	[super dealloc];
}

- (id)initWithQQ:(UInt32)QQ {
	self = [super init];
	if(self) {
		_QQ = QQ;
		NSString* path = [FileTool getFilePath:QQ ForFile:kLQFileSystem];
		_preferences = [[NSMutableDictionary dictionaryWithContentsOfFile:path] retain];
		if(_preferences == nil)
			_preferences = [[NSMutableDictionary dictionary] retain];
	}
	return self;
}

- (void)save {
	NSString* path = [FileTool getFilePath:_QQ ForFile:kLQFileSystem];
	[_preferences writeToFile:path atomically:YES];
}

- (void)saveAndClear {
	[self save];
	[_pMap removeObjectForKey:[NSNumber numberWithUnsignedInt:_QQ]];
}

- (BOOL)booleanValue:(NSString*)key {
	NSNumber* value = [_preferences objectForKey:key];
	if(value == nil)
		return NO;
	else
		return [value boolValue];
}

- (void)setBool:(BOOL)value forKey:(NSString*)key {
	NSNumber* valueInt = [NSNumber numberWithBool:value];
	[_preferences setObject:valueInt forKey:key];
}

- (NSString*)stringValue:(NSString*)key {
	NSString* value = [_preferences objectForKey:key];
	if(value == nil)
		return @"";
	else
		return value;
}

- (void)setString:(NSString*)value forKey:(NSString*)key {
	if(value != nil)
		[_preferences setObject:value forKey:key];
}

- (int)intValue:(NSString*)key {
	NSNumber* q = [_preferences objectForKey:key];
	if(q)
		return [q intValue];
	else
		return 0;
}

- (int)intValue:(NSString*)key defaultValue:(int)defaultValue {
	NSNumber* q = [_preferences objectForKey:key];
	if(q)
		return [q intValue];
	else
		return defaultValue;
}

- (void)setInt:(int)value forKey:(NSString*)key {
	[_preferences setObject:[NSNumber numberWithInt:value] forKey:key];
}

- (NSArray*)arrayValue:(NSString*)key {
	return [_preferences objectForKey:key];
}

- (void)setArray:(NSArray*)value forKey:(NSString*)key {
	if(value != nil)
		[_preferences setObject:value forKey:key];
}

@end
