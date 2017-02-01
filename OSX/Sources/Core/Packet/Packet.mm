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

#import "Packet.h"
#import "QQConstants.h"
#import "NSData-QQCrypt.h"
#import "ByteTool.h"
#import "NSData-BytesOperation.h"
#import "DebugEvent.h"

@implementation Packet

// initial 
static UInt16 m_startSequence = 1000;
static NSMutableData* m_buf;

- (void) dealloc {
	[m_connId release];
	if(m_decryptKey)
		[m_decryptKey release];
	if(m_encryptKey)
		[m_encryptKey release];
	[super dealloc];
}

- (BOOL)isEqual:(id)anObject {
	if([anObject isKindOfClass:[Packet class]])
		return [self hash] == [anObject hash];
	else
		return NO;
}

- (unsigned)hash {
	return ((([self family] << 8) | m_command) << 16) | m_sequence;
}

#pragma mark -
#pragma mark initialization

- (id)initWithQQUser:(QQUser*)user {
	return [self initWithQQUser:user encryptKey:nil];
}

- (id)initWithQQUser:(QQUser*)user encryptKey:(NSData*)key {
	self = [super init];
	if(self) {
		m_sequence = m_startSequence;
		m_startSequence++;
		
		[user retain];
		[m_user release];
		m_user = user;
		
		if(m_buf == nil)
			m_buf = [[NSMutableData dataWithLength:65536] retain];
		
		if(key)
			m_encryptKey = [key retain];
	}
	return self;
}

- (id)initWithData:(NSData*)data user:(QQUser*)user {	
	// set user
	[user retain];
	[m_user release];
	m_user = user;
	
	// get decrypted data, if decrypt key is nil, no need
	NSData* decrypted = nil;
	if([self getDecryptKey] == nil) {
		if([self getDecryptLength:data] == 0)
			decrypted = data;
	} else {
		decrypted = [data QQDecrypt:[self getDecryptKey] 
							 offset:[self getDecryptStart:data]
							 length:[self getDecryptLength:data]];
		if(decrypted == nil) {
			decrypted = [data QQDecrypt:[self getFallbackDecryptKey]
								 offset:[self getDecryptStart:data]
								 length:[self getDecryptLength:data]];
		}
	}
	
	// if nil, fail
	if(decrypted == nil)
		return nil;
	
	// get buffer
	char* buffer = (char*)[decrypted bytes];
	int hLen = [self getInPacketHeaderLength];
	int tLen = [self getInPacketTailLength];
	
	// parse header
	ByteBuffer* bb = [ByteBuffer bufferWithBytes:buffer length:hLen];
	[self parseHeader:bb];
	
	// parse body
	bb = [ByteBuffer bufferWithBytes:(buffer + hLen) length:([decrypted length] - hLen - tLen)];
	[self parseBody:bb];
	
	// parse tail
	bb = [ByteBuffer bufferWithBytes:(buffer + [decrypted length] - tLen) length:tLen];
	[self parseTail:bb];
	
	// output packet content
	if([m_user isDebugging]) {
		DebugEvent* event = [[DebugEvent alloc] initWithId:kDebugEventIncomingPacket
													 packet:self
													   data:decrypted];
		[m_user deliveryDebugEvent:event];
		[event release];
	}
	
	return self;
}

- (id)initWithData:(NSData*)data user:(QQUser*)user decryptKey:(NSData*)key {
	if(key)
		m_decryptKey = [key retain];
	
	return [self initWithData:data user:user];
}

#pragma mark -
#pragma mark NSCoding protocol

- (void)encodeWithCoder:(NSCoder*)encoder {
}

- (id)initWithCoder:(NSCoder*)decoder {
	return self;
}

#pragma mark -
#pragma mark NSCopying protocol

- (id)copyWithZone:(NSZone *)zone {
	return [self retain];
}

#pragma mark -
#pragma mark packet data operation

//
// get body data, not encrypted, some packet need this, such as
// login packet needs body of SelectServerPacket
//
- (NSData*)plainBody {
	// create byte buffer
	char* buffer = (char*)[m_buf mutableBytes];
	ByteBuffer* bb = [ByteBuffer bufferWithBytes:buffer length:[m_buf length]];
	
	// fill body
	[self fillBody:bb];
	
	// create data object
	return [NSData dataWithBytes:buffer length:[bb position]];
}

//
// Get plain data with packet field filled
//
- (NSData*)plain {
	// create byte buffer
	char* buffer = (char*)[m_buf mutableBytes];
	ByteBuffer* bb = [ByteBuffer bufferWithBytes:buffer length:[m_buf length]];
	
	// fill header
	[self fillHeader:bb];
	int bodyOffset = [bb position];
	
	// fill body
	[self fillBody:bb];
	int tailOffset = [bb position];
	m_bodyLength = tailOffset - bodyOffset;
	
	// fill tail
	[self fillTail:bb];
	
	// call postFill
	int current = [bb position];
	[self postFill:bb bodyOffset:bodyOffset tailOffset:tailOffset];
	[bb setPosition:current];
	
	// create data object
	NSData* data = [NSData dataWithBytes:buffer length:[bb position]];
	
	// output for debug
	if([m_user isDebugging]) {
		DebugEvent* event = [[DebugEvent alloc] initWithId:kDebugEventOutcomingPacket
													packet:self
													  data:data];
		[m_user deliveryDebugEvent:event];
		[event release];
	}
	
	return data;
}

- (NSData*)encrypted {
	// create byte buffer
	char* buffer = (char*)[m_buf mutableBytes];
	ByteBuffer* bb = [ByteBuffer bufferWithBytes:buffer length:[m_buf length]];
	
	// fill header
	[self fillHeader:bb];
	int bodyOffset = [bb position];
	
	// fill body
	[self fillBody:bb];
	int tailOffset = [bb position];
	m_bodyLength = tailOffset - bodyOffset;
	
	// encrypt if encrypt key is not nil
	if([self getEncryptKey]) {
		NSData* needEncrypt = [bb dataOfRange:NSMakeRange([self getEncryptStart], [self getEncryptLength])];
		NSData* encrypted = [needEncrypt QQEncrypt:[self getEncryptKey]];
		
		// put encrypt data back
		[bb setPosition:[self getEncryptStart]];
		[bb writeBytes:encrypted];
		tailOffset = [bb position];
	}
	
	// fill tail
	[self fillTail:bb];
	
	// call postFill
	int current = [bb position];
	[self postFill:bb bodyOffset:bodyOffset tailOffset:tailOffset];
	[bb setPosition:current];
	
	// create data object
	NSData* data = [NSData dataWithBytes:buffer length:[bb position]];
	
	// output for debug
	if([m_user isDebugging])
		[self plain];	
	
	return data;
}

- (void)fillHeader:(ByteBuffer*)buf {	
}

- (void)fillBody:(ByteBuffer*)buf {	
}

- (void)fillTail:(ByteBuffer*)buf {	
}

- (void)postFill:(ByteBuffer*)buf bodyOffset:(int)bodyOffset tailOffset:(int)tailOffset {
}

- (void)parseHeader:(ByteBuffer*)buf {
}

- (void)parseBody:(ByteBuffer*)buf {
}

- (void)parseTail:(ByteBuffer*)buf {
}

- (int)getInPacketHeaderLength {
	// use basic in packet header length as default
	return 7;
}

- (int)getInPacketTailLength {
	// use basic in packet tail length as default
	return 1;
}

- (BOOL)isSystemMessage {
	return NO;
}

- (BOOL)isClusterMessage {
	return NO;
}

- (id)packetOwner {
	return [NSNumber numberWithUnsignedInt:10000];
}

- (BOOL)validate:(NSData*)encryptedData {
	return YES;
}

#pragma mark -
#pragma mark encrypt and decrypt setter

- (int)getEncryptStart {
	return 0;
}

- (int)getEncryptLength {
	return -1;
}

- (int)getDecryptStart:(NSData*)data {
	return 0;
}

- (int)getDecryptLength:(NSData*)data {
	return -1;
}

- (NSData*)getEncryptKey {
	return m_encryptKey ? m_encryptKey : [m_user sessionKey];
}

- (NSData*)getDecryptKey {
	return m_decryptKey ? m_decryptKey : [m_user sessionKey];
}

- (NSData*)getFallbackDecryptKey {
	return [m_user passwordKey];
}

#pragma mark -
#pragma mark subclass must override

- (int)family {
	return kQQFamilyUnknown;
}

#pragma mark -
#pragma mark setter and getter

- (UInt16)version {
	return m_version;
}

- (UInt16)command {
	return m_command;
}

- (void)setCommand:(UInt16)command {
	m_command = command;
}

- (UInt16)sequence {
	return m_sequence;
}

- (void)setSequence:(UInt16)sequence {
	m_sequence = sequence;
}

- (char)header {
	return m_header;
}

- (char)tail {
	return m_tail;
}

- (void)setConnectionId:(NSNumber*)connId {
	[connId retain];
	[m_connId release];
	m_connId = connId;
}

- (NSNumber*)connectionId {
	return m_connId;
}

- (QQUser*)user {
	return m_user;
}

@end
