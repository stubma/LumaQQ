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

#import "FileBuffer.h"


@implementation FileBuffer

- (id)initWithFile:(NSFileHandle*)file {
	self = [super init];
	if(self) {
		if(file == nil)
			return nil;
		m_file = [file retain];
	}
	return self;
}

- (void) dealloc {
	[m_file release];
	[super dealloc];
}

- (char)getByte {
	NSData* data = [m_file readDataOfLength:1];
	return (char)((const char*)[data bytes])[0];
}

- (char)getByte:(int)offset {
	[m_file seekToFileOffset:offset];
	return [self getByte];
}

- (SInt16)getInt16 {
	NSData* data = [m_file readDataOfLength:2];
	SInt16 ret = *(SInt16*)[data bytes];
	return m_littleEndian ? EndianS16_NtoL(ret) : EndianS16_NtoB(ret);
}

- (SInt16)getInt16:(int)offset {
	[m_file seekToFileOffset:offset];
	return [self getInt16];
}

- (UInt16)getUInt16 {
	NSData* data = [m_file readDataOfLength:2];
	UInt16 ret = *(UInt16*)[data bytes];
	return m_littleEndian ? EndianU16_NtoL(ret) : EndianU16_NtoB(ret);
}

- (UInt16)getUInt16:(int)offset {
	[m_file seekToFileOffset:offset];
	return [self getUInt16];
}

- (SInt32)getInt32 {
	NSData* data = [m_file readDataOfLength:4];
	SInt32 ret = *(SInt32*)[data bytes];
	return m_littleEndian ? EndianS32_NtoL(ret) : EndianS32_NtoB(ret);
}

- (SInt32)getInt32:(int)offset {
	[m_file seekToFileOffset:offset];
	return [self getInt32];
}

- (UInt32)getUInt32 {
	NSData* data = [m_file readDataOfLength:4];
	UInt32 ret = *(UInt32*)[data bytes];
	return m_littleEndian ? EndianU32_NtoL(ret) : EndianU32_NtoB(ret);
}

- (UInt32)getUInt32:(int)offset {
	[m_file seekToFileOffset:offset];
	return [self getUInt32];
}

- (SInt64)getInt64 {
	NSData* data = [m_file readDataOfLength:8];
	SInt64 ret = *(SInt64*)[data bytes];
	return m_littleEndian ? EndianS64_NtoL(ret) : EndianS64_NtoB(ret);
}

- (SInt64)getInt64:(int)offset {
	[m_file seekToFileOffset:offset];
	return [self getInt64];
}

- (UInt64)getUInt64 {
	NSData* data = [m_file readDataOfLength:8];
	UInt64 ret = *(UInt64*)[data bytes];
	return m_littleEndian ? EndianU64_NtoL(ret) : EndianU64_NtoB(ret);
}

- (UInt64)getUInt64:(int)offset {
	[m_file seekToFileOffset:offset];
	return [self getUInt64];
}

- (NSData*)getBytes:(int)size {
	return [m_file readDataOfLength:size];
}

- (NSData*)getBytes:(int)offset size:(int)size {
	[m_file seekToFileOffset:offset];
	return [self getBytes:size];
}

- (BOOL)littleEndian {
	return m_littleEndian;
}

- (void)setLittleEndian:(BOOL)flag {
	m_littleEndian = flag;
}

- (void)seek:(int)offset {
	[m_file seekToFileOffset:offset];
}

- (int)offset {
	return [m_file offsetInFile];
}

@end
