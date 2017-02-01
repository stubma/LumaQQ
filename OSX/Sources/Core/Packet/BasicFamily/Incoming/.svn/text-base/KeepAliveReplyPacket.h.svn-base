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
#import "BasicInPacket.h"

////////// format 1 ////////////
// header
// --------- encrypt start (session key) -----------
// reply code, 1 byte
// the number of online users, 4 bytes
// my ip, 4 bytes
// my port, 2 bytes
// unknown 2 bytes
// current time, 4 bytes
// unknown 4 bytes
// unknown 1 bytes
// -------- encrypt end --------
// tail

@interface KeepAliveReplyPacket : BasicInPacket {
	UInt32 m_online;
	char m_ip[4];
	UInt16 m_port;
	UInt32 m_time;
}

// getter and setter
- (UInt32)online;
- (const char*)ip;
- (UInt16)port;
- (UInt32)time;

@end
