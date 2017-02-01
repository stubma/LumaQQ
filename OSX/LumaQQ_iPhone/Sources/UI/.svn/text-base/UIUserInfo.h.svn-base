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
#import "User.h"
#import "PushButtonTableCell.h"
#import "ContactInfo.h"
#import "QQListener.h"
#import "QQClient.h"

@class UIController;

@interface UIUserInfo : NSObject <UIUnit, QQListener> {
	UIController* _uiController;
	QQClient* _client;
	User* _user;
	
	UIPreferencesTable* _table;
	PushButtonTableCell* _refreshCell;
	PushButtonTableCell* _saveCell;
	UIPreferencesTableCell* _qqCell;
	UIPreferencesTableCell* _headCell;
	UIPreferencesTextTableCell* _nickCell;
	UIPreferencesTextTableCell* _nameCell;
	UIPreferencesTextTableCell* _ageCell;
	UIPreferencesTextTableCell* _homePageCell;
	UIPreferencesTableCell* _zodiacCell;
	UIPreferencesTableCell* _horoscopeCell;
	UIPreferencesTableCell* _occupationCell;
	UIPreferencesTableCell* _genderCell;
	UIPreferencesTableCell* _bloodCell;
	UIPreferencesTextTableCell* _collegeCell;
	
	UIPreferencesTextTableCell* _emailCell;
	UIPreferencesTextTableCell* _telephoneCell;
	UIPreferencesTextTableCell* _mobileCell;
	UIPreferencesTextTableCell* _countryCell;
	UIPreferencesTextTableCell* _provinceCell;
	UIPreferencesTextTableCell* _cityCell;
	UIPreferencesTextTableCell* _addressCell;
	UIPreferencesTextTableCell* _zipcodeCell;
	
	UIPreferencesTableCell* _noAuthCell;
	UIPreferencesTableCell* _needAuthCell;
	UIPreferencesTableCell* _denyCell;
	UIPreferencesTableCell* _needQuestionCell;
	UIPreferencesTextTableCell* _authQuestionCell;
	UIPreferencesTextTableCell* _authAnswerCell;
	
	UIPreferencesTableCell* _contactOpenCell;
	UIPreferencesTableCell* _contactVisibleToFriendCell;
	UIPreferencesTableCell* _contactSecretCell;
	
	UIPreferencesTextTableCell* _signatureCell;
	UIPreferencesTextTableCell* _introductionCell;
	
	NSMutableDictionary* _data;
	ContactInfo* _tempContact;
	UIAlertSheet* _alertSheet;
	
	UInt16 _waitingSequence;
	NSData* _authInfo;
}

- (NSArray*)_loadValueArray:(NSString*)name;
- (void)_reloadContact;
- (void)_checkAuthType:(char)authType;
- (void)_checkContactVisibility:(char)contactVisibility;

- (void)refreshInfoButtonClicked:(UIPushButton*)button;
- (void)saveInfoButtonClicked:(UIPushButton*)button;

- (void)handleHeadSelectedNotification:(NSNotification*)notification;
- (void)handleGenderSelectedNotification:(NSNotification*)notification;
- (void)handleZodiacSelectedNotification:(NSNotification*)notification;
- (void)handleHoroscopeSelectedNotification:(NSNotification*)notification;
- (void)handleOccupationSelectedNotification:(NSNotification*)notification;
- (void)handleBloodSelectedNotification:(NSNotification*)notification;

- (BOOL)handleGetUserInfoOK:(QQNotification*)event;
- (BOOL)handleGetMyQuestionOK:(QQNotification*)event;
- (BOOL)handleGetSignatureOK:(QQNotification*)event;
- (BOOL)handleGetAuthInfoOK:(QQNotification*)event;
- (BOOL)handleModifyInfoOK:(QQNotification*)event;
- (BOOL)handleDeleteSignatureOK:(QQNotification*)event;
- (BOOL)handleModifySignatureOK:(QQNotification*)event;
- (BOOL)handleModifyQuestionOK:(QQNotification*)event;
- (BOOL)handleTimeout:(QQNotification*)event;

@end
