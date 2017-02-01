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
#import "HeadControl.h"
#import "QQListener.h"
#import "VerifyCodeHelper.h"

@class MainWindowController;

@interface AddFriendWindowController : NSWindowController <QQListener> {	
	IBOutlet NSView* m_verifyCodeView;
	IBOutlet NSView* m_questionView;
	IBOutlet NSView* m_messageView;
	IBOutlet NSBox* m_lastSeparator;
	
	IBOutlet NSTextField* m_txtTitle;
	IBOutlet NSComboBox* m_cbGroup;
	IBOutlet NSTextField* m_txtVerifyCode;
	IBOutlet NSImageView* m_ivVerifyCode;
	IBOutlet NSButton* m_btnRefresh;
	IBOutlet NSTextField* m_txtQuestion;
	IBOutlet NSTextField* m_txtAnswer;
	IBOutlet NSTextView* m_txtMessage;
	IBOutlet NSButton* m_chkAllowAddMe;
	IBOutlet NSButton* m_btnOK;
	IBOutlet NSButton* m_btnCancel;
	IBOutlet NSProgressIndicator* m_piBusy;
	IBOutlet HeadControl* m_headControl;
	IBOutlet NSTextField* m_txtHint;
	
	NSView* m_lastView;
	
	UInt32 m_QQ;
	int m_head;
	NSString* m_nick;
	char m_authType;
	MainWindowController* m_mainWindowController;
	
	UInt16 m_waitingSequence;
	NSData* m_authInfo;
	NSData* m_questionAuthInfo;
	
	VerifyCodeHelper* m_verifyCodeHelper;
	BOOL m_refreshing;
	BOOL m_secondPhase;
	
	BOOL m_operating;
}

- (id)initWithQQ:(UInt32)QQ mainWindowController:(MainWindowController*)mainWindowController;
- (id)initWithQQ:(UInt32)QQ head:(int)head nick:(NSString*)nick mainWindowController:(MainWindowController*)mainWindowController;

// helper
- (void)showView:(NSView*)view;
- (void)showAuthUI;
- (void)startGetVerifyCodeImage;
- (void)setDestinationGroupIndex:(int)index;

// actions
- (IBAction)onOK:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onRefresh:(id)sender;

// qq event handler
- (BOOL)handleAddFriendOK:(QQNotification*)event;
- (BOOL)handleAddFriendDenied:(QQNotification*)event;
- (BOOL)handleAddFriendNeedAuth:(QQNotification*)event;
- (BOOL)handleGetAuthInfoOK:(QQNotification*)event;
- (BOOL)handleGetAuthInfoNeedVerifyCode:(QQNotification*)event;
- (BOOL)handleGetAuthInfoByVerifyCodeOK:(QQNotification*)event;
- (BOOL)handleGetAuthInfoByVerifyCodeRetry:(QQNotification*)event;
- (BOOL)handleAnswerQuestionOK:(QQNotification*)event;
- (BOOL)handleAnswerQuestionFailed:(QQNotification*)event;
- (BOOL)handleGetUserQuestionOK:(QQNotification*)event;
- (BOOL)handleGetUserQuestionFailed:(QQNotification*)event;
- (BOOL)handleAuthorizeOK:(QQNotification*)event;
- (BOOL)handleAuthorizeFailed:(QQNotification*)event;
- (BOOL)handleTimeout:(QQNotification*)event;

@end
