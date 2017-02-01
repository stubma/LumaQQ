/*
 * LumaQQ - Cross platform QQ client, special edition for iPhone
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

#import "SystemIMCell.h"
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/NSString-UIStringDrawing.h>
#import "Constants.h"

static const float HSPACING = 5.0f;
static const float VSPACING = 5.0f;
static const float ICON_HEIGHT = 60.0f;
static const float ICON_WIDTH = 60.0f;

const float SYSTEM_IM_CELL_HEIGHT = 70.0f;

extern Theme gTheme;

@implementation SystemIMCell

- (void) dealloc {
	[_properties release];
	[super dealloc];
}

- (void)setProperties:(NSDictionary*)properties {
	[properties retain];
	[_properties release];
	_properties = properties;
}

- (void)drawRect:(CGRect)rect {
	if(rect.size.height <= 0)
		return;
	
	// create bg color
	CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGColorRef bgColor;
	if([self isSelected])
		bgColor = CGColorCreate(colorSpace, gTheme.systemSelectedBg);
	else
		bgColor = CGColorCreate(colorSpace, gTheme.systemBg);
	CGColorSpaceRelease(colorSpace);
	
	// draw bg
	CGContextRef context = UICurrentContext();
	CGContextSetFillColorWithColor(context, bgColor);
	CGContextFillRect(context, rect);
	CGColorRelease(bgColor);
	
	// draw separator
	[self drawSeparatorInRect:rect];
	
	// get message
	NSString* msg = [_properties objectForKey:kChatLogKeyMessage];
	
	// draw icon
	float x = HSPACING;
	float y = VSPACING;
	UIImage* icon = [UIImage imageNamed:kImageOnlineIcon];
	CGSize iconSize = [icon size];
	[icon compositeToRect:CGRectMake(x, y, ICON_WIDTH, ICON_HEIGHT)
				 fromRect:CGRectMake(0.0f, 0.0f, iconSize.width, iconSize.height)
				operation:NSCompositeSourceOver
				 fraction:1.0f];
	x += ICON_WIDTH + HSPACING;
	
	// get msg rect
	CGRect maxMsgRect = CGRectMake(x, y, rect.origin.x + rect.size.width - x - 10.0f, iconSize.height);
	
	// get msg size
	GSFontRef msgFont = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 14.0f);
	
	// set text color
	CGContextSetStrokeColor(context, gTheme.systemIMTextFg);
	CGContextSetFillColor(context, gTheme.systemIMTextFg);
	
	// draw message
	[msg drawInRect:maxMsgRect withFont:msgFont];
	
	// release
	CFRelease(msgFont);
}

@end
