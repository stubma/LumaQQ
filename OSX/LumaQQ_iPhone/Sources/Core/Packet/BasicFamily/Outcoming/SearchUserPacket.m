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

#import "SearchUserPacket.h"


@implementation SearchUserPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandSearch;
		m_QQ = 0;
		m_page = 0;
		m_nick = nil;
	}
	return self;
}

- (void) dealloc {
	[m_nick release];
	[super dealloc];
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeByte:m_subCommand];
	switch(m_subCommand) {
		case kQQSubCommandSearchAll:
			[buf writeByte:0x1F];
			[buf writeString:[NSString stringWithFormat:@"%u", m_page]];
			break;
		case kQQSubCommandSearchByNick:
		case kQQSubCommandSearchByQQ:
			[buf writeByte:0x1F];
			if(m_QQ == 0)
				[buf writeByte:0x2D];
			else
				[buf writeString:[NSString stringWithFormat:@"%u", m_QQ]];
			
			[buf writeByte:0x1F];
			if(m_nick == nil)
				[buf writeByte:0x2D];
			else
				[buf writeString:m_nick];
			
			[buf writeByte:0x1F];
			[buf writeByte:0x2D];
			
			[buf writeByte:0x1F];
			[buf writeString:[NSString stringWithFormat:@"%u", m_page]];
			[buf writeByte:0];
			break;
	}
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)QQ {
	return m_QQ;
}

- (void)setQQ:(UInt32)QQ {
	m_QQ = QQ;
}

- (NSString*)nick {
	return m_nick;
}

- (void)setNick:(NSString*)nick {
	[nick retain];
	[m_nick release];
	m_nick = nick;
}

- (UInt32)page {
	return m_page;
}

- (void)setPage:(UInt32)page {
	m_page = page;
}

@end
