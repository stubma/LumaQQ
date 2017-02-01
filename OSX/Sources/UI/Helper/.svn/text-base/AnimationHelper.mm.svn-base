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

#import "AnimationHelper.h"


@implementation AnimationHelper

+ (void)moveWindow:(NSWindow*)window from:(NSRect)fromFrame to:(NSRect)toFrame delegate:(id)delegate {
	[self moveWindow:window
				from:fromFrame
				  to:toFrame
			  fadeIn:nil
			 fadeOut:nil
		progressMark:1
			duration:0.25
			   curve:NSAnimationEaseIn
			delegate:delegate];
}

+ (void)moveWindow:(NSWindow*)window from:(NSRect)fromFrame to:(NSRect)toFrame fadeIn:(NSWindow*)fadeInWindow fadeOut:(NSWindow*)fadeOutWindow delegate:(id)delegate {
	[self moveWindow:window
				from:fromFrame
				  to:toFrame
			  fadeIn:fadeInWindow
			 fadeOut:fadeOutWindow
		progressMark:1
			duration:0.25
			   curve:NSAnimationEaseIn
			delegate:delegate];
}

+ (void)moveWindow:(NSWindow*)window from:(NSRect)fromFrame to:(NSRect)toFrame fadeIn:(NSWindow*)fadeInWindow fadeOut:(NSWindow*)fadeOutWindow progressMark:(NSAnimationProgress)mark duration:(float)duration curve:(NSAnimationCurve)curve delegate:(id)delegate {
	NSViewAnimation* animation = [[NSViewAnimation alloc] initWithDuration:duration
															animationCurve:curve];
	[animation setDelegate:delegate];
	
	NSDictionary* fadeInDict = nil;
	if(fadeInWindow != nil) {
		fadeInDict = [NSDictionary dictionaryWithObjectsAndKeys:
			fadeInWindow,
			NSViewAnimationTargetKey,
			NSViewAnimationFadeInEffect,
			NSViewAnimationEffectKey,
			nil];
	}
	
	NSDictionary* fadeOutDict = nil;
	if(fadeOutWindow != nil) {
		fadeOutDict = [NSDictionary dictionaryWithObjectsAndKeys:
			fadeOutWindow,
			NSViewAnimationTargetKey,
			NSViewAnimationFadeOutEffect,
			NSViewAnimationEffectKey,
			nil];
	}
	
	NSDictionary* moveDict = nil;
	if(window != nil) {
		moveDict = [NSDictionary dictionaryWithObjectsAndKeys:
			window,
			NSViewAnimationTargetKey,
			[NSValue valueWithRect:fromFrame],
			NSViewAnimationStartFrameKey,
			[NSValue valueWithRect:toFrame],
			NSViewAnimationEndFrameKey,
			nil];
	}
	
	if(fadeInDict || fadeOutDict || moveDict) {
		NSMutableArray* effect = [NSMutableArray array];
		if(fadeInDict)
			[effect addObject:fadeInDict];
		if(fadeOutDict)
			[effect addObject:fadeOutDict];
		if(moveDict)
			[effect addObject:moveDict];
		
		[animation setViewAnimations:effect];
		if(mark != 1.0)
			[animation addProgressMark:mark];
		
		[animation startAnimation];
	}
	
	[animation release];
}

+ (void)moveView:(NSView*)view from:(NSRect)fromFrame to:(NSRect)toFrame delegate:(id)delegate {
	[self moveView:view
			  from:fromFrame
				to:toFrame
			fadeIn:nil
		   fadeOut:nil
	  progressMark:1
		  duration:0.25
			 curve:NSAnimationEaseIn
		  delegate:delegate];
}

+ (void)moveView:(NSView*)view from:(NSRect)fromFrame to:(NSRect)toFrame fadeIn:(NSView*)fadeInView fadeOut:(NSView*)fadeOutView delegate:(id)delegate {
	[self moveView:view
			  from:fromFrame
				to:toFrame
			fadeIn:fadeInView
		   fadeOut:fadeOutView
	  progressMark:1
		  duration:0.25
			 curve:NSAnimationEaseIn
		  delegate:delegate];
}

+ (void)moveView:(NSView*)view from:(NSRect)fromFrame to:(NSRect)toFrame fadeIn:(NSView*)fadeInView fadeOut:(NSView*)fadeOutView progressMark:(NSAnimationProgress)mark duration:(float)duration curve:(NSAnimationCurve)curve delegate:(id)delegate {
	NSViewAnimation* animation = [[NSViewAnimation alloc] initWithDuration:duration
															animationCurve:curve];
	[animation setDelegate:delegate];
	
	NSDictionary* fadeInDict = nil;
	if(fadeInView != nil) {
		fadeInDict = [NSDictionary dictionaryWithObjectsAndKeys:
			fadeInView,
			NSViewAnimationTargetKey,
			NSViewAnimationFadeInEffect,
			NSViewAnimationEffectKey,
			nil];
	}
	
	NSDictionary* fadeOutDict = nil;
	if(fadeOutView != nil) {
		fadeOutDict = [NSDictionary dictionaryWithObjectsAndKeys:
			fadeOutView,
			NSViewAnimationTargetKey,
			NSViewAnimationFadeOutEffect,
			NSViewAnimationEffectKey,
			nil];
	}
	
	NSDictionary* moveDict = nil;
	if(view != nil) {
		moveDict = [NSDictionary dictionaryWithObjectsAndKeys:
			view,
			NSViewAnimationTargetKey,
			[NSValue valueWithRect:fromFrame],
			NSViewAnimationStartFrameKey,
			[NSValue valueWithRect:toFrame],
			NSViewAnimationEndFrameKey,
			nil];
	}
	
	if(fadeInDict || fadeOutDict || moveDict) {
		NSMutableArray* effect = [NSMutableArray array];
		if(fadeInDict)
			[effect addObject:fadeInDict];
		if(fadeOutDict)
			[effect addObject:fadeOutDict];
		if(moveDict)
			[effect addObject:moveDict];
		
		[animation setViewAnimations:effect];
		if(mark != 1.0)
			[animation addProgressMark:mark];
		
		[animation startAnimation];
	}
	
	[animation release];
}

+ (void)moveWindow:(NSWindow*)window from:(NSRect)fromFrame to:(NSRect)toFrame fadeIn:(NSView*)fadeInView delegate:(id)delegate {
	[self moveWindow:window
				from:fromFrame
				  to:toFrame
			  fadeIn:fadeInView
		progressMark:1
			duration:0.25
			   curve:NSAnimationEaseIn
			delegate:delegate];
}

+ (void)moveWindow:(NSWindow*)window from:(NSRect)fromFrame to:(NSRect)toFrame fadeIn:(NSView*)fadeInView progressMark:(NSAnimationProgress)mark duration:(float)duration curve:(NSAnimationCurve)curve delegate:(id)delegate {
	NSViewAnimation* animation = [[NSViewAnimation alloc] initWithDuration:duration
															animationCurve:curve];
	[animation setDelegate:delegate];
	
	NSDictionary* moveDict = nil;
	if(window != nil) {
		moveDict = [NSDictionary dictionaryWithObjectsAndKeys:
			window,
			NSViewAnimationTargetKey,
			[NSValue valueWithRect:fromFrame],
			NSViewAnimationStartFrameKey,
			[NSValue valueWithRect:toFrame],
			NSViewAnimationEndFrameKey,
			nil];
	}
	
	NSDictionary* fadeInDict = nil;
	if(fadeInView != nil) {
		fadeInDict = [NSDictionary dictionaryWithObjectsAndKeys:
			fadeInView,
			NSViewAnimationTargetKey,
			NSViewAnimationFadeInEffect,
			NSViewAnimationEffectKey,
			nil];
	}
	
	if(fadeInDict || moveDict) {
		NSMutableArray* effect = [NSMutableArray array];
		if(fadeInDict)
			[effect addObject:fadeInDict];
		if(moveDict)
			[effect addObject:moveDict];
		
		[animation setViewAnimations:effect];
		if(mark != 1.0)
			[animation addProgressMark:mark];
		
		[animation startAnimation];
	}
	
	[animation release];
}

+ (NSViewAnimation*)newAnimation:(float)duration curve:(NSAnimationCurve)curve {
	return [[[NSViewAnimation alloc] initWithDuration:duration animationCurve:curve] autorelease];
}

+ (NSViewAnimation*)newAnimation {
	return [self newAnimation:0.25 curve:NSAnimationEaseIn];
}

+ (NSDictionary*)moveView:(NSView*)view from:(NSRect)fromFrame to:(NSRect)toFrame {
	NSDictionary* moveDict = nil;
	if(view != nil) {
		moveDict = [NSDictionary dictionaryWithObjectsAndKeys:
			view,
			NSViewAnimationTargetKey,
			[NSValue valueWithRect:fromFrame],
			NSViewAnimationStartFrameKey,
			[NSValue valueWithRect:toFrame],
			NSViewAnimationEndFrameKey,
			nil];
	}
	return moveDict;	
}

@end
