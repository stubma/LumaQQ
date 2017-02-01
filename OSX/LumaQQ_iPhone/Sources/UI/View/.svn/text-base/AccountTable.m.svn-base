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

#import "AccountTable.h"

@implementation AccountTable

- (id)initWithFrame:(struct CGRect)frame {
	self = [super initWithFrame:frame];
	if(self) {
		_editing = NO;
	}
	return self;
}

- (void)reloadData {
	[super reloadData];
	
	if(_editing) {
		NSArray* cells = [self visibleCells];
		NSEnumerator* e = [[cells objectAtIndex:0] objectEnumerator];
		UIImageAndTextTableCell* cell;
		while(cell = [e nextObject]) {
			[cell _showDeleteOrInsertion:YES
						  withDisclosure:YES
								animated:NO
								isDelete:YES
				   andRemoveConfirmation:NO];
		}
	}
}

- (void)setEditing:(BOOL)flag {
	_editing = flag;
}

@end
