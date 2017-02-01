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
#import "FontStyle.h"
#import "BasicOutPacket.h"

/*
 * Temp session im doesn't support long message and has a length limitation
 * In 2006, must get auth info every time you send a temp session message
 */

//////////// format 0x01 //////////////
// header
// --- encrypt start (session key) ---
// sub command, 1 byte, 0x01, means send temp session im
// receiver qq number, 4 bytes
// temp session auth info length, 2 bytes
// temp session auth info
// unknown 4 bytes
// sender name length, 1 byte
// sender name
// sender site name, 1 byte
// sender site name
// unknown 1 byte, this byte should be 0x01 or 0x02, otherwise receiver can't see your message
// unknown 4 bytes
// length of following data, 2 bytes, exclusive
// message, length can be calculated thru above length and font style length
// FontStyle structure, see Bean/FontStyle.mm for more info
// NOTE: the message and font style can't exceed 700 bytes
// -- encrypt end ---
// tail

@interface TempSessionOpPacket : BasicOutPacket {
	UInt32 m_receiver;
	NSData* m_authInfo;
	NSString* m_senderName;
	NSString* m_senderSite;
	NSData* m_messageData;
	FontStyle* m_fontStyle;
}

- (UInt32)receiver;
- (void)setReceiver:(UInt32)receiver;
- (FontStyle*)fontStyle;
- (void)setFontStyle:(FontStyle*)style;
- (NSData*)messageData;
- (void)setMessageData:(NSData*)data;
- (NSString*)senderName;
- (void)setSenderName:(NSString*)name;
- (NSString*)senderSite;
- (void)setSenderSite:(NSString*)site;
- (NSData*)authInfo;
- (void)setAuthInfo:(NSData*)authInfo;

@end
