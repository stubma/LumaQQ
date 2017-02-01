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

#import "ClusterAuthWindowController.h"
#import "LocalizedStringTool.h"
#import "ReceivedIMPacket.h"
#import "ReceivedIMPacketHeader.h"
#import "Constants.h"
#import "ImageTool.h"
#import "MainWindowController.h"

#define _kWorkflowUnitApprove @"UnitApprove"
#define _kWorkflowUnitReject @"UnitReject"

@implementation ClusterAuthWindowController

- (void) dealloc {
	[m_cluster release];
	[m_notification release];
	[super dealloc];
}

#pragma mark -
#pragma mark override super

- (void)buildWorkflow:(NSString*)name {
	if([name isEqualToString:kWorkflowApproveReject]) {
		if([[m_matrixResponse selectedCell] tag] == 0)
			[m_moderator addUnit:_kWorkflowUnitApprove failEvent:kQQEventClusterAuthorizationSendFailed critical:YES];
		else
			[m_moderator addUnit:_kWorkflowUnitReject failEvent:kQQEventClusterAuthorizationSendFailed critical:YES];
	}	
}

- (BOOL)showMessageOnly {
	if([m_object isMemberOfClass:[ReceivedIMPacket class]]) {
		ReceivedIMPacket* packet = (ReceivedIMPacket*)m_object;
		ReceivedIMPacketHeader* header = [packet imHeader];
		switch([header type]) {
			case kQQIMTypeRequestJoinCluster:
				return NO;
			default:
				return YES;
		}
	}
	return [super showMessageOnly];
}

- (IBAction)onOK:(id)sender {
	if([self showMessageOnly])
		return [self close];
	else {
		// add request blocking
		if([m_chkOption state] == NSOnState)
			[m_mainWindowController addRequestBlockingEntry:[m_notification sourceQQ]];
		
		// start workflow
		[self buildWorkflow:kWorkflowApproveReject];
		[m_moderator start:[m_mainWindowController client]];
	}
}

- (IBAction)onHead:(id)sender {
	if([m_object isMemberOfClass:[ReceivedIMPacket class]]) {
		ReceivedIMPacket* packet = (ReceivedIMPacket*)m_object;
		ReceivedIMPacketHeader* header = [packet imHeader];
		switch([header type]) {
			case kQQIMTypeApprovedJoinCluster:
			case kQQIMTypeRejectedJoinCluster:
			case kQQIMTypeClusterCreated:
			case kQQIMTypeClusterRoleChanged:
				[[m_mainWindowController windowRegistry] showClusterInfoWindow:m_cluster mainWindow:m_mainWindowController];
				break;
			case kQQIMTypeRequestJoinCluster:
			case kQQIMTypeExitedCluster:
			case kQQIMTypeJoinedCluster:
				User* user = [[m_mainWindowController groupManager] user:[m_notification sourceQQ]];
				if(user == nil) 
					user = [[[User alloc] initWithQQ:[m_notification sourceQQ] domain:m_mainWindowController] autorelease];				
				[[m_mainWindowController windowRegistry] showUserInfoWindow:user mainWindow:m_mainWindowController];
				break;
			default:
				user = [[m_mainWindowController groupManager] user:[m_notification destQQ]];
				if(user == nil) 
					user = [[[User alloc] initWithQQ:[m_notification sourceQQ] domain:m_mainWindowController] autorelease];
				[[m_mainWindowController windowRegistry] showUserInfoWindow:user mainWindow:m_mainWindowController];
				break;
		}
	}
}

- (NSString*)windowTitle {
	return L(@"LQClusterAuthTitle", @"AuthWindow");
}

- (NSString*)message {
	return SM(m_object, [m_cluster name], [[m_mainWindowController me] QQ]);
}

- (void)initControl {
	[m_chkOption setTitle:L(@"LQOptionBlock", @"AuthWindow")];
	[m_txtToGroup removeFromSuperview];
	[m_cbGroup removeFromSuperview];
	
	[m_headControl setShowStatus:NO];
	
	if([m_object isMemberOfClass:[ReceivedIMPacket class]]) {
		ReceivedIMPacket* packet = (ReceivedIMPacket*)m_object;
		ReceivedIMPacketHeader* header = [packet imHeader];
		switch([header type]) {
			case kQQIMTypeApprovedJoinCluster:
			case kQQIMTypeRejectedJoinCluster:
			case kQQIMTypeClusterCreated:
				[m_headControl setHead:-1];
				[m_headControl setImage:[ImageTool imageWithName:kImageCluster size:kSizeLarge]];
				break;
		}
	}
}

- (void)initModel {
	if([m_object isMemberOfClass:[ReceivedIMPacket class]]) {
		ReceivedIMPacket* packet = (ReceivedIMPacket*)m_object;
		ReceivedIMPacketHeader* header = [packet imHeader];
		switch([header type]) {
			case kQQIMTypeRequestJoinCluster:
			case kQQIMTypeApprovedJoinCluster:
			case kQQIMTypeRejectedJoinCluster:
			case kQQIMTypeClusterCreated:
			case kQQIMTypeClusterRoleChanged:
			case kQQIMTypeJoinedCluster:
			case kQQIMTypeExitedCluster:
				// get cluster object
				m_notification = [[packet clusterNotification] retain];
				m_cluster = [[m_mainWindowController groupManager] clusterByExternalId:[m_notification externalId]];
				if(m_cluster == nil) {
					m_cluster = [[Cluster alloc] initWithInternalId:[header sender] domain:m_mainWindowController];
					[m_cluster setExternalId:[m_notification externalId]];
				} else
					[m_cluster retain];
				break;
		}
	}
}

- (IBAction)onResponseChange:(id)sender {
	switch([[sender selectedCell] tag]) {
		case 0:
			[m_txtRejectReason setEnabled:NO];
			[m_chkOption setHidden:YES];
			break;
		case 1:
			[m_txtRejectReason setEnabled:YES];
			[m_chkOption setHidden:NO];
			break;
	}
}

- (UInt16)executeWorkflowUnit:(NSString*)unitName hint:(NSString*)hint {
	[self startHint:hint];
	
	if([unitName isEqualToString:_kWorkflowUnitApprove]) {
		return [[m_mainWindowController client] approveJoinCluster:[m_cluster internalId] 
														  receiver:[m_notification sourceQQ]
														  authInfo:[m_notification authInfo]];
	} else if([unitName isEqualToString:_kWorkflowUnitReject]) {
		return [[m_mainWindowController client] rejectJoinCluster:[m_cluster internalId]
														 receiver:[m_notification sourceQQ]
														 authInfo:[m_notification authInfo]
														  message:[m_txtRejectReason stringValue]];
	} else
		return 0;
}

- (NSString*)workflowUnitHint:(NSString*)unitName {
	if([unitName isEqualToString:_kWorkflowUnitApprove]) 
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
		case kQQEventClusterAuthorizationSendOK:
			ret = [self handleClusterAuthorizationSendOK:event];
			break;
	}
	return ret;
}

- (BOOL)handleClusterAuthorizationSendOK:(QQNotification*)event {
	return YES;
}

@end
