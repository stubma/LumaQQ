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
#import "ClusterCommandPacket.h"

///////// format 0x01 ////////////
// header
// --- encrypt start (session key) ---
// sub command, 1 byte
// internal id, 4 bytes
// sub sub command, 1 byte, 0x01, means request
// length of auth info, 2 bytes
// auth info, get it from request im packet, see also ReceivedIMPacket
// receiver qq number, 4 bytes, no use for cluster auth, so all zero here
// length of message, 1 byte
// message
// --- encrypt end ---
// tail

///////// format 0x02 /////////
// header
// --- encrypt start (session key) ---
// sub command, 1 byte
// internal id, 4 bytes
// sub sub command, 1 byte, 0x02, means approve
// receiver qq number, 4 bytes
// length of message, 1 byte, no use for this packet, so 0x01 here
// message, no use for this packet, so 0x2D here, means string "-"
// length of auth info, 2 bytes
// auth info, get it from request im packet
// --- encrypt end ---
// tail

///////// format 0x03 /////////
// header
// --- encrypt start (session key) ---
// sub command, 1 byte
// internal id, 4 bytes
// sub sub command, 1 byte, 0x03, means reject
// receiver qq number, 4 bytes
// length of message, 1 byte
// message
// length of auth info, 2 bytes
// auth info, get it from request im packet
// --- encrypt end ---
// tail

@interface ClusterAuthorizePacket : ClusterCommandPacket {
	NSData* m_authInfo;
	UInt32 m_receiver;
	NSString* m_message;
}

// getter and setter
- (NSData*)authInfo;
- (void)setAuthInfo:(NSData*)authInfo;
- (UInt32)receiver;
- (void)setReceiver:(UInt32)receiver;
- (NSString*)message;
- (void)setMessage:(NSString*)message;

@end
