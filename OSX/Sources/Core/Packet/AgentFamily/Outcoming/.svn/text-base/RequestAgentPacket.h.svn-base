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

#import <Cocoa/Cocoa.h>
#import "AgentOutPacket.h"

//////////// format 1 ///////////
// header
// unknown 8 bytes, most of time it's 0x0100 0x0000 0x0000 0x0000
// unknown 4 bytes, most of time, all zero
// file agent token length, 2 bytes
// file agent token
// --- encrypt start (file agent key) ---
// agent transfer type, 2 bytes
// owner id, 4 bytes, if you send image in cluster, it's cluster internal id
// image size, 4 bytes
// md5 of image, 16 bytes
// md5 of image file name, 16 bytes
// unknown 2 bytes, most of time it's zero
// --- encrypt end ---
// tail

@interface RequestAgentPacket : AgentOutPacket {
	UInt16 m_agentTransferType;
	UInt32 m_owner;
	UInt32 m_imageSize;
	NSData* m_imageMd5;
	NSData* m_imageFileNameMd5;
}

// getter and setter
- (UInt16)agentTransferType;
- (void)setAgentTransferType:(UInt16)type;
- (UInt32)owner;
- (void)setOwner:(UInt32)owner;
- (UInt32)imageSize;
- (void)setImageSize:(UInt32)size;
- (NSData*)imageMd5;
- (void)setImageMd5:(NSData*)md5;
- (NSData*)imageFileNameMd5;
- (void)setImageFileNameMd5:(NSData*)md5;

@end
