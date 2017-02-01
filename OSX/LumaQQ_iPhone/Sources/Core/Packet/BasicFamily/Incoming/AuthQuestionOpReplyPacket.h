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

//////// format 1 ////////
// header
// ---- encrypt start (session key) ------
// sub command, 1 byte, 0x01, means get my question and answer
// length of question, 1 byte
// question
// length of answer, 1 byte
// answer
// ---- encrypt end -----
// tail

////////// format 0x02 ////////
// header
// ---- encrypt start (session key) ------
// sub command, 1 byte, 0x02, means modify question
// reply code, 1 byte
// ---- encrypt end ------
// tail

////////// format 0x03 ////////
// header
// ---- encrypt start (session key) ------
// sub command, 1 byte, 0x03, means get question of a user
// unknown 2 bytes, 0x0001
// reply code, 1 byte
// (NOTE) if reply code is not 0x00, body ends here
// length of question, 1 byte
// question
// ---- encrypt end ---
// tail

////////// format 0x04 ////////
// header
// ---- encrypt start (session key) ------
// sub command, 1 byte, 0x04, means answer a question
// unknown 2 bytes, 0x0001
// reply code, 1 byte
// (NOTE) if reply code is not 0x00, body ends here
// length of auth info, 2 byte
// auth info
// ---- encrypt end ------
// tail

@interface AuthQuestionOpReplyPacket : BasicInPacket {
	NSString* m_question;
	NSString* m_answer;
	NSData* m_authInfo;
}

// getter and setter
- (NSString*)question;
- (NSString*)answer;
- (NSData*)authInfo;

@end
