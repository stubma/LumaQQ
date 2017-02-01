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
#import "ClusterCommandPacket.h"
#import "FontStyle.h"

////////// format 1 /////////
// header
// --- encrypt start (session key) ---
// sub command, 1 byte
// internal id, 4 bytes
// length of following data (exclusive), 2 bytes
// unknown 2 bytes (I guessed content type before, but seems not)
// fragment count, 1 byte
// fragment index, 1 byte
// message id, 2 bytes
// unknown 4 bytes
// message data, space appended to last fragment
// FontStyle structure, see Source/Bean/FontStyle.mm
// NOTE: only last fragment has FontStyle
// --- encrypt end ---
// tail

@interface ClusterSendIMExPacket : ClusterCommandPacket {
	FontStyle* m_fontStyle;
	NSData* m_messageData;
	UInt16 m_messageId;
	UInt8 m_fragmentCount;
	UInt8 m_fragmentIndex;
}

+ (void)increaseMessageId;
+ (UInt16)messageId;

// getter and setter
- (FontStyle*)fontStyle;
- (void)setFontStyle:(FontStyle*)style;
- (NSData*)messageData;
- (void)setMessageData:(NSData*)data;
- (UInt8)fragmentCount;
- (void)setFragmentCount:(UInt8)count;
- (UInt8)fragmentIndex;
- (void)setFragmentIndex:(UInt8)index;
- (UInt16)messageId;

@end
