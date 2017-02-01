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

#import "SystemNotificationPacket.h"

#define _kKeySubCommand @"SystemNotificationPacket_SubCommand"
#define _kKeySourceQQ @"SystemNotificationPacket_SourceQQ"
#define _kKeyDestQQ @"SystemNotificationPacket_DestQQ"
#define _kKeyMessage @"SystemNotificationPacket_Message"
#define _kKeyAllowAddReverse @"SystemNotificationPacket_AllowAddReverse"

@implementation SystemNotificationPacket

- (void) dealloc {
	[m_message release];
	[m_unknownId release];
	[m_unknownToken release];
	[super dealloc];
}

- (BOOL)isServerInitiative {
	return YES;
}

- (BOOL)isSystemMessage {
	return YES;
}

- (void)parseBody:(ByteBuffer*)buf {
	NSString* s = [buf getStringUntil:0x1F];
	m_subCommand = [s intValue];
	
	s = [buf getStringUntil:0x1F];
	m_sourceQQ = [s intValue];
	
	s = [buf getStringUntil:0x1F];
	m_destQQ = [s intValue];
	
	switch(m_subCommand) {
		case kQQSubCommandOtherApproveMyRequest:
		case kQQSubCommandOtherRejectMyRequest:
			m_message = [[buf getStringUntil:0x1F] retain];
			int len = [buf getUInt16];
			m_unknownId = [[NSMutableData dataWithLength:len] retain];
			[buf getBytes:(NSMutableData*)m_unknownId];
			break;
		case kQQSubCommandOtherAddMeEx:
			len = [buf getByte] & 0xFF;
			m_unknownToken = [[NSMutableData dataWithLength:len] retain];
			[buf getBytes:(NSMutableData*)m_unknownToken];
			len = [buf getUInt16];
			m_unknownId = [[NSMutableData dataWithLength:len] retain];
			[buf getBytes:(NSMutableData*)m_unknownId];
			break;
		case kQQSubCommandOtherRequestAddMeEx:
			len = [buf getByte] & 0xFF;
			m_message = [[buf getString:len] retain];
			m_allowAddReverse = [buf getByte] == 0x01;
			len = [buf getUInt16];
			m_unknownId = [[NSMutableData dataWithLength:len] retain];
			[buf getBytes:(NSMutableData*)m_unknownId];
			break;
		case kQQSubCommandOtherApproveMyRequestAndAddMe:
			len = [buf getByte] & 0xFF;
			m_message = [[buf getString:len] retain];
			[buf skip:1];
			len = [buf getUInt16];
			m_unknownId = [[NSMutableData dataWithLength:len] retain];
			[buf getBytes:(NSMutableData*)m_unknownId];
			break;
	}
}

#pragma mark -
#pragma mark NSCoding protocol

- (void)encodeWithCoder:(NSCoder*)encoder {
	[encoder encodeInt:m_subCommand forKey:_kKeySubCommand];
	[encoder encodeInt32:m_sourceQQ forKey:_kKeySourceQQ];
	[encoder encodeInt32:m_destQQ forKey:_kKeyDestQQ];
	[encoder encodeObject:m_message forKey:_kKeyMessage];
	[encoder encodeBool:m_allowAddReverse forKey:_kKeyAllowAddReverse];
	[super encodeWithCoder:encoder];
}

- (id)initWithCoder:(NSCoder*)decoder {
	m_subCommand = [decoder decodeIntForKey:_kKeySubCommand];
	m_sourceQQ = [decoder decodeInt32ForKey:_kKeySourceQQ];
	m_destQQ = [decoder decodeInt32ForKey:_kKeyDestQQ];
	m_message = [[decoder decodeObjectForKey:_kKeyMessage] retain];
	m_allowAddReverse = [decoder decodeBoolForKey:_kKeyAllowAddReverse];
	return [super initWithCoder:decoder];
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)sourceQQ {
	return m_sourceQQ;
}

- (UInt32)destQQ {
	return m_destQQ;
}

- (NSString*)message {
	return m_message == nil ? @"" : m_message;
}

- (NSData*)unknownId {
	return m_unknownId;
}

- (NSData*)unknownToken {
	return m_unknownToken;
}

- (BOOL)allowAddReverse {
	return m_allowAddReverse;
}

@end
