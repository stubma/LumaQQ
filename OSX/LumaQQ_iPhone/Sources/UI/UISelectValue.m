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

#import "UISelectValue.h"
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIPreferencesTextTableCell.h>
#import "Constants.h"
#import "UIController.h"
#import "LocalizedStringTool.h"

@implementation UISelectValue

- (void) dealloc {
	[_table release];
	[_cells release];
	[_data release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitSelectValue;
}

- (void)begin:(UIController*)uiController {
	// save controller
	_uiController = uiController;
	
	// push navigation item
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:L(@"SelectValue")] autorelease];
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
		// init variables
		_cells = [[NSMutableArray array] retain];
		
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
		
		// clear
		[_cells removeAllObjects];
		
		// get data array
		NSArray* values = [_data objectForKey:kDataKeyStringValueArray];
		NSEnumerator* e = [values objectEnumerator];
		NSString* value;
		NSString* currentValue = [_data objectForKey:kDataKeyStringValue];
		while(value = [e nextObject]) {
			UIPreferencesTableCell* cell = [[[UIPreferencesTableCell alloc] init] autorelease];
			[cell setTitle:value];
			if(currentValue != nil) {
				if([value isEqualToString:currentValue])
					[cell setChecked:YES];
			}
			[_cells addObject:cell];
		}
		
		// reset title
		NSString* title = [_data objectForKey:kDataKeyTitle];
		if(title != nil)
			[[[_uiController navBar] topItem] setTitle:title];
		
		// reload table
		[_table reloadData];
	}
}

#pragma mark -
#pragma mark navigation bar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button {
	switch(button) {
		case kNavButtonLeft:
			break;
		case kNavButtonRight:
			[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:[_data objectForKey:kDataKeyReturnedData]];
			break;
	}
}

#pragma mark -
#pragma mark table data source and delegate

-(int)numberOfGroupsInPreferencesTable:(UIPreferencesTable*)aTable {
	return 1;
}

-(int)preferencesTable:(UIPreferencesTable*)aTable numberOfRowsInGroup:(int)group {
	return [_cells count];
}

- (id)preferencesTable:(UIPreferencesTable*)aTable titleForGroup:(int)group {
	NSString* title = [_data objectForKey:kDataKeyGroupTitle];
	return title;
}

-(float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed {
	return proposed;
}

-(UIPreferencesTableCell*)preferencesTable:(UIPreferencesTable *)aTable cellForRow:(int)row inGroup:(int)group {
	return [_cells objectAtIndex:row];
}

- (void)tableRowSelected:(NSNotification*)notification {		
	// get selected cell, need minus 1 because has a group
	UIPreferencesTableCell* selectedCell = [_cells objectAtIndex:([_table selectedRow] - 1)];
	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[selectedCell title] forKey:kUserInfoStringValue];
	
	// back
	NSMutableDictionary* returnedData = [_data objectForKey:kDataKeyReturnedData];
	[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:returnedData];
	
	// notify
	NSString* notifyName = [_data objectForKey:kDataKeyNotificationName];
	if(notifyName != nil) {
		id obj = [_data objectForKey:kDataKeyNotificationObject];		
		[[NSNotificationCenter defaultCenter] postNotificationName:notifyName
															object:(obj == nil ? [NSNumber numberWithInt:([_table selectedRow] - 1)] : obj)
														  userInfo:userInfo];
	}
}

@end
