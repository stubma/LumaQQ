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
#import "QQUser.h"
#import "QQConstants.h"
#import "ByteBuffer.h"

@interface Packet : NSObject <NSCoding, NSCopying> {
	char m_header;
	char m_tail;
	UInt16 m_version;
	UInt16 m_command;
	UInt16 m_sequence;
	
	// length of body bytes
	int m_bodyLength;	
	
	// qq user object
	QQUser* m_user;
	
	// temporary save connection id in the field
	NSNumber* m_connId;
	
	// decrypt and encrypt key
	NSData* m_decryptKey;
	NSData* m_encryptKey;
}

// initialization
- (id)initWithQQUser:(QQUser*)user;
- (id)initWithQQUser:(QQUser*)user encryptKey:(NSData*)key;
- (id)initWithData:(NSData*)data user:(QQUser*)user;
- (id)initWithData:(NSData*)data user:(QQUser*)user decryptKey:(NSData*)key;

// fill and parse
- (NSData*)plainBody;
- (NSData*)plain;
- (NSData*)encrypted;
- (void)fillHeader:(ByteBuffer*)buf;
- (void)fillBody:(ByteBuffer*)buf;
- (void)fillTail:(ByteBuffer*)buf;
- (void)postFill:(ByteBuffer*)buf bodyOffset:(int)bodyOffset tailOffset:(int)tailOffset;
- (void)parseHeader:(ByteBuffer*)buf;
- (void)parseBody:(ByteBuffer*)buf;
- (void)parseTail:(ByteBuffer*)buf;
- (int)getInPacketHeaderLength;
- (int)getInPacketTailLength;

// subclass must override
- (int)family;

// packet property
- (BOOL)isSystemMessage;
- (BOOL)isClusterMessage;
- (id)packetOwner;

//
// encrypt/decrypt setters
//

// start must larger than 0
- (int)getEncryptStart;

// -1 means encrypt till end
- (int)getEncryptLength;

// start must larger than 0
- (int)getDecryptStart:(NSData*)data;

// -1 means decrypt till end
- (int)getDecryptLength:(NSData*)data;

// nil means don't encrypt
- (NSData*)getEncryptKey;

// nil means don't decrypt
- (NSData*)getDecryptKey;

// if getDecrypt returns nil, the return value of this method doesn't matter
- (NSData*)getFallbackDecryptKey;

// getter and setter
- (UInt16)version;
- (UInt16)command;
- (char)header;
- (char)tail;
- (void)setCommand:(UInt16)command;
- (UInt16)sequence;
- (void)setSequence:(UInt16)sequence;
- (void)setConnectionId:(NSNumber*)connId;
- (NSNumber*)connectionId;
- (QQUser*)user;

@end
