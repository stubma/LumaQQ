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

#import "Constants.h"
#import "WindowRegistry.h"
#import "MainWindowController.h"
#import "AboutWindowController.h"
#import "PreferenceCache.h"
#import "ClusterAuthWindowController.h"
#import "LuminanceWindowController.h"
#import "UserAuthWindowController.h"
#import "QConsoleWindowController.h"

@implementation WindowRegistry

// registry for Main Window, so it's static
static NSMutableDictionary* s_mainWindows = nil;
static NSMutableDictionary* s_preferenceWindows = nil;
static NSMutableDictionary* s_systemMessageWindows = nil;
static AboutWindowController* s_aboutWindowController = nil;
static NSMutableDictionary* s_tabIMWindows = nil;
static LuminanceWindowController* s_luminanceWindow = nil;
static QConsoleWindowController* s_qconsole = nil;

+ (void)initialize {
	s_mainWindows = [[NSMutableDictionary dictionary] retain];
	s_preferenceWindows = [[NSMutableDictionary dictionary] retain];
	s_systemMessageWindows = [[NSMutableDictionary dictionary] retain];
	s_tabIMWindows = [[NSMutableDictionary dictionary] retain];
}

+ (void)showAboutWindow {
	if(s_aboutWindowController == nil) {
		s_aboutWindowController = [[AboutWindowController alloc] init];
		[s_aboutWindowController showWindow:self];
	} else
		[[s_aboutWindowController window] orderFront:self];
}

+ (void)unregisterAboutWindow {
	s_aboutWindowController = nil;
}

+ (BOOL)isMainWindowOpened:(UInt32)QQ {
	return [s_mainWindows objectForKey:[NSNumber numberWithUnsignedInt:QQ]] != nil;
}

+ (MainWindowController*)getMainWindow:(UInt32)QQ {
	return [s_mainWindows objectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

+ (void)registerMainWindow:(UInt32)QQ window:(MainWindowController*)main {
	[s_mainWindows setObject:main forKey:[NSNumber numberWithUnsignedInt:QQ]];
}

+ (void)unregisterMainWindow:(UInt32)QQ {
	[s_mainWindows removeObjectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

+ (NSEnumerator*)mainWindowEnumerator {
	return [s_mainWindows objectEnumerator];
}

+ (NSArray*)mainWindowArray {
	return [s_mainWindows allValues];
}

+ (BOOL)isPreferenceWindowOpened:(UInt32)QQ {
	return [s_preferenceWindows objectForKey:[NSNumber numberWithUnsignedInt:QQ]] != nil;
}

+ (void)registerPreferenceWindow:(UInt32)QQ window:(PreferenceWindowController*)controller {
	[s_preferenceWindows setObject:controller forKey:[NSNumber numberWithUnsignedInt:QQ]];
}

+ (void)unregisterPreferenceWindow:(UInt32)QQ {
	[s_preferenceWindows removeObjectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

+ (PreferenceWindowController*)getPreferenceWindow:(UInt32)QQ {
	return [s_preferenceWindows objectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

+ (PreferenceWindowController*)showPreferenceWindow:(MainWindowController*)mainWindowController {
	UInt32 QQ = [[mainWindowController me] QQ];
	if([self isPreferenceWindowOpened:QQ]) {
		PreferenceWindowController* pwc = [self getPreferenceWindow:QQ];
		[pwc showWindow:self];
		return pwc;
	} else {
		PreferenceWindowController* pwc = [[PreferenceWindowController alloc] initWithMainWindow:mainWindowController];
		[self registerPreferenceWindow:QQ window:pwc];
		[pwc showWindow:self];
		[[pwc window] center];
		return pwc;
	}
}

+ (BOOL)isSystemMessageWindowOpened:(UInt32)QQ {
	return [s_systemMessageWindows objectForKey:[NSNumber numberWithUnsignedInt:QQ]] != nil; 
}

+ (SystemMessageWindowController*)getSystemMessageWindow:(UInt32)QQ {
	return [s_systemMessageWindows objectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

+ (void)registerSystemMessageWindow:(UInt32)QQ window:(SystemMessageWindowController*)controller {
	[s_systemMessageWindows setObject:controller forKey:[NSNumber numberWithUnsignedInt:QQ]];
}

+ (void)unregisterSystemMessageWindow:(UInt32)QQ {
	[s_systemMessageWindows removeObjectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

+ (SystemMessageWindowController*)showSystemMessageWindow:(MainWindowController*)mainWindowController {
	UInt32 QQ = [[mainWindowController me] QQ];
	if([self isSystemMessageWindowOpened:QQ]) {
		SystemMessageWindowController* smw = [self getSystemMessageWindow:QQ];
		[smw showWindow:self];
		return smw;
	} else {
		SystemMessageWindowController* smw = [[SystemMessageWindowController alloc] initWithMainWindow:mainWindowController];
		[self registerSystemMessageWindow:QQ window:smw];
		[smw showWindow:self];
		[[smw window] center];
		return smw;
	}
}

+ (BOOL)isTabIMWindowOpened:(UInt32)QQ {
	return [s_tabIMWindows objectForKey:[NSNumber numberWithUnsignedInt:QQ]] != nil;
}

+ (void)registerTabIMWindow:(UInt32)QQ window:(TabIMWindowController*)controller {
	[s_tabIMWindows setObject:controller forKey:[NSNumber numberWithUnsignedInt:QQ]];
}

+ (void)unregisterTabIMWindow:(UInt32)QQ {
	[s_tabIMWindows removeObjectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

+ (TabIMWindowController*)getTabIMWindow:(UInt32)QQ {
	return [s_tabIMWindows objectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

+ (TabIMWindowController*)showTabIMWindow:(MainWindowController*)mainWindowController {
	UInt32 QQ = [[mainWindowController me] QQ];
	if([self isTabIMWindowOpened:QQ]) {
		TabIMWindowController* tiw = [self getTabIMWindow:QQ];
		[[tiw window] orderFront:self];
		return tiw;
	} else {
		TabIMWindowController* tiw = [[TabIMWindowController alloc] initWithMainWindow:mainWindowController];
		[self registerTabIMWindow:QQ window:tiw];
		[tiw showWindow:self];
		return tiw;
	}
}

+ (void)showLuminanceWindow {
	if(s_luminanceWindow == nil)
		s_luminanceWindow = [[LuminanceWindowController alloc] init];
	[s_luminanceWindow showWindow:self];
}

+ (void)unregisterLuminanceWindow {
	s_luminanceWindow = nil;
}

+ (void)showQConsole {
	if(s_qconsole == nil)
		s_qconsole = [[QConsoleWindowController alloc] init];
	[s_qconsole showWindow:self];
}

+ (void)unregisterQConsole {
	s_qconsole = nil;
}

- (id) init {
	self = [super init];
	if (self != nil) {
		m_userInfoWindowRegistry = [[NSMutableDictionary dictionary] retain];
		m_searchWizardRegistry = [[NSMutableDictionary dictionary] retain];
		m_addFriendWindowRegistry = [[NSMutableDictionary dictionary] retain];
		m_joinClusterWindowRegistry = [[NSMutableDictionary dictionary] retain];
		m_deleteUserWindowRegistry = [[NSMutableDictionary dictionary] retain];
		m_clusterInfoWindowRegistry = [[NSMutableDictionary dictionary] retain];
		m_normalIMWindowRegistry = [[NSMutableDictionary dictionary] retain];
		m_clusterIMWindowRegistry = [[NSMutableDictionary dictionary] retain];
		m_faceManagerWindowRegistry = [[NSMutableDictionary dictionary] retain];
		m_mobileIMWindowRegistry = [[NSMutableDictionary dictionary] retain];
		m_tempSessionIMWindowRegistry = [[NSMutableDictionary dictionary] retain];
		m_tempClusterInfoWindowRegistry = [[NSMutableDictionary dictionary] retain];
	}
	return self;
}

- (void) dealloc {
	[m_tempClusterInfoWindowRegistry release];
	[m_userInfoWindowRegistry release];
	[m_searchWizardRegistry release];
	[m_addFriendWindowRegistry release];
	[m_joinClusterWindowRegistry release];
	[m_deleteUserWindowRegistry release];
	[m_clusterInfoWindowRegistry release];
	[m_normalIMWindowRegistry release];
	[m_clusterIMWindowRegistry release];
	[m_faceManagerWindowRegistry release];
	[m_mobileIMWindowRegistry release];
	[m_tempSessionIMWindowRegistry release];
	[super dealloc];
}

- (BOOL)isSearchWizardOpened:(UInt32)QQ {
	return [m_searchWizardRegistry objectForKey:[NSNumber numberWithUnsignedInt:QQ]] != nil;
}

- (void)registerSearchWizard:(UInt32)QQ window:(SearchWindowController*)controller {
	[m_searchWizardRegistry setObject:controller forKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (void)unregisterSearchWizard:(UInt32)QQ {
	[m_searchWizardRegistry removeObjectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (SearchWindowController*)getSearchWizard:(UInt32)QQ {
	return [m_searchWizardRegistry objectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (void)showSearchWizard:(UInt32)QQ mainWindow:(MainWindowController*)mainWindowController pageIdentifier:(NSString*)identifier {
	if([self isSearchWizardOpened:QQ]) {
		SearchWindowController* sw = [self getSearchWizard:QQ];
		[sw showWindow:self];
	} else {
		SearchWindowController* sw = [[SearchWindowController alloc] initWithMainWindowController:mainWindowController];
		[sw setInitialIdentifier:identifier];
		[self registerSearchWizard:QQ window:sw];
		[sw showWindow:self];
	}
}

- (BOOL)isUserInfoWindowOpened:(UInt32)QQ {
	return [m_userInfoWindowRegistry objectForKey:[NSNumber numberWithUnsignedInt:QQ]] != nil;
}

- (void)registerUserInfoWindow:(UInt32)QQ window:(UserInfoWindowController*)controller {
	[m_userInfoWindowRegistry setObject:controller forKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (void)unregisterUserInfoWindow:(UInt32)QQ {
	[m_userInfoWindowRegistry removeObjectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (UserInfoWindowController*)getUserInfoWindow:(UInt32)QQ {
	return [m_userInfoWindowRegistry objectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (UserInfoWindowController*)showUserInfoWindow:(User*)user mainWindow:(MainWindowController*)mainWindowController {
	return [self showUserInfoWindow:user cluster:nil mainWindow:mainWindowController];
}

- (UserInfoWindowController*)showUserInfoWindow:(User*)user cluster:(Cluster*)cluster mainWindow:(MainWindowController*)mainWindowController {
	if([self isUserInfoWindowOpened:[user QQ]]) {
		UserInfoWindowController* uiw = [self getUserInfoWindow:[user QQ]];
		[uiw showWindow:self];
		return uiw;
	} else {
		UserInfoWindowController* uiw = [[UserInfoWindowController alloc] initWithMainWindowController:mainWindowController
																								  user:user
																							   cluster:cluster];
		[self registerUserInfoWindow:[user QQ] window:uiw];
		[uiw showWindow:self];
		return uiw;
	}
}

- (BOOL)isAddFriendWindowOpened:(UInt32)QQ {
	return [m_addFriendWindowRegistry objectForKey:[NSNumber numberWithUnsignedInt:QQ]] != nil;
}

- (void)registerAddFriendWindow:(UInt32)QQ window:(AddFriendWindowController*)controller {
	[m_addFriendWindowRegistry setObject:controller forKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (void)unregisterAddFriendWindow:(UInt32)QQ {
	[m_addFriendWindowRegistry removeObjectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (AddFriendWindowController*)getAddFriendWindow:(UInt32)QQ {
	return [m_addFriendWindowRegistry objectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (AddFriendWindowController*)showAddFriendWindow:(UInt32)QQ mainWindow:(MainWindowController*)mainWindowController {
	return [self showAddFriendWindow:QQ
								head:0
								nick:kStringEmpty 
						  mainWindow:mainWindowController];
}

- (AddFriendWindowController*)showAddFriendWindow:(UInt32)QQ head:(int)head nick:(NSString*)nick mainWindow:(MainWindowController*)mainWindowController {
	if([self isAddFriendWindowOpened:QQ]) {
		AddFriendWindowController* afw = [self getAddFriendWindow:QQ];
		[afw showWindow:self];
		return afw;
	} else {
		AddFriendWindowController* afw = [[AddFriendWindowController alloc] initWithQQ:QQ
																				  head:head
																				  nick:nick
																  mainWindowController:mainWindowController];
		[self registerAddFriendWindow:QQ window:afw];
		[afw showWindow:self];
		return afw;
	}
}

- (BOOL)isJoinClusterWindowOpened:(UInt32)m_internalId {
	return [m_joinClusterWindowRegistry objectForKey:[NSNumber numberWithUnsignedInt:m_internalId]] != nil;
}

- (void)registerJoinClusterWindow:(UInt32)m_internalId window:(JoinClusterWindowController*)controller {
	[m_joinClusterWindowRegistry setObject:controller forKey:[NSNumber numberWithUnsignedInt:m_internalId]];
}

- (void)unregisterJoinClusterWindow:(UInt32)m_internalId {
	[m_joinClusterWindowRegistry removeObjectForKey:[NSNumber numberWithUnsignedInt:m_internalId]];
}

- (JoinClusterWindowController*)getJoinClusterWindow:(UInt32)m_internalId {
	return [m_joinClusterWindowRegistry objectForKey:[NSNumber numberWithUnsignedInt:m_internalId]];
}

- (void)showJoinClusterWindow:(UInt32)m_internalId object:(id)object mainWindow:(MainWindowController*)mainWindowController {
	if([self isJoinClusterWindowOpened:m_internalId]) {
		JoinClusterWindowController* jcw = [self getJoinClusterWindow:m_internalId];
		[jcw showWindow:self];
	} else {
		JoinClusterWindowController* jcw = [[JoinClusterWindowController alloc] initWithObject:object mainWindow:mainWindowController];
		[self registerJoinClusterWindow:m_internalId window:jcw];
		[jcw showWindow:self];
	}
}

- (BOOL)isDeleteUserWindowOpened:(UInt32)QQ {
	return [m_deleteUserWindowRegistry objectForKey:[NSNumber numberWithUnsignedInt:QQ]] != nil;
}

- (void)registerDeleteUserWindow:(UInt32)QQ window:(DeleteUserWindowController*)controller {
	[m_deleteUserWindowRegistry setObject:controller forKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (void)unregisterDeleteUserWindow:(UInt32)QQ {
	[m_deleteUserWindowRegistry removeObjectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (DeleteUserWindowController*)getDeleteUserWindow:(UInt32)QQ {
	return [m_deleteUserWindowRegistry objectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (DeleteUserWindowController*)showDeleteUserWindow:(User*)user mainWindow:(MainWindowController*)mainWindowController {
	if([self isDeleteUserWindowOpened:[user QQ]]) {
		DeleteUserWindowController* duw = [self getDeleteUserWindow:[user QQ]];
		[duw showWindow:self];
		return duw;
	} else {
		DeleteUserWindowController* duw = [[DeleteUserWindowController alloc] initWithUser:user
																				mainWindow:mainWindowController];
		[self registerDeleteUserWindow:[user QQ] window:duw];
		[duw showWindow:self];
		return duw;
	}
}

- (BOOL)isClusterInfoWindowOpened:(UInt32)internalId {
	return [m_clusterInfoWindowRegistry objectForKey:[NSNumber numberWithUnsignedInt:internalId]] != nil;
}

- (void)registerClusterInfoWindow:(UInt32)internalId window:(ClusterInfoWindowController*)controller {
	[m_clusterInfoWindowRegistry setObject:controller forKey:[NSNumber numberWithUnsignedInt:internalId]];
}

- (void)unregisterClusterInfoWindow:(UInt32)internalId {
	[m_clusterInfoWindowRegistry removeObjectForKey:[NSNumber numberWithUnsignedInt:internalId]];
}

- (ClusterInfoWindowController*)getClusterInfoWindow:(UInt32)internalId {
	return [m_clusterInfoWindowRegistry objectForKey:[NSNumber numberWithUnsignedInt:internalId]];
}

- (ClusterInfoWindowController*)showClusterInfoWindow:(Cluster*)cluster mainWindow:(MainWindowController*)mainWindowController {
	if([self isClusterInfoWindowOpened:[cluster internalId]]) {
		ClusterInfoWindowController* ciw = [self getClusterInfoWindow:[cluster internalId]];
		[ciw showWindow:self];
		return ciw;
	} else {
		ClusterInfoWindowController* ciw = [[ClusterInfoWindowController alloc] initWithCluster:cluster
																					 mainWindow:mainWindowController];
		[self registerClusterInfoWindow:[cluster internalId] window:ciw];
		[ciw showWindow:self];
		return ciw;
	}
}

- (BOOL)isTempClusterInfoWindowOpened:(UInt32)internalId {
	return [m_tempClusterInfoWindowRegistry objectForKey:[NSNumber numberWithUnsignedInt:internalId]] != nil;
}

- (void)registerTempClusterInfoWindow:(UInt32)internalId window:(NSWindowController*)controller {
	[m_tempClusterInfoWindowRegistry setObject:controller forKey:[NSNumber numberWithUnsignedInt:internalId]];
}

- (void)unregisterTempClusterInfoWindow:(UInt32)internalId {
	[m_tempClusterInfoWindowRegistry removeObjectForKey:[NSNumber numberWithUnsignedInt:internalId]];
}

- (NSWindowController*)getTempClusterInfoWindow:(UInt32)internalId {
	return [m_tempClusterInfoWindowRegistry objectForKey:[NSNumber numberWithUnsignedInt:internalId]];
}

- (NSWindowController*)showTempClusterInfoWindow:(Cluster*)cluster parent:(Cluster*)parentCluster mainWindow:(MainWindowController*)mainWindowController {
	if([self isTempClusterInfoWindowOpened:[cluster internalId]]) {
		NSWindowController* win = [self getTempClusterInfoWindow:[cluster internalId]];
		[win showWindow:self];
		return win;
	} else {
		NSWindowController* win = nil;
		if(parentCluster) {
			win = [[ModifySubjectWindowController alloc] initWithTempCluster:cluster
															   parentCluster:parentCluster
																  mainWindow:mainWindowController];
		} else {
			win = [[ModifyDialogWindowController alloc] initWithTempCluster:cluster
															  parentCluster:parentCluster
																 mainWindow:mainWindowController];
		}

		[self registerTempClusterInfoWindow:[cluster internalId] window:win];
		[win showWindow:self];
		return win;
	}
}

- (BOOL)isNormalIMWindowOrTabFocused:(NSNumber*)QQ mainWindow:(MainWindowController*)main {
	PreferenceCache* cache = [PreferenceCache cache:[[main me] QQ]];
	if([cache useTabStyleIMWindow]) {
		TabIMWindowController* tiw = [WindowRegistry getTabIMWindow:[[main me] QQ]];
		User* user = [[main groupManager] user:[QQ unsignedIntValue]];
		if(tiw && user)
			return [tiw isNormalIMTabFocused:user];
		else
			return NO;
	} else {
		NSWindowController* win = [self getNormalIMWindow:QQ];
		if(win == nil)
			return NO;
		else
			return [[win window] isKeyWindow];
	}
}

- (BOOL)isNormalIMWindowOpened:(NSNumber*)QQ {
	return [m_normalIMWindowRegistry objectForKey:QQ] != nil;
}

- (void)registerNormalIMWindow:(NSNumber*)QQ window:(NSWindowController*)controller {
	[m_normalIMWindowRegistry setObject:controller forKey:QQ];
}

- (void)unregisterNormalIMWindow:(NSNumber*)QQ {
	[m_normalIMWindowRegistry removeObjectForKey:QQ];
}

- (NSWindowController*)getNormalIMWindow:(NSNumber*)QQ {
	return [m_normalIMWindowRegistry objectForKey:QQ];
}

- (NSWindowController*)showNormalIMWindowOrTab:(User*)user mainWindow:(MainWindowController*)mainWindowController {
	// get tab im option
	PreferenceCache* cache = [PreferenceCache cache:[[mainWindowController me] QQ]];
	if([cache useTabStyleIMWindow]) {
		TabIMWindowController* tiw = [WindowRegistry showTabIMWindow:mainWindowController];
		[tiw showWindow:self];
		[tiw addUserTab:user];
		return tiw;
	} else {
		NSNumber* key = [NSNumber numberWithUnsignedInt:[user QQ]];
		if([self isNormalIMWindowOpened:key]) {
			NSWindowController* win = [self getNormalIMWindow:key];
			[win showWindow:self];
			return win;
		} else {
			NormalIMWindowController* win = [[NormalIMWindowController alloc] initWithUser:user mainWindow:mainWindowController];
			[win showWindow:self];
			return win;
		}
	}
}

- (BOOL)isTempSessionIMWindowOrTabFocused:(NSNumber*)QQ mainWindow:(MainWindowController*)main {
	PreferenceCache* cache = [PreferenceCache cache:[[main me] QQ]];
	if([cache useTabStyleIMWindow]) {
		TabIMWindowController* tiw = [WindowRegistry getTabIMWindow:[[main me] QQ]];
		User* user = [[main groupManager] user:[QQ unsignedIntValue]];
		if(tiw && user)
			return [tiw isTempSessionIMTabFocused:user];
		else
			return NO;
	} else {
		NSWindowController* win = [self getTempSessionIMWindow:QQ];
		if(win == nil)
			return NO;
		else
			return [[win window] isKeyWindow];
	}
}

- (BOOL)isTempSessionIMWindowOpened:(NSNumber*)QQ {
	return [m_tempSessionIMWindowRegistry objectForKey:QQ] != nil;
}

- (void)registerTempSessionIMWindow:(NSNumber*)QQ window:(NSWindowController*)controller {
	[m_tempSessionIMWindowRegistry setObject:controller forKey:QQ];
}

- (void)unregisterTempSessionIMWindow:(NSNumber*)QQ {
	[m_tempSessionIMWindowRegistry removeObjectForKey:QQ];
}

- (NSWindowController*)getTempSessionIMWindow:(NSNumber*)QQ {
	return [m_tempSessionIMWindowRegistry objectForKey:QQ];
}

- (NSWindowController*)showTempSessionIMWindowOrTab:(User*)user mainWindow:(MainWindowController*)mainWindowController {
	// get tab im option
	PreferenceCache* cache = [PreferenceCache cache:[[mainWindowController me] QQ]];
	if([cache useTabStyleIMWindow]) {
		TabIMWindowController* tiw = [WindowRegistry showTabIMWindow:mainWindowController];
		[tiw showWindow:self];
		[tiw addTempSessionTab:user];
		return tiw;
	} else {
		NSNumber* key = [NSNumber numberWithUnsignedInt:[user QQ]];
		if([self isTempSessionIMWindowOpened:key]) {
			NSWindowController* win = [self getTempSessionIMWindow:key];
			[win showWindow:self];
			return win;
		} else {
			TempSessionIMWindowController* win = [[TempSessionIMWindowController alloc] initWithUser:user mainWindow:mainWindowController];
			[win showWindow:self];
			return win;
		}
	}
}

- (BOOL)isMobileIMWindowOrTabFocused:(NSNumber*)QQ mainWindow:(MainWindowController*)main {
	PreferenceCache* cache = [PreferenceCache cache:[[main me] QQ]];
	if([cache useTabStyleIMWindow]) {
		TabIMWindowController* tiw = [WindowRegistry getTabIMWindow:[[main me] QQ]];
		User* user = [[main groupManager] user:[QQ unsignedIntValue]];
		if(tiw && user)
			return [tiw isMobileIMTabFocusedByUser:user];
		else
			return NO;
	} else {
		NSWindowController* win = [self getMobileIMWindow:QQ];
		if(win == nil)
			return NO;
		else
			return [[win window] isKeyWindow];
	}
}

- (BOOL)isMobileIMWindowOrTabFocusedByMobile:(NSString*)mobile mainWindow:(MainWindowController*)main {
	PreferenceCache* cache = [PreferenceCache cache:[[main me] QQ]];
	if([cache useTabStyleIMWindow]) {
		TabIMWindowController* tiw = [WindowRegistry getTabIMWindow:[[main me] QQ]];
		Mobile* m = [[main groupManager] mobile:mobile];
		if(tiw && m)
			return [tiw isMobileIMTabFocused:m];
		else
			return NO;
	} else {
		NSWindowController* win = [self getMobileIMWindowByMobile:mobile];
		if(win == nil)
			return NO;
		else
			return [[win window] isKeyWindow];
	}
}

- (BOOL)isMobileIMWindowOpened:(NSNumber*)QQ {
	return [m_mobileIMWindowRegistry objectForKey:QQ] != nil;
}

- (BOOL)isMobileIMWindowOpenedByMobile:(NSString*)mobile {
	return [m_mobileIMWindowRegistry objectForKey:mobile] != nil;
}

- (void)registerMobileIMWindow:(NSNumber*)QQ window:(NSWindowController*)controller {
	[m_mobileIMWindowRegistry setObject:controller forKey:QQ];
}

- (void)registerMobileIMWindowByMobile:(NSString*)mobile window:(NSWindowController*)controller {
	[m_mobileIMWindowRegistry setObject:controller forKey:mobile];
}

- (void)unregisterMobileIMWindow:(NSNumber*)QQ {
	[m_mobileIMWindowRegistry removeObjectForKey:QQ];
}

- (void)unregisterMobileIMWindowByMobile:(NSString*)mobile {
	[m_mobileIMWindowRegistry removeObjectForKey:mobile];
}

- (NSWindowController*)getMobileIMWindow:(NSNumber*)QQ {
	return [m_mobileIMWindowRegistry objectForKey:QQ];
}

- (NSWindowController*)getMobileIMWindowByMobile:(NSString*)mobile {
	return [m_mobileIMWindowRegistry objectForKey:mobile];
}

- (NSWindowController*)showMobileIMWindowOrTab:(User*)user mainWindow:(MainWindowController*)mainWindowController {
	// get tab im option
	PreferenceCache* cache = [PreferenceCache cache:[[mainWindowController me] QQ]];
	if([cache useTabStyleIMWindow]) {
		TabIMWindowController* tiw = [WindowRegistry showTabIMWindow:mainWindowController];
		[tiw showWindow:self];
		[tiw addMobileTabByUser:user];
		return tiw;
	} else {
		NSNumber* key = [NSNumber numberWithUnsignedInt:[user QQ]];
		if([self isMobileIMWindowOpened:key]) {
			NSWindowController* win = [self getMobileIMWindow:key];
			[win showWindow:self];
			return win;
		} else {
			MobileIMWindowController* win = [[MobileIMWindowController alloc] initWithObject:user mainWindow:mainWindowController];
			[win showWindow:self];
			return win;
		}
	}
}

- (NSWindowController*)showMobileIMWindowOrTabByMobile:(Mobile*)mobile mainWindow:(MainWindowController*)mainWindowController {
	// get tab im option
	PreferenceCache* cache = [PreferenceCache cache:[[mainWindowController me] QQ]];
	if([cache useTabStyleIMWindow]) {
		TabIMWindowController* tiw = [WindowRegistry showTabIMWindow:mainWindowController];
		[tiw showWindow:self];
		[tiw addMobileTab:mobile];
		return tiw;
	} else {
		if([self isMobileIMWindowOpenedByMobile:[mobile mobile]]) {
			NSWindowController* win = [self getMobileIMWindowByMobile:[mobile mobile]];
			[win showWindow:self];
			return win;
		} else {
			MobileIMWindowController* win = [[MobileIMWindowController alloc] initWithObject:mobile mainWindow:mainWindowController];
			[win showWindow:self];
			return win;
		}
	}
}

- (BOOL)isClusterIMWindowOrTabFocused:(NSNumber*)internalId mainWindow:(MainWindowController*)main {
	PreferenceCache* cache = [PreferenceCache cache:[[main me] QQ]];
	if([cache useTabStyleIMWindow]) {
		TabIMWindowController* tiw = [WindowRegistry getTabIMWindow:[[main me] QQ]];
		Cluster* cluster = [[main groupManager] cluster:[internalId unsignedIntValue]];
		if(tiw && cluster)
			return [tiw isClusterIMTabFocused:cluster];
		else
			return NO;
	} else {
		NSWindowController* win = [self getClusterIMWindow:internalId];
		if(win == nil)
			return NO;
		else
			return [[win window] isKeyWindow];
	}
}

- (BOOL)isClusterIMWindowOpened:(NSNumber*)internalId {
	return [m_clusterIMWindowRegistry objectForKey:internalId] != nil;
}

- (void)registerClusterIMWindow:(NSNumber*)internalId window:(NSWindowController*)controller {
	[m_clusterIMWindowRegistry setObject:controller forKey:internalId];
}

- (void)unregisterClusterIMWindow:(NSNumber*)internalId {
	[m_clusterIMWindowRegistry removeObjectForKey:internalId];
}

- (NSWindowController*)getClusterIMWindow:(NSNumber*)internalId {
	return [m_clusterIMWindowRegistry objectForKey:internalId];
}

- (NSWindowController*)showClusterIMWindowOrTab:(Cluster*)cluster mainWindow:(MainWindowController*)mainWindowController {
	// get tab im option
	PreferenceCache* cache = [PreferenceCache cache:[[mainWindowController me] QQ]];
	if([cache useTabStyleIMWindow]) {
		TabIMWindowController* tiw = [WindowRegistry showTabIMWindow:mainWindowController];
		[tiw showWindow:self];
		[tiw addClusterTab:cluster];
		return tiw;
	} else {
		NSNumber* key = [NSNumber numberWithUnsignedInt:[cluster internalId]];
		if([self isClusterIMWindowOpened:key]) {
			NSWindowController* win = [self getClusterIMWindow:key];
			[win showWindow:self];
			return win;
		} else {
			ClusterIMWindowController* win = [[ClusterIMWindowController alloc] initWithCluster:cluster mainWindow:mainWindowController];
			[win showWindow:self];
			return win;
		}
	}
}

- (BOOL)isFaceManagerWindowOpened:(UInt32)QQ {
	return [m_faceManagerWindowRegistry objectForKey:[NSNumber numberWithUnsignedInt:QQ]] != nil;
}

- (void)registerFaceManagerWindow:(UInt32)QQ window:(FaceManagerWindowController*)controller {
	[m_faceManagerWindowRegistry setObject:controller forKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (void)unregisterFaceManagerWindow:(UInt32)QQ {
	[m_faceManagerWindowRegistry removeObjectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (FaceManagerWindowController*)getFaceManagerWindow:(UInt32)QQ {
	return [m_faceManagerWindowRegistry objectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (void)showFaceManagerWindow:(UInt32)QQ mainWindow:(MainWindowController*)mainWindowController {
	if([self isFaceManagerWindowOpened:QQ]) {
		FaceManagerWindowController* fmw = [self getFaceManagerWindow:QQ];
		[fmw showWindow:self];
	} else {
		FaceManagerWindowController* fmw = [[FaceManagerWindowController alloc] initWithMainWindow:mainWindowController];
		[fmw showWindow:self];
	}
}

- (NSWindowController*)showUserAuthWindow:(InPacket*)packet mainWindow:(MainWindowController*)mainWindowController {
	UserAuthWindowController* uaw = [[UserAuthWindowController alloc] initWithObject:packet mainWindow:mainWindowController];
	[uaw showWindow:mainWindowController];
	return uaw;
}

- (NSWindowController*)showClusterAuthWindow:(InPacket*)packet mainWindow:(MainWindowController*)mainWindowController {
	ClusterAuthWindowController* caw = [[ClusterAuthWindowController alloc] initWithObject:packet mainWindow:mainWindowController];
	[caw showWindow:mainWindowController];
	return caw;
}

@end
