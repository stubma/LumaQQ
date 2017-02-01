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
#import "ClusterSendIMExPacket.h"

////// format 1 ////////
// header
// --- encrypt start (session key) ---
// sub command, 1 byte, 0x35
// cluster type, 1 byte
// NOTE: if permanent cluster, cluster type is 0x01, if not, use temp cluster type
// parent cluster internal id, 4 bytes
// cluster internal id, 4 bytes
// length of following data, 2 bytes, exclusive
// unknown 2 bytes (I guessed content type before, but seems not)
// fragment count, 1 byte
// fragment index, 1 byte
// message id, 2 bytes
// unknown 4 bytes
// message, there is a space character at last fragment
// FontStyle structure, see Source/Bean/FontStyle.mm comment
// NOTE: only last fragment has FontStyle
// --- encrypt end ---
// tail

@interface TempClusterSendIMPacket : ClusterSendIMExPacket {
	char m_type;
}

// getter and setter
- (char)type;
- (void)setType:(char)type;

@end
