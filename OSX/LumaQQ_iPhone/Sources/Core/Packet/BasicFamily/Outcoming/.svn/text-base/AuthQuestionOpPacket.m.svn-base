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

#import "AuthQuestionOpPacket.h"


@implementation AuthQuestionOpPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandAuthQuestionOp;
	}
	return self;
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeByte:m_subCommand];
	switch(m_subCommand) {
		case kQQSubCommandGetMyQuestion:
			[buf writeByte:0];
			break;
		case kQQSubCommandModifyQuestion:
			[buf writeString:m_question withLength:YES lengthByte:1];
			[buf writeString:m_answer withLength:YES lengthByte:1];
			[buf writeByte:0];
			break;
		case kQQSubCommandGetUserQuestion:
			[buf writeUInt16:1];
			[buf writeUInt32:m_friendQQ];
			break;
		case kQQSubCommandAnswerQuestion:
			[buf writeUInt16:1];
			[buf writeUInt32:m_friendQQ];
			[buf writeString:m_answer withLength:YES lengthByte:1];
			break;
	}
}

- (void) dealloc {
	[m_question release];
	[m_answer release];
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

- (NSString*)question {
	return m_question;
}

- (void)setQuestion:(NSString*)question {
	[question retain];
	[m_question release];
	m_question = question;
}

- (NSString*)answer {
	return m_answer;
}

- (void)setAnswer:(NSString*)answer {
	[answer retain];
	[m_answer release];
	m_answer = answer;
}

- (UInt32)friendQQ {
	return m_friendQQ;
}

- (void)setFriendQQ:(UInt32)friendQQ {
	m_friendQQ = friendQQ;
}

@end
