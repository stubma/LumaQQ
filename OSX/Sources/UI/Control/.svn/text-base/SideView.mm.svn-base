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

#import "SideView.h"
#import "MainWindowController.h"
#import "AnimationHelper.h"
#import "Constants.h"

#define _kAnimationHide 0
#define _kAnimationShow 1
#define _kAnimationDragDrop 2

@implementation SideView

- (void) dealloc {
	[self stopTimer];
	[m_mainWindowController release];
	[super dealloc];
}

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	if(self) {
		m_hided = NO;
		m_mouseInside = NO;
		m_animating = NO;
		m_animationType = -1;
	}
	return self;
}

- (void)onTimer:(NSTimer*)theTimer {
	// check window
	NSWindow* window = [self window];
	if(window == nil)
		return;
	
	// check hided, if hided, flash if there is unread message
	// if not hided, hide it if mouse is outside of view
	if(m_hided) {
		if([[m_mainWindowController messageQueue] pendingMessageCount] > 0) 
			[self show];
	} else {
		// check unread message
		if([[m_mainWindowController messageQueue] pendingMessageCount] > 0)
			return;
		
		// check mouse
		if(m_mouseInside)
			return;
		
		// check animation
		if(m_animating)
			return;
		
		// hide myself
		m_animating = YES;
		NSRect startFrame = [window frame];
		NSRect endFrame = startFrame;
		switch(m_dockSide) {
			case kSideLeft:
				endFrame.origin.x -= NSWidth(startFrame) - 10;
				break;
			case kSideRight:
				endFrame.origin.x += NSWidth(startFrame) - 10;
				break;
			case kSideBottom:
				endFrame.origin.y -= NSHeight(startFrame) - 10;
				break;
			case kSideTop:
				endFrame.origin.y += NSHeight(startFrame) - 10;
				break;
		}
		
		// animation
		m_animationType = _kAnimationHide;
		[AnimationHelper moveWindow:window 
							   from:startFrame
								 to:endFrame
						   delegate:self];
	}
}

- (void)drawRect:(NSRect)aRect {
	[super drawRect:aRect];
	
	// add tracking
	if(m_trackTag == 0) {
		m_trackTag = [self addTrackingRect:[self bounds]
									 owner:self
								  userData:nil
							  assumeInside:NO];
	}
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
	if(newWindow) {
		// add tracking
		if(m_trackTag != 0) {
			[self removeTrackingRect:m_trackTag];
			m_trackTag = 0;
		}
		if(m_trackTag == 0) {
			m_trackTag = [self addTrackingRect:[self bounds]
										 owner:self
									  userData:nil
								  assumeInside:NO];
		}
		
		// start timer
		m_timer = [NSTimer scheduledTimerWithTimeInterval:3
												   target:self
												 selector:@selector(onTimer:)
												 userInfo:nil
												  repeats:YES];
		[m_timer retain];
	} else {
		// remove tracking
		if(m_trackTag != 0) {
			[self removeTrackingRect:m_trackTag];
			m_trackTag = 0;
		}
		
		// stop timer
		[self stopTimer];
		
		// clear flag
		m_hided = NO;
		m_mouseInside = NO;
		m_animating = NO;
	}
}

- (void)stopTimer {
	if(m_timer) {
		[m_timer invalidate];
		[m_timer release];
		m_timer = nil;
	}
}

- (void)mouseDown:(NSEvent *)theEvent {
	m_doDrag = NO;
	NSWindow* window = [self window];
	if(window) {
		switch([theEvent clickCount]) {
			case 0:
				break;
			case 1:
				if([[m_mainWindowController messageQueue] pendingMessageCount] > 0)
					[m_mainWindowController performSelector:@selector(onExtractMessage:) withObject:self];
				else {
					m_doDrag = YES;
					m_frame = [window frame];
					m_mousePt = [theEvent locationInWindow];
				}
				break;
			default:
				// > 1, then we think it's a double click
				[m_mainWindowController performSelector:@selector(onRestoreFromAutoHide:) withObject:self];
				break;
		}
	}
}

- (void)mouseDragged:(NSEvent *)theEvent {
	if(m_doDrag) {
		NSPoint pt = [theEvent locationInWindow];
		m_frame.origin.x += pt.x - m_mousePt.x;
		m_frame.origin.y += pt.y - m_mousePt.y;
		NSWindow* window = [self window];
		if(window)
			[window setFrameOrigin:m_frame.origin];
	}
}

- (void)mouseUp:(NSEvent *)theEvent {
	if(!m_doDrag)
		return;
	NSWindow* window = [self window];
	if(!window)
		return;
	
	// get screen size
	NSRect screenFrame = [[NSScreen mainScreen] frame];
	
	// check side, 0: left, 1: right, 2: top, 3: bottom
	m_dockSide = kSideLeft;
	int gap = NSMinX(m_frame) - NSMinX(screenFrame);
	if(NSMaxX(screenFrame) - NSMaxX(m_frame) < gap) {
		m_dockSide = kSideRight;
		gap = NSMaxX(screenFrame) - NSMaxX(m_frame);
	}
	if(NSMinY(m_frame) - NSMinY(screenFrame) < gap) {
		m_dockSide = kSideBottom;
		gap = NSMinY(m_frame) - NSMinY(screenFrame);
	}
	if(NSMaxY(screenFrame) - NSMaxY(m_frame) < gap)
		m_dockSide = kSideTop;
	
	// calculate new location
	NSRect viewBound = [self bounds];
	if(m_dockSide == kSideRight)
		m_frame.origin.x = NSMaxX(screenFrame) - NSWidth(viewBound);
	else if(m_dockSide == kSideLeft)
		m_frame.origin.x = 0;
	else if(m_dockSide == kSideBottom)
		m_frame.origin.y = 0;
	else
		m_frame.origin.y = NSMaxY(screenFrame) - NSHeight(viewBound);
	m_frame.origin.y = MAX(m_frame.origin.y, 0);
	m_frame.origin.y = MIN(m_frame.origin.y, NSMaxY(screenFrame) - NSHeight(viewBound));
	m_frame.origin.x = MAX(m_frame.origin.x, 0);
	m_frame.origin.x = MIN(m_frame.origin.x, NSMaxX(screenFrame) - NSWidth(viewBound));
	
	// clear flag
	m_hided = NO;
	m_animating = YES;
	
	// start animation
	m_animationType = _kAnimationDragDrop;
	[AnimationHelper moveWindow:window
						   from:[window frame]
							 to:m_frame
					   delegate:self];
}

- (void)mouseEntered:(NSEvent *)theEvent {
	if([theEvent trackingNumber] == m_trackTag) {
		m_mouseInside = YES;
		if(m_hided) 
			[self show];
	} else
		[super mouseEntered:theEvent];
}

- (void)mouseExited:(NSEvent *)theEvent {
	if([theEvent trackingNumber] == m_trackTag)
		m_mouseInside = NO;
	else
		[super mouseExited:theEvent];
}

- (void)setMainWindowController:(MainWindowController*)controller {
	[controller retain];
	[m_mainWindowController release];
	m_mainWindowController = controller;
}

- (void)setDockSide:(int)side {
	m_dockSide = side;
}

- (void)show {
	// calculate animation parameters
	NSWindow* window = [self window];
	m_animating = YES;
	NSRect startFrame = [window frame];
	NSRect endFrame = startFrame;
	switch(m_dockSide) {
		case kSideLeft:
			endFrame.origin.x = 0;
			break;
		case kSideRight:
			endFrame.origin.x = [[NSScreen mainScreen] frame].size.width - NSWidth(startFrame);
			break;
		case kSideBottom:
			endFrame.origin.y = 0;
			break;
		case kSideTop:
			endFrame.origin.y = [[NSScreen mainScreen] frame].size.height - NSHeight(startFrame);
			break;
	}
	
	// animiation
	m_animationType = _kAnimationShow;
	[AnimationHelper moveWindow:window
						   from:startFrame
							 to:endFrame
					   delegate:self];
}

#pragma mark -
#pragma mark animation delegate

- (void)animationDidEnd:(NSAnimation*)animation {
	m_animating = NO;
	switch(m_animationType) {
		case _kAnimationShow:
		case _kAnimationHide:
			m_hided = !m_hided;
			break;
	}
	
	m_animationType = -1;
}

@end
