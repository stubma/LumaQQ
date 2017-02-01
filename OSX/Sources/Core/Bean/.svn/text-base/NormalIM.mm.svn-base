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

#import "NormalIM.h"
#import "QQConstants.h"
#import "NSMutableData-Trim.h"

#define _kKeyTime @"NormalIM_Time"
#define _kKeyData @"NormalIM_Data"
#define _kKeyStyle @"NormalIM_Style"

@implementation NormalIM

- (void) dealloc {
	[m_messageData release];
	[m_fontStyle release];
	[super dealloc];
}

- (void)read:(ByteBuffer*)buf {
	m_sessionId = [buf getUInt16];
	m_sendTime = [buf getUInt32];
	m_senderHead = [buf getUInt16];
	m_flag = [buf getUInt32];
	m_fragmentCount = [buf getByte];
	m_fragmentIndex = [buf getByte];
	m_messageId = [buf getUInt16];
	m_replyType = [buf getByte];
	
	int fontStyleLength = [buf getByte:([buf length] - 1)] & 0xFF;
	m_messageData = [[NSMutableData dataWithLength:([buf available] - fontStyleLength)] retain];
	[buf getBytes:(NSMutableData*)m_messageData];
	m_fontStyle = [[FontStyle alloc] init];
	[m_fontStyle read:buf];
}

- (void)readEx:(ByteBuffer*)buf {
	m_sessionId = [buf getUInt16];
	m_sendTime = [buf getUInt32];
	m_senderHead = [buf getUInt16];
	m_flag = [buf getUInt32];
	[buf skip:8]; // unknown 8 bytes
	m_fragmentCount = [buf getByte];
	m_fragmentIndex = [buf getByte];
	m_messageId = [buf getUInt16];
	m_replyType = [buf getByte];
	
	int fontStyleLength = [buf getByte:([buf length] - 1)] & 0xFF;
	m_messageData = [[NSMutableData dataWithLength:([buf available] - fontStyleLength)] retain];
	[buf getBytes:(NSMutableData*)m_messageData];
	m_fontStyle = [[FontStyle alloc] init];
	[m_fontStyle read:buf];
	
	// check fragment count, the message from mobile QQ will set count to 0!!
	if(m_fragmentCount == 0) {
		m_fromMobileQQ = YES;
		m_fragmentCount = 1;
		if(m_fontStyle == nil)
			m_fontStyle = [[FontStyle defaultStyle] retain];
	} else
		m_fromMobileQQ = NO;
	
	// filter tail space
	if(m_fragmentIndex == m_fragmentCount - 1)
		[(NSMutableData*)m_messageData tailTrim:0x20];
}

- (BOOL)isEqual:(id)anObject {
	if([anObject isMemberOfClass:[NormalIM class]]) {
		NormalIM* im = (NormalIM*)anObject;
		return [im messageId] == m_messageId && [im fragmentIndex] == m_fragmentIndex;
	} else
		return NO;
}

- (unsigned)hash {
	return m_messageId << 16 | m_fragmentIndex;
}

- (NSComparisonResult)compare:(NormalIM*)normalIM {
	int ret = m_messageId - [normalIM messageId];
	if(ret == 0)
		ret = m_fragmentIndex - [normalIM fragmentIndex];
	return (ret > 0) ? NSOrderedDescending : ((ret < 0) ? NSOrderedAscending : NSOrderedSame);
}

#pragma mark -
#pragma mark NSCoding protocol

- (void)encodeWithCoder:(NSCoder*)encoder {
	[encoder encodeInt32:m_sendTime forKey:_kKeyTime];
	[encoder encodeObject:m_messageData forKey:_kKeyData];
	[encoder encodeObject:m_fontStyle forKey:_kKeyStyle];
}

- (id)initWithCoder:(NSCoder*)decoder {
	m_sendTime = [decoder decodeInt32ForKey:_kKeyTime];
	m_messageData = [[decoder decodeObjectForKey:_kKeyData] retain];
	m_fontStyle = [[decoder decodeObjectForKey:_kKeyStyle] retain];
	return self;
}

#pragma mark -
#pragma mark getter and setter

- (BOOL)fromMobileQQ {
	return m_fromMobileQQ;
}

- (UInt16)sessionId {
	return m_sessionId;
}

- (UInt32)sendTime {
	return m_sendTime;
}

- (UInt16)senderHead {
	return m_senderHead;
}

- (UInt32)flag {
	return m_flag;
}

- (UInt8)fragmentCount {
	return m_fragmentCount;
}

- (UInt8)fragmentIndex {
	return m_fragmentIndex;
}

- (UInt16)messageId {
	return m_messageId;
}

- (char)replyType {
	return m_replyType;
}

- (NSData*)messageData {
	return m_messageData;
}

- (void)setMessageData:(NSData*)data {
	[data retain];
	[m_messageData release];
	m_messageData = data;
}

- (FontStyle*)fontStyle {
	return m_fontStyle;
}

@end
