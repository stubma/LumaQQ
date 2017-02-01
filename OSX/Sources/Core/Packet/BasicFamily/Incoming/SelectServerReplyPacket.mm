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


#import "SelectServerReplyPacket.h"


@implementation SelectServerReplyPacket

- (void)parseBody:(ByteBuffer*)buf {
	m_nextTimes = [buf getUInt16];
	m_unknown1 = [buf getByte];
	m_unknown2 = [buf getUInt32];
	m_unknown3 = [buf getUInt32];
	[buf getBytes:m_redirectServerIp length:4];
}

- (NSData*)getDecryptKey {
	return [m_user selectServerRandomKey];
}

#pragma mark -
#pragma mark getter and setter

- (UInt16)nextTimes {
	return m_nextTimes;
}

- (char)unknown1 {
	return m_unknown1;
}

- (UInt32)unknown2 {
	return m_unknown2;
}

- (UInt32)unknown3 {
	return m_unknown3;
}

- (char*)redirectServerIp {
	return m_redirectServerIp;
}

@end
