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

#import "ClusterIMCell.h"
#import <UIKit/NSString-UIStringDrawing.h>
#import <GraphicsServices/GraphicsServices.h>
#import "Constants.h"
#import "NSString-Validate.h"

const float CLUSTER_IM_CELL_HEIGHT = 64.0f;

static float VSPACING = 5.0f;
static float HSPACING = 5.0f;

extern Theme gTheme;

@implementation ClusterIMCell

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
	
	// draw cluster image
	float x = rect.origin.x;
	UIImage* image = [UIImage imageNamed:kImageCluster];
	CGSize size = [image size];
	float y = VSPACING;
	x += HSPACING;
	[image compositeToPoint:CGPointMake(x, y) operation:NSCompositeSourceOver];
	x += size.width + HSPACING;
	
	//
	// draw cluster name
	//
	
	// get message array
	NSArray* msgArray = [_messageManager clusterMessages:_cluster];
	
	// set text color
	CGContextSetStrokeColor(context, gTheme.clusterIMTextFg);
	CGContextSetFillColor(context, gTheme.clusterIMTextFg);
	
	// draw name
	GSFontRef font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 16.0f);
	size = [[_cluster name] sizeInRect:rect withFont:font];
	[[_cluster name] drawAtPoint:CGPointMake(x, y) withFont:font];
	
	// draw unread hint
	CGContextSetStrokeColor(context, gTheme.unreadHintFg);
	CGContextSetFillColor(context, gTheme.unreadHintFg);
	NSString* unreadHint = [NSString stringWithFormat:@"(%u %@)", [msgArray count], L(@"Unread")];
	[unreadHint drawAtPoint:CGPointMake(x + size.width + HSPACING, y) withFont:font];
	
	// adjust y
	y += size.height + VSPACING;
	
	if([msgArray count] > 0) {
		// get first packet
		NSDictionary* properties = [msgArray objectAtIndex:0];
		
		NSString* msg = [properties objectForKey:kChatLogKeyMessage];
		if(![msg isEmpty]) {			
			// set signature text color
			if([self isSelected]) {
				CGContextSetStrokeColor(context, gTheme.clusterBg);
				CGContextSetFillColor(context, gTheme.clusterBg);
			} else {
				CGContextSetStrokeColor(context, gTheme.messageTextFg);
				CGContextSetFillColor(context, gTheme.messageTextFg);
			}
			
			// draw, 10 is a adjust to make sure all text is in the bound
			CGRect drawRect;
			drawRect.origin.x = x;
			drawRect.origin.y = y;
			drawRect.size.width = rect.size.width + rect.origin.x - drawRect.origin.x - HSPACING - 10;
			drawRect.size.height = rect.size.height + rect.origin.y - drawRect.origin.y - VSPACING;
			[msg drawInRect:drawRect withFont:font];
		}	
	}
	
	// release
	CFRelease(font);
}

@end
