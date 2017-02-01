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
#import "InPacket.h"

///////// format //////////////
// family flag, 1 byte, 0x02
// sender version, 2 bytes
// command, 2 bytes
// sequence, 2 bytes
// body
// NOTE: body is encrypted
// end flag, 1 byte, 0x03

@interface BasicInPacket : InPacket {
	char m_reply;
	char m_subCommand;
}

// getter and setter
- (char)reply;
- (char)subCommand;

@end
