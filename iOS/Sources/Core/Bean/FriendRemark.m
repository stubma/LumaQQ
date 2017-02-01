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

#import "FriendRemark.h"
#import "NSString-Filter.h"

@implementation FriendRemark

- (void) dealloc {
	[m_name release];
	[m_mobile release];
	[m_telephone release];
	[m_address release];
	[m_email release];
	[m_zipcode release];
	[m_note release];
	[super dealloc];
}

- (void)read:(ByteBuffer*)buf {
	m_QQ = [buf getUInt32];
	[buf skip:1];
	int len = [buf getByte] & 0xFF;
	m_name = [[[buf getString:len] normalize] retain];
	len = [buf getByte] & 0xFF;
	m_mobile = [[buf getString:len] retain];
	len = [buf getByte] & 0xFF;
	m_telephone = [[buf getString:len] retain];
	len = [buf getByte] & 0xFF;
	m_address = [[buf getString:len] retain];
	len = [buf getByte] & 0xFF;
	m_email = [[buf getString:len] retain];
	len = [buf getByte] & 0xFF;
	m_zipcode = [[buf getString:len] retain];
	len = [buf getByte] & 0xFF;
	m_note = [[buf getString:len] retain];
}

- (void)write:(ByteBuffer*)buf {
	[buf writeUInt32:m_QQ];
	[buf writeByte:0];
	[buf writeString:m_name withLength:YES lengthByte:1];
	[buf writeString:m_mobile withLength:YES lengthByte:1];
	[buf writeString:m_telephone withLength:YES lengthByte:1];
	[buf writeString:m_address withLength:YES lengthByte:1];
	[buf writeString:m_email withLength:YES lengthByte:1];
	[buf writeString:m_zipcode withLength:YES lengthByte:1];
	[buf writeString:m_note withLength:YES lengthByte:1];
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)QQ {
	return m_QQ;
}

- (NSString*)name {
	return m_name;
}

- (NSString*)mobile {
	return m_mobile;
}

- (NSString*)telephone {
	return m_telephone;
}

- (NSString*)address {
	return m_address;
}

- (NSString*)email {
	return m_email;
}

- (NSString*)zipcode {
	return m_zipcode;
}

- (NSString*)note {
	return m_note;
}

@end
