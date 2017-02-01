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
#import "BasicInPacket.h"

////////// format 0x03 /////////
// header
// ---- encrypt start (session key) ------
// sub command string format, "03", means other approve my request
// separator, 1 byte, 0x1F
// source qq number string
// separator, 1 byte, 0x1F
// dest qq number string
// separator, 1 byte, 0x1F
// message, because approve desn't have message, here is "0"
// separator, 1 byte, 0x1F
// unknown id length, 2 bytes
// unknown id
// ---- encrypt end ---
// tail

////////// format 0x04 ////////////
// header
// ---- encrypt start (session key) -----
// sub command string format, "04", means other reject my request
// separator, 1 byte, 0x1F
// source qq number string
// separator, 1 byte, 0x1F
// dest qq number string
// separator, 1 byte, 0x1F
// message
// separator, 1 byte, 0x1F
// length of unknown id, 2 bytes
// unknown id
// ---- encrypt end ----
// tail

////////// format 0x40 ////////////
// header
// ---- encrypt start (session key) -----
// sub command string format, "40", means I am added by other
// separator, 1 byte, 0x1F
// source qq number string
// separator, 1 byte, 0x1F
// dest qq number string
// separator, 1 byte, 0x1F
// length of unknown token, 1 byte
// unknown token
// length of unknown id, 2 bytes
// unknown id
// ---- encrypt end ----
// tail

////////// format 0x41 ////////////
// header
// ---- encrypt start (session key) -----
// sub command string format, "41", means other request add me
// separator, 1 byte, 0x1F
// source qq number string
// separator, 1 byte, 0x1F
// dest qq number string
// separator, 1 byte, 0x1F
// length of message, 1 byte
// message
// flag indicates whether allow me add other, 1 byte, 0x01 means yes, 0x02 means no
// length of unknown id, 2 bytes
// unknown id
// ---- encrypt end ----
// tail

////////// format 0x43 ////////////
// header
// ---- encrypt start (session key) -----
// sub command string format, "43", means other approve my request and add me
// separator, 1 byte, 0x1F
// source qq number string
// separator, 1 byte, 0x1F
// dest qq number string
// separator, 1 byte, 0x1F
// length of message, 1 byte
// message
// unknown 1 byte
// length of unknown id, 2 bytes
// unknonw id
// ---- encrypt end ----
// tail

@interface SystemNotificationPacket : BasicInPacket {
	UInt32 m_sourceQQ;
	UInt32 m_destQQ;
	NSString* m_message;
	NSData* m_unknownId;
	NSData* m_unknownToken;	
	BOOL m_allowAddReverse;
}

// getter and setter
- (UInt32)sourceQQ;
- (UInt32)destQQ;
- (NSString*)message;
- (NSData*)unknownId;
- (NSData*)unknownToken;
- (BOOL)allowAddReverse;

@end
