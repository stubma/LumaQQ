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
#import <UIKit/UIAlertSheet.h>
#import "UIUtil.h"
#import "LocalizedStringTool.h"

@implementation UIUtil

+ (CGRect)locateChild:(CGSize)childSize inParent:(CGRect)parentRect alignment:(int)alignment {
	CGRect rect;
	rect.size = childSize;
	
	// get horizontal and vertical gap
	int vGap = (parentRect.size.height - childSize.height) / 2;
	int hGap = (parentRect.size.width - childSize.width) / 2;
	
	// check alignment
	switch(alignment) {
		case kAlignLeft:
			rect.origin.x = parentRect.origin.x + MAX(hGap, 0);
			rect.origin.y = parentRect.origin.y + MAX(vGap, 0);
			break;
		case kAlignRight:
			rect.origin.x = parentRect.origin.x + parentRect.size.width - childSize.width - MAX(hGap, 0);
			rect.origin.y = parentRect.origin.y + parentRect.size.height - childSize.height - MAX(vGap, 0);
			break;
		case kAlignAbsoluteCenter:
			rect.origin.x = hGap;
			rect.origin.y = vGap;
			break;
	}
	return rect;
}

+ (void)showWarning:(NSString*)message title:(NSString*)title delegate:(id)delegate {
	NSArray* buttons = [NSArray arrayWithObjects:L(@"OK"), nil];
	UIAlertSheet* alertSheet = [[UIAlertSheet alloc] initWithTitle:title buttons:buttons defaultButtonIndex:1 delegate:delegate context:nil];
	[alertSheet setBodyText:message];
	[alertSheet popupAlertAnimated:YES];
}

+ (void)showQuestion:(NSString*)message title:(NSString*)title delegate:(id)delegate {
	NSArray* buttons = [NSArray arrayWithObjects:L(@"OK"), L(@"Cancel"), nil];
	UIAlertSheet* alertSheet = [[UIAlertSheet alloc] initWithTitle:title buttons:buttons defaultButtonIndex:2 delegate:delegate context:nil];
	[alertSheet setBodyText:message];
	[alertSheet popupAlertAnimated:YES];
}

@end
