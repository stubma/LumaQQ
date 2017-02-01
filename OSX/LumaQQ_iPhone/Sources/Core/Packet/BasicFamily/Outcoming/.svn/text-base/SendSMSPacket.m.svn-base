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

#import "SendSMSPacket.h"
#import "ByteTool.h"

@implementation SendSMSPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandSendSMS;
		m_mobiles = [[NSMutableArray array] retain];
		m_QQs = [[NSMutableArray array] retain];
		m_messageSequence = 0;
		m_type = 0;
		m_contentId = 0;
		m_contentType = 0;
	}
	return self;
}

- (void) dealloc {
	[m_mobiles release];
	[m_QQs release];
	[m_name release];
	[m_messageData release];
	[super dealloc];
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeUInt16:m_messageSequence];
	[buf writeUInt16:0];
	[buf writeUInt32:0];
	[buf writeString:m_name maxLength:kQQMaxSMSSenderName fillZero:YES];
	[buf writeByte:0];
	[buf writeByte:m_type];
	[buf writeByte:m_contentType];
	[buf writeUInt32:m_contentId];
	[buf writeByte:0];
	
	[buf writeByte:[m_mobiles count]];
	NSEnumerator* e = [m_mobiles objectEnumerator];
	NSString* mobile;
	while(mobile = [e nextObject]) {
		[buf writeString:mobile maxLength:kQQMaxMobileLength fillZero:YES];
		[buf writeByte:0];
		[buf writeUInt16:0];
	}
	
	[buf writeByte:[m_QQs count]];
	e = [m_QQs objectEnumerator];
	NSNumber* QQ;
	while(QQ = [e nextObject])
		[buf writeUInt32:[QQ unsignedIntValue]];
	
	[buf writeByte:0x03];
	[buf writeUInt16:[m_messageData length]];
	[buf writeBytes:m_messageData];
}

- (void)addQQ:(UInt32)QQ {
	[m_QQs addObject:[NSNumber numberWithUnsignedInt:QQ]];
}

- (void)addMobile:(NSString*)mobile {
	[m_mobiles addObject:mobile];
}

#pragma mark -
#pragma mark getter and setter

- (NSString*)name {
	return m_name;
}

- (void)setName:(NSString*)name {
	[name retain];
	[m_name release];
	m_name = name;
}

- (NSData*)messageData {
	return m_messageData;
}

- (void)setMessageData:(NSData*)message {
	[message retain];
	[m_messageData release];
	m_messageData = message;
}

- (NSArray*)mobiles {
	return m_mobiles;
}

- (void)setMobiles:(NSArray*)mobiles {
	[m_mobiles addObjectsFromArray:mobiles];
}

- (NSArray*)QQs {
	return m_QQs;
}

- (void)setQQs:(NSArray*)QQs {
	[m_QQs addObjectsFromArray:QQs];
}

- (UInt16)messageSequence {
	return m_messageSequence;
}

- (void)setMessageSequence:(UInt16)messageSequence {
	m_messageSequence = messageSequence;
}

@end
