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

@interface ClusterNotification : NSObject <NSCoding> {
	UInt32 m_externalId;
	char m_clusterType;
	char m_rootCause;
	NSData* m_authInfo;
	NSData* m_unknownToken;
	
	UInt32 m_sourceQQ;
	UInt32 m_destQQ;
	
	char m_role;
	NSString* m_roleString;
	NSString* m_message;
}

- (void)read0021:(ByteBuffer*)buf;
- (void)read0022:(ByteBuffer*)buf;
- (void)read0023:(ByteBuffer*)buf;
- (void)read0024:(ByteBuffer*)buf;
- (void)read0025:(ByteBuffer*)buf;
- (void)read0026:(ByteBuffer*)buf;
- (void)read002C:(ByteBuffer*)buf;

// getter and setter
- (UInt32)externalId;
- (char)clusterType;
- (char)rootCause;
- (NSData*)authInfo;
- (NSData*)unknownToken;
- (UInt32)sourceQQ;
- (UInt32)destQQ;
- (char)role;
- (NSString*)roleString;
- (NSString*)message;

@end
