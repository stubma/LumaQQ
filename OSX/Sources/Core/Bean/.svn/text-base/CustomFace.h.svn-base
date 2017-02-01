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
#import "ByteBuffer.h"

/*
 * this class is used to represent a custom face structure in IM
 * a custom face is flagged by kQQCustomFaceTag
 */

/////// format 0x36 /////////
// custom face tag, 1 byte, 0x15
// face existence flag, 1 byte, 0x36, means a new custom face
// face structure length in decimal string, 3 bytes, if 89 bytes, then "089"
// face type, 1 bytes, see constant kQQFaceTypeCustomFace also
// face shortcut length, 1 byte, 'A' mean length 0, 'B' means length 1, and so on
// face image source, 2 byte, hex string, see kQQImageSourceCustomFace also...
// session id hex string, 8 bytes, big-endian, if less than 8 bytes, fill zero
// agent server ip hex string, 8 bytes, little-endian
// agent server port hex string, 8 bytes, big-endian
// file agent key, 16 bytes
// face file name, for custom face, MD5 + ext, for screenscrap and picture file, { + UUID + } + ext
// face shortcut
// end flag, 1 byte, 'A'

//////// format 0x37 /////////
// custom face tag, 1 byte, 0x15
// face existence flag, 1 byte, 0x37, means a reference to previous face
// face structure length in string, 3 bytes, if 89 bytes, then "089"
// face index, 1 bytes, 'A' means index 0, 'B' means index 1, and so on
// face shortcut length, 1 byte, 'A' mean length 0, 'B' means length 1, and so on
// face shortcut
// end flag, 1 byte, 'A'

@interface CustomFace : NSObject {
	// not in data, added for convinence
	UInt32 m_owner;
	
	char m_faceExistence;
	int m_length;
	char m_faceType;
	int m_shortcutLength;
	char m_faceImageSource;
	UInt32 m_sessionId;
	char m_serverIp[4];
	UInt16 m_serverPort;
	NSData* m_fileAgentKey;
	NSString* m_filename;
	NSString* m_shortcut;
	
	// not in received data, used for send
	NSData* m_fileData;
	NSData* m_fileMd5;
	NSData* m_filenameMd5;
}

- (id)initWithOwner:(UInt32)owner type:(char)type source:(char)source existence:(char)existence shortcut:(NSString*)shortcut filename:(NSString*)filename data:(NSData*)data md5:(NSData*)md5;

- (void)read:(ByteBuffer*)buf;
- (NSData*)toData;

- (UInt32)owner;
- (void)setOwner:(UInt32)owner;
- (int)length;
- (BOOL)isReference;
- (BOOL)exist;
- (char)faceType;
- (int)faceIndex;
- (int)shortcutLength;
- (NSString*)shortcut;
- (NSString*)filename;
- (UInt32)sessionId;
- (void)setSessionId:(UInt32)sessionId;
- (const char*)serverIp;
- (void)setServerIp:(const char*)serverIp;
- (UInt16)serverPort;
- (void)setServerPort:(UInt16)port;
- (NSData*)fileAgentKey;
- (void)setFileAgentKey:(NSData*)key;
- (char)faceImageSource;
- (NSData*)fileData;
- (NSData*)fileMd5;
- (NSData*)filenameMd5;
- (UInt16)agentTransferType;
- (UInt32)imageSize;

@end
