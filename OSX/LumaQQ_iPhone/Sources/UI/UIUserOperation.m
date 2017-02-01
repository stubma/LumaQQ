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

#import "UIUserOperation.h"
#import <UIKit/UINavigationItem.h>
#import "UIController.h"
#import "NSString-Validate.h"
#import "LocalizedStringTool.h"
#import "Constants.h"
#import "GroupManager.h"
#import "UIUtil.h"
#import "AuthInfoOpReplyPacket.h"

#define _kAlertConfirmDeleteUser 0
#define _kAlertDeleteUserFailed 1
#define _kAlertDeleteUserSuccess 2

@implementation UIUserOperation

- (void) dealloc {
	[_table release];
	[_data release];
	[_userCell release];
	[_infoCell release];
	[_chatCell release];
	[_moveCell release];
	[_deleteCell release];
	[_authInfo release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitUserOperation;
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
	
	[_client removeQQListener:self];
}

- (UIView*)view {
	if(_table == nil) {				
		// create edit view
		CGRect bound = [_uiController clientRect];
		_table = [[UIPreferencesTable alloc] initWithFrame:bound];
		
		// user cell
		_userCell = [[UIPreferencesTableCell alloc] init];
		
		// info cell
		_infoCell = [[PushButtonTableCell alloc] initWithTitle:L(@"ViewUserInfo")
												   upImageName:kImageOrangeButtonUp
												 downImageName:kImageOrangeButtonDown];
		[[_infoCell control] addTarget:self action:@selector(infoButtonClicked:) forEvents:kUIMouseUp];
		
		// chat cell
		_chatCell = [[PushButtonTableCell alloc] initWithTitle:L(@"ChatWithUser")
												   upImageName:kImageOrangeButtonUp
												 downImageName:kImageOrangeButtonDown];
		[[_chatCell control] addTarget:self action:@selector(chatButtonClicked:) forEvents:kUIMouseUp];
		
		// modify remark cell
		_modifyRemarkCell = [[PushButtonTableCell alloc] initWithTitle:L(@"ModifyRemarkName")
												   upImageName:kImageOrangeButtonUp
												 downImageName:kImageOrangeButtonDown];
		[[_modifyRemarkCell control] addTarget:self action:@selector(modifyRemarkButtonClicked:) forEvents:kUIMouseUp];
		
		// move cell
		_moveCell = [[PushButtonTableCell alloc] initWithTitle:L(@"MoveUser")
												   upImageName:kImageOrangeButtonUp
												 downImageName:kImageOrangeButtonDown];
		[[_moveCell control] addTarget:self action:@selector(moveButtonClicked:) forEvents:kUIMouseUp];
		
		// delete cell
		_deleteCell = [[PushButtonTableCell alloc] initWithTitle:L(@"DeleteUser")
													 upImageName:kImageOrangeButtonUp
												   downImageName:kImageOrangeButtonDown];
		[[_deleteCell control] addTarget:self action:@selector(deleteButtonClicked:) forEvents:kUIMouseUp];
		
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
		
		// get argument
		_groupManager = [_data objectForKey:kDataKeyGroupManager];
		_client = [_data objectForKey:kDataKeyClient];
		
		// save user
		_user = [_data objectForKey:kDataKeyUser];
		if(_user == nil)
			[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:nil];
		
		// init UI
		[_userCell setIcon:[_user headWithStatus:NO]];
		[_userCell setTitle:[_user shortDisplayName]];
		
		// set navigation bar title
		[[[_uiController navBar] topItem] setTitle:[_userCell title]];
		
		// reload table
		[_table reloadData];
	}
	
	[_client addQQListener:self];
}

- (void)infoButtonClicked:(UIPushButton*)button {
	[_uiController transitTo:kUIUnitUserInfo style:kTransitionStyleLeftSlide data:_data];
}

- (void)chatButtonClicked:(UIPushButton*)button {
	[_uiController transitTo:kUIUnitUserChat style:kTransitionStyleLeftSlide data:_data];
}

- (void)modifyRemarkButtonClicked:(UIPushButton*)button {
	NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:kUIUnitMain, kDataKeyFrom,
								 _user, kDataKeyNotificationObject,
								 [_user remarkName], kDataKeyStringValue,
								 kUserRemarkNameChangedNotificationName, kDataKeyNotificationName,
								 L(@"RemarkName"), kDataKeyTextCellTitle,
								 L(@"ModifyRemarkName"), kDataKeyTitle,
								 L(@"OK"), kDataKeyApplyButtonTitle,
								 nil];
	[_uiController transitTo:kUIUnitNameEdit style:kTransitionStyleLeftSlide data:data];
}

- (void)moveButtonClicked:(UIPushButton*)button {
	NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:[_groupManager allUserGroupNames], kDataKeyStringValueArray,
		kUserWillBeMovedToGroupNotificationName, kDataKeyNotificationName,
		_user, kDataKeyNotificationObject,
		L(@"MoveToGroup"), kDataKeyTitle,
		kUIUnitMain, kDataKeyFrom,
		nil];
	[_uiController transitTo:kUIUnitSelectValue style:kTransitionStyleLeftSlide data:data];
}

- (void)deleteButtonClicked:(UIPushButton*)button {
	int groupIndex = [_user groupIndex];
	if(groupIndex == [_groupManager strangerGroupIndex] || groupIndex == [_groupManager blacklistGroupIndex]) {
		// remove user and reload user table
		[_user retain];
		[_groupManager removeUser:_user];
		
		// notify
		[[NSNotificationCenter defaultCenter] postNotificationName:kUserRemovedNotificationName
															object:_user];
		[_user release];
		
		// back
		[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:nil];
	} else {
		_alertType = _kAlertConfirmDeleteUser;
		[UIUtil showQuestion:L(@"ConfirmMoveUserToStranger") title:L(@"Question") delegate:self];
	}
}

#pragma mark -
#pragma mark alert delegate

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
	
	// 1 is ok button, the index starts from 0!
	if(_alertType == _kAlertConfirmDeleteUser) {
		if(button == 1) {		
			// show alert
			_alertSheet = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
			[_alertSheet setBodyText:L(@"GettingDeleteAuthInfo")];
			[_alertSheet presentSheetFromAboveView:_table];
			
			// get delete user auth info
			_waitingSequence = [_client getDeleteUserAuthInfo:[_user QQ]];
		}
	} else if(_alertType == _kAlertDeleteUserFailed || _alertType == _kAlertDeleteUserSuccess) {
		[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:nil];
	}
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
#pragma mark preference table delegate and data source

-(int)numberOfGroupsInPreferencesTable:(UIPreferencesTable*)aTable {
	return 6;
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
		case 4:
			return 1;
		case 5:
			return 1;
		default:
			return 0;
	}
}

-(float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed {
	switch(group) {
		case 0:
			switch(row) {
				case 0:
					return 50.0f;
			}
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
					return _userCell;
			}
			break;
		case 1:
			switch(row) {
				case 0:
					return _infoCell;
			}
			break;
		case 2:
			switch(row) {
				case 0:
					return _chatCell;
			}
			break;
		case 3:
			switch(row) {
				case 0:
					return _modifyRemarkCell;
			}
			break;
		case 4:
			switch(row) {
				case 0:
					return _moveCell;
			}
			break;
		case 5:
			switch(row) {
				case 0:
					return _deleteCell;
			}
			break;
	}
	return nil; 
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventRemoveFriendFromListFailed:
		case kQQEventDeleteFriendFailed:
		case kQQEventTimeoutBasic:
		{
			OutPacket* packet = [event outPacket];
			if([packet sequence] == _waitingSequence) {
				// dismiss alert
				[_alertSheet dismiss];
				[_alertSheet release];
				_alertSheet = nil;
				
				// show a message
				_alertType = _kAlertDeleteUserFailed;
				[UIUtil showWarning:L(@"DeleteUserFailed") title:L(@"Fail") delegate:self];
				
				return YES;
			}
			break;
		}
		case kQQEventGetAuthInfoOK:
			ret = [self handleGetAuthInfoOK:event];
			break;
		case kQQEventDeleteFriendOK:
			ret = [self handleDeleteFriendOK:event];
			break;
		case kQQEventRemoveFriendFromListOK:
			ret = [self handleRemoveFriendFromListOK:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleRemoveFriendFromListOK:(QQNotification*)event {
	OutPacket* packet = [event outPacket];
	if([packet sequence] == _waitingSequence) {
		// remove user and reload user table
		[_user retain];
		[_groupManager removeUser:_user];
		
		// dismiss alert
		[_alertSheet dismiss];
		[_alertSheet release];
		_alertSheet = nil;
		
		// notify
		[[NSNotificationCenter defaultCenter] postNotificationName:kUserRemovedNotificationName
															object:_user];
		[_user release];
		
		// back
		[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:nil];
		
		return YES;
	}
	return NO;
}

- (BOOL)handleDeleteFriendOK:(QQNotification*)event {
	OutPacket* packet = [event outPacket];
	if([packet sequence] == _waitingSequence) {
		[_alertSheet setBodyText:L(@"RemovingUserFromServerList")];
		_waitingSequence = [_client removeFriendFromServerList:[_user QQ]];
		
		return YES;
	}
	return NO;
}

- (BOOL)handleGetAuthInfoOK:(QQNotification*)event {
	AuthInfoOpReplyPacket* packet = (AuthInfoOpReplyPacket*)[event object];
	if(_waitingSequence == [packet sequence]) {
		// get auth info
		if(_authInfo) {
			[_authInfo release];
			_authInfo = nil;
		}
		_authInfo = [packet authInfo];
		[_authInfo retain];
		
		// delete user
		[_alertSheet setBodyText:L(@"DeletingUser")];
		_waitingSequence = [_client deleteFriend:[_user QQ] authInfo:_authInfo];
		
		return YES;
	}
	return NO;
}

@end
