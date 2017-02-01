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

/////////// format 1 ///////////
// header
// -------- encrypt start (session key) -----------
// destination status, 1 byte
// status version id, 2 bytes
// unknown 6 bytes, all zero
// length of status message, 2 bytes
// status message
// NOTE: status message is UTF-8 encoding!!!!!!
// -------- encrypt end -------
// tail

@interface ChangeStatusPacket : BasicOutPacket {
	char m_status;
	UInt16 m_statusVersion;
	NSString* m_statusMessage;
}

// getter and setter
- (char)status;
- (void)setStatus:(char)status;
- (NSString*)statusMessage;
- (void)setStatusMessage:(NSString*)msg;
- (UInt16)statusVersion;
- (void)setStatusVersion:(UInt16)version;

@end
