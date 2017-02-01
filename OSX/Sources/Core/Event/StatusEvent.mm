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

#import "StatusEvent.h"


@implementation StatusEvent

- (id)initWithId:(int)eventId oldStatus:(int)oldStatus newStatus:(int)newStatus {
	[self setEventId:eventId];
	[self setOldStatus:oldStatus];
	[self setNewStatus:newStatus];
	return self;
}

- (void) dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

- (int)eventId {
	return m_eventId;
}

- (void)setEventId:(int)value {
	m_eventId = value;
}

- (int)oldStatus {
	return m_oldStatus;
}

- (void)setOldStatus:(int)value {
	m_oldStatus = value;
}

- (int)newStatus {
	return m_newStatus;
}

- (void)setNewStatus:(int)value {
	m_newStatus = value;
}

@end
