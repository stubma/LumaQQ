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

#import "UIClusterAuth.h"
#import <UIKit/UINavigationItem.h>
#import "Constants.h"
#import "UIController.h"
#import "LocalizedStringTool.h"
#import "UIUtil.h"
#import "AuthorizeReplyPacket.h"
#import "NSString-Validate.h"

#define _kRowSource 1

@implementation UIClusterAuth

- (void) dealloc {
	[_table release];
	[_sourceCell release];
	[_msgCell release];
	[_approveCell release];
	[_rejectCell release];
	[_data release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitClusterAuth;
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
		// create edit view
		CGRect bound = [_uiController clientRect];
		_table = [[UIPreferencesTable alloc] initWithFrame:bound];
		
		// create source cell
		_sourceCell = [[UIPreferencesTableCell alloc] init];
		
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
		[_msgCell setValue:@""];
		
		// reload table
		[_table reloadData];
		
		// add qq listener
		[_client addQQListener:self];
	}
}

- (void)approveButtonClicked:(UIPushButton*)button {
	// show alert
	_alertSheet = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
	[_alertSheet setBodyText:L(@"ApprovingRequest")];
	[_alertSheet presentSheetFromAboveView:_table];
	
	// approve
	NSDictionary* dict = [_data objectForKey:kDataKeyDictionary];
	NSNumber* cId = [dict objectForKey:kChatLogKeyClusterInternalID];
	NSNumber* qq = [dict objectForKey:kChatLogKeySourceQQ];
	_waitingSequence = [_client approveJoinCluster:[cId unsignedIntValue] 
										  receiver:[qq unsignedIntValue] 
										  authInfo:[dict objectForKey:kChatLogKeyAuthInfo]];
}

- (void)rejectButtonClicked:(UIPushButton*)button {
	// show alert
	_alertSheet = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
	[_alertSheet setBodyText:L(@"RejectingRequest")];
	[_alertSheet presentSheetFromAboveView:_table];
	
	// reject
	NSDictionary* dict = [_data objectForKey:kDataKeyDictionary];
	NSNumber* cId = [dict objectForKey:kChatLogKeyClusterInternalID];
	NSNumber* qq = [dict objectForKey:kChatLogKeySourceQQ];
	_waitingSequence = [_client rejectJoinCluster:[cId unsignedIntValue] 
										 receiver:[qq unsignedIntValue] 
										 authInfo:[dict objectForKey:kChatLogKeyAuthInfo]
										  message:[_msgCell value]];
}

- (void)_back {
	[_client removeQQListener:self];
	
	[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:nil];
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
		case kSMTypeRequestJoinCluster:
			return 4;
		case kSMTypeApproveJoinCluster:
		case kSMTypeRejectJoinCluster:
		case kSMTypeExitCluster:
		case kSMTypeCreateCluster:
		case kSMTypeJoinCluster:
			return 1;
	}
	return 0;
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
		case 1:
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
					return _msgCell;
			}
			break;
		case 2:
			switch(row) {
				case 0:
					return _approveCell;
			}
			break;
		case 3:
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
			NSNumber* cId = [dict objectForKey:kChatLogKeyClusterInternalID];
			Cluster* cluster = [_groupManager cluster:[cId unsignedIntValue]];
			if(cluster == nil)
				cluster = [[[Cluster alloc] initWithInternalId:[cId unsignedIntValue]] autorelease];
			NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:_client, kDataKeyClient,
				_groupManager, kDataKeyGroupManager,
				cluster, kDataKeyCluster,
				kUIUnitClusterAuth, kDataKeyFrom,
				nil];
			[_uiController transitTo:kUIUnitClusterInfo style:kTransitionStyleLeftSlide data:data];
			break;
		}
	}
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventTimeoutBasic:
			ret = [self handleTimeout:event];
			break;
		case kQQEventClusterAuthorizationSendOK:
			ret = [self handleClusterAuthorizationSendOK:event];
			break;
		case kQQEventClusterAuthorizationSendFailed:
			ret = [self handleClusterAuthorizationSendFailed:event];
			break;
	}
	
	return ret;
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

- (BOOL)handleClusterAuthorizationSendFailed:(QQNotification*)event {
	OutPacket* packet = [event outPacket];
	if(_waitingSequence == [packet sequence]) {
		// dismiss alert
		[_alertSheet dismiss];
		[_alertSheet release];
		_alertSheet = nil;
		
		// show warning
		[UIUtil showWarning:L(@"FailedToAuthorize") title:L(@"Warning") delegate:self];
		
		// return yes
		return YES;
	}
	return NO;
}

- (BOOL)handleClusterAuthorizationSendOK:(QQNotification*)event {
	OutPacket* packet = [event outPacket];
	if(_waitingSequence == [packet sequence]) {
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
