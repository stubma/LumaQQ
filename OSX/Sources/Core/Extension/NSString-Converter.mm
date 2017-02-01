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

#import "NSString-Converter.h"


@implementation NSString (Converter)

- (int)hexIntValue {
	int ret = 0;
	int length = MIN([self length], 8);
	if(length == 0)
		return 0;
	
	for(int i = 0; i < length; i++) {
		UniChar c = [self characterAtIndex:i];
		if(c >= '0' && c <= '9') 
			c -= '0';
		else if(c >= 'A' && c <= 'F')
			c -= 'A' - 10;
		else if(c >= 'a' && c <= 'f')
			c -= 'a' - 10;
		else if(c == ' ')
			continue;
		else
			break;
		
		c <<= ((length - i - 1) * 4);
		ret |= c;
	}
	
	return ret;
}

- (char)hexCharValue:(int)start {
	char ret = 0;
	int length = MIN([self length] - start, 2);
	if(length == 0)
		return 0;
	
	for(int i = start; i < start + length; i++) {
		UniChar c = [self characterAtIndex:i];
		if(c >= '0' && c <= '9') 
			c -= '0';
		else if(c >= 'A' && c <= 'F')
			c -= 'A' - 10;
		else if(c >= 'a' && c <= 'f')
			c -= 'a' - 10;
		else if(c == ' ')
			continue;
		else
			break;
		
		c <<= ((length + start - i - 1) * 4);
		ret |= c;
	}
	
	return ret;
}

- (char)hexCharValue {
	return [self hexCharValue:0];
}

- (NSData*)hexData {
	if([self length] == 0)
		return [NSData data];
	
	int count = ([self length] - 1) / 2 + 1;
	NSMutableData* data = [NSMutableData dataWithLength:count];
	char* bytes = (char*)[data mutableBytes];
	
	for(int i = 0; i < count; i++) {
		char byte = [self hexCharValue:(i * 2)];
		bytes[i] = byte;
	}
	
	return data;
}

@end
