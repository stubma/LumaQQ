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

#import "UISwipeDeleteTable.h"
#import <GraphicsServices/GraphicsServices.h>
#import "Constants.h"

@implementation UISwipeDeleteTable

- (id) init {
	self = [super init];
	if (self != nil) {
		_oldSwipeRow = -1;
	}
	return self;
}

- (id)initWithFrame:(struct CGRect)frame {
	self = [super initWithFrame:frame];
	if(self) {
		_oldSwipeRow = -1;
	}
	return self;
}

- (int)swipe:(int)direction withEvent:(GSEventRef)event {
	[super swipe:direction withEvent:event];
	
	if(direction == kSwipeDirectionLeft || direction == kSwipeDirectionRight) {
		// get point
		CGRect loc = GSEventGetLocationInWindow(event);
		CGPoint point = [self convertPoint:loc.origin fromView:nil];
		
		// get row
		int row = [self rowAtPoint:point];
		
		// get visible cell, show delete
		id cell = [self visibleCellForRow:row column:0];
		if(cell != nil) {
			[cell _showDeleteOrInsertion:YES
						  withDisclosure:NO
								animated:YES
								isDelete:YES
				   andRemoveConfirmation:YES];
		}
		
		// hide delete for old row
		if(_oldSwipeRow != -1) {
			cell = [self visibleCellForRow:_oldSwipeRow column:0];
			if(cell != nil) {
				[cell _showDeleteOrInsertion:NO
							  withDisclosure:NO
									animated:YES
									isDelete:YES
					   andRemoveConfirmation:NO];
			}
		}
		
		// save old swipe row
		_oldSwipeRow = row;
	}
}

@end
