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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 0 2111-1307 USA
 */

#import "Constants.h"
#import "UserAuthWindowController.h"
#import "LocalizedStringTool.h"
#import "MainWindowController.h"
#import "AlertTool.h"
#import "AuthorizeReplyPacket.h"
#import "NSString-Validate.h"

#define _kWorkflowUnitApproveAndAddHim @"UnitApproveAndAddHim"
#define _kWorkflowUnitApprove @"UnitApprove"
#define _kWorkflowUnitReject @"UnitReject"

@implementation UserAuthWindowController

- (IBAction)onHead:(id)sender {
	[[m_mainWindowController windowRegistry] showUserInfoWindow:m_user mainWindow:m_mainWindowController];
}

- (void) dealloc {
	[m_user release];
	[super dealloc];
}

- (void)buildWorkflow:(NSString*)name {
	if([name isEqualToString:kWorkflowApproveReject]) {
		if([[m_matrixResponse selectedCell] tag] == 0) {
			if([m_chkOption state])
				[m_moderator addUnit:_kWorkflowUnitApproveAndAddHim failEvent:kQQEventAuthorizeFailed critical:YES];
			else
				[m_moderator addUnit:_kWorkflowUnitApprove failEvent:kQQEventAuthorizeFailed critical:YES];
		} else
			[m_moderator addUnit:_kWorkflowUnitReject failEvent:kQQEventAuthorizeFailed critical:YES];
	}	
}

- (BOOL)showMessageOnly {
	if([m_object isMemberOfClass:[SystemNotificationPacket class]]) {
		SystemNotificationPacket* packet = (SystemNotificationPacket*)m_object;
		switch([packet subCommand]) {
			case kQQSubCommandOtherRequestAddMeEx:
				return NO;
			default:
				return YES;
		}
	}
	return [super showMessageOnly];
}

- (NSString*)windowTitle {
	return L(@"LQUserAuthTitle", @"AuthWindow");
}

- (NSString*)message {
	return SM(m_packet, nil, [m_user QQ]);
}

- (IBAction)onResponseChange:(id)sender {
	switch([[sender selectedCell] tag]) {
		case 0:
			if(m_allowAddReverse) {
				[m_chkOption setTitle:L(@"LQOptionAddReverse", @"AuthWindow")];
				[m_txtRejectReason setEnabled:NO];
				[m_txtToGroup setHidden:(![m_chkOption state])];
				[m_cbGroup setHidden:(![m_chkOption state])];
			} else {
				[m_chkOption setHidden:YES];
				[m_txtToGroup setHidden:YES];
				[m_cbGroup setHidden:YES];
				[m_txtRejectReason setEnabled:NO];
			}
			break;
		case 1:
			[m_txtRejectReason setEnabled:YES];
			[m_txtToGroup setHidden:YES];
			[m_cbGroup setHidden:YES];
			[m_chkOption setHidden:NO];
			[m_chkOption setTitle:L(@"LQOptionBlock", @"AuthWindow")];
			break;
	}
}

- (IBAction)onOptionChanged:(id)sender {
	[self onResponseChange:m_matrixResponse];
}

- (IBAction)onOK:(id)sender {
	if([self showMessageOnly])
		return [self close];
	else {
		// add request blocking
		if([[m_matrixResponse selectedCell] tag] == 1 && [m_chkOption state] == NSOnState)
			[m_mainWindowController addRequestBlockingEntry:[m_user QQ]];
		
		// start workflow
		[self buildWorkflow:kWorkflowApproveReject];
		[m_moderator start:[m_mainWindowController client]];
	}
}

- (void)initControl {
	[m_chkOption setTitle:L(@"LQOptionAddReverse", @"AuthWindow")];
	[m_cbGroup reloadData];
	[m_cbGroup selectItemAtIndex:0];
	[m_headControl setShowStatus:NO];
}

- (void)initModel {
	if([m_object isMemberOfClass:[SystemNotificationPacket class]]) {
		m_packet = (SystemNotificationPacket*)m_object;
		m_user = [[m_mainWindowController groupManager] user:[m_packet sourceQQ]];
		if(m_user == nil) {
			m_allowAddReverse = [m_packet allowAddReverse];
			m_user = [[User alloc] initWithQQ:[m_packet sourceQQ] domain:m_mainWindowController];
		} else if([[m_mainWindowController groupManager] isUserFriendly:m_user]) {
			m_allowAddReverse = NO;
			[m_user retain];
		} else {
			m_allowAddReverse = YES;
			[m_user retain];
		}
	}
}

- (UInt16)executeWorkflowUnit:(NSString*)unitName hint:(NSString*)hint {
	[self startHint:hint];
	
	if([unitName isEqualToString:_kWorkflowUnitApprove]) {
		return [[m_mainWindowController client] approveAuthorization:[m_user QQ]];
	} else if([unitName isEqualToString:_kWorkflowUnitReject]) {
		return [[m_mainWindowController client] rejectAuthorization:[m_user QQ]
															message:[m_txtRejectReason stringValue]];
	} else if([unitName isEqualToString:_kWorkflowUnitApproveAndAddHim]) {
		return [[m_mainWindowController client] approveAuthorizationAndAddHim:[m_user QQ]
																	  message:[m_txtRejectReason stringValue]];
	} else
		return 0;
}

- (NSString*)workflowUnitHint:(NSString*)unitName {
	if([unitName isEqualToString:_kWorkflowUnitApprove] ||
	   [unitName isEqualToString:_kWorkflowUnitApproveAndAddHim]) 
		return L(@"LQHintApprove", @"AuthWindow");
	else if([unitName isEqualToString:_kWorkflowUnitReject]) 
		return L(@"LQHintReject", @"AuthWindow");
	else
		return kStringEmpty;
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	switch([event eventId]) {
		case kQQEventAuthorizeOK:
			ret = [self handleAuthorizationSendOK:event];
			break;
		case kQQEventAuthorizeFailed:
			ret = [self handleAuthorizeFailed:event];
			break;
	}
	return ret;
}

- (BOOL)handleAuthorizeFailed:(QQNotification*)event {
	AuthorizeReplyPacket* packet = (AuthorizeReplyPacket*)[event object];
	if(![[packet message] isEmpty]) {
		[AlertTool showWarning:[self window]
					   message:[packet message]];	
	}
	return YES;
}

- (BOOL)handleAuthorizationSendOK:(QQNotification*)event {
	if(![m_cbGroup isHidden]) {
		User* user = [[m_mainWindowController groupManager] user:[m_user QQ]];
		if(user == nil) {
			[[m_mainWindowController groupManager] addUser:m_user groupIndex:[m_cbGroup indexOfSelectedItem]];
			Group* g = [[m_mainWindowController groupManager] group:[m_user groupIndex]];
			if(g)
				[[m_mainWindowController userOutline] reloadItem:g reloadChildren:YES];
			[[m_mainWindowController client] getUserInfo:[m_user QQ]];
		} else if([user groupIndex] != [m_cbGroup indexOfSelectedItem]) {
			int oldGroupIndex = [[m_mainWindowController groupManager] moveUser:user toGroupIndex:[m_cbGroup indexOfSelectedItem]];
			Group* g = [[m_mainWindowController groupManager] group:oldGroupIndex];
			if(g)
				[[m_mainWindowController userOutline] reloadItem:g reloadChildren:YES];
			g = [[m_mainWindowController groupManager] group:[user groupIndex]];
			if(g)
				[[m_mainWindowController userOutline] reloadItem:g reloadChildren:YES];
			[[m_mainWindowController client] getUserInfo:[user QQ]];
		}
	}
	return YES;
}

@end
