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

#import <Cocoa/Cocoa.h>
#import "HeadControl.h"
#import "WorkflowModerator.h"
#import "VerifyCodeHelper.h"

@class MainWindowController;

@interface JoinClusterWindowController : NSWindowController <WorkflowDataSource> {
	IBOutlet HeadControl* m_headControl;
	IBOutlet NSTextField* m_txtId;
	IBOutlet NSTextField* m_txtName;
	IBOutlet NSTextField* m_txtCreator;
	
	IBOutlet NSView* m_verifyCodeView;
	IBOutlet NSView* m_messageView;
	IBOutlet NSBox* m_lastSeparator;
	
	IBOutlet NSTextField* m_txtVerifyCode;
	IBOutlet NSImageView* m_ivVerifyCode;
	
	IBOutlet NSTextView* m_txtAuth;
	
	IBOutlet NSButton* m_btnOK;
	IBOutlet NSButton* m_btnRefresh;
	IBOutlet NSButton* m_btnCancel;
	
	IBOutlet NSProgressIndicator* m_piBusy;
	IBOutlet NSTextField* m_txtHint;
	
	MainWindowController* m_mainWindowController;
	NSView* m_lastView;
	
	UInt32 m_internalId;
	UInt32 m_externalId;
	NSString* m_name;
	UInt32 m_creator;
	
	NSData* m_authInfo;	
	VerifyCodeHelper* m_verifyCodeHelper;
	
	WorkflowModerator* m_moderator;
}

- (id)initWithObject:(id)obj mainWindow:(MainWindowController*)mainWindowController;

// helper
- (void)showView:(NSView*)view;
- (void)enableUI:(BOOL)enable;
- (void)hideUI;
- (void)startHint:(NSString*)hint;
- (void)stopHint;
- (void)buildWorkflow:(NSString*)name;
- (void)startGetVerifyCodeImage;

// actions
- (IBAction)onOK:(id)sender;
- (IBAction)okCancel:(id)sender;
- (IBAction)onHead:(id)sender;
- (IBAction)onViewCreatorInfo:(id)sender;
- (IBAction)onRefresh:(id)sender;

// qq event handler
- (BOOL)handleJoinClusterOK:(QQNotification*)event;
- (BOOL)handleJoinClusterDenied:(QQNotification*)event;
- (BOOL)handleJoinClusterNeedAuth:(QQNotification*)event;
- (BOOL)handleGetAuthInfoOK:(QQNotification*)event;
- (BOOL)handleGetAuthInfoNeedVerifyCode:(QQNotification*)event;
- (BOOL)handleGetAuthInfoByVerifyCodeOK:(QQNotification*)event;
- (BOOL)handleGetAuthInfoByVerifyCodeRetry:(QQNotification*)event;
- (BOOL)handleClusterAuthSendOK:(QQNotification*)event;

@end
