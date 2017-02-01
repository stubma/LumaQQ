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

#import <Cocoa/Cocoa.h>

@interface PreferenceManager : NSObject {
	NSMutableDictionary* m_dict;
	NSString* m_path;
}

// class method
+ (PreferenceManager*)managerWithFile:(NSString*)filename;
+ (PreferenceManager*)managerWithQQ:(UInt32)QQ file:(NSString*)filename;

// initialization
- (id)initWithPath:(NSString*)path;

// initialize path
- (BOOL)initStore;
+ (BOOL)isPerferenceExist:(UInt32)iQQ file:(NSString*)filename;

// write to disk
- (void)sync;

// access value
- (NSString*)stringForKey:(NSString*)key;
- (BOOL)boolForKey:(NSString*)key;
- (NSArray*)arrayForKey:(NSString*)key;
- (int)integerForKey:(NSString*)key;
- (void)setInteger:(int)value forKey:(NSString*)key;
- (void)setObject:(id)value forKey:(NSString*)key;
- (id)objectForKey:(NSString*)key;
- (void)setBool:(BOOL)value forKey:(NSString*)key;
- (float)floatForKey:(NSString*)key;
- (void)setFloat:(float)value forKey:(NSString*)key;

@end
