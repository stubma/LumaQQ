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

////////// format 1 //////////
// header
// ---- encrypt start (session key) -----
// sub command, 1 byte, 0x31, means search all
// separator, 1 byte, 0x1F
// page number string, till to end
// ---- encrypt end ----
// tail

////////// format 2 //////////
// header
// ---- encrypt start (session key) -----
// sub command, 1 byte, 0x32, means search by nick, 0x33, means search by QQ
// separator, 1 byte, 0x1F
// QQ number string, if not available, use 0x2D, "-"
// separator, 1 byte, 0x1F
// nick, if not available, use 0x2D
// separator, 1 byte, 0x1F
// email, 2006 don't support this, use 0x2D
// separator, 1 byte, 0x1F
// page number string, null-terminated
// ---- encrypt end ----
// tail

@interface SearchUserPacket : BasicOutPacket {
	UInt32 m_QQ;
	NSString* m_nick;
	UInt32 m_page;
}

// getter and setter
- (UInt32)QQ;
- (void)setQQ:(UInt32)QQ;
- (NSString*)nick;
- (void)setNick:(NSString*)nick;
- (UInt32)page;
- (void)setPage:(UInt32)page;

@end
