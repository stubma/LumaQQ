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
#import "BasicInPacket.h"

/////// format 1 ///////
// header
// --- encrypt start (session key) ---
// unknown 6 bytes
// reply message length, 1 byte
// reply message
// number of mobile, 1 byte
// a. mobile number, 18 bytes, if less than 18, fill zero
// b. unknown 2 bytes
// c. reply code of this receiver, 1 byte
// d. attached message length, 1 byte
// e. attached message
// f. unknown 1 byte
// NOTE: if more mobile, repeat a,b,c,d,e,f
// number of qq, 1 byte
// g. qq number, 4 bytes
// h. reply code of this receiver, 1 byte
// i. attached message length, 1 byte
// j. attached message
// k. unknown 1 byte
// NOTE: if more qq, repeat g,h,i,j,k
// unknown 1 byte
// reference message length, 1 byte
// reference message
// --- encrypt end ---
// tail

@interface SendSMSReplyPacket : BasicInPacket {
	NSString* m_replyMessage;
	NSString* m_referenceMessage;
	NSMutableArray* m_mobileReplies;
	NSMutableArray* m_QQReplies;
}

// getter and setter
- (NSString*)replyMessage;
- (NSString*)referenceMessage;
- (NSArray*)mobileReplies;
- (NSArray*)QQReplies;

@end
