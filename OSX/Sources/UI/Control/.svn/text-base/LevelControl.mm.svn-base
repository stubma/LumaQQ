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
#import "LevelControl.h"
#import "LevelCell.h"

@implementation LevelControl

+ (void)initialize {
    if (self == [LevelControl class]) {		// Do it once
        [self setCellClass: [LevelCell class]];
    }
}

+ (Class)cellClass {
    return [LevelCell class];
}

#pragma mark -
#pragma mark getter and setter

- (int)level {
	return [(LevelCell*)[self cell] level];
}

- (void)setLevel:(int)level {
	[[self cell] setLevel:level];
	[self setToolTip:[NSString stringWithFormat:L(@"LQLevel"), level, [self upgradeDays]]];
}

- (int)upgradeDays {
	return [(LevelCell*)[self cell] upgradeDays];
}

- (void)setUpgradeDays:(int)days {
	[[self cell] setUpgradeDays:days];
	[self setToolTip:[NSString stringWithFormat:L(@"LQLevel"), [self level], days]];
}

@end
