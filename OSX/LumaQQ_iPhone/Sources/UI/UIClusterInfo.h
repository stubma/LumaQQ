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
#import "QQClient.h"
#import "GroupManager.h"
#import "Cluster.h"
#import "QQListener.h"
#import "PushButtonTableCell.h"
#import "QQNotification.h"

@class UIController;

@interface UIClusterInfo : NSObject <UIUnit, QQListener> {
	UIController* _uiController;
	Cluster* _cluster;
	GroupManager* _groupManager;
	QQClient* _client;
	
	UIPreferencesTable* _table;
	
	PushButtonTableCell* _refreshCell;
	
	UIPreferencesTableCell* _idCell;
	UIPreferencesTextTableCell* _nameCell;
	UIPreferencesTableCell* _creatorCell;
	UIPreferencesTextTableCell* _noticeCell;
	UIPreferencesTextTableCell* _descriptionCell;
	
	UIPreferencesTableCell* _noAuthCell;
	UIPreferencesTableCell* _needAuthCell;
	UIPreferencesTableCell* _denyCell;
	
	PushButtonTableCell* _modifyCell;
	
	NSMutableDictionary* _data;
	UIAlertSheet* _alertSheet;
	UInt16 _waitingSequence;
}

- (void)_checkAuthType:(char)authType;
- (char)_authType;
- (void)_reloadInfo;

- (void)refreshInfoButtonClicked:(UIPushButton*)button;
- (void)modifyInfoButtonClicked:(UIPushButton*)button;

- (BOOL)handleTimeout:(QQNotification*)event;
- (BOOL)handleGetClusterInfoOK:(QQNotification*)event;
- (BOOL)handleModifyClusterInfoOK:(QQNotification*)event;

@end
