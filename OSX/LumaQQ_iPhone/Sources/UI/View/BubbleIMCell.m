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

#import "BubbleIMCell.h"
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/NSString-UIStringDrawing.h>
#import "NSString-Validate.h"
#import "MessageRipper.h"
#import "Constants.h"
#import "ImageTool.h"

static const float HSPACING = 3.0f;
static const float VSPACING = 3.0f;
static const float BUBBLE_HSIZE = 23.0f;
static const float BUBBLE_VSIZE = 19.0f;
static const float BUBBLE_HSPAN = 18.0f;
static const float BUBBLE_VSPAN = 16.0f;
static const float BUBBLE_HADJUST = -10.0f;
static const float BUBBLE_VADJUST = -9.0f;

extern UInt32 gMyQQ;
extern Theme gTheme;

@implementation BubbleIMCell

- (void) dealloc {
	[_properties release];
	[super dealloc];
}

- (void)setGroupManager:(GroupManager*)gm {
	_groupManager = gm;
}

- (void)setProperties:(NSDictionary*)properties {
	[properties retain];
	[_properties release];
	_properties = properties;
	_height = 0.0f;
}

- (float)height {
	if(_height == 0.0f) {
		// qq is nil means error message
		NSNumber* qq = [_properties objectForKey:kChatLogKeyQQ];
		NSString* msg = [_properties objectForKey:kChatLogKeyMessage];
		if(qq == nil) {
			// create error font
			GSFontRef font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 10.0f);
			
			// get msg rect and evaluate size
			CGRect maxMsgRect = CGRectMake(HSPACING, VSPACING, 320.0f - HSPACING - HSPACING, 10000.0f);
			CGSize msgSize = [msg sizeInRect:maxMsgRect withFont:font];
			_height = msgSize.height + VSPACING + VSPACING;
			
			// release
			CFRelease(font);
		} else {
			NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[_properties objectForKey:kChatLogKeyTime] unsignedIntValue]];
			NSString* name = nil;
			UIImage* head = nil;
			BOOL bMe = NO;
			User* u = [_groupManager user:[qq unsignedIntValue]];
			if(u != nil) {
				name = [u shortDisplayName];
				head = [u headWithStatus:NO];
				bMe = [u QQ] == gMyQQ;
			} else {
				name = [NSString stringWithFormat:@"%u", [qq unsignedIntValue]];
				head = [ImageTool headWithRealId:1];
				bMe = [qq unsignedIntValue] == gMyQQ;
			}
			
			// add head
			CGSize headSize = [head size];
			
			// create font
			GSFontRef font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 12.0f);
			GSFontRef msgFont = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 14.0f);
			
			// get name size
			CGSize nameSize = [name sizeWithFont:font];
			_height += MAX(nameSize.height, headSize.height / 2.0f);
			
			// get date string size
			NSCalendar* calendar = [NSCalendar currentCalendar];
			NSDateComponents* comp = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
			NSString* formattedDateString = nil;
			if([comp hour] > 9)
				formattedDateString = [NSString stringWithFormat:@"%u", [comp hour]];
			else
				formattedDateString = [NSString stringWithFormat:@"0%u", [comp hour]];
			if([comp minute] > 9)
				formattedDateString = [NSString stringWithFormat:@"%@:%u", formattedDateString, [comp minute]];
			else
				formattedDateString = [NSString stringWithFormat:@"%@:0%u", formattedDateString, [comp minute]];
			if([comp second] > 9)
				formattedDateString = [NSString stringWithFormat:@"%@:%u", formattedDateString, [comp second]];
			else
				formattedDateString = [NSString stringWithFormat:@"%@:0%u", formattedDateString, [comp second]];
			CGSize dateSize = [formattedDateString sizeWithFont:font];
			_height += dateSize.height;
			
			// calculate available msg rect
			float x = bMe ? (320.0f - HSPACING) : HSPACING;
			float maxSize = MAX(headSize.width / 2.0f + HSPACING + nameSize.width, dateSize.width);
			CGRect maxMsgRect;
			maxMsgRect.origin.x = (bMe ? 0 : (x + maxSize)) + HSPACING + BUBBLE_HSIZE + BUBBLE_HADJUST;
			maxMsgRect.origin.y = VSPACING + BUBBLE_VSIZE + BUBBLE_VADJUST;
			maxMsgRect.size.height = 10000.0f;
			maxMsgRect.size.width = 320.0f - HSPACING - BUBBLE_HSIZE - BUBBLE_HADJUST - maxMsgRect.origin.x - (bMe ? maxSize : 0);
			
			// msg size may exceed max width, so we keep one block buffer
			maxMsgRect.size.width -= BUBBLE_HSPAN;
			
			// get msg size in this rect
			CGSize msgSize = [msg sizeInRect:maxMsgRect withFont:msgFont];
			int bubbleVCount = ceilf((msgSize.height + BUBBLE_VADJUST + BUBBLE_VADJUST) / BUBBLE_VSPAN);
			
			// compare with height
			_height = MAX(_height, bubbleVCount * BUBBLE_VSPAN + BUBBLE_VSIZE + BUBBLE_VSIZE);
			
			// add spacing
			_height += VSPACING + VSPACING;
			
			// release
			CFRelease(font);
			CFRelease(msgFont);	
		}
	}
	return _height;
}

- (void)drawRect:(CGRect)rect {
	if(rect.size.height <= 0)
		return;
	
	NSNumber* qq = [_properties objectForKey:kChatLogKeyQQ];
	NSString* msg = [_properties objectForKey:kChatLogKeyMessage];
	
	// create bg color
	CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGColorRef bgColor = CGColorCreate(colorSpace, gTheme.bubbleBg);
	CGColorSpaceRelease(colorSpace);
	
	// draw bg
	CGContextRef context = UICurrentContext();
	CGContextSetFillColorWithColor(context, bgColor);
	CGContextFillRect(context, rect);
	CGColorRelease(bgColor);
	
	// check msg
	if(msg == nil)
		return;
	
	// qq is nil means an error string
	if(qq == nil) {
		// set error text color
		CGContextSetStrokeColor(context, gTheme.errorTextFg);
		CGContextSetFillColor(context, gTheme.errorTextFg);
		
		// create error font
		GSFontRef font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 10.0f);
		
		// get msg rect and evaluate size
		CGRect maxMsgRect = CGRectMake(HSPACING, VSPACING, 320.0f - HSPACING - HSPACING, 10000.0f);
		CGSize msgSize = [msg sizeInRect:maxMsgRect withFont:font];
		
		// draw message
		[msg drawAtPoint:CGPointMake(HSPACING + (maxMsgRect.size.width - msgSize.width) / 2.0f, VSPACING) withFont:font];
		
		// release
		CFRelease(font);
	} else {
		NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[_properties objectForKey:kChatLogKeyTime] unsignedIntValue]];
		NSString* name = nil;
		UIImage* head = nil;
		BOOL bMe = NO;
		User* u = [_groupManager user:[qq unsignedIntValue]];
		if(u != nil) {
			name = [u shortDisplayName];
			head = [u headWithStatus:NO];
			bMe = [u QQ] == gMyQQ;
		} else {
			name = [NSString stringWithFormat:@"%u", [qq unsignedIntValue]];
			head = [ImageTool headWithRealId:1];
			bMe = [qq unsignedIntValue] == gMyQQ;
		}
		
		// create bg color
		CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
		CGColorRef bgColor = CGColorCreate(colorSpace, gTheme.bubbleBg);
		CGColorSpaceRelease(colorSpace);
		
		// draw bg
		CGContextRef context = UICurrentContext();
		CGContextSetFillColorWithColor(context, bgColor);
		CGContextFillRect(context, rect);
		CGColorRelease(bgColor);
		
		// create font
		GSFontRef font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 12.0f);
		GSFontRef msgFont = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 14.0f);
		
		// get name size
		CGSize nameSize = [name sizeWithFont:font];
		
		// get head size
		CGSize headSize = [head size];
		
		// get date string size
		NSCalendar* calendar = [NSCalendar currentCalendar];
		NSDateComponents* comp = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
		NSString* formattedDateString = nil;
		if([comp hour] > 9)
			formattedDateString = [NSString stringWithFormat:@"%u", [comp hour]];
		else
			formattedDateString = [NSString stringWithFormat:@"0%u", [comp hour]];
		if([comp minute] > 9)
			formattedDateString = [NSString stringWithFormat:@"%@:%u", formattedDateString, [comp minute]];
		else
			formattedDateString = [NSString stringWithFormat:@"%@:0%u", formattedDateString, [comp minute]];
		if([comp second] > 9)
			formattedDateString = [NSString stringWithFormat:@"%@:%u", formattedDateString, [comp second]];
		else
			formattedDateString = [NSString stringWithFormat:@"%@:0%u", formattedDateString, [comp second]];
		CGSize dateSize = [formattedDateString sizeWithFont:font];
		
		// msg rect
		CGRect maxMsgRect;
		
		// draw head
		float x = bMe ? (rect.size.width - HSPACING) : HSPACING;
		float y = VSPACING;
		[head compositeToRect:CGRectMake(x - (bMe ? (headSize.width / 2) : 0), y, headSize.width / 2, headSize.height / 2)
					 fromRect:CGRectMake(0.0f, 0.0f, headSize.width, headSize.height)
					operation:NSCompositeSourceOver
					 fraction:1.0f];
		x += bMe ? -(headSize.width / 2.0f + HSPACING) : (headSize.width / 2.0f + HSPACING);
		
		// set text color
		CGContextSetStrokeColor(context, gTheme.bubbleIMTextFg);
		CGContextSetFillColor(context, gTheme.bubbleIMTextFg);
		
		// draw name
		[name drawAtPoint:CGPointMake(x - (bMe ? nameSize.width : 0), y + (headSize.height / 2.0f - nameSize.height) / 2.0f) withFont:font];
		x = bMe ? (rect.size.width - HSPACING) : HSPACING;
		y += MAX(nameSize.height, headSize.height / 2.0f) + VSPACING;
		
		// draw date
		[formattedDateString drawAtPoint:CGPointMake(x - (bMe ? dateSize.width : 0), y) withFont:font];
		
		// calculate available msg rect
		float maxSize = MAX(headSize.width / 2.0f + HSPACING + nameSize.width, dateSize.width);
		maxMsgRect.origin.x = (bMe ? 0 : (x + maxSize)) + HSPACING + BUBBLE_HSIZE + BUBBLE_HADJUST;
		maxMsgRect.origin.y = VSPACING + BUBBLE_VSIZE + BUBBLE_VADJUST;
		maxMsgRect.size.height = 10000.0f;
		maxMsgRect.size.width = rect.size.width - HSPACING - BUBBLE_HSIZE - BUBBLE_HADJUST - maxMsgRect.origin.x - (bMe ? maxSize : 0);
		
		// msg size may exceed max width, so we keep one block buffer
		maxMsgRect.size.width -= BUBBLE_HSPAN;
		
		// get msg size in this rect
		CGSize msgSize = [msg sizeInRect:maxMsgRect withFont:msgFont];
		int bubbleHCount = ceilf((msgSize.width + BUBBLE_HADJUST + BUBBLE_HADJUST) / BUBBLE_HSPAN);
		int bubbleVCount = ceilf((msgSize.height + BUBBLE_VADJUST + BUBBLE_VADJUST) / BUBBLE_VSPAN);
		if(bMe)
			maxMsgRect.origin.x = maxMsgRect.size.width - bubbleHCount * BUBBLE_HSPAN;
		maxMsgRect.size = msgSize;
		
		// draw bubble top
		int i, j;
		x = maxMsgRect.origin.x - BUBBLE_HSIZE - BUBBLE_HADJUST;
		y = maxMsgRect.origin.y - BUBBLE_VSIZE - BUBBLE_VADJUST;
		[[UIImage imageNamed:(bMe ? kImageBlueBubbleTopLeft : kImageGrayBubbleTopLeft)] compositeToPoint:CGPointMake(x, y) operation:NSCompositeSourceOver];
		x += BUBBLE_HSIZE;
		UIImage* topMiddle = [UIImage imageNamed:(bMe ? kImageBlueBubbleTopMiddle : kImageGrayBubbleTopMiddle)];
		for(i = 0; i < bubbleHCount; i++) {
			[topMiddle compositeToPoint:CGPointMake(x, y) operation:NSCompositeSourceOver];
			x += BUBBLE_HSPAN;
		}	
		[[UIImage imageNamed:(bMe ? kImageBlueBubbleTopRight : kImageGrayBubbleTopRight)] compositeToPoint:CGPointMake(x, y) operation:NSCompositeSourceOver];
		
		// draw bubble middle
		x = maxMsgRect.origin.x - BUBBLE_HSIZE - BUBBLE_HADJUST;
		y += BUBBLE_VSIZE;
		for(i = 0; i < bubbleVCount; i++) {
			[[UIImage imageNamed:(bMe ? kImageBlueBubbleLeft : kImageGrayBubbleLeft)] compositeToPoint:CGPointMake(x, y) operation:NSCompositeSourceOver];
			x += BUBBLE_HSIZE;
			
			UIImage* middle = [UIImage imageNamed:(bMe ? kImageBlueBubbleMiddle : kImageGrayBubbleMiddle)];
			for(j = 0; j < bubbleHCount; j++) {
				[middle compositeToPoint:CGPointMake(x, y) operation:NSCompositeSourceOver];
				x += BUBBLE_HSPAN;
			}
			
			[[UIImage imageNamed:(bMe ? kImageBlueBubbleRight : kImageGrayBubbleRight)] compositeToPoint:CGPointMake(x, y) operation:NSCompositeSourceOver];
			x = maxMsgRect.origin.x - BUBBLE_HSIZE - BUBBLE_HADJUST;
			y += BUBBLE_VSPAN;
		}
		
		// draw bubble bottom
		[[UIImage imageNamed:(bMe ? kImageBlueBubbleBottomLeft : kImageGrayBubbleBottomLeft)] compositeToPoint:CGPointMake(x, y) operation:NSCompositeSourceOver];
		x += BUBBLE_HSIZE;
		UIImage* bottomMiddle = [UIImage imageNamed:(bMe ? kImageBlueBubbleBottomMiddle : kImageGrayBubbleBottomMiddle)];
		for(i = 0; i < bubbleHCount; i++) {
			[bottomMiddle compositeToPoint:CGPointMake(x, y) operation:NSCompositeSourceOver];
			x += BUBBLE_HSPAN;
		}
		[[UIImage imageNamed:(bMe ? kImageBlueBubbleBottomRight : kImageGrayBubbleBottomRight)] compositeToPoint:CGPointMake(x, y) operation:NSCompositeSourceOver];
		
		// draw message
		[msg drawInRect:maxMsgRect withFont:msgFont];
		
		// release
		CFRelease(font);
		CFRelease(msgFont);	
	}
}

@end
