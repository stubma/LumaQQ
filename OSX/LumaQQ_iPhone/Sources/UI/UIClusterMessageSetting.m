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

#import "UIClusterMessageSetting.h"
#import <UIKit/UINavigationItem.h>
#import "Constants.h"
#import "UIController.h"
#import "LocalizedStringTool.h"
#import "UIUtil.h"
#import "ClusterModifyMessageSettingPacket.h"

#define _kRowAccept 1
#define _kRowAutoEject 2
#define _kRowDisplayCount 3
#define _kRowAcceptNoPrompt 4
#define _kRowBlock 5

@implementation UIClusterMessageSetting

- (void) dealloc {
	[_table release];
	[_acceptCell release];
	[_autoEjectCell release];
	[_displayCountCell release];
	[_acceptNoPromptCell release];
	[_blockCell release];
	[_saveToServerCell release];
	[_clearFromServerCell release];
	[_okCell release];
	[_data release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitClusterMessageSetting;
}

- (void)begin:(UIController*)uiController {
	// save controller
	_uiController = uiController;
	
	// push navigation item
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:L(@"ClusterMessageSetting")] autorelease];
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
		
		// create accept cell
		_acceptCell = [[UIPreferencesTableCell alloc] init];
		[_acceptCell setTitle:L(@"AcceptMessage")];
		
		// create auto eject cell
		_autoEjectCell = [[UIPreferencesTableCell alloc] init];
		[_autoEjectCell setTitle:L(@"AutoEjectMessage")];
		
		// create display count cell
		_displayCountCell = [[UIPreferencesTableCell alloc] init];
		[_displayCountCell setTitle:L(@"DisplayMessageCount")];
		
		// create accept no prompt cell
		_acceptNoPromptCell = [[UIPreferencesTableCell alloc] init];
		[_acceptNoPromptCell setTitle:L(@"AcceptMessageNoPrompt")];
		
		// create block cell
		_blockCell = [[UIPreferencesTableCell alloc] init];
		[_blockCell setTitle:L(@"BlockMessages")];
		
		// create saveToServer cell
		_saveToServerCell = [[PushButtonTableCell alloc] initWithTitle:L(@"SaveMessageSettingToServer")
														   upImageName:kImageBlueButtonUp
														 downImageName:kImageBlueButtonDown];
		[[_saveToServerCell control] addTarget:self action:@selector(saveButtonClicked:) forEvents:kUIMouseUp];
		
		// create clear cell
		_clearFromServerCell = [[PushButtonTableCell alloc] initWithTitle:L(@"ClearMessageSettingFromServer")
															  upImageName:kImageBlueButtonUp
															downImageName:kImageBlueButtonDown];
		[[_clearFromServerCell control] addTarget:self action:@selector(clearButtonClicked:) forEvents:kUIMouseUp];
		
		// create ok cell
		_okCell = [[PushButtonTableCell alloc] initWithTitle:L(@"OK")
												 upImageName:kImageGreenButtonUp
											   downImageName:kImageGreenButtonDown];
		[[_okCell control] addTarget:self action:@selector(okButtonClicked:) forEvents:kUIMouseUp];
		
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
		
		// get args
		_cluster = [_data objectForKey:kDataKeyCluster];
		_client = [_data objectForKey:kDataKeyClient];
		
		// init
		[self _checkMessageSetting:[_cluster messageSetting]];
		
		// reload table
		[_table reloadData];
	}
	
	// add qq listener
	[_client addQQListener:self];
}

- (void)saveButtonClicked:(UIPushButton*)button {
	// show alert
	_alertSheet = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
	[_alertSheet setBodyText:L(@"SavingSettingToServer")];
	[_alertSheet presentSheetFromAboveView:_table];
	
	_waitingSequence = [_client modifyMessageSetting:[_cluster internalId]
										  externalId:[_cluster externalId]
									  messageSetting:[self _messageSetting]];
}

- (void)clearButtonClicked:(UIPushButton*)button {
	// show alert
	_alertSheet = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
	[_alertSheet setBodyText:L(@"ClearingSettingFromServer")];
	[_alertSheet presentSheetFromAboveView:_table];
	
	_waitingSequence = [_client modifyMessageSetting:[_cluster internalId]
										  externalId:[_cluster externalId]
									  messageSetting:kQQClusterMessageClearServerSetting];
}

- (void)okButtonClicked:(UIPushButton*)button {
	[self _setMessageSetting];
	[self _back];
}

- (void)_setMessageSetting {
	if([_cluster messageSetting] != [self _messageSetting]) {
		[_cluster setMessageSetting:[self _messageSetting]];
		[[NSNotificationCenter defaultCenter] postNotificationName:kClusterMessagetSettingChangedNotificationName
															object:_cluster];
	}
}

- (void)_checkMessageSetting:(char)messageSetting {
	[_acceptCell setChecked:NO];
	[_autoEjectCell setChecked:NO];
	[_displayCountCell setChecked:NO];
	[_acceptNoPromptCell setChecked:NO];
	[_blockCell setChecked:NO];
	
	switch(messageSetting) {
		case kQQClusterMessageAccept:
			[_acceptCell setChecked:YES];
			break;
		case kQQClusterMessageAutoEject:
			[_autoEjectCell setChecked:YES];
			break;
		case kQQClusterMessageDisplayCount:
			[_displayCountCell setChecked:YES];
			break;
		case kQQClusterMessageAcceptNoPrompt:
			[_acceptNoPromptCell setChecked:YES];
			break;
		case kQQClusterMessageBlock:
			[_blockCell setChecked:YES];
			break;
	}
}

- (char)_messageSetting {
	if([_blockCell isChecked])
		return kQQClusterMessageBlock;
	else if([_autoEjectCell isChecked])
		return kQQClusterMessageAutoEject;
	else if([_displayCountCell isChecked])
		return kQQClusterMessageDisplayCount;
	else if([_acceptNoPromptCell isChecked])
		return kQQClusterMessageAcceptNoPrompt;
	else
		return kQQClusterMessageAccept;
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
#pragma mark preference table delegate and data source

-(int)numberOfGroupsInPreferencesTable:(UIPreferencesTable*)aTable {
	return 4;
}

-(int)preferencesTable:(UIPreferencesTable*)aTable numberOfRowsInGroup:(int)group {
	switch(group) {
		case 0: 
			return 5;
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

-(UIPreferencesTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForRow:(int)row inGroup:(int)group {
	switch(group) {
		case 0:
			switch(row) {
				case 0:
					return _acceptCell;
				case 1:
					return _autoEjectCell;
				case 2:
					return _displayCountCell;
				case 3:
					return _acceptNoPromptCell;
				case 4:
					return _blockCell;
			}
			break;
		case 1:
			switch(row) {
				case 0:
					return _saveToServerCell;
			}
			break;
		case 2:
			switch(row) {
				case 0:
					return _clearFromServerCell;
			}
			break;
		case 3:
			switch(row) {
				case 0:
					return _okCell;
			}
			break;
	}
	return nil; 
}

- (void)tableRowSelected:(NSNotification*)notification {
	switch([_table selectedRow]) {
		case _kRowAccept:
			[self _checkMessageSetting:kQQClusterMessageAccept];
			break;
		case _kRowAutoEject:
			[self _checkMessageSetting:kQQClusterMessageAutoEject];
			break;
		case _kRowDisplayCount:
			[self _checkMessageSetting:kQQClusterMessageDisplayCount];
			break;
		case _kRowAcceptNoPrompt:
			[self _checkMessageSetting:kQQClusterMessageAcceptNoPrompt];
			break;
		case _kRowBlock:
			[self _checkMessageSetting:kQQClusterMessageBlock];
			break;
	}
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventClusterModifyMessageSettingFailed:
		case kQQEventTimeoutBasic:
			ret = [self handleTimeout:event];
			break;
		case kQQEventClusterModifyMessageSettingOK:
			ret = [self handleModifyMessageSettingOK:event];
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

- (BOOL)handleModifyMessageSettingOK:(QQNotification*)event {
	ClusterModifyMessageSettingPacket* packet = (ClusterModifyMessageSettingPacket*)[event outPacket];
	if(_waitingSequence == [packet sequence]) {
		if([packet messageSetting] != kQQClusterMessageClearServerSetting)
			[self _setMessageSetting];
		
		// dismiss alert
		[_alertSheet dismiss];
		[_alertSheet release];
		_alertSheet = nil;
		
		return YES;
	}
	return NO;
}

@end
