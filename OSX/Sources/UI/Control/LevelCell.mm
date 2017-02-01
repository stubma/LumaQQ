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

#import "LevelCell.h"
#import "Constants.h"

@implementation LevelCell

- (id)initWithLevel:(int)level upgradeDays:(int)days {
	self = [super init];
	if(self) {
		m_level = level;
		m_upgradeDays = days;
	}
	return self;
}

- (id)copyWithZone:(NSZone*)zone {
    LevelCell* newCopy = [[LevelCell alloc] initWithLevel:m_level upgradeDays:m_upgradeDays];
    return newCopy;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {	
	// check level0
	if(m_level <= 0)
		return;
	
	// load image
	NSImage* imgSun = [NSImage imageNamed:kImageSun];
	NSImage* imgMoon = [NSImage imageNamed:kImageMoon];
	NSImage* imgStar = [NSImage imageNamed:kImageStar];
	
	// get image size
	NSSize imgSize = [imgSun size];
	
	// check size
	if(imgSize.height > NSHeight(cellFrame))
		return;
	
	// get start point
	int x = cellFrame.origin.x;
	int y = NSMinY(cellFrame);
	NSRect imgRect = NSMakeRect(x, y, imgSize.width, imgSize.height);
	
	if ([controlView isFlipped])
		imgRect.origin.y += ceil((cellFrame.size.height + imgRect.size.height) / 2);
	else
		imgRect.origin.y += ceil((cellFrame.size.height - imgRect.size.height) / 2);
	
	// draw sun
	int tmp = m_level;
	while(tmp >= 16) {
		[imgSun compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
		tmp -= 16;
		imgRect.origin.x += imgSize.width;
	}
	
	// draw moon
	while(tmp >= 4) {
		[imgMoon compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
		tmp -= 4;
		imgRect.origin.x += imgSize.width;
	}
	
	// draw star
	while(tmp > 0) {
		[imgStar compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
		tmp--;
		imgRect.origin.x += imgSize.width;
	}
}

#pragma mark -
#pragma mark getter and setter

- (int)level {
	return m_level;
}

- (void)setLevel:(int)level {
	m_level = level;
	[(NSControl*)[self controlView] updateCell:self];
}

- (int)upgradeDays {
	return m_upgradeDays;
}

- (void)setUpgradeDays:(int)days {
	m_upgradeDays = days;
}

@end
