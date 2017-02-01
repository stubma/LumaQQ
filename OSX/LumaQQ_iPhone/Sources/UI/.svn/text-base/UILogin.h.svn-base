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
#import <UIKit/UIBox.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIPreferencesControlTableCell.h>
#import <UIKit/UIPreferencesTextTableCell.h>
#import <UIKit/UITextField.h>
#import "GetLoginTokenReplyPacket.h"
#import "QQNotification.h"
#import "UIUnit.h"
#import "QQClient.h"
#import "PushButtonTableCell.h"
#import "JobController.h"

@class UIController;

@interface UILogin : NSObject <UIUnit, QQListener> {
	// top box
	UIBox* _box;
	
	// content view
	UIView* _view;
	
	// hint label
	UITextLabel* _hint;
	
	// verify code box
	UIPreferencesTable* _verifyBox;
	
	// cell
	UIPreferencesControlTableCell* _imageCell;
	UIPreferencesTextTableCell* _textCell;
	PushButtonTableCell* _refreshCell;
	PushButtonTableCell* _okCell;
	
	// verify code image
	UIImageView* _verifyImageView;
	
	// controller
	UIController* _uiController;
	
	// other
	NSMutableDictionary* _connectData;
	QQClient* _client;
	
	// cached message
	NSMutableArray* _cachedMessages;
	NSMutableArray* _cachedSystemNotifications;
	
	// need save reference to GetLoginTokenReplyPacket
	GetLoginTokenReplyPacket* _packet;
	
	// animation control flag
	BOOL _show;
}

// login
- (void)_start;
- (void)_stop;

// verify box
- (void)_createVerifyBox;
- (void)_refreshVerifyImage:(GetLoginTokenReplyPacket*)packet;
- (void)_showVerifyBox:(GetLoginTokenReplyPacket*)packet;
- (void)_hideVerifyBox;

// other
- (void)_cancel;
- (void)_gotoMain;

// action handle
- (void)refreshImageButtonClicked:(UIPushButton*)button;
- (void)okButtonClicked:(UIPushButton*)button;

// job delegate
- (void)getFriendGroupJobTerminated:(JobController*)jobController;

// qq event handle
- (BOOL)handleNetworkStarted:(QQNotification*)event;
- (BOOL)handleConnectionEstablished:(QQNotification*)event;
- (BOOL)handleNetworkError:(QQNotification*)event;
- (BOOL)handleSelectServerOK:(QQNotification*)event;
- (BOOL)handleGetServerTokenOK:(QQNotification*)event;
- (BOOL)handleGetLoginTokenOK:(QQNotification*)event;
- (BOOL)handlePasswordVerifyOK:(QQNotification*)event;
- (BOOL)handleNeedVerifyCode:(QQNotification*)event;
- (BOOL)handleTimeout:(QQNotification*)event;
- (BOOL)handleLoginOK:(QQNotification*)event;
- (BOOL)handleLoginFailed:(QQNotification*)event;
- (BOOL)handlePasswordVerifyFailed:(QQNotification*)event;
- (BOOL)handleGetFriendGroupOK:(QQNotification*)event;
- (BOOL)handleDownloadGroupNameOK:(QQNotification*)event;
- (BOOL)handleReceivedIM:(QQNotification*)event;
- (BOOL)handleReceivedSystemNotification:(QQNotification*)event;

@end
