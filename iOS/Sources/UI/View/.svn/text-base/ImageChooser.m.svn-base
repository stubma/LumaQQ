/*
 * LumaQQ - Cross platform QQ client, special edition for iPhone
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

#import "ImageChooser.h"
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/NSString-UIStringDrawing.h>
#import "Constants.h"
#import "ImageChooserDelegate.h"

static const float CELL_WIDTH = 40.0f;
static const float CELL_HEIGHT = 40.0f;

static const float _bg[] = {
	1.0f, 1.0f, 1.0f, 1.0f
};
static const float _clickedBg[] = {
	0.76f, 1.0f, 1.0f, 1.0f
};
static const float _lineColor[] = {
	0.1f, 0.1f, 0.1f, 1.0f
};

@implementation ImageChooser

- (void) dealloc {
	[(id)_provider release];
	[_delegate release];
	[super dealloc];
}

- (id) init {
	self = [super init];
	if (self != nil) {
		_cellWidth = CELL_WIDTH;
		_cellHeight = CELL_HEIGHT;
		_row = 4;
		_column = 4;
		_horizontalScroll = YES;
		_offset = 0;
		_clicked = -1;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self) {
		_cellWidth = CELL_WIDTH;
		_cellHeight = CELL_HEIGHT;
		_row = 4;
		_column = 4;
		_horizontalScroll = YES;
		_offset = 0;
		_clicked = -1;
	}
	return self;
}

- (void)mouseDragged:(GSEventRef)event {
	CGRect loc = GSEventGetLocationInWindow(event);
	CGPoint point = [self convertPoint:loc.origin fromView:nil];
	_dragged = YES;
	
	if(_horizontalScroll) {
		// get delta
		float dx = point.x - _mousePoint.x;
		_mousePoint = point;
		
		// calculate max horizontal scale
		int columnCount = [_provider imageCount] / _row;
		float span = _cellWidth * columnCount;
		float maxOffset = span - _cellWidth;
		if(_offset <= maxOffset) {
			_offset -= dx;
			_offset = MAX(0.0f, _offset);
			_offset = MIN(maxOffset, _offset);
			[self setNeedsDisplay];
		}
	} else {
		// get delta
		float dy = point.y - _mousePoint.y;
		_mousePoint = point;
		
		// calculate max horizontal scale
		int rowCount = [_provider imageCount] / _column;
		float span = _cellHeight * rowCount;
		float maxOffset = span - _cellHeight;
		if(_offset <= maxOffset) {
			_offset -= dy;
			_offset = MAX(0.0f, _offset);
			_offset = MIN(maxOffset, _offset);
			[self setNeedsDisplay];
		}
	}
	
	[super mouseDragged:event];
}

- (void)mouseDown:(GSEventRef)event {
	CGRect loc = GSEventGetLocationInWindow(event);
	_mousePoint = [self convertPoint:loc.origin fromView:nil];
	_dragged = NO;
	
	// get image area rect
	CGRect rect = [self frame];
	CGRect imageAreaRect;
	imageAreaRect.size.width = _column * _cellWidth;
	imageAreaRect.size.height = _row * _cellHeight;
	imageAreaRect.origin.x = (rect.size.width - imageAreaRect.size.width) / 2.0f;
	imageAreaRect.origin.y = (rect.size.height - imageAreaRect.size.height) / 2.0f;
	
	// calculate the clicked index
	int column = (_mousePoint.x - imageAreaRect.origin.x + _offset) / _cellWidth;
	int row = (_mousePoint.y - imageAreaRect.origin.y) / _cellHeight;
	if(_horizontalScroll)
		_clicked = column * _row + row;
	else
		_clicked = row * _column + column;
	
	[super mouseDown:event];
	[self setNeedsDisplay];
}

- (void)mouseUp:(GSEventRef)event {
	if(_dragged == NO) {
		if(_delegate)
			[_delegate imageClicked:_clicked];
	}
	_clicked = -1;
	[super mouseUp:event];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	if(rect.size.height <= 0)
		return;
	
	// create bg color
	CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGColorRef bgColor = CGColorCreate(colorSpace, _bg);
	CGColorSpaceRelease(colorSpace);
	
	// draw background
	CGContextRef context = UICurrentContext();
	CGContextSetFillColorWithColor(context, bgColor);
	CGContextFillRect(context, rect);
	CGColorRelease(bgColor);
	
	// draw outline
	CGRect imageAreaRect;
	imageAreaRect.size.width = _column * _cellWidth;
	imageAreaRect.size.height = _row * _cellHeight;
	imageAreaRect.origin.x = (rect.size.width - imageAreaRect.size.width) / 2.0f;
	imageAreaRect.origin.y = (rect.size.height - imageAreaRect.size.height) / 2.0f;
	CGContextSetStrokeColor(context, _lineColor);
	CGContextSetFillColor(context, _lineColor);
	CGContextSetLineWidth(context, 0.3f);
	CGContextStrokeRect(context, CGRectMake(imageAreaRect.origin.x - 1, imageAreaRect.origin.y - 1, imageAreaRect.size.width + 2, imageAreaRect.size.height + 2));
	
	// get the start index
	int index;
	if(_horizontalScroll)
		index = (int)(_offset / _cellWidth) * _row;
	else
		index = (int)(_offset / _cellHeight) * _column;
	
	// horizontal line
	float y = imageAreaRect.origin.y + _cellHeight - (_horizontalScroll ? 0 : (_offset - _cellHeight * (int)(_offset / _cellHeight)));
	CGContextBeginPath(context);
	while(y < imageAreaRect.origin.y + imageAreaRect.size.height) {
		CGContextMoveToPoint(context, imageAreaRect.origin.x, y);
		CGContextAddLineToPoint(context, imageAreaRect.origin.x + imageAreaRect.size.width, y);
		y += _cellHeight;
	}
	CGContextStrokePath(context);
	
	// vertical line
	float x = imageAreaRect.origin.x + _cellWidth - (_horizontalScroll ? (_offset - _cellWidth * (int)(_offset / _cellWidth)) : 0);
	CGContextBeginPath(context);
	while(x < imageAreaRect.origin.x + imageAreaRect.size.width) {
		CGContextMoveToPoint(context, x, imageAreaRect.origin.y);
		CGContextAddLineToPoint(context, x, imageAreaRect.origin.y + imageAreaRect.size.height);
		x += _cellWidth;
	}
	CGContextStrokePath(context);
	
	// create title font
	CGRect maxRect = CGRectMake(0, 0, 10000, 10000);
	GSFontRef font;
	BOOL showTitle = [_provider shouldShowTitle];
	CGSize titleSize;
	if(showTitle) {
		font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 10.0f);
		NSString* title = [_provider titleAtIndex:0];
		titleSize = [title sizeInRect:maxRect withFont:font];
	}
	
	// draw images
	int count = [_provider imageCount];
	CGContextClipToRect(context, imageAreaRect);
	if(_horizontalScroll) {
		int div = _offset / _cellWidth;
		float x = imageAreaRect.origin.x - (_offset - div * _cellWidth);
		float y = imageAreaRect.origin.y;
		while(index < count && x < imageAreaRect.origin.x + imageAreaRect.size.width) {
			while(index < count && y < imageAreaRect.origin.y + imageAreaRect.size.height) {
				UIImage* image = [_provider imageAtIndex:index];
				CGSize size = [image size];
				
				// draw clicked bg
				if(index == _clicked) {
					CGContextSetFillColor(context, _clickedBg);
					CGContextFillRect(context, CGRectMake(x, y, _cellWidth, _cellHeight));
					CGContextSetFillColor(context, _lineColor);
				}
				
				if(showTitle) {
					NSString* title = [_provider titleAtIndex:index];
					if(title != nil) {
						float spacing = (_cellHeight - size.height - titleSize.height) / 3.0f;
						[image compositeToPoint:CGPointMake(x + (_cellWidth - size.width) / 2.0f, y + spacing)
									  operation:NSCompositeSourceOver];
						[title drawInRect:CGRectMake(x, y + spacing + size.height + spacing, _cellWidth, _cellHeight - (spacing + size.height + spacing))
								 withFont:font
								 ellipsis:0
								alignment:1];
					} else {
						[image compositeToPoint:CGPointMake(x + (_cellWidth - size.width) / 2.0f, y + (_cellHeight - size.height) / 2.0f)
									  operation:NSCompositeSourceOver];
					}					
				} else {
					[image compositeToPoint:CGPointMake(x + (_cellWidth - size.width) / 2.0f, y + (_cellHeight - size.height) / 2.0f)
								  operation:NSCompositeSourceOver];
				}
				
				y += _cellHeight;
				index++;
			}
			
			x += _cellWidth;
			y = imageAreaRect.origin.y;
		}
	} else {
		int div = _offset / _cellHeight;
		float x = imageAreaRect.origin.x;
		float y = imageAreaRect.origin.y - (_offset - div * _cellHeight);
		while(index < count && y < imageAreaRect.origin.y + imageAreaRect.size.height) {
			while(index < count && x < imageAreaRect.origin.x + imageAreaRect.size.width) {
				UIImage* image = [_provider imageAtIndex:index];
				CGSize size = [image size];
				[image compositeToPoint:CGPointMake(x + (_cellWidth - size.width) / 2.0f, y + (_cellHeight - size.height) / 2.0f)
							  operation:NSCompositeSourceOver];
				
				x += _cellWidth;
				index++;
			}
			
			y += _cellHeight;
			x = imageAreaRect.origin.x;
		}
	}
	
	// release
	if(showTitle)
		CFRelease(font);
}

- (void)setProvider:(id<ImageProvider>)provider {
	[(id)provider retain];
	[(id)_provider release];
	_provider = provider;
}

- (void)setDelegate:(id)delegate {
	[delegate retain];
	[_delegate release];
	_delegate = delegate;
}

- (void)setHorizontalScroll:(BOOL)flag {
	_horizontalScroll = flag;
}

- (void)setRow:(int)row {
	_row = row;
}

- (void)setColumn:(int)column {
	_column = column;
}

- (void)setCellHeight:(float)h {
	_cellHeight = h;
}

- (void)setCellWidth:(float)w {
	_cellWidth = w;
}

@end
