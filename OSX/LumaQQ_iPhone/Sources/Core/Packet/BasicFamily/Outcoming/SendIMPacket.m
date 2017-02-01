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

#import "SendIMPacket.h"


@implementation SendIMPacket

static UInt16 s_messageId = 0;
static UInt16 s_sessionId = 0;

+ (void)increaseMessageId {
	s_messageId++;
}

+ (void)increaseSessionId {
	s_sessionId++;
}

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandSendIM;
		m_fontStyle = [[FontStyle defaultStyle] retain];
		m_fragmentCount = 1;
		m_fragmentIndex = 0;
		m_replyType = kQQIMReplyTypeManual;
		m_messageId = s_messageId;
		m_sessionId = s_sessionId;
	}
	return self;
}

- (void)fillBody:(ByteBuffer*)buf {
	QQUser* me = [self user];
	[buf writeUInt32:[me QQ]];
	[buf writeUInt32:m_receiver];
	[buf writeUInt16:kQQVersionCurrent];
	[buf writeUInt32:[me QQ]];
	[buf writeUInt32:m_receiver];
	[buf writeBytes:[me fileSessionKey]];
	[buf writeUInt16:kQQNormalIMTypeText];
	[buf writeUInt16:m_sessionId];
	[buf writeUInt32:[[NSDate date] timeIntervalSince1970]]; 
	[buf writeUInt16:[[me info] head]];
	[buf writeUInt32:1];
	[buf writeByte:m_fragmentCount];
	[buf writeByte:m_fragmentIndex];
	[buf writeUInt16:m_messageId];
	[buf writeByte:m_replyType];
	[buf writeBytes:m_messageData];
	[m_fontStyle write:buf];
}

- (void) dealloc {
	[m_messageData release];
	[m_fontStyle release];
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)receiver {
	return m_receiver;
}

- (void)setReceiver:(UInt32)receiver {
	m_receiver = receiver;
}

- (FontStyle*)fontStyle {
	return m_fontStyle;
}

- (void)setFontStyle:(FontStyle*)style {
	[style retain];
	[m_fontStyle release];
	m_fontStyle = style;
}

- (NSData*)messageData {
	return m_messageData;
}

- (void)setMessageData:(NSData*)data {
	[data retain];
	[m_messageData release];
	m_messageData = data;
}

- (char)replyType {
	return m_replyType;
}

- (void)setReplyType:(char)replyType {
	m_replyType = replyType;
}

- (UInt8)fragmentCount {
	return m_fragmentCount;
}

- (void)setFragmentCount:(UInt8)count {
	m_fragmentCount = count;
}

- (UInt8)fragmentIndex {
	return m_fragmentIndex;
}

- (void)setFragmentIndex:(UInt8)index {
	m_fragmentIndex = index;
}

- (UInt16)sessionId {
	return m_sessionId;
}

- (UInt16)messageId {
	return m_messageId;
}

@end
