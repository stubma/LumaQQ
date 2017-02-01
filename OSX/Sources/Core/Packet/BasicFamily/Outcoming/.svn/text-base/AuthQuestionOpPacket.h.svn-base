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
#import "BasicOutPacket.h"

///////// format 0x01 /////////
// header
// ---- encrypt start (session key) ------
// sub command, 1 byte, 0x01, means get my question and answer
// unknown 1 byte, 0x00
// ---- encrypt end -----
// tail

////////// format 0x02 ////////
// header
// ---- encrypt start (session key) ------
// sub command, 1 byte, 0x02, means modify question
// length of question, 1 byte
// question
// length of answer, 1 byte
// answer
// unknown 1 byte, 0x00
// ---- encrypt end ------
// tail

////////// format 0x03 ////////
// header
// ---- encrypt start (session key) ------
// sub command, 1 byte, 0x03, means get question of a user
// unknown 2 bytes, 0x0001
// user qq number, 4 bytes
// ---- encrypt end ---
// tail

////////// format 0x04 ////////
// header
// ---- encrypt start (session key) ------
// sub command, 1 byte, 0x04, means answer a question
// unknown 2 bytes, 0x0001
// user qq number, 4 bytes
// length of answer, 1 byte
// answer
// ---- encrypt end ------
// tail

@interface AuthQuestionOpPacket : BasicOutPacket {	
	// for 0x02
	NSString* m_question;
	
	// for 0x02 and 0x04
	NSString* m_answer;
	
	// for 0x03 and 0x04
	UInt32 m_friendQQ;
}

// getter and setter
- (NSString*)question;
- (void)setQuestion:(NSString*)question;
- (NSString*)answer;
- (void)setAnswer:(NSString*)answer;
- (UInt32)friendQQ;
- (void)setFriendQQ:(UInt32)friendQQ;

@end
