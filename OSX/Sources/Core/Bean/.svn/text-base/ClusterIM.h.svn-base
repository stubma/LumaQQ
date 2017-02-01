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

#import <Cocoa/Cocoa.h>
#import "ByteBuffer.h"
#import "FontStyle.h"

@interface ClusterIM : NSObject <NSCoding> {
	UInt32 m_parentInternalId; // only valid for temp cluster message
	UInt32 m_internalId; // for temp cluster message, it uses internal id
	UInt32 m_externalId; // for cluster message, it uses external id
	char m_clusterType;
	UInt32 m_versionId;
	UInt32 m_sender;
	UInt16 m_messageSequence;
	UInt32 m_sendTime;
	UInt8 m_fragmentCount;
	UInt8 m_fragmentIndex;
	UInt16 m_messageId;
	NSData* m_messageData; // don't use NSString here because it may be a fragment
	FontStyle* m_fontStyle;
	UInt16 m_contentType;
	
	// from a QQ client in a mobile
	BOOL m_fromMobileQQ;
}

- (void)read:(ByteBuffer*)buf;
- (void)read0020:(ByteBuffer*)buf;
- (void)read002A:(ByteBuffer*)buf;

- (BOOL)hasFontStyle;
- (NSComparisonResult)compare:(ClusterIM*)clusterIM;

// getter and setter
- (BOOL)fromMobileQQ;
- (UInt32)parentInternalId;
- (UInt32)internalId;
- (UInt16)contentType;
- (UInt32)versionId;
- (char)clusterType;
- (UInt32)externalId;
- (UInt16)messageSequence;
- (UInt32)sendTime;
- (UInt32)sender;
- (UInt8)fragmentCount;
- (UInt8)fragmentIndex;
- (UInt16)messageId;
- (NSData*)messageData;
- (void)setMessageData:(NSData*)data;
- (FontStyle*)fontStyle;
- (void)setFontStyle:(FontStyle*)style;

@end
