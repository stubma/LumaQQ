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

#import <Foundation/Foundation.h>


@interface PreferenceTool : NSObject {
	UInt32 _QQ;
	NSMutableDictionary* _preferences;
}

+ (PreferenceTool*)toolWithQQ:(UInt32)QQ;

- (id)initWithQQ:(UInt32)QQ;
- (void)save;
- (void)saveAndClear;
- (BOOL)booleanValue:(NSString*)key;
- (void)setBool:(BOOL)value forKey:(NSString*)key;
- (int)intValue:(NSString*)key;
- (int)intValue:(NSString*)key defaultValue:(int)defaultValue;
- (void)setInt:(int)value forKey:(NSString*)key;
- (NSString*)stringValue:(NSString*)key;
- (void)setString:(NSString*)value forKey:(NSString*)key;
- (NSArray*)arrayValue:(NSString*)key;
- (void)setArray:(NSArray*)value forKey:(NSString*)key;

@end
