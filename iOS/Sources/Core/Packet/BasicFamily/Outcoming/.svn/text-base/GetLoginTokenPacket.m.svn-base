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

#import "GetLoginTokenPacket.h"

@implementation GetLoginTokenPacket : BasicOutPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandGetLoginToken;
		m_subCommand = kQQSubCommandGetLoginToken;
		m_verifyCode = [@"2006" retain];
		m_fragmentIndex = 0;
	}
	return self;
}

- (void) dealloc {
	[m_puzzleToken release];
	[m_verifyCode release];
	[super dealloc];
}

- (void)fillBody:(ByteBuffer*)buf {
	switch(m_subCommand) {
		case kQQSubCommandGetLoginToken:
			[buf writeBytes:[m_user loginTokenRandomKey]];
			[buf writeByte:m_subCommand];
			[buf writeUInt16:0x0005];
			[buf writeUInt32:0];
			break;
		case kQQSubCommandSubmitVerifyCode:
			[buf writeBytes:[m_user loginTokenRandomKey]];
			[buf writeByte:m_subCommand];
			[buf writeUInt16:0x0005];
			[buf writeUInt32:0];
			const char* verifyCodeBuffer = [m_verifyCode UTF8String];
			int length = strlen(verifyCodeBuffer);
			[buf writeUInt16:length];
			[buf writeBytes:verifyCodeBuffer length:length];
			[buf writeUInt16:[m_puzzleToken length]];
			[buf writeBytes:m_puzzleToken];
			break;
		case kQQSubCommandGetLoginTokenEx:
			[buf writeBytes:[m_user loginTokenRandomKey]];
			[buf writeByte:[[m_user serverToken] length]];
			[buf writeBytes:[m_user serverToken]];
			[buf writeByte:m_subCommand];
			[buf writeUInt16:0x0005];
			[buf writeUInt32:0];
			[buf writeByte:m_fragmentIndex];
			if(m_puzzleToken == nil)
				[buf writeUInt16:0];
			else {
				[buf writeUInt16:[m_puzzleToken length]];
				[buf writeBytes:m_puzzleToken];
			}
			break;
		case kQQSubCommandSubmitVerifyCodeEx:
			[buf writeBytes:[m_user loginTokenRandomKey]];
			[buf writeByte:[[m_user serverToken] length]];
			[buf writeBytes:[m_user serverToken]];
			[buf writeByte:m_subCommand];
			[buf writeUInt16:0x0005];
			[buf writeUInt32:0];
			verifyCodeBuffer = [m_verifyCode UTF8String];
			length = strlen(verifyCodeBuffer);
			[buf writeUInt16:length];
			[buf writeBytes:verifyCodeBuffer length:length];
			[buf writeUInt16:[m_puzzleToken length]];
			[buf writeBytes:m_puzzleToken];
			break;
	}
}

#pragma mark -
#pragma mark override super method

- (int)getEncryptStart {
	return 11 + kQQKeyLength;
}

- (int)getDecryptStart:(NSData*)data {
	return 11 + kQQKeyLength;
}

- (int)getEncryptLength {
	return m_bodyLength - kQQKeyLength;
}

- (int)getDecryptLength:(NSData*)data {
	return [data length] - 11 - 1 - kQQKeyLength;
}

- (NSData*)getEncryptKey {
	return [m_user loginTokenRandomKey];
}

- (NSData*)getDecryptKey {
	return [m_user loginTokenRandomKey];
}

#pragma mark -
#pragma mark getter and setter

- (NSString*)verifyCode {
	return m_verifyCode;
}

- (void)setVerifyCode:(NSString*)code {
	[code retain];
	[m_verifyCode release];
	m_verifyCode = code;
}

- (void)setPuzzleToken:(NSData*)token {
	[token retain];
	[m_puzzleToken release];
	m_puzzleToken = token;
}

- (int)fragmentIndex {
	return m_fragmentIndex;
}

- (void)setFragmentIndex:(int)index {
	m_fragmentIndex = index;
}

@end
