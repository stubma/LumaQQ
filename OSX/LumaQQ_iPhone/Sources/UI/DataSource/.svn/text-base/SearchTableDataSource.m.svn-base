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

#import "SearchTableDataSource.h"
#import "Constants.h"
#import "LocalizedStringTool.h"

@implementation SearchTableDataSource

- (void)dealloc {
	[_qqCell release];
	[_searchUserCell release];
	[_clusterIdCell release];
	[_searchClusterCell release];
	[super dealloc];
}

- (id)init {
	self = [super init];
	if (self != nil) {
		// create qq cell
		_qqCell = [[UIPreferencesTextTableCell alloc] init];
		[_qqCell setTitle:L(@"QQNo")];
		
		// cluster id cell
		_clusterIdCell = [[UIPreferencesTextTableCell alloc] init];
		[_clusterIdCell setTitle:L(@"ClusterID")];
		
		// create search user cell
		_searchUserCell = [[PushButtonTableCell alloc] initWithTitle:L(@"Incomplete") // use SearchUser when complete
														 upImageName:kImageOrangeButtonUp
													   downImageName:kImageOrangeButtonDown];
		
		// create search cluster cell
		_searchClusterCell = [[PushButtonTableCell alloc] initWithTitle:L(@"Incomplete") // use SearchCluster when complete
															upImageName:kImageOrangeButtonUp
														  downImageName:kImageOrangeButtonDown];
	}
	return self;
}

- (void)updateFocus:(UIPreferencesTable*)table {
	[(UIResponder*)[_searchUserCell control] becomeFirstResponder];
	[table setKeyboardVisible:NO];
}

-(int)numberOfGroupsInPreferencesTable:(UIPreferencesTable*)aTable {
	return 4;
}

-(int)preferencesTable:(UIPreferencesTable*)aTable numberOfRowsInGroup:(int)group {
	switch(group) {
		case 0: 
			return 1;
		case 1:
			return 1;
		case 2:
			return 1;
		case 3:
			return 1;
		default:
			return 0;
	}
}

- (id)preferencesTable:(UIPreferencesTable*)aTable titleForGroup:(int)group {
	switch(group) {
		case 0:
			return L(@"GroupSearchUser");
		case 2:
			return L(@"GroupSearchCluster");
	}
	return nil;
}

-(float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed {
	switch(group) {
		case 0:
			switch(row) {
				case 0:
					return 44.0;
			}
			break;
		case 3:
			switch(row) {
				case 0:
					return 44.0;
			}
			break;
	}
	return proposed;
}

-(BOOL)preferencesTable:(UIPreferencesTable*)aTable isLabelGroup:(int)group {
	return NO;
}

-(UIPreferencesTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForRow:(int)row inGroup:(int)group {
	switch(group) {
		case 0:
			switch(row) {
				case 0:
					return _qqCell;
			}
			break;
		case 1:
			switch(row) {
				case 0:
					return _searchUserCell;
			}
			break;
		case 2:
			switch(row) {
				case 0:
					return _clusterIdCell;
			}
			break;
		case 3:
			switch(row) {
				case 0:
					return _searchClusterCell;
			}
			break;
	}
	return nil; 
}

@end
