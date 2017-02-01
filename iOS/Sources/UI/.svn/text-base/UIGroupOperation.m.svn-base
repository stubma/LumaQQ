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

#import "UIGroupOperation.h"
#import <UIKit/UINavigationItem.h>
#import "UIController.h"
#import "NSString-Validate.h"
#import "LocalizedStringTool.h"
#import "Constants.h"
#import "UIUtil.h"

@implementation UIGroupOperation

- (void) dealloc {
	[_table release];
	[_data release];
	[_group release];
	[_groupCell release];
	[_renameCell release];
	[_deleteCell release];
	[_createCell release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitGroupOperation;
}

- (void)begin:(UIController*)uiController {
	// save controller
	_uiController = uiController;
	
	// push navigation item
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:L(@"")] autorelease];
	[[uiController navBar] pushNavigationItem:item];
	
	// show button
	[[uiController navBar] showLeftButton:L(@"Back") withStyle:kNavButtonStyleBackArrow rightButton:nil withStyle:0];
	
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
		
		// group cell
		_groupCell = [[UIPreferencesTableCell alloc] init];
		
		// rename cell
		_renameCell = [[PushButtonTableCell alloc] initWithTitle:L(@"RenameGroup")
												   upImageName:kImageOrangeButtonUp
												 downImageName:kImageOrangeButtonDown];
		[[_renameCell control] addTarget:self action:@selector(renameButtonClicked:) forEvents:kUIMouseUp];
		
		// delete cell
		_deleteCell = [[PushButtonTableCell alloc] initWithTitle:L(@"DeleteGroup")
												   upImageName:kImageOrangeButtonUp
												 downImageName:kImageOrangeButtonDown];
		[[_deleteCell control] addTarget:self action:@selector(deleteButtonClicked:) forEvents:kUIMouseUp];
		
		// create cell
		_createCell = [[PushButtonTableCell alloc] initWithTitle:L(@"CreateGroup")
												   upImageName:kImageOrangeButtonUp
												 downImageName:kImageOrangeButtonDown];
		[[_createCell control] addTarget:self action:@selector(createButtonClicked:) forEvents:kUIMouseUp];
		
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
		
		// get group
		if(_group != nil) {
			[_group release];
			_group = nil;
		}
		_group = [_data objectForKey:kDataKeyGroup];
		[_group retain];
		
		// get group manager
		_groupManager = [_data objectForKey:kDataKeyGroupManager];
		
		// init UI
		[_groupCell setTitle:[_group name]];
		
		// set navigation bar title
		[[[_uiController navBar] topItem] setTitle:[_groupCell title]];
		
		// reload table
		[_table reloadData];
	}
}

- (void)renameButtonClicked:(UIPushButton*)button {
	NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:kUIUnitMain, kDataKeyFrom,
								 _group, kDataKeyNotificationObject,
								 [_group name], kDataKeyStringValue,
								 kGroupNameChangedNotificationName, kDataKeyNotificationName,
								 L(@"GroupName"), kDataKeyTextCellTitle,
								 L(@"RenameGroup"), kDataKeyTitle,
								 L(@"OK"), kDataKeyApplyButtonTitle,
								 nil];
	[_uiController transitTo:kUIUnitNameEdit style:kTransitionStyleLeftSlide data:data];
}

- (void)deleteButtonClicked:(UIPushButton*)button {
	[UIUtil showQuestion:L(@"ConfirmDeleteGroup") title:L(@"Question") delegate:self];
}

- (void)createButtonClicked:(UIPushButton*)button {
	NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:kUIUnitMain, kDataKeyFrom,
								 @"", kDataKeyStringValue,
								 kGroupWillBeCreatedNotificationName, kDataKeyNotificationName,
								 L(@"GroupName"), kDataKeyTextCellTitle,
								 L(@"CreateGroup"), kDataKeyTitle,
								 L(@"OK"), kDataKeyApplyButtonTitle,
								 nil];
	[_uiController transitTo:kUIUnitNameEdit style:kTransitionStyleLeftSlide data:data];
}

#pragma mark -
#pragma mark navigation bar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button {
	switch(button) {
		case kNavButtonLeft:
			[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:nil];
			break;
		case kNavButtonRight:
			break;
	}
}

#pragma mark -
#pragma mark alert sheet delegate

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
	
	// 1 is ok button, the index starts from 1!
	if(button == 1) {	
		if([_group userCount] == 0) {
			[[NSNotificationCenter defaultCenter] postNotificationName:kWantToDeleteGroupNotificationName
																object:_group];
			[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:nil];
		} else {
			NSMutableArray* names = (NSMutableArray*)[_groupManager friendlyGroupNames];
			[names removeObject:[_group name]];
			NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:names, kDataKeyStringValueArray,
				kWantToDeleteGroupNotificationName, kDataKeyNotificationName,
				_group, kDataKeyNotificationObject,
				kUIUnitMain, kDataKeyFrom,
				L(@"SelectGroup"), kDataKeyTitle,
				L(@"MoveFriendsTo"), kDataKeyGroupTitle,
				nil];
			[_uiController transitTo:kUIUnitSelectValue style:kTransitionStyleLeftSlide data:data];
		}
	}
}

#pragma mark -
#pragma mark preference table delegate and data source

-(int)numberOfGroupsInPreferencesTable:(UIPreferencesTable*)aTable {
	return 2 + ([_groupManager isBuiltInGroup:_group] ? 0 : 2);
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

-(float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed {
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
					return _groupCell;
			}
			break;
		case 1:
			switch(row) {
				case 0:
					return _createCell;
			}
			break;
		case 2:
			switch(row) {
				case 0:
					return _renameCell;
			}
			break;
		case 3:
			switch(row) {
				case 0:
					return _deleteCell;
			}
			break;
	}
	return nil; 
}

@end
