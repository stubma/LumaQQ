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

#import "QQNotification.h"
#import "QQEvent.h"

@implementation QQNotification : NSNotification

- (id)initWithId:(int)value packet:(Packet*)p {
	// Xcode help: don't call init() of NSNotification
	[self setEventId:value];
	[self setPacket:p];
	return self;
}

- (id)initWithId:(int)value packet:(Packet*)p outPacket:(OutPacket*)outPacket {
	// Xcode help: don't call init() of NSNotification
	[self setEventId:value];
	[self setPacket:p];
	[self setOutPacket:outPacket];
	return self;
}

- (id)initWithId:(int)value connection:(int)connId {
	// Xcode help: don't call init() of NSNotification
	[self setEventId:value];
	[self setConnectionId:connId];
	return self;
}

- (void) dealloc {
	[m_packet release];
	[m_outPacket release];
	[super dealloc];
}

- (int)eventId {
	return m_eventId;
}

- (void)setEventId:(int)idValue {
	m_eventId = idValue;
}

- (int)connectionId {
	return m_connId;
}

- (void)setConnectionId:(int)connId {
	m_connId = connId;
}

- (void)setPacket:(Packet*)p {
	[p retain];
	[m_packet release];
	m_packet = p;
}

- (NSString *)name {
	return kQQNotificationName;
}

- (id)object {
	return m_packet;
}

- (OutPacket*)outPacket {
	return m_outPacket;
}

- (void)setOutPacket:(OutPacket*)outPacket {
	[outPacket retain];
	[m_outPacket release];
	m_outPacket = outPacket;
}

- (NSDictionary *)userInfo {
	return nil;
}

@end
