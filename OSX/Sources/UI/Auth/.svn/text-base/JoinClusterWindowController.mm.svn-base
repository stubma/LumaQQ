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

#import "JoinClusterWindowController.h"
#import "ClusterInfo.h"
#import "LocalizedStringTool.h"
#import "Constants.h"
#import "ImageTool.h"
#import "MainWindowController.h"
#import "AuthInfoOpReplyPacket.h"
#import "AnimationHelper.h"

#define _kWorkflowClusterJoin @"ClusterJoin"
#define _kWorkflowClusterAuth @"ClusterAuth"
#define _kWorkflowRefreshVerifyCode @"RefreshVerifyCode"

#define _kWorkflowUnitJoinCluster @"UnitJoinCluster"
#define _kWorkflowUnitGetAuthInfo @"UnitGetAuthInfo"
#define _kWorkflowUnitClusterAuth @"UnitClusterAuth"
#define _kWorkflowUnitGetVerifyCode @"UnitGetVerifyCode"

@implementation JoinClusterWindowController

- (void) dealloc {
	if(m_moderator) {
		[m_moderator cancel];
		[m_moderator release];
		m_moderator = nil;
	}
	if(m_verifyCodeHelper) {
		[m_verifyCodeHelper cancel];
		[m_verifyCodeHelper release];
		m_verifyCodeHelper = nil;
	}
	[m_authInfo release];
	[m_name release];
	[m_mainWindowController release];
	[super dealloc];
}

- (void)awakeFromNib {
	m_lastView = m_lastSeparator;
}

- (id)initWithObject:(id)obj mainWindow:(MainWindowController*)mainWindowController {
	self = [super initWithWindowNibName:@"JoinCluster"];
	if(self) {
		m_mainWindowController = [mainWindowController retain];
		if([obj isMemberOfClass:[ClusterInfo class]]) {
			ClusterInfo* info = (ClusterInfo*)obj;
			m_internalId = [info internalId];
			m_externalId = [info externalId];
			m_name = [[info name] retain];
			m_creator = [info creator];
			m_verifyCodeHelper = [[VerifyCodeHelper alloc] initWithQQ:m_internalId delegate:self];
		}
	}
	return self;
}

- (void)windowDidLoad {
	// init controls
	[m_headControl setShowStatus:NO];
	[m_headControl setHead:-1];
	[m_headControl setImage:[ImageTool imageWithName:kImageCluster size:kSizeLarge]];
	[m_txtId setStringValue:[NSString stringWithFormat:@"%u", m_externalId]];
	[m_txtName setStringValue:m_name];
	[m_txtCreator setStringValue:[NSString stringWithFormat:@"%u", m_creator]];

	// register
	[[m_mainWindowController windowRegistry] registerJoinClusterWindow:m_internalId window:self];
	
	// start join
	m_moderator = [[WorkflowModerator alloc] initWithName:_kWorkflowClusterJoin dataSource:self];
	[self buildWorkflow:_kWorkflowClusterJoin];
	[m_moderator start:[m_mainWindowController client]];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	[[m_mainWindowController windowRegistry] unregisterJoinClusterWindow:m_internalId];
	[self release];
}

- (void)enableUI:(BOOL)enable {
	[m_btnOK setEnabled:enable];
	[m_btnRefresh setEnabled:enable];
}

- (void)startHint:(NSString*)hint {
	[m_piBusy setHidden:NO];
	[m_piBusy startAnimation:self];
	[m_txtHint setStringValue:hint];
}

- (void)stopHint {
	[m_piBusy setHidden:YES];
	[m_piBusy stopAnimation:self];
	[m_txtHint setStringValue:kStringEmpty];
}

- (void)buildWorkflow:(NSString*)name {
	if([name isEqualToString:_kWorkflowClusterAuth]) {
		[m_moderator addUnit:_kWorkflowUnitClusterAuth failEvent:0];
	} else if([name isEqualToString:_kWorkflowClusterJoin]) {
		[m_moderator addUnit:_kWorkflowUnitJoinCluster failEvent:0];
	} else if([name isEqualToString:_kWorkflowRefreshVerifyCode])
		[m_moderator addUnit:_kWorkflowUnitGetVerifyCode failEvent:0];
}

- (void)startGetVerifyCodeImage {
	[m_verifyCodeHelper start];
}

- (void)hideUI {
	[m_btnOK setHidden:YES];
	[m_btnRefresh setHidden:YES];
	[m_btnCancel setTitle:L(@"LQClose")];
}

- (void)showView:(NSView*)view {
	// get content view width
	float contentWidth = [[[self window] contentView] bounds].size.width;
	
	// add view
	[view setAutoresizingMask:NSViewMaxYMargin];
	[[[self window] contentView] addSubview:view];
	NSRect vcBound = [view bounds];
	NSRect refFrame = [m_lastView frame];
	[view setFrameOrigin:NSMakePoint((contentWidth - vcBound.size.width) / 2, refFrame.origin.y)];
	
	// get window frame
	NSRect oldFrame = [[self window] frame];
	NSRect newFrame = NSMakeRect(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
	newFrame.size.height += vcBound.size.height;
	newFrame.origin.y -= vcBound.size.height;
	
	// set last view
	m_lastView = view;
	
	// animate
	[AnimationHelper moveWindow:[self window]
						   from:oldFrame
							 to:newFrame
						 fadeIn:view
					   delegate:self];
}

#pragma mark -
#pragma mark actions

- (IBAction)onOK:(id)sender {
	if([m_verifyCodeView superview] == nil) {
		[m_moderator reset:_kWorkflowClusterAuth];
		[self buildWorkflow:_kWorkflowClusterAuth];
		[m_moderator start:[m_mainWindowController client]];
	} else {
		[m_moderator reset:_kWorkflowClusterAuth];
		[m_moderator addUnit:_kWorkflowUnitGetAuthInfo failEvent:0];
		[m_moderator start:[m_mainWindowController client]];
	}
}

- (IBAction)okCancel:(id)sender {
	[self close];
}

- (IBAction)onHead:(id)sender {
	Cluster* cluster = [[m_mainWindowController groupManager] cluster:m_internalId];
	if(cluster == nil) {
		cluster = [[[Cluster alloc] initWithInternalId:m_internalId domain:m_mainWindowController] autorelease];
	}
	[[m_mainWindowController windowRegistry] showClusterInfoWindow:cluster
														mainWindow:m_mainWindowController];
}

- (IBAction)onViewCreatorInfo:(id)sender {
	User* user = [[m_mainWindowController groupManager] user:m_creator];
	if(user == nil)
		user = [[[User alloc] initWithQQ:m_creator domain:m_mainWindowController] autorelease];
	if(user)
		[[m_mainWindowController windowRegistry] showUserInfoWindow:user mainWindow:m_mainWindowController];
}

- (IBAction)onRefresh:(id)sender {
	if(![m_moderator operating]) {
		[m_moderator reset:_kWorkflowRefreshVerifyCode];
		[self buildWorkflow:_kWorkflowRefreshVerifyCode];
		[m_moderator start:[m_mainWindowController client]];
	}
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventClusterJoinOK:
			ret = [self handleJoinClusterOK:event];
			break;
		case kQQEventClusterJoinRejected:
			ret = [self handleJoinClusterDenied:event];
			break;
		case kQQEventClusterJoinNeedAuth:
			ret = [self handleJoinClusterNeedAuth:event];
			break;
		case kQQEventGetAuthInfoOK:
			ret = [self handleGetAuthInfoOK:event];
			break;
		case kQQEventGetAuthInfoNeedVerifyCode:
			ret = [self handleGetAuthInfoNeedVerifyCode:event];
			break;
		case kQQEventGetAuthInfoByVerifyCodeOK:
			ret = [self handleGetAuthInfoByVerifyCodeOK:event];
			break;
		case kQQEventGetAuthInfoByVerifyCodeRetry:
			ret = [self handleGetAuthInfoByVerifyCodeRetry:event];
			break;
		case kQQEventClusterAuthorizationSendOK:
			ret = [self handleClusterAuthSendOK:event];
			break;
	}
	return ret;
}

- (BOOL)handleJoinClusterOK:(QQNotification*)event {
	// set message
	[m_txtHint setStringValue:L(@"LQMessageJoinOK", @"JoinCluster")];
	
	// add cluster model
	Cluster* cluster = [[m_mainWindowController groupManager] cluster:m_internalId];
	if(cluster == nil) {
		cluster = [[Cluster alloc] initWithInternalId:m_internalId domain:m_mainWindowController];
		[cluster setExternalId:m_externalId];
		[cluster setName:m_name];
		
		[[m_mainWindowController groupManager] addCluster:cluster];
		[m_mainWindowController reloadClusters];
		[[m_mainWindowController client] getClusterInfo:m_internalId];
	}
	
	// hide button
	[self hideUI];
	
	return YES;
}

- (BOOL)handleJoinClusterDenied:(QQNotification*)event {
	[m_txtHint setStringValue:L(@"LQMessageReject", @"JoinCluster")];
	[self hideUI];
	return YES;
}

- (BOOL)handleJoinClusterNeedAuth:(QQNotification*)event {
	[m_txtHint setStringValue:L(@"LQMessageNeedAuth", @"JoinCluster")];
	
	// show auth box
	[self showView:m_messageView];
	
	// get auth info
	[m_moderator addUnit:_kWorkflowUnitGetAuthInfo failEvent:kQQEventClusterAuthorizationSendFailed critical:YES];
	
	return YES;
}

- (BOOL)handleGetAuthInfoOK:(QQNotification*)event {
	AuthInfoOpReplyPacket* packet = [event object];
	m_authInfo = [[packet authInfo] retain];
	return YES;
}

- (BOOL)handleGetAuthInfoNeedVerifyCode:(QQNotification*)event {
	// save url
	AuthInfoOpReplyPacket* packet = [event object];
	[m_verifyCodeHelper setUrl:[packet url]];
	
	// show verify code box
	[self showView:m_verifyCodeView];
	
	// add new unit
	[m_moderator addUnit:_kWorkflowUnitGetVerifyCode failEvent:0];
	return YES;
}

- (BOOL)handleGetAuthInfoByVerifyCodeOK:(QQNotification*)event {
	AuthInfoOpReplyPacket* packet = [event object];
	m_authInfo = [[packet authInfo] retain];
	[m_moderator addUnit:_kWorkflowUnitClusterAuth failEvent:0];
	return YES;
}

- (BOOL)handleGetAuthInfoByVerifyCodeRetry:(QQNotification*)event {
	[m_txtHint setStringValue:L(@"LQMessageVerifyCodeError", @"JoinCluster")];
	return YES;
}

- (BOOL)handleClusterAuthSendOK:(QQNotification*)event {
	[m_txtHint setStringValue:L(@"LQMessageAuthSent", @"JoinCluster")];
	[self hideUI];
	return YES;
}

#pragma mark -
#pragma mark workflow data source

- (void)workflowStart:(NSString*)workflowName {
	[self enableUI:NO];
}

- (UInt16)executeWorkflowUnit:(NSString*)unitName hint:(NSString*)hint {
	[self startHint:hint];
	
	if([unitName isEqualToString:_kWorkflowUnitJoinCluster]) {
		return [[m_mainWindowController client] joinCluster:m_internalId];
	} else if([unitName isEqualToString:_kWorkflowUnitGetAuthInfo]) {
		NSString* cookieHex = [m_verifyCodeHelper cookie];
		if(cookieHex) {
			return [[m_mainWindowController client] getClusterAuthInfo:m_externalId
															verifyCode:[m_txtVerifyCode stringValue]
																cookie:cookieHex];
		} else
			return [[m_mainWindowController client] getClusterAuthInfo:m_externalId];
	} else if([unitName isEqualToString:_kWorkflowUnitClusterAuth]) {
		return [[m_mainWindowController client] requestJoinCluster:m_internalId
														  authInfo:m_authInfo
														   message:[m_txtAuth string]];
	} else if([unitName isEqualToString:_kWorkflowUnitGetVerifyCode]) {
		[self startGetVerifyCodeImage];
		return 0;
	}
	return 0;
}

- (NSString*)workflowUnitHint:(NSString*)unitName {
	if([unitName isEqualToString:_kWorkflowUnitJoinCluster])
		return L(@"LQHintJoinCluster", @"JoinCluster");
	else if([unitName isEqualToString:_kWorkflowUnitGetAuthInfo])
		return L(@"LQHintGetAuthInfo", @"JoinCluster");
	else if([unitName isEqualToString:_kWorkflowUnitClusterAuth])
		return L(@"LQHintClusterAuth", @"JoinCluster");
	else if([unitName isEqualToString:_kWorkflowUnitGetVerifyCode])
		return L(@"LQHintGetVerifyCode", @"JoinCluster");
	else
		return kStringEmpty;
}

- (void)workflow:(NSString*)workflowName end:(BOOL)success {
	[self enableUI:YES];
	[self stopHint];
}

- (BOOL)needExecuteWorkflowUnit:(NSString*)unitName {
	return YES;
}

- (BOOL)acceptEvent:(int)eventId {
	return NO;
}

#pragma mark -
#pragma mark downloader delegate

- (void)downloadDidFinish:(NSURLDownload *)download {	
	// set verify code image
	[m_ivVerifyCode setImage:[m_verifyCodeHelper image]];
	
	// end this unit
	[m_moderator endCurrentUnit:YES];
}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error {
	// end this unit
	[m_moderator endCurrentUnit:NO];
}

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response {
	
}

#pragma mark -
#pragma mark animation delegate

- (void)animationDidEnd:(NSAnimation*)animation {
	[m_lastView setAutoresizingMask:NSViewMinYMargin];
}

@end
