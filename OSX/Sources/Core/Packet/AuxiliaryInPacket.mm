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

#import "AuxiliaryInPacket.h"


@implementation AuxiliaryInPacket

- (void)parseHeader:(ByteBuffer*)buf {
	m_header = [buf getByte];
	m_command = [buf getByte];
	m_sequence = [buf getUInt16];
	[buf skip:39];
	m_version = [buf getUInt16];
	[buf skip:1];
}

- (BOOL)triggerAnyway {
	return YES;
}

- (int)family {
	return kQQFamilyAuxiliary;
}

- (int)getInPacketHeaderLength {
	return 46;
}

- (int)getInPacketTailLength {
	return 0;
}

- (int)getEncryptLength {
	return 0;
}

- (int)getDecryptLength:(NSData*)data {
	return 0;
}

- (NSData*)getEncryptKey {
	return nil;
}

- (NSData*)getDecryptKey {
	return nil;
}

- (NSData*)getFallbackDecryptKey {
	return nil;
}

@end
