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


@interface KeyTool : NSObject 

+ (NSString*)key2String:(NSEvent*)theEvent;
+ (NSString*)key2String:(unsigned int)modifier character:(UniChar)keyChar;
+ (BOOL)acceptable:(UniChar)keyChar;
+ (UInt32)string2Modifier:(NSString*)keyString;
+ (UInt32)cocoaModifier2CarbonModifier:(UInt32)modifier;
+ (UInt32)string2KeyCode:(NSString*)keyString;
+ (OSStatus)initAscii2KeyCodeTable;
+ (UInt32)ascii2KeyCode:(unsigned char)asciiCode;
+ (UniChar)string2KeyChar:(NSString*)keyString;

@end
