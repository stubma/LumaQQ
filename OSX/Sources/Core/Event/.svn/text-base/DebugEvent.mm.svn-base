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

#import "DebugEvent.h"


@implementation DebugEvent

- (id)initWithId:(int)eventId packet:(Packet*)packet data:(NSData*)data {
	[self setEventId:eventId];
	[self setPacket:packet];
	[self setData:data];
	return self;
}

- (void) dealloc {
	[m_packet release];
	[m_data release];
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

- (int)eventId {
	return m_eventId;
}

- (void)setEventId:(int)eventId {
	m_eventId = eventId;
}

- (Packet*)packet {
	return m_packet;
}

- (void)setPacket:(Packet*)packet {
	[packet retain];
	[m_packet release];
	m_packet = packet;
}

- (NSData*)data {
	return m_data;
}

- (void)setData:(NSData*)data {
	[data retain];
	[m_data release];
	m_data = data;
}

@end
