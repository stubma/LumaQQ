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
#import "FriendStatusChangedNotification.h"

/////////// format //////////
// header
// -- encrypt start (session key) ---
// friend qq number, 4 bytes
// unknown 4 bytes
// unknown 4 bytes
// status, 1 byte
// friend qq version, 2 bytes
// unknown key, 16 bytes
// user property, 4 bytes
// my qq number, 4 bytes
// unknown 9 bytes
// length of status message, 2 bytes
// status message
// NOTE: status message is UTF-8 encoding !!!
// --- encrypt end ---
// tail

@interface FriendStatusChangedPacket : BasicInPacket {
	FriendStatusChangedNotification* m_friendStatus;
}

- (FriendStatusChangedNotification*)friendStatus;

@end
