/*
 * LumaQQ - Cross platform QQ client, special edition for iPhone
 *
 * Copyright (C) 2007 luma <stubma@163.com>
 *
 * This program is free software you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

#import "NSColor.h"


@implementation NSColor

+ (NSColor*)blackColor {
	return [NSColor colorWithCalibratedRed:0.0
									 green:0.0
									  blue:0.0
									 alpha:1.0];
}

+ (NSColor*)colorWithCalibratedRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha {
	NSColor* color = [[NSColor alloc] init];
	[color _setRed:red];
	[color _setGreen:green];
	[color _setBlue:blue];
	[color _setAlpha:alpha];
	return [color autorelease];
}

- (float)redComponent {
	return _red;
}

- (float)greenComponent {
	return _green;
}

- (float)blueComponent {
	return _blue;
}

- (void)_setRed:(float)red {
	_red = red;
}

- (void)_setGreen:(float)green {
	_green = green;
}

- (void)_setBlue:(float)blue {
	_blue = blue;
}

- (void)_setAlpha:(float)alpha {
	_alpha = alpha;
}

@end
