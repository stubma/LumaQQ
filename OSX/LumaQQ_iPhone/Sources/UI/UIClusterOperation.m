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

#import "UIClusterOperation.h"
#import <UIKit/UINavigationItem.h>
#import "UIController.h"
#import "NSString-Validate.h"
#import "LocalizedStringTool.h"
#import "Constants.h"
#import "UIUtil.h"
#import "ClusterCommandReplyPacket.h"

#define _kAlertConfirmExit 0
#define _kAlertExitSuccess 1

@implementation UIClusterOperation

- (void) dealloc {
	[_table release];
	[_data release];
	[_clusterCell release];
	[_infoCell release];
	[_chatCell release];
	[_exitCell release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitClusterOperation;
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
	
	// remove qq listener
	[_client removeQQListener:self];
}

- (UIView*)view {
	if(_table == nil) {				
		// create edit view
		CGRect bound = [_uiController clientRect];
		_table = [[UIPreferencesTable alloc] initWithFrame:bound];
		
		// cluster cell
		_clusterCell = [[UIPreferencesTableCell alloc] init];
		
		// info cell
		_infoCell = [[PushButtonTableCell alloc] initWithTitle:L(@"ViewClusterInfo")
													 upImageName:kImageOrangeButtonUp
												   downImageName:kImageOrangeButtonDown];
		[[_infoCell control] addTarget:self action:@selector(infoButtonClicked:) forEvents:kUIMouseUp];
		
		// chat cell
		_chatCell = [[PushButtonTableCell alloc] initWithTitle:L(@"ChatInCluster")
													 upImageName:kImageOrangeButtonUp
												   downImageName:kImageOrangeButtonDown];
		[[_chatCell control] addTarget:self action:@selector(chatButtonClicked:) forEvents:kUIMouseUp];
		
		// setting cell
		_settingCell = [[PushButtonTableCell alloc] initWithTitle:L(@"EditMessageSetting")
												   upImageName:kImageOrangeButtonUp
												 downImageName:kImageOrangeButtonDown];
		[[_settingCell control] addTarget:self action:@selector(settingButtonClicked:) forEvents:kUIMouseUp];
		
		// exit cell
		_exitCell = [[PushButtonTableCell alloc] initWithTitle:L(@"ExitCluster")
													 upImageName:kImageOrangeButtonUp
												   downImageName:kImageOrangeButtonDown];
		[[_exitCell control] addTarget:self action:@selector(exitButtonClicked:) forEvents:kUIMouseUp];
		
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
		
		// get cluster
		_cluster = [_data objectForKey:kDataKeyCluster];
		_client = [_data objectForKey:kDataKeyClient];
		
		// init UI
		[_clusterCell setTitle:[_cluster name]];
		
		// set navigation bar title
		[[[_uiController navBar] topItem] setTitle:[_clusterCell title]];
		
		// reload table
		[_table reloadData];
	}
	
	// add qq listener
	[_client addQQListener:self];
}

- (void)infoButtonClicked:(UIPushButton*)button {
	[_uiController transitTo:kUIUnitClusterInfo style:kTransitionStyleLeftSlide data:_data];
}

- (void)chatButtonClicked:(UIPushButton*)button {
	[_uiController transitTo:kUIUnitClusterChat style:kTransitionStyleLeftSlide data:_data];
}

- (void)settingButtonClicked:(UIPushButton*)button {
	[_uiController transitTo:kUIUnitClusterMessageSetting style:kTransitionStyleLeftSlide data:_data];
}

- (void)exitButtonClicked:(UIPushButton*)button {
	_alertType = _kAlertConfirmExit;
	[UIUtil showQuestion:L(@"ConfirmExitCluster") title:L(@"Question") delegate:self];
}

#pragma mark -
#pragma mark alert sheet delegate

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
	
	// 1 is ok button, the index starts from 1!
	switch(_alertType) {
		case _kAlertConfirmExit:
			if(button == 1) {
				// show alert
				_alertSheet = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
				[_alertSheet setBodyText:L(@"ExitingCluster")];
				[_alertSheet presentSheetFromAboveView:_table];
				
				// exit
				_waitingSequence = [_client exitCluster:[_cluster internalId]];
			}
			break;
		case _kAlertExitSuccess:
			[[NSNotificationCenter defaultCenter] postNotificationName:kClusterExitedNotificationName
																object:_cluster];
			break;
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
	return 5;
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
					return _clusterCell;
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
					return _settingCell;
			}
			break;
		case 4:
			switch(row) {
				case 0:
					return _exitCell;
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
		case kQQEventClusterExitFailed:
		case kQQEventTimeoutBasic:
			ret = [self handleTimeout:event];
			break;
		case kQQEventClusterExitOK:
			ret = [self handleExitClusterOK:event];
			break;
	}
}

- (BOOL)handleTimeout:(QQNotification*)event {
	OutPacket* packet = [event outPacket];
	if(_waitingSequence == [packet sequence]) {
		// dismiss alert
		[_alertSheet dismiss];
		[_alertSheet release];
		_alertSheet = nil;
		
		// return yes
		return YES;
	}
	return NO;
}

- (BOOL)handleExitClusterOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = (ClusterCommandReplyPacket*)[event object];
	if(_waitingSequence = [packet sequence]) {
		// dismiss alert
		[_alertSheet dismiss];
		[_alertSheet release];
		_alertSheet = nil;
		
		// show hint
		_alertType = _kAlertExitSuccess;
		[UIUtil showWarning:L(@"ExitClusterSuccess") title:L(@"Success") delegate:self];
		
		return YES;
	}
	return NO;
}

@end
