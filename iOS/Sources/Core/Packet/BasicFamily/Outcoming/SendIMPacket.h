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
#import "BasicOutPacket.h"
#import "FontStyle.h"

////////// format 1 /////////////
// header
// -- encrypt start (session key) ---
// sender qq number, 4 bytes
// receiver qq number, 4 bytes
// sender qq version, 2 bytes
// sender qq number, 4 bytes
// receiver qq number, 4 bytes, no idea why they put a copy here
// sender file session key, 16 bytes
// normal im type, 2 bytes
// session id, 2 bytes
// send time, 4 bytes
// sender head, 2 bytes
// message property flag, 4 bytes
// fragment count, 1 byte, qq default fragment size is 700 bytes (message text length)
// fragment index, 1 byte, start from 0
// message id, 2 bytes
// reply type, 1 byte
// message, there is a space character at last fragment
// FontStyle structure, see Source/Bean/FontStyle.mm comment
// --- encrypt end ---
// tail

@interface SendIMPacket : BasicOutPacket {
	UInt32 m_receiver;
	FontStyle* m_fontStyle;
	char m_replyType;
	NSData* m_messageData;
	UInt8 m_fragmentCount;
	UInt8 m_fragmentIndex;
	UInt16 m_sessionId;
	UInt16 m_messageId;
}

+ (void)increaseMessageId;
+ (void)increaseSessionId;

// getter and setter
- (UInt32)receiver;
- (void)setReceiver:(UInt32)receiver;
- (FontStyle*)fontStyle;
- (void)setFontStyle:(FontStyle*)style;
- (NSData*)messageData;
- (void)setMessageData:(NSData*)data;
- (char)replyType;
- (void)setReplyType:(char)replyType;
- (UInt8)fragmentCount;
- (void)setFragmentCount:(UInt8)count;
- (UInt8)fragmentIndex;
- (void)setFragmentIndex:(UInt8)index;
- (UInt16)sessionId;
- (UInt16)messageId;

@end
