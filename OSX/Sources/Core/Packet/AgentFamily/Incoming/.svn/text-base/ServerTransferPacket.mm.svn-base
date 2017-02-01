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

#import "ServerTransferPacket.h"


@implementation ServerTransferPacket

- (void) dealloc {
	[m_imageMd5 release];
	[m_imageFileName release];
	[m_imageFileNameMd5 release];
	[m_imageData release];
	[super dealloc];
}

#pragma mark -
#pragma mark override

- (unsigned)hash {
	return ((([self family] << 8) | m_command) << 16) | ((m_sequence + m_sessionId) & 0x0000FFFF);
}

- (BOOL)isServerInitiative {
	return m_version != kQQVersionCurrent;
}

- (BOOL)triggerAnyway {
	return YES;
}

- (void)parseBody:(ByteBuffer*)buf {
	[buf skip:8];
	m_sessionId = [buf getUInt32];
	[buf skip:4];
	
	if(m_version != kQQVersionCurrent) {
		switch(m_sequence) {
			case 0:
				[buf skip:4];
				m_imageMd5 = [[NSMutableData dataWithLength:16] retain];
				[buf getBytes:(NSMutableData*)m_imageMd5];
				m_imageFileNameMd5 = [[NSMutableData dataWithLength:16] retain];
				[buf getBytes:(NSMutableData*)m_imageFileNameMd5];
				m_imageSize = [buf getUInt32];
				int len = [buf getUInt16];
				m_imageFileName = [[buf getString:len] retain];
				break;
			default:
				len = [buf getUInt16];
				m_imageData = [[NSMutableData dataWithLength:len] retain];
				[buf getBytes:(NSMutableData*)m_imageData];
			break;
		}
	} else {
		int len = [buf getUInt16];
		if(len == 4)
			m_restartPoint = [buf getUInt32];
		else
			m_restartPoint = -1; // currently we use restart point to flag what the packet is
	}
}

- (NSData*)getEncryptKey {
	return nil;
}

- (NSData*)getDecryptKey {
	return nil;
}

- (int)getDecryptLength:(NSData*)data {
	return 0;
}

#pragma mark -
#pragma mark getter and setter

- (NSData*)imageData {
	return m_imageData;
}

- (UInt32)sessionId {
	return m_sessionId;
}

- (NSData*)imageMd5 {
	return m_imageMd5;
}

- (NSData*)imageFileNameMd5 {
	return m_imageFileNameMd5;
}

- (UInt32)imageSize {
	return m_imageSize;
}

- (NSString*)imageFileName {
	return m_imageFileName;
}

- (UInt32)restartPoint {
	return m_restartPoint;
}

@end
