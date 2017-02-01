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

#import "RequestAgentPacket.h"


@implementation RequestAgentPacket

- (void) dealloc {
	[m_imageMd5 release];       
	[m_imageFileNameMd5 release];
	[super dealloc];
}

#pragma mark -
#pragma mark override

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandRequestAgent;
	}
	return self;
}

- (void)fillBody:(ByteBuffer*)buf {	
	int offset = [buf position];
	
	[buf writeUInt32:0x01000000];
	[buf writeUInt32:0];
	[buf writeUInt32:0];
	[buf writeUInt16:[[m_user fileAgentToken] length]];
	[buf writeBytes:[m_user fileAgentToken]];
	m_unencryptedBodyLength = [buf position] - offset;
	
	[buf writeUInt16:m_agentTransferType];
	[buf writeUInt32:m_owner];
	[buf writeUInt32:m_imageSize];
	[buf writeBytes:m_imageMd5];
	[buf writeBytes:m_imageFileNameMd5];
	[buf writeUInt16:0];
}

- (int)getEncryptStart {
	return 13 + m_unencryptedBodyLength;
}

- (int)getEncryptLength {
	return m_bodyLength - m_unencryptedBodyLength;
}

- (int)getDecryptStart:(NSData*)data {
	return 13 + m_unencryptedBodyLength;
}

- (int)getDecryptLength:(NSData*)data {
	return [data length] - m_unencryptedBodyLength - 13 - 1;
}

#pragma mark -
#pragma mark getter and setter

- (UInt16)agentTransferType {
	return m_agentTransferType;
}

- (void)setAgentTransferType:(UInt16)type {
	m_agentTransferType = type;
}

- (UInt32)owner {
	return m_owner;
}

- (void)setOwner:(UInt32)owner {
	m_owner = owner;
}

- (UInt32)imageSize {
	return m_imageSize;
}

- (void)setImageSize:(UInt32)size {
	m_imageSize = size;
}

- (NSData*)imageMd5 {
	return m_imageMd5;
}

- (void)setImageMd5:(NSData*)md5 {
	[md5 retain];
	[m_imageMd5 release];
	m_imageMd5 = md5;
}

- (NSData*)imageFileNameMd5 {
	return m_imageFileNameMd5;
}

- (void)setImageFileNameMd5:(NSData*)md5 {
	[md5 retain];
	[m_imageFileNameMd5 release];
	m_imageFileNameMd5 = md5;
}

@end
