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

#import <UIKit/UIKit.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIPreferencesControlTableCell.h>
#import <UIKit/UISwitchControl.h>
#import "UIPreference.h"
#import "QQConstants.h"
#import "UIController.h"
#import "LocalizedStringTool.h"
#import "PreferenceTool.h"
#import "FileTool.h"
#import "UIController.h"
#import "GetFriendGroupJob.h"

extern UInt32 gMyQQ;

#define _kRowSoundScheme 13

@implementation UIPreference

- (void) dealloc {
	[_table release];
	[_showOnlineOnlyCell release];
	[_showNickCell release];
	[_showStatusMessageCell release];
	[_showSignatureCell release];
	[_showLevelCell release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitPreference;
}

- (void)begin:(UIController*)uiController {
	// save controller
	_uiController = uiController;
	
	// push navigation item
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:L(@"Preference")] autorelease];
	[[uiController navBar] pushNavigationItem:item];
	
	// show button
	[[uiController navBar] showButtonsWithLeftTitle:L(@"Save") rightTitle:L(@"Cancel")];
	
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
		
		//
		// create table cell for every preference
		//
		
		// update friend group cell
		_updateFriendGroupCell = [[PushButtonTableCell alloc] initWithTitle:L(@"UpdateFriendGroup")
																upImageName:kImageOrangeButtonUp
															  downImageName:kImageOrangeButtonDown];
		[[_updateFriendGroupCell control] addTarget:self action:@selector(updateFriendGroupButtonClicked:) forEvents:kUIMouseUp];
		
		// show online only
		_showOnlineOnlyCell = [[UIPreferencesControlTableCell alloc] init];
		[_showOnlineOnlyCell setTitle:L(@"ShowOnlineOnly")];
		UISwitchControl* showOnlineOnlySwitch = [[[UISwitchControl alloc] initWithFrame:DEFAULT_SWITCH_RECT] autorelease];
		[_showOnlineOnlyCell setControl:showOnlineOnlySwitch];
		[_showOnlineOnlyCell setShowSelection:NO];
		
		// show nick name
		_showNickCell = [[UIPreferencesControlTableCell alloc] init];
		[_showNickCell setTitle:L(@"ShowNick")];
		UISwitchControl* showNickSwitch = [[[UISwitchControl alloc] initWithFrame:DEFAULT_SWITCH_RECT] autorelease];
		[_showNickCell setControl:showNickSwitch];
		[_showNickCell setShowSelection:NO];
		
		// show status message
		_showStatusMessageCell = [[UIPreferencesControlTableCell alloc] init];
		[_showStatusMessageCell setTitle:L(@"ShowStatusMessage")];
		UISwitchControl* showStatusMessageSwitch = [[[UISwitchControl alloc] initWithFrame:DEFAULT_SWITCH_RECT] autorelease];
		[_showStatusMessageCell setControl:showStatusMessageSwitch];
		[_showStatusMessageCell setShowSelection:NO];
		
		// show signature
		_showSignatureCell = [[UIPreferencesControlTableCell alloc] init];
		[_showSignatureCell setTitle:L(@"ShowSignature")];
		UISwitchControl* showSignatureSwitch = [[[UISwitchControl alloc] initWithFrame:DEFAULT_SWITCH_RECT] autorelease];
		[_showSignatureCell setControl:showSignatureSwitch];
		[_showSignatureCell setShowSelection:NO];
		
		// show level
		_showLevelCell = [[UIPreferencesControlTableCell alloc] init];
		[_showLevelCell setTitle:L(@"ShowLevel")];
		UISwitchControl* showLevelSwitch = [[[UISwitchControl alloc] initWithFrame:DEFAULT_SWITCH_RECT] autorelease];
		[_showLevelCell setControl:showLevelSwitch];
		[_showLevelCell setShowSelection:NO];
		
		// create button bar count cell
		_buttonBarCountCell = [[UIPreferencesTableCell alloc] init];
		_buttonBarCountSegment = [[UISegmentedControl alloc] initWithFrame:CGRectMake(130, 10, 170, 45)
																 withStyle:0
																 withItems:[NSArray arrayWithObjects:@"3", @"4", @"5", @"6", @"7", nil]];
		[_buttonBarCountCell setTitle:L(@"ButtonBarCount")];
		[_buttonBarCountCell addSubview:_buttonBarCountSegment];
		[_buttonBarCountCell setShowSelection:NO];
		[_buttonBarCountSegment setDelegate:self];
		
		// reject stranger message
		_rejectStrangerMessageCell = [[UIPreferencesControlTableCell alloc] init];
		[_rejectStrangerMessageCell setTitle:L(@"RejectStrangerMessage")];
		UISwitchControl* rejectStrangerMessageSwitch = [[[UISwitchControl alloc] initWithFrame:DEFAULT_SWITCH_RECT] autorelease];
		[_rejectStrangerMessageCell setControl:rejectStrangerMessageSwitch];
		[_rejectStrangerMessageCell setShowSelection:NO];
		
		// enable sound
		_enableSoundCell = [[UIPreferencesControlTableCell alloc] init];
		[_enableSoundCell setTitle:L(@"EnableSound")];
		UISwitchControl* enableSoundSwitch = [[[UISwitchControl alloc] initWithFrame:DEFAULT_SWITCH_RECT] autorelease];
		[_enableSoundCell setControl:enableSoundSwitch];
		[_enableSoundCell setShowSelection:NO];
		
		// sound scheme
		_soundSchemeCell = [[UIPreferencesTableCell alloc] init];
		[_soundSchemeCell setTitle:L(@"SoundScheme")];
		[_soundSchemeCell setShowDisclosure:YES];
		
		// init table
		[_table setDataSource:self];
		[_table setDelegate:self];
		[_table reloadData];
	}
	return _table;
}

- (void)refresh:(NSMutableDictionary*)data {	
	// clear selection
	[_table selectRow:-1 byExtendingSelection:NO withFade:NO];
	
	// get groupmanager and client
	_groupManager = [data objectForKey:kDataKeyGroupManager];
	_client = [data objectForKey:kDataKeyClient];
	
	// get preference
	PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
	
	// initial UI
	[(UISwitchControl*)[_showOnlineOnlyCell control] setValue:[tool booleanValue:kPreferenceKeyShowOnlineOnly]];
	[(UISwitchControl*)[_showNickCell control] setValue:[tool booleanValue:kPreferenceKeyShowNick]];
	[(UISwitchControl*)[_showStatusMessageCell control] setValue:[tool booleanValue:kPreferenceKeyShowStatusMessage]];
	[(UISwitchControl*)[_showSignatureCell control] setValue:[tool booleanValue:kPreferenceKeyShowSignature]];
	[(UISwitchControl*)[_showLevelCell control] setValue:[tool booleanValue:kPreferenceKeyShowLevel]];
	[(UISwitchControl*)[_rejectStrangerMessageCell control] setValue:[tool booleanValue:kPreferenceKeyRejectStrangerMessage]];
	[(UISwitchControl*)[_enableSoundCell control] setValue:![tool booleanValue:kPreferenceKeyDisableSound]];
	[_soundSchemeCell setValue:[tool stringValue:kPreferenceKeySoundScheme]];
	[_buttonBarCountSegment selectSegment:([tool intValue:kPreferenceKeyButtonBarButtonCount defaultValue:5] - 3)];
	
	// add notification handler
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleSoundSchemeSelected:)
												 name:kSoundSchemeSelectedNotificationName
											   object:nil];
}

- (void)handleSoundSchemeSelected:(NSNotification*)notification {
	NSString* sound = [[notification userInfo] objectForKey:kUserInfoStringValue];
	[_soundSchemeCell setValue:sound];
}

- (void)updateFriendGroupButtonClicked:(UIPushButton*)button {
	// show alert
	_alertSheet = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
	[_alertSheet setBodyText:L(@"UpdatingGroupName")];
	[_alertSheet presentSheetFromAboveView:_table];
	
	// install jobs
	[_client addQQListener:self];
	JobController* jobController = [[JobController alloc] initWithContext:[NSDictionary dictionaryWithObjectsAndKeys:_groupManager, kDataKeyGroupManager, _client, kDataKeyClient, nil]];
	[jobController setTarget:self];
	[jobController setAction:@selector(updateFriendGroupJobTerminated:)];
	[jobController startJob:[[[GetFriendGroupJob alloc] initWithGroupManager:_groupManager] autorelease]];
}

- (void)updateFriendGroupJobTerminated:(JobController*)jobController {
	// remove qq listener
	[_client removeQQListener:self];
	
	// notify
	[[NSNotificationCenter defaultCenter] postNotificationName:kFriendGroupRebuiltNotificationName
														object:nil];
	
	// dismiss alert
	[_alertSheet dismiss];
	[_alertSheet release];
	_alertSheet = nil;
	
	// back to main
	[_uiController transitTo:kUIUnitMain style:kTransitionStyleRightSlide data:nil];
}

#pragma mark -
#pragma mark navigation bar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button {
	switch(button) {
		case kNavButtonLeft:
		{
			// save preference
			PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
			[tool setBool:([[_showOnlineOnlyCell control] value] != 0) forKey:kPreferenceKeyShowOnlineOnly];
			[tool setBool:([[_showNickCell control] value] != 0) forKey:kPreferenceKeyShowNick];
			[tool setBool:([[_showStatusMessageCell control] value] != 0) forKey:kPreferenceKeyShowStatusMessage];
			[tool setBool:([[_showSignatureCell control] value] != 0) forKey:kPreferenceKeyShowSignature];
			[tool setBool:([[_showLevelCell control] value] != 0) forKey:kPreferenceKeyShowLevel];
			[tool setBool:([[_rejectStrangerMessageCell control] value] != 0) forKey:kPreferenceKeyRejectStrangerMessage];
			[tool setBool:([[_enableSoundCell control] value] == 0) forKey:kPreferenceKeyDisableSound];
			[tool setString:[_soundSchemeCell value] forKey:kPreferenceKeySoundScheme];
			[tool setInt:(3 + [_buttonBarCountSegment selectedSegment]) forKey:kPreferenceKeyButtonBarButtonCount];
			[tool save];
			
			// back to main
			[_uiController transitTo:kUIUnitMain 
							   style:kTransitionStyleRightSlide 
								data:nil];
			
			// post notification
			[[NSNotificationCenter defaultCenter] postNotificationName:kPreferenceChangedNotificationName
																object:nil];
			break;
		}
		case kNavButtonRight:
			// back to main
			[_uiController transitTo:kUIUnitMain 
							   style:kTransitionStyleRightSlide 
								data:nil];		
			break;
	}
	
	// remove notification handler
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kSoundSchemeSelectedNotificationName
												  object:nil];
}

#pragma mark -
#pragma mark preference table delegate and data source

-(int)numberOfGroupsInPreferencesTable:(UIPreferencesTable*)aTable {
	return 4;
}

-(int)preferencesTable:(UIPreferencesTable*)aTable numberOfRowsInGroup:(int)group {
	switch(group) {
		case 0: // update friend group
			return 1;
		case 1: // display options
			return 6;
		case 2: // message options
			return 1;
		case 3: // sound options
			return 2;
		default:
			return 0;
	}
}

- (id)preferencesTable:(UIPreferencesTable*)aTable titleForGroup:(int)group {
	switch(group) {
		case 1:
			return L(@"DisplayGroup");
		case 2:
			return L(@"MessageGroup");
		case 3:
			return L(@"SoundGroup");
	}
	return nil;
}

-(float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed {
	switch(group) {
		case 1:
			switch(row) {
				case 5:
					return 60.0f;
			}
			break;
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
					return _updateFriendGroupCell;
			}
			break;
		case 1:
			switch(row) {
				case 0:
					return _showOnlineOnlyCell;
				case 1:
					return _showNickCell;
				case 2:
					return _showStatusMessageCell;
				case 3:
					return _showSignatureCell;
				case 4:
					return _showLevelCell;
				case 5:
					return _buttonBarCountCell;
			}
			break;
		case 2:
			switch(row) {
				case 0:
					return _rejectStrangerMessageCell;
			}
			break;
		case 3:
			switch(row) {
				case 0:
					return _enableSoundCell;
				case 1:
					return _soundSchemeCell;
			}
			break;
	}
	return nil; 
}

- (void)tableRowSelected:(NSNotification*)notification {
	switch([_table selectedRow]) {
		case _kRowSoundScheme:
		{
			// get bundle path
			NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
			bundlePath = [bundlePath stringByAppendingPathComponent:kLQBundleDirectorySound];
			
			// get sub dirs
			NSArray* subs = [FileTool subDirectory:bundlePath];
			
			// go to select value
			NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:kUIUnitPreference, kDataKeyFrom,
				subs, kDataKeyStringValueArray,
				L(@"SelectSoundScheme"), kDataKeyTitle,
				kSoundSchemeSelectedNotificationName, kDataKeyNotificationName,
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
		case kQQEventDownloadGroupNamesOK:
			ret = [self handleDownloadGroupNameOK:event];
			break;
		case kQQEventGetFriendGroupOK:
			ret = [self handleGetFriendGroupOK:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleGetFriendGroupOK:(QQNotification*)event {
	[_alertSheet setBodyText:L(@"UpdatingFriendList")];
	return NO;
}

- (BOOL)handleDownloadGroupNameOK:(QQNotification*)event {
	[_alertSheet setBodyText:L(@"UpdatingFriendGroup")];
	return NO;
}

@end
