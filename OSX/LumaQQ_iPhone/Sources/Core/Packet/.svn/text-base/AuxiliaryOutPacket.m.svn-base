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

#import "AuxiliaryOutPacket.h"


@implementation AuxiliaryOutPacket

- (id)initWithQQUser:(QQUser*)user {
	return [self initWithQQUser:user encryptKey:nil];
}

- (id)initWithQQUser:(QQUser*)user encryptKey:(NSData*)key {
	self = [super initWithQQUser:user encryptKey:key];
	if(self) {
		m_header = kQQHeaderAuxiliaryFamily;
		m_version = kQQVersionCurrent;
		m_sendCount = 0;
		m_needAck = NO; // it is a little tricky to set need ack to NO
		m_repeatTimeIfNoAck = 1;
	}
	return self;
}

- (void)fillHeader:(ByteBuffer*)buf {
	[buf writeByte:m_header];
	[buf writeByte:m_command];
	[buf writeUInt16:m_sequence]; 
	
	[buf writeUInt32:0];
	[buf writeUInt32:0];
	[buf writeUInt32:0];
	[buf writeUInt32:0];
	[buf writeUInt32:0];
	[buf writeUInt32:0];
	[buf writeUInt32:0];
	[buf writeUInt32:0];
	[buf writeUInt32:0];
	[buf writeUInt16:0];
	[buf writeByte:0];
	
	[buf writeUInt16:m_version];
	[buf writeByte:0];
}

- (int)family {
	return kQQFamilyAuxiliary;
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
