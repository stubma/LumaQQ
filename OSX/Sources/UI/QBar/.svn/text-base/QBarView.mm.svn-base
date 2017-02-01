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

#import "QBarView.h"
#import "Constants.h"

// button size in QBar
#define _kButtonWidth 13
#define _kButtonHeight 13

@implementation QBarView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        m_addButtonHovered = NO;
		m_addButtonPressed = NO;
		m_addButtonTrackingTag = 0;
    }
    return self;
}

- (void) dealloc {
	if(m_plugin)
		[(id)m_plugin release];
	[m_delegate release];
	[super dealloc];
}

- (void)drawRect:(NSRect)rect {
	// get image
	NSImage* image = nil;
	if(m_addButtonPressed)
		image = [NSImage imageNamed:kImageAddButtonPressed];
	else if(m_addButtonHovered)
		image = [NSImage imageNamed:kImageAddButtonHovered];
	else
		image = [NSImage imageNamed:kImageAddButton];
	
	// get add button rect
	NSSize imageSize = [image size];
	m_newAddButtonRect = [self addButtonRect:[self bounds] imageSize:imageSize];
	
	// draw image
	[image compositeToPoint:m_newAddButtonRect.origin operation:NSCompositeSourceOver];
}

- (void)resetCursorRects {
	// update tracking rect
	if(m_newAddButtonRect.origin.x != m_oldAddButtonRect.origin.x ||
	   m_newAddButtonRect.origin.y != m_oldAddButtonRect.origin.y ||
	   m_newAddButtonRect.size.width != m_oldAddButtonRect.size.width ||
	   m_newAddButtonRect.size.height != m_oldAddButtonRect.size.height) {
		m_oldAddButtonRect = m_newAddButtonRect;
		if(m_addButtonTrackingTag != 0)
			[self removeTrackingRect:m_addButtonTrackingTag];
		m_addButtonTrackingTag = [self addTrackingRect:m_oldAddButtonRect
												 owner:self
											  userData:nil
										  assumeInside:NO];
	}
}

- (void)mouseEntered:(NSEvent *)theEvent {
	if([theEvent trackingNumber] == m_addButtonTrackingTag) {
		m_addButtonHovered = YES;
		[self setNeedsDisplay:YES];
	}
}

- (void)mouseExited:(NSEvent *)theEvent {
	if([theEvent trackingNumber] == m_addButtonTrackingTag) {
		m_addButtonHovered = NO;
		[self setNeedsDisplay:YES];
	}
}

- (void)mouseDown:(NSEvent *)theEvent {
	NSPoint loc = [theEvent locationInWindow];
	loc = [self convertPoint:loc fromView:nil];
	if(NSPointInRect(loc, m_oldAddButtonRect)) {
		m_addButtonPressed = YES;
		[self setNeedsDisplay:YES];
	}
}

- (void)mouseUp:(NSEvent *)theEvent {
	if(m_addButtonPressed) {
		m_addButtonPressed = NO;
		[self setNeedsDisplay:YES];
		
		// delegate
		if(m_delegate)
			[m_delegate qBarViewAddButtonPressed:self];
	}
}

#pragma mark -
#pragma mark helper

- (NSRect)addButtonRect:(NSRect)qRect imageSize:(NSSize)imageSize {
	NSRect addRect = qRect;
	addRect.origin.x = NSWidth(qRect) - _kButtonWidth;
	addRect.size.width = imageSize.width;
	addRect.size.height = imageSize.height;
	return addRect;
}

#pragma mark -
#pragma mark API

- (void)setQBarPlugin:(id<QBarPlugin>)plugin {
	if(m_plugin) {
		[m_plugin pluginDeactivated];
		[(id)m_plugin release];
	}
	m_plugin = [(id)plugin retain];
	[m_box setContentView:[plugin pluginView]];
	[m_plugin pluginActivated];
}

- (id<QBarPlugin>)plugin {
	return m_plugin;
}

- (void)setDelegate:(id)delegate {
	[delegate retain];
	[m_delegate release];
	m_delegate = delegate;
}

@end
