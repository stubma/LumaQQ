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

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

/*
 * this structure is common for all received im packet
 */

// sender qq number, 4 bytes, it could be a cluster id
// receiver qq number 4 bytes
// message sequence, 4 bytes, it isn't the sequence of the packet, seems it is a server side concept
// sender ip, 4 bytes, this field is always 127.0.0.1 because tencent thinks it is unsafe to expose sender ip
// sender port, 2 bytes, always 4000
// message type, 2 bytes

@interface ReceivedIMPacketHeader : NSObject <NSCoding> {
	UInt32 m_sender;
	UInt32 m_receiver;
	UInt32 m_messageSequence;
	char m_senderIp[4];
	UInt16 m_senderPort;
	UInt16 m_type;
}

- (void)read:(ByteBuffer*)buf;

// getter and setter
- (UInt32)sender;
- (void)setSender:(UInt32)sender;
- (UInt32)receiver;
- (UInt32)messageSequence;
- (char*)senderIp;
- (UInt16)senderPort;
- (UInt16)type;

@end
