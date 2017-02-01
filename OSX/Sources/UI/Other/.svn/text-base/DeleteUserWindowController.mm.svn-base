/*
 * LumaQQ - Cross platform QQ client, special edition for Mac
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

#import "Constants.h"
#import "DeleteUserWindowController.h"
#import "MainWindowController.h"
#import "LocalizedStringTool.h"
#import "AuthInfoOpReplyPacket.h"

#define _kWorkflowDelete @"Delete"

#define _kWorkflowUnitGetAuthInfo @"GetAuthInfo"
#define _kWorkflowUnitDelete @"UnitDelete"
#define _kWorkflowUnitRemoveFromServerList @"UnitRemoveFromServerList"

@implementation DeleteUserWindowController

- (id)initWithUser:(User*)user mainWindow:(MainWindowController*)mainWindowController {
	self = [super initWithWindowNibName:@"DeleteUser"];
	if(self) {
		m_user = [user retain];
		m_mainWindowController = [mainWindowController retain];
	}
	return self;
}

- (void) dealloc {
	[m_authInfo release];
	[m_user release];
	[m_mainWindowController release];
	[super dealloc];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	if(m_moderator) {
		[m_moderator cancel];
		[m_moderator release];
		m_moderator = nil;
	}
	[[m_mainWindowController windowRegistry] unregisterDeleteUserWindow:[m_user QQ]];
	[self release];
}

- (void)windowDidLoad {
	// init control
	[m_headControl setShowStatus:NO];
	[m_headControl setObjectValue:m_user];
	[m_txtTitle setStringValue:[NSString stringWithFormat:L(@"LQTitle", @"DeleteUser"), [m_user nick], [m_user QQ]]];

	// create workflow
	m_moderator = [[WorkflowModerator alloc] initWithName:_kWorkflowDelete dataSource:self];
	[self buildWorkflow:_kWorkflowDelete];
	[m_moderator start:[m_mainWindowController client]];
}

#pragma mark -
#pragma mark action

- (IBAction)onClose:(id)sender {
	[self close];
}

#pragma mark -
#pragma mark helper

- (void)buildWorkflow:(NSString*)name {
	if([name isEqualToString:_kWorkflowDelete]) {
		[m_moderator addUnit:_kWorkflowUnitGetAuthInfo failEvent:kQQEventGetAuthInfoNeedVerifyCode critical:YES];
	}
}

- (void)startHint:(NSString*)hint {
	[m_piBusy setHidden:NO];
	[m_piBusy startAnimation:self];
	[m_txtHint setStringValue:hint];
}

- (void)stopHint {
	[m_piBusy stopAnimation:self];
	[m_piBusy setHidden:YES];
	[m_txtHint setStringValue:kStringEmpty];
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventGetAuthInfoOK:
			ret = [self handleGetAuthInfoOK:event];
			break;
		case kQQEventDeleteFriendOK:
			ret = [self handleDeleteFriendOK:event];
			break;
		case kQQEventRemoveFriendFromListOK:
			ret = [self handleRemoveFriendFromServerListOK:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleGetAuthInfoOK:(QQNotification*)event {
	AuthInfoOpReplyPacket* packet = (AuthInfoOpReplyPacket*)[event object];
	m_authInfo = [[packet authInfo] retain];
	[m_moderator addUnit:_kWorkflowUnitDelete failEvent:kQQEventDeleteFriendFailed critical:YES];
	return YES;
}

- (BOOL)handleDeleteFriendOK:(QQNotification*)event {
	[m_moderator addUnit:_kWorkflowUnitRemoveFromServerList failEvent:kQQEventRemoveFriendFromListFailed critical:YES];
	return YES;
}

- (BOOL)handleRemoveFriendFromServerListOK:(QQNotification*)event {
	return YES;
}

#pragma mark -
#pragma mark workflow data source protocol

- (void)workflowStart:(NSString*)workflowName {
	
}

- (UInt16)executeWorkflowUnit:(NSString*)unitName hint:(NSString*)hint {
	[self startHint:hint];
	
	if([unitName isEqualToString:_kWorkflowUnitGetAuthInfo])
		return [[m_mainWindowController client] getDeleteUserAuthInfo:[m_user QQ]];
	else if([unitName isEqualToString:_kWorkflowUnitDelete])
		return [[m_mainWindowController client] deleteFriend:[m_user QQ] authInfo:m_authInfo];
	else if([unitName isEqualToString:_kWorkflowUnitRemoveFromServerList])
		return [[m_mainWindowController client] removeFriendFromServerList:[m_user QQ]];
	else
		return 0;
}

- (NSString*)workflowUnitHint:(NSString*)unitName {
	if([unitName isEqualToString:_kWorkflowUnitGetAuthInfo])
		return L(@"LQHintGetAuthInfo", @"DeleteUser");
	if([unitName isEqualToString:_kWorkflowUnitDelete])
		return L(@"LQHintDeleteFriend", @"DeleteUser");
	else if([unitName isEqualToString:_kWorkflowUnitRemoveFromServerList]) 
		return L(@"LQHintRemoveFromServerList", @"DeleteUser");
	else
		return kStringEmpty;
}

- (void)workflow:(NSString*)workflowName end:(BOOL)success {
	[self stopHint];
	
	if(success) {
		[m_txtHint setStringValue:L(@"LQHintDeleteOK", @"DeleteUser")];
		[self close];
	} else
		[m_txtHint setStringValue:L(@"LQHintDeleteFailed", @"DeleteUser")];
}

- (BOOL)needExecuteWorkflowUnit:(NSString*)unitName {
	return YES;
}

- (BOOL)acceptEvent:(int)eventId {
	return NO;
}

@end
