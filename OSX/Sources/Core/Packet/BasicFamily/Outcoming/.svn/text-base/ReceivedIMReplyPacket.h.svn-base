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

#import <Cocoa/Cocoa.h>
#import "BasicOutPacket.h"

///////// format 1 /////////
// header
// --- encrypt start (session key) ---
// sender qq number, 4 bytes
// receiver qq number, 4 bytes, of coz, it's me
// message sequence, 4 bytes
// sender ip, 4 bytes
// --- encrypt end ---
// tail

@interface ReceivedIMReplyPacket : BasicOutPacket {
	UInt32 m_sender;
	UInt32 m_receiver;
	UInt32 m_messageSequence;
	char m_senderIp[4];
}

// getter and setter
- (UInt32)sender;
- (void)setSender:(UInt32)sender;
- (UInt32)receiver;
- (void)setReceiver:(UInt32)receiver;
- (UInt32)messageSequence;
- (void)setMessageSequence:(UInt32)seq;
- (char*)senderIp;
- (void)setSenderIp:(char*)ip;

@end
