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

#import "SMSReply.h"
#import "QQConstants.h"

@implementation SMSReply

- (void)readQQReply:(ByteBuffer*)buf {
	m_QQ = [buf getUInt32];
	m_reply = [buf getByte];
	int len = [buf getByte] & 0xFF;
	m_message = [[buf getString:len] retain];
	[buf skip:1];
	
	m_mobile = nil;
}

- (void)readMobileReply:(ByteBuffer*)buf {
	m_mobile = [[buf getStringUntil:0 maxLength:kQQMaxMobileLength] retain];
	[buf skip:2];
	m_reply = [buf getByte];
	int len = [buf getByte] & 0xFF;
	m_message = [[buf getString:len] retain];
	[buf skip:1];
	
	m_QQ = -1;
}

- (void) dealloc {
	[m_message release];
	[m_mobile release];
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)QQ {
	return m_QQ;
}

- (NSString*)mobile {
	return m_mobile;
}

- (NSString*)message {
	return m_message;
}

- (char)reply {
	return m_reply;
}

@end
