/*
HMBlkPanel.m

Author: Makoto Kinoshita

Copyright 2004-2006 The Shiira Project. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted 
provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice, this list of conditions 
  and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright notice, this list of 
  conditions and the following disclaimer in the documentation and/or other materials provided 
  with the distribution.

THIS SOFTWARE IS PROVIDED BY THE SHIIRA PROJECT ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE SHIIRA PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
*/

#import "HMBlkButton.h"
#import "HMBlkContentView.h"
#import "HMBlkPanel.h"

@implementation HMBlkPanel

//--------------------------------------------------------------//
#pragma mark -- Black image --
//--------------------------------------------------------------//

+ (NSImage*)contentBackgroundImage
{
    static NSImage* _contentBackgroundImage;
    if (!_contentBackgroundImage) {
        NSBundle*   bundle;
        bundle = [NSBundle bundleForClass:self];
        
        _contentBackgroundImage = [[NSImage alloc] initWithContentsOfFile:
                [bundle pathForImageResource:@"blkPanelMM"]];
    }
    
    return _contentBackgroundImage;
}

//--------------------------------------------------------------//
#pragma mark -- Colors --
//--------------------------------------------------------------//

+ (NSColor*)highlighedCellColor
{
    static NSColor* _highlightCellColor = nil;
    if (!_highlightCellColor) {
        _highlightCellColor = [[NSColor colorWithCalibratedWhite:0.5f alpha:0.8f] retain];
    }
    
    return _highlightCellColor;
}

+ (NSArray*)alternatingRowBackgroundColors
{
    static NSArray* _altColors = nil;
    if (!_altColors) {
        _altColors = [[NSArray arrayWithObjects:
                [NSColor colorWithCalibratedWhite:0.16f alpha:0.86f], 
                [NSColor colorWithCalibratedWhite:0.15f alpha:0.8f], 
                nil] retain];
    }
    
    return _altColors;
}

+ (NSColor*)majorGridColor
{
    static NSColor* _majorGridColor = nil;
    if (!_majorGridColor) {
        _majorGridColor = [[NSColor colorWithCalibratedRed:0.69f green:0.69 blue:0.69 alpha:1.0f] retain];
    }
    
    return _majorGridColor;
}

//--------------------------------------------------------------//
#pragma mark -- Initialize --
//--------------------------------------------------------------//

- (id)initWithContentRect:(NSRect)contentRect 
        styleMask:(unsigned int)styleMask 
        backing:(NSBackingStoreType)backingType 
        defer:(BOOL)flag
{
    // Invoke super without title bar
    self = [super initWithContentRect:contentRect 
            styleMask:NSBorderlessWindowMask 
            backing:backingType 
            defer:flag];
    
    // Initialize instance variables
    _mouseMoveListeners = [[NSMutableSet set] retain];
    
    // Configure itself
    [self setLevel:NSFloatingWindowLevel];
    [self setOpaque:NO];
    [self setBecomesKeyOnlyIfNeeded:YES];
    
    // Set content view
    [self setContentView:[[[HMBlkContentView alloc] initWithFrame:contentRect] autorelease]];
    
	// create close button
	_showCloseButton = YES;
	[self addCloseButton];
    
    // Set accepts mouse moved events
    [self setAcceptsMouseMovedEvents:YES];
    
    return self;
}

- (void)dealloc
{
    [_closeButton release];
    [_mouseMoveListeners release];
    
    [super dealloc];
}

//--------------------------------------------------------------//
#pragma mark -- getter and setter --
//--------------------------------------------------------------//
- (BOOL)showCloseButton {
	return _showCloseButton;
}

- (void)setShowCloseButton:(BOOL)value {
	_showCloseButton = value;
	if(_showCloseButton) {
		if(_closeButton == nil)
			[self addCloseButton];
	} else {
		if(_closeButton)
			[self removeCloseButton];
	}
}

//--------------------------------------------------------------//
#pragma mark -- add/remove close button --
//--------------------------------------------------------------//
- (void)addCloseButton {
	// Create close button
    NSBundle*   bundle;
    NSImage*    closeButtonImage;
    bundle = [NSBundle bundleForClass:[self class]];
    closeButtonImage = [[[NSImage alloc] initWithContentsOfFile:
		[bundle pathForImageResource:@"blkCloseButton"]] autorelease];
    if (closeButtonImage) {
		NSRect contentRect = [[self contentView] bounds];
        NSRect  buttonRect;
        buttonRect.origin.x = 12;
        buttonRect.origin.y = contentRect.size.height - 7 - [closeButtonImage size].height;
        buttonRect.size = [closeButtonImage size];
        
        _closeButton = [[HMBlkButton alloc] initWithFrame:buttonRect];
        [_closeButton setButtonType:NSMomentaryChangeButton];
        [_closeButton setBezelStyle:NSRegularSquareBezelStyle];
        [_closeButton setBordered:NO];
        [_closeButton setImage:closeButtonImage];
        [_closeButton setAutoresizingMask:NSViewMaxXMargin | NSViewMinYMargin];
        [_closeButton setTarget:self];
        [_closeButton setAction:@selector(onClose:)];
        
        [[self contentView] addSubview:_closeButton];
        
        [self addMouseMoveListener:_closeButton];
    }
}

- (void)removeCloseButton {
	[self removeMouseMoveListener:_closeButton];
	[_closeButton removeFromSuperview];
	[_closeButton release];
	_closeButton = nil;
}

//--------------------------------------------------------------//
#pragma mark -- Action --
//--------------------------------------------------------------//
- (IBAction)onClose:(id)sender {
	[self orderOut:self];
	[self autorelease];
}

//--------------------------------------------------------------//
#pragma mark -- Window attributes --
//--------------------------------------------------------------//

- (BOOL)hasShadow
{
    return NO;
}

- (BOOL)becomesKeyOnlyIfNeeded
{
    return YES;
}

//--------------------------------------------------------------//
#pragma mark -- Mouse move listener --
//--------------------------------------------------------------//

- (void)addMouseMoveListener:(id)listener
{
    [_mouseMoveListeners addObject:listener];
}

- (void)removeMouseMoveListener:(id)listener
{
    [_mouseMoveListeners removeObject:listener];
}

//--------------------------------------------------------------//
#pragma mark -- NSResponder override --
//--------------------------------------------------------------//

- (BOOL)canBecomeMainWindow
{
    return YES;
}

//--------------------------------------------------------------//
#pragma mark -- Fade out timer --
//--------------------------------------------------------------//

static float    SRBookmarkDisplayInterval = 3.0f;
static float    SRBookmarkFadeoutInterval = 0.01f;
static float    SRBookmarkFadeoutAlphaDiff = 0.05f;

- (void)resetFadeOutTimer
{
    // Cancel current timer
    if (_fadeOutTimer && [_fadeOutTimer isValid]) {
        [_fadeOutTimer invalidate];
        _fadeOutTimer = nil;
    }
    
    // Reset alpha value
    if ([self alphaValue] != 1.0f) {
        [self setAlphaValue:1.0f];
    }
    
    // Start display timer
    _fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:SRBookmarkDisplayInterval 
            target:self 
            selector:@selector(displayTimerExpired:) 
            userInfo:nil 
            repeats:NO];
}

- (void)displayTimerExpired:(NSTimer*)timer
{
    // Start fade out timer
    _fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:SRBookmarkFadeoutInterval 
            target:self 
            selector:@selector(fadeOutTimerExpired:) 
            userInfo:nil 
            repeats:YES];
}

- (void)fadeOutTimerExpired:(NSTimer*)timer
{
    // Get alpha value
    float   alpha;
    alpha = [self alphaValue];
    
    if (alpha <= SRBookmarkFadeoutAlphaDiff) {
        // Close panel
        [self orderOut:self];
        [self setAlphaValue:1.0f];
		[self autorelease];
        
        // Cancel timer
        [_fadeOutTimer invalidate];
        _fadeOutTimer = nil;
        return;
    }
    
    // Set alpha value
    alpha -= SRBookmarkFadeoutAlphaDiff;
    [self setAlphaValue:alpha];
}

@end
