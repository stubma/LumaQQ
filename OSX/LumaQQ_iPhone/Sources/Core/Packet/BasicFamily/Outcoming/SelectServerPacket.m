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

#import "SelectServerPacket.h"


@implementation SelectServerPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandSelectServer;
		m_times = 0;
		m_unknown1 = 0;
		m_unknown2 = 0;
		m_unknown3 = 0;
		memset(m_previousServerIp, 0, 4 * sizeof(char));
	}
	return self;
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeBytes:[m_user selectServerRandomKey]];
	[buf writeUInt16:m_times];
	[buf writeByte:m_unknown1];
	[buf writeUInt32:m_unknown2];
	[buf writeUInt32:m_unknown3];
	[buf writeBytes:m_previousServerIp length:4];
}

- (int)getEncryptStart {
	return 11 + kQQKeyLength;
}

- (int)getDecryptStart:(NSData*)data {
	return 11 + kQQKeyLength;
}

- (int)getEncryptLength {
	return m_bodyLength - kQQKeyLength;
}

- (int)getDecryptLength:(NSData*)data {
	return [data length] - 11 - 1 - kQQKeyLength;
}

- (NSData*)getEncryptKey {
	return [m_user selectServerRandomKey];
}

- (NSData*)getDecryptKey {
	return [m_user selectServerRandomKey];
}

#pragma mark -
#pragma mark getter and setter

- (UInt16)times {
	return m_times;
}

- (void)setTimes:(UInt16)times {
	m_times = times;
}

- (char)unknown1 {
	return m_unknown1;
}

- (void)setUnknown1:(char)unknown1 {
	m_unknown1 = unknown1;
}

- (UInt32)unknown2 {
	return m_unknown2;
}

- (void)setUnknown2:(UInt32)unknown2 {
	m_unknown2 = unknown2;
}

- (UInt32)unknown3 {
	return m_unknown3;
}

- (void)setUnknown3:(UInt32)unknown3 {
	m_unknown3 = unknown3;
}

- (char*)previousServerIp {
	return m_previousServerIp;
}

- (void)setPreviousServerIp:(const char*)ip {
	memcpy(m_previousServerIp, ip, 4 * sizeof(char));
}

@end
