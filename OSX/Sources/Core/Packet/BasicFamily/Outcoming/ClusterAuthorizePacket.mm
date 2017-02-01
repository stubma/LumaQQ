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

#import "ClusterAuthorizePacket.h"


@implementation ClusterAuthorizePacket

- (void) dealloc {
	[m_authInfo release];
	[m_message release];
	[super dealloc];
}

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_subCommand = kQQSubCommandClusterAuthorize;
		m_message = [@"-" retain];
	}
	return self;
}

- (void)fillBody:(ByteBuffer*)buf {
	[super fillBody:buf];
	[buf writeByte:m_subSubCommand];
	
	switch(m_subSubCommand) {
		case kQQSubSubCommandRequestJoinCluster:
			[buf writeUInt16:[m_authInfo length]];
			[buf writeBytes:m_authInfo];
			[buf writeUInt32:m_receiver];
			[buf writeString:m_message withLength:YES lengthByte:1];
			break;
		case kQQSubSubCommandApproveJoinCluster:
		case kQQSubSubCommandRejectJoinCluster:
			[buf writeUInt32:m_receiver];
			[buf writeString:m_message withLength:YES lengthByte:1];
			[buf writeUInt16:[m_authInfo length]];
			[buf writeBytes:m_authInfo];
			break;
	}
}

#pragma mark -
#pragma mark getter and setter

- (NSData*)authInfo {
	return m_authInfo;
}

- (void)setAuthInfo:(NSData*)authInfo {
	[authInfo retain];
	[m_authInfo release];
	m_authInfo = authInfo;
}

- (UInt32)receiver {
	return m_receiver;
}

- (void)setReceiver:(UInt32)receiver {
	m_receiver = receiver;
}

- (NSString*)message {
	return m_message;
}

- (void)setMessage:(NSString*)message {
	[message retain];
	[m_message release];
	m_message = message;
}

@end
