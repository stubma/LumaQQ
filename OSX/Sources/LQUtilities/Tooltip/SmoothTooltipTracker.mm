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

#import "SmoothTooltipTracker.h"
#import "SmoothTooltipTrackerDelegate.h"
#import "Constants.h"

#define TOOL_TIP_CHECK_INTERVAL			45.0	//Check for mouse X times a second
#define DEFAULT_TOOL_TIP_DELAY			35.0	//Number of check intervals of no movement before a tip is displayed

@implementation SmoothTooltipTracker

+ (SmoothTooltipTracker *)smoothTooltipTrackerForView:(NSView *)inView withDelegate:(id)inDelegate {
	return [[[self alloc] initForView:inView withDelegate:inDelegate] autorelease];
}

- (SmoothTooltipTracker *)initForView:(NSView *)inView withDelegate:(id)inDelegate {
	if ((self = [super init])) {
		view = [inView retain];
		delegate = inDelegate;
		tooltipTrackingTag = -1;
		tooltipLocation = NSZeroPoint;
		m_tooltipDelay = DEFAULT_TOOL_TIP_DELAY;

		//Reset cursor tracking when the view's frame changes
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(resetCursorTracking)
													 name:NSViewFrameDidChangeNotification
												   object:view];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(resetCursorTracking)
													 name:kMainToolbarToggledVisibilityNotificationName
												   object:[view window]];

		[self installCursorRect];
	}
	
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[self removeCursorRect];
	[self _stopTrackingMouse];

	[view release]; 
	view = nil;
	
	[super dealloc];
}

- (void)setDelegate:(id)inDelegate {
	if (delegate != inDelegate) {
		[self _stopTrackingMouse];
		
		delegate = inDelegate;
	}
}

- (void)viewWillBeRemovedFromWindow {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kMainToolbarToggledVisibilityNotificationName
												  object:[view window]];
	
	[self removeCursorRect];
	[self _stopTrackingMouse];
}

- (void)viewWasAddedToWindow {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(resetCursorTracking)
												 name:kMainToolbarToggledVisibilityNotificationName
											   object:[view window]];
	
	[self installCursorRect];
}

- (void)installCursorRect {
	if (tooltipTrackingTag == -1) {
		NSRect	 		trackingRect;
		BOOL			mouseInside;
		
		//Add a new tracking rect
		trackingRect = [view frame];
		trackingRect.origin = NSMakePoint(0,0);
		
		mouseInside = NSPointInRect([view convertPoint:[[view window] convertScreenToBase:[NSEvent mouseLocation]] fromView:[[view window] contentView]],
									trackingRect);
		tooltipTrackingTag = [view addTrackingRect:trackingRect owner:self userData:nil assumeInside:mouseInside];
		
		//If the mouse is already inside, begin tracking the mouse immediately
		if (mouseInside) 
			[self _startTrackingMouse];
	}
}

- (void)removeCursorRect {
	if (tooltipTrackingTag != -1) {
		[view removeTrackingRect:tooltipTrackingTag];
		tooltipTrackingTag = -1;
		[self _stopTrackingMouse];		
	}
}

- (void)resetCursorTracking {
	[self removeCursorRect];
	[self installCursorRect];
}

- (void)mouseEntered:(NSEvent *)theEvent {
	[self _startTrackingMouse];
}

- (void)mouseExited:(NSEvent *)theEvent {
	[self _stopTrackingMouse];
}

- (void)_startTrackingMouse {
	if (!tooltipMouseLocationTimer) {
		tooltipCount = 0;
		tooltipMouseLocationTimer = [[NSTimer scheduledTimerWithTimeInterval:(1.0 / TOOL_TIP_CHECK_INTERVAL)
																	  target:self
																	selector:@selector(mouseMovementTimer:)
																	userInfo:nil
																	 repeats:YES] retain];
	}
}

- (void)_stopTrackingMouse {
	//Invalidate tracking
	if (tooltipMouseLocationTimer) {
		//Hide the tooltip before releasing the timer, as the timer may be the last object retaining self
		//and we want to communicate with the delegate before a potential call to dealloc.
		[self _hideTooltip];
		
		NSTimer* theTimer = tooltipMouseLocationTimer;
		tooltipMouseLocationTimer = nil;
		
		[theTimer invalidate];
		[theTimer release]; 
		theTimer = nil;
	}
}

- (void)_hideTooltip {
	tooltipCount = 0;

	//If the tooltip was being shown before, hide it
	if (!NSEqualPoints(tooltipLocation,NSZeroPoint)) {
		lastMouseLocation = NSZeroPoint;
		tooltipLocation = NSZeroPoint;
		
		//Hide tooltip
		[delegate hideTooltip];
	}
}

- (void)mouseMovementTimer:(NSTimer *)inTimer {
	NSPoint		mouseLocation = [NSEvent mouseLocation];
	NSWindow	*theWindow = [view window];
	
	if ([theWindow isVisible] && 
	   NSPointInRect([theWindow convertScreenToBase:mouseLocation],[[theWindow contentView] convertRect:[view frame] fromView:[view superview]])) {
		//tooltipCount is used for delaying the appearence of tooltips.  We reset it to 0 when the mouse moves.  When
		//the mouse is left still tooltipCount will eventually grow greater than TOOL_TIP_DELAY, and we will begin
		//displaying the tooltips
		if (tooltipCount > m_tooltipDelay) {
			if (!NSEqualPoints(tooltipLocation, mouseLocation)) {
				[delegate showTooltipAtPoint:mouseLocation];
				tooltipLocation = mouseLocation;
			}			
		} else {
			if (!NSEqualPoints(mouseLocation,lastMouseLocation)) {
				lastMouseLocation = mouseLocation;
				tooltipCount = 0; //reset tooltipCount to 0 since the mouse has moved
			} else {
				tooltipCount++;
			}
		}
	} else {
		//If the cursor has left our frame or the window is no logner visible, manually hide the tooltip.
		//This protects us in the cases where we do not receive a mouse exited message; we don't stop tracking
		//because we could reenter the tracking area without receiving a mouseEntered: message.
		[self _hideTooltip];
	}
}

- (void)setTooltipDelay:(float)tooltipDelay {
	m_tooltipDelay = tooltipDelay;
}

@end
