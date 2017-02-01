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

#import <Foundation/Foundation.h>
#import "ClusterCommandPacket.h"

///////// format 1 ////////
// header
// --- encrypt start (session key) ---
// sub command, 1 byte
// internal id, 4 bytes
// cluster type, 1 byte
// cluster auth type, 1 byte
// 2004 category, 4 bytes, unused
// 2005 category, 4 bytes
// length of name, 1 byte
// name
// unknown 2 bytes
// length of notice, 1 byte
// notice
// length of description, 1 byte
// description
// --- encrypt end ---
// tail

@interface ClusterModifyInfoPacket : ClusterCommandPacket {
	char m_authType;
	UInt32 m_category;
	NSString* m_name;
	NSString* m_notice;
	NSString* m_description;
}

// getter and setter
- (char)authType;
- (void)setAuthType:(char)authType;
- (UInt32)category;
- (void)setCategory:(UInt32)category;
- (NSString*)name;
- (void)setName:(NSString*)name;
- (NSString*)notice;
- (void)setNotice:(NSString*)notice;
- (NSString*)description;
- (void)setDescription:(NSString*)desc;

@end
