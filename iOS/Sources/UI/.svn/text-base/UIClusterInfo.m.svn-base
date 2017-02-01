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

#import "UIClusterInfo.h"
#import <UIKit/UINavigationItem.h>
#import "Constants.h"
#import "UIController.h"
#import "LocalizedStringTool.h"
#import "ClusterCommandReplyPacket.h"
#import "UIUtil.h"

extern UInt32 gMyQQ;

#define _kRowCreator 5
#define _kRowNoAuth 9
#define _kRowNeedAuth 10
#define _kRowDeny 11

@implementation UIClusterInfo

- (void) dealloc {
	[_table release];
	[_idCell release];
	[_nameCell release];
	[_noticeCell release];
	[_descriptionCell release];
	[_refreshCell release];
	[_modifyCell release];
	[_noAuthCell release];
	[_needAuthCell release];
	[_denyCell release];
	[_creatorCell release];
	[_data release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitClusterInfo;
}

- (void)begin:(UIController*)uiController {
	// save controller
	_uiController = uiController;
	
	// push navigation item
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:L(@"ClusterInfo")] autorelease];
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
		[_table setDataSource:self];
		[_table setDelegate:self];
		
		// create id cell
		_idCell = [[UIPreferencesTableCell alloc] init];
		[_idCell setTitle:L(@"ClusterID")];
		[_idCell setEnabled:NO];
		
		// create name cell
		_nameCell = [[UIPreferencesTextTableCell alloc] init];
		[_nameCell setTitle:L(@"ClusterName")];
		
		// create creator cell
		_creatorCell = [[UIPreferencesTableCell alloc] init];
		[_creatorCell setTitle:L(@"Creator")];
		[_creatorCell setShowDisclosure:YES];
		
		// create notice cell
		_noticeCell = [[UIPreferencesTextTableCell alloc] init];
		[_noticeCell setTitle:L(@"ClusterNotice")];
		
		// create description cell
		_descriptionCell = [[UIPreferencesTextTableCell alloc] init];
		[_descriptionCell setTitle:L(@"ClusterDescription")];
		
		// no auth cell
		_noAuthCell = [[UIPreferencesTableCell alloc] init];
		[_noAuthCell setTitle:L(@"ClusterNoAuth")];
		
		// need auth cell
		_needAuthCell = [[UIPreferencesTableCell alloc] init];
		[_needAuthCell setTitle:L(@"ClusterNeedAuth")];
		
		// deny all cell
		_denyCell = [[UIPreferencesTableCell alloc] init];
		[_denyCell setTitle:L(@"ClusterDenyAll")];
		
		// create refresh button
		_refreshCell = [[PushButtonTableCell alloc] initWithTitle:L(@"RefreshClusterInfo")
													  upImageName:kImageOrangeButtonUp
													downImageName:kImageOrangeButtonDown];
		[[_refreshCell control] addTarget:self action:@selector(refreshInfoButtonClicked:) forEvents:kUIMouseUp];
		
		// create modify button
		_modifyCell = [[PushButtonTableCell alloc] initWithTitle:L(@"ModifyClusterInfo")
												   upImageName:kImageGreenButtonUp
												 downImageName:kImageGreenButtonDown];
		[[_modifyCell control] addTarget:self action:@selector(modifyInfoButtonClicked:) forEvents:kUIMouseUp];
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
		
		// get cluster
		_groupManager = [_data objectForKey:kDataKeyGroupManager];
		_client = [_data objectForKey:kDataKeyClient];
		_cluster = [_data objectForKey:kDataKeyCluster];
		
		// init value
		[self _reloadInfo];
		
		// init control
		User* me = [_groupManager me];
		BOOL bAdmin = [me isSuperUser:_cluster];
		[_nameCell setEnabled:bAdmin];
		[_noticeCell setEnabled:bAdmin];
		[_descriptionCell setEnabled:bAdmin];
		[_noAuthCell setEnabled:bAdmin];
		[_needAuthCell setEnabled:bAdmin];
		[_denyCell setEnabled:bAdmin];
		
		// reload
		[_table reloadData];
	}
	
	// add qq listener
	[_client addQQListener:self];
}

- (void)refreshInfoButtonClicked:(UIPushButton*)button {
	// show alert
	_alertSheet = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
	[_alertSheet setBodyText:L(@"RefreshingClusterInfo")];
	[_alertSheet presentSheetFromAboveView:_table];
	
	_waitingSequence = [_client getClusterInfo:[_cluster internalId]];
}

- (void)modifyInfoButtonClicked:(UIPushButton*)button {
	// show alert
	_alertSheet = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
	[_alertSheet setBodyText:L(@"ModifyingClusterInfo")];
	[_alertSheet presentSheetFromAboveView:_table];
	
	_waitingSequence = [_client modifyClusterInfo:[_cluster internalId]
										 authType:[self _authType]
										 category:[[_cluster info] category] 
											 name:[_nameCell value]
										   notice:[_noticeCell value]
									  description:[_descriptionCell value]];
}

- (void)_reloadInfo {
	[_idCell setValue:[NSString stringWithFormat:@"%u", [_cluster externalId]]];
	[_nameCell setValue:[_cluster name]];
	[_noticeCell setValue:[[_cluster info] notice]];
	[_descriptionCell setValue:[[_cluster info] description]];
	[self _checkAuthType:[[_cluster info] authType]];
	User* creator = [_groupManager user:[[_cluster info] creator]];
	if(creator == nil) {
		creator = [[[User alloc] initWithQQ:[[_cluster info] creator]] autorelease];
		[_groupManager registerUser:creator];
	} 
	[_creatorCell setValue:[creator shortDisplayName]];
}

- (char)_authType {
	if([_noAuthCell isChecked])
		return kQQClusterAuthNo;
	else if([_denyCell isChecked])
		return kQQClusterAuthReject;
	else
		return kQQClusterAuthNeed;
}

- (void)_checkAuthType:(char)authType {
	[_noAuthCell setChecked:NO];
	[_needAuthCell setChecked:NO];
	[_denyCell setChecked:NO];
	
	switch(authType) {
		case kQQClusterAuthNo:
			[_noAuthCell setChecked:YES];
			break;
		case kQQClusterAuthNeed:
			[_needAuthCell setChecked:YES];
			break;
		case kQQClusterAuthReject:
			[_denyCell setChecked:YES];
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
#pragma mark alert delegate

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
	
	// 1 is ok button, the index starts from 0!
	if(button == 1) {		
		// back to previous view
		[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:nil];
	}
}

#pragma mark -
#pragma mark preference table delegate and data source

-(int)numberOfGroupsInPreferencesTable:(UIPreferencesTable*)aTable {
	// if I am not super user, I can't modify info
	User* me = [_groupManager me];
	return 3 + ([me isSuperUser:_cluster] ? 1 : 0);
}

-(int)preferencesTable:(UIPreferencesTable*)aTable numberOfRowsInGroup:(int)group {
	switch(group) {
		case 0: 
			return 1;
		case 1: 
			return 5;
		case 2:
			return 3;
		case 3:
			return 1;
		default:
			return 0;
	}
}

- (id)preferencesTable:(UIPreferencesTable*)aTable titleForGroup:(int)group {
	switch(group) {
		case 2:
			return L(@"AuthGroup");
	}
	return nil;
}

-(float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed {
	return proposed;
}

-(UIPreferencesTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForRow:(int)row inGroup:(int)group {
	switch(group) {
		case 0:
			switch(row) {
				case 0:
					return _refreshCell;
			}
			break;
		case 1:
			switch(row) {
				case 0:
					return _idCell;
				case 1:
					return _nameCell;
				case 2:
					return _creatorCell;
				case 3:
					return _noticeCell;
				case 4:
					return _descriptionCell;
			}
			break;
		case 2:
			switch(row) {
				case 0:
					return _noAuthCell;
				case 1:
					return _needAuthCell;
				case 2:
					return _denyCell;
			}
			break;
		case 3:
			switch(row) {
				case 0:
					return _modifyCell;
			}
			break;
	}
	return nil; 
}

- (void)tableRowSelected:(NSNotification*)notification {
	switch([_table selectedRow]) {
		case _kRowCreator:
		{
			User* creator = [_groupManager user:[[_cluster info] creator]];
			if(creator == nil)
				break;
			NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:creator, kDataKeyUser,
										 _groupManager, kDataKeyGroupManager,
										 _client, kDataKeyClient,
										 kUIUnitClusterInfo, kDataKeyFrom,
										 nil];
			[_uiController transitTo:kUIUnitUserInfo style:kTransitionStyleLeftSlide data:data];
			 break;
		}
		case _kRowNoAuth:
			[self _checkAuthType:kQQClusterAuthNo];
			break;
		case _kRowNeedAuth:
			[self _checkAuthType:kQQClusterAuthNeed];
			break;
		case _kRowDeny:
			[self _checkAuthType:kQQClusterAuthReject];
			break;
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
		case kQQEventClusterGetInfoOK:
			ret = [self handleGetClusterInfoOK:event];
			break;
		case kQQEventClusterModifyInfoOK:
			ret = [self handleModifyClusterInfoOK:event];
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
		
		// return yes
		return YES;
	}
	return NO;
}

- (BOOL)handleGetClusterInfoOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = (ClusterCommandReplyPacket*)[event object];
	if(_waitingSequence == [packet sequence]) {
		[self _reloadInfo];
		
		// dismiss alert
		[_alertSheet dismiss];
		[_alertSheet release];
		_alertSheet = nil;
		
		return YES;
	}
	return NO;
}

- (BOOL)handleModifyClusterInfoOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = (ClusterCommandReplyPacket*)[event object];
	if(_waitingSequence == [packet sequence]) {
		// set back to cluster
		[_cluster setName:[_nameCell value]];
		[[_cluster info] setAuthType:[self _authType]];
		[[_cluster info] setNotice:[_noticeCell value]];
		[[_cluster info] setDescription:[_descriptionCell value]];
		
		// dismiss alert
		[_alertSheet dismiss];
		[_alertSheet release];
		_alertSheet = nil;
		
		// show dialog
		[UIUtil showWarning:L(@"ModifyClusterInfoSuccess") title:L(@"Success") delegate:self];
		
		return YES;
	}
	return NO;
}

@end
