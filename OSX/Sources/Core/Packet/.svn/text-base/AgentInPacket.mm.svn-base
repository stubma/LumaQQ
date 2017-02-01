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

#import "AgentInPacket.h"


@implementation AgentInPacket

#pragma mark -
#pragma mark override super method

- (void)parseHeader:(ByteBuffer*)buf {
	m_header = [buf getByte];
	m_version = [buf getUInt16];
	m_packetLength = [buf getUInt16];
	m_command = [buf getUInt16];
	m_sequence = [buf getUInt16];
	[buf skip:4];
}

- (void)parseTail:(ByteBuffer*)buf {
	m_tail = [buf getByte];
}

- (int)family {
	return kQQFamilyAgent;
}

- (int)getInPacketHeaderLength {
	return 13;
}

- (NSData*)getEncryptKey {
	return m_encryptKey ? m_encryptKey : [m_user fileAgentKey];
}

- (NSData*)getDecryptKey {
	return m_decryptKey ? m_decryptKey : [m_user fileAgentKey];
}

- (UInt16)packetLength {
	return m_packetLength;
}

@end
