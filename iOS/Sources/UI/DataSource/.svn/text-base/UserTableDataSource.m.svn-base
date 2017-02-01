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

#import "UserTableDataSource.h"
#import <UIKit/UITable.h>
#import <UIKit/UITableCell.h>
#import <GraphicsServices/GraphicsServices.h>
#import "GroupCell.h"
#import "UserCell.h"
#import "Constants.h"
#import "PreferenceTool.h"

extern const float GROUP_CELL_HEIGHT;
extern const float USER_CELL_HEIGHT;

extern UInt32 gMyQQ;

@implementation UserTableDataSource

- (id)initWithGroupManager:(GroupManager*)groupManager {
	self = [super init];
	if(self) {
		_groupManager = groupManager;
	}
	return self;
}

- (UITableCell*)table:(UITable*)table cellForRow:(int)row column:(UITableColumn*)col {
	id obj = [_groupManager linearLocate:row];
	if([obj isMemberOfClass:[Group class]]) {
		GroupCell* cell = [[[GroupCell alloc] init] autorelease];
		[cell setTapDelegate:self];
		[cell setGroup:obj];
		[cell setDisclosureStyle:kDisclosureStyleRoundArrow];
		[cell setDisclosureClickable:YES];
		return cell;
	} else if([obj isMemberOfClass:[User class]]) {
		UserCell* cell = [[[UserCell alloc] init] autorelease];
		[cell setTapDelegate:self];
		[cell setUser:obj];
		[cell setDisclosureStyle:kDisclosureStyleRoundArrow];
		[cell setDisclosureClickable:YES];
		return cell;
	} else {
		return nil;
	}
}

- (float)table:(UITable*)table heightForRow:(int)row {
	id obj = [_groupManager linearLocate:row];
	if([obj isMemberOfClass:[Group class]]) {
		return GROUP_CELL_HEIGHT;
	} else if([obj isMemberOfClass:[User class]]) {
		Group* g = [_groupManager group:[obj groupIndex]];
		if(![g expanded])
			return 0.0;
		else if(![obj isVisible] && [self _showOnlineUserOnly])
			return 0.0;
		else
			return USER_CELL_HEIGHT;
	} else
		return 0.0;
}

- (int)numberOfRowsInTable:(UITable*)table {
	return [_groupManager userTableRowCount];
}

- (BOOL)_showOnlineUserOnly {
	return [[PreferenceTool toolWithQQ:gMyQQ] booleanValue:kPreferenceKeyShowOnlineOnly];
}

- (void)view:(id)view handleTapWithCount:(int)count event:(GSEventRef)event fingerCount:(int)fingerCount {
	if(count == 2) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kCellDoubleTappedNotificationName
															object:[view object]];
	}
}

@end
