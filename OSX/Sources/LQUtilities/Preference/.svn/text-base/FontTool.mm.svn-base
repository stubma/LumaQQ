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

#import "FontTool.h"
#import "PreferenceCache.h"

@implementation FontTool

+ (FontStyle*)chatFontStyleWithPreference:(UInt32)QQ {
	FontStyle* style = [FontStyle defaultStyle];
	PreferenceCache* cache = [PreferenceCache cache:QQ];
	[style setBold:[cache chatFontStyleBold]];
	[style setItalic:[cache chatFontStyleItalic]];
	[style setUnderline:[cache chatFontStyleUnderline]];
	[style setFontName:[cache chatFontName]];
	[style setFontSize:[cache chatFontSize]];
	[style setColor:[cache chatFontColor]];
	return style;
}

+ (NSFont*)fontWithName:(NSString*)name size:(int)size bold:(BOOL)bold italic:(BOOL)italic {
	NSFontManager* fm = [NSFontManager sharedFontManager];
	NSFont* font = [NSFont fontWithName:@"Lucida Grande" size:size];
	font = [fm convertFont:font toFamily:name];
	if(bold)
		font = [fm convertFont:font toHaveTrait:NSBoldFontMask];
	if(italic)
		font = [fm convertFont:font toHaveTrait:NSItalicFontMask];
	return font;
}

+ (NSFont*)chatFontWithPreference:(UInt32)QQ {
	PreferenceCache* cache = [PreferenceCache cache:QQ];
	return [self fontWithName:[cache chatFontName]
						 size:[cache chatFontSize]
						 bold:[cache chatFontStyleBold]
					   italic:[cache chatFontStyleItalic]];
}

+ (NSFont*)nickFontWithPreference:(UInt32)QQ {
	PreferenceCache* cache = [PreferenceCache cache:QQ];
	return [self fontWithName:[cache nickFontName]
						 size:[cache nickFontSize]
						 bold:[cache nickFontStyleBold]
					   italic:[cache nickFontStyleItalic]];
}

+ (NSFont*)signatureFontWithPreference:(UInt32)QQ {
	PreferenceCache* cache = [PreferenceCache cache:QQ];
	return [self fontWithName:[cache signatureFontName]
						 size:[cache signatureFontSize]
						 bold:[cache signatureFontStyleBold]
					   italic:[cache signatureFontStyleItalic]];
}

+ (NSFont*)fontWithStyle:(FontStyle*)style {
	return [self fontWithName:[style fontName]
						 size:[style fontSize]
						 bold:[style bold]
					   italic:[style italic]];
}

@end
