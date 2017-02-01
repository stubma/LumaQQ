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

#import "ClusterSendIMExPacket.h"


@implementation ClusterSendIMExPacket

static UInt16 s_messageId = 0;

+ (void)increaseMessageId {
	s_messageId++;
}

+ (UInt16)messageId {
	return s_messageId;
}

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_subCommand = kQQSubCommandClusterSendIMEx;
		m_fontStyle = [[FontStyle defaultStyle] retain];
		m_fragmentCount = 1;
		m_fragmentIndex = 0;
		m_messageId = s_messageId;
	}
	return self;
}

- (void)fillBody:(ByteBuffer*)buf {
	[super fillBody:buf];
	int pos = [buf position];
	[buf skip:2];
	[buf writeUInt16:1];
	[buf writeByte:m_fragmentCount];
	[buf writeByte:m_fragmentIndex];
	[buf writeUInt16:m_messageId];
	[buf writeUInt32:0];
	[buf writeBytes:m_messageData];
	if(m_fragmentIndex + 1 == m_fragmentCount)
		[m_fontStyle write:buf];
	[buf writeUInt16:([buf position] - pos - 2) position:pos];
}

- (void) dealloc {
	[m_messageData release];
	[m_fontStyle release];
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

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

- (UInt16)messageId {
	return m_messageId;
}

@end
