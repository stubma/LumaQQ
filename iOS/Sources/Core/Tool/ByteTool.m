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

#import <iconv.h>
#import "ByteTool.h"
#import "QQConstants.h"
#import "NSData-BytesOperation.h"

@implementation ByteTool

+ (char*)encipher:(const char*)input key:(const char*)key output:(char*)output {
	// iterate times
	int loop = 0x10;
	
	// variables
	UInt32 y = [ByteTool getUInt32:input offset:0 length:4];
	UInt32 z = [ByteTool getUInt32:input offset:4 length:4];
	UInt32 a = [ByteTool getUInt32:key offset:0 length:4];
	UInt32 b = [ByteTool getUInt32:key offset:4 length:4];
	UInt32 c = [ByteTool getUInt32:key offset:8 length:4];
	UInt32 d = [ByteTool getUInt32:key offset:12 length:4];
	
	// control variable
	// TEA delta£¨(sqr(5) - 1) * 2^31
	UInt32 sum = 0;
	UInt32 delta = 0x9E3779B9;
	// iterate
	while (loop-- > 0) {
		sum += delta;
		y += ((z << 4) + a) ^ (z + sum) ^ ((z >> 5) + b);
		z += ((y << 4) + c) ^ (y + sum) ^ ((y >> 5) + d);
	}
	
	// output crypted data
	[ByteTool writeUInt32:output value:y at:0];
	[ByteTool writeUInt32:output value:z at:4];
	return output;
}

+ (UInt32)getUInt32:(const char*)bytes offset:(int)offset {
	return [self getUInt32:bytes offset:offset length:4];
}

+ (UInt32)getUInt32:(const char*)bytes offset:(int)offset length:(int)length {
	UInt32 ret = 0;
	int end = 0;
	int i;
	
	if(length > 4)
		end = offset + 4;
	else
		end = offset + length;
	for(i = offset; i < end; i++) {
		ret <<= 8;
		ret |= bytes[i] & 0xFF;
	}
	return ret;
}

+ (void)writeUInt32:(char*)bytes value:(UInt32)value at:(int)offset {
	UInt32 u = EndianU32_NtoB(value);
	memcpy(bytes + offset, &u, 4);
}

+ (void)writeUInt32:(char*)bytes value:(UInt32)value at:(int)offset littleEndian:(BOOL)littleEndian {
	UInt32 u = 0;
	if(littleEndian)
		u = EndianU32_NtoL(value);
	else
		u = EndianU32_NtoB(value);
	memcpy(bytes + offset, &u, 4);
}

+ (UInt16)getUInt16:(const char*)bytes offset:(int)offset {
	int i;
	UInt16 ret = 0;
	for(i = offset; i < offset + 2; i++) {
		ret <<= 8;
		ret |= bytes[i] & 0xFF;
	}
	return ret;
}

+ (void)writeUInt16:(char*)bytes value:(UInt16)value at:(int)offset {
	UInt16 u = EndianU16_NtoB(value);
	memcpy(bytes + offset, &u, 2);
}

+ (void)getBytes:(char*)bytes from:(const char*)buffer start:(int)offset length:(int)length {
	memcpy(bytes, buffer + offset, length);
}

+ (void)writeBytes:(const char*)bytes to:(char*)buffer start:(int)offset length:(int)length {
	memcpy(buffer + offset, bytes, length);
}

+ (NSData*)randomKey {
	NSMutableData* key = [NSMutableData dataWithLength:kQQKeyLength];
	char* bytes = (char*)[key mutableBytes];
	int i;
	for(i = 0; i < kQQKeyLength; i++)
		bytes[i] = random();
	return key;
}

+ (void)convertBytes:(const char*)bytes length:(int)length from:(const char*)from to:(const char*)to outBuf:(char**)outBuf outLength:(int*)outLength {
	size_t outBytes = length * 2 + 1;
	size_t outBytesBak = outBytes;
	size_t inBytes = length;
	const char* src = bytes;
	*outLength = 0;
	
	// open conv handle
	iconv_t hConv = iconv_open(to, from);
	if(hConv == (iconv_t)-1)
		return;
	
	// if success, alloc memory
	char* dst = (char*)malloc(sizeof(char) * outBytes);
	char* dstBak = dst;
	
	// convert
	size_t ret = iconv(hConv, (const char**)&src, &inBytes, &dstBak, &outBytesBak);
	iconv_close(hConv);
	
	// not 0 means error
	if(ret != 0) {
		free(dst);
	} else {
		*outLength = outBytes - outBytesBak;
		dst[*outLength] = 0;
		*outBuf = dst;
	}
}

+ (NSString*)getString:(NSData*)data encoding:(int)encoding {
	switch(encoding) {
		case kQQEncodingASCII:
		case kQQEncodingUTF8:
		{
			NSString* str = (NSString*)CFStringCreateFromExternalRepresentation(kCFAllocatorDefault,
																				(CFDataRef)data,
																				kCFStringEncodingUTF8);
			return str == nil ? @"" : [str autorelease];
		}
		default:
		{
			const char* bytes = (const char*)[data bytes];
			int length = [data length];
			int dstLength = 0;
			char* dst = NULL;
			[self convertBytes:bytes
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

+ (NSString*)getString:(const char*)bytes length:(int)length {
	return [self getString:bytes length:length encoding:kQQEncodingDefault];
}

+ (NSString*)getString:(const char*)bytes length:(int)length encoding:(int)encoding {
	return [self getString:[NSData dataWithBytes:bytes length:length] encoding:encoding];
}

+ (NSString*)getString:(NSData*)data {
	return [self getString:data encoding:kQQEncodingDefault];
}

+ (NSData*)getBytes:(NSString*)str {
	return [self getBytes:str encoding:kQQEncodingDefault];
}

+ (NSData*)getBytes:(NSString*)str encoding:(int)encoding {
	// map encoding
	switch(encoding) {
		case kQQEncodingASCII:
		case kQQEncodingUTF8:
		{
			const char* bytes = [str UTF8String];
			NSData* ret = [NSData dataWithBytes:bytes length:strlen(bytes)];
			return ret;
		}
		default:
		{
			const char* bytes = [str UTF8String];
			int length = strlen(bytes);
			int dstLength = 0;
			char* dst = NULL;
			[self convertBytes:bytes
						length:length
						  from:"UTF-8"
							to:"GB18030"
						outBuf:&dst
					 outLength:&dstLength];
			if(dstLength > 0) {
				NSData* ret = [NSData dataWithBytes:dst length:dstLength];
				free(dst);
				return ret;
			} else
				return [NSData data];
		}
	}
}

+ (NSString*)ip2String:(const char*)ip {
	NSString* address = [NSString stringWithFormat:@"%d.%d.%d.%d", ip[0] & 0xFF, ip[1] & 0xFF, ip[2] & 0xFF, ip[3] & 0xFF];
	return address;
}

+ (NSString*)ipData2String:(NSData*)data {
	const char* ip = (const char*)[data bytes];
	return [ByteTool ip2String:ip];
}

+ (NSData*)string2IpData:(NSString*)string {
	NSArray* components = [string componentsSeparatedByString:@"."];
	NSMutableData* data = [NSMutableData dataWithLength:4];
	if([components count] == 4) {
		char* ip = (char*)[data mutableBytes];
		int value = [[components objectAtIndex:0] intValue];
		if(value > 255 || value < 0)
			return nil;
		ip[0] = value & 0xFF;
		value = [[components objectAtIndex:1] intValue];
		if(value > 255 || value < 0)
			return nil;
		ip[1] = value & 0xFF;
		value = [[components objectAtIndex:2] intValue];
		if(value > 255 || value < 0)
			return nil;
		ip[2] = value & 0xFF;
		value = [[components objectAtIndex:3] intValue];
		if(value > 255 || value < 0)
			return nil;
		ip[3] = value & 0xFF;
		
		return data;
	} else {
		NSLog(@"Error IP String Format: %@", string);
		return nil;
	}
}

+ (void)reverseIp:(char*)ip {
	char tmp = ip[0];
	ip[0] = ip[3];
	ip[3] = tmp;
	tmp = ip[1];
	ip[1] = ip[2];
	ip[2] = tmp;
}

@end
