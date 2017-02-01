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
#import <UIKit/UIPreferencesTextTableCell.h>
#import "UIUnit.h"
#import "PushButtonTableCell.h"
#import "QQListener.h"
#import "QQClient.h"
#import "GroupManager.h"

@interface UIUserAuth : NSObject <UIUnit, QQListener> {
	UIController* _uiController;
	QQClient* _client;
	GroupManager* _groupManager;
	
	UIPreferencesTable* _table;
	UIPreferencesTableCell* _sourceCell;
	UIPreferencesControlTableCell* _addHimCell;
	UIPreferencesTableCell* _destGroupCell;
	UIPreferencesTextTableCell* _msgCell;
	PushButtonTableCell* _approveCell;
	PushButtonTableCell* _rejectCell;
	
	NSMutableDictionary* _data;
	UIAlertSheet* _alertSheet;
	UInt16 _waitingSequence;
	BOOL _addHimAsFriend;
}

- (void)_back;

- (void)approveButtonClicked:(UIPushButton*)button;
- (void)rejectButtonClicked:(UIPushButton*)button;

- (void)handleGroupSelected:(NSNotification*)notification;

- (BOOL)handleTimeout:(QQNotification*)event;
- (BOOL)handleAuthorizeFailed:(QQNotification*)event;
- (BOOL)handleAuthorizationOK:(QQNotification*)event;

@end
