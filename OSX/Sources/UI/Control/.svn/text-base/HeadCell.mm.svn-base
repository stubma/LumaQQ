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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

#import "Constants.h"
#import "HeadCell.h"
#import "QQConstants.h"
#import "ImageTool.h"
#import "User.h"
#import "Group.h"

@implementation HeadCell

- (id) init {
	self = [super init];
	if (self != nil) {
		m_head = 0;
		m_status = kQQStatusOffline;
		m_showStatus = YES;
	}
	return self;
}

- (void) dealloc {
	[m_image release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone*)zone {
    HeadCell* newCopy = [[HeadCell alloc] init];
    [newCopy setHead:[self head]];
	[newCopy setStatus:[self status]];
	[newCopy setShowStatus:[self showStatus]];
    return newCopy;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {	
	// get main image
	NSImage* imgMain = m_image;
	
	// check TM
	if(m_head != kHeadUseImage) {
		User* u = [self objectValue];
		if(u == nil)
			imgMain = [ImageTool headWithId:m_head];
		else {
			[u setHead:m_head];
			imgMain = [u head:m_owner handleStatus:[self showStatus]];
		}
	}
	
	// if nil
	if(!imgMain)
		return;
	
	// get main image rect
	NSSize imgSize = [imgMain size];
	
	// compare cell frame and image size
	if(imgSize.width > NSWidth(cellFrame) || imgSize.height > NSHeight(cellFrame)) 
		imgMain = [ImageTool imageWithName:[imgMain name] size:cellFrame.size];
	
	// calculate draw location and draw
	int x = cellFrame.origin.x;
	int y = NSMinY(cellFrame);
	NSRect imgRect = NSMakeRect(x,
								y,
								MIN(NSWidth(cellFrame), imgSize.width),
								MIN(NSHeight(cellFrame), imgSize.height));
								
	if ([controlView isFlipped])
		imgRect.origin.y += ceil((cellFrame.size.height + imgRect.size.height) / 2);
	else
		imgRect.origin.y += ceil((cellFrame.size.height - imgRect.size.height) / 2);
	[imgMain compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
	
	// draw status decoration
	if([self showStatus]) {
		switch(m_status) {
			case kQQStatusAway:
				[self drawDecoration:[NSImage imageNamed:kImageAway] headRect:imgRect];
				break;
			case kQQStatusHidden:
				[self drawDecoration:[NSImage imageNamed:kImageHidden] headRect:imgRect];
				break;
			case kQQStatusQMe:
				[self drawDecoration:[NSImage imageNamed:kImageQMe] headRect:imgRect];
				break;
			case kQQStatusBusy:
				[self drawDecoration:[NSImage imageNamed:kImageBusy] headRect:imgRect];
				break;
			case kQQStatusMute:
				[self drawDecoration:[NSImage imageNamed:kImageMute] headRect:imgRect];
				break;
		}
	}
}

- (void)drawDecoration:(NSImage*)image headRect:(NSRect)headRect {
	// draw decoration at right bottom corner
	NSSize imgSize = [image size];
	[image compositeToPoint:NSMakePoint(headRect.origin.x + NSWidth(headRect) - imgSize.width, headRect.origin.y) operation:NSCompositeSourceOver];
}

- (NSSize)cellSize {
	if([[self objectValue] isMemberOfClass:[Group class]])
		return NSMakeSize(20, 20);
	else
		return NSMakeSize(44, 44);
}

- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag {
	NSLog(@"stop tracking");
}

#pragma mark -
#pragma mark getter and setter

- (UInt16)head {
	return m_head;
}

- (char)status {
	return m_status;
}

- (void)setHead:(UInt16)head {
	m_head = head;
	[(NSControl*)[self controlView] updateCell:self];
}

- (void)setStatus:(char)status {
	m_status = status;
	[(NSControl*)[self controlView] updateCell:self];
}

- (void)setObjectValue:(id)object {
	[super setObjectValue:object];
	if([object isMemberOfClass:[User class]]) {
		[self setHead:[(User*)object head]];
		[self setStatus:[(User*)object status]];
	}
}

- (BOOL)showStatus {
	return m_showStatus;
}

- (void)setShowStatus:(BOOL)showStatus {
	m_showStatus = showStatus;
	[(NSControl*)[self controlView] updateCell:self];
}

- (NSImage*)image {
	return m_image;
}

- (void)setImage:(NSImage*)image {
	[image retain];
	[m_image release];
	m_image = image;
	[(NSControl*)[self controlView] updateCell:self];
}

- (void)setOwner:(UInt32)owner {
	m_owner = owner;
}

@end
