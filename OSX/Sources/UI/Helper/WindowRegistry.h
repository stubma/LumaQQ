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
#import "UserInfoWindowController.h"
#import "User.h"
#import "Cluster.h"
#import "Mobile.h"
#import "MobileIMWindowController.h"
#import "SearchWindowController.h"
#import "AddFriendWindowController.h"
#import "DeleteUserWindowController.h"
#import "ClusterInfoWindowController.h"
#import "NormalIMWindowController.h"
#import "ClusterIMWindowController.h"
#import "JoinClusterWindowController.h"
#import "PreferenceWindowController.h"
#import "FaceManagerWindowController.h"
#import "MobileIMWindowController.h"
#import "SystemMessageWindowController.h"
#import "TempSessionIMWindowController.h"
#import "TabIMWindowController.h"
#import "ModifySubjectWindowController.h"
#import "ModifyDialogWindowController.h"

@class MainWindowController;

@interface WindowRegistry : NSObject {
	NSMutableDictionary* m_userInfoWindowRegistry;
	NSMutableDictionary* m_searchWizardRegistry;
	NSMutableDictionary* m_addFriendWindowRegistry;
	NSMutableDictionary* m_joinClusterWindowRegistry;
	NSMutableDictionary* m_deleteUserWindowRegistry;
	NSMutableDictionary* m_clusterInfoWindowRegistry;
	NSMutableDictionary* m_normalIMWindowRegistry;
	NSMutableDictionary* m_clusterIMWindowRegistry;
	NSMutableDictionary* m_faceManagerWindowRegistry;
	NSMutableDictionary* m_mobileIMWindowRegistry;
	NSMutableDictionary* m_tempSessionIMWindowRegistry;
	NSMutableDictionary* m_tempClusterInfoWindowRegistry;
}

+ (BOOL)isMainWindowOpened:(UInt32)QQ;
+ (MainWindowController*)getMainWindow:(UInt32)QQ;
+ (void)registerMainWindow:(UInt32)QQ window:(MainWindowController*)main;
+ (void)unregisterMainWindow:(UInt32)QQ;
+ (NSEnumerator*)mainWindowEnumerator;
+ (NSArray*)mainWindowArray;

+ (BOOL)isPreferenceWindowOpened:(UInt32)QQ;
+ (void)registerPreferenceWindow:(UInt32)QQ window:(PreferenceWindowController*)controller;
+ (void)unregisterPreferenceWindow:(UInt32)QQ;
+ (PreferenceWindowController*)getPreferenceWindow:(UInt32)QQ;
+ (PreferenceWindowController*)showPreferenceWindow:(MainWindowController*)mainWindowController;

+ (BOOL)isSystemMessageWindowOpened:(UInt32)QQ;
+ (SystemMessageWindowController*)getSystemMessageWindow:(UInt32)QQ;
+ (void)registerSystemMessageWindow:(UInt32)QQ window:(SystemMessageWindowController*)controller;
+ (void)unregisterSystemMessageWindow:(UInt32)QQ;
+ (SystemMessageWindowController*)showSystemMessageWindow:(MainWindowController*)mainWindowController;

+ (void)showAboutWindow;
+ (void)unregisterAboutWindow;

+ (void)showLuminanceWindow;
+ (void)unregisterLuminanceWindow;

+ (void)showQConsole;
+ (void)unregisterQConsole;

+ (BOOL)isTabIMWindowOpened:(UInt32)QQ;
+ (void)registerTabIMWindow:(UInt32)QQ window:(TabIMWindowController*)controller;
+ (void)unregisterTabIMWindow:(UInt32)QQ;
+ (TabIMWindowController*)getTabIMWindow:(UInt32)QQ;
+ (TabIMWindowController*)showTabIMWindow:(MainWindowController*)mainWindowController;

- (BOOL)isUserInfoWindowOpened:(UInt32)QQ;
- (void)registerUserInfoWindow:(UInt32)QQ window:(UserInfoWindowController*)controller;
- (void)unregisterUserInfoWindow:(UInt32)QQ;
- (UserInfoWindowController*)getUserInfoWindow:(UInt32)QQ;
- (UserInfoWindowController*)showUserInfoWindow:(User*)user mainWindow:(MainWindowController*)mainWindowController;
- (UserInfoWindowController*)showUserInfoWindow:(User*)user cluster:(Cluster*)cluster mainWindow:(MainWindowController*)mainWindowController;

- (BOOL)isSearchWizardOpened:(UInt32)QQ;
- (void)registerSearchWizard:(UInt32)QQ window:(SearchWindowController*)controller;
- (void)unregisterSearchWizard:(UInt32)QQ;
- (SearchWindowController*)getSearchWizard:(UInt32)QQ;
- (void)showSearchWizard:(UInt32)QQ mainWindow:(MainWindowController*)mainWindowController pageIdentifier:(NSString*)identifier;

- (BOOL)isAddFriendWindowOpened:(UInt32)QQ;
- (void)registerAddFriendWindow:(UInt32)QQ window:(AddFriendWindowController*)controller;
- (void)unregisterAddFriendWindow:(UInt32)QQ;
- (AddFriendWindowController*)getAddFriendWindow:(UInt32)QQ;
- (AddFriendWindowController*)showAddFriendWindow:(UInt32)QQ mainWindow:(MainWindowController*)mainWindowController;
- (AddFriendWindowController*)showAddFriendWindow:(UInt32)QQ head:(int)head nick:(NSString*)nick mainWindow:(MainWindowController*)mainWindowController;

- (BOOL)isJoinClusterWindowOpened:(UInt32)m_internalId;
- (void)registerJoinClusterWindow:(UInt32)m_internalId window:(JoinClusterWindowController*)controller;
- (void)unregisterJoinClusterWindow:(UInt32)m_internalId;
- (JoinClusterWindowController*)getJoinClusterWindow:(UInt32)m_internalId;
- (void)showJoinClusterWindow:(UInt32)m_internalId object:(id)object mainWindow:(MainWindowController*)mainWindowController;

- (BOOL)isDeleteUserWindowOpened:(UInt32)QQ;
- (void)registerDeleteUserWindow:(UInt32)QQ window:(DeleteUserWindowController*)controller;
- (void)unregisterDeleteUserWindow:(UInt32)QQ;
- (DeleteUserWindowController*)getDeleteUserWindow:(UInt32)QQ;
- (DeleteUserWindowController*)showDeleteUserWindow:(User*)user mainWindow:(MainWindowController*)mainWindowController;

- (BOOL)isClusterInfoWindowOpened:(UInt32)internalId;
- (void)registerClusterInfoWindow:(UInt32)internalId window:(ClusterInfoWindowController*)controller;
- (void)unregisterClusterInfoWindow:(UInt32)internalId;
- (ClusterInfoWindowController*)getClusterInfoWindow:(UInt32)internalId;
- (ClusterInfoWindowController*)showClusterInfoWindow:(Cluster*)cluster mainWindow:(MainWindowController*)mainWindowController;

- (BOOL)isTempClusterInfoWindowOpened:(UInt32)internalId;
- (void)registerTempClusterInfoWindow:(UInt32)internalId window:(NSWindowController*)controller;
- (void)unregisterTempClusterInfoWindow:(UInt32)internalId;
- (NSWindowController*)getTempClusterInfoWindow:(UInt32)internalId;
- (NSWindowController*)showTempClusterInfoWindow:(Cluster*)cluster parent:(Cluster*)parentCluster mainWindow:(MainWindowController*)mainWindowController;

- (BOOL)isNormalIMWindowOrTabFocused:(NSNumber*)QQ mainWindow:(MainWindowController*)main;
- (BOOL)isNormalIMWindowOpened:(NSNumber*)QQ;
- (void)registerNormalIMWindow:(NSNumber*)QQ window:(NSWindowController*)controller;
- (void)unregisterNormalIMWindow:(NSNumber*)QQ;
- (NSWindowController*)getNormalIMWindow:(NSNumber*)QQ;
- (NSWindowController*)showNormalIMWindowOrTab:(User*)user mainWindow:(MainWindowController*)mainWindowController;

- (BOOL)isTempSessionIMWindowOrTabFocused:(NSNumber*)QQ mainWindow:(MainWindowController*)main;
- (BOOL)isTempSessionIMWindowOpened:(NSNumber*)QQ;
- (void)registerTempSessionIMWindow:(NSNumber*)QQ window:(NSWindowController*)controller;
- (void)unregisterTempSessionIMWindow:(NSNumber*)QQ;
- (NSWindowController*)getTempSessionIMWindow:(NSNumber*)QQ;
- (NSWindowController*)showTempSessionIMWindowOrTab:(User*)user mainWindow:(MainWindowController*)mainWindowController;

- (BOOL)isMobileIMWindowOrTabFocused:(NSNumber*)QQ mainWindow:(MainWindowController*)main;
- (BOOL)isMobileIMWindowOrTabFocusedByMobile:(NSString*)mobile mainWindow:(MainWindowController*)main;
- (BOOL)isMobileIMWindowOpened:(NSNumber*)QQ;
- (BOOL)isMobileIMWindowOpenedByMobile:(NSString*)mobile;
- (void)registerMobileIMWindow:(NSNumber*)QQ window:(NSWindowController*)controller;
- (void)registerMobileIMWindowByMobile:(NSString*)mobile window:(NSWindowController*)controller;
- (void)unregisterMobileIMWindow:(NSNumber*)QQ;
- (void)unregisterMobileIMWindowByMobile:(NSString*)mobile;
- (NSWindowController*)getMobileIMWindow:(NSNumber*)QQ;
- (NSWindowController*)getMobileIMWindowByMobile:(NSString*)mobile;
- (NSWindowController*)showMobileIMWindowOrTab:(User*)user mainWindow:(MainWindowController*)mainWindowController;
- (NSWindowController*)showMobileIMWindowOrTabByMobile:(Mobile*)mobile mainWindow:(MainWindowController*)mainWindowController;

- (BOOL)isClusterIMWindowOrTabFocused:(NSNumber*)internalId mainWindow:(MainWindowController*)main;
- (BOOL)isClusterIMWindowOpened:(NSNumber*)internalId;
- (void)registerClusterIMWindow:(NSNumber*)internalId window:(NSWindowController*)controller;
- (void)unregisterClusterIMWindow:(NSNumber*)internalId;
- (NSWindowController*)getClusterIMWindow:(NSNumber*)internalId;
- (NSWindowController*)showClusterIMWindowOrTab:(Cluster*)cluster mainWindow:(MainWindowController*)mainWindowController;

- (BOOL)isFaceManagerWindowOpened:(UInt32)QQ;
- (void)registerFaceManagerWindow:(UInt32)QQ window:(FaceManagerWindowController*)controller;
- (void)unregisterFaceManagerWindow:(UInt32)QQ;
- (FaceManagerWindowController*)getFaceManagerWindow:(UInt32)QQ;
- (void)showFaceManagerWindow:(UInt32)QQ mainWindow:(MainWindowController*)mainWindowController;

- (NSWindowController*)showUserAuthWindow:(InPacket*)packet mainWindow:(MainWindowController*)mainWindowController;
- (NSWindowController*)showClusterAuthWindow:(InPacket*)packet mainWindow:(MainWindowController*)mainWindowController;

@end
