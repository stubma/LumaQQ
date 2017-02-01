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

#import "OutPacket.h"


@implementation OutPacket : Packet

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_sendCount = 0;
		m_needAck = YES;
		m_repeatTimeIfNoAck = 1;
	}
	return self;
}

- (id)initWithQQUser:(QQUser*)user encryptKey:(NSData*)key {
	self = [super initWithQQUser:user encryptKey:key];
	if(self) {
		m_sendCount = 0;
		m_needAck = YES;
		m_repeatTimeIfNoAck = 1;
	}
	return self;
}

- (void)increaseSendCount {
	m_sendCount++;
}

- (void) dealloc {
	[m_sentDate release];
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

- (int)sendCount {
	return m_sendCount;
}

- (BOOL)needAck {
	return m_needAck;
}

- (void)setNeedAck:(BOOL)needAck {
	m_needAck = needAck;
}

- (NSDate*)sentDate {
	return m_sentDate;
}

- (void)setSentDate:(NSDate*)date {
	[date retain];
	[m_sentDate release];
	m_sentDate = date;
}

- (int)repeatTimeIfNoAck {
	return m_repeatTimeIfNoAck;
}

- (void)setRepeatTimeIfNoAck:(int)time {
	m_repeatTimeIfNoAck = time;
}

@end
