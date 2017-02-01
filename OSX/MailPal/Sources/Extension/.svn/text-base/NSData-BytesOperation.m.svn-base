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

#import "NSData-BytesOperation.h"
#import "NSMutableData-CustomAppending.h"

@implementation NSData (BytesOperation)

+ (NSData*)dataWithHexString:(NSString*)string {
	NSMutableData* data = [NSMutableData data];
	const char* bytes = [string UTF8String];
	int len = strlen(bytes);
	int index = 1;
	char value = 0;
	int i;
	for(i = 0; i < len; i++) {
		if(bytes[i] == ' ') {
			[data appendByte:value];
			value = 0;
			index = 1;
		} else if(bytes[i] >= '0' && bytes[i] <= '9') {
			value |= (bytes[i] - '0') << (index * 4);
			index--;
		} else if(bytes[i] >= 'A' && bytes[i] <= 'F') {
			value |= (bytes[i] - 'A' + 10) << (index * 4);
			index--;
		} else if(bytes[i] >= 'a' && bytes[i] <= 'f') {
			value |= (bytes[i] - 'a' + 10) << (index * 4);
			index--;
		}
	}
	if(index == -1)
		[data appendByte:value];
	return data;
}

- (int)indexOfByte:(char)byte from:(int)from {
	const char* bytes = (const char*)[self bytes];
	int length = [self length];
	int i;
	for(i = from; i < length; i++) {
		if(bytes[i] == byte)
			return i;
	}
	return -1;
}

- (int)indexOfBytes:(char*)bytes length:(int)length from:(int)from {
	const char* datas = (const char*)[self bytes];
	int dataLen = [self length];
	int i, j;
	for(i = from; i < dataLen; i++) {
		for(j = 0; j < length; j++) {
			if(datas[i] == bytes[j])
				return i;
		}
	}
	return -1;
}

- (void)toNative:(int)swapUnit sourceIsLittleEndian:(BOOL)flag {
	int i;
	int length = [self length];
	if(length > 0 && (length % swapUnit) == 0) {
		char* bytes = (char*)[self bytes];
		for(i = 0; i < length; i += swapUnit) {
			switch(swapUnit) {
				case 2:
				{
					UInt16 _u16;
					if(flag)
						_u16 = EndianU16_LtoN(*(UInt16*)(&bytes[i]));
					else
						_u16 = EndianU16_BtoN(*(UInt16*)(&bytes[i]));
					memcpy(bytes + i, (char*)&_u16, 2);
					break;
				}
				case 4:
				{
					UInt32 _u32;
					if(flag)
						_u32 = EndianU32_LtoN(*(UInt32*)(&bytes[i]));
					else
						_u32 = EndianU32_BtoN(*(UInt32*)(&bytes[i]));
					memcpy(bytes + i, (char*)&_u32, 4);
					break;
				}
				case 8:
				{
					UInt64 _u64;
					if(flag)
						_u64 = EndianU64_LtoN(*(UInt64*)(&bytes[i]));
					else
						_u64 = EndianU64_BtoN(*(UInt64*)(&bytes[i]));
					memcpy(bytes + i, (char*)&_u64, 8);
					break;
				}
			}
		}
	}
}

- (NSString*)hexString {
	return [self hexString:YES];
}

- (NSString*)hexString:(BOOL)withSpace {
	int i;
	const char* bytes = (const char*)[self bytes];
	int length = [self length];
	NSMutableString* s = [NSMutableString stringWithCapacity:(length * 2)];
	for(i = 0; i < length; i++) {
		NSString* hex = [NSString stringWithFormat:@"%X", (bytes[i] & 0xFF)];
		if([hex length] < 2)
			[s appendString:@"0"];
		[s appendString:hex];
		
		// append space
		if(withSpace)
			[s appendString:@" "];
	}
	return s;
}

@end
