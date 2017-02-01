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

#import "BasicOutPacket.h"
#import "ByteBuffer.h"

@implementation BasicOutPacket : OutPacket

#pragma mark -
#pragma mark override super method

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_header = kQQHeaderBasicFamily;
		m_tail = kQQTailBasicFamily;
		m_version = kQQVersionCurrent;
	}
	return self;
}

- (void)fillHeader:(ByteBuffer*)buf {
	[buf writeByte:kQQHeaderBasicFamily];
	[buf writeUInt16:kQQVersionCurrent];
	[buf writeUInt16:m_command];
	[buf writeUInt16:m_sequence];
	[buf writeUInt32:[m_user QQ]];
}

- (void)fillTail:(ByteBuffer*)buf {
	[buf writeByte:kQQTailBasicFamily];
}

- (int)getEncryptStart {
	return 11;
}

- (int)getEncryptLength {
	return m_bodyLength;
}

- (int)getDecryptStart:(NSData*)data {
	return 11;
}

- (int)getDecryptLength:(NSData*)data {
	return [data length] - 12;
}

- (int)family {
	return kQQFamilyBasic;
}

- (char)subCommand {
	return m_subCommand;
}

- (void)setSubCommand:(char)subCommand {
	m_subCommand = subCommand;
}

@end
