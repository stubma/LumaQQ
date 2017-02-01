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

#import "ChangeStatusPacket.h"


@implementation ChangeStatusPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandChangeStatus;
		m_statusMessage = @"";
		m_statusVersion = 0;
	}
	return self;
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeByte:m_status];
	[buf writeUInt16:m_statusVersion];
	[buf writeUInt16:0];
	[buf writeUInt32:0];
	[buf writeString:m_statusMessage
		  withLength:YES
		  lengthByte:2
		  lengthBase:0
			encoding:kQQEncodingUTF8];
}

- (void) dealloc {
	[m_statusMessage release];
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

- (char)status {
	return m_status;
}

- (void)setStatus:(char)status {
	m_status = status;
}

- (NSString*)statusMessage {
	return m_statusMessage;
}

- (void)setStatusMessage:(NSString*)msg {
	[msg retain];
	[m_statusMessage release];
	m_statusMessage = msg;
}

- (UInt16)statusVersion {
	return m_statusVersion;
}

- (void)setStatusVersion:(UInt16)version {
	m_statusVersion = version;
}

@end
