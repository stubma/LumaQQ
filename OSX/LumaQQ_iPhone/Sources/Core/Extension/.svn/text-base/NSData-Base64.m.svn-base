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

#import "NSData-Base64.h"

@implementation NSData (Base64)

const char alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

- (NSData*)base64Encode {
	const unsigned char* data = (const unsigned char*)[self bytes];
    int len = [self length];
    
    NSMutableData* target = [NSMutableData dataWithLength: ((len - 1) / 3 + 1) * 4];
    unsigned char* output = (unsigned char*)[target mutableBytes];
    
    unsigned long val;
    int quad, trip;
    int i, j;
    for(i = 0, j = 0; i < len; i += 3, j += 4) {
        quad = 0;
        trip = 0;
        
        val = data[i];
        val <<= 8;
        
        if((i + 1) < len) {
            val |= data[i + 1];
            trip = 1;
        }
        val <<= 8;
        
        if((i + 2) < len) {
            val |= data[i + 2];
            quad = 1;
        }
        
        output[j + 3] = alphabet[(quad ? (val & 0x3f) : 64)];
        val >>= 6;
        output[j + 2] = alphabet[(trip ? (val & 0x3f) : 64)];
        val >>= 6;
        output[j + 1] = alphabet[val & 0x3f];
        val >>= 6;
        output[j] = alphabet[val];
    }
    
    return target;
}

- (NSData*)base64Decode {
	const unsigned char* data = (const unsigned char*)[self bytes];
    int len = [self length];
    
    NSMutableData* target = [NSMutableData dataWithLength: (len / 4) * 3];
    unsigned char* out = (unsigned char*)[target mutableBytes];
    
    UInt32 val;
    int i, j, k;
    for(i = 0, j = 0; i + 3 < len; i += 4, j += 3) {
        val = 0;
        for(k = i; k < i + 4; k++) {
            if(data[k] >= 'A' && data[k] <= 'Z') {
                val <<= 6;
                val += data[k] - 'A';
            } else if(data[k] >= 'a' && data[k] <= 'z') {
                val <<= 6;
                val += data[k] - 'a' + 26;
            } else if(data[k] >= '0' && data[k] <= '9') {
                val <<= 6;
                val += data[k] - '0' + 52;
            } else if(data[k] == '+') {
                val <<= 6;
                val += 62;
            } else if(data[k] == '/') {
                val <<= 6;
                val += 63;
            } else {
                val <<= 6;
            }
        }
		
		val = EndianU32_NtoB(val);
        memcpy(out + j, ((unsigned char*)(&val)) + 1, 3);
    }
	
	data = (const unsigned char*)[target bytes];
	len = 0;
	for(i = [target length] - 1; i >= 0; i--, len++) {
		if(data[i] != 0)
			break;
	}
	return [NSData dataWithBytes:[target bytes] length:([target length] - len)];
}

@end
