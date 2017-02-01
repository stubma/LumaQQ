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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 0 2111-1307 USA
 */

#import <Cocoa/Cocoa.h>

#define kHeadUseImage 0xFFFF

@interface HeadCell : NSActionCell {
	UInt16 m_head;
	UInt32 m_owner;
	char m_status;
	BOOL m_showStatus;
	NSImage* m_image; // if head is kHeadUseImage, use this
}

// drawing routine
- (void)drawDecoration:(NSImage*)image headRect:(NSRect)headRect;

// getter and setter
- (UInt16)head;
- (char)status;
- (void)setHead:(UInt16)head;
- (void)setStatus:(char)status;
- (BOOL)showStatus;
- (void)setShowStatus:(BOOL)showStatus;
- (NSImage*)image;
- (void)setImage:(NSImage*)image;
- (void)setOwner:(UInt32)owner;

@end
