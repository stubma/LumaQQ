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

#import "GrabView.h"
#import "AnimationHelper.h"
#import "Constants.h"

#define _kOperationStroke 0
#define _kOperationMove 1
#define _kOperationResize 2

#define _kHandleSize 10.0

@implementation GrabView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        m_scrapRect.size.height = m_scrapRect.size.width = 0;
		m_oldScrapRect.size.height = m_oldScrapRect.size.width = 0;
    }
    return self;
}

- (void) dealloc {
	[m_hintWindow release];
	[super dealloc];
}

- (NSRect)scrapRect {
	return m_scrapRect;
}

- (void)drawRect:(NSRect)rect {
	NSGraphicsContext* context = [NSGraphicsContext currentContext];
	[context saveGraphicsState];
	
	// save old composite operation
	NSCompositingOperation oldCompOp = [context compositingOperation];
	
	// erase old rect
	if(NSWidth(m_oldScrapRect) >= 0 && NSHeight(m_oldScrapRect) >= 0) {
		[context setCompositingOperation:NSCompositeXOR];
		
		// erase old rect
		[[NSColor redColor] set];
		[NSBezierPath strokeRect:m_oldScrapRect];
		
		// erase old handle
		[[NSColor blueColor] set];
		[self drawHandles];
		
		[context setCompositingOperation:oldCompOp];
	}
	
	// draw new rect
	if(NSWidth(m_scrapRect) > 0 && NSHeight(m_scrapRect) > 0) {
		[[NSColor redColor] set];
		[NSBezierPath strokeRect:m_scrapRect];
		
		// draw handle
		[[NSColor blueColor] set];
		[self drawHandles];
	}
	
	[context restoreGraphicsState];
}

- (void)mouseMoved:(NSEvent *)theEvent {
	// get mouse loc
	m_mouse = [theEvent locationInWindow];
	
	// adjust location of hint window
	[self autoPositionHintWindow:m_mouse];
	
	// set cursor
	if(NSWidth(m_scrapRect) <= 0 || NSHeight(m_scrapRect) <= 0) {
		if([NSCursor currentCursor] != [NSCursor arrowCursor])
			[[NSCursor arrowCursor] set];
	} else {
		m_resizeHandle = [self testHandle:m_mouse];
		if(m_resizeHandle != 0) {
			if((m_resizeHandle & (kSideLeft | kSideRight)) != 0 &&
			   [NSCursor currentCursor] != [NSCursor resizeLeftRightCursor])
				[[NSCursor resizeLeftRightCursor] set];
			else if((m_resizeHandle & (kSideTop | kSideBottom)) != 0 &&
					[NSCursor currentCursor] != [NSCursor resizeUpDownCursor])
				[[NSCursor resizeUpDownCursor] set];
		} else if(NSPointInRect(m_mouse, m_scrapRect)) {
			if([NSCursor currentCursor] != [NSCursor openHandCursor])
				[[NSCursor openHandCursor] set];
		} else {
			if([NSCursor currentCursor] != [NSCursor arrowCursor])
				[[NSCursor arrowCursor] set];
		}
	}
}

- (void)rightMouseDown:(NSEvent *)theEvent {
	NSWindow* window = [self window];
	if(window) {
		if(NSWidth(m_scrapRect) <= 0 || NSHeight(m_scrapRect) <= 0)
			[window close];
		else {
			m_oldScrapRect = m_scrapRect;
			m_scrapRect.size.width = m_scrapRect.size.height = 0;
			[self refresh];
		}
	}
}

- (void)mouseDown:(NSEvent *)theEvent {
	NSWindow* window = [self window];
	if(window) {
		switch([theEvent clickCount]) {
			case 0:
				break;
			case 1:
				// get mouse loc
				m_anchor = [theEvent locationInWindow];
				
				// check operation type
				if(NSWidth(m_scrapRect) <= 0 || NSHeight(m_scrapRect) <= 0) {
					m_operation = _kOperationStroke;
				} else {
					m_resizeHandle = [self testHandle:m_anchor];
					if(m_resizeHandle != 0) {
						m_operation = _kOperationResize;
						m_backupRect = m_scrapRect;
					} else if(NSPointInRect(m_anchor, m_scrapRect)) {
						m_operation = _kOperationMove;
						m_backupRect = m_scrapRect;
					} else
						m_operation = _kOperationStroke;
				}					
				break;
			default:
				[window close];
				break;
		}
	}
}

- (void)mouseDragged:(NSEvent *)theEvent {
	NSWindow* window = [self window];
	if(window) {
		// get mouse location
		m_mouse = [theEvent locationInWindow];
		
		// save old rect
		m_oldScrapRect = m_scrapRect;
		
		// calculate new rect
		float dx = m_mouse.x - m_anchor.x;
		float dy = m_mouse.y - m_anchor.y;
		switch(m_operation) {
			case _kOperationStroke:
				m_scrapRect.origin.x = MIN(m_anchor.x, m_mouse.x);
				m_scrapRect.origin.y = MIN(m_anchor.y, m_mouse.y);
				m_scrapRect.size.width = ABS(dx);
				m_scrapRect.size.height = ABS(dy);
				break;
			case _kOperationMove:
				m_scrapRect.origin.x = m_backupRect.origin.x + dx;
				m_scrapRect.origin.y = m_backupRect.origin.y + dy;
				break;
			case _kOperationResize:
				if((m_resizeHandle & kSideLeft) != 0) {
					m_scrapRect.origin.x = m_backupRect.origin.x + dx;
					m_scrapRect.size.width = m_backupRect.size.width - dx;
				}				
				if((m_resizeHandle & kSideRight) != 0)
					m_scrapRect.size.width = m_backupRect.size.width + dx;
				if((m_resizeHandle & kSideBottom) != 0) {
					m_scrapRect.origin.y = m_backupRect.origin.y + dy;
					m_scrapRect.size.height = m_backupRect.size.height - dy;
				}
				if((m_resizeHandle & kSideTop) != 0)
				   m_scrapRect.size.height = m_backupRect.size.height + dy;
				break;
		}
		
		// validate
		m_scrapRect.size.width = MAX(m_scrapRect.size.width, 0);
		m_scrapRect.size.height = MAX(m_scrapRect.size.height, 0);
		
		// refresh
		[self refresh];
		
		// adjust location of hint window
		[self autoPositionHintWindow:m_mouse];
	}
}

- (void)mouseUp:(NSEvent *)theEvent {
	
}

- (void)keyDown:(NSEvent *)theEvent {
	NSWindow* window = [self window];
	if(window) {
		NSString* charString = [theEvent charactersIgnoringModifiers];
		if([charString length] >= 1) {		
			charString = [charString uppercaseString];
			UniChar keyChar = [charString characterAtIndex:0];
			
			// check escape key
			if(keyChar == 27)  { 
				if(NSWidth(m_scrapRect) <= 0 || NSHeight(m_scrapRect) <= 0)
					[window close];
				else {
					m_oldScrapRect = m_scrapRect;
					m_scrapRect.size.width = m_scrapRect.size.height = 0;
					[self refresh];
				}
			}
		}
	}
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

#pragma mark -
#pragma mark helper

- (void)refresh {
	NSRect unionRect = NSUnionRect(m_oldScrapRect, m_scrapRect);
	unionRect.origin.x -= _kHandleSize + 1;
	unionRect.origin.y -= _kHandleSize + 1;
	unionRect.size.height += _kHandleSize * 2 + 2;
	unionRect.size.width += _kHandleSize * 2 + 2;
	[self displayRect:unionRect];
}

- (void)autoPositionHintWindow:(NSPoint)mouse {
	if(m_hintWindow) {
		NSRect frame = [m_hintWindow frame];
		if(NSPointInRect(mouse, frame)) {
			// get screen frame
			NSRect screenFrame = [[NSScreen mainScreen] frame];
			
			// now, left or right?
			BOOL left = NSMinX(frame) < NSMaxX(screenFrame) - NSMaxX(frame);
			
			// change side to avoid overlap with mouse
			if(left)
				frame.origin.x = NSMaxX(screenFrame) - NSWidth(frame) - 50;
			else
				frame.origin.x = 50;
			
			// begin animation
			[AnimationHelper moveWindow:m_hintWindow
								   from:[m_hintWindow frame]
									 to:frame
							   delegate:self];
		}
	}
}

- (int)testHandle:(NSPoint)mouse {
	// test left bottom
	NSRect rect = NSMakeRect(m_scrapRect.origin.x - _kHandleSize, 
							 m_scrapRect.origin.y - _kHandleSize, 
							 _kHandleSize,
							 _kHandleSize);
	if(NSPointInRect(mouse, rect))
		return kSideLeft | kSideBottom;
	
	// test bottom
	rect.origin.x += NSWidth(m_scrapRect) / 2;
	rect.origin.x += _kHandleSize / 2;
	if(NSPointInRect(mouse, rect))
		return kSideBottom;
	
	// test right bottom
	rect.origin.x += NSWidth(m_scrapRect) / 2;
	rect.origin.x += _kHandleSize / 2;
	if(NSPointInRect(mouse, rect))
		return kSideRight | kSideBottom;
	
	// test right
	rect.origin.y += NSHeight(m_scrapRect) / 2;
	rect.origin.y += _kHandleSize / 2;
	if(NSPointInRect(mouse, rect))
		return kSideRight;
	
	// test right top
	rect.origin.y += NSHeight(m_scrapRect) / 2;
	rect.origin.y += _kHandleSize / 2;
	if(NSPointInRect(mouse, rect))
		return kSideRight | kSideTop;
	
	// test top
	rect.origin.x -= NSWidth(m_scrapRect) / 2;
	rect.origin.x -= _kHandleSize / 2;
	if(NSPointInRect(mouse, rect))
		return kSideTop;
	
	// test left top
	rect.origin.x -= NSWidth(m_scrapRect) / 2;
	rect.origin.x -= _kHandleSize / 2;
	if(NSPointInRect(mouse, rect))
		return kSideTop | kSideLeft;
	
	// test left
	rect.origin.y -= NSHeight(m_scrapRect) / 2;
	rect.origin.y -= _kHandleSize / 2;
	if(NSPointInRect(mouse, rect))
		return kSideLeft;
	
	return 0;
}

- (void)drawHandles {
	// draw left bottom
	NSRect rect = NSMakeRect(m_scrapRect.origin.x - _kHandleSize, 
							 m_scrapRect.origin.y - _kHandleSize, 
							 _kHandleSize,
							 _kHandleSize);
	[NSBezierPath fillRect:rect];
	
	// draw bottom
	rect.origin.x += NSWidth(m_scrapRect) / 2;
	rect.origin.x += _kHandleSize / 2;
	[NSBezierPath fillRect:rect];
	
	// draw right bottom
	rect.origin.x += NSWidth(m_scrapRect) / 2;
	rect.origin.x += _kHandleSize / 2;
	[NSBezierPath fillRect:rect];
	
	// draw right
	rect.origin.y += NSHeight(m_scrapRect) / 2;
	rect.origin.y += _kHandleSize / 2;
	[NSBezierPath fillRect:rect];
	
	// draw right top
	rect.origin.y += NSHeight(m_scrapRect) / 2;
	rect.origin.y += _kHandleSize / 2;
	[NSBezierPath fillRect:rect];
	
	// draw top
	rect.origin.x -= NSWidth(m_scrapRect) / 2;
	rect.origin.x -= _kHandleSize / 2;
	[NSBezierPath fillRect:rect];
	
	// draw left top
	rect.origin.x -= NSWidth(m_scrapRect) / 2;
	rect.origin.x -= _kHandleSize / 2;
	[NSBezierPath fillRect:rect];
	
	// draw left
	rect.origin.y -= NSHeight(m_scrapRect) / 2;
	rect.origin.y -= _kHandleSize / 2;
	[NSBezierPath fillRect:rect];
}

#pragma mark -
#pragma mark API

- (void)setHintWindow:(NSWindow*)hintWindow {
	[hintWindow retain];
	[m_hintWindow release];
	m_hintWindow = hintWindow;
}

#pragma mark -
#pragma mark animation delegate

- (void)animationDidEnd:(NSAnimation *)animation {
}

@end
