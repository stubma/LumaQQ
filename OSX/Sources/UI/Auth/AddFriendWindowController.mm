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

#import "AddFriendWindowController.h"
#import "LocalizedStringTool.h"
#import "MainWindowController.h"
#import "AddFriendReplyPacket.h"
#import "AuthInfoOpReplyPacket.h"
#import "AuthQuestionOpReplyPacket.h"
#import "AuthorizeReplyPacket.h"
#import "AddFriendPacket.h"
#import "AuthInfoOpPacket.h"
#import "AuthorizePacket.h"
#import "AuthQuestionOpPacket.h"
#import "AlertTool.h"
#import "AnimationHelper.h"
#import "Constants.h"

@implementation AddFriendWindowController

- (id)initWithQQ:(UInt32)QQ mainWindowController:(MainWindowController*)mainWindowController {
	return [self initWithQQ:QQ head:0 nick:kStringEmpty  mainWindowController:mainWindowController];
}

- (id)initWithQQ:(UInt32)QQ head:(int)head nick:(NSString*)nick mainWindowController:(MainWindowController*)mainWindowController {
	self = [super initWithWindowNibName:@"AddFriend"];
	if(self) {
		m_QQ = QQ;
		m_head = head;
		[nick retain];
		m_nick = nick;
		m_mainWindowController = [mainWindowController retain];
		m_secondPhase = NO;
		m_verifyCodeHelper = [[VerifyCodeHelper alloc] initWithQQ:m_QQ delegate:self];
	}
	return self;
}

- (void) dealloc {
	[m_nick release];
	[m_questionAuthInfo release];
	[m_authInfo release];
	[m_mainWindowController release];
	if(m_verifyCodeHelper) {
		[m_verifyCodeHelper cancel];
		[m_verifyCodeHelper release];
		m_verifyCodeHelper = nil;
	}
	[super dealloc];
}

- (void)awakeFromNib {
	m_lastView = m_lastSeparator;
}

- (BOOL)windowShouldClose:(id)sender {
	if(m_operating) {
		[AlertTool showWarning:[self window] message:L(@"LQWarningOperating", @"AddFriend")];
	}
	
	return !m_operating;
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	[[m_mainWindowController windowRegistry] unregisterAddFriendWindow:m_QQ];
	[[m_mainWindowController client] removeQQListener:self];
	[self release];
}

- (void)windowDidLoad {
	// init controls
	[m_txtTitle setStringValue:[NSString stringWithFormat:L(@"LQTitle", @"AddFriend"), m_nick, m_QQ]];
	[m_txtHint setStringValue:L(@"LQHintReady", @"AddFriend")];
	[m_headControl setShowStatus:NO];
	[m_headControl setHead:m_head];
	[m_cbGroup reloadData];
	[m_cbGroup selectItemAtIndex:0];
	
	// add qq listener
	[[m_mainWindowController client] addQQListener:self];
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

- (void)showAuthUI {	
	if(m_authType == kQQAuthNeed) {
		// show message panel
		[self showView:m_messageView];
	} else if(m_authType == kQQAuthQuestion) {
		// show question panel
		[self showView:m_questionView];
	}
}

- (void)startGetVerifyCodeImage {
	// refresh ui
	m_operating = YES;
	[m_piBusy startAnimation:self];
	[m_btnRefresh setEnabled:NO];
	[m_txtHint setStringValue:L(@"LQHintGetVerifyCodeImage", @"AddFriend")];
	
	// start
	[m_verifyCodeHelper start];
}

- (void)setDestinationGroupIndex:(int)index {
	[m_cbGroup selectItemAtIndex:index];
}

#pragma mark -
#pragma mark actions

- (IBAction)onRefresh:(id)sender {
	m_refreshing = YES;
	[self startGetVerifyCodeImage];
}

- (IBAction)onOK:(id)sender {
	// refresh ui
	m_operating = YES;
	[m_btnOK setEnabled:NO];
	[m_piBusy startAnimation:self];
	
	if(m_secondPhase) {
		if([m_verifyCodeView superview] == nil) {
			if([m_questionView superview] == nil) {
				[m_txtHint setStringValue:L(@"LQHintAuthorize", @"AddFriend")];
				[[m_mainWindowController client] authorize:m_QQ
												  authInfo:m_authInfo
												   message:[m_txtMessage string]
												allowAddMe:[m_chkAllowAddMe state]
													 group:[m_cbGroup indexOfSelectedItem]];
			} else {
				[m_txtHint setStringValue:L(@"LQHintAnswerQuestion", @"AddFriend")];
				m_waitingSequence = [[m_mainWindowController client] answerQuestion:m_QQ answer:[m_txtAnswer stringValue]];
			}
		} else {
			[m_txtHint setStringValue:L(@"LQHintSubmitVerifyCode", @"AddFriend")];
			
			// get auth info again
			NSString* cookieHex = [m_verifyCodeHelper cookie];
			m_waitingSequence = [[m_mainWindowController client] getUserAuthInfo:m_QQ
																	  verifyCode:[m_txtVerifyCode stringValue]
																		  cookie:cookieHex];
		}			
	} else {
		[m_txtHint setStringValue:L(@"LQHintGetAuthInfo", @"AddFriend")];
		m_waitingSequence = [[m_mainWindowController client] getUserAuthInfo:m_QQ];
	}
}

- (IBAction)onCancel:(id)sender {
	[[self window] performClose:self];
}

#pragma mark -
#pragma mark combobox data source

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index {
	return [[[m_mainWindowController groupManager] group:index] name];
}

- (int)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	return [[m_mainWindowController groupManager] friendlyGroupCount];
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventAddFriendOK:
			ret = [self handleAddFriendOK:event];
			break;
		case kQQEventAddFriendDenied:
			ret = [self handleAddFriendDenied:event];
			break;
		case kQQEventAddFriendNeedAuth:
			ret = [self handleAddFriendNeedAuth:event];
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
		case kQQEventAnswerQuestionOK:
			ret = [self handleAnswerQuestionOK:event];
			break;
		case kQQEventAnswerQuestionFailed:
			ret = [self handleAnswerQuestionFailed:event];
			break;
		case kQQEventGetUserQuestionOK:
			ret = [self handleGetUserQuestionOK:event];
			break;
		case kQQEventGetUserQuestionFailed:
			ret = [self handleGetUserQuestionFailed:event];
			break;
		case kQQEventAuthorizeOK:
			ret = [self handleAuthorizeOK:event];
			break;
		case kQQEventAuthorizeFailed:
			ret = [self handleAuthorizeFailed:event];
			break;
		case kQQEventTimeoutBasic:
			ret = [self handleTimeout:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleTimeout:(QQNotification*)event {
	OutPacket* outPacket = [event outPacket];
	switch([outPacket command]) {
		case kQQCommandAddFriend:
			AddFriendPacket* afp = (AddFriendPacket*)outPacket;
			if([afp QQ] == m_QQ) {
				m_operating = NO;
				[m_piBusy stopAnimation:self];
				[m_btnOK setEnabled:YES];
				[m_txtHint setStringValue:L(@"LQHintAddFriendTimeout", @"AddFriend")];
			}
			break;
		case kQQCommandAuthInfoOp:
			AuthInfoOpPacket* aiop = (AuthInfoOpPacket*)outPacket;
			if([aiop QQ] == m_QQ) {
				m_operating = NO;
				[m_piBusy stopAnimation:self];
				[m_btnOK setEnabled:YES];
				[m_txtHint setStringValue:L(@"LQHintAuthInfoTimeout", @"AddFriend")];
			}
			break;
		case kQQCommandAuthQuestionOp:
			AuthQuestionOpPacket* aqop = (AuthQuestionOpPacket*)outPacket;
			if([aqop friendQQ] == m_QQ) {
				m_operating = NO;
				[m_piBusy stopAnimation:self];
				[m_btnOK setEnabled:YES];
				[m_txtHint setStringValue:L(@"LQHintQuestionOpTimeout", @"AddFriend")];
			}
			break;
		case kQQCommandAuthorize:
			AuthorizePacket* ap = (AuthorizePacket*)outPacket;
			if([ap QQ] == m_QQ) {
				m_operating = NO;
				[m_piBusy stopAnimation:self];
				[m_btnOK setEnabled:YES];
				[m_txtHint setStringValue:L(@"LQHintAuthorizeTimeout", @"AddFriend")];
			}
			break;
	}
	return NO;
}

- (BOOL)handleAddFriendOK:(QQNotification*)event {
	AddFriendReplyPacket* packet = [event object];
	if([packet QQ] == m_QQ) {
		// stop ui
		m_operating = NO;
		[m_piBusy stopAnimation:self];
		[m_txtHint setStringValue:L(@"LQHintAdded", @"AddFriend")];
		[m_btnOK setEnabled:YES];
		[m_btnOK setHidden:YES];
		[m_btnCancel setTitle:L(@"LQClose")];
		
		[m_mainWindowController addAddFriendGroupMapping:m_QQ groupIndex:[m_cbGroup indexOfSelectedItem]];
		[m_mainWindowController addFriend:m_QQ];

		return YES;
	}
	
	return NO;
}

- (BOOL)handleAddFriendDenied:(QQNotification*)event {
	AddFriendReplyPacket* packet = [event object];
	if([packet QQ] == m_QQ) {
		// stop ui
		m_operating = NO;
		[m_piBusy stopAnimation:self];
		[m_txtHint setStringValue:L(@"LQHintDenied", @"AddFriend")];
		[m_btnOK setEnabled:YES];
		[m_btnOK setHidden:YES];
		[m_btnCancel setTitle:L(@"LQClose")];
		
		return YES;
	}
	
	return NO;
}

- (BOOL)handleAddFriendNeedAuth:(QQNotification*)event {
	AddFriendReplyPacket* packet = [event object];
	if([packet QQ] == m_QQ) {
		// change phase
		m_secondPhase = YES;
		
		// save auth type and refresh UI
		m_authType = [packet authType];
		[self showAuthUI];
		
		// check auth type, if need question, continute
		if(m_authType == kQQAuthQuestion) {
			[m_txtHint setStringValue:L(@"LQHintGetQuestion", @"AddFriend")];
			m_waitingSequence = [[m_mainWindowController client] getUserQuestion:m_QQ];
		} else {
			// stop ui
			m_operating = NO;
			[m_piBusy stopAnimation:self];
			[m_txtHint setStringValue:L(@"LQHintNeedAuth", @"AddFriend")];
			[m_btnOK setEnabled:YES];
		}
		
		return YES;
	}
	
	return NO;
}

- (BOOL)handleGetAuthInfoOK:(QQNotification*)event {
	AuthInfoOpReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// save auth info
		m_authInfo = [[packet authInfo] retain];
		
		// add
		[m_txtHint setStringValue:L(@"LQHintAddFriend", @"AddFriend")];
		[[m_mainWindowController client] addFriend:m_QQ];
		
		// handled, so return YES
		return YES;
	}
	
	return NO;
}

- (BOOL)handleGetAuthInfoNeedVerifyCode:(QQNotification*)event {
	AuthInfoOpReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// save url
		[m_verifyCodeHelper setUrl:[packet url]];
		
		// show verify code panel
		[self showView:m_verifyCodeView];
		
		// start to get verify code image
		m_refreshing = NO;
		[self startGetVerifyCodeImage];
		
		return YES;
	}
	
	return NO;
}

- (BOOL)handleGetAuthInfoByVerifyCodeOK:(QQNotification*)event {
	AuthInfoOpReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// save auth info
		m_authInfo = [[packet authInfo] retain];
		
		// answer question or authorize
		if([m_questionView superview] == nil) {
			[m_txtHint setStringValue:L(@"LQHintAuthorize", @"AddFriend")];
			[[m_mainWindowController client] authorize:m_QQ
											  authInfo:m_authInfo
											   message:[m_txtMessage string]
											allowAddMe:[m_chkAllowAddMe state]
												 group:[m_cbGroup indexOfSelectedItem]];
		} else {
			[m_txtHint setStringValue:L(@"LQHintAnswerQuestion", @"AddFriend")];
			m_waitingSequence = [[m_mainWindowController client] answerQuestion:m_QQ answer:[m_txtAnswer stringValue]];
		}
		return YES;
	}
	
	return NO;
}

- (BOOL)handleGetAuthInfoByVerifyCodeRetry:(QQNotification*)event {
	AuthInfoOpReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// stop ui
		m_operating = NO;
		[m_piBusy stopAnimation:self];
		[m_btnOK setEnabled:YES];
		[m_txtHint setStringValue:L(@"LQHintVerifyCodeRetry", @"AddFriend")];
		
		return YES;
	}
	return NO;
}

- (BOOL)handleAnswerQuestionOK:(QQNotification*)event {
	AuthQuestionOpReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// save auth info
		m_questionAuthInfo = [[packet authInfo] retain];
		
		// send authorize
		[m_txtHint setStringValue:L(@"LQHintAuthorize", @"AddFriend")];
		[[m_mainWindowController client] authorize:m_QQ
										  authInfo:m_authInfo
								  questionAuthInfo:m_questionAuthInfo
										allowAddMe:[m_chkAllowAddMe state]
											 group:[m_cbGroup indexOfSelectedItem]];
		
		return YES;
	}
	return NO;
}

- (BOOL)handleAnswerQuestionFailed:(QQNotification*)event {
	AuthQuestionOpReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// stop ui
		m_operating = NO;
		[m_btnOK setEnabled:YES];
		[m_piBusy stopAnimation:self];
		[m_txtHint setStringValue:L(@"LQHintAnswerRetry", @"AddFriend")];
		
		return YES;
	}
	return NO;
}

- (BOOL)handleGetUserQuestionOK:(QQNotification*)event {
	AuthQuestionOpReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// stop ui
		m_operating = NO;
		[m_btnOK setEnabled:YES];
		[m_piBusy stopAnimation:self];
		[m_txtHint setStringValue:L(@"LQHintNeedAnswer", @"AddFriend")];
		
		// set question
		[m_txtQuestion setStringValue:[packet question]];
		
		return YES;
	}
	return NO;
}

- (BOOL)handleGetUserQuestionFailed:(QQNotification*)event {
	AuthQuestionOpReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// stop ui
		m_operating = NO;
		[m_btnOK setEnabled:YES];
		[m_btnOK setHidden:YES];
		[m_piBusy stopAnimation:self];
		[m_txtHint setStringValue:L(@"LQHintGetQuestionFailed", @"AddFriend")];
		
		return YES;
	}
	return NO;
}

- (BOOL)handleAuthorizeOK:(QQNotification*)event {
	AuthorizeReplyPacket* packet = [event object];
	if([packet QQ] == m_QQ) {
		// stop ui
		m_operating = NO;
		[m_btnOK setEnabled:YES];
		[m_btnOK setHidden:YES];
		[m_btnCancel setTitle:L(@"LQClose")];
		[m_piBusy stopAnimation:self];
		[m_txtHint setStringValue:L(@"LQHintAuthorizeOK", @"AddFriend")];
		
		// cache destination group index
		[m_mainWindowController addAddFriendGroupMapping:m_QQ groupIndex:[m_cbGroup indexOfSelectedItem]];
		
		return YES;
	}
	return NO;
}

- (BOOL)handleAuthorizeFailed:(QQNotification*)event {
	AuthorizeReplyPacket* packet = [event object];
	if([packet QQ] == m_QQ) {
		// stop ui
		m_operating = NO;
		[m_btnOK setEnabled:YES];
		[m_piBusy stopAnimation:self];
		[m_txtHint setStringValue:L(@"LQHintAuthorizeFailed", @"AddFriend")];
		
		return YES;
	}
	return NO;
}

#pragma mark -
#pragma mark downloader delegate

- (void)downloadDidFinish:(NSURLDownload *)download {
	// refresh ui
	[m_btnRefresh setEnabled:YES];
	
	// set verify code image
	[m_ivVerifyCode setImage:[m_verifyCodeHelper image]];
	
	// add friend
	if(m_refreshing) {
		m_operating = NO;
		[m_piBusy stopAnimation:self];
		[m_txtHint setStringValue:L(@"LQHintVerifyCodeImageRefreshed", @"AddFriend")];
	} else {
		[m_txtHint setStringValue:L(@"LQHintAddFriend", @"AddFriend")];
		[[m_mainWindowController client] addFriend:m_QQ];
	}
}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error {
	// refresh ui
	[m_btnRefresh setEnabled:YES];
}

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response {
	
}

#pragma mark -
#pragma mark animation delegate

- (void)animationDidEnd:(NSAnimation*)animation {
	[m_lastView setAutoresizingMask:NSViewMinYMargin];
}

@end
