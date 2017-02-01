/*
 * MailPal - A Garbage Code Terminator for iPhone Mail
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

@interface ByteTool : NSObject {

}

+ (UInt32)getUInt32:(const char*)bytes offset:(int)offset;
+ (UInt32)getUInt32:(const char*)bytes offset:(int)offset length:(int)length;
+ (void)writeUInt32:(char*)bytes value:(UInt32)value at:(int)offset;
+ (UInt16)getUInt16:(const char*)bytes offset:(int)offset;
+ (void)writeUInt16:(char*)bytes value:(UInt16)value at:(int)offset;
+ (void)getBytes:(char*)bytes from:(const char*)buffer start:(int)offset length:(int)length;
+ (void)writeBytes:(const char*)bytes to:(char*)buffer start:(int)offset length:(int)length;
+ (void)convertBytes:(const char*)bytes length:(int)length from:(const char*)from to:(const char*)to outBuf:(char**)outBuf outLength:(int*)outLength;
+ (int)startOfBytes:(const char*)subBytes subLength:(int)subLength in:(const char*)bytes length:(int)length;

+ (NSString*)getString:(const char*)bytes length:(int)length;
+ (NSString*)getString:(const char*)bytes length:(int)length encoding:(int)encoding;
+ (NSData*)getBytes:(NSString*)str;
+ (NSData*)getBytes:(NSString*)str encoding:(int)encoding;
+ (NSString*)getString:(NSData*)data encoding:(int)encoding;
+ (NSString*)getString:(NSData*)data;
+ (NSString*)ip2String:(const char*)ip;
+ (NSString*)ipData2String:(NSData*)data;
+ (NSData*)string2IpData:(NSString*)string;
+ (void)reverseIp:(char*)ip;

@end
