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
#import "ClusterCommandPacket.h"

////////// format 1 ///////
// header
// ---- encrypt start (session key) ----
// sub command, 1 byte
// internal id, 4 bytes
// modify mask, 4 bytes
// (NOTE) according to the mask, following content may exist or not
// notification right, 1 byte
// default channel id, 4 bytes
// --- encrypt end ---
// tail

@interface ClusterModifyChannelSettingPacket : ClusterCommandPacket {
	UInt32 m_mask;
	char m_notificationRight;
	UInt32 m_defaultChannelId;
}

// getter and setter
- (UInt32)mask;
- (void)setMask:(UInt32)mask;
- (char)notificationRight;
- (void)setNotificationRight:(char)right;
- (UInt32)defaultChannelId;
- (void)setDefaultChannelId:(UInt32)channel;

@end
