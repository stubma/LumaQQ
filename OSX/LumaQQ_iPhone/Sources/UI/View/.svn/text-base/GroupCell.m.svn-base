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

#import <Foundation/Foundation.h>
#import <UIKit/NSString-UIStringDrawing.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UIView-Geometry.h>
#import "GroupCell.h"
#import "Constants.h"

const float GROUP_CELL_HEIGHT = 40.0f;

extern Theme gTheme;

@implementation GroupCell

- (void) dealloc {
	[_group release];
	[super dealloc];
}

- (Group*)group {
	return _group;
}

- (void)setGroup:(Group*)group {
	[group retain];
	[_group release];
	_group = group;
}

- (id)object {
	return _group;
}

- (void)drawRect:(CGRect)rect {
	// 0 means this is not visible
	if(rect.size.height <= 0)
		return;
	
	// draw bg
	UIImage* blueBg = [UIImage imageNamed:kImageGradientBlueBackground];
	CGSize bgSize = [blueBg size];
	[blueBg compositeToRect:rect
				   fromRect:CGRectMake(0.0f, 0.0f, bgSize.width, bgSize.height)
				  operation:NSCompositeSourceOver
				   fraction:1.0f];
	
	// draw separator
	[self drawSeparatorInRect:rect];
	
	// draw expand/collapse flag
	UIImage* image = [UIImage imageNamed:([_group expanded] ? kImageExpand : kImageCollapse)];
	CGSize size = [image size];
	int vGap = (rect.size.height - size.height) / 2;
	_expandBound.size = size;
	_expandBound.origin.x = rect.origin.x + vGap;
	_expandBound.origin.y = rect.origin.y + vGap;
	[image compositeToPoint:_expandBound.origin operation:NSCompositeSourceOver];
	
	// draw name
	GSFontRef font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 20.0f);
	CGSize textSize = [[_group name] sizeInRect:rect withFont:font];
	NSString* s = [NSString stringWithFormat:@"%@ (%d/%d)", [_group name], [_group onlineUserCount], [_group userCount]];
	[s drawAtPoint:CGPointMake(vGap + size.width + vGap, (rect.size.height - textSize.height) / 2) withFont:font];
	CFRelease(font);
}

- (void)mouseDown:(GSEventRef)event {	
	[super mouseDown:event];
	
	// get point relative to cell
	CGRect rect = GSEventGetLocationInWindow(event);
	CGPoint point = [self convertPoint:rect.origin fromView:nil];
	
	// if point is in expand bound
	if(CGRectContainsPoint(_expandBound, point)) {
		[_group setExpanded:![_group expanded]];
		
		// trigger notification
		[[NSNotificationCenter defaultCenter] postNotificationName:kGroupExpandStatusChangedNotificationName
															object:_group];
		
		// refresh ui
		[self setNeedsDisplay];
	}
}

@end
