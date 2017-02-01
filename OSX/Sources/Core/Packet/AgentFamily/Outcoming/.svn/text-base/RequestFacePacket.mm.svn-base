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

#import "RequestFacePacket.h"
#import "ByteTool.h"

@implementation RequestFacePacket

#pragma mark -
#pragma mark override

- (id)initWithQQUser:(QQUser*)user encryptKey:(NSData*)key {
	self = [super initWithQQUser:user encryptKey:key];
	if(self) {
		m_command = kQQCommandRequestFace;
		m_unencryptedBodyLength = 12;
	}
	return self;
}

- (void)fillBody:(ByteBuffer*)buf {	
	[buf writeUInt32:0x01000000];
	[buf writeUInt32:0];
	[buf writeUInt32:m_sessionId];
	[buf writeUInt16:[[m_user fileAgentToken] length]];
	[buf writeBytes:[m_user fileAgentToken]];
	[buf writeUInt32:m_owner];
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)sessionId {
	return m_sessionId;
}

- (void)setSessionId:(UInt32)sessionId {
	m_sessionId = sessionId;
}

- (UInt32)owner {
	return m_owner;
}

- (void)setOwner:(UInt32)owner {
	m_owner = owner;
}

@end
