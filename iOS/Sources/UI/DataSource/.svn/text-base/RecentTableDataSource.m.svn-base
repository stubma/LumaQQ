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

#import "RecentTableDataSource.h"
#import <UIKit/UITable.h>
#import <UIKit/UITableCell.h>
#import <GraphicsServices/GraphicsServices.h>
#import "UserCell.h"
#import "Constants.h"
#import "FileTool.h"

#define _kMaxRecent 20

extern const float USER_CELL_HEIGHT;

extern UInt32 gMyQQ;

@implementation RecentTableDataSource

- (void) dealloc {
	if(_recents)
		[_recents release];
	[super dealloc];
}

- (id)initWithGroupManager:(GroupManager*)groupManager {
	self = [super init];
	if(self) {
		_groupManager = groupManager;
		_recents = [[NSMutableArray array] retain];
		
		// load recent file
		NSString* path = [FileTool getRecentPlistByString:[NSString stringWithFormat:@"%u", gMyQQ]];
		if([FileTool isFileExist:path]) {
			_dirty = YES;
			NSArray* recentQQ = [NSArray arrayWithContentsOfFile:path];
			NSEnumerator* e = [recentQQ objectEnumerator];
			NSNumber* qq = nil;
			while(qq = [e nextObject]) {
				User* u = [_groupManager user:[qq unsignedIntValue]];
				if(u == nil)
					u = [[[User alloc] initWithQQ:[qq unsignedIntValue]] autorelease];
				[_recents addObject:u];
			}
		} else
			_dirty = NO;
	}
	return self;
}

- (void)update:(UITable*)table {
	if(_dirty) {
		[table reloadData];
		_dirty = NO;
	}
}

- (id)recentAtIndex:(int)index {
	if(_recents)
		return [_recents objectAtIndex:index];
	else
		return nil;
}

- (void)removeAll {
	[_recents removeAllObjects];
	_dirty = YES;
}

- (void)addRecentByQQ:(UInt32)QQ {
	User* u = [_groupManager user:QQ];
	if(u == nil)
		u = [[[User alloc] initWithQQ:QQ] autorelease];
	if([_recents containsObject:u]) {
		[_recents removeObject:u];
		[_recents insertObject:u atIndex:0];
	} else {
		while([_recents count] >= _kMaxRecent)
			[_recents removeObjectAtIndex:(_kMaxRecent - 1)];
		[_recents insertObject:u atIndex:0];
	}
	_dirty = YES;
}

- (void)sync {
	if(_recents) {
		// create qq number array
		NSMutableArray* recentQQ = [NSMutableArray arrayWithCapacity:[_recents count]];
		NSEnumerator* e = [_recents objectEnumerator];
		User* u = nil;
		while(u = [e nextObject])
			[recentQQ addObject:[NSNumber numberWithUnsignedInt:[u QQ]]];
		
		// save to file
		NSString* path = [FileTool getRecentPlistByString:[NSString stringWithFormat:@"%u", gMyQQ]];
		[FileTool initDirectoryForFile:path];
		[recentQQ writeToFile:path atomically:YES];
	}
}

- (UITableCell*)table:(UITable*)table cellForRow:(int)row column:(UITableColumn*)col {
	id obj = [_recents objectAtIndex:row];
	UserCell* cell = [[[UserCell alloc] init] autorelease];
	[cell setTapDelegate:self];
	[cell setUser:obj];
	[cell setDisclosureStyle:kDisclosureStyleRoundArrow];
	[cell setDisclosureClickable:YES];
	return cell;
}

- (float)table:(UITable*)table heightForRow:(int)row {
	return USER_CELL_HEIGHT;
}

- (int)numberOfRowsInTable:(UITable*)table {
	return [_recents count];
}

- (void)view:(id)view handleTapWithCount:(int)count event:(GSEventRef)event fingerCount:(int)fingerCount {
	if(count == 2) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kCellDoubleTappedNotificationName
															object:[view object]];
	}
}

@end
