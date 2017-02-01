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

#import "MessageTableDataSource.h"
#import "UserIMCell.h"
#import "ClusterIMCell.h"
#import "Constants.h"
#import "MessageManager.h"
#import "SystemIMCell.h"

extern const float USER_IM_CELL_HEIGHT;
extern const float CLUSTER_IM_CELL_HEIGHT;
extern const float SYSTEM_IM_CELL_HEIGHT;

@implementation MessageTableDataSource

- (id)initWithMessageManager:(MessageManager*)mm {
	self = [super init];
	if(self) {
		_messageManager = mm;
	}
	return self;
}

- (void)update:(UITable*)table {
	[table reloadData];
}

- (UITableCell*)table:(UITable*)table cellForRow:(int)row column:(UITableColumn*)col {
	id obj = [_messageManager linearLocate:row];
	if(obj == nil)
		return nil;
	else if([obj isMemberOfClass:[User class]]) {
		UserIMCell* cell = [[[UserIMCell alloc] init] autorelease];
		[cell setUser:obj];
		[cell setMessageManager:_messageManager];
		[cell setDisclosureStyle:kDisclosureStyleRoundArrow];
		[cell setDisclosureClickable:YES];
		return cell;
	} else if([obj isMemberOfClass:[Cluster class]]) {
		ClusterIMCell* cell = [[[ClusterIMCell alloc] init] autorelease];
		[cell setCluster:obj];
		[cell setMessageManager:_messageManager];
		[cell setDisclosureStyle:kDisclosureStyleRoundArrow];
		[cell setDisclosureClickable:YES];
		return cell;
	} else if([obj isKindOfClass:[NSDictionary class]]) {
		SystemIMCell* cell = [[[SystemIMCell alloc] init] autorelease];
		[cell setProperties:obj];
		[cell setDisclosureStyle:kDisclosureStyleRoundArrow];
		[cell setDisclosureClickable:YES];
		return cell;
	} else
		return nil;
}

- (float)table:(UITable*)table heightForRow:(int)row {
	id obj = [_messageManager linearLocate:row];
	if(obj == nil)
		return 0.0f;
	else if([obj isMemberOfClass:[User class]])
		return USER_IM_CELL_HEIGHT;
	else if([obj isMemberOfClass:[Cluster class]]) {
		switch([obj messageSetting]) {
			case kQQClusterMessageAcceptNoPrompt:
			case kQQClusterMessageDisplayCount:
			case kQQClusterMessageBlock:
				return 0.0f;
			default:
				return CLUSTER_IM_CELL_HEIGHT;
		}
	} else if([obj isKindOfClass:[NSDictionary class]]) {
		return SYSTEM_IM_CELL_HEIGHT;
	} else
		return 0.0f;
}

- (int)numberOfRowsInTable:(UITable*)table {
	return [_messageManager itemCount] + [_messageManager systemItemCount];
}

- (void)table:(UITable*)table deleteRow:(int)row {
}

@end
