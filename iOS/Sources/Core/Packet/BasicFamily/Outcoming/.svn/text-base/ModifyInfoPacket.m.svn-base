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

#import "ModifyInfoPacket.h"


@implementation ModifyInfoPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandModifyInfo;
	}
	return self;
}

- (void)fillBody:(ByteBuffer*)buf {
	// auth info
	[buf writeByte:[m_authInfo length]];
	[buf writeBytes:m_authInfo];
	
	// delimiter
	char delimiter = 0x1F;
	
	// in 2006, tencent forbids modifying password in this packet.
	[buf writeByte:delimiter];
	[buf writeByte:delimiter];
	
	[m_contact write:buf];
}

- (void) dealloc {
	[m_contact release];
	[m_authInfo release];
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

- (ContactInfo*)contact {
	return m_contact;
}

- (void)setContact:(ContactInfo*)contact {
	[contact retain];
	[m_contact release];
	m_contact = contact;
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
