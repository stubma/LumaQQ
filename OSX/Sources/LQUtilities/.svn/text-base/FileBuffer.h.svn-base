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


@interface FileBuffer : NSObject {
	NSFileHandle* m_file;
	BOOL m_littleEndian;
}

- (id)initWithFile:(NSFileHandle*)file;

- (char)getByte;
- (char)getByte:(int)offset;
- (SInt16)getInt16;
- (SInt16)getInt16:(int)offset;
- (UInt16)getUInt16;
- (UInt16)getUInt16:(int)offset;
- (SInt32)getInt32;
- (SInt32)getInt32:(int)offset;
- (UInt32)getUInt32;
- (UInt32)getUInt32:(int)offset;
- (SInt64)getInt64;
- (SInt64)getInt64:(int)offset;
- (UInt64)getUInt64;
- (UInt64)getUInt64:(int)offset;
- (NSData*)getBytes:(int)size;
- (NSData*)getBytes:(int)offset size:(int)size;

- (BOOL)littleEndian;
- (void)setLittleEndian:(BOOL)flag;

- (void)seek:(int)offset;
- (int)offset;

@end
