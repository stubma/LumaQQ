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

/*
 * the start position for a ByteBuffer always begin from 0, it handles the conversion internally
 */

@interface ByteBuffer : NSObject {
	char* m_buffer;
	int m_pos;
	int m_end; // exclusive
	int m_from;
}

+ (ByteBuffer*)bufferWithBytes:(char*)bytes length:(int)length;
+ (ByteBuffer*)bufferWithBytes:(char*)bytes from:(int)from length:(int)length;

// initialization
- (id)initWithBuffer:(char*)buffer length:(int)length;
- (id)initWithBuffer:(char*)buffer from:(int)from length:(int)length;

// read & write
- (UInt32)getUInt32;
- (void)writeUInt32:(UInt32)value;
- (void)writeUInt32:(UInt32)value littleEndian:(BOOL)littleEndian;
- (UInt16)getUInt16;
- (void)writeUInt16:(UInt16)value;
- (void)writeUInt16:(UInt16)value position:(int)pos;
- (void)getBytes:(char*)bytes length:(int)length;
- (void)writeBytes:(const char*)bytes length:(int)length;
- (char)getByte;
- (char)getByte:(int)pos;
- (void)writeByte:(char)byte;
- (void)getBytes:(NSMutableData*)data;
- (void)writeBytes:(NSData*)data;
- (void)writeBytes:(NSData*)data from:(int)from length:(int)length;
- (void)writeBytes:(NSData*)data maxLength:(int)max;
- (void)writeByte:(char)byte repeat:(int)times;
- (void)writeString:(NSString*)string;
- (void)writeString:(NSString*)string withLength:(BOOL)writeLength lengthByte:(int)bytes;
- (void)writeString:(NSString*)string withLength:(BOOL)writeLength lengthByte:(int)bytes lengthBase:(int)base;
- (void)writeString:(NSString*)string withLength:(BOOL)writeLength lengthByte:(int)bytes lengthBase:(int)base encoding:(int)encoding;
- (void)writeString:(NSString*)string maxLength:(int)max fillZero:(BOOL)fillZero;
- (void)writeHexString:(char)byte;
- (void)writeHexStrings:(NSData*)data;
- (void)writeHexStrings:(NSData*)data littleEndian:(BOOL)flag;
- (void)writeHexStringWithUInt32:(UInt32)value littleEndian:(BOOL)littleEndian spaceForZero:(BOOL)spaceForZero;
- (void)writeDecimalString:(int)value length:(int)length spaceForZero:(BOOL)spaceForZero;
- (NSString*)getString;
- (NSString*)getString:(int)length;
- (NSString*)getString:(int)length encoding:(int)encoding;
- (NSString*)getStringUntil:(char)delimiter;
- (NSString*)getStringUntil:(char)delimiter maxLength:(int)max;
- (NSString*)getStringUntil:(char)delimiter encoding:(int)encoding;
- (void)skip:(int)length;

// getter and setter
- (int)position;
- (void)setPosition:(int)pos;
- (int)length;
- (int)available;
- (BOOL)hasAvailable;
- (NSData*)dataOfRange:(NSRange)range;

@end
