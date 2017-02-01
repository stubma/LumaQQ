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
// user qq number, 4 bytes
// flag indicate who can modify my name card, 4 bytes
// length of name, 1 byte
// name
// gender index, 1 byte, start from 0, 'male', 'female', '-'
// length of phone, 1 byte
// phone
// length of email, 1 byte
// email
// length of remark, 1 byte
// remark
// --- encrypt end ---
// tail

@interface ClusterModifyCardPacket : ClusterCommandPacket {
	BOOL m_allowAdminModify;
	NSString* m_name;
	NSString* m_phone;
	NSString* m_email;
	NSString* m_remark;
	int m_genderIndex;
}

// getter and setter
- (BOOL)allowAdminModify;
- (void)setAllowAdminModify:(BOOL)flag;
- (NSString*)name;
- (void)setName:(NSString*)name;
- (NSString*)phone;
- (void)setPhone:(NSString*)phone;
- (NSString*)email;
- (void)setEmail:(NSString*)email;
- (NSString*)remark;
- (void)setRemark:(NSString*)remark;
- (int)genderIndex;
- (void)setGenderIndex:(int)genderIndex;

@end
