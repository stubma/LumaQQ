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

#import "AuthorizePacket.h"
#import "ByteTool.h"
#import "Constants.h"

@implementation AuthorizePacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandAuthorize;
		m_message = kStringEmpty;
	}
	return self;
}

- (void) dealloc {
	[m_authInfo release];
	[m_questionAuthInfo release];
	[m_message release];
	[super dealloc];
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeByte:m_subCommand];
	[buf writeUInt32:m_QQ];
	[buf writeUInt16:0];
	switch(m_subCommand) {
		case kQQSubCommandNormalAuthorize:
			[buf writeUInt16:[m_authInfo length]];
			[buf writeBytes:m_authInfo];
			[buf writeByte:(m_allowAddMe ? 1 : 0)];
			[buf writeByte:m_destGroup];
			[buf writeString:m_message withLength:YES lengthByte:1];
			break;
		case kQQSubCommandApproveAuthorizationAndAddHim:
			[buf writeString:m_message withLength:YES lengthByte:1];
			break;
		case kQQSubCommandRejectAuthorization:
			[buf writeString:m_message withLength:YES lengthByte:1];
			break;
		case kQQSubCommandDoubleAuthorize:
			[buf writeUInt16:[m_authInfo length]];
			[buf writeBytes:m_authInfo];
			[buf writeUInt16:[m_questionAuthInfo length]];
			[buf writeBytes:m_questionAuthInfo];
			[buf writeByte:(m_allowAddMe ? 1 : 0)];
			[buf writeByte:m_destGroup];
			break;
	}
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)QQ {
	return m_QQ;
}

- (void)setQQ:(UInt32)QQ {
	m_QQ = QQ;
}

- (NSData*)authInfo {
	return m_authInfo;
}

- (void)setAuthInfo:(NSData*)authInfo {
	[authInfo retain];
	[m_authInfo release];
	m_authInfo = authInfo;
}

- (BOOL)allowAddMe {
	return m_allowAddMe;
}

- (void)setAllowAddMe:(BOOL)allowAddMe {
	m_allowAddMe = allowAddMe;
}

- (int)destGroup {
	return m_destGroup;
}

- (void)setDestGroup:(int)destGroup {
	m_destGroup = destGroup;
}

- (NSString*)message {
	return m_message;
}

- (void)setMessage:(NSString*)message {
	[message retain];
	[m_message release];
	m_message = message;
}

- (NSData*)questionAuthInfo {
	return m_questionAuthInfo;
}

- (void)setQuestionAuthInfo:(NSData*)questionAuthInfo {
	[questionAuthInfo retain];
	[m_questionAuthInfo release];
	m_questionAuthInfo = questionAuthInfo;
}

@end
