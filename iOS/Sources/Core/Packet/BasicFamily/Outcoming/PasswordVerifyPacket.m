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

#import "PasswordVerifyPacket.h"
#import "NSData-QQCrypt.h"
#import "NSMutableData-CustomAppending.h"
#import "NSData-CRC32.h"
#import "NSData-MD5.h"
#import "NSData-QQCrypt.h"
#import "ByteTool.h"

@implementation PasswordVerifyPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandPasswordVerify;
	}
	return self;
}

- (void) dealloc {
	[_passwordChallenge release];
	[super dealloc];
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeBytes:[m_user passwordVerifyRandomKey]];
	
	int pos = [buf position];
	[buf skip:2];
	
	[buf writeUInt32:kQQLanguageChinese];
	[buf writeUInt16:0x010E];
	
	[buf writeByte:[[m_user loginToken] length]];
	[buf writeBytes:[m_user loginToken]];
	
	int pos2 = [buf position];
	[buf skip:2];
	if(_passwordChallenge != nil) {
		[_passwordChallenge release];
		_passwordChallenge = nil;
	}	
	_passwordChallenge = [[NSMutableData data] retain];
	[_passwordChallenge appendData:[m_user passwordMd5]];
	[_passwordChallenge appendSInt32:random() littleEndian:NO];
	NSData* temp = [_passwordChallenge QQEncrypt:[m_user passwordKey]];
	[buf writeBytes:temp];
	[buf writeUInt16:[temp length] position:pos2];
	
	[buf writeUInt16:0x0014];
	[self _generateEvilData:buf];
	
	[buf writeUInt16:([buf position] - pos - 2) position:pos];
	
	int padding = 100 - ([buf position] - pos);
	if(padding > 0) {
		[buf writeUInt16:padding];
		while(padding-- > 0)
			[buf writeByte:0];
	}
}

- (void)_generateEvilData:(ByteBuffer*)buf {
	NSData* randomKeyMD5 = [[m_user passwordVerifyRandomKey] MD5];
	NSData* loginTokenMD5 = [[m_user loginToken] MD5];
	int loop = kQQLanguageChinese % 19 + 5;
	NSData* mixedMD5 = [self _mixLoginTokenMD5:(const UInt8*)[loginTokenMD5 bytes] 
								  randomKeyMD5:(const UInt8*)[randomKeyMD5 bytes]];
	NSData* passwordChallengeMD5 = [_passwordChallenge MD5];
	
	NSMutableData* quadData = [NSMutableData data];
	[quadData appendData:randomKeyMD5];
	[quadData appendData:loginTokenMD5];
	[quadData appendData:mixedMD5];
	[quadData appendData:passwordChallengeMD5];
	NSData* quadMD5 = [quadData MD5];
	while(loop-- > 0)
		quadMD5 = [quadMD5 MD5];
	const char* quadMD5Buf = (const char*)[quadMD5 bytes];
	
	const char* keyarray[] = {
		quadMD5Buf,
		(const char*)[loginTokenMD5 bytes],
		(const char*)[mixedMD5 bytes],
		(const char*)[passwordChallengeMD5 bytes]
	};
	
	char* outputBuf = (char*)calloc(16, sizeof(char));
	char* tempBuf = (char*)malloc(sizeof(char) * 16);
	int i;
	for(i = 0; i < 4; i++) {
		[ByteTool encipher:quadMD5Buf key:keyarray[i] output:tempBuf];
		[ByteTool encipher:(quadMD5Buf + 8) key:keyarray[i] output:(tempBuf + 8)];
		
		int j;
		for(j = 0; j < 16; j++)
			outputBuf[j] ^= tempBuf[j];
	}
	
	[buf writeBytes:outputBuf length:16];

	// crc32
	NSData* evilData = [NSData dataWithBytes:outputBuf length:16];
	UInt32 crc32 = [evilData CRC32];
	[buf writeUInt32:crc32 littleEndian:YES];
	
	// free
	free(outputBuf);
	free(tempBuf);
}

- (NSData*)_mixLoginTokenMD5:(const UInt8*)loginTokenMD5 randomKeyMD5:(const UInt8*)randomKeyMD5 {
	NSMutableData* ret = [NSMutableData dataWithLength:16];
	UInt8* retBuf = (UInt8*)[ret mutableBytes];
	memcpy(retBuf, randomKeyMD5, 16);
	
	// allocate
	UInt8* buffer1 = (UInt8*)malloc(sizeof(UInt8) * 256);
	UInt8* buffer2 = (UInt8*)malloc(sizeof(UInt8) * 256);
	
	// initialize
	int i;
	for(i = 0; i < 256; i++) {
		buffer1[i] = i;
		buffer2[i] = loginTokenMD5[i % 16];	
	}
	
	// shuffle buffer1
	int factor = 0;
	for(i = 0; i < 256; i++) {
		factor = (buffer1[i] + buffer2[i] + factor) % 256;
		UInt8 temp = buffer1[i];
		buffer1[i] = buffer1[factor];
		buffer1[factor] = temp;
	}
	
	// output
	int j, k;
	for(i = 0, j = 0, k = 0; k < 16; k++) {
		i++;
		j = (buffer1[i] + j) % 256;
		
		UInt8 temp1 = buffer1[i];
		UInt8 temp2 = buffer1[j];
		buffer1[i] = temp2;
		buffer1[j] = temp1;
		
		retBuf[k] ^= buffer1[(temp1 + temp2) % 256];
	}
	
	// free
	free(buffer1);
	free(buffer2);
	
	return ret;
}

#pragma mark -
#pragma mark override super method

- (int)getEncryptStart {
	return 11 + kQQKeyLength;
}

- (int)getDecryptStart:(NSData*)data {
	return 11 + kQQKeyLength;
}

- (int)getEncryptLength {
	return m_bodyLength - kQQKeyLength;
}

- (int)getDecryptLength:(NSData*)data {
	return [data length] - 11 - 1 - kQQKeyLength;
}

- (NSData*)getEncryptKey {
	return [m_user passwordVerifyRandomKey];
}

- (NSData*)getDecryptKey {
	return [m_user passwordVerifyRandomKey];
}

@end