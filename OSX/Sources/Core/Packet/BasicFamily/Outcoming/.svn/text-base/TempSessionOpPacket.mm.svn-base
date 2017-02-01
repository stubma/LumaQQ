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

#import "TempSessionOpPacket.h"


@implementation TempSessionOpPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandTempSessionOp;
	}
	return self;
}

- (void) dealloc {
	[m_fontStyle release];
	[m_messageData release];
	[m_senderName release];
	[m_senderSite release];
	[m_authInfo release];
	[super dealloc];
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeByte:m_subCommand];
	switch(m_subCommand) {
		case kQQSubCommandSendTempSessionIM:
			[buf writeUInt32:m_receiver];
			[buf writeUInt16:[m_authInfo length]];
			[buf writeBytes:m_authInfo];
			[buf writeUInt32:0];
			[buf writeString:m_senderName withLength:YES lengthByte:1];
			[buf writeString:m_senderSite withLength:YES lengthByte:1];
			[buf writeByte:0x01];
			[buf writeUInt32:0];
			int offset = [buf position];
			[buf skip:2];
			[buf writeBytes:m_messageData];
			[m_fontStyle write:buf];
			[buf writeUInt16:([buf position] - offset - 2) position:offset];
			break;
	}
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

- (NSString*)senderName {
	return m_senderName;
}

- (void)setSenderName:(NSString*)name {
	[name retain];
	[m_senderName release];
	m_senderName = name;
}

- (NSString*)senderSite {
	return m_senderSite;
}

- (void)setSenderSite:(NSString*)site {
	[site retain];
	[m_senderSite release];
	m_senderSite = site;
}

- (NSData*)authInfo {
	return m_authInfo;
}

- (void)setAuthInfo:(NSData*)authInfo {
	[authInfo retain];
	[m_authInfo release];
	m_authInfo = authInfo;
}

@end
