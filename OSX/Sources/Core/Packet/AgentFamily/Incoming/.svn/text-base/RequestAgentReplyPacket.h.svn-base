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

////////// format ///////////
// header
// unknown 8 bytes, same as request packet
// --- encrypt start (file agent key) ---
// reply code, 2 bytes
// server ip of this time, 4 bytes, little-endian
// server port of this time, 2 bytes
// session id, 4 bytes, nonzero only when reply code is kQQReplyOK
// ip of server redirect to, 4 bytes
// port of server redirect to, 2 bytes
// length of attached message, 2 bytes
// attached message
// --- encrypt end ---
// tail

@interface RequestAgentReplyPacket : AgentInPacket {
	UInt16 m_reply;
	char m_serverIp[4];
	UInt16 m_serverPort;
	UInt32 m_sessionId;
	char m_redirectServerIp[4];
	UInt16 m_redirectServerPort;
	NSString* m_message;
}

// getter and setter
- (UInt16)reply;
- (const char*)serverIp;
- (UInt16)serverPort;
- (UInt32)sessionId;
- (const char*)redirectServerIp;
- (UInt16)redirectServerPort;
- (NSString*)message;

@end
