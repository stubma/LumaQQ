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

#import "SignatureOpPacket.h"
#import "Signature.h"
#import "ByteTool.h"

@implementation SignatureOpPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandSignatureOp;
		m_subCommand = kQQSubCommandGetSignature;
		m_friends = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_friends release];
	[m_authInfo release];
	[super dealloc];
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeByte:m_subCommand];
	switch(m_subCommand) {
		case kQQSubCommandDeleteSignature:
			[buf writeByte:[m_authInfo length]];
			[buf writeBytes:m_authInfo];
			break;
		case kQQSubCommandModifySignature:
			[buf writeByte:[m_authInfo length]];
			[buf writeBytes:m_authInfo];
			
			[buf writeByte:0];
			NSData* bytes = [ByteTool getBytes:m_signature];
			[buf writeByte:[bytes length]];
			[buf writeBytes:bytes];
			break;
		case kQQSubCommandGetSignature:
			[buf writeByte:0];
			[buf writeByte:[m_friends count]];
			NSEnumerator* e = [m_friends objectEnumerator];
			Signature* sig = nil;
			while(sig = [e nextObject]) {
				[buf writeUInt32:[sig QQ]];
				[buf writeUInt32:[sig lastModifiedTime]];
			}
			break;
	}
}

#pragma mark -
#pragma mark getter and setter

- (NSString*)signature {
	return m_signature;
}

- (void)setSignature:(NSString*)signature {
	[signature retain];
	[m_signature release];
	m_signature = signature;
}

- (NSArray*)friends {
	return m_friends;
}

- (void)addFriends:(NSArray*)friends {
	[m_friends addObjectsFromArray:friends];
}

- (void)addFriend:(UInt32)QQ {
	Signature* sig = [[Signature alloc] init];
	[sig setQQ:QQ];
	[sig setLastModifiedTime:0];
	[m_friends addObject:sig];
	[sig release];
}

- (NSData*)authInfo {
	return m_authInfo;
}

- (void)setAuthInfo:(NSData*)authInfo {
	[authInfo retain];
	[m_authInfo release];
	m_authInfo = authInfo;
}

@end
