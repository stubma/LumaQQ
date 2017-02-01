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
#import "BasicOutPacket.h"

//////// format 1 ////////
// header
// --- encrypt start (session key) ---
// sub command, 1 byte
// my ip address, 4 bytes
// my port, 2 bytes, useless in querying weather
// --- encrypt end ---
// tail

@interface WeatherOpPacket : BasicOutPacket {
	char m_ip[4];
}

// getter and setter
- (const char*)ip;
- (void)setIp:(const char*)ip;

@end