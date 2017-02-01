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

#import "HeadControl.h"


@implementation HeadControl

+ (void)initialize {
    if (self == [HeadControl class]) {		// Do it once
        [self setCellClass: [HeadCell class]];
    }
}

+ (Class)cellClass {
    return [HeadCell class];
}

#pragma mark -
#pragma mark getter and setter

- (UInt16)head {
	return [[self cell] head];
}

- (char)status {
	return [(HeadCell*)[self cell] status];
}

- (void)setHead:(UInt16)head {
	[[self cell] setHead:head];
}

- (void)setStatus:(char)status {
	[[self cell] setStatus:status];
}

- (void)setObjectValue:(id)object {
	[[self cell] setObjectValue:object];
}

- (BOOL)showStatus {
	return [[self cell] showStatus];
}

- (void)setShowStatus:(BOOL)showStatus {
	[[self cell] setShowStatus:showStatus];
}

- (NSImage*)image {
	return [[self cell] image];
}

- (void)setImage:(NSImage*)image {
	[[self cell] setImage:image];
}

- (void)setOwner:(UInt32)owner {
	[[self cell] setOwner:owner];
}

@end
