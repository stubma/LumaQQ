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

#import <iconv.h>
#import "ByteTool.h"
#import "Constants.h"
#import "NSData-BytesOperation.h"

@implementation ByteTool

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

+ (int)startOfBytes:(const char*)subBytes subLength:(int)subLength in:(const char*)bytes length:(int)length {
	int* next = (int*)malloc(sizeof(int) * subLength);
	next[0] = 0;
	int temp;
	int i;
	
	// build kmp next
	for(i = 1; i < subLength; i++) { 
		temp = next[i - 1]; 
		
		while(subBytes[i] != subBytes[temp] && temp > 0)
			temp = next[temp - 1]; 
		
		if(subBytes[i] == subBytes[temp]) 
			next[i] = temp + 1; 
		else 
			next[i] = 0; 
	} 
	
	// match pointer
	int tp = 0; 
	int mp = 0; 
	
	// kmp
	for(tp = 0; tp < length; tp++) { 
		while(bytes[tp] != subBytes[mp] && mp) 
			mp = next[mp - 1]; 
		
		if(bytes[tp] == subBytes[mp]) 
			mp++; 
		
		if(mp == subLength)
			return tp - mp + 1; 
	} 
	
	if(tp == length) 
		return -1; 
	
	free(next);
}

+ (NSString*)getString:(NSData*)data encoding:(int)encoding {
	switch(encoding) {
		case kMPEncodingASCII:
		case kMPEncodingUTF8:
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
	return [self getString:bytes length:length encoding:kMPEncodingDefault];
}

+ (NSString*)getString:(const char*)bytes length:(int)length encoding:(int)encoding {
	return [self getString:[NSData dataWithBytes:bytes length:length] encoding:encoding];
}

+ (NSString*)getString:(NSData*)data {
	return [self getString:data encoding:kMPEncodingDefault];
}

+ (NSData*)getBytes:(NSString*)str {
	return [self getBytes:str encoding:kMPEncodingDefault];
}

+ (NSData*)getBytes:(NSString*)str encoding:(int)encoding {
	// map encoding
	switch(encoding) {
		case kMPEncodingASCII:
		case kMPEncodingUTF8:
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
