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

#import <Cocoa/Cocoa.h>

#define kImagePlay @"play.png"
#define kImagePlayRollover @"play_rollover.png"
#define kImagePlayPressed @"play_pressed.png"
#define kImagePause @"pause.png"
#define kImagePauseRollover @"pause_rollover.png"
#define kImagePausePressed @"pause_pressed.png"
#define kImageStop @"stop.png"
#define kImageStopRollover @"stop_rollover.png"
#define kImageStopPressed @"stop_pressed.png"
#define kImageNext @"next.png"
#define kImageNextRollover @"next_rollover.png"
#define kImageNextPressed @"next_pressed.png"
#define kImagePrevious @"previous.png"
#define kImagePreviousRollover @"previous_rollover.png"
#define kImagePreviousPressed @"previous_pressed.png"

#define kStateNormal 0
#define kStateRollover 1
#define kStatePressed 2

@interface iTunesControlView : NSView {
	NSTrackingRectTag m_playPauseTag;
	NSTrackingRectTag m_stopTag;
	NSTrackingRectTag m_nextTag;
	NSTrackingRectTag m_previousTag;
	
	NSToolTipTag m_playPauseTipTag;
	NSToolTipTag m_stopTipTag;
	NSToolTipTag m_nextTipTag;
	NSToolTipTag m_previousTipTag;
	
	int m_playPauseState;
	int m_stopState;
	int m_nextState;
	int m_previousState;
	
	BOOL m_playing;
}

// helper
- (NSImage*)imageNamed:(NSString*)name;
- (BOOL)executeScript:(NSString*)script;

- (void)setPlaying:(BOOL)value;

@end
