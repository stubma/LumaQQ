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

#import "SendSMSReplyPacket.h"
#import "SMSReply.h"

@implementation SendSMSReplyPacket

- (void)parseBody:(ByteBuffer*)buf {
	[buf skip:6];
	int len = [buf getByte] & 0xFF;
	m_replyMessage = [[buf getString:len] retain];
	
	int count = [buf getByte] & 0xFF;
	m_mobileReplies = [[NSMutableArray array] retain];
	while(count-- > 0) {
		SMSReply* reply = [[SMSReply alloc] init];
		[reply readMobileReply:buf];
		[m_mobileReplies addObject:reply];
		[reply release];
	}
	
	count = [buf getByte] & 0xFF;
	m_QQReplies = [[NSMutableArray array] retain];
	while(count-- > 0) {
		SMSReply* reply = [[SMSReply alloc] init];
		[reply readQQReply:buf];
		[m_QQReplies addObject:reply];
		[reply release];
	}
	
	[buf skip:1];
	len = [buf getByte] & 0xFF;
	m_referenceMessage = [[buf getString:len] retain];
}

- (void) dealloc {
	[m_replyMessage release];
	[m_referenceMessage release];
	[m_mobileReplies release];
	[m_QQReplies release];
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

- (NSString*)replyMessage {
	return m_replyMessage;
}

- (NSString*)referenceMessage {
	return m_referenceMessage;
}

- (NSArray*)mobileReplies {
	return m_mobileReplies;
}

- (NSArray*)QQReplies {
	return m_QQReplies;
}

@end
