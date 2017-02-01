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

#import "ClusterIM.h"
#import "NSMutableData-Trim.h"

#define _kKeySender @"ClusterIM_Sender"
#define _kKeyTime @"ClusterIM_Time"
#define _kKeyData @"ClusterIM_Data"
#define _kKeyStyle @"ClusterIM_Style"

@implementation ClusterIM

- (void) dealloc {
	[m_messageData release];
	[m_fontStyle release];
	[super dealloc];
}

- (void)read:(ByteBuffer*)buf {
	m_externalId = [buf getUInt32];
	m_clusterType = [buf getByte];
	m_sender = [buf getUInt32];
	[buf skip:2];
	m_messageSequence = [buf getUInt16];
	m_sendTime = [buf getUInt32];
	m_versionId = [buf getUInt32];
	[buf skip:2];
	m_contentType = [buf getUInt16];
	m_fragmentCount = [buf getByte] & 0xFF;
	m_fragmentIndex = [buf getByte] & 0xFF;
	m_messageId = [buf getUInt16];
	[buf skip:4];

	if([self hasFontStyle]) {
		int fontStyleLength = [buf getByte:([buf length] - 1)] & 0xFF;
		m_messageData = [[NSMutableData dataWithLength:([buf available] - fontStyleLength)] retain];
		[buf getBytes:(NSMutableData*)m_messageData];
		m_fontStyle = [[FontStyle alloc] init];
		[m_fontStyle read:buf];
	} else {
		m_messageData = [[NSMutableData dataWithLength:[buf available]] retain];
		[buf getBytes:(NSMutableData*)m_messageData];
	}
	
	// check fragment count, the message from mobile user will set count to 0!!
	if(m_fragmentCount == 0) {
		m_fragmentCount = 1;
		if(m_fontStyle == nil)
			m_fontStyle = [[FontStyle defaultStyle] retain];
	}
	
	// filter tail space
	if(m_fragmentIndex == m_fragmentCount - 1)
		[(NSMutableData*)m_messageData tailTrim:0x20];
}

- (void)read0020:(ByteBuffer*)buf {
	m_externalId = [buf getUInt32];
	m_clusterType = [buf getByte];
	m_sender = [buf getUInt32];
	[buf skip:2];
	m_messageSequence = [buf getUInt16];
	m_sendTime = [buf getUInt32];
	m_versionId = [buf getUInt32];
	
	int len = [buf getUInt16];
	m_messageData = [[NSMutableData dataWithLength:len] retain];
	[buf getBytes:(NSMutableData*)m_messageData];
	
	if([buf hasAvailable]) {
		m_fontStyle = [[FontStyle alloc] init];
		[m_fontStyle read:buf];
	} else {
		m_fontStyle = [[FontStyle defaultStyle] retain];
	}
	
	// make it no fragment
	m_fragmentCount = 1;
	m_fragmentIndex = 0;
	
	// filter tail space
	if(m_fragmentIndex == m_fragmentCount - 1)
		[(NSMutableData*)m_messageData tailTrim:0x20];
}

- (void)read002A:(ByteBuffer*)buf {
	m_parentInternalId = [buf getUInt32];
	m_clusterType = [buf getByte];
	m_internalId = [buf getUInt32];
	m_sender = [buf getUInt32];
	[buf skip:2];
	m_messageSequence = [buf getUInt16];
	m_sendTime = [buf getUInt32];
	m_versionId = [buf getUInt32];
	[buf skip:2];
	m_contentType = [buf getUInt16];
	m_fragmentCount = [buf getByte] & 0xFF;
	m_fragmentIndex = [buf getByte] & 0xFF;
	m_messageId = [buf getUInt16];
	[buf skip:4];
	
	if([self hasFontStyle]) {
		int fontStyleLength = [buf getByte:([buf length] - 1)] & 0xFF;
		m_messageData = [[NSMutableData dataWithLength:([buf available] - fontStyleLength)] retain];
		[buf getBytes:(NSMutableData*)m_messageData];
		m_fontStyle = [[FontStyle alloc] init];
		[m_fontStyle read:buf];
	} else {
		m_messageData = [[NSMutableData dataWithLength:[buf available]] retain];
		[buf getBytes:(NSMutableData*)m_messageData];
	}
	
	// check fragment count, the message from mobile user will set count to 0!!
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
	if([anObject isMemberOfClass:[ClusterIM class]]) {
		ClusterIM* im = (ClusterIM*)anObject;
		return [im messageId] == m_messageId && [im fragmentIndex] == m_fragmentIndex;
	} else
		return NO;
}

- (unsigned)hash {
	return m_messageId << 16 | m_fragmentIndex;
}

- (BOOL)hasFontStyle {
	return m_fragmentIndex + 1 == m_fragmentCount;
}

- (NSComparisonResult)compare:(ClusterIM*)clusterIM {
	int ret = m_messageId - [clusterIM messageId];
	if(ret == 0)
		ret = m_fragmentIndex - [clusterIM fragmentIndex];
	return (ret > 0) ? NSOrderedDescending : ((ret < 0) ? NSOrderedAscending : NSOrderedSame);
}

#pragma mark -
#pragma mark NSCoding protocol

- (void)encodeWithCoder:(NSCoder*)encoder {
	[encoder encodeInt32:m_sender forKey:_kKeySender];
	[encoder encodeInt32:m_sendTime forKey:_kKeyTime];
	[encoder encodeObject:m_messageData forKey:_kKeyData];
	[encoder encodeObject:m_fontStyle forKey:_kKeyStyle];
}

- (id)initWithCoder:(NSCoder*)decoder {
	m_sender = [decoder decodeInt32ForKey:_kKeySender];
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

- (UInt32)parentInternalId {
	return m_parentInternalId;
}

- (UInt32)internalId {
	return m_internalId;
}

- (UInt16)contentType {
	return m_contentType;
}

- (UInt32)versionId {
	return m_versionId;
}

- (char)clusterType {
	return m_clusterType;
}

- (UInt32)externalId {
	return m_externalId;
}

- (UInt16)messageSequence {
	return m_messageSequence;
}

- (UInt32)sendTime {
	return m_sendTime;
}

- (UInt32)sender {
	return m_sender;
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

- (void)setFontStyle:(FontStyle*)style {
	[style retain];
	[m_fontStyle release];
	m_fontStyle = style;
}

@end
