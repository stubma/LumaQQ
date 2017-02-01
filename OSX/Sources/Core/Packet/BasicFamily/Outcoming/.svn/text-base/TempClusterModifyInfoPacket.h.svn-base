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
#import "ClusterCommandPacket.h"

//////// format 1 ///////
// header
// --- encrypt start (session key) ---
// sub command, 1 byte, 0x34
// temp cluster type, 1 byte
// parent cluster internal id, 4 bytes
// temp cluster internal id, 4 bytes
// temp cluster name length, 1 byte
// temp cluster name
// --- encrypt end ---
// tail

@interface TempClusterModifyInfoPacket : ClusterCommandPacket {
	NSString* m_name;
}

// getter and setter
- (NSString*)name;
- (void)setName:(NSString*)name;

@end
