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

#import "UIUserAuth.h"
#import <UIKit/UINavigationItem.h>
#import <UIKit/UISwitchControl.h>
#import "Constants.h"
#import "UIController.h"
#import "LocalizedStringTool.h"
#import "UIUtil.h"
#import "AuthorizeReplyPacket.h"
#import "NSString-Validate.h"

#define _kRowSource 1
#define _kRowDestGroup 4

@implementation UIUserAuth

- (void) dealloc {
	[_table release];
	[_sourceCell release];
	[_addHimCell release];
	[_destGroupCell release];
	[_msgCell release];
	[_approveCell release];
	[_rejectCell release];
	[_data release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitUserAuth;
}

- (void)begin:(UIController*)uiController {
	// save controller
	_uiController = uiController;
	
	// push navigation item
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:L(@"ApproveOrReject")] autorelease];
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
		// init variables
		_addHimAsFriend = NO;
		
		// create edit view
		CGRect bound = [_uiController clientRect];
		_table = [[UIPreferencesTable alloc] initWithFrame:bound];
		
		// create source cell
		_sourceCell = [[UIPreferencesTableCell alloc] init];
		
		// create add him cell
		_addHimCell = [[UIPreferencesControlTableCell alloc] init];
		[_addHimCell setTitle:L(@"AddHimAsFriend")];
		UISwitchControl* addHimSwitch = [[[UISwitchControl alloc] initWithFrame:DEFAULT_SWITCH_RECT] autorelease];
		[_addHimCell setControl:addHimSwitch];
		[_addHimCell setShowSelection:NO];
		
		// create dest group cell
		_destGroupCell = [[UIPreferencesTableCell alloc] init];
		[_destGroupCell setTitle:L(@"AddHimToGroup")];
		[_destGroupCell setShowDisclosure:YES];
		
		// create accept no prompt cell
		_msgCell = [[UIPreferencesTextTableCell alloc] init];
		[_msgCell setTitle:L(@"RejectReason")];
		
		// create approve cell
		_approveCell = [[PushButtonTableCell alloc] initWithTitle:L(@"Approve")
													  upImageName:kImageBlueButtonUp
													downImageName:kImageBlueButtonDown];
		[[_approveCell control] addTarget:self action:@selector(approveButtonClicked:) forEvents:kUIMouseUp];
		
		// create reject cell
		_rejectCell = [[PushButtonTableCell alloc] initWithTitle:L(@"Reject")
													 upImageName:kImageBlueButtonUp
												   downImageName:kImageBlueButtonDown];
		[[_rejectCell control] addTarget:self action:@selector(rejectButtonClicked:) forEvents:kUIMouseUp];
		
		// init table
		[_table setDataSource:self];
		[_table setDelegate:self];
	}
	return _table;
}

- (void)refresh:(NSMutableDictionary*)data {	
	// hide keyboard
	[_table setKeyboardVisible:NO];
	
	// clear selection
	[_table selectRow:-1 byExtendingSelection:NO withFade:NO];
	
	if(data != nil) {		
		// save data
		[data retain];
		[_data release];
		_data = data;
		
		// get client
		_client = [_data objectForKey:kDataKeyClient];
		_groupManager = [_data objectForKey:kDataKeyGroupManager];
		
		// get dictionary
		NSDictionary* dict = [_data objectForKey:kDataKeyDictionary];
		[_sourceCell setTitle:[dict objectForKey:kChatLogKeyMessage]];
		
		// init control
		NSNumber* type = [dict objectForKey:kChatLogKeySMType];
		BOOL bCanAdd = [type intValue] == kSMTypeRequestAddMeAndAllowAddHim;
		[[_addHimCell control] setValue:NO];
		[_msgCell setValue:@""];
		[_addHimCell setEnabled:bCanAdd];
		[_destGroupCell setEnabled:bCanAdd];
		[_destGroupCell setValue:[[_groupManager group:0] name]];
		
		// reload table
		[_table reloadData];
		
		// add qq listener
		[_client addQQListener:self];
		
		// add notification handle
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleGroupSelected:)
													 name:kGroupSelectedNotificationName
												   object:nil];
	}
}

- (void)approveButtonClicked:(UIPushButton*)button {
	// show alert
	_alertSheet = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
	[_alertSheet setBodyText:L(@"ApprovingRequest")];
	[_alertSheet presentSheetFromAboveView:_table];
	
	// approve
	NSDictionary* dict = [_data objectForKey:kDataKeyDictionary];
	NSNumber* qq = [dict objectForKey:kChatLogKeySourceQQ];
	NSNumber* type = [dict objectForKey:kChatLogKeySMType];
	if([type intValue] == kSMTypeRequestAddMeAndAllowAddHim) {
		if([[_addHimCell control] value] != 0) {
			_addHimAsFriend = YES;
			_waitingSequence = [_client approveAuthorizationAndAddHim:[qq unsignedIntValue] message:[_msgCell value]];
		} else
			_waitingSequence = [_client approveAuthorization:[qq unsignedIntValue]];
	} else
		_waitingSequence = [_client approveAuthorization:[qq unsignedIntValue]];
}

- (void)rejectButtonClicked:(UIPushButton*)button {
	// show alert
	_alertSheet = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
	[_alertSheet setBodyText:L(@"RejectingRequest")];
	[_alertSheet presentSheetFromAboveView:_table];
	
	// reject
	NSDictionary* dict = [_data objectForKey:kDataKeyDictionary];
	NSNumber* qq = [dict objectForKey:kChatLogKeySourceQQ];
	_waitingSequence = [_client rejectAuthorization:[qq unsignedIntValue] message:[_msgCell value]];
}

- (void)_back {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kGroupSelectedNotificationName
												  object:nil];
	[_client removeQQListener:self];
	_addHimAsFriend = NO;
	
	[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:nil];
}

- (void)handleGroupSelected:(NSNotification*)notification {
	NSString* name = [[notification userInfo] objectForKey:kUserInfoStringValue];
	[_destGroupCell setValue:name];
}

#pragma mark -
#pragma mark navigation bar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button {
	switch(button) {
		case kNavButtonLeft:
			[self _back];
			break;
		case kNavButtonRight:
			break;
	}
}

#pragma mark -
#pragma mark alert delegate

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
	
	[self _back];
}

#pragma mark -
#pragma mark preference table delegate and data source

-(int)numberOfGroupsInPreferencesTable:(UIPreferencesTable*)aTable {
	NSDictionary* dict = [_data objectForKey:kDataKeyDictionary];
	NSNumber* type = [dict objectForKey:kChatLogKeySMType];
	switch([type intValue]) {
		case kSMTypeRequestAddMe:
		case kSMTypeRequestAddMeAndAllowAddHim:
			return 5;
		case kSMTypeApproveMyRequest:
		case kSMTypeApproveMyRequestAndAddMe:
		case kSMTypeRejectMyRequest:
		case kSMTypeAddMe:
			return 1;
	}
	return 0;
}

-(int)preferencesTable:(UIPreferencesTable*)aTable numberOfRowsInGroup:(int)group {
	switch(group) {
		case 0: 
			return 1;
		case 1: 
			return 2;
		case 2:
			return 1;
		case 3:
			return 1;
		case 4:
			return 1;
		default:
			return 0;
	}
}

- (id)preferencesTable:(UIPreferencesTable*)aTable titleForGroup:(int)group {
	NSDictionary* dict = [_data objectForKey:kDataKeyDictionary];
	NSNumber* type = [dict objectForKey:kChatLogKeySMType];
	switch(group) {
		case 1:
			return [type intValue] == kSMTypeRequestAddMeAndAllowAddHim ? L(@"GroupAddHim") : L(@"GroupForbidAddHim");
		case 2:
			return L(@"GroupReject");
	}
	return nil;
}

-(float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed {
	switch(group) {
		case 0:
			switch(row) {
				case 0:
					return 100.0f;
			}
			break;
	}
	return proposed;
}

-(UIPreferencesTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForRow:(int)row inGroup:(int)group {
	switch(group) {
		case 0:
			switch(row) {
				case 0:
					return _sourceCell;
			}
			break;
		case 1:
			switch(row) {
				case 0:
					return _addHimCell;
				case 1:
					return _destGroupCell;
			}
			break;
		case 2:
			switch(row) {
				case 0:
					return _msgCell;
			}
			break;
		case 3:
			switch(row) {
				case 0:
					return _approveCell;
			}
			break;
		case 4:
			switch(row) {
				case 0:
					return _rejectCell;
			}
			break;
	}
	return nil; 
}

- (void)tableRowSelected:(NSNotification*)notification {
	switch([_table selectedRow]) {
		case _kRowSource:
		{
			// hide keyboard
			[_table setKeyboardVisible:NO];
			
			// go to user info
			NSDictionary* dict = [_data objectForKey:kDataKeyDictionary];
			NSNumber* qq = [dict objectForKey:kChatLogKeySourceQQ];
			User* user = [_groupManager user:[qq unsignedIntValue]];
			if(user == nil) {
				user = [[[User alloc] initWithQQ:[qq unsignedIntValue]] autorelease];
				[_groupManager addUser:user groupIndex:kGroupIndexUndefined];
			}
			NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:_client, kDataKeyClient,
				user, kDataKeyUser,
				kUIUnitUserAuth, kDataKeyFrom,
				nil];
			[_uiController transitTo:kUIUnitUserInfo style:kTransitionStyleLeftSlide data:data];
			break;
		}
		case _kRowDestGroup:
		{
			// hide keyboard
			[_table setKeyboardVisible:NO];
			
			// go to select group
			NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:[_groupManager friendlyGroupNames], kDataKeyStringValueArray,
				kGroupSelectedNotificationName, kDataKeyNotificationName,
				L(@"AddHimToGroup"), kDataKeyTitle,
				kUIUnitUserAuth, kDataKeyFrom,
				nil];
			[_uiController transitTo:kUIUnitSelectValue style:kTransitionStyleLeftSlide data:data];
			break;
		}
	}
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventAuthorizeFailed:
			ret = [self handleAuthorizeFailed:event];
			break;
		case kQQEventAuthorizeOK:
			ret = [self handleAuthorizationOK:event];
			break;
		case kQQEventTimeoutBasic:
			ret = [self handleTimeout:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleAuthorizeFailed:(QQNotification*)event {
	AuthorizeReplyPacket* packet = (AuthorizeReplyPacket*)[event object];
	if(_waitingSequence == [packet sequence]) {
		// dismiss alert
		[_alertSheet dismiss];
		[_alertSheet release];
		_alertSheet = nil;
		
		if(![[packet message] isEmpty]) {
			// show warning
			[UIUtil showWarning:[packet message] title:L(@"Warning") delegate:self];
		} else {
			[UIUtil showWarning:L(@"FailedToAuthorize") title:L(@"Warning") delegate:self];
		}
		
		// return yes
		return YES;
	}

	return NO;
}

- (BOOL)handleTimeout:(QQNotification*)event {
	OutPacket* packet = [event outPacket];
	if(_waitingSequence == [packet sequence]) {
		// dismiss alert
		[_alertSheet dismiss];
		[_alertSheet release];
		_alertSheet = nil;
		
		// show warning
		[UIUtil showWarning:L(@"TimeoutToAuthorize") title:L(@"Warning") delegate:self];
		
		// return yes
		return YES;
	}
	return NO;
}

- (BOOL)handleAuthorizationOK:(QQNotification*)event {
	OutPacket* packet = [event outPacket];
	if(_waitingSequence == [packet sequence]) {
		// add user
		if(_addHimAsFriend) {
			int groupIndex = [_groupManager groupIndexByName:[_destGroupCell value]];
			if(groupIndex != -1) {
				NSDictionary* dict = [_data objectForKey:kDataKeyDictionary];
				NSNumber* qq = [dict objectForKey:kChatLogKeySourceQQ];
				User* user = [_groupManager user:[qq unsignedIntValue]];
				if(user == nil) {
					// create user add to friend or stranger group
					user = [[[User alloc] initWithQQ:[qq unsignedIntValue]] autorelease];
					[_groupManager addUser:user groupIndex:groupIndex];					
					[_client getUserInfo:[user QQ]];
				} else if([user groupIndex] == kGroupIndexUndefined) {
					[_groupManager addUser:user groupIndex:groupIndex];
					[_client getUserInfo:[user QQ]];
				}
			}
		}
		
		// dismiss alert
		[_alertSheet dismiss];
		[_alertSheet release];
		_alertSheet = nil;
		
		// back
		[self _back];
		
		// return yes
		return YES;
	}
	
	return NO;
}

@end
