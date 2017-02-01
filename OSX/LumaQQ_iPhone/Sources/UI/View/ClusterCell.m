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
#import "Constants.h"
#import "ClusterCell.h"

const float CLUSTER_CELL_HEIGHT = 44.0f;

extern Theme gTheme;

@implementation ClusterCell

- (void) dealloc {
	[_cluster release];
	[super dealloc];
}

- (void)setCluster:(Cluster*)cluster {
	[cluster retain];
	[_cluster release];
	_cluster = cluster;
}

- (Cluster*)cluster {
	return _cluster;
}

- (id)object {
	return _cluster;
}

- (MessageManager*)messageManager {
	return _messageManager;
}

- (void)setMessageManager:(MessageManager*)mm {
	_messageManager = mm;
}

- (void)drawRect:(CGRect)rect {
	// 0 means this is not visible
	if(rect.size.height <= 0)
		return;
	
	// create color
	CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGColorRef bgColor;
	if([self isSelected])
		bgColor = CGColorCreate(colorSpace, gTheme.clusterSelectedBg);
	else
		bgColor = CGColorCreate(colorSpace, gTheme.clusterBg);
	CGColorSpaceRelease(colorSpace);
	
	// draw bg
	CGContextRef context = UICurrentContext();
	CGContextSetFillColorWithColor(context, bgColor);
	CGContextFillRect(context, rect);
	CGColorRelease(bgColor);
	
	// draw separator
	[self drawSeparatorInRect:rect];
	
	// draw expand/collapse flag
	int x = rect.origin.x;
	UIImage* image = [UIImage imageNamed:([_cluster expanded] ? kImageExpand : kImageCollapse)];
	CGSize size = [image size];
	int y = (rect.size.height - size.height) / 2;
	_expandBound.size = size;
	_expandBound.origin.x = x + y;
	_expandBound.origin.y = rect.origin.y + y;
	[image compositeToPoint:_expandBound.origin operation:NSCompositeSourceOver];
	x += y;
	x += size.width;
	
	// draw cluster image
	image = [UIImage imageNamed:kImageCluster];
	size = [image size];
	y = (rect.size.height - size.height) / 2;
	[image compositeToPoint:CGPointMake(x, y) operation:NSCompositeSourceOver];
	x += size.width;
	x += y;
	
	// set text color
	if([[_cluster info] isAdvanced]) {
		CGContextSetStrokeColor(context, gTheme.advancedClusterTextFg);
		CGContextSetFillColor(context, gTheme.advancedClusterTextFg);
	} else {
		CGContextSetStrokeColor(context, gTheme.clusterTextFg);
		CGContextSetFillColor(context, gTheme.clusterTextFg);
	}

	// draw name
	GSFontRef font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 20.0f);
	NSString* name = [_cluster displayName];
	int msgCount = [_messageManager clusterMessageCount:_cluster];
	if([_cluster messageSetting] == kQQClusterMessageDisplayCount && msgCount > 0)
		name = [NSString stringWithFormat:@"%@ (%u %@)", name, msgCount, L(@"Unread")];
	size = [name sizeInRect:rect withFont:font];
	[name drawAtPoint:CGPointMake(x, (rect.size.height - size.height) / 2) withFont:font];
	CFRelease(font);
}

- (void)mouseDown:(GSEventRef)event {	
	[super mouseDown:event];
	
	// get point relative to cell
	CGRect rect = GSEventGetLocationInWindow(event);
	CGPoint point = [self convertPoint:rect.origin fromView:nil];
	
	// if point is in expand bound
	if(CGRectContainsPoint(_expandBound, point)) {
		[_cluster setExpanded:![_cluster expanded]];
		
		// trigger notification
		[[NSNotificationCenter defaultCenter] postNotificationName:kClusterExpandStatusChangedNotificationName
															object:_cluster];
		
		// refresh ui
		[self setNeedsDisplay];
	}
}

@end
