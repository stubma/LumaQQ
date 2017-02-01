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
#import "AgentInPacket.h"

////////// format 1 ///////////
// header
// unknown 8 bytes, same as request packet
// session id, 4 bytes
// --- encrypt start (file agent key included in ReceivedIMPacket) ---
// agent transfer type, 2 bytes, when receive, it's zero
// unknown 10 bytes
// --- encrypt end ---
// tail

@interface RequestBeginReplyPacket : AgentInPacket {
	UInt32 m_sessionId;
	UInt16 m_agentTransferType;
}

// getter and setter
- (UInt32)sessionId;
- (UInt16)agentTransferType;

@end
