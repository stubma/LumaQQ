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

#import "ScreenscrapHelper.h"
#import "GrabView.h"
#import "AnimationHelper.h"
#import "Constants.h"
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>

#define SWAP_PIXEL(p) (((p) << 8) | ((p) >> 24))

static ScreenscrapHelper* s_helper = nil;

@implementation BorderlessKeyWindow

- (BOOL)canBecomeKeyWindow {
	return YES;
}

@end

@implementation ScreenscrapHelper

static inline void swapcopy32(void * src, void * dst, int bytecount) {
    uint32_t *srcP;
    uint32_t *dstP;
    uint32_t p0, p1, p2, p3;
    uint32_t u0, u1, u2, u3;
    
    srcP = (uint32_t*)src;
    dstP = (uint32_t*)dst;
	
    while(bytecount >= 16) {
        /*
         * Blatent hint to compiler that we want
         * strength reduction, pipelined fetches, and
         * some instruction scheduling, please.
         */
        p3 = srcP[3];
        p2 = srcP[2];
        p1 = srcP[1];
        p0 = srcP[0];
        
        u3 = SWAP_PIXEL(p3);
        u2 = SWAP_PIXEL(p2);
        u1 = SWAP_PIXEL(p1);
        u0 = SWAP_PIXEL(p0);
        srcP += 4;
		
		// must take care byte order in intel mac
        dstP[3] = EndianU32_NtoB(u3);
        dstP[2] = EndianU32_NtoB(u2);
        dstP[1] = EndianU32_NtoB(u1);
        dstP[0] = EndianU32_NtoB(u0);
        bytecount -= 16;
        dstP += 4;
    }
    while(bytecount >= 4) {
        p0 = *srcP++;
        bytecount -= 4;
        *dstP++ = EndianU32_NtoB(SWAP_PIXEL(p0));
    }
}

- (void)swizzleBitmap:(NSBitmapImageRep*)bitmap {	
    int rowBytes = [bitmap bytesPerRow];
    int top = 0;
    int bottom = [bitmap pixelsHigh] - 1;
    void* base = [bitmap bitmapData];
    void* buffer = malloc(rowBytes);
    
    while(top < bottom) {
        void* topP = (top * rowBytes) + (char*)base;
        void* bottomP = (bottom * rowBytes) + (char*)base;
        
        /* Save and swap scanlines */
        swapcopy32( topP, buffer, rowBytes );
        swapcopy32( bottomP, topP, rowBytes );
        bcopy( buffer, bottomP, rowBytes );
        
        ++top;
        --bottom;
    }
    free(buffer);
}

- (NSData*)captureRect:(NSRect)rect {
	/* Build a full-screen GL context */
	CGLContextObj glContextObj;
	CGLPixelFormatObj pixelFormatObj;
	GLint numPixelFormats;
	CGOpenGLDisplayMask displayMask = CGDisplayIDToOpenGLDisplayMask(CGMainDisplayID());
	CGLPixelFormatAttribute attribs[] = {
		kCGLPFAFullScreen,
		kCGLPFADisplayMask,
		(CGLPixelFormatAttribute)displayMask,
		(CGLPixelFormatAttribute)NULL
	};
	
	CGLChoosePixelFormat(attribs, &pixelFormatObj, &numPixelFormats);
	CGLCreateContext(pixelFormatObj, NULL, &glContextObj);
	CGLDestroyPixelFormat(pixelFormatObj);
	CGLSetCurrentContext(glContextObj);
	CGLSetFullScreen(glContextObj);
	
    /* Get OpenGL aimed at FB */
    CGLSetCurrentContext(glContextObj);
	
	GLint width = NSWidth(rect);
	GLint height = NSHeight(rect);
	
    long bytewidth = width * 4;	// Assume 4 bytes/pixel for now
    bytewidth = (bytewidth + 3) & ~3;	// Align to 4 bytes
    
    /* Build NSBitmapImageRep */
    NSBitmapImageRep* rep = [[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
																	 pixelsWide:width
																	 pixelsHigh:height
																  bitsPerSample:8
																samplesPerPixel:3
																	   hasAlpha:NO
																	   isPlanar:NO
																 colorSpaceName:NSDeviceRGBColorSpace
																	bytesPerRow:bytewidth
																   bitsPerPixel:(8 * 4)] autorelease];
	
    /* Read FB into NSBitmapImageRep */
    glFinish();				/* Finish all OpenGL commands */
    glPixelStorei(GL_PACK_ALIGNMENT, 4);	/* Force 4-byte alignment */
    glPixelStorei(GL_PACK_ROW_LENGTH, 0);
    glPixelStorei(GL_PACK_SKIP_ROWS, 0);
    glPixelStorei(GL_PACK_SKIP_PIXELS, 0);
	
    /*
     * By matching the framebuffer format, we can get the
     * data transferred to our buffer using DMA.
     */
    glReadPixels(NSMinX(rect), 
				 NSMinY(rect), 
				 width, 
				 height,
				 GL_BGRA,
				 GL_UNSIGNED_INT_8_8_8_8_REV,
				 [rep bitmapData]);
	
    /*
     * glReadPixels generates a quadrant I raster, with origin in the lower left
     * This isn't a problem for signal processing routines such as compressors,
     * as they can simply use a negative 'adavnce' to move between scanlines.
     * NSBitmapImageRep assumes a quadrant III raster, though, so we need to
     * invert it.  Pixel swizzling can also be done here.
     */
    [self swizzleBitmap:rep];
	
	// clean
	CGLSetCurrentContext(NULL);
    CGLClearDrawable(glContextObj);
    CGLDestroyContext(glContextObj);
	
	// get image data
	return [rep representationUsingType:NSJPEGFileType properties:nil];
}

+ (ScreenscrapHelper*)sharedHelper {
	if(s_helper == nil)
		s_helper = [[ScreenscrapHelper alloc] init];
	return s_helper;
}

- (id) init {
	self = [super init];
	if (self != nil) {
		m_busy = NO;
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleScreenscrapDidFinishedNotification:)
													 name:kScreenscrapDidFinishedNotificationName
												   object:nil];
	}
	return self;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kScreenscrapDidFinishedNotificationName
												  object:nil];
	[super dealloc];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	// get rect, packed as a value
	NSRect rect = [[m_window contentView] scrapRect];
	NSValue* value = [NSValue valueWithRect:rect];
	
	// release window
	if(m_window) {
		[m_window autorelease];
		m_window = nil;
	}
	if(m_hintWindow) {
		[m_hintWindow close];
		[m_hintWindow release];
		m_hintWindow = nil;
	}
	
	// post notification
	NSNotification* n = [NSNotification notificationWithName:kScreenscrapDidFinishedNotificationName 
													  object:value];
	[[NSNotificationQueue defaultQueue] enqueueNotification:n
											   postingStyle:NSPostASAP];
	
	// reset flag to accept next screenscrap
	m_busy = NO;
}

- (void)handleScreenscrapDidFinishedNotification:(NSNotification*)notification {
	// get capture rect
	NSRect rect = [[notification object] rectValue];
	
	// check rect
	if(NSWidth(rect) <= 0 || NSHeight(rect) <= 0)
		return;
	
	// capture screen
	NSData* data = [self captureRect:rect];
	
	// generate a uuid as file name
	CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
	NSString* uuidStr = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuid);
	CFRelease(uuid);
	
	// write to file
	NSString* path = [NSString stringWithFormat:@"/tmp/{%@}.JPG", uuidStr];
	[data writeToFile:path atomically:YES];
	[uuidStr release];
	
	// post notification
	NSNotification* n = [NSNotification notificationWithName:kScreenscrapDataDidPopulatedNotificationName
													  object:data
													userInfo:[NSDictionary dictionaryWithObject:path forKey:kUserInfoImagePath]];
	[[NSNotificationQueue defaultQueue] enqueueNotification:n
											   postingStyle:NSPostASAP];
}

- (void)beginScreenscrap {
	// check flag
	if(m_busy)
		return;
	m_busy = YES;
	
	// get screen size
	NSRect frame = [[NSScreen mainScreen] frame];
	
	// create screenshot window
    m_window = [[BorderlessKeyWindow alloc] initWithContentRect:frame 
													  styleMask:NSBorderlessWindowMask
														backing:NSBackingStoreBuffered
														  defer:NO];
	[m_window setReleasedWhenClosed:NO];
	[m_window setContentView:[[[GrabView alloc] initWithFrame:frame] autorelease]];
	[m_window setInitialFirstResponder:[m_window contentView]];
	[m_window setDelegate:self];
    [m_window setBackgroundColor:[NSColor clearColor]];
    [m_window setLevel:(NSScreenSaverWindowLevel + 1)];
    [m_window setHasShadow:NO];	
    [m_window setAlphaValue:0];
	[m_window setAcceptsMouseMovedEvents:YES];
	
	// create hint image
	NSImage* hintImage = [NSImage imageNamed:kImageScreenscrapHint];
	NSSize imageSize = [hintImage size];
	
	// calculate hint window dest frame
	NSRect destFrame = NSMakeRect(50, NSMaxY(frame) - imageSize.height + 1, imageSize.width - 1, imageSize.height - 1);
	NSRect hintEndFrame = destFrame;
	hintEndFrame.origin.y += NSHeight(frame);
	
	// calculate hint window start frame
	NSRect hintStartFrame = destFrame;
	hintStartFrame.origin.y -= NSHeight(frame);
	
	// create hint window
    m_hintWindow = [[NSWindow alloc] initWithContentRect:hintStartFrame
											   styleMask:NSBorderlessWindowMask
												 backing:NSBackingStoreBuffered
												   defer:NO];
	[m_hintWindow setReleasedWhenClosed:NO];
	NSImageView* imageView = [[[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, imageSize.width - 1, imageSize.height - 1)] autorelease];
	[imageView setImageFrameStyle:NSImageFrameNone];
	[imageView setImage:hintImage];
	[m_hintWindow setContentView:imageView];
	[m_hintWindow setHasShadow:NO];
	[m_hintWindow setLevel:(NSScreenSaverWindowLevel + 2)];
	
	// set hint window to grab view
	[[m_window contentView] setHintWindow:m_hintWindow];
	
	// begin animation
	[m_window orderFront:self];
	[m_hintWindow orderFront:self];
	[AnimationHelper moveWindow:m_hintWindow
						   from:hintStartFrame
							 to:hintEndFrame
						 fadeIn:m_window
						fadeOut:nil
				   progressMark:0.5
					   duration:0.75
						  curve:NSAnimationLinear
					   delegate:self];
}

#pragma mark -
#pragma mark animation delegate

- (void)animationDidEnd:(NSAnimation *)animation {
	[m_window makeKeyWindow];
}

- (void)animationDidStop:(NSAnimation*)animation {
	[m_window makeKeyWindow];
}

- (void)animation:(NSAnimation*)animation didReachProgressMark:(NSAnimationProgress)progress {
	if(progress == 0.5)
		[animation stopAnimation];
}

@end
