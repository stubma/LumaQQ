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

#import "ByteBuffer.h"
#import "ByteTool.h"
#import "QQConstants.h"

@implementation ByteBuffer

+ (ByteBuffer*)bufferWithBytes:(char*)bytes length:(int)length {
	ByteBuffer* buffer = [[ByteBuffer alloc] initWithBuffer:bytes from:0 length:length];
	return [buffer autorelease];
}

+ (ByteBuffer*)bufferWithBytes:(char*)bytes from:(int)from length:(int)length {
	ByteBuffer* buffer = [[ByteBuffer alloc] initWithBuffer:bytes from:from length:length];
	return [buffer autorelease];
}

- (id)initWithBuffer:(char*)buffer length:(int)length {
	return [self initWithBuffer:buffer from:0 length:length];
}

- (id)initWithBuffer:(char*)buffer from:(int)from length:(int)length {
	self = [super init];
	if(self) {
		m_buffer = buffer;
		m_pos = from;
		m_from = from;
		m_end = m_from + length;
	}
	return self;
}

#pragma mark -
#pragma mark read and write

- (UInt32)getUInt32 {
	UInt32 value = [ByteTool getUInt32:m_buffer offset:m_pos];
	m_pos +=4;
	return value;
}

- (void)writeUInt32:(UInt32)value {
	[ByteTool writeUInt32:m_buffer value:value at:m_pos];
	m_pos += 4;
}

- (void)writeUInt32:(UInt32)value littleEndian:(BOOL)littleEndian {
	[ByteTool writeUInt32:m_buffer value:value at:m_pos littleEndian:littleEndian];
	m_pos += 4;
}

- (UInt16)getUInt16 {
	UInt16 value = [ByteTool getUInt16:m_buffer offset:m_pos];
	m_pos += 2;
	return value;
}

- (void)writeUInt16:(UInt16)value {
	[ByteTool writeUInt16:m_buffer value:value at:m_pos];
	m_pos += 2;
}

- (void)writeUInt16:(UInt16)value position:(int)pos {
	[ByteTool writeUInt16:m_buffer value:value at:(m_from + pos)];
}

- (void)getBytes:(char*)bytes length:(int)length {
	memcpy(bytes, m_buffer + m_pos, length);
	m_pos += length;
}

- (void)writeBytes:(const char*)bytes length:(int)length {
	memcpy(m_buffer + m_pos, bytes, length);
	m_pos += length;
}

- (char)getByte {
	m_pos++;
	return m_buffer[m_pos - 1];
}

- (char)getByte:(int)pos {
	return m_buffer[pos];
}

- (void)writeByte:(char)byte {
	[self writeByte:byte repeat:1];
}

- (void)getBytes:(NSMutableData*)data {
	memcpy([data mutableBytes], m_buffer + m_pos, [data length]);
	m_pos += [data length];
}

- (void)writeBytes:(NSData*)data {
	memcpy(m_buffer + m_pos, [data bytes], [data length]);
	m_pos += [data length];
}

- (void)writeBytes:(NSData*)data from:(int)from length:(int)length {
	memcpy(m_buffer + m_pos, ((const char*)[data bytes]) + from, length);
	m_pos += length;
}

- (void)writeBytes:(NSData*)data maxLength:(int)max {
	int len = MIN(max, [data length]);
	memcpy(m_buffer + m_pos, [data bytes], len);
	m_pos += len;
}

- (void)writeByte:(char)byte repeat:(int)times {
	int i;
	for(i = 0; i < times; i++)
		m_buffer[m_pos++] = byte;
}

- (void)writeString:(NSString*)string {
	if(string) {
		NSData* data = [ByteTool getBytes:string];
		[self writeBytes:data];
	}
}

- (void)writeString:(NSString*)string maxLength:(int)max fillZero:(BOOL)fillZero {
	int length = 0;
	
	if(string) {
		NSData* data = [ByteTool getBytes:string];
		[self writeBytes:data maxLength:max];
		length = [data length];
	}
	
	// fill zero
	if(fillZero) {
		if(length < max)
			[self writeByte:0 repeat:(max - length)];
	}
}

- (void)writeString:(NSString*)string withLength:(BOOL)writeLength lengthByte:(int)bytes {
	[self writeString:string
		   withLength:writeLength
		   lengthByte:bytes
		   lengthBase:0];
}

- (void)writeString:(NSString*)string withLength:(BOOL)writeLength lengthByte:(int)bytes lengthBase:(int)base {
	[self writeString:string
		   withLength:writeLength
		   lengthByte:bytes
		   lengthBase:0
			 encoding:kQQEncodingDefault];
}

- (void)writeString:(NSString*)string withLength:(BOOL)writeLength lengthByte:(int)bytes lengthBase:(int)base encoding:(int)encoding {
	int length = 0;
	
	NSData* data = nil;
	if(string) {
		data = [ByteTool getBytes:string encoding:encoding];
		length = [data length];
	}		
	
	// write length
	if(writeLength) {
		switch(bytes) {
			case 1:
				[self writeByte:(length + base)];
				break;
			case 2:
				[self writeUInt16:(length + base)];
				break;
			default:
				[self writeUInt32:(length + base)];
				break;
		}
	}
	
	if(string)
		[self writeBytes:data];
}

- (void)writeHexString:(char)byte {
	// get higher 4 bits
	char c = (byte >> 4) & 0x0F;
	c = (c >= 10) ? ('A' + c - 10) : ('0' + c);
	[self writeByte:c];
	c = byte & 0x0F;
	c = (c >= 10) ? ('A' + c - 10) : ('0' + c);
	[self writeByte:c];
}

- (void)writeHexStrings:(NSData*)data {
	[self writeHexStrings:data littleEndian:NO];
}

- (void)writeHexStrings:(NSData*)data littleEndian:(BOOL)flag {
	const char* bytes = (const char*)[data bytes];
	int start = flag ? [data length] - 1 : 0;
	int end = flag ? -1 : [data length];
	int delta = flag ? -1 : 1;
	int i;
	for(i = start; i != end; i += delta)
		[self writeHexString:bytes[i]];
}

- (void)writeHexStringWithUInt32:(UInt32)value littleEndian:(BOOL)littleEndian spaceForZero:(BOOL)spaceForZero {
	if(littleEndian)
		value = EndianU32_NtoL(value);
	else
		value = EndianU32_NtoB(value);
	
	int i;
	char* p = (char*)&value;
	for(i = 0; i < 4; i++) {
		char c = (p[i] >> 4) & 0x0F;
		if(c == 0 && spaceForZero) 
			[self writeByte:' '];
		else {
			c = (c >= 10) ? ('A' + c - 10) : ('0' + c);
			[self writeByte:c];
			spaceForZero = NO;
		}
		
		c = p[i] & 0x0F;
		if(c == 0 && spaceForZero) 
			[self writeByte:' '];
		else {
			c = (c >= 10) ? ('A' + c - 10) : ('0' + c);
			[self writeByte:c];
			spaceForZero = NO;
		}
	}
}

- (void)writeDecimalString:(int)value length:(int)length spaceForZero:(BOOL)spaceForZero {
	NSString* s = [[NSNumber numberWithInt:value] description];
	int fillZero = length - [s length];
	length -= MAX(0, fillZero);
	while(fillZero-- > 0)
		[self writeByte:(spaceForZero ? 0x20 : '0')];
	fillZero = 0;
	while(length-- > 0)
		[self writeByte:[s characterAtIndex:fillZero++]];
}

- (NSString*)getString:(int)length encoding:(int)encoding {
	if(length == 0) 
		return @"";
	
	NSMutableData* data = [NSMutableData dataWithLength:length];
	[self getBytes:data];
	NSString* str = nil;
	switch(encoding) {
		case kQQEncodingASCII:
		case kQQEncodingUTF8:
		{
			str = (NSString*)CFStringCreateFromExternalRepresentation(kCFAllocatorDefault,
																	  (CFDataRef)data,
																	  kCFStringEncodingUTF8);
			return (str == nil) ? @"" : [str autorelease];
		}
		default:
		{
			const char* bytes = (const char*)[data bytes];
			int length = [data length];
			int dstLength = 0;
			char* dst = NULL;
			[ByteTool convertBytes:bytes
							length:length
							  from:"GB18030"
								to:"UTF-8"
							outBuf:&dst
						 outLength:&dstLength];
			if(dstLength > 0) {
				NSString* str = [NSString stringWithUTF8String:dst];
				free(dst);
				return str == nil ? @"" : str;
			} else
				return @"";
		}
	}
}

- (NSString*)getString {
	return [self getString:[self available]];
}

- (NSString*)getString:(int)length {
	return [self getString:length encoding:kQQEncodingDefault];
}

- (NSString*)getStringUntil:(char)delimiter {
	return [self getStringUntil:delimiter encoding:kQQEncodingDefault];
}

- (NSString*)getStringUntil:(char)delimiter maxLength:(int)max {
	int oldPos = m_pos;
	int pos = m_pos;
	while(pos < m_end && m_buffer[pos] != delimiter && (pos - m_pos) < max)
		pos++;
	
	NSString* s = [self getString:(pos - m_pos)];
	m_pos = MIN(oldPos + max, m_end);
	return s;
}

- (NSString*)getStringUntil:(char)delimiter encoding:(int)encoding {
	int pos = m_pos;
	while(pos < m_end && m_buffer[pos] != delimiter) 
		pos++;
	
	NSString* s = [self getString:(pos - m_pos) encoding:encoding];
	if(m_pos < m_end)
		m_pos++;
	return s; 
}

- (void)skip:(int)length {
	m_pos += length;
}

#pragma mark -
#pragma mark getter and setter

- (int)position {
	return m_pos - m_from;
}

- (void)setPosition:(int)pos {
	m_pos = pos + m_from;
}

- (int)length {
	return m_end - m_from;
}

- (int)available {
	return m_end - m_pos;
}

- (BOOL)hasAvailable {
	return [self available] > 0;
}

- (NSData*)dataOfRange:(NSRange)range {
	range.location = MAX(0, range.location);
	range.location = MIN([self length] - 1, range.location);
	range.length = MAX(0, range.length);
	range.length = MIN([self length] - range.location, range.length);
	return [NSData dataWithBytes:(m_buffer + m_from + range.location) length:range.length];
}

@end
