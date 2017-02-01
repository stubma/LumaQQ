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

#import "FontStyle.h"
#import "ByteTool.h"
#import "QQConstants.h"

#define _kFontStyleBold 0x20
#define _kFontStyleItalic 0x40
#define _kFontStyleUnderline 0x80

#define _kKeyFlag @"FontStyle_Flag"
#define _kKeyRed @"FontStyle_Red"
#define _kKeyGreen @"FontStyle_Green"
#define _kKeyBlue @"FontStyle_Blue"
#define _kKeyEncoding @"FontStyle_Encoding"
#define _kKeyFontName @"FontStyle_FontName"

static const char s_songTi[] = {
	0xCB, 0xCE, 0xCC, 0xE5 // song ti
};

@implementation FontStyle

+ (FontStyle*)defaultStyle {
	FontStyle* style = [[FontStyle alloc] init];
	return [style autorelease];
}

+ (FontStyle*)styleWithSize:(int)size {
	return [FontStyle styleWithSize:size color:[NSColor blackColor]];
}

+ (FontStyle*)styleWithColor:(NSColor*)color {
	return [FontStyle styleWithSize:[NSFont systemFontSize] color:color];
}

+ (FontStyle*)styleWithSize:(int)size color:(NSColor*)color {
	FontStyle* style = [[FontStyle alloc] init];
	[style setFontSize:size];
	[style setColor:color];
	return [style autorelease];
}

+ (FontStyle*)styleWithSize:(int)size bold:(BOOL)bold italic:(BOOL)italic underline:(BOOL)underline {
	return [FontStyle styleWithSize:size bold:bold italic:italic underline:underline color:[NSColor blackColor]];
}

+ (FontStyle*)styleWithSize:(int)size bold:(BOOL)bold italic:(BOOL)italic underline:(BOOL)underline color:(NSColor*)color {
	FontStyle* style = [[FontStyle alloc] init];
	[style setFontSize:size];
	[style setBold:bold];
	[style setItalic:italic];
	[style setUnderline:underline];
	[style setColor:color];
	return [style autorelease];
}

- (id) init {
	self = [super init];
	if (self != nil) {
		m_flag = 0;
		[self setFontSize:[NSFont systemFontSize]];
		m_red = m_green = m_blue = 0;
		m_fontName = (NSString*)CFStringCreateWithBytes(kCFAllocatorDefault,
														(const UInt8*)s_songTi,
														4,
														kCFStringEncodingGB_18030_2000,
														TRUE);
		m_encoding = kQQEncodingDefault;
	}
	return self;
}

- (void) dealloc {
	[m_fontName release];
	[super dealloc];
}

- (void)read:(ByteBuffer*)buf {
	m_flag = [buf getUInt16];
	m_red = [buf getByte] & 0xFF;
	m_green = [buf getByte] & 0xFF;
	m_blue = [buf getByte] & 0xFF;
	[buf skip:1];
	m_encoding = [buf getUInt16];
	m_fontName = [[buf getString:([buf available] - 1)] retain];
	m_length = [buf getByte] & 0xFF;
	
	[self checkFontSize];
}

- (void)write:(ByteBuffer*)buf {
	[buf writeUInt16:m_flag];
	[buf writeByte:m_red];
	[buf writeByte:m_green];
	[buf writeByte:m_blue];
	[buf writeByte:0];
	[buf writeUInt16:m_encoding];
	NSData* data = [ByteTool getBytes:m_fontName];
	[buf writeBytes:data];
	[buf writeByte:(([data length] + 9) & 0xFF)];
}

#pragma mark -
#pragma mark NSCoding protocol

- (void)encodeWithCoder:(NSCoder*)encoder {
	[encoder encodeInt:m_flag forKey:_kKeyFlag];
	[encoder encodeInt:m_red forKey:_kKeyRed];
	[encoder encodeInt:m_green forKey:_kKeyGreen];
	[encoder encodeInt:m_blue forKey:_kKeyBlue];
	[encoder encodeInt:m_encoding forKey:_kKeyEncoding];
	[encoder encodeObject:m_fontName forKey:_kKeyFontName];
}

- (id)initWithCoder:(NSCoder*)decoder {
	m_flag = [decoder decodeIntForKey:_kKeyFlag];
	m_red = [decoder decodeIntForKey:_kKeyRed];
	m_green = [decoder decodeIntForKey:_kKeyGreen];
	m_blue = [decoder decodeIntForKey:_kKeyBlue];
	m_encoding = [decoder decodeIntForKey:_kKeyEncoding];
	m_fontName = [[decoder decodeObjectForKey:_kKeyFontName] retain];
	return self;
}

#pragma mark -
#pragma mark helper

- (int)byteCount {
	NSData* data = [ByteTool getBytes:m_fontName];
	return [data length] + 9;
}

- (BOOL)bold {
	return (m_flag & _kFontStyleBold) != 0;
}

- (BOOL)italic {
	return (m_flag & _kFontStyleItalic) != 0;
}

- (BOOL)underline {
	return (m_flag & _kFontStyleUnderline) != 0;
}

- (int)fontSize {
	return m_flag & 0x001F;
}

- (NSColor*)fontColor {
	return [NSColor colorWithCalibratedRed:(m_red / 255.0)
									 green:(m_green / 255.0)
									  blue:(m_blue / 255.0)
									 alpha:1.0];
}

- (void)checkFontSize {
	int size = m_flag & 0x1F;
	if(size < [NSFont systemFontSize])
		size = [NSFont systemFontSize];
	if(size > 24)
		size = 24;
	m_flag &= 0xE0;
	m_flag |= size;
}

#pragma mark -
#pragma mark getter and setter

- (UInt16)flag {
	return m_flag;
}

- (UInt8)red {
	return m_red;
}

- (UInt8)green {
	return m_green;
}

- (UInt8)blue {
	return m_blue;
}

- (UInt16)encoding {
	return m_encoding;
}

- (NSString*)fontName {
	return m_fontName;
}

- (void)setFontSize:(int)size {
	if(size < [NSFont systemFontSize])
		size = [NSFont systemFontSize];
	if(size > 24)
		size = 24;
	size &= 0x1F;
	m_flag &= 0xE0;
	m_flag |= size;
}

- (void)setBold:(BOOL)flag {
	if(flag)
		m_flag |= _kFontStyleBold;
	else
		m_flag &= ~_kFontStyleBold;
}

- (void)setItalic:(BOOL)flag {
	if(flag)
		m_flag |= _kFontStyleItalic;
	else
		m_flag &= ~_kFontStyleItalic;
}

- (void)setUnderline:(BOOL)flag {
	if(flag)
		m_flag |= _kFontStyleUnderline;
	else
		m_flag &= ~_kFontStyleUnderline;
}

- (void)setColor:(NSColor*)color {
	m_red = [color redComponent] * 255;
	m_green = [color greenComponent] * 255;
	m_blue = [color blueComponent] * 255;
}

- (void)setFontName:(NSString*)fontName {
	[fontName retain];
	[m_fontName release];
	m_fontName = fontName;
}

@end
