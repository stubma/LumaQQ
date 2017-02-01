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

#import "NSData-MD5.h"
#import <openssl/MD5.h>

@implementation NSData (MD5)

- (NSData*)MD5 {
	// get target buffer
	NSMutableData* target = [NSMutableData dataWithLength:16];
	unsigned char* targetBuffer = (unsigned char*)[target mutableBytes];
	
	// get source buffer and md5 it
	const unsigned char* sourceBuffer = (const unsigned char*)[self bytes];
	MD5(sourceBuffer, [self length], targetBuffer);
	
	return target;
}

@end
