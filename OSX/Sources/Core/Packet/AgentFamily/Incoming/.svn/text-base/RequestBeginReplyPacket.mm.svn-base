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

#import "RequestBeginReplyPacket.h"


@implementation RequestBeginReplyPacket

#pragma mark -
#pragma mark override

- (void)parseBody:(ByteBuffer*)buf {
	[buf skip:8];
	m_sessionId = [buf getUInt32];
	m_agentTransferType = [buf getUInt16];
}

- (int)getEncryptStart {
	return [self getInPacketHeaderLength] + 12;
}

- (int)getEncryptLength {
	return m_bodyLength - 12;
}

- (int)getDecryptStart:(NSData*)data {
	return [self getInPacketHeaderLength] + 12;
}

- (int)getDecryptLength:(NSData*)data {
	return [data length] - [self getInPacketHeaderLength] - 12 - 1;
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)sessionId {
	return m_sessionId;
}

- (UInt16)agentTransferType {
	return m_agentTransferType;
}

@end
