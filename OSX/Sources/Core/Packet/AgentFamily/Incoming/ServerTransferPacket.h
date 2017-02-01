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
#import "AgentInPacket.h"

/////// format, sequence 0x0000, version is not client version, send info to client /////////
// header
// NOTE: sequence in header is always 0x0000
// unknown 8 bytes
// session id, 4 bytes
// unknown 4 bytes
// length of following data, 2 bytes, exclusive
// length of following data, 2 bytes, inclusive
// md5 of image file, 16 bytes
// md5 of image file name, 16 bytes
// image file size, 4 bytes
// image file name length, 2 bytes\
// image file name
// unknown 8 bytes
// tail

///////// format non-zero sequence, version is not client version, send data to client ///////////
// header
// NOTE: sequence in header is increased by one, start from 0x0001
// unknown 8 bytes
// session id, 4 bytes
// unknown 4 bytes
// length of data, 2 bytes
// data
// tail

/////// format non-zero sequence, version is client version, request client for data /////////////
// header
// unknown 8 bytes
// session id, 4 bytes
// unknown 4 bytes 
// length of following data, 2 bytes, exclusive
// the offset of restart upload, 4 bytes
// tail

/////// format non-zero sequence, version is client version, reply for client data /////////////
// header
// unknown 8 bytes
// session id, 4 bytes
// NOTE: if it's the reply for last fragment, then the session id is next session id
// unknown 4 bytes 
// length of following data, 2 bytes, exclusive
// unknown 1 byte, always 0x02, so length is always 0x0001
// tail

@interface ServerTransferPacket : AgentInPacket {
	// used in send, receive
	UInt32 m_sessionId;
	
	// used in receive
	NSData* m_imageMd5;
	NSData* m_imageFileNameMd5;
	UInt32 m_imageSize;
	NSString* m_imageFileName;
	
	NSData* m_imageData;
	
	// used in send
	UInt32 m_restartPoint;
}

// getter and setter
- (UInt32)sessionId;
- (NSData*)imageMd5;
- (NSData*)imageFileNameMd5;
- (UInt32)imageSize;
- (NSString*)imageFileName;
- (NSData*)imageData;
- (UInt32)restartPoint;

@end
