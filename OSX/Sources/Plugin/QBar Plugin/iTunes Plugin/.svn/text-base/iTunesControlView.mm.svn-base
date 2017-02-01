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

#import "iTunesControlView.h"
#import "iTunesQBar.h"

#define _kImageHeight 13
#define _kImageWidth 12

@implementation iTunesControlView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        m_playing = NO;
		m_playPauseState = m_stopState = m_nextState = m_previousState = kStateNormal;
		m_playPauseTag = m_stopTag = m_nextTag = m_previousTag = 0;
		m_playPauseTipTag = m_stopTipTag = m_nextTipTag = m_previousTipTag = 0;
		
		[self setAutoresizesSubviews:YES];
    }
    return self;
}

- (void)resetCursorRects {
	if(m_playPauseTag != 0) {
		[self removeTrackingRect:m_playPauseTag];
		[self removeToolTip:m_playPauseTipTag];
		[self removeTrackingRect:m_stopTag];
		[self removeToolTip:m_stopTipTag];
		[self removeTrackingRect:m_nextTag];
		[self removeToolTip:m_nextTipTag];
		[self removeTrackingRect:m_previousTag];
		[self removeToolTip:m_previousTipTag];
		
		m_playPauseTag = m_stopTag = m_nextTag = m_previousTag = 0;
		m_playPauseTipTag = m_stopTipTag = m_nextTipTag = m_previousTipTag = 0;
	}
	if(m_playPauseTag == 0) {
		NSRect frame = [self frame];
		
		// register tracking area
		NSRect rect = NSMakeRect(0, NSHeight(frame) - _kImageHeight, _kImageWidth, _kImageHeight);
		m_playPauseTag = [self addTrackingRect:rect
										 owner:self
									  userData:nil
								  assumeInside:NO];
		m_playPauseTipTag = [self addToolTipRect:rect
										   owner:self
										userData:[iTunesQBar bundleString:@"LQTooltipPlayPause"]];
		
		rect = NSMakeRect(NSWidth(frame) - _kImageWidth, NSHeight(frame) - _kImageHeight, _kImageWidth, _kImageHeight);
		m_stopTag = [self addTrackingRect:rect
									owner:self
								 userData:nil
							 assumeInside:NO];
		m_stopTipTag = [self addToolTipRect:rect
									  owner:self
								   userData:[iTunesQBar bundleString:@"LQTooltipStop"]];
		
		rect = NSMakeRect(0, 0, _kImageWidth, _kImageHeight);
		m_previousTag = [self addTrackingRect:rect
										owner:self
									 userData:nil
								 assumeInside:NO];
		m_previousTipTag = [self addToolTipRect:rect
										  owner:self
									   userData:[iTunesQBar bundleString:@"LQTooltipPreviousTrack"]];
		
		rect = NSMakeRect(NSWidth(frame) - _kImageWidth, 0, _kImageWidth, _kImageHeight);
		m_nextTag = [self addTrackingRect:rect
									owner:self
								 userData:nil
							 assumeInside:NO];
		m_nextTipTag = [self addToolTipRect:rect
									  owner:self
								   userData:[iTunesQBar bundleString:@"LQTooltipNextTrack"]];		
	}
}

- (void)drawRect:(NSRect)rect {
	NSRect frame = [self frame];
	// draw play/pause button
	NSImage* image = nil;
	if(m_playPauseState == kStateNormal)
		image = [self imageNamed:(m_playing ? kImagePause : kImagePlay)];
	else if(m_playPauseState == kStateRollover)
		image = [self imageNamed:(m_playing ? kImagePauseRollover : kImagePlayRollover)];
	else
		image = [self imageNamed:(m_playing ? kImagePausePressed : kImagePlayPressed)];
	[image compositeToPoint:NSMakePoint(0, NSHeight(frame) - _kImageHeight) operation:NSCompositeSourceOver];
	
	// draw stop button
	if(m_stopState == kStateNormal)
		image = [self imageNamed:kImageStop];
	else if(m_stopState == kStateRollover)
		image = [self imageNamed:kImageStopRollover];
	else
		image = [self imageNamed:kImageStopPressed];
	[image compositeToPoint:NSMakePoint(NSWidth(frame) - _kImageWidth, NSHeight(frame) - _kImageHeight) operation:NSCompositeSourceOver];
	
	// draw previous button
	if(m_previousState == kStateNormal)
		image = [self imageNamed:kImagePrevious];
	else if(m_previousState == kStateRollover)
		image = [self imageNamed:kImagePreviousRollover];
	else
		image = [self imageNamed:kImagePreviousPressed];
	[image compositeToPoint:NSZeroPoint operation:NSCompositeSourceOver];
	
	// draw next button
	if(m_nextState == kStateNormal)
		image = [self imageNamed:kImageNext];
	else if(m_nextState == kStateRollover)
		image = [self imageNamed:kImageNextRollover];
	else
		image = [self imageNamed:kImageNextPressed];
	[image compositeToPoint:NSMakePoint(NSWidth(frame) - _kImageWidth, 0) operation:NSCompositeSourceOver];
}

- (void)mouseEntered:(NSEvent *)theEvent {	
	if([theEvent trackingNumber] == m_playPauseTag) {
		m_playPauseState = kStateRollover;
		[self setNeedsDisplay:YES];
	} else if([theEvent trackingNumber] == m_stopTag) {
		m_stopState = kStateRollover;
		[self setNeedsDisplay:YES];
	} else if([theEvent trackingNumber] == m_previousTag) {
		m_previousState = kStateRollover;
		[self setNeedsDisplay:YES];
	} else if([theEvent trackingNumber] == m_nextTag) {
		m_nextState = kStateRollover;
		[self setNeedsDisplay:YES];
	}
}

- (void)mouseExited:(NSEvent *)theEvent {
	if([theEvent trackingNumber] == m_playPauseTag) {
		m_playPauseState = kStateNormal;
		[self setNeedsDisplay:YES];
	} else if([theEvent trackingNumber] == m_stopTag) {
		m_stopState = kStateNormal;
		[self setNeedsDisplay:YES];
	} else if([theEvent trackingNumber] == m_previousTag) {
		m_previousState = kStateNormal;
		[self setNeedsDisplay:YES];
	} else if([theEvent trackingNumber] == m_nextTag) {
		m_nextState = kStateNormal;
		[self setNeedsDisplay:YES];
	}
}

- (void)mouseDown:(NSEvent *)theEvent {
	NSPoint loc = [theEvent locationInWindow];
	loc = [self convertPoint:loc fromView:nil];
	NSRect frame = [self frame];
	if(NSPointInRect(loc, NSMakeRect(0, NSHeight(frame) - _kImageHeight, _kImageWidth, _kImageHeight))) {
		m_playPauseState = kStatePressed;
		[self setNeedsDisplay:YES];
	} else if(NSPointInRect(loc, NSMakeRect(NSWidth(frame) - _kImageWidth, NSHeight(frame) - _kImageHeight, _kImageWidth, _kImageHeight))) {
		m_stopState = kStatePressed;
		[self setNeedsDisplay:YES];
	} else if(NSPointInRect(loc, NSMakeRect(0, 0, _kImageWidth, _kImageHeight))) {
		m_previousState = kStatePressed;
		[self setNeedsDisplay:YES];
	} else if(NSPointInRect(loc, NSMakeRect(NSWidth(frame) - _kImageWidth, 0, _kImageWidth, _kImageHeight))) {
		m_nextState = kStatePressed;
		[self setNeedsDisplay:YES];
	}
}

- (void)mouseUp:(NSEvent *)theEvent {
	if(m_playPauseState == kStatePressed ||
	   m_stopState == kStatePressed ||
	   m_previousState == kStatePressed ||
	   m_nextState == kStatePressed) {
		if([iTunesQBar isiTunesLaunched]) {
			if(m_playPauseState == kStatePressed) {
				BOOL ret = YES;
				if(m_playing)
					ret = [self executeScript:@"tell app \"iTunes\" to pause"];
				else
					ret = [self executeScript:@"tell app \"iTunes\" to play"];
				if(ret)
					[self setPlaying:!m_playing];
			} else if(m_stopState == kStatePressed) {
				[self executeScript:@"tell app \"iTunes\" to stop"];
				[self setPlaying:NO];
			} else if(m_previousState == kStatePressed) {
				[self executeScript:@"tell app \"iTunes\" to previous track"];
				if(!m_playing) {
					if([self executeScript:@"tell app \"iTunes\" to play"])
						m_playing = YES;
				}
			} else if(m_nextState == kStatePressed) {
				[self executeScript:@"tell app \"iTunes\" to next track"];
				if(!m_playing) {
					if([self executeScript:@"tell app \"iTunes\" to play"])
						m_playing = YES;
				}
			}
		}
		
		m_playPauseState = m_stopState = m_nextState = m_previousState = kStateNormal;
		[self setNeedsDisplay:YES];
	}
}

- (NSImage*)imageNamed:(NSString*)name {
	NSBundle* bundle = [NSBundle bundleForClass:[self class]];
	return [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:name]] autorelease];
}

- (BOOL)executeScript:(NSString*)script {
	NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:script];
	BOOL ret = [scriptObject executeAndReturnError:nil] != nil;
	[scriptObject release];
	return ret;
}

- (NSString *)view:(NSView *)view stringForToolTip:(NSToolTipTag)tag point:(NSPoint)point userData:(void *)userData {
	return (NSString*)userData;
}

- (void)setPlaying:(BOOL)value {
	m_playing = value;
	[self setNeedsDisplay:YES];
}

@end
