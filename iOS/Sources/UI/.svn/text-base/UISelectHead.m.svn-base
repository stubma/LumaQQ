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

#import "UISelectHead.h"
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIPreferencesTableCell.h>
#import "Constants.h"
#import "UIController.h"
#import "LocalizedStringTool.h"
#import "ImageTool.h"

static const int GROUP_COUNT = 7;
static const int HEADS[][40] = {
	// start from 1, first element is count
	// Male
	{
		30,
		5,  7,  10, 14, 15, 16, 17, 28,
		36, 37, 43, 44, 46, 50, 52, 53,
		54, 60, 61, 63, 68, 72, 74, 77,
		79, 80, 82, 85, 94, 95
	},

	// Female
	{
		29, 
		6,  9,  12, 20, 29, 30, 34, 38,
		40, 45, 47, 49, 51, 55, 57, 58,
		62, 67, 70, 75, 78, 81, 83, 84, 
		86, 87, 88, 89, 90
	},

	// Pet
	{
		36,
		1,  2,  3,  4,  8,  11, 13, 17,
		18, 19, 21, 22, 23, 24, 25, 26,
		31, 32, 33, 35, 39, 41, 42, 48,
		56, 59, 64, 65, 66, 69, 71, 73,
		76, 91, 92, 93
	},

	// QQ Tang
	{
		5,
		96, 97, 98, 99, 100
	},

	// QQ fantasy
	{
		5,
		113, 114, 115, 116, 117
	},

	// QQ Sonic
	{
		5,
		101, 102, 103, 104, 105
	},

	// QQ HuaXia
	{
		17,
		106, 107, 108, 109, 110, 111, 112, 118, 
		119, 120, 121, 122, 123, 124, 125, 126,
		127
	}
};

@implementation UISelectHead

- (void) dealloc {
	[_table release];
	[_data release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitSelectHead;
}

- (void)begin:(UIController*)uiController {
	// save controller
	_uiController = uiController;
	
	// push navigation item
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:L(@"SelectHead")] autorelease];
	[[uiController navBar] pushNavigationItem:item];
	
	// show button
	[[uiController navBar] showButtonsWithLeftTitle:nil rightTitle:L(@"Cancel")];
	
	// set delegate
	[[uiController navBar] setDelegate:self];
}

- (void)stop:(UIController*)uiController {
	[[[uiController navBar] navigationItems] removeAllObjects];
	[[uiController navBar] setDelegate:nil];
}

- (UIView*)view {
	if(_table == nil) {				
		// create edit view
		CGRect bound = [_uiController clientRect];
		_table = [[UIPreferencesTable alloc] initWithFrame:bound];
		
		// init table
		[_table setDataSource:self];
		[_table setDelegate:self];
	}
	return _table;
}

- (void)refresh:(NSMutableDictionary*)data {	
	if(data != nil) {		
		// save data
		[data retain];
		[_data release];
		_data = data;
		
		// reload table
		[_table reloadData];
	}
}

- (UInt16)_mapRowToHeadId:(int)row {
	int i;
	for(i = 0; i < 7; i++) {
		if(row > HEADS[i][0])
			row -= HEADS[i][0] + 1;
		else
			return HEADS[i][row];
	}
	return 0;
}

#pragma mark -
#pragma mark navigation bar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button {
	switch(button) {
		case kNavButtonLeft:
			break;
		case kNavButtonRight:
			[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:nil];
			break;
	}
}

#pragma mark -
#pragma mark table data source and delegate

-(int)numberOfGroupsInPreferencesTable:(UIPreferencesTable*)aTable {
	return GROUP_COUNT;
}

-(int)preferencesTable:(UIPreferencesTable*)aTable numberOfRowsInGroup:(int)group {
	return HEADS[group][0];
}

- (id)preferencesTable:(UIPreferencesTable*)aTable titleForGroup:(int)group {
	switch(group) {
		case 0:
			return L(@"HeadMale");
			break;
		case 1:
			return L(@"HeadFemale");
			break;
		case 2:
			return L(@"HeadPet");
			break;
		case 3:
			return L(@"HeadQQTang");
			break;
		case 4:
			return L(@"HeadQQFantasy");
			break;
		case 5:
			return L(@"HeadQQSonic");
			break;
		case 6:
			return L(@"HeadQQHuaXia");
			break;
	}
	return nil;
}

-(float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed {
	return proposed;
}

-(BOOL)preferencesTable:(UIPreferencesTable*)aTable isLabelGroup:(int)group {
	return NO;
}

-(UIPreferencesTableCell*)preferencesTable:(UIPreferencesTable *)aTable cellForRow:(int)row inGroup:(int)group {
	UIPreferencesTableCell* cell = [[[UIPreferencesTableCell alloc] init] autorelease];
	int headId = HEADS[group][row + 1];
	[cell setIcon:[ImageTool headWithRealId:headId]];
	return cell;
}

- (void)tableRowSelected:(NSNotification*)notification {
	// map row to head id
	UInt16 headId = [self _mapRowToHeadId:[_table selectedRow]];
	
	// back
	[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:nil];
	
	// notify
	if(headId > 0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kHeadSelectedNotificationName
															object:[NSNumber numberWithUnsignedInt:headId]];
	}
}

@end
