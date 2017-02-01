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
#import "Cluster.h"
#import "QQListener.h"
#import "QQClient.h"

@interface UIClusterOperation : NSObject <UIUnit, QQListener> {
	UIController* _uiController;
	QQClient* _client;
	
	UIPreferencesTable* _table;
	UIPreferencesTableCell* _clusterCell;
	PushButtonTableCell* _infoCell;
	PushButtonTableCell* _chatCell;
	PushButtonTableCell* _settingCell;
	PushButtonTableCell* _exitCell;
	
	Cluster* _cluster;
	NSMutableDictionary* _data;
	UIAlertSheet* _alertSheet;
	int _alertType;
	UInt16 _waitingSequence;
}

- (void)infoButtonClicked:(UIPushButton*)button;
- (void)chatButtonClicked:(UIPushButton*)button;
- (void)settingButtonClicked:(UIPushButton*)button;
- (void)exitButtonClicked:(UIPushButton*)button;

- (BOOL)handleTimeout:(QQNotification*)event;
- (BOOL)handleExitClusterOK:(QQNotification*)event;

@end
