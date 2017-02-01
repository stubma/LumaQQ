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

#import "LoginPacket.h"
#import "NSData-QQCrypt.h"
#import "NSData-CRC32.h"
#import "NSData-MD5.h"
#import "NSMutableData-CustomAppending.h"
#import "SystemTool.h"

@implementation LoginPacket : BasicOutPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandLogin;
	}
	return self;
}

#pragma mark -
#pragma mark override super

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeUInt16:[[m_user passport] length]];
	[buf writeBytes:[m_user passport]];
	
	[buf writeUInt16:0];
	
	int pos = [buf position];
	[buf skip:2];
	NSMutableData* challengeData = [NSMutableData data];
	[challengeData appendData:[m_user passwordMd5]];
	[challengeData appendSInt32:random() littleEndian:NO];
	NSData* temp = [challengeData QQEncrypt:[m_user passwordKey]];
	[buf writeBytes:temp];
	[buf writeUInt16:[temp length] position:pos];
	
	char b;
	NSData* emptyData = [NSData dataWithBytes:&b length:0];
	NSData* K2Hash1 = [emptyData QQEncrypt:[m_user passwordKey]];
	[buf writeBytes:K2Hash1];
	
	[buf writeByte:0];
	[buf writeUInt32:0];
	[buf writeUInt16:0];
	[buf writeUInt32:0];
	[buf writeUInt32:0];
	[buf writeUInt32:0];
	[buf writeBytes:kQQ2007ExeMD5 length:16];
	
	const UInt8* k2hashBytes = (const UInt8*)[K2Hash1 bytes];
	UInt8 localOicqIndex = 1;
	int i;
	for(i = 0; i < 16; i++)
		localOicqIndex ^= k2hashBytes[i];
	for(i = 0; i < 16; i++)
		localOicqIndex ^= kQQ2007ExeMD5[i];
	[buf writeByte:localOicqIndex];
	
	[buf writeByte:[m_user loginStatus]];
	
	[buf writeUInt16:0];
	[buf writeUInt32:1];
	[buf writeUInt32:1];
	[buf writeBytes:[m_user selectedServer]];
	
	CFUUIDRef guidRef = nil;
	CFUUIDBytes guidBytes;
	NSString* guid = [[NSUserDefaults standardUserDefaults] objectForKey:kQQLocalComputerGUIDKeyName];
	if(guid == nil) {
		guidRef = CFUUIDCreate(kCFAllocatorDefault);
		guidBytes = CFUUIDGetUUIDBytes(guidRef);
		guid = [NSString stringWithFormat:@"%2X%2X%2X%2X-%2X%2X-%2X%2X-%2X%2X-%2X%2X%2X%2X%2X%2X", 
				guidBytes.byte0 & 0xFF,
				guidBytes.byte1 & 0xFF,
				guidBytes.byte2 & 0xFF,
				guidBytes.byte3 & 0xFF,
				guidBytes.byte4 & 0xFF,
				guidBytes.byte5 & 0xFF,
				guidBytes.byte6 & 0xFF,
				guidBytes.byte7 & 0xFF,
				guidBytes.byte8 & 0xFF,
				guidBytes.byte9 & 0xFF,
				guidBytes.byte10 & 0xFF,
				guidBytes.byte11 & 0xFF,
				guidBytes.byte12 & 0xFF,
				guidBytes.byte13 & 0xFF,
				guidBytes.byte14 & 0xFF,
				guidBytes.byte15 & 0xFF];
		[[NSUserDefaults standardUserDefaults] setObject:guid forKey:kQQLocalComputerGUIDKeyName];
	} else {
		guidRef = CFUUIDCreateFromString(kCFAllocatorDefault, (CFStringRef)guid);
		guidBytes = CFUUIDGetUUIDBytes(guidRef);
	}
	[buf writeByte:guidBytes.byte0];
	[buf writeByte:guidBytes.byte1];
	[buf writeByte:guidBytes.byte2];
	[buf writeByte:guidBytes.byte3];
	[buf writeByte:guidBytes.byte4];
	[buf writeByte:guidBytes.byte5];
	[buf writeByte:guidBytes.byte6];
	[buf writeByte:guidBytes.byte7];
	[buf writeByte:guidBytes.byte8];
	[buf writeByte:guidBytes.byte9];
	[buf writeByte:guidBytes.byte10];
	[buf writeByte:guidBytes.byte11];
	[buf writeByte:guidBytes.byte12];
	[buf writeByte:guidBytes.byte13];
	[buf writeByte:guidBytes.byte14];
	[buf writeByte:guidBytes.byte15];
	if(guidRef != nil)
		CFRelease(guidRef);
	
	[buf writeByte:[[m_user loginToken] length]];
	[buf writeBytes:[m_user loginToken]];
	
	[buf writeUInt16:0];
	
	[buf writeUInt16:0x6];
	[buf writeUInt16:0];
	[buf writeUInt32:0];
	
	[buf writeUInt16:0x140];
	pos = [buf position];
	
	// get MAC address and hard disk serial No, but I use machine serial instead of hard disk serial
	NSMutableData* computerData = [NSMutableData dataWithLength:28];
	char* computerDataBuf = (char*)[computerData mutableBytes];
	bzero(computerDataBuf, 28);
	[SystemTool getMACAddress:computerDataBuf bufferSize:6];
	NSString* machineSerialNo = [SystemTool getMacSerialNumber];
	const char* snBuf = [machineSerialNo cString];
	unsigned int snLen = [machineSerialNo cStringLength];
	memcpy(computerDataBuf + 8, snBuf, snLen * sizeof(char));
	NSData* computerId = [computerData MD5];
	NSData* guidEx = [[NSData dataWithBytes:computerDataBuf length:8] MD5];
	
	[buf writeByte:0x1];
	[buf writeUInt32:[computerId CRC32]];
	[buf writeUInt16:0x0010];
	[buf writeBytes:computerId];
	
	[buf writeUInt16:0];
	[buf writeUInt32:1];
	[buf writeUInt32:1];
	[buf writeBytes:[m_user selectedServer]];
	
	[buf writeByte:0x2];
	[buf writeUInt32:[guidEx CRC32]];
	[buf writeUInt16:0x0010];
	[buf writeBytes:guidEx];
	
	int padding = 0x140 - ([buf position] - pos);
	while(padding-- > 0)
		[buf writeByte:0];
}

- (int)getEncryptStart {
	return [[m_user passport] length] + 2 + 11;
}

- (int)getEncryptLength {
	return m_bodyLength - [[m_user passport] length] - 2;
}

- (int)getDecryptStart:(NSData*)data {
	return [[m_user passport] length] + 2 + 11;
}

- (int)getDecryptLength:(NSData*)data {
	return [data length] - 11 - 1 - [[m_user passport] length] - 2;
}

- (NSData*)getEncryptKey {
	return [m_user initialKey];
}

- (NSData*)getDecryptKey {
	return [m_user initialKey];
}

@end
