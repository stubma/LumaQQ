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
#import "Packet.h"

#pragma mark -
#pragma mark status event

#define kDebugEventIncomingPacket 0
#define kDebugEventOutcomingPacket 1

@interface DebugEvent : NSObject {
	int m_eventId;
	Packet* m_packet;
	NSData* m_data;
}

- (id)initWithId:(int)eventId packet:(Packet*)packet data:(NSData*)data;

// getter and setter
- (int)eventId;
- (void)setEventId:(int)eventId;
- (Packet*)packet;
- (void)setPacket:(Packet*)packet;
- (NSData*)data;
- (void)setData:(NSData*)data;

@end
