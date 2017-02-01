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

#import "AuthInfoOpPacket.h"


@implementation AuthInfoOpPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandAuthInfoOp;
	}
	return self;
}

- (void) dealloc {
	[m_authInfo release];
	[m_cookie release];
	[m_verifyCode release];
	[super dealloc];
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeByte:m_subCommand];
	[buf writeUInt16:m_subSubCommand];
	
	switch(m_subSubCommand) {
		case kQQSubSubCommandGetModifyUserInfoAuthInfo:
			[buf writeUInt32:0];
			break;
		default:
			[buf writeUInt32:m_QQ];
			break;
	}
	
	switch(m_subCommand) {
		case kQQSubCommandGetAuthInfoByVerifyCode:
			[buf writeString:m_verifyCode withLength:YES lengthByte:2];
			[buf writeString:m_cookie withLength:YES lengthByte:2];
			break;
	}
}

#pragma mark -
#pragma mark getter and setter

- (UInt16)subSubCommand {
	return m_subSubCommand;
}

- (void)setSubSubCommand:(UInt16)subSubCommand {
	m_subSubCommand = subSubCommand;
}

- (UInt32)QQ {
	return m_QQ;
}

- (void)setQQ:(UInt32)QQ {
	m_QQ = QQ;
}

- (UInt32)externalId {
	return m_QQ;
}

- (void)setExternalId:(UInt32)externalId {
	m_QQ = externalId;
}

- (NSData*)authInfo {
	return m_authInfo;
}

- (void)setAuthInfo:(NSData*)authInfo {
	[authInfo retain];
	[m_authInfo release];
	m_authInfo = authInfo;
}

- (NSString*)cookie {
	return m_cookie;
}

- (void)setCookie:(NSString*)cookie {
	[cookie retain];
	[m_cookie release];
	m_cookie = cookie;
}

- (NSString*)verifyCode {
	return m_verifyCode;
}

- (void)setVerifyCode:(NSString*)verifyCode {
	[verifyCode retain];
	[m_verifyCode release];
	m_verifyCode = verifyCode;
}

@end
