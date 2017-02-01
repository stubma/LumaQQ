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

#import "PasswordVerifyReplyPacket.h"


@implementation PasswordVerifyReplyPacket

- (void) dealloc {
	[m_passport release];
	[m_loginKey release];
	[m_unknownToken1 release];
	[m_unknownToken2 release];
	[super dealloc];
}

- (void)parseBody:(ByteBuffer*)buf {
	[buf skip:2];
	
	m_reply = [buf getByte];
	
	[buf skip:4];
	
	int len = [buf getUInt16];
	m_unknownToken1 = [[NSMutableData dataWithLength:len] retain];
	[buf getBytes:(NSMutableData*)m_unknownToken1];
	
	len = [buf getUInt16];
	m_unknownToken2 = [[NSMutableData dataWithLength:len] retain];
	[buf getBytes:(NSMutableData*)m_unknownToken2];
	
	len = [buf getUInt16];
	switch(m_reply) {
		case kQQReplyOK:
			m_passport = [[NSMutableData dataWithLength:len] retain];
			[buf getBytes:(NSMutableData*)m_passport];
			
			m_loginKey = [[NSMutableData dataWithLength:kQQKeyLength] retain];
			[buf getBytes:(NSMutableData*)m_loginKey];
			break;
		case kQQReplyNeedActivate:
		case kQQReplyPasswordError:
			m_errorMessage = [[buf getString:len] retain];
			break;
		default:
			if([buf available] >= len)
				m_errorMessage = [[buf getString:len] retain];
			break;
	}
}

#pragma mark -
#pragma mark override super methods

- (NSData*)getDecryptKey {
	return [m_user passwordKey];
}

- (NSData*)getFallbackDecryptKey {
	return [m_user passwordVerifyRandomKey];
}

#pragma mark -
#pragma mark getter and setter

- (NSData*)passport {
	return m_passport;
}

- (NSData*)loginKey {
	return m_loginKey;
}

- (NSString*)errorMessage {
	return m_errorMessage;
}

@end
