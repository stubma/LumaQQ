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

#import "Face.h"
#import "Constants.h"

#define _kKeyMd5 @"Md5"
#define _kKeyOriginal @"Original"
#define _kKeyThumbnail @"Thumbnail"
#define _kKeyShortcut @"Shortcut"
#define _kKeyTip @"Tip"
#define _kKeyMultiframe @"Multiframe"
#define _kKeyIndex @"Index"

@implementation Face

- (id) init {
	self = [super init];
	if (self != nil) {
		m_md5 = kStringEmpty;
		m_original = kStringEmpty;
		m_thumbnail = kStringEmpty;
		m_shortcut = kStringEmpty;
		m_tip = kStringEmpty;
		m_multiframe = NO;
		m_index = 0;
		m_groupIndex = -1;
	}
	return self;
}

- (void) dealloc {
	[m_md5 release];
	[m_original release];
	[m_thumbnail release];
	[m_shortcut release];
	[m_tip release];
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:m_md5 forKey:_kKeyMd5];
	[encoder encodeObject:m_original forKey:_kKeyOriginal];
	[encoder encodeObject:m_thumbnail forKey:_kKeyThumbnail];
	[encoder encodeObject:m_shortcut forKey:_kKeyShortcut];
	[encoder encodeObject:m_tip forKey:_kKeyTip];
	[encoder encodeBool:m_multiframe forKey:_kKeyMultiframe];
	[encoder encodeInt:m_index forKey:_kKeyIndex];
}

- (id)initWithCoder:(NSCoder *)decoder {
	m_md5 = [[decoder decodeObjectForKey:_kKeyMd5] retain];
	m_original = [[decoder decodeObjectForKey:_kKeyOriginal] retain];
	m_thumbnail = [[decoder decodeObjectForKey:_kKeyThumbnail] retain];
	m_shortcut = [[decoder decodeObjectForKey:_kKeyShortcut] retain];
	m_tip = [[decoder decodeObjectForKey:_kKeyTip] retain];
	m_multiframe = [decoder decodeBoolForKey:_kKeyMultiframe];
	m_index = [decoder decodeIntForKey:_kKeyIndex];
	
	if(!m_md5)
		m_md5 = kStringEmpty;
	if(!m_original)
		m_original = kStringEmpty;
	if(!m_thumbnail)
		m_thumbnail = kStringEmpty;
	if(!m_shortcut)
		m_shortcut = kStringEmpty;
	if(!m_tip)
		m_tip = kStringEmpty;
	return self;
}

- (NSString*)md5 {
	return m_md5;
}

- (void)setMd5:(NSString*)md5 {
	[md5 retain];
	[m_md5 release];
	m_md5 = md5;
}

- (NSString*)original {
	return m_original;
}

- (void)setOriginal:(NSString*)original {
	[original retain];
	[m_original release];
	m_original = original;
}

- (NSString*)thumbnail {
	return m_thumbnail;
}

- (void)setThumbnail:(NSString*)thumbnail {
	[thumbnail retain];
	[m_thumbnail release];
	m_thumbnail = thumbnail;
}

- (NSString*)shortcut {
	return m_shortcut;
}

- (void)setShortcut:(NSString*)shortcut {
	[shortcut retain];
	[m_shortcut release];
	m_shortcut = shortcut;
}

- (NSString*)tip {
	return m_tip;
}

- (void)setTip:(NSString*)tip {
	[tip retain];
	[m_tip release];
	m_tip = tip;
}

- (BOOL)multiframe {
	return m_multiframe;
}

- (void)setMultiframe:(BOOL)multiframe {
	m_multiframe = multiframe;
}

- (int)index {
	return m_index;
}

- (void)setIndex:(int)index {
	m_index = index;
}

- (int)groupIndex {
	return m_groupIndex;
}

- (void)setGroupIndex:(int)index {
	m_groupIndex = index;
}

@end
