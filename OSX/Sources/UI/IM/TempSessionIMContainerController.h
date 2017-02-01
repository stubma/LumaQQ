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

#import <Cocoa/Cocoa.h>
#import "BaseIMContainer.h"
#import "QQSplitView.h"
#import "User.h"
#import "VerifyCodeHelper.h"

@interface TempSessionIMContainerController : BaseIMContainer {
	IBOutlet QQSplitView* m_split;
	IBOutlet NSWindow* m_verifyCodeWindow;
	IBOutlet NSTextField* m_txtVerifyCode;
	IBOutlet NSImageView* m_ivVerifyCode;
	IBOutlet NSProgressIndicator* m_piBusy;
	IBOutlet NSButton* m_btnRefresh;
	IBOutlet NSButton* m_btnOK;
	IBOutlet NSButton* m_btnCancel;
	IBOutlet NSTextField* m_txtHint;
	
	User* m_user;
	
	// for verify code
	BOOL m_refreshing;
	VerifyCodeHelper* m_verifyCodeHelper;
}

// helper
- (void)showVerifyCodePanel;
- (void)startGetVerifyCodeImage;

// actions
- (IBAction)onRefresh:(id)sender;
- (IBAction)onOK:(id)sender;
- (IBAction)onCancel:(id)sender;

// qq event handler
- (BOOL)handleGetUserInfoOK:(QQNotification*)event;
- (BOOL)handleSendTempSessionIMOK:(QQNotification*)event;
- (BOOL)handleSendTempSessionIMFailed:(QQNotification*)event;
- (BOOL)handleTempSessionOpTimeout:(QQNotification*)event;
- (BOOL)handleGetAuthInfoOK:(QQNotification*)event;
- (BOOL)handleGetAuthInfoNeedVerifyCode:(QQNotification*)event;
- (BOOL)handleGetAuthInfoByVerifyCodeOK:(QQNotification*)event;
- (BOOL)handleGetAuthInfoByVerifyCodeRetry:(QQNotification*)event;

@end
