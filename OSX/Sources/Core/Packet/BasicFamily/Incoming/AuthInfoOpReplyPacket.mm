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

#import "AuthInfoOpReplyPacket.h"


@implementation AuthInfoOpReplyPacket

- (void)parseBody:(ByteBuffer*)buf {
	m_subCommand = [buf getByte];
	m_subSubCommand = [buf getUInt16];
	m_reply = [buf getByte];
	switch(m_subCommand) {
		case kQQSubCommandGetAuthInfo:
			switch(m_reply) {
				case kQQReplyOK:
					int len = [buf getUInt16];
					m_authInfo = [[NSMutableData dataWithLength:len] retain];
					[buf getBytes:(NSMutableData*)m_authInfo];
					break;
				case kQQReplyNeedVerifyCode:
					len = [buf getUInt16];
					m_url = [[buf getString:len] retain];
					break;
			}
			break;
		case kQQSubCommandGetAuthInfoByVerifyCode:
			if(m_reply == kQQReplyOK) {
				int len = [buf getUInt16];
				m_authInfo = [[NSMutableData dataWithLength:len] retain];
				[buf getBytes:(NSMutableData*)m_authInfo];
				break;
			}
			break;
	}
}

#pragma mark -
#pragma mark getter and setter

- (UInt16)subSubCommand {
	return m_subSubCommand;
}

- (NSData*)authInfo {
	return m_authInfo;
}

- (NSString*)url {
	return m_url;
}

@end
