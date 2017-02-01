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

#import "ReceivedIMPacketHeader.h"

#define _kKeySender @"ReceivedIMPacketHeader_Sender"
#define _kKeyType @"ReceivedIMPacketHeader_Type"

@implementation ReceivedIMPacketHeader

- (void)read:(ByteBuffer*)buf {
	m_sender = [buf getUInt32];
	m_receiver = [buf getUInt32];
	m_messageSequence = [buf getUInt32];
	[buf getBytes:m_senderIp length:4];
	m_senderPort = [buf getUInt16];
	m_type = [buf getUInt16];
}

#pragma mark -
#pragma mark NSCoding protocol

- (void)encodeWithCoder:(NSCoder*)encoder {
	[encoder encodeInt32:m_sender forKey:_kKeySender];
	[encoder encodeInt:m_type forKey:_kKeyType];
}

- (id)initWithCoder:(NSCoder*)decoder {
	m_sender = [decoder decodeInt32ForKey:_kKeySender];
	m_type = [decoder decodeIntForKey:_kKeyType];
	return self;
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)sender {
	return m_sender;
}

- (void)setSender:(UInt32)sender {
	m_sender = sender;
}

- (UInt32)receiver {
	return m_receiver;
}

- (UInt32)messageSequence {
	return m_messageSequence;
}

- (char*)senderIp {
	return m_senderIp;
}

- (UInt16)senderPort {
	return m_senderPort;
}

- (UInt16)type {
	return m_type;
}

@end
