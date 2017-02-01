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


#import "UINameEdit.h"
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIPreferencesTextTableCell.h>
#import "Constants.h"
#import "UIController.h"
#import "LocalizedStringTool.h"
#import "UIUtil.h"
#import "NSString-Validate.h"

@implementation UINameEdit

- (void) dealloc {
	[_table release];
	[_textCell release];
	[_applyCell release];
	[_data release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitNameEdit;
}

- (void)begin:(UIController*)uiController {
	// save controller
	_uiController = uiController;
	
	// push navigation item
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:@""] autorelease];
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
		
		// create text cell
		_textCell = [[UIPreferencesTextTableCell alloc] init];
		
		// create apply cell
		_applyCell = [[PushButtonTableCell alloc] initWithTitle:@""
													  upImageName:kImageOrangeButtonUp
													downImageName:kImageOrangeButtonDown];
		[[_applyCell control] addTarget:self action:@selector(applyButtonClicked:) forEvents:kUIMouseUp];
		
		// init table
		[_table setDataSource:self];
		[_table setDelegate:self];
	}
	return _table;
}

- (void)refresh:(NSMutableDictionary*)data {	
	// set keyboard visible
	[_table setKeyboardVisible:NO];
	[_textCell resignFirstResponder];
	
	if(data != nil) {		
		// save data
		[data retain];
		[_data release];
		_data = data;
		
		// set text cell title
		NSString* title = [_data objectForKey:kDataKeyTextCellTitle];
		if(title != nil)
			[_textCell setTitle:title];
		
		// set text cell value
		NSString* value = [_data objectForKey:kDataKeyStringValue];
		if(value != nil)
			[_textCell setValue:value];
		
		// set apply button title
		title = [_data objectForKey:kDataKeyApplyButtonTitle];
		if(title != nil)
			[[_applyCell control] setTitle:title];
		
		// reset title
		title = [_data objectForKey:kDataKeyTitle];
		if(title != nil)
			[[[_uiController navBar] topItem] setTitle:title];
		
		// reload table
		[_table reloadData];
	}
}

- (void)applyButtonClicked:(UIPushButton*)button {
	NSString* value = [_textCell value];
	if(value == nil || [value isEmpty]) {
		[UIUtil showWarning:L(@"NameCannotBeEmpty") title:L(@"Warning") delegate:self];
	} else {
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[_textCell value] forKey:kUserInfoStringValue];
		[[NSNotificationCenter defaultCenter] postNotificationName:[_data objectForKey:kDataKeyNotificationName]
															object:[_data objectForKey:kDataKeyNotificationObject]
														  userInfo:userInfo];
		
		// back
		[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:nil];
	}
}

#pragma mark -
#pragma mark alert delegate

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
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
	return 2;
}

-(int)preferencesTable:(UIPreferencesTable*)aTable numberOfRowsInGroup:(int)group {
	switch(group) {
		case 0:
			return 1;
		case 1:
			return 1;
	}
	return 0;
}

-(float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed {
	return proposed;
}

-(UIPreferencesTableCell*)preferencesTable:(UIPreferencesTable *)aTable cellForRow:(int)row inGroup:(int)group {
	switch(group) {
		case 0:
			switch(row) {
				case 0:
					return _textCell;
			}
			break;
		case 1:
			switch(row) {
				case 0:
					return _applyCell;
			}
			break;
	}
	return nil;
}

@end
