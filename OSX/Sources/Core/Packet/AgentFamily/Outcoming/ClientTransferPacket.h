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

/////////// format of reply data, used in receiving ///////
// header
// unknown 8 bytes
// session id, 4 bytes
// unknown 4 bytes
// length of following data, 2 bytes, exclusive
// unknown 1 byte, always 0x02, so length is always 0x0001
// tail

/////////// format of request data, used in receiving ///////
// header
// unknown 8 bytes
// session id, 4 bytes
// unknown 4 bytes
// length of following data, 2 bytes, exclusive
// the offset of restart download, 4 bytes
// tail

/////////// format of transfer image info, used in send ////////////
// header
// unknown 8 bytes
// session id, 4 bytes
// unknown 4 bytes
// length of following data, 2 bytes, exclusive
// length of following data, 2 bytes, inclusive, so it's same as previous field
// image file md5, 16 bytes
// image file name md5, 16 bytes
// image file size, 4 bytes
// image file name length, 2 bytes
// image file name
// unknown 8 bytes
// tail

////////// format of transfer image data, used in send /////////
// header
// unknown 8 bytes
// session id, 4 bytes
// unknown 4 bytes
// length of data, 2 bytes
// data
// tail

#define kTransferModeReplyData 0
#define kTransferModeRequestData 1
#define kTransferImageInfo 2
#define kTransferImageData 3

@interface ClientTransferPacket : AgentOutPacket {
	// for receive, send
	UInt32 m_sessionId;
	
	// for receive
	UInt32 m_restartPoint;
	
	// for send
	NSData* m_fileMd5;
	NSData* m_filenameMd5;
	UInt32 m_imageSize;
	NSString* m_filename;
	NSData* m_fileFragmentData;
	
	// transfer packet mode
	int m_mode;
}

// getter and setter
- (UInt32)sessionId;
- (void)setSessionId:(UInt32)sessionId;
- (void)setRestartPoint:(UInt32)restart;
- (UInt32)restartPoint;
- (void)setMode:(int)mode;
- (void)setFileMd5:(NSData*)md5;
- (void)setFilenameMd5:(NSData*)md5;
- (void)setImageSize:(UInt32)imageSize;
- (void)setFilename:(NSString*)filename;
- (void)setFileFragmentData:(NSData*)fragment;

@end
