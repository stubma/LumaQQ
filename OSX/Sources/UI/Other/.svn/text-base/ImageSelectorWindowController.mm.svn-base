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

#import "ImageSelectorWindowController.h"
#import "Constants.h"

@implementation ImageSelectorWindowController

- (id)initWithDataSource:(id)dataSource delegate:(id)delegate {
	self = [super initWithWindowNibName:@"ImageSelector"];
	if(self) {
		[self setDataSource:dataSource];
		[self setImageSelectorDelegate:delegate];
	}
	return self;
}

- (void)dealloc {
	[m_dataSource release];
	[m_imageSelectorDelegate release];
	[super dealloc];
}

- (void)windowDidLoad {
	[m_imageSelector setDataSource:m_dataSource];
	[m_imageSelector setDelegate:m_imageSelectorDelegate];
	[m_imageSelector reloadData:self];
	
	// resize to minimum and get delta
	NSRect bound = [m_imageSelector bounds];
	NSSize min = [m_imageSelector minimumSize];
	int dX = NSWidth(bound) - min.width;
	int dY = NSHeight(bound) - min.height;
	
	// resize window
	NSRect frame = [[self window] frame];
	frame.size.width -= dX;
	frame.size.height -= dY;
	[[self window] setFrame:frame display:NO];
	
	// accept mouse move
	[[self window] setAcceptsMouseMovedEvents:YES];
	
	// add observer
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleImageSelectorWindowNeedToBeClosed:)
												 name:kImageSelectorWindowNeedToBeClosedNotificationName
											   object:nil];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kImageSelectorWindowNeedToBeClosedNotificationName
												  object:nil];
	
	[self release];
}

- (void)handleImageSelectorWindowNeedToBeClosed:(NSNotification*)notification {
	if([notification object] == [self window])
		[self close];
}

#pragma mark -
#pragma mark getter and setter

- (void)setOneShot:(BOOL)oneShot {
	[m_imageSelector setOneShot:oneShot];
}

- (id)dataSource {
	return m_dataSource;
}

- (void)setDataSource:(id)dataSource {
	[dataSource retain];
	[m_dataSource release];
	m_dataSource = dataSource;
}

- (id)imageSelectorDelegate {
	return m_imageSelectorDelegate;
}

- (void)setImageSelectorDelegate:(id)delegate {
	[delegate retain];
	[m_imageSelectorDelegate release];
	m_imageSelectorDelegate = delegate;
}

@end
