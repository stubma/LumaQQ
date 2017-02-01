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

#import "ClusterNotification.h"
#import "QQConstants.h"

#define _kKeyExternalId @"ClusterNotification_ExternalId"
#define _kKeyRootCause @"ClusterNotification_RootCause"
#define _kKeySourceQQ @"ClusterNotification_SourceQQ"
#define _kKeyDestQQ @"ClusterNotification_DestQQ"
#define _kKeyMessage @"ClusterNotification_Message"

@implementation ClusterNotification

- (void) dealloc {
	[m_message release];
	[m_roleString release];
	[m_authInfo release];
	[m_unknownToken release];
	
	[super dealloc];
}

- (void)read0021:(ByteBuffer*)buf {
	m_externalId = [buf getUInt32];
	m_clusterType = [buf getByte];
	m_sourceQQ = [buf getUInt32];
	m_rootCause = [buf getByte];
	m_destQQ = [buf getUInt32];
	
	int len = [buf getByte] & 0xFF;
	m_roleString = [[buf getString:len] retain];
	
	len = [buf getUInt16];
	m_unknownToken = [[NSMutableData dataWithLength:len] retain];
	[buf getBytes:(NSMutableData*)m_unknownToken];
}

- (void)read0022:(ByteBuffer*)buf {
	m_externalId = [buf getUInt32];
	m_clusterType = [buf getByte];
	m_sourceQQ = [buf getUInt32];
	m_rootCause = [buf getByte];
	
	switch(m_rootCause) {
		case kQQExitClusterActive:
		case kQQExitClusterDismissed:
		{
			int len = [buf getUInt16];
			m_unknownToken = [[NSMutableData dataWithLength:len] retain];
			[buf getBytes:(NSMutableData*)m_unknownToken];
			break;
		}
		case kQQExitClusterPassive:
		{
			m_destQQ = [buf getUInt32];
			int len = [buf getByte] & 0xFF;
			m_roleString = [[buf getString:len] retain];
			len = [buf getUInt16];
			m_unknownToken = [[NSMutableData dataWithLength:len] retain];
			[buf getBytes:(NSMutableData*)m_unknownToken];
			break;
		}
	}
}

- (void)read0023:(ByteBuffer*)buf {
	m_externalId = [buf getUInt32];
	m_clusterType = [buf getByte];
	m_sourceQQ = [buf getUInt32];
	
	int len = [buf getByte] & 0xFF;
	m_message = [[buf getString:len] retain];
	
	len = [buf getUInt16];
	m_unknownToken = [[NSMutableData dataWithLength:len] retain];
	[buf getBytes:(NSMutableData*)m_unknownToken];
	
	len = [buf getUInt16];
	m_authInfo = [[NSMutableData dataWithLength:len] retain];
	[buf getBytes:(NSMutableData*)m_authInfo];
}

- (void)read0024:(ByteBuffer*)buf {
	m_externalId = [buf getUInt32];
	m_clusterType = [buf getByte];
	m_sourceQQ = [buf getUInt32];
	
	int len = [buf getByte] & 0xFF;
	m_message = [[buf getString:len] retain];
	
	len = [buf getUInt16];
	m_unknownToken = [[NSMutableData dataWithLength:len] retain];
	[buf getBytes:(NSMutableData*)m_unknownToken];
}

- (void)read0025:(ByteBuffer*)buf {
	m_externalId = [buf getUInt32];
	m_clusterType = [buf getByte];
	m_sourceQQ = [buf getUInt32];
	
	int len = [buf getByte] & 0xFF;
	m_message = [[buf getString:len] retain];
	
	len = [buf getUInt16];
	m_unknownToken = [[NSMutableData dataWithLength:len] retain];
	[buf getBytes:(NSMutableData*)m_unknownToken];
}

- (void)read0026:(ByteBuffer*)buf {
	m_externalId = [buf getUInt32];
	m_clusterType = [buf getByte];
	m_sourceQQ = [buf getUInt32];
	
	int len = [buf getUInt16];
	m_unknownToken = [[NSMutableData dataWithLength:len] retain];
	[buf getBytes:(NSMutableData*)m_unknownToken];
}

- (void)read002C:(ByteBuffer*)buf {
	m_externalId = [buf getUInt32];
	m_clusterType = [buf getByte];
	m_rootCause = [buf getByte];
	
	switch(m_rootCause & 0xFF) {
		case kQQClusterAdminRoleSet:
		case kQQClusterAdminRoleUnset:
			m_sourceQQ = [buf getUInt32];
			m_role = [buf getByte];
			break;
		case (kQQClusterOwnerRoleSet & 0xFF):
			m_sourceQQ = [buf getUInt32];
			m_destQQ = [buf getUInt32];
			break;
	}
}

#pragma mark -
#pragma mark NSCoding protocol

- (void)encodeWithCoder:(NSCoder*)encoder {
	[encoder encodeInt32:m_externalId forKey:_kKeyExternalId];
	[encoder encodeInt:m_rootCause forKey:_kKeyRootCause];
	[encoder encodeInt32:m_sourceQQ forKey:_kKeySourceQQ];
	[encoder encodeInt32:m_destQQ forKey:_kKeyDestQQ];
	[encoder encodeObject:m_message forKey:_kKeyMessage];
}

- (id)initWithCoder:(NSCoder*)decoder {
	m_externalId = [decoder decodeInt32ForKey:_kKeyExternalId];
	m_rootCause = [decoder decodeInt32ForKey:_kKeyRootCause];
	m_sourceQQ = [decoder decodeInt32ForKey:_kKeySourceQQ];
	m_destQQ = [decoder decodeInt32ForKey:_kKeyDestQQ];
	m_message = [[decoder decodeObjectForKey:_kKeyMessage] retain];
	return self;
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)externalId {
	return m_externalId;
}

- (char)clusterType {
	return m_clusterType;
}

- (char)rootCause {
	return m_rootCause;
}

- (NSData*)authInfo {
	return m_authInfo;
}

- (NSData*)unknownToken {
	return m_unknownToken;
}

- (UInt32)sourceQQ {
	return m_sourceQQ;
}

- (UInt32)destQQ {
	return m_destQQ;
}

- (char)role {
	return m_role;
}

- (NSString*)roleString {
	return m_roleString;
}

- (NSString*)message {
	return m_message;
}

@end
