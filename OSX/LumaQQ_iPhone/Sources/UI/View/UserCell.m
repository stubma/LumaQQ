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

#import <UIKit/UIKit.h>
#import <UIKit/NSString-UIStringDrawing.h>
#import <GraphicsServices/GraphicsServices.h>
#import "UserCell.h"
#import "Constants.h"
#import "PreferenceTool.h"
#import "NSString-Validate.h"

static float VSPACING = 3.0f;
static float HSPACING = 5.0f;
const float USER_CELL_HEIGHT = 64.0f;

extern UInt32 gMyQQ;
extern Theme gTheme;

@implementation UserCell

- (void) dealloc {
	[_user release];
	[_cluster release];
	[super dealloc];
}

- (id) init {
	self = [super init];
	if (self != nil) {
		_memberMode = NO;
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	// 0 means this is not visible
	if(rect.size.height <= 0)
		return;
	
	// save a draw rect
	CGRect drawRect = rect;
	drawRect.size.width = 10000;
	
	// create bg color
	CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGColorRef bgColor;
	if([self isSelected])
		bgColor = CGColorCreate(colorSpace, gTheme.userSelectedBg);
	else
		bgColor = CGColorCreate(colorSpace, gTheme.userBg);
	CGColorSpaceRelease(colorSpace);
	
	// draw bg
	CGContextRef context = UICurrentContext();
	CGContextSetFillColorWithColor(context, bgColor);
	CGContextFillRect(context, rect);
	CGColorRelease(bgColor);
	
	// draw separator
	[self drawSeparatorInRect:rect];
	
	// draw head
	drawRect.origin.x += HSPACING;
	drawRect.origin.y += VSPACING;
	UIImage* head = [_user headWithStatus:YES];
	[head compositeToPoint:drawRect.origin operation:NSCompositeSourceOver];
	CGSize headSize = [head size];
	
	// draw online status icon
	UIImage* decoration = nil;
	switch([_user status]) {
		case kQQStatusQMe:
			decoration = [UIImage imageNamed:kImageQMe];
			break;
		case kQQStatusBusy:
			decoration = [UIImage imageNamed:kImageBusy];
			break;
		case kQQStatusMute:
			decoration = [UIImage imageNamed:kImageMute];
			break;
		case kQQStatusAway:
			decoration = [UIImage imageNamed:kImageAway];
			break;
	}
	CGSize decorationSize = [decoration size];
	[decoration compositeToPoint:CGPointMake(drawRect.origin.x + headSize.width - decorationSize.width, drawRect.origin.y + headSize.height - decorationSize.height) operation:NSCompositeSourceOver];
	
	// adjust origin
	drawRect.origin.x += headSize.width + HSPACING;
	drawRect.origin.y += VSPACING;
	
	//
	// draw name
	//
	
	// set text color
	if([_user isMember]) {
		CGContextSetStrokeColor(context, gTheme.memberTextFg);
		CGContextSetFillColor(context, gTheme.memberTextFg);
	} else {
		CGContextSetStrokeColor(context, gTheme.userTextFg);
		CGContextSetFillColor(context, gTheme.userTextFg);
	}

	// create font
	GSFontRef font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 16.0f);
	
	// draw display name
	NSString* displayName = _memberMode ? [_user memberDisplayName:[_cluster internalId]] : [_user displayName];
	CGSize textSize = [displayName sizeInRect:drawRect withFont:font];
	drawRect.size.height = textSize.height;
	[displayName drawInRect:drawRect withFont:font];
	
	// draw cluster role
	if(_memberMode) {
		// get role image
		UIImage* roleImage = nil;
		if([_user isCreator:_cluster])
			roleImage = [UIImage imageNamed:kImageClusterCreator];
		else if([_user isAdmin:_cluster])
			roleImage = [UIImage imageNamed:kImageClusterAdmin];
		else if([_user isStockholder:_cluster])
			roleImage = [UIImage imageNamed:kImageClusterStockholder];
		
		// draw image
		if(roleImage != nil) {
			CGSize roleSize = [roleImage size];
			[roleImage compositeToPoint:CGPointMake(drawRect.origin.x + textSize.width + HSPACING, drawRect.origin.y + (textSize.height - roleSize.height) / 2.0f)
							  operation:NSCompositeSourceOver];
		}
	}
	
	// adjust draw rect
	drawRect.origin.y += textSize.height + VSPACING;
	
	// draw signature
	PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
	CGSize sigTextSize = {
		0.0f, 0.0f
	};
	NSString* sig = [_user signature];
	if(sig != nil && ![sig isEmpty]) {
		if([tool booleanValue:kPreferenceKeyShowSignature]) {
			// set signature text color
			CGContextSetStrokeColor(context, gTheme.userSigTextFg);
			CGContextSetFillColor(context, gTheme.userSigTextFg);
			
			// draw, 10 is a adjust to make sure all text is in the bound
			drawRect.size.width = rect.size.width + rect.origin.x - drawRect.origin.x - HSPACING - 10;
			drawRect.size.height = rect.size.height + rect.origin.y - drawRect.origin.y - VSPACING;
			[sig drawInRect:drawRect withFont:font];
		}
	}
	
	// draw level
	if([tool booleanValue:kPreferenceKeyShowLevel] && [_user level] > 0) {
		// set text color
		CGContextSetStrokeColor(context, gTheme.userTextFg);
		CGContextSetFillColor(context, gTheme.userTextFg);
		
		// create level font
		GSFontRef levelFont = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 12.0f);
		
		// draw
		drawRect.origin.x = HSPACING;
		drawRect.origin.y = VSPACING + headSize.height + VSPACING;
		drawRect.size.width = headSize.width;
		drawRect.size.height = 10000;
		NSString* s = [NSString stringWithFormat:@"%u%@", [_user level], L(@"Level")];
		CGSize levelSize = [s sizeInRect:drawRect withFont:levelFont];
		[s drawAtPoint:CGPointMake(drawRect.origin.x + (headSize.width - levelSize.width) / 2, drawRect.origin.y) withFont:levelFont];
		
		// release level font
		CFRelease(levelFont);
	}
	
	// release font
	CFRelease(font);
}

- (User*)user {
	return _user;
}

- (void)setUser:(User*)user {
	[user retain];
	[_user release];
	_user = user;
}

- (id)object {
	return _user;
}

- (void)setMemberMode:(BOOL)flag {
	_memberMode = flag;
}

- (void)setCluster:(Cluster*)cluster {
	[cluster retain];
	[_cluster release];
	_cluster = cluster;
}

@end
