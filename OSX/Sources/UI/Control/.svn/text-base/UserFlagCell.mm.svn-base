/*
 * LumaQQ - Cross platform QQ client, special edition for Mac
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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 0 2111-1307 USA
 */

#import "UserFlagCell.h"
#import "User.h"
#import "Constants.h"

@implementation UserFlagCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	// get user model
	User* u = [self objectValue];
	if(u == nil)
		return;
	
	// set image size
	NSSize imgSize = NSMakeSize(16.0, 16.0);
	int spacing = 2;
	
	// get start point
	int x = cellFrame.origin.x;
	int y = NSMinY(cellFrame);
	NSRect imgRect = NSMakeRect(x, y, imgSize.width, imgSize.height);
	
	if ([controlView isFlipped])
		imgRect.origin.y += ceil((cellFrame.size.height + imgRect.size.height) / 2);
	else
		imgRect.origin.y += ceil((cellFrame.size.height - imgRect.size.height) / 2);
	
	// is member?
	if([u isMember]) {
		NSImage* img = [NSImage imageNamed:kImageQQMember];
		[img compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
		imgRect.origin.x += imgSize.width + spacing;
	}
	
	// is vip?
	if([u isVIP]) {
		NSImage* img = [NSImage imageNamed:kImageQQVIP];
		[img compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
		imgRect.origin.x += imgSize.width + spacing;
	}
	
	// is hua xia?
	if([u hasHuaXia]) {
		NSImage* img = [NSImage imageNamed:kImageQQHuaXia];
		[img compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
		imgRect.origin.x += imgSize.width;
	}
	
	// is fantasy?
	if([u hasFantasy]) {
		NSImage* img = [NSImage imageNamed:kImageQQFantasy];
		[img compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
		imgRect.origin.x += imgSize.width + spacing;
	}
	
	// is qq tang?
	if([u hasTang]) {
		NSImage* img = [NSImage imageNamed:kImageQQTang];
		[img compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
		imgRect.origin.x += imgSize.width + spacing;
	}
	
	// is 3d show?
	if([u has3DShow]) {
		NSImage* img = [NSImage imageNamed:kImageQQ3DShow];
		[img compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
		imgRect.origin.x += imgSize.width + spacing;
	}
	
	// is bind to mobile?
	if([u isBind]) {
		NSImage* img = [NSImage imageNamed:kImageQQBindToMobile];
		[img compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
		imgRect.origin.x += imgSize.width + spacing;
	}
	
	// is ring?
	if([u hasRing]) {
		NSImage* img = [NSImage imageNamed:kImageQQRing];
		[img compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
		imgRect.origin.x += imgSize.width + spacing;
	}
	
	// has space?
	if([u hasSpace]) {
		NSImage* img = [NSImage imageNamed:kImageQQSpace];
		[img compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
		imgRect.origin.x += imgSize.width + spacing;
	}
	
	// is home user?
	if([u hasHome]) {
		NSImage* img = [NSImage imageNamed:kImageQQHome];
		[img compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
		imgRect.origin.x += imgSize.width + spacing;
	}
	
	// is love?
	if([u hasLove]) {
		NSImage* img = [NSImage imageNamed:kImageQQLove];
		[img compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
		imgRect.origin.x += imgSize.width + spacing;
	}
	
	// is qq pet?
	if([u hasPet]) {
		NSImage* img = [NSImage imageNamed:kImageQQPet];
		[img compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
		imgRect.origin.x += imgSize.width + spacing;
	}
}

@end
