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

#import "NSData-QQCrypt.h"
#import "ByteTool.h"

@implementation NSData (QQCrypt)

#pragma makr -
#pragma mark auxillary variable

char cipher[8];
char* prePlain;
char* output;
char* plain;
int pos;
int _crypt;
int preCrypt;
int padding;
int contextStart;
BOOL header = YES;
const char* key;

#pragma mark -
#pragma mark interface

- (NSData*)QQEncrypt:(NSData*)keyData {
	return [self QQEncrypt:keyData offset:0 length:[self length]];
}

- (NSData*)QQDecrypt:(NSData*)keyData {
	return [self QQDecrypt:keyData offset:0 length:[self length]];
}

- (NSData*)QQEncrypt:(NSData*)keyData offset:(int)offset length:(int)length {
	const char* bytes = (const char*)[self bytes];
	plain = (char*)malloc(8 * sizeof(char));
	prePlain = (char*)calloc(8, sizeof(char));
	pos = 1;           
	padding = 0; 
	_crypt = preCrypt = 0;
	key = (const char*)[keyData bytes];
	header = YES;
	int i;
	
	// -1 means encrypt to end
	if(length == -1)
		length = [self length] - offset;
	
	int lengthbak = length;
	
	pos = (length + 0x0A) % 8;
	if(pos != 0)
		pos = 8 - pos;

	int count = length + pos + 10;
	NSMutableData* encryptData = [NSMutableData dataWithLength:(pos + 10 + [self length])];
	output = (char*)[encryptData mutableBytes];
	memcpy(output, bytes, offset);
	output += offset;
	
	plain[0] = (char)(([self rand] & 0xF8) | pos);
	
	for(i = 1; i <= pos; i++)
		plain[i] = (char)([self rand] & 0xFF);
	pos++;
	
	padding = 1;
	while(padding <= 2) {
		if(pos < 8) {
			plain[pos++] = (char)([self rand] & 0xFF);
			padding++;
		}
		if(pos == 8)
			[self encrypt8Bytes];
	}
	
	i = offset;
	while(length > 0) {
		if(pos < 8) {
			plain[pos++] = bytes[i++];
			length--;
		}
		if(pos == 8)
			[self encrypt8Bytes];
	}
	
	padding = 1;
	while(padding <= 7) {
		if(pos < 8) {
			plain[pos++] = 0x0;
			padding++;
		}
		if(pos == 8)
			[self encrypt8Bytes];
	}
	
	free(plain);
	free(prePlain);
	
	memcpy(output + count, bytes + offset + lengthbak, [self length] - offset - lengthbak);
	return encryptData;
}

- (NSData*)QQDecrypt:(NSData*)keyData offset:(int)offset length:(int)length {
	const char* bytes = (const char*)[self bytes];
	_crypt = preCrypt = 0;
	key = (const char*)[keyData bytes];
	
	int i;
	int count, countbak;
	int mlen = offset + 8;
	
	// -1 means decrypt to end
	if(length == -1)
		length = [self length] - offset;
	
	if((length % 8 != 0) || (length < 16)) 
		return nil;
	
	prePlain = [self decipher:bytes offset:offset];
	pos = prePlain[0] & 0x7;
	
	count = length - pos - 10;
	countbak = count;
	if(count < 0) 
		return nil;
	
	char* m = (char*)calloc(mlen, sizeof(char));
	char* mbak = m;
	
	NSMutableData* decryptData = [NSMutableData dataWithLength:(count + [self length] - length)];
	output = (char*)[decryptData mutableBytes];
	memcpy(output, bytes, offset);
	output += offset;
	
	preCrypt = 0;
	_crypt = 8;
	contextStart = 8;
	pos++;
	
	padding = 1;
	while(padding <= 2) {
		if(pos < 8) {
			pos++;
			padding++;
		}
		if(pos == 8) {
			m = (char*)bytes;
			if(![self decrypt8Bytes:bytes offset:offset length:length]) {
				free(mbak);
				return nil;
			}
		}
	}
	
	i = 0;
	while(count != 0) {
		if(pos < 8) {
			output[i] = (char)(m[offset + preCrypt + pos] ^ prePlain[pos]);
			i++;
			count--;
			pos++;
		}
		if(pos == 8) {
			m = (char*)bytes;
			preCrypt = _crypt - 8;
			if(![self decrypt8Bytes:bytes offset:offset length:length]) {
				free(mbak);
				return nil;
			}
		}
	}
	
	for(padding = 1; padding < 8; padding++) {
		if(pos < 8) {
			if((m[offset + preCrypt + pos] ^ prePlain[pos]) != 0) {
				free(mbak);
				return nil;
			};
			pos++;
		}
		if(pos == 8) {
			m = (char*)bytes;
			preCrypt = _crypt;
			if(![self decrypt8Bytes:bytes offset:offset length:length]) {
				free(mbak);
				return nil;
			}
		}
	}
	
	free(mbak);
	memcpy(output + countbak, bytes + offset + length, [self length] - offset - length);
	return decryptData;
}

#pragma mark -
#pragma mark internal use

- (int)rand {
	return random();
}

- (void)encrypt8Bytes {
	// 这plain ^ preCrypt
	for(pos = 0; pos < 8; pos++) {
		if(header) 
			plain[pos] ^= prePlain[pos];
		else
			plain[pos] ^= output[preCrypt + pos];
	}
	// f(plain ^ preCrypt)
	memcpy(output + _crypt, [ByteTool encipher:plain key:key output:cipher], 8);
	
	// f(plain ^ preCrypt) ^ prePlain
	for(pos = 0; pos < 8; pos++)
		output[_crypt + pos] ^= prePlain[pos];
	memcpy(prePlain, plain, 8);
	
	// finish
	preCrypt = _crypt;
	_crypt += 8;      
	pos = 0;
	header = NO;   
}

- (char*)decipher:(const char*)bytes {
	return [self decipher:bytes offset:0];
}

- (char*)decipher:(const char*)bytes offset:(int)offset {
	// iterate times
	int loop = 0x10;
	
	// variables
	UInt32 y = [ByteTool getUInt32:bytes offset:offset length:4];
	UInt32 z = [ByteTool getUInt32:bytes offset:offset + 4 length:4];
	UInt32 a = [ByteTool getUInt32:key offset:0 length:4];
	UInt32 b = [ByteTool getUInt32:key offset:4 length:4];
	UInt32 c = [ByteTool getUInt32:key offset:8 length:4];
	UInt32 d = [ByteTool getUInt32:key offset:12 length:4];

	// control variable
	UInt32 sum = 0xE3779B90;
	UInt32 delta = 0x9E3779B9;
	
	// iterate
	while(loop-- > 0) {
		z -= ((y << 4) + c) ^ (y + sum) ^ ((y >> 5) + d);
		y -= ((z << 4) + a) ^ (z + sum) ^ ((z >> 5) + b);
		sum -= delta;
	}
	
	// output
	[ByteTool writeUInt32:cipher value:y at:0];
	[ByteTool writeUInt32:cipher value:z at:4];
	return cipher;
}

- (BOOL)decrypt8Bytes:(const char*)bytes offset:(int)offset length:(int)length {
	for(pos = 0; pos < 8; pos++) {
		if(contextStart + pos >= length) 
			return YES;
		prePlain[pos] ^= bytes[offset + _crypt + pos];
	}
	
	// d(crypt ^ prePlain)
	prePlain = [self decipher:prePlain];
	if(prePlain == nil)
		return NO;
	
	contextStart += 8;
	_crypt += 8;
	pos = 0;
	return YES;
}

@end
