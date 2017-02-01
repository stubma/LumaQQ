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
#import <UIKit/UIPreferencesControlTableCell.h>
#import <UIKit/UIPreferencesTableCell.h>
#import <UIKit/UISegmentedControl.h>
#import "UIUnit.h"
#import "QQListener.h"
#import "PushButtonTableCell.h"
#import "GroupManager.h"
#import "QQClient.h"
#import "JobController.h"

@class UIController;

@interface UIPreference : NSObject <UIUnit, QQListener> {
	UIController* _uiController;
	GroupManager* _groupManager;
	QQClient* _client;
	
	UIPreferencesTable* _table;
	PushButtonTableCell* _updateFriendGroupCell;
	UIPreferencesControlTableCell* _showOnlineOnlyCell;
	UIPreferencesControlTableCell* _showNickCell;
	UIPreferencesControlTableCell* _showStatusMessageCell;
	UIPreferencesControlTableCell* _showSignatureCell;
	UIPreferencesControlTableCell* _showLevelCell;
	UIPreferencesControlTableCell* _buttonBarCountCell;
	UIPreferencesControlTableCell* _rejectStrangerMessageCell;
	UIPreferencesControlTableCell* _enableSoundCell;
	UIPreferencesTableCell* _soundSchemeCell;
	
	UISegmentedControl* _buttonBarCountSegment;
	
	UIAlertSheet* _alertSheet;
}

- (void)updateFriendGroupButtonClicked:(UIPushButton*)button;

- (void)updateFriendGroupJobTerminated:(JobController*)jobController;

- (void)handleSoundSchemeSelected:(NSNotification*)notification;

- (BOOL)handleGetFriendGroupOK:(QQNotification*)event;
- (BOOL)handleDownloadGroupNameOK:(QQNotification*)event;

@end
