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

#import "CustomFace.h"
#import "NSString-Converter.h"
#import "QQConstants.h"
#import "NSData-MD5.h"
#import "ByteTool.h"

static NSMutableData* s_data = nil;

@implementation CustomFace

- (void) dealloc {
	[m_fileAgentKey release];
	[m_filename release];
	[m_shortcut release];
	[m_fileData release];
	[m_fileMd5 release];
	[m_filenameMd5 release];
	[super dealloc];
}

- (id)initWithOwner:(UInt32)owner type:(char)type source:(char)source existence:(char)existence shortcut:(NSString*)shortcut filename:(NSString*)filename data:(NSData*)data md5:(NSData*)md5 {
	self = [super init];
	if(self) {
		m_owner = owner;
		m_faceType = type;
		m_faceImageSource = source;
		m_faceExistence = existence;
		m_shortcut = [shortcut retain];
		m_filename = [filename retain];
		m_fileData = [data retain];
		m_fileMd5 = [md5 retain];
		m_filenameMd5 = [[[m_filename dataUsingEncoding:NSASCIIStringEncoding] MD5] retain]; // only ascii allowed
	}
	return self;
}

- (void)read:(ByteBuffer*)buf {
	[buf skip:1];
	m_faceExistence = [buf getByte];
	switch(m_faceExistence) {
		case kQQClusterCustomFace:
			m_length = [[buf getString:3] intValue];
			m_faceType = [buf getByte];
			m_shortcutLength = [buf getByte] - 'A';
			m_faceImageSource = [[buf getString:2] hexIntValue];
			m_sessionId = [[buf getString:8] hexIntValue];
			m_serverIp[3] = [[buf getString:2] hexIntValue];
			m_serverIp[2] = [[buf getString:2] hexIntValue];
			m_serverIp[1] = [[buf getString:2] hexIntValue];
			m_serverIp[0] = [[buf getString:2] hexIntValue];
			m_serverPort = [[buf getString:8] hexIntValue];
			m_fileAgentKey = [[NSMutableData dataWithLength:16] retain];
			[buf getBytes:(NSMutableData*)m_fileAgentKey];
			m_filename = [[buf getString:(m_length - [buf position] - 1 - m_shortcutLength)] retain];
			m_shortcut = [[buf getString:m_shortcutLength] retain];
			[buf skip:1];
			break;
		case kQQClusterCustomFaceRef:
			m_length = [[buf getString:3] intValue];
			m_faceType = [buf getByte];
			m_shortcutLength = [buf getByte] - 'A';
			m_shortcut = [[buf getString:m_shortcutLength] retain];
			[buf skip:1];
			break;
	}
}

- (NSData*)toData {
	if(s_data == nil)
		s_data = [[NSMutableData dataWithLength:200] retain];
	
	ByteBuffer* buf = [ByteBuffer bufferWithBytes:(char*)[s_data mutableBytes] length:[s_data length]];
	[buf writeByte:kQQTagCustomFace];
	[buf writeByte:m_faceExistence];
	switch(m_faceExistence) {
		case kQQClusterCustomFace:
			int offset = [buf position];
			[buf skip:3];
			[buf writeByte:m_faceType];			
			NSData* shortcutData = [ByteTool getBytes:m_shortcut];
			[buf writeByte:('A' + [shortcutData length])];
			[buf writeHexString:m_faceImageSource];
			[buf writeHexStringWithUInt32:m_sessionId littleEndian:NO spaceForZero:YES];
			[buf writeHexString:m_serverIp[3]];
			[buf writeHexString:m_serverIp[2]];
			[buf writeHexString:m_serverIp[1]];
			[buf writeHexString:m_serverIp[0]];
			[buf writeHexStringWithUInt32:m_serverPort littleEndian:NO spaceForZero:YES];
			[buf writeBytes:m_fileAgentKey];
			[buf writeString:m_filename];
			[buf writeBytes:shortcutData];
			[buf writeByte:'A'];
			
			int backup = [buf position];
			[buf setPosition:offset];
			[buf writeDecimalString:backup length:3 spaceForZero:YES];
			[buf setPosition:backup];
			break;
		case kQQClusterCustomFaceRef:
			offset = [buf position];
			[buf skip:3];
			[buf writeByte:m_faceType];
			[buf writeString:m_shortcut
				  withLength:YES
				  lengthByte:1
				  lengthBase:'A'];
			[buf writeByte:'A'];
			
			backup = [buf position];
			[buf setPosition:offset];
			[buf writeDecimalString:backup length:3 spaceForZero:YES];
			[buf setPosition:backup];
			break;
	}
	
	return [s_data subdataWithRange:NSMakeRange(0, [buf position])]; 
}

- (UInt32)owner {
	return m_owner;
}

- (void)setOwner:(UInt32)owner {
	m_owner = owner;
}

- (int)length {
	return m_length;
}

- (BOOL)isReference {
	return m_faceExistence == kQQClusterCustomFaceRef;
}

- (BOOL)exist {
	return m_faceExistence == kQQClusterCustomFace;
}

- (char)faceType {
	return m_faceType;
}

- (int)faceIndex {
	return m_faceType - 'A';
}

- (int)shortcutLength {
	return m_shortcutLength;
}

- (NSString*)shortcut {
	return m_shortcut;
}

- (NSString*)filename {
	return m_filename;
}

- (UInt32)sessionId {
	return m_sessionId;
}

- (void)setSessionId:(UInt32)sessionId {
	m_sessionId = sessionId;
}

- (const char*)serverIp {
	return m_serverIp;
}

- (void)setServerIp:(const char*)serverIp {
	memcpy(m_serverIp, serverIp, 4);
}

- (UInt16)serverPort {
	return m_serverPort;
}

- (void)setServerPort:(UInt16)port {
	m_serverPort = port;
}

- (NSData*)fileAgentKey {
	return m_fileAgentKey;
}

- (void)setFileAgentKey:(NSData*)key {
	[key retain];
	[m_fileAgentKey release];
	m_fileAgentKey = key;
}

- (char)faceImageSource {
	return m_faceImageSource;
}

- (NSData*)fileData {
	return m_fileData;
}

- (NSData*)fileMd5 {
	return m_fileMd5;
}

- (NSData*)filenameMd5 {
	return m_filenameMd5;
}

- (UInt16)agentTransferType {
	switch(m_faceType) {
		case 'e':
			return kQQAgentCustomFace;
		case 'k':
			return kQQAgentScreenscrap;
		default:
			return kQQAgentCustomFace;
	}
}

- (UInt32)imageSize {
	return m_fileData == nil ? 0 : [m_fileData length];
}

@end
