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

/*
 * FontStyle is used in IM related packets.
 * It is always put to the end of packet
 */

// font flag, 2 bytes, known bits are:
//			bit0 ~ bit4 => font size, so the max size is 32
// 			bit5 => nonzero means bold
//			bit6 => nonzero means italic
//			bit7 => nonzero means underline
// red of font color, 1 byte
// green of font color, 1 byte
// blue of font color, 1 byte
// unknown 1 byte
// message encoding, 2 bytes
// font name, variable length
// length of font style structure, 1 byte

@interface FontStyle : NSObject <NSCoding> {
	UInt16 m_flag;
	UInt8 m_red;
	UInt8 m_green;
	UInt8 m_blue;
	UInt16 m_encoding;
	NSString* m_fontName;
	UInt8 m_length;
}

+ (FontStyle*)defaultStyle;
+ (FontStyle*)styleWithSize:(int)size;
+ (FontStyle*)styleWithColor:(NSColor*)color;
+ (FontStyle*)styleWithSize:(int)size color:(NSColor*)color;
+ (FontStyle*)styleWithSize:(int)size bold:(BOOL)bold italic:(BOOL)italic underline:(BOOL)underline;
+ (FontStyle*)styleWithSize:(int)size bold:(BOOL)bold italic:(BOOL)italic underline:(BOOL)underline color:(NSColor*)color;

- (void)read:(ByteBuffer*)buf;
- (void)write:(ByteBuffer*)buf;

// helper
- (BOOL)bold;
- (BOOL)italic;
- (BOOL)underline;
- (int)fontSize;
- (NSColor*)fontColor;
- (void)checkFontSize;
- (int)byteCount;

// getter and setter
- (UInt16)flag;
- (UInt8)red;
- (UInt8)green;
- (UInt8)blue;
- (UInt16)encoding;
- (NSString*)fontName;
- (void)setFontSize:(int)size;
- (void)setBold:(BOOL)flag;
- (void)setItalic:(BOOL)flag;
- (void)setUnderline:(BOOL)flag;
- (void)setColor:(NSColor*)color;
- (void)setFontName:(NSString*)fontName;

@end
