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

#import "AgentOutPacket.h"

@implementation AgentOutPacket

#pragma mark -
#pragma mark override super method

- (id)initWithQQUser:(QQUser*)user {
	return [self initWithQQUser:user encryptKey:[user fileAgentKey]];
}

- (id)initWithQQUser:(QQUser*)user encryptKey:(NSData*)key {
	self = [super initWithQQUser:user encryptKey:key];
	if(self) {
		m_header = kQQHeaderAgentFamily;
		m_tail = kQQTailAgentFamily;
		m_version = kQQVersionCurrent;
		m_unencryptedBodyLength = 0;
	}
	return self;
}

- (void)fillHeader:(ByteBuffer*)buf {
	[buf writeByte:kQQHeaderAgentFamily];
	[buf writeUInt16:kQQVersionCurrent];
	[buf writeUInt16:0]; // placeholder
	[buf writeUInt16:m_command];
	[buf writeUInt16:m_sequence];
	[buf writeUInt32:[m_user QQ]];
}

- (void)fillTail:(ByteBuffer*)buf {
	[buf writeByte:kQQTailAgentFamily];
}

- (int)family {
	return kQQFamilyAgent;
}

- (int)getEncryptStart {
	return 13 + m_unencryptedBodyLength;
}

- (int)getEncryptLength {
	return m_bodyLength - m_unencryptedBodyLength;
}

- (int)getDecryptStart:(NSData*)data {
	return 13 + m_unencryptedBodyLength;
}

- (int)getDecryptLength:(NSData*)data {
	return [data length] - m_unencryptedBodyLength - 13 - 1;
}

- (void)postFill:(ByteBuffer*)buf bodyOffset:(int)bodyOffset tailOffset:(int)tailOffset {
	int total = tailOffset + 1;
	[buf writeUInt16:total position:3];
}

@end
