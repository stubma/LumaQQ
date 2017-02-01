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

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

/*
 * it's common for all normal im
 */

// sender qq version, 2 bytes
// sender qq number, 4 bytes
// receiver qq number, 4 bytes
// file session key, 16 bytes, file session key is md5 value of 20 bytes array
// 			the 0 - 3 bytes is user qq number and the remainning is session key
// normal im type, 2 bytes

@interface NormalIMHeader : NSObject <NSCoding> {
	UInt16 m_senderVersion;
	UInt32 m_sender;
	UInt32 m_receiver;
	NSData* m_fileSessionKey;
	UInt16 m_normalIMType;
}

- (void)read:(ByteBuffer*)buf;

// getter and setter
- (UInt16)senderVersion;
- (UInt32)sender;
- (UInt32)receiver;
- (NSData*)fileSessionKey;
- (UInt16)normalIMType;

@end
