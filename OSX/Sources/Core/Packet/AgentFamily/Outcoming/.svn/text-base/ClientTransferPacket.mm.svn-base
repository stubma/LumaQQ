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

#import "ClientTransferPacket.h"

@implementation ClientTransferPacket

#pragma mark -
#pragma mark override

- (unsigned)hash {
	return ((([self family] << 8) | m_command) << 16) | ((m_sequence + m_sessionId) & 0x0000FFFF);
}

- (void) dealloc {
	[m_fileMd5 release];
	[m_filenameMd5 release];
	[m_filename release];
	[m_fileFragmentData release];
	[super dealloc];
}

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user encryptKey:nil];
	if(self) {
		m_command = kQQCommandTransfer;
		m_restartPoint = 0;
	}
	return self;
}

- (void)fillBody:(ByteBuffer*)buf {	
	[buf writeUInt32:0x01000000];
	[buf writeUInt32:0x1];
	[buf writeUInt32:m_sessionId];
	[buf writeUInt32:0];
	switch(m_mode) {
		case kTransferModeReplyData:
			[buf writeUInt16:1];
			[buf writeByte:2];
			m_needAck = NO;
			break;
		case kTransferModeRequestData:
			[buf writeUInt16:4];
			[buf writeUInt32:m_restartPoint];
			m_needAck = NO;
			break;
		case kTransferImageData:
			NSLog(@"send image data, seq: %d, hash: %d", m_sequence, [self hash]);
			[buf writeUInt16:[m_fileFragmentData length]];
			[buf writeBytes:m_fileFragmentData];
			m_needAck = NO;
			break;
		case kTransferImageInfo:
			int offset = [buf position];
			[buf writeUInt16:0];
			[buf writeUInt16:0];
			[buf writeBytes:m_fileMd5];
			[buf writeBytes:m_filenameMd5];
			[buf writeUInt32:m_imageSize];
			[buf writeString:m_filename withLength:YES lengthByte:2];
			[buf writeUInt32:0];
			[buf writeUInt32:0];
			
			int len = [buf position] - offset - 2;
			[buf writeUInt16:len position:offset];
			[buf writeUInt16:len position:(offset + 2)];
			
			m_needAck = NO;
			break;
	}
}

- (NSData*)getEncryptKey {
	return nil;
}

- (NSData*)getDecryptKey {
	return nil;
}

#pragma mark -
#pragma mark getter and setter

- (void)setMode:(int)mode {
	m_mode = mode;
}

- (void)setRestartPoint:(UInt32)restart {
	m_restartPoint = restart;
}

- (UInt32)restartPoint {
	return m_restartPoint;
}

- (UInt32)sessionId {
	return m_sessionId;
}

- (void)setSessionId:(UInt32)sessionId {
	m_sessionId = sessionId;
}

- (void)setFileMd5:(NSData*)md5 {
	[md5 retain];
	[m_fileMd5 release];
	m_fileMd5 = md5;
}

- (void)setFilenameMd5:(NSData*)md5 {
	[md5 retain];
	[m_filenameMd5 release];
	m_filenameMd5 = md5;
}

- (void)setImageSize:(UInt32)imageSize {
	m_imageSize = imageSize;
}

- (void)setFilename:(NSString*)filename {
	[filename retain];
	[m_filename release];
	m_filename = filename;
}

- (void)setFileFragmentData:(NSData*)fragment {
	[fragment retain];
	[m_fileFragmentData release];
	m_fileFragmentData = fragment;
}

@end
