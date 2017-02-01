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
#import "AgentOutPacket.h"

//////////// format //////////
// header
// unknown 8 bytes, it can be 0x0100000000000000
// session id, 4 bytes
// --- encrypt start (file agent key included in message) ---
// agent transfer type, 2 bytes, when receive, it's zero
// --- encrypt end ---
// tail

@interface RequestBeginPacket : AgentOutPacket {
	UInt16 m_agentTransferType;
	UInt32 m_sessionId;
}

// getter and setter
- (UInt16)agentTransferType;
- (void)setAgentTransferType:(UInt16)type;
- (UInt32)sessionId;
- (void)setSessionId:(UInt32)sessionId;

@end
