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

#import "ChatLogIMCell.h"
#import "Constants.h"
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/NSString-UIStringDrawing.h>
#import "ImageTool.h"
#import "NSString-Validate.h"

extern UInt32 gMyQQ;
extern Theme gTheme;

static const float HSPACING = 3.0f;
static const float VSPACING = 3.0f;

@implementation ChatLogIMCell

- (void) dealloc {
	[_properties release];
	[super dealloc];
}

- (BOOL)isMatched:(NSString*)text {
	if(text == nil || [text isEmpty]) 
		return YES;
	
	// get message
	NSString* msg = [_properties objectForKey:kChatLogKeyMessage];
	
	// search
	NSRange range = [msg rangeOfString:text options:NSCaseInsensitiveSearch];
	return range.location != NSNotFound;
}

- (float)height {
	if(_height == 0.0f) {
		// get message
		NSString* msg = [_properties objectForKey:kChatLogKeyMessage];
		
		// get date
		NSNumber* dateInt = [_properties objectForKey:kChatLogKeyTime];
		NSDate* date = [NSDate dateWithTimeIntervalSince1970:[dateInt unsignedIntValue]];
		
		// get name and head
		NSString* name = nil;
		UIImage* head = nil;
		NSNumber* qq = [_properties objectForKey:kChatLogKeyQQ];
		User* user = [_groupManager user:[qq unsignedIntValue]];
		if(user == nil) {
			name = [NSString stringWithFormat:@"%u", [qq unsignedIntValue]];
			head = [ImageTool headWithRealId:1];
		} else {
			name = [user shortDisplayName];
			head = [user headWithStatus:NO];
		}
		
		// me flag
		BOOL bMe = [qq unsignedIntValue] == gMyQQ;
		
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
		NSDateComponents* comp = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
		NSString* formattedDateString = nil;
		if([comp hour] > 9)
			formattedDateString = [NSString stringWithFormat:@"%u/%u %u", [comp month], [comp day], [comp hour]];
		else
			formattedDateString = [NSString stringWithFormat:@"%u/%u 0%u", [comp month], [comp day], [comp hour]];
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
		maxMsgRect.origin.x = (bMe ? 0 : (x + maxSize)) + HSPACING;
		maxMsgRect.origin.y = VSPACING;
		maxMsgRect.size.height = 10000.0f;
		maxMsgRect.size.width = 320.0f - HSPACING - maxMsgRect.origin.x - (bMe ? maxSize : 0);
		maxMsgRect.size.width -= 10.0f;
		
		// get msg size in this rect
		CGSize msgSize = [msg sizeInRect:maxMsgRect withFont:msgFont];
		
		// compare with height
		_height = MAX(_height, msgSize.height);
		
		// add spacing
		_height += VSPACING + VSPACING;		
		
		// release
		CFRelease(font);
		CFRelease(msgFont);
	}
	return _height;
}

- (void)drawRect:(CGRect)rect {
	// 0 means this is not visible
	if(rect.size.height <= 0)
		return;
	
	// get message
	NSString* msg = [_properties objectForKey:kChatLogKeyMessage];
	
	// get date
	NSNumber* dateInt = [_properties objectForKey:kChatLogKeyTime];
	NSDate* date = [NSDate dateWithTimeIntervalSince1970:[dateInt unsignedIntValue]];
	
	// get name and head
	NSString* name = nil;
	UIImage* head = nil;
	NSNumber* qq = [_properties objectForKey:kChatLogKeyQQ];
	User* user = [_groupManager user:[qq unsignedIntValue]];
	if(user == nil) {
		name = [NSString stringWithFormat:@"%u", [qq unsignedIntValue]];
		head = [ImageTool headWithRealId:0];
	} else {
		name = [user shortDisplayName];
		head = [user headWithStatus:NO];
	}
	
	// me flag
	BOOL bMe = [qq unsignedIntValue] == gMyQQ;
	
	// create bg color
	CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGColorRef bgColor = NULL;
	if([self isSelected])
		bgColor = CGColorCreate(colorSpace, gTheme.chatLogSelectedBg);
	else
		bgColor = CGColorCreate(colorSpace, gTheme.chatLogBg);
	CGColorSpaceRelease(colorSpace);
	
	// draw bg
	CGContextRef context = UICurrentContext();
	CGContextSetFillColorWithColor(context, bgColor);
	CGContextFillRect(context, rect);
	CGColorRelease(bgColor);
	
	// draw separator
	[self drawSeparatorInRect:rect];
	
	// create font
	GSFontRef font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 12.0f);
	GSFontRef msgFont = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 14.0f);
	
	// get name size
	CGSize nameSize = [name sizeWithFont:font];
	
	// get head size
	CGSize headSize = [head size];
	
	// get date string size
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* comp = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
	NSString* formattedDateString = nil;
	if([comp hour] > 9)
		formattedDateString = [NSString stringWithFormat:@"%u/%u %u", [comp month], [comp day], [comp hour]];
	else
		formattedDateString = [NSString stringWithFormat:@"%u/%u 0%u", [comp month], [comp day], [comp hour]];
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
	CGContextSetStrokeColor(context, gTheme.chatLogTextFg);
	CGContextSetFillColor(context, gTheme.chatLogTextFg);
	
	// draw name
	[name drawAtPoint:CGPointMake(x - (bMe ? nameSize.width : 0), y + (headSize.height / 2.0f - nameSize.height) / 2.0f) withFont:font];
	x = bMe ? (rect.size.width - HSPACING) : HSPACING;
	y += MAX(nameSize.height, headSize.height / 2.0f) + VSPACING;
	
	// draw date
	[formattedDateString drawAtPoint:CGPointMake(x - (bMe ? dateSize.width : 0), y) withFont:font];
	
	// calculate available msg rect
	float maxSize = MAX(headSize.width / 2.0f + HSPACING + nameSize.width, dateSize.width);
	maxMsgRect.origin.x = (bMe ? 0 : (x + maxSize)) + HSPACING;
	maxMsgRect.origin.y = VSPACING;
	maxMsgRect.size.height = 10000.0f;
	maxMsgRect.size.width = rect.size.width - HSPACING - maxMsgRect.origin.x - (bMe ? maxSize : 0);
	maxMsgRect.size.width -= 10.0f;
	
	// get msg size in this rect
	CGSize msgSize = [msg sizeInRect:maxMsgRect withFont:msgFont];
	if(bMe)
		maxMsgRect.origin.x = maxMsgRect.origin.x + maxMsgRect.size.width - msgSize.width;
	maxMsgRect.size = msgSize;
	
	// set message color
	if(bMe) {
		CGContextSetStrokeColor(context, gTheme.chatLogMyMsgFg);
		CGContextSetFillColor(context, gTheme.chatLogMyMsgFg);
	} else {
		CGContextSetStrokeColor(context, gTheme.chatLogOtherMsgFg);
		CGContextSetFillColor(context, gTheme.chatLogOtherMsgFg);
	}

	// draw message
	[msg drawInRect:maxMsgRect withFont:msgFont];
	
	// release
	CFRelease(font);
	CFRelease(msgFont);
}

- (void)setProperties:(NSDictionary*)properties {
	[properties retain];
	[_properties release];
	_properties = properties;
	_height = 0.0f;
}

- (void)setGroupManager:(GroupManager*)gm {
	_groupManager = gm;
}

@end
