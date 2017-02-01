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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 0 2111-1307 USA
 */

#import <Cocoa/Cocoa.h>
#import "PSMTabBarControl.h"
#import "Cluster.h"
#import "User.h"
#import "Mobile.h"
#import "KeyboardShortcutWindowController.h"
#import "IMContainer.h"

@class MainWindowController;

@interface TabIMWindowController : NSWindowController <QQListener> {
	IBOutlet PSMTabBarControl* m_tabBar;
	IBOutlet NSTabView* m_tabView;
	
	MainWindowController* m_mainWindowController;
	KeyboardShortcutWindowController* m_shortcutWindowController;
	
	NSMutableArray* m_containerArray;
	NSMutableDictionary* m_historyRegistry;
	
	BOOL m_historyDrawerOpened;
	int m_sheetType;
}

- (id)initWithMainWindow:(MainWindowController*)mainWindowController;

// actions
- (IBAction)onKeySetting:(id)sender;
- (IBAction)onHistory:(id)sender;
- (IBAction)onToolbarItem:(id)sender;
- (IBAction)onHeadItem:(id)sender;
- (IBAction)shiftClose:(id)sender;

// API
- (void)addContainerTab:(id<IMContainer>)container;
- (void)addUserTab:(User*)user;
- (void)addClusterTab:(Cluster*)cluster;
- (void)addMobileTab:(Mobile*)mobile;
- (void)addMobileTabByUser:(User*)user;
- (void)addTempSessionTab:(User*)user;
- (BOOL)isNormalIMTabFocused:(User*)user;
- (BOOL)isTempSessionIMTabFocused:(User*)user;
- (BOOL)isClusterIMTabFocused:(Cluster*)cluster;
- (BOOL)isMobileIMTabFocused:(Mobile*)mobile;
- (BOOL)isMobileIMTabFocusedByUser:(User*)user;

// helper
- (void)activateContainer:(id<IMContainer>)container;
- (id<IMContainer>)activeContainer;
- (id<IMContainer>)findContainer:(id)model;

// observer
- (void)handleScreenscrapDataDidPopulatedNotification:(NSNotification*)notification;
- (void)handleTempJPGDidCreatedNotification:(NSNotification*)notification;
- (void)handleIMContainerModelDidChangedNotification:(NSNotification*)notification;

// delegate
- (void)closeTabConfirmAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;
- (void)clusterCommandFailedAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;

// qq event handler
- (BOOL)handleClusterCommandFailed:(QQNotification*)event;

@end
