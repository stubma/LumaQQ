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
#import <UIKit/UISwitchControl.h>
#import "UIController.h"
#import "UIAccountEdit.h"
#import "UIUtil.h"
#import "QQConstants.h"
#import "LocalizedStringTool.h"

#define _kServerCellRow 7
#define _kPortCellRow 8

@implementation UIAccountEdit

- (void) dealloc {
	[_editView release];
	[_table release];
	[_qqCell release];
	[_passwordCell release];
	[_loginHiddenCell release];
	[_protocolCell release];
	[_serverCell release];
	[_portCell release];
	[_protocolSegment release];
	[_proxyEnableCell release];
	[_proxyServerCell release];
	[_proxyPortCell release];
	[_proxyUsernameCell release];
	[_proxyPasswordCell release];
	[_data release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitAccountEdit;
}

- (void)begin:(UIController*)uiController {
	// save controller
	_uiController = uiController;
	
	// push navigation item
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:L(@"Account")] autorelease];
	[[uiController navBar] pushNavigationItem:item];
	
	// show button
	[[uiController navBar] showButtonsWithLeftTitle:L(@"Save") rightTitle:L(@"Cancel")];
	
	// set delegate
	[[uiController navBar] setDelegate:self];
	
	// add notification handle
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleServerSelectedNotification:)
												 name:kServerSelectedNotificationName
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handlePortSelectedNotification:)
												 name:kPortSelectedNotificationName
											   object:nil];
}

- (void)stop:(UIController*)uiController {
	[[[uiController navBar] navigationItems] removeAllObjects];
	[[uiController navBar] setDelegate:nil];
}

- (UIView*)view {
	if(_editView == nil) {
		// create data
		_data = [[NSMutableDictionary dictionary] retain];
		
		// create edit view
		CGRect bound = [_uiController clientRect];
		_editView = [[UIView alloc] initWithFrame:bound];
		
		// create qq cell
		_qqCell = [[UIPreferencesTextTableCell alloc] init];
		[_qqCell setTitle:L(@"QQNo")];
		
		// create password cell
		_passwordCell = [[UIPreferencesTextTableCell alloc] init];
		[_passwordCell setTitle:L(@"Password")];
		[[_passwordCell textField] setSecure:YES];
		[[_passwordCell textField] setEditingDelegate:self];
		
		// create login hidden cell
		_loginHiddenCell = [[UIPreferencesControlTableCell alloc] init];
		[_loginHiddenCell setTitle:L(@"LoginHidden")];
		UISwitchControl* loginHiddenSwitch = [[[UISwitchControl alloc] initWithFrame:DEFAULT_SWITCH_RECT] autorelease];
		[_loginHiddenCell setControl:loginHiddenSwitch];
		[_loginHiddenCell setShowSelection:NO];
		
		// create protocol cell
		_protocolCell = [[UIPreferencesTableCell alloc] init];
		_protocolSegment = [[UISegmentedControl alloc] initWithFrame:CGRectMake(170, 10, 130, 45)
														   withStyle:0
														   withItems:[NSArray arrayWithObjects:kQQProtocolUDP, kQQProtocolTCP, nil]];
		[_protocolCell setTitle:L(@"Protocol")];
		[_protocolCell addSubview:_protocolSegment];
		[_protocolCell setShowSelection:NO];
		[_protocolSegment setDelegate:self];
		
		// create server cell
		_serverCell = [[UIPreferencesTableCell alloc] init];
		[_serverCell setTitle:L(@"Server")];
		[_serverCell setShowDisclosure:YES];
		
		// create port cell
		_portCell = [[UIPreferencesTableCell alloc] init];
		[_portCell setTitle:L(@"Port")];
		[_portCell setShowDisclosure:YES];
		
		// create proxy enable cell
		_proxyEnableCell = [[UIPreferencesControlTableCell alloc] init];
		[_proxyEnableCell setTitle:L(@"EnableHttpProxy")];
		UISwitchControl* enableProxySwitch = [[[UISwitchControl alloc] initWithFrame:DEFAULT_SWITCH_RECT] autorelease];
		[_proxyEnableCell setControl:enableProxySwitch];
		[_proxyEnableCell setShowSelection:NO];
		
		// create proxy server cell
		_proxyServerCell = [[UIPreferencesTextTableCell alloc] init];
		[_proxyServerCell setTitle:L(@"ProxyServer")];
		
		// create proxy port cell
		_proxyPortCell = [[UIPreferencesTextTableCell alloc] init];
		[_proxyPortCell setTitle:L(@"ProxyPort")];
		
		// create proxy username cell
		_proxyUsernameCell = [[UIPreferencesTextTableCell alloc] init];
		[_proxyUsernameCell setTitle:L(@"ProxyUsername")];
		
		// create proxy password cell
		_proxyPasswordCell = [[UIPreferencesTextTableCell alloc] init];
		[_proxyPasswordCell setTitle:L(@"ProxyPassword")];
		[[_proxyPasswordCell textField] setSecure:YES];
		
		// create table
		bound.origin.x = 0;
		bound.origin.y = 0;
		_table = [[UIPreferencesTable alloc] initWithFrame:bound];
		[_table setDataSource:self];
		[_table setDelegate:self];
		
		// add table
		[_editView addSubview:_table];
	}
	
	return _editView;
}

- (void)refresh:(NSMutableDictionary*)data {
	// reload data
	[_table reloadData];
	
	// hide keyboard
	[_table setKeyboardVisible:NO];
	
	// clear selection
	[_table selectRow:-1 byExtendingSelection:NO withFade:NO];
	
	// init variables
	_passwordChanged = NO;
	
	if(data != nil) {
		// save new data
		[data retain];
		[_data release];
		_data = data;
		
		// set qq cell value
		NSNumber* n = [_data objectForKey:kDataKeyQQ];
		if(n != nil)
			[_qqCell setValue:[NSString stringWithFormat:@"%u", [n unsignedIntValue]]];
		
		// set password cell
		NSString* s = [_data objectForKey:kDataKeyPassword];
		if(s != nil)
			[_passwordCell setValue:s]; 
		
		// set login hidden cell
		n = [_data objectForKey:kDataKeyLoginHidden];
		if(n != nil)
			[[_loginHiddenCell control] setValue:[n boolValue]];
		
		// set protocol cell
		s = [_data objectForKey:kDataKeyProtocol];
		if(s != nil) {
			if([s isEqualToString:kQQProtocolUDP])
				[_protocolSegment selectSegment:0];
			else
				[_protocolSegment selectSegment:1];
		}
		
		// set server cell
		s = [_data objectForKey:kDataKeyServer];
		if(s != nil)
			[_serverCell setValue:s];
		
		// set server port
		n = [_data objectForKey:kDataKeyPort];
		if(n != nil)
			[_portCell setValue:[NSString stringWithFormat:@"%u", [n intValue]]];
		
		// set enable proxy cell
		n = [_data objectForKey:kDataKeyEnableHTTPProxy];
		if(n != nil) 
			[[_proxyEnableCell control] setValue:[n boolValue]];
		
		// set proxy server cell
		s = [_data objectForKey:kDataKeyHTTPProxyServer];
		if(s != nil)
			[_proxyServerCell setValue:s];
		
		// set proxy port cell
		n = [_data objectForKey:kDataKeyHTTPProxyPort];
		if(n != nil)
			[_proxyPortCell setValue:[NSString stringWithFormat:@"%u", [n intValue]]];
		
		// set proxy user name cell
		s = [_data objectForKey:kDataKeyHTTPProxyUsername];
		if(s != nil)
			[_proxyUsernameCell setValue:s];
		
		// set proxy password cell
		s = [_data objectForKey:kDataKeyHTTPProxyPassword];
		if(s != nil)
			[_proxyPasswordCell setValue:s];
	} else {
		// if data is not set, clear table
		[_qqCell setValue:@""];
		[_passwordCell setValue:@""];
		[_qqCell setPlaceHolderValue:L(@"YourQQNo")];
		[_passwordCell setPlaceHolderValue:L(@"YourPassword")];
		[[_loginHiddenCell control] setValue:YES];
		[_protocolSegment selectSegment:0];
		[_serverCell setValue:LQUDPServers[0]];
		[_portCell setValue:[NSString stringWithFormat:@"%u", kQQPortUDP]];
		[_portCell setEnabled:NO];
		[[_proxyEnableCell control] setValue:NO];
		[_proxyServerCell setPlaceHolderValue:L(@"ProxyServerPlaceholder")];
		[_proxyPortCell setPlaceHolderValue:L(@"ProxyPortPlaceholder")];
		[_proxyUsernameCell setPlaceHolderValue:L(@"ProxyUsernamePlaceholder")];
		[_proxyPasswordCell setPlaceHolderValue:L(@"ProxyPasswordPlaceholder")];
	}
}

- (void)handleServerSelectedNotification:(NSNotification*)notification {
	[_serverCell setValue:[[notification userInfo] objectForKey:kUserInfoStringValue]];
}

- (void)handlePortSelectedNotification:(NSNotification*)notification {
	[_portCell setValue:[[notification userInfo] objectForKey:kUserInfoStringValue]];
}

- (void)_back:(NSMutableDictionary*)data {
	// remove notification handler
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kServerSelectedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kPortSelectedNotificationName
												  object:nil];
	
	// back to account manage
	[_uiController transitTo:kUIUnitAccountManage style:kTransitionStyleRightSlide data:data];
}

#pragma mark -
#pragma mark editing delegate

- (BOOL)keyboardInput:(id)field shouldInsertText:(NSString*)text isMarkedText:(int)b {
	_passwordChanged = YES;
	return YES;
}

#pragma mark -
#pragma mark navigation bar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button {
	switch(button) {
		case kNavButtonLeft:
		{
			// validate qq
			UInt32 qq = [[_qqCell value] intValue];
			if(qq <= 10000) {
				[UIUtil showWarning:L(@"InvalidQQNumber") title:L(@"Warning") delegate:self];
				return;
			}
			
			// validate password
			NSString* pwd = [_passwordCell value];
			if([pwd length] == 0) {
				[UIUtil showWarning:L(@"EmptyPassword") title:L(@"Warning") delegate:self];
				return;
			}
			
			// validate protocol
			BOOL bProxyEnabled = [[_proxyEnableCell control] value] != 0;
			if(bProxyEnabled) {
				if([_protocolSegment selectedSegment] == 0) {
					[UIUtil showWarning:L(@"HttpProxyNeedTCP") title:L(@"Warning") delegate:self];
					return;
				}
			}
			
			// save parameters
			[_data setObject:[NSNumber numberWithUnsignedInt:qq] forKey:kDataKeyQQ];
			[_data setObject:pwd forKey:kDataKeyPassword];
			[_data setObject:[NSNumber numberWithBool:([[_loginHiddenCell control] value] != 0)] forKey:kDataKeyLoginHidden];
			[_data setObject:([_protocolSegment selectedSegment] == 0 ? kQQProtocolUDP : kQQProtocolTCP) forKey:kDataKeyProtocol];
			[_data setObject:[_serverCell value] forKey:kDataKeyServer];
			[_data setObject:[NSNumber numberWithInt:[[_portCell value] intValue]] forKey:kDataKeyPort];
			[_data setObject:[NSNumber numberWithBool:bProxyEnabled] forKey:kDataKeyEnableHTTPProxy];
			if([_proxyServerCell value] != nil)
				[_data setObject:[_proxyServerCell value] forKey:kDataKeyHTTPProxyServer];
			if([_proxyPortCell value] != nil)
				[_data setObject:[NSNumber numberWithInt:[[_proxyPortCell value] intValue]] forKey:kDataKeyHTTPProxyPort];
			if([_proxyUsernameCell value] != nil)
				[_data setObject:[_proxyUsernameCell value] forKey:kDataKeyHTTPProxyUsername];
			if([_proxyPasswordCell value] != nil)
				[_data setObject:[_proxyPasswordCell value] forKey:kDataKeyHTTPProxyPassword];
			
			// set dont make md5 value
			if(_passwordChanged)
				[_data setObject:[NSNumber numberWithBool:NO] forKey:kDataKeyDontMakeMD5];
			
			// back to account manage
			[self _back:_data];
			break;
		}
		case kNavButtonRight:
			[self _back:nil];
			break;
	}
}

#pragma mark -
#pragma mark alert sheet delegate

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
}

#pragma mark -
#pragma mark segment control delegate

- (void)segmentedControl:(UISegmentedControl*)segmentedControl selectedSegmentChanged:(int)segment {
	switch(segment) {
		case 0:
			[_serverCell setValue:LQUDPServers[0]];
			[_portCell setValue:[NSString stringWithFormat:@"%u", kQQPortUDP]];
			[_portCell setEnabled:NO];
			break;
		case 1:
			[_serverCell setValue:LQTCPServers[1]];
			[_portCell setValue:[NSString stringWithFormat:@"%u", kQQPortTCPSecure]];
			[_portCell setEnabled:YES];
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
		case 0: // qq and password
			return 2;
		case 1: // login hidden
			return 1;
		case 2: // login server and protocol and port
			return 3;
		case 3: // http proxy
			return 5;
		default:
			return 0;
	}
}

- (id)preferencesTable:(UIPreferencesTable*)aTable titleForGroup:(int)group {
	switch(group) {
		case 3:
			return L(@"GroupHttpProxy");
	}
	return nil;
}

-(float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed {
	switch(group) {
		case 2:
			switch(row) {
				case 0:
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
					return _qqCell;
				case 1:
					return _passwordCell;
			}
			break;
		case 1:
			switch(row) {
				case 0:
					return _loginHiddenCell;
			}
			break;
		case 2:
			switch(row) {
				case 0:
					return _protocolCell;
				case 1:
					return _serverCell;
				case 2:
					return _portCell;
			}
			break;
		case 3:
			switch(row) {
				case 0:
					return _proxyEnableCell;
				case 1:
					return _proxyServerCell;
				case 2:
					return _proxyPortCell;
				case 3:
					return _proxyUsernameCell;
				case 4:
					return _proxyPasswordCell;
			}
	}
	return nil; 
}

- (void)tableRowSelected:(NSNotification*)notification {
	switch([_table selectedRow]) {
		case _kServerCellRow:
		{
			NSMutableDictionary* returned = [NSMutableDictionary dictionaryWithObject:([_data objectForKey:kDataKeyDontMakeMD5] == nil ? [NSNumber numberWithBool:NO] : [_data objectForKey:kDataKeyDontMakeMD5]) forKey:kDataKeyDontMakeMD5];
			NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:returned, kDataKeyReturnedData,
				L(@"SelectServer"), kDataKeyTitle,
				kUIUnitAccountEdit, kDataKeyFrom,
				[_protocolSegment selectedSegment] == 0 ? [NSArray arrayWithObjects:(id*)LQUDPServers count:kLQUDPServerCount] : [NSArray arrayWithObjects:(id*)LQTCPServers count:kLQTCPServerCount], kDataKeyStringValueArray,
				[_serverCell value], kDataKeyStringValue,
				kServerSelectedNotificationName, kDataKeyNotificationName,
				nil];
			[_uiController transitTo:kUIUnitSelectValue style:kTransitionStyleLeftSlide data:data];
			break;
		}
		case _kPortCellRow:
		{
			NSMutableDictionary* returned = [NSMutableDictionary dictionaryWithObject:([_data objectForKey:kDataKeyDontMakeMD5] == nil ? [NSNumber numberWithBool:NO] : [_data objectForKey:kDataKeyDontMakeMD5]) forKey:kDataKeyDontMakeMD5];
			NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:returned, kDataKeyReturnedData,
				L(@"SelectPort"), kDataKeyTitle,
				kUIUnitAccountEdit, kDataKeyFrom,
				[NSArray arrayWithObjects:[NSString stringWithFormat:@"%u", kQQPortTCPSecure], [NSString stringWithFormat:@"%u", kQQPortTCP], nil], kDataKeyStringValueArray,
				[_portCell value], kDataKeyStringValue,
				kPortSelectedNotificationName, kDataKeyNotificationName,
				nil];
			[_uiController transitTo:kUIUnitSelectValue style:kTransitionStyleLeftSlide data:data];
			break;
		}
	}
}

@end
