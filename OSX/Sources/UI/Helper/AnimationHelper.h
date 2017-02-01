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


@interface AnimationHelper : NSObject {
	
}

+ (void)moveWindow:(NSWindow*)window from:(NSRect)fromFrame to:(NSRect)toFrame delegate:(id)delegate;
+ (void)moveWindow:(NSWindow*)window from:(NSRect)fromFrame to:(NSRect)toFrame fadeIn:(NSWindow*)fadeInWindow fadeOut:(NSWindow*)fadeOutWindow delegate:(id)delegate;
+ (void)moveWindow:(NSWindow*)window from:(NSRect)fromFrame to:(NSRect)toFrame fadeIn:(NSWindow*)fadeInWindow fadeOut:(NSWindow*)fadeOutWindow progressMark:(NSAnimationProgress)mark duration:(float)duration curve:(NSAnimationCurve)curve delegate:(id)delegate;
+ (void)moveView:(NSView*)view from:(NSRect)fromFrame to:(NSRect)toFrame delegate:(id)delegate;
+ (void)moveView:(NSView*)view from:(NSRect)fromFrame to:(NSRect)toFrame fadeIn:(NSView*)fadeInView fadeOut:(NSView*)fadeOutView delegate:(id)delegate;
+ (void)moveView:(NSView*)view from:(NSRect)fromFrame to:(NSRect)toFrame fadeIn:(NSView*)fadeInView fadeOut:(NSView*)fadeOutView progressMark:(NSAnimationProgress)mark duration:(float)duration curve:(NSAnimationCurve)curve delegate:(id)delegate;
+ (void)moveWindow:(NSWindow*)window from:(NSRect)fromFrame to:(NSRect)toFrame fadeIn:(NSView*)fadeInView delegate:(id)delegate;
+ (void)moveWindow:(NSWindow*)window from:(NSRect)fromFrame to:(NSRect)toFrame fadeIn:(NSView*)fadeInView progressMark:(NSAnimationProgress)mark duration:(float)duration curve:(NSAnimationCurve)curve delegate:(id)delegate;
+ (NSViewAnimation*)newAnimation:(float)duration curve:(NSAnimationCurve)curve;
+ (NSViewAnimation*)newAnimation;
+ (NSDictionary*)moveView:(NSView*)view from:(NSRect)fromFrame to:(NSRect)toFrame;

@end
