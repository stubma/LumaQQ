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

#import "BasicInPacket.h"


@implementation BasicInPacket : InPacket

#pragma mark -
#pragma mark override super method

- (void)parseHeader:(ByteBuffer*)buf {
	m_header = [buf getByte];
	m_version = [buf getUInt16];
	m_command = [buf getUInt16];
	m_sequence = [buf getUInt16];
}

- (void)parseTail:(ByteBuffer*)buf {
	m_tail = [buf getByte];
}

- (int)getEncryptStart {
	return 7;
}

- (int)getEncryptLength {
	return m_bodyLength;
}

- (int)getDecryptStart:(NSData*)data {
	return 7;
}

- (int)getDecryptLength:(NSData*)data {
	return [data length] - 8;
}

- (int)family {
	return kQQFamilyBasic;
}

#pragma mark -
#pragma mark getter and setter

- (char)reply {
	return m_reply;
}

- (char)subCommand {
	return m_subCommand;
}

@end
