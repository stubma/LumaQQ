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

#import "UserIMCell.h"
#import <UIKit/NSString-UIStringDrawing.h>
#import <GraphicsServices/GraphicsServices.h>
#import "Constants.h"
#import "NSString-Validate.h"

static float VSPACING = 3.0f;
static float HSPACING = 5.0f;

const float USER_IM_CELL_HEIGHT = 64.0f;

extern Theme gTheme;

@implementation UserIMCell

- (void) dealloc {
	[_user release];
	[super dealloc];
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
	UIImage* head = [_user headWithStatus:NO];
	[head compositeToPoint:drawRect.origin operation:NSCompositeSourceOver];
	CGSize headSize = [head size];
	
	// adjust origin
	drawRect.origin.x += headSize.width + HSPACING;
	drawRect.origin.y += VSPACING;
	
	//
	// draw name
	//
	
	// set text color
	CGContextSetStrokeColor(context, gTheme.userIMTextFg);
	CGContextSetFillColor(context, gTheme.userIMTextFg);
	
	// create font
	GSFontRef font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 16.0f);
	
	// get message array
	NSArray* msgArray = [_messageManager userMessages:_user];
	
	// draw display name
	NSString* displayName = [_user shortDisplayName];
	CGSize textSize = [displayName sizeInRect:drawRect withFont:font];
	drawRect.size.height = textSize.height;
	[displayName drawInRect:drawRect withFont:font];
	
	// draw unread hint
	CGContextSetStrokeColor(context, gTheme.unreadHintFg);
	CGContextSetFillColor(context, gTheme.unreadHintFg);
	NSString* unreadHint = [NSString stringWithFormat:@"(%u %@)", [msgArray count], L(@"Unread")];
	[unreadHint drawAtPoint:CGPointMake(drawRect.origin.x + textSize.width + HSPACING, drawRect.origin.y) withFont:font];
	
	// adjust draw rect
	drawRect.origin.y += textSize.height + VSPACING;
	
	if([msgArray count] > 0) {
		// get first packet
		NSDictionary* properties = [msgArray objectAtIndex:0];
			
		NSString* msg = [properties objectForKey:kChatLogKeyMessage];
		if(![msg isEmpty]) {
			// set signature text color
			if([self isSelected]) {
				CGContextSetStrokeColor(context, gTheme.userBg);
				CGContextSetFillColor(context, gTheme.userBg);
			} else {
				CGContextSetStrokeColor(context, gTheme.messageTextFg);
				CGContextSetFillColor(context, gTheme.messageTextFg);
			}
			
			// draw, 10 is a adjust to make sure all text is in the bound
			drawRect.size.width = rect.size.width + rect.origin.x - drawRect.origin.x - HSPACING - 10;
			drawRect.size.height = rect.size.height + rect.origin.y - drawRect.origin.y - VSPACING;
			[msg drawInRect:drawRect withFont:font];
		}	
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

- (MessageManager*)messageManager {
	return _messageManager;
}

- (void)setMessageManager:(MessageManager*)mm {
	_messageManager = mm;
}

@end
