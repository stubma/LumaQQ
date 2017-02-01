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

#import "ReceivedIMReplyPacket.h"


@implementation ReceivedIMReplyPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandReceivedIM;
	}
	return self;
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeUInt32:m_sender];
	[buf writeUInt32:m_receiver];
	[buf writeUInt32:m_messageSequence];
	[buf writeBytes:m_senderIp length:4];
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

- (void)setReceiver:(UInt32)receiver {
	m_receiver = receiver;
}

- (UInt32)messageSequence {
	return m_messageSequence;
}

- (void)setMessageSequence:(UInt32)seq {
	m_messageSequence = seq;
}

- (char*)senderIp {
	return m_senderIp;
}

- (void)setSenderIp:(char*)ip {
	memcpy(m_senderIp, ip, 4 * sizeof(char));
}

@end
