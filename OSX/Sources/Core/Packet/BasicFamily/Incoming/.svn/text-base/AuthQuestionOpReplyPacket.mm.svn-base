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

#import "AuthQuestionOpReplyPacket.h"


@implementation AuthQuestionOpReplyPacket

- (void)parseBody:(ByteBuffer*)buf {
	m_subCommand = [buf getByte];
	switch(m_subCommand) {
		case kQQSubCommandGetMyQuestion:
			int len = [buf getByte] & 0xFF;
			m_question = [[buf getString:len] retain];
			len = [buf getByte] & 0xFF;
			m_answer = [[buf getString:len] retain];
			break;
		case kQQSubCommandModifyQuestion:
			m_reply = [buf getByte];
			break;
		case kQQSubCommandGetUserQuestion:
			[buf skip:2];
			m_reply = [buf getByte];
			if(m_reply == kQQReplyOK) {
				len = [buf getByte] & 0xFF;
				m_question = [[buf getString:len] retain];
			}
			break;
		case kQQSubCommandAnswerQuestion:
			[buf skip:2];
			m_reply = [buf getByte];
			if(m_reply == kQQReplyOK) {
				len = [buf getUInt16];
				m_authInfo = [[NSMutableData dataWithLength:len] retain];
				[buf getBytes:(NSMutableData*)m_authInfo];
			}
			break;
	}
}

- (void) dealloc {
	[m_question release];
	[m_answer release];
	[m_authInfo release];
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

- (NSString*)question {
	return m_question;
}

- (NSString*)answer {
	return m_answer;
}

- (NSData*)authInfo {
	return m_authInfo;
}

@end
