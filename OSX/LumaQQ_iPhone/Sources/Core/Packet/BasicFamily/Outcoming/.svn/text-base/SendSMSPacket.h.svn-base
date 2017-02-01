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

//////////// format 1 ////////////
// header
// --- encrypt start (session key) ---
// message sequence, 2 bytes, used to flag message fragment in large message
// unknown 6 bytes
// sender name, 13 bytes, if less than 13, fill zero
// unknown 1 byte
// sms type, 1 bytes
// sms content type, 1 byte
// sms content id, 4 bytes
// unknown 1 byte
// a. number of receiving mobile, 1 byte
// b. mobile number, 18 bytes, if less than 18, fill zero
// c. unknown 3 bytes
// NOTE: if more mobile, repeat (b)(c)
// NOTE: (b)(c) only exist when (a) is nonzero
// d. number of receiving qq, 1 byte
// e. qq number, 4 bytes
// NOTE: if more qq, repeat (e)
// NOTE: (e) only exists when (d) is nonzero
// unknown 1 byte, always 0x03
// length of sms message, 2 bytes
// NOTE: total length of the sender name and message can't be larger than 54 characters
// sms message
// 			if normal message, plain bytes
//			if contains blink message, use 0x01 to embrace blink part
// 			if the message is part of a long message, prefix "a/b" to message plus a 0x0A, such as "1/2\n" (0x31 0x2F 0x32 0x0A)
// --- encrypt end ---
// tail

@interface SendSMSPacket : BasicOutPacket {
	NSString* m_name;
	NSData* m_messageData;
	NSMutableArray* m_mobiles;
	NSMutableArray* m_QQs;
	
	char m_type;
	char m_contentType;
	UInt32 m_contentId;
	UInt16 m_messageSequence;
}

- (void)addQQ:(UInt32)QQ;
- (void)addMobile:(NSString*)mobile;

// getter and setter
- (NSString*)name;
- (void)setName:(NSString*)name;
- (NSData*)messageData;
- (void)setMessageData:(NSData*)message;
- (NSArray*)mobiles;
- (void)setMobiles:(NSArray*)mobiles;
- (NSArray*)QQs;
- (void)setQQs:(NSArray*)QQs;
- (UInt16)messageSequence;
- (void)setMessageSequence:(UInt16)messageSequence;

@end
