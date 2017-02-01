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

//////// format 1 ////////
// header
// ---- encrypt start (session key) ----
// sub command, 1 byte
// cluster count, 2 bytes
// a. internal id, 4 bytes
// b. external id, 4 bytes, no use for request packet, fill 0
// c. message setting, 1 byte, no use for request packet, fill 0
// (NOTE) if more cluster, repeat (a)(b)(c)
// ---- encrypt end ----
// tail

@interface ClusterGetMessageSettingPacket : ClusterCommandPacket {
	NSMutableArray* m_clusters;
}

// getter and setter
- (NSArray*)clusters;
- (void)setClusters:(NSArray*)clusters;
- (void)addCluster:(UInt32)internalId;

@end
