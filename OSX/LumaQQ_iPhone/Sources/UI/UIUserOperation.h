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
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIPreferencesTableCell.h>
#import "UIUnit.h"
#import "PushButtonTableCell.h"
#import "User.h"
#import "GroupManager.h"
#import "QQListener.h"
#import "QQClient.h"

@class UIController;


@interface UIUserOperation : NSObject <UIUnit, QQListener> {
	UIController* _uiController;
	GroupManager* _groupManager;
	QQClient* _client;
	
	UIPreferencesTable* _table;
	UIPreferencesTableCell* _userCell;
	PushButtonTableCell* _infoCell;
	PushButtonTableCell* _chatCell;
	PushButtonTableCell* _modifyRemarkCell;
	PushButtonTableCell* _moveCell;
	PushButtonTableCell* _deleteCell;
	
	User* _user;
	NSMutableDictionary* _data;
	UIAlertSheet* _alertSheet;
	UInt16 _waitingSequence;
	NSData* _authInfo;
	int _alertType;
}

- (void)infoButtonClicked:(UIPushButton*)button;
- (void)chatButtonClicked:(UIPushButton*)button;
- (void)modifyRemarkButtonClicked:(UIPushButton*)button;
- (void)moveButtonClicked:(UIPushButton*)button;
- (void)deleteButtonClicked:(UIPushButton*)button;

- (BOOL)handleGetAuthInfoOK:(QQNotification*)event;
- (BOOL)handleDeleteFriendOK:(QQNotification*)event;
- (BOOL)handleRemoveFriendFromListOK:(QQNotification*)event;

@end
