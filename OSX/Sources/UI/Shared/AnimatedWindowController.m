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

#import "AnimatedWindowController.h"

#define WINDOW_TITLE_AND_TOOLBAR_HEIGHT 78

@implementation AnimatedWindowController

#pragma mark -
#pragma mark init

- (id)init {
	self = [super initWithWindowNibName:[self windowNibName]];
	if (self != nil) {
		// Set up an array and some dictionaries to keep track
		// of the views we'll be displaying.
		m_toolItemIdentifiers = [[NSMutableArray alloc] init];
		m_toolbarViews = [[NSMutableDictionary alloc] init];
		m_toolbarItems = [[NSMutableDictionary alloc] init];

		// Set up an NSm_viewAnimation to animate the transitions.
		m_viewAnimation = [[NSViewAnimation alloc] init];
		[m_viewAnimation setAnimationBlockingMode:NSAnimationNonblocking];
		[m_viewAnimation setAnimationCurve:NSAnimationEaseInOut];
		[m_viewAnimation setDelegate:self];
		
		[self setCrossFade:YES]; 
		[self setShiftSlowsAnimation:YES];
	}
	return self;
}

- (void)windowDidLoad {
	// Create a new window to display the preference views.
	// If the developer attached a window to this controller
	// in Interface Builder, it gets replaced with this one.
	NSWindow *window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 500, 500)
												   styleMask:(NSTitledWindowMask |
															  NSClosableWindowMask |
															  NSMiniaturizableWindowMask)
													 backing:NSBackingStoreBuffered
													   defer:YES];
	[self setWindow:window];
	[window setDelegate:self];
	m_contentSubview = [[NSView alloc] initWithFrame:[[[self window] contentView] frame]];
	[m_contentSubview setAutoresizingMask:(NSViewMinYMargin | NSViewWidthSizable)];
	[[[self window] contentView] addSubview:m_contentSubview];
	[[self window] setShowsToolbarButton:NO];
	[[self window] center];
	[m_contentSubview release];
	[window release];
}

- (void) dealloc {
	[m_toolItemIdentifiers release];
	[m_toolbarItems release];
	[m_toolbarViews release];
	[m_viewAnimation release];
	[super dealloc];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	[self release];
}

#pragma mark -
#pragma mark Configuration

- (BOOL)autoChangeWindowTitle {
	return NO;
}

- (void)setupToolbar {
	// Subclasses must override this method to add items to the
	// toolbar by calling -addView:label: or -addView:label:image:.
}

- (NSString*)toolbarIdentifier {
	return @"PreferenceToolbar";
}

- (void)addView:(NSView *)view label:(NSString *)label {
	[self addView:view
			label:label
			image:[NSImage imageNamed:label]];
}

- (void)addView:(NSView *)view label:(NSString *)label image:(NSImage *)image {
	NSAssert (view != nil,
			  @"Attempted to add a nil view when calling -addView:label:image:.");
	
	NSString *identifier = [label copy];
	
	[m_toolItemIdentifiers addObject:identifier];
	[m_toolbarViews setObject:view forKey:identifier];
	
	NSToolbarItem *item = [[[NSToolbarItem alloc] initWithItemIdentifier:identifier] autorelease];
	[item setLabel:label];
	[item setImage:image];
	[item setTarget:self];
	[item setAction:@selector(toggleActivePreferenceView:)];
	
	[m_toolbarItems setObject:item forKey:identifier];
}

#pragma mark -
#pragma mark Accessor Methods

- (BOOL)crossFade {
    return m_crossFade;
}

- (void)setCrossFade:(BOOL)fade {
    m_crossFade = fade;
}

- (BOOL)shiftSlowsAnimation {
    return m_shiftSlowsAnimation;
}

- (void)setShiftSlowsAnimation:(BOOL)slows {
    m_shiftSlowsAnimation = slows;
}

#pragma mark -
#pragma mark Overriding Methods

- (IBAction)showWindow:(id)sender {
	// This forces the resources in the nib to load.
	[self window];

	// Clear the last setup and get a fresh one.
	[m_toolItemIdentifiers removeAllObjects];
	[m_toolbarViews removeAllObjects];
	[m_toolbarItems removeAllObjects];
	[self setupToolbar];

	NSAssert (([m_toolItemIdentifiers count] > 0),
			  @"No items were added to the toolbar in -setupToolbar.");
	
	if ([[self window] toolbar] == nil) {
		NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:[self toolbarIdentifier]];
		[toolbar setAllowsUserCustomization:NO];
		[toolbar setSizeMode:NSToolbarSizeModeDefault];
		[toolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
		[toolbar setDelegate:self];
		[[self window] setToolbar:toolbar];
		[toolbar release];
	}
	
	NSString *firstIdentifier = [m_toolItemIdentifiers objectAtIndex:0];
	[[[self window] toolbar] setSelectedItemIdentifier:firstIdentifier];
	[self displayViewForIdentifier:firstIdentifier animate:NO];
	
	[super showWindow:sender];
}

#pragma mark -
#pragma mark Toolbar

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar {
	return m_toolItemIdentifiers;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar {
	return m_toolItemIdentifiers;
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
	return m_toolItemIdentifiers;
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)identifier willBeInsertedIntoToolbar:(BOOL)willBeInserted {
	return [m_toolbarItems objectForKey:identifier];
}

- (void)toggleActivePreferenceView:(NSToolbarItem *)toolbarItem {
	[self displayViewForIdentifier:[toolbarItem itemIdentifier] animate:YES];
}

- (void)displayViewForIdentifier:(NSString *)identifier animate:(BOOL)animate {	
	// Find the view we want to display.
	NSView *newView = [m_toolbarViews objectForKey:identifier];

	// See if there are any visible views.
	NSView *oldView = nil;
	if ([[m_contentSubview subviews] count] > 0) {
		// Get a list of all of the views in the window. Usually at this
		// point there is just one visible view. But if the last fade
		// hasn't finished, we need to get rid of it now before we move on.
		NSEnumerator *subviewsEnum = [[m_contentSubview subviews] reverseObjectEnumerator];
		
		// The first one (last one added) is our visible view.
		oldView = [subviewsEnum nextObject];
		
		// Remove any others.
		NSView *reallyOldView = nil;
		while (reallyOldView = [subviewsEnum nextObject]) {
			[reallyOldView removeFromSuperviewWithoutNeedingDisplay];
		}
	}
	
	if (![newView isEqualTo:oldView]) {		
		NSRect frame = [newView bounds];
		frame.origin.y = [m_contentSubview frame].size.height - [newView bounds].size.height;
		[newView setFrame:frame];
		[m_contentSubview addSubview:newView];
		[[self window] setInitialFirstResponder:newView];

		if (animate && [self crossFade])
			[self crossFadeView:oldView withView:newView];
		else {
			[oldView removeFromSuperviewWithoutNeedingDisplay];
			[newView setHidden:NO];
			[[self window] setFrame:[self frameForView:newView] display:YES animate:animate];
		}
		
		if([self autoChangeWindowTitle])
			[[self window] setTitle:[[m_toolbarItems objectForKey:identifier] label]];
	}
}

#pragma mark -
#pragma mark Cross-Fading Methods

- (void)crossFadeView:(NSView *)oldView withView:(NSView *)newView {
	[m_viewAnimation stopAnimation];
	
    if ([self shiftSlowsAnimation] && [[[self window] currentEvent] modifierFlags] & NSShiftKeyMask)
		[m_viewAnimation setDuration:1.25];
    else
		[m_viewAnimation setDuration:0.25];
	
	NSDictionary *fadeOutDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
		oldView, NSViewAnimationTargetKey,
		NSViewAnimationFadeOutEffect, NSViewAnimationEffectKey,
		nil];

	NSDictionary *fadeInDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
		newView, NSViewAnimationTargetKey,
		NSViewAnimationFadeInEffect, NSViewAnimationEffectKey,
		nil];

	NSDictionary *resizeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
		[self window], NSViewAnimationTargetKey,
		[NSValue valueWithRect:[[self window] frame]], NSViewAnimationStartFrameKey,
		[NSValue valueWithRect:[self frameForView:newView]], NSViewAnimationEndFrameKey,
		nil];
	
	NSArray *animationArray = [NSArray arrayWithObjects:
		fadeOutDictionary,
		fadeInDictionary,
		resizeDictionary,
		nil];
	
	[m_viewAnimation setViewAnimations:animationArray];
	[m_viewAnimation startAnimation];
}

- (void)animationDidEnd:(NSAnimation *)animation {
	NSView *subview;
	
	// Get a list of all of the views in the window. Hopefully
	// at this point there are two. One is visible and one is hidden.
	NSEnumerator *subviewsEnum = [[m_contentSubview subviews] reverseObjectEnumerator];
	
	// This is our visible view. Just get past it.
	subview = [subviewsEnum nextObject];

	// Remove everything else. There should be just one, but
	// if the user does a lot of fast clicking, we might have
	// more than one to remove.
	while (subview = [subviewsEnum nextObject]) {
		[subview removeFromSuperviewWithoutNeedingDisplay];
	}

	// This is a work-around that prevents the first
	// toolbar icon from becoming highlighted.
	[[self window] makeFirstResponder:nil];
}

- (NSRect)frameForView:(NSView *)view {
	NSRect windowFrame = [[self window] frame];
	windowFrame.size.height = [view frame].size.height + WINDOW_TITLE_AND_TOOLBAR_HEIGHT;
	windowFrame.size.width = [view frame].size.width;
	windowFrame.origin.y = NSMaxY([[self window] frame]) - windowFrame.size.height;	
	return windowFrame;
}

@end
