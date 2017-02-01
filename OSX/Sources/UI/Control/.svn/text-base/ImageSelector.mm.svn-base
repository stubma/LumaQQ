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

#import "LocalizedStringTool.h"
#import "ImageSelector.h"
#import "Constants.h"

#define _kMarginDefault 3
#define _kSpacingDefault 3
#define _kPaddingDefault 3

@implementation ImageSelector

#pragma mark -
#pragma mark init

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	if (self != nil) {
		m_panelCell = [[NSSegmentedCell alloc] init];
		m_navigateCell = [[NSSegmentedCell alloc] init];
		m_buttonCell = [[NSSegmentedCell alloc] init];
		
		[m_panelCell setControlView:self];
		[m_panelCell setControlSize:NSSmallControlSize];
		[m_panelCell setAlignment:NSNaturalTextAlignment];
		[m_panelCell setTarget:self];
		[m_panelCell setAction:@selector(onPanelChanged:)];
		float fontSize = [NSFont systemFontSizeForControlSize:NSSmallControlSize];
		NSFont* font = [NSFont fontWithName:[[m_panelCell font] fontName] size:fontSize];
		[m_panelCell setFont:font];
		m_selectedPanel = 0;
		
		[m_navigateCell setControlView:self];
		[m_navigateCell setSegmentCount:3];
		[m_navigateCell setLabel:[NSString stringWithCharacters:&kLQUnicodeLeftArrow length:1] forSegment:0];
		[m_navigateCell setLabel:[NSString stringWithFormat:L(@"LQPage"), 1] forSegment:1];
		[m_navigateCell setLabel:[NSString stringWithCharacters:&kLQUnicodeRightArrow length:1] forSegment:2];
		[m_navigateCell setTarget:self];
		[m_navigateCell setAction:@selector(onNavigate:)];
		[m_navigateCell setControlSize:NSSmallControlSize];
		[m_navigateCell setFont:font];
		[m_navigateCell setTrackingMode:NSSegmentSwitchTrackingMomentary];
		
		[m_buttonCell setControlView:self];
		[m_buttonCell setSegmentCount:1];
		[m_buttonCell setControlSize:NSSmallControlSize];
		[m_buttonCell setTrackingMode:NSSegmentSwitchTrackingMomentary];
		[m_buttonCell setFont:font];
		[m_buttonCell setTarget:self];
		[m_buttonCell setAction:@selector(onAuxiliaryButton:)];
		
		m_selectedPage = 0;
		m_totalPage = 1;
		[self refreshNavigateStatus];
		
		m_rowColInPanel = 0;
		m_rowColInPage = 0;
		m_selectedRow = -1;
		m_selectedCol = -1;
		m_mouseCol = -1;
		m_mouseRow = -1;
		
		m_oneShot = YES;
		
		m_tooltipTracker = [[SmoothTooltipTracker smoothTooltipTrackerForView:self withDelegate:self] retain];
		[m_tooltipTracker setTooltipDelay:1.0];
	}
	return self;
}

- (void) dealloc {
	[m_dataSource release];
	[m_delegate release];
	[m_panelCell release];
	[m_navigateCell release];
	[m_buttonCell release];
	[m_tooltipTracker release];
	[super dealloc];
}

#pragma mark -
#pragma mark override

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)drawRect:(NSRect)aRect {
	// check datasource
	if(!m_dataSource)
		return;
	
	// get self bound
	NSRect bound = [self bounds];
	
	// get image size
	NSSize imageSize = [m_dataSource imageSize];
	
	// get unit size
	m_unitSize = NSMakeSize(imageSize.width + _kPaddingDefault * 2, imageSize.height + _kPaddingDefault * 2);
	
	// get grid size
	int columns = [m_dataSource columnCount];
	int rows = [m_dataSource rowCount];
	NSSize gridSize = NSMakeSize(m_unitSize.width * columns, m_unitSize.height * rows);
	
	// get segment cell frame
	NSSize segmentSize = [m_panelCell cellSize];
	m_panelCellFrame = NSMakeRect(aRect.origin.x + _kMarginDefault,
								  aRect.origin.y + aRect.size.height - segmentSize.height - _kMarginDefault,
								  segmentSize.width,
								  segmentSize.height);
	
	// draw panel cell
	[m_panelCell drawWithFrame:m_panelCellFrame inView:self];
	
	// get navigate cell frame
	NSSize navigateSize = [m_navigateCell cellSize];
	m_navigateCellFrame = NSMakeRect(NSWidth(bound) - navigateSize.width - _kMarginDefault,
									 aRect.origin.y + _kMarginDefault,
									 navigateSize.width,
									 navigateSize.height);
	
	// draw navigate cell
	[m_navigateCell drawWithFrame:m_navigateCellFrame inView:self];
	
	// get button cell frame
	if([m_dataSource showAuxiliaryButton]) {
		NSSize buttonSize = [m_buttonCell cellSize];
		m_buttonCellFrame = NSMakeRect(aRect.origin.x + _kMarginDefault,
									   aRect.origin.y + _kMarginDefault,
									   buttonSize.width,
									   navigateSize.height);
		[m_buttonCell drawWithFrame:m_buttonCellFrame inView:self];
	}		
	
	// get grid rect
	m_gridRect = NSMakeRect((NSWidth(bound) - gridSize.width) / 2,
							m_navigateCellFrame.origin.y + m_navigateCellFrame.size.height + _kSpacingDefault,
							gridSize.width,
							gridSize.height);
	
	// save state
	NSGraphicsContext* gContext = [NSGraphicsContext currentContext];
	[gContext saveGraphicsState];
	
	// forbid anti-alias
	[gContext setShouldAntialias:NO];
	
	// set color
	[[NSColor colorWithCalibratedRed:0.7 green:0.7 blue:0.7 alpha:1.0] set];
	
	// draw grid
	[NSBezierPath strokeRect:m_gridRect];
	
	// draw horizontal line
	NSBezierPath* path = [NSBezierPath bezierPath];
	for(int i = 1; i < rows; i++) {
		[path moveToPoint:NSMakePoint(m_gridRect.origin.x, m_gridRect.origin.y + m_unitSize.height * i)];
		[path lineToPoint:NSMakePoint(m_gridRect.origin.x + m_gridRect.size.width, m_gridRect.origin.y + m_unitSize.height * i)];
	}
	
	// draw vertical line
	for(int i = 1; i < columns; i++) {
		[path moveToPoint:NSMakePoint(m_gridRect.origin.x + m_unitSize.width * i, m_gridRect.origin.y)];
		[path lineToPoint:NSMakePoint(m_gridRect.origin.x + m_unitSize.width * i, m_gridRect.origin.y + m_gridRect.size.height)];
	}
	[path stroke];
	
	// draw images
	int imgCount = [m_dataSource imageCount:m_selectedPanel];
	int pageDelta = m_selectedPage * rows;
	imgCount -= pageDelta * columns;
	for(int i = 0; i < rows; i++) {
		for(int j = 0; j < columns; j++) {
			NSRect rect = [self rectForRow:i column:j];
			rect.origin.x += _kPaddingDefault - 1;
			rect.origin.y += _kPaddingDefault - 1;
			
			NSImage* image = [m_dataSource imageForPanel:m_selectedPanel page:m_selectedPage row:i column:j];
			[image compositeToPoint:rect.origin operation:NSCompositeSourceOver];
			
			imgCount--;
			if(imgCount == 0)
				break;
		}
		
		if(imgCount == 0)
			break;
	}
	
	// draw selected rectangle
	if(m_selectedCol != -1 && 
	   m_selectedRow != -1 &&
	   m_selectedPanel == m_rowColInPanel &&
	   m_selectedPage == m_rowColInPage) {
		[[NSColor blueColor] set];
		
		[NSBezierPath strokeRect:[self rectForRow:m_selectedRow column:m_selectedCol]];
	}
	
	// restore state
	[gContext restoreGraphicsState];
}

- (NSSize)minimumSize {
	if(!m_dataSource)
		return NSMakeSize(0, 0);
	
	// get image size
	NSSize imageSize = [m_dataSource imageSize];
	
	// get unit size
	m_unitSize = NSMakeSize(imageSize.width + _kPaddingDefault * 2, imageSize.height + _kPaddingDefault * 2);
	
	// get grid size
	NSSize gridSize = NSMakeSize(m_unitSize.width * [m_dataSource columnCount], m_unitSize.height * [m_dataSource rowCount]);
	
	// get segment cell
	NSSize segmentSize = [m_panelCell cellSize];
	
	// get navigate size
	NSSize navigateSize = [m_navigateCell cellSize];
	
	int width = MAX(segmentSize.width, navigateSize.width);
	width = MAX(width, gridSize.width) + _kMarginDefault * 2;
	
	return NSMakeSize(width, segmentSize.height + navigateSize.height + gridSize.height + _kMarginDefault * 2 + _kSpacingDefault * 2);
}

- (void)mouseMoved:(NSEvent *)theEvent {
	// get mouse point
	NSPoint pt = [theEvent locationInWindow];
	pt = [self convertPoint:pt fromView:nil];
	
	int row, col;
	[self rowColFromMouse:pt x:&row y:&col];
	
	if(m_mouseRow != row || m_mouseCol != col) {
		// exit image
		if(m_mouseRow != -1 && m_mouseCol != -1) {
			NSImage* image = [m_dataSource imageForPanel:m_selectedPanel page:m_selectedPage row:m_mouseRow column:m_mouseCol];
			if(image) {
				id imageId = [m_dataSource imageIdForPanel:m_selectedPanel page:m_selectedPage row:m_mouseRow column:m_mouseCol];
				[m_delegate exitImage:self image:image imageId:imageId panel:m_selectedPanel];
			}
		}
		
		// enter image
		m_mouseRow = row;
		m_mouseCol = col;
		if(m_mouseRow != -1 && m_mouseCol != -1) {
			NSImage* image = [m_dataSource imageForPanel:m_selectedPanel page:m_selectedPage row:m_mouseRow column:m_mouseCol];
			if(image) {
				id imageId = [m_dataSource imageIdForPanel:m_selectedPanel page:m_selectedPage row:m_mouseRow column:m_mouseCol];
				[m_delegate enterImage:self image:image imageId:imageId panel:m_selectedPanel];
			}
		}
	}
}

- (void)mouseDown:(NSEvent *)theEvent {
	// get mouse point
	NSPoint pt = [theEvent locationInWindow];
	pt = [self convertPoint:pt fromView:nil];
	
	[m_panelCell trackMouse:theEvent
					 inRect:m_panelCellFrame
					 ofView:self
			   untilMouseUp:YES];
	[m_navigateCell trackMouse:theEvent
						inRect:m_navigateCellFrame
						ofView:self
				  untilMouseUp:YES];
	if([m_dataSource showAuxiliaryButton]) {
		[m_buttonCell trackMouse:theEvent
						  inRect:m_buttonCellFrame
						  ofView:self
					untilMouseUp:YES];
	}
	
	if(NSPointInRect(pt, m_gridRect)) {
		// set selected
		m_rowColInPanel = m_selectedPanel;
		m_rowColInPage = m_selectedPage;
		m_selectedCol = (pt.x - m_gridRect.origin.x) / m_unitSize.width;
		int row = (pt.y - m_gridRect.origin.y) / m_unitSize.height;
		m_selectedRow = [m_dataSource rowCount] - row - 1;
		
		// notify delegate
		if(m_delegate) {
			[m_delegate imageChanged:self 
							   image:[m_dataSource imageForPanel:m_rowColInPanel page:m_rowColInPage row:m_selectedRow column:m_selectedCol]
							 imageId:[m_dataSource imageIdForPanel:m_rowColInPanel page:m_rowColInPage row:m_selectedRow column:m_selectedCol]
							   panel:m_selectedPanel];
		}
		
		// close window if one shot and cmd key isn't pressed
		if(m_oneShot && !([theEvent modifierFlags] & NSCommandKeyMask) && [self window]) {
			[m_delegate exitImage:self image:nil imageId:nil panel:m_selectedPanel];
			NSNotification* n = [NSNotification notificationWithName:kImageSelectorWindowNeedToBeClosedNotificationName object:[self window]];
			[[NSNotificationQueue defaultQueue] enqueueNotification:n postingStyle:NSPostASAP];
		} else {
			// redraw
			[self setNeedsDisplay];
		}
	}
}

#pragma mark -
#pragma mark API

- (int)selectedPanel {
	return m_selectedPanel;
}

- (int)selectedPage {
	return m_selectedPage;
}

- (void)rowColFromMouse:(NSPoint)pt x:(int*)pRow y:(int*)pCol {
	if(NSPointInRect(pt, m_gridRect)) {
		*pCol = (pt.x - m_gridRect.origin.x) / m_unitSize.width;
		int row = (pt.y - m_gridRect.origin.y) / m_unitSize.height;
		*pRow = [m_dataSource rowCount] - row - 1;
	} else {
		*pRow = -1;
		*pCol = -1;
	}
}

- (void)refreshNavigateStatus {
	[m_navigateCell setEnabled:(m_selectedPage > 0) forSegment:0];
	[m_navigateCell setEnabled:(m_selectedPage < m_totalPage - 1) forSegment:2];
	[m_navigateCell setLabel:[NSString stringWithFormat:L(@"LQPage"), m_selectedPage + 1] forSegment:1];
}

- (NSRect)rectForRow:(int)row column:(int)col {
	int rows = [m_dataSource rowCount];
	return NSMakeRect(m_gridRect.origin.x + col * m_unitSize.width + 1,
					  m_gridRect.origin.y + (rows - row - 1) * m_unitSize.height + 1,
					  m_unitSize.width - 2,
					  m_unitSize.height - 2);
}

#pragma mark -
#pragma mark getter and setter

- (void)setDataSource:(id)object {
	[object retain];
	[m_dataSource release];
	m_dataSource = object;
	
	if(m_dataSource)
		[m_buttonCell setLabel:[m_dataSource auxiliaryButtonLabel] forSegment:0];
}

- (void)setDelegate:(id)delegate {
	[delegate retain];
	[m_delegate release];
	m_delegate = delegate;
}

- (id)delegate {
	return m_delegate;
}

- (void)setOneShot:(BOOL)oneShot {
	m_oneShot = oneShot;
}

#pragma mark -
#pragma mark actions

- (IBAction)nextPage:(id)sender {
	m_selectedPage++;
	[self refreshNavigateStatus];
}

- (IBAction)previousPage:(id)sender {
	m_selectedPage--;
	[self refreshNavigateStatus];
}

- (IBAction)onPanelChanged:(id)sender {
	m_selectedPanel = [m_panelCell selectedSegment];
	m_selectedPage = 0;
	m_totalPage = 1 + ([m_dataSource imageCount:m_selectedPanel] - 1) / ([m_dataSource columnCount] * [m_dataSource rowCount]);
	[self refreshNavigateStatus];
}

- (IBAction)onNavigate:(id)sender {
	switch([m_navigateCell selectedSegment]) {
		case 0:
			[self previousPage:sender];
			break;
		case 2:
			[self nextPage:sender];
			break;
	}
}

- (IBAction)onAuxiliaryButton:(id)sender {
	[m_delegate auxiliaryAction:sender];
}

- (IBAction)reloadData:(id)sender {
	int count = [m_dataSource panelCount];
	[m_panelCell setSegmentCount:count];
	for(int i = 0; i < count; i++) {
		[m_panelCell setLabel:[m_dataSource labelForPanel:i] forSegment:i];
		[m_panelCell setWidth:0 forSegment:i];
	}
	[m_panelCell setSelectedSegment:m_selectedPanel];
	m_totalPage = 1 + ([m_dataSource imageCount:m_selectedPanel] - 1) / ([m_dataSource columnCount] * [m_dataSource rowCount]);
	[self refreshNavigateStatus];
	
	[self setNeedsDisplay];
}

#pragma mark -
#pragma mark smooth tooltip delegate

- (void)showTooltipAtPoint:(NSPoint)screenPoint {
	if(m_delegate) {
		// get mouse point
		NSPoint pt = [[self window] convertScreenToBase:screenPoint];
		pt = [self convertPoint:pt fromView:nil];
		
		int row, col;
		[self rowColFromMouse:pt x:&row y:&col];
		
		NSImage* image = [m_dataSource imageForPanel:m_selectedPanel page:m_selectedPage row:row column:col];
		if(image) {
			id imageId = [m_dataSource imageIdForPanel:m_selectedPanel page:m_selectedPage row:row column:col];
			[m_delegate showTooltipAtPoint:screenPoint image:image imageId:imageId panel:m_selectedPanel];
		} else
			[m_delegate hideTooltip];
	}
}

- (void)hideTooltip {
	if(m_delegate)
		[m_delegate hideTooltip];
}

@end
