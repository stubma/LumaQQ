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

#import "TabIMWindowController.h"
#import "MainWindowController.h"
#import "Constants.h"
#import "AlertTool.h"
#import "NSData-MD5.h"
#import "NSData-BytesOperation.h"

#define _kToolBarTabIMWindow @"TabIMToolBar"

// toolbar item
#define _kToolbarItemOwner @"ToolbarItemOwner"
#define _kToolbarItemKeySetting @"ToolbarItemKeySetting"
#define _kToolbarItemHistory @"ToolbarItemHistory"

// sheet type
#define _kSheetCloseTabConfirm 0
#define _kSheetClusterCommandFailed 1

@implementation TabIMWindowController

- (id)initWithMainWindow:(MainWindowController*)mainWindowController {
	self = [super initWithWindowNibName:@"TabIM"];
	if(self) {
		m_mainWindowController = [mainWindowController retain];
		m_containerArray = [[NSMutableArray array] retain];
		m_historyRegistry = [[NSMutableDictionary dictionary] retain];
		m_historyDrawerOpened = NO;
		m_sheetType = -1;
	}
	return self;
}

- (void) dealloc {
	if(m_shortcutWindowController)
		[m_shortcutWindowController release];
	[m_mainWindowController release];
	[m_containerArray release];
	[m_historyRegistry release];
	[super dealloc];
}

- (void)windowDidLoad {
	// configure tab bar control
	[m_tabBar setCanCloseOnlyTab:YES];
	[m_tabBar setSizeCellsToFit:YES];
	[m_tabBar setCellMinWidth:50];
	
	// remove all tab item
	NSArray* tabItems = [m_tabView tabViewItems];
	NSEnumerator* e = [tabItems objectEnumerator];
	while(NSTabViewItem* item = [e nextObject])
		[m_tabView removeTabViewItem:item];
	
	// add observers
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleScreenscrapDataDidPopulatedNotification:)
												 name:kScreenscrapDataDidPopulatedNotificationName
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleTempJPGDidCreatedNotification:)
												 name:kTempJPGFileDidCreatedNotificationName
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleIMContainerModelDidChangedNotification:)
												 name:kIMContainerModelDidChangedNotificationName
											   object:nil];
	
	// add qq listener
	[[m_mainWindowController client] addQQListener:self];
}

- (void)windowDidEndSheet:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	switch(m_sheetType) {
		case _kSheetCloseTabConfirm:
			// if only one tab exists, close window
			if([m_tabView numberOfTabViewItems] == 1)
				[self close];
			else
				[m_tabView removeTabViewItem:[m_tabView selectedTabViewItem]];
			break;
		case _kSheetClusterCommandFailed:			
			// remove cluster from ui
			id<IMContainer> container = [[[m_tabView selectedTabViewItem] identifier] content];
			[[m_mainWindowController groupManager] removeCluster:[container model]];
			[m_mainWindowController reloadClusters];
			
			// if only one tab exists, close window
			if([m_tabView numberOfTabViewItems] == 1)
				[self close];
			else
				[m_tabView removeTabViewItem:[m_tabView selectedTabViewItem]];
			break;
	}
	
	m_sheetType = -1;
}

- (BOOL)windowShouldClose:(id)sender {
	// if tab count > 1, close tab, not window
	if([m_containerArray count] > 1) {
		[m_tabBar closeTab:[m_tabView selectedTabViewItem]];
		return NO;
	} else
		return YES;
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kScreenscrapDataDidPopulatedNotificationName
												  object:nil];	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kTempJPGFileDidCreatedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kIMContainerModelDidChangedNotificationName
												  object:nil];	
	
	// unregister me
	[WindowRegistry unregisterTabIMWindow:[[m_mainWindowController me] QQ]];
	
	// remove all qq listener
	NSArray* items = [m_tabView tabViewItems];
	NSEnumerator* e = [items objectEnumerator];
	while(NSTabViewItem* item = [e nextObject]) {
		id<IMContainer> container = [[item identifier] content];
		[[m_mainWindowController client] removeQQListener:container];
	}
	[[m_mainWindowController client] removeQQListener:self];
	
	[self release];
}

- (void)windowDidBecomeKey:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	id<IMContainer> container = [self activeContainer];
	if(container) {
		[container walkMessageQueue:[m_mainWindowController messageQueue]];
	}
}

- (IBAction)showWindow:(id)sender {
	[super showWindow:sender];
	NSTabViewItem* item = [m_tabView selectedTabViewItem];
	if(item) {
		id<IMContainer> container = [[item identifier] content];
		[container walkMessageQueue:[m_mainWindowController messageQueue]];
	}
}

- (void)handleScreenscrapDataDidPopulatedNotification:(NSNotification*)notification {
	// only process this notification when I am focused
	if([[self window] isKeyWindow]) {				
		// get md5
		NSData* md5 = [[notification object] MD5];
		NSString* md5Str = [md5 hexString];
		
		// insert screenscrap
		id<IMContainer> container = [self activeContainer];
		if(container && [container allowCustomFace]) {
			[[container inputBox] insertCustomFace:kFaceTypeScreenscrap
											   md5:md5Str
											  path:[[notification userInfo] objectForKey:kUserInfoImagePath]
										  received:NO];
		}
	}
}

- (void)handleTempJPGDidCreatedNotification:(NSNotification*)notification {
	// only process this notification when I am focused
	if([[self window] isKeyWindow]) {				
		// get md5
		NSData* md5 = [[notification object] MD5];
		NSString* md5Str = [md5 hexString];
		
		// insert screenscrap
		id<IMContainer> container = [self activeContainer];
		if(container && [container allowCustomFace]) {
			[[container inputBox] insertCustomFace:kFaceTypePicture
											   md5:md5Str
											  path:[[notification userInfo] objectForKey:kUserInfoImagePath]
										  received:NO];
		}
	}
}

- (void)handleIMContainerModelDidChangedNotification:(NSNotification*)notification {
	id model = [notification object];
	id<IMContainer> container = [self activeContainer];
	if(container) {
		if([model isEqual:[container model]]) {
			// get head control
			NSToolbar* toolbar = [[self window] toolbar];
			NSToolbarItem* headItem = [[toolbar items] objectAtIndex:0];
			HeadControl* headControl = (HeadControl*)[headItem view];
			
			// refresh
			[headControl setOwner:[[m_mainWindowController me] QQ]];
			[headControl setObjectValue:model];
			[headControl display];
			
			// refresh window title, tab label if current tab model is same as changed model
			NSTabViewItem* item = [m_tabView selectedTabViewItem];
			id<IMContainer> currentContainer = [[item identifier] content];
			if(currentContainer == container) {
				// set new window title
				[[self window] setTitle:[(id)container description]];
				
				// refresh tab label
				[item setLabel:[container shortDescription]];
			}
		}
	}
}

#pragma mark -
#pragma mark helper

- (id<IMContainer>)activeContainer {
	NSTabViewItem* item = [m_tabView selectedTabViewItem];
	if(item)
		return [[item identifier] content];
	else
		return nil;
}

- (void)activateContainer:(id<IMContainer>)container {
	NSEnumerator* e = [[m_tabView tabViewItems] objectEnumerator];
	while(NSTabViewItem* item = [e nextObject]) {
		if([(id)container isEqual:[[item identifier] content]]) {
			[m_tabView selectTabViewItem:item];
			break;
		}
	}
}

- (id<IMContainer>)findContainer:(id)model {
	NSEnumerator* e = [m_containerArray objectEnumerator];
	while(id<IMContainer> container = [e nextObject]) {
		if([[container model] isEqual:model])
			return container;
	}
	return nil;
}

#pragma mark -
#pragma mark API

- (void)addContainerTab:(id<IMContainer>)container {
	// create ite
	NSTabViewItem* item = [[[NSTabViewItem alloc] initWithIdentifier:[container controller]] autorelease];
	[item setView:[container view]];
	[item setLabel:[container shortDescription]];
	
	// add item and select item
	[m_tabView addTabViewItem:item];
	[m_tabView selectTabViewItem:item];
	
	// init container
	[[container inputBox] setDelegate:self];
	
	// create history drawer
	HistoryDrawerController* historyController = [[HistoryDrawerController alloc] initWithMainWindow:m_mainWindowController history:[container history]];
	[NSBundle loadNibNamed:@"HistoryDrawer" owner:historyController];
	[[historyController drawer] setParentWindow:[self window]];
	[m_historyRegistry setObject:historyController forKey:container];
	[historyController release];
	
	// add qq listener
	[[m_mainWindowController client] addQQListener:container];
	
	// register container
	[m_containerArray addObject:container];
	
	// post notification
	[[NSNotificationCenter defaultCenter] postNotificationName:kIMContainerAttachedToWindowNotificationName
														object:[container view]
													  userInfo:[NSDictionary dictionaryWithObject:[self window] forKey:kUserInfoAttachToWindow]];
}

- (void)addUserTab:(User*)user {
	NormalIMContainerController* container = [[NormalIMContainerController alloc] initWithObject:user mainWindow:m_mainWindowController];
	if(![m_containerArray containsObject:container]) {
		// load container
		[NSBundle loadNibNamed:@"NormalIMContainer" owner:container];
		[self addContainerTab:container];
	} else
		[self activateContainer:container];
	[container release];
}

- (void)addClusterTab:(Cluster*)cluster {
	ClusterIMContainerController* container = [[ClusterIMContainerController alloc] initWithObject:cluster mainWindow:m_mainWindowController];
	if(![m_containerArray containsObject:container]) {
		// load container
		[NSBundle loadNibNamed:@"ClusterIMContainer" owner:container];
		[self addContainerTab:container];
		
		// show member list
		[container performAction:kToolbarItemSwitchMemberView];
	} else
		[self activateContainer:container];
	[container release];
}

- (void)addMobileTab:(Mobile*)mobile {
	MobileIMContainerController* container = [[MobileIMContainerController alloc] initWithObject:mobile mainWindow:m_mainWindowController];
	if(![m_containerArray containsObject:container]) {
		// load container
		[NSBundle loadNibNamed:@"MobileIMContainer" owner:container];
		[self addContainerTab:container];
	} else
		[self activateContainer:container];
	[container release];
}

- (void)addMobileTabByUser:(User*)user {
	MobileIMContainerController* container = [[MobileIMContainerController alloc] initWithObject:user mainWindow:m_mainWindowController];
	if(![m_containerArray containsObject:container]) {
		// load container
		[NSBundle loadNibNamed:@"MobileIMContainer" owner:container];
		[self addContainerTab:container];
	} else
		[self activateContainer:container];
	[container release];
}

- (void)addTempSessionTab:(User*)user {
	TempSessionIMContainerController* container = [[TempSessionIMContainerController alloc] initWithObject:user mainWindow:m_mainWindowController];
	if(![m_containerArray containsObject:container]) {
		// load container
		[NSBundle loadNibNamed:@"TempSessionIMContainer" owner:container];
		[self addContainerTab:container];
	} else
		[self activateContainer:container];
	[container release];
}

- (BOOL)isNormalIMTabFocused:(User*)user {
	if(![[self window] isKeyWindow])
		return NO;
	
	NSTabViewItem* item = [m_tabView selectedTabViewItem];
	id<IMContainer> container = [[item identifier] content];
	if([(id)container isMemberOfClass:[NormalIMContainerController class]] &&
	   [[container model] isEqual:user])
		return YES;
	else
		return NO;
}

- (BOOL)isTempSessionIMTabFocused:(User*)user {
	if(![[self window] isKeyWindow])
		return NO;
	
	NSTabViewItem* item = [m_tabView selectedTabViewItem];
	id<IMContainer> container = [[item identifier] content];
	if([(id)container isMemberOfClass:[TempSessionIMContainerController class]] &&
	   [[container model] isEqual:user])
		return YES;
	else
		return NO;
}

- (BOOL)isClusterIMTabFocused:(Cluster*)cluster {
	if(![[self window] isKeyWindow])
		return NO;
	
	NSTabViewItem* item = [m_tabView selectedTabViewItem];
	id<IMContainer> container = [[item identifier] content];
	if([(id)container isMemberOfClass:[ClusterIMContainerController class]] &&
	   [[container model] isEqual:cluster])
		return YES;
	else
		return NO;
}

- (BOOL)isMobileIMTabFocused:(Mobile*)mobile {
	if(![[self window] isKeyWindow])
		return NO;
	
	NSTabViewItem* item = [m_tabView selectedTabViewItem];
	id<IMContainer> container = [[item identifier] content];
	if([(id)container isMemberOfClass:[MobileIMContainerController class]] &&
	   [[container model] isEqual:mobile])
		return YES;
	else
		return NO;
}

- (BOOL)isMobileIMTabFocusedByUser:(User*)user {
	if(![[self window] isKeyWindow])
		return NO;
	
	NSTabViewItem* item = [m_tabView selectedTabViewItem];
	id<IMContainer> container = [[item identifier] content];
	if([(id)container isMemberOfClass:[MobileIMContainerController class]] &&
	   [[container model] isEqual:user])
		return YES;
	else
		return NO;
}

- (BOOL)validateMenuItem:(id <NSMenuItem>)menuItem {
	NSString* string = NSStringFromSelector([menuItem action]);
	if([string isEqualToString:@"shiftClose:"]) {
		[menuItem setTitle:L(@"LQCloseAllTab")];
		return [m_containerArray count] > 1;
	} else if([string isEqualToString:@"performClose:"]) {
		if([m_containerArray count] > 1)
			[menuItem setTitle:L(@"LQCloseCurrentTab")];
		else
			[menuItem setTitle:L(@"LQClose")];
		return YES;
	} else
		return [super validateMenuItem:menuItem];
}

#pragma mark -
#pragma mark qq text view delegate

- (void)closeKeyTriggerred:(QQTextView*)textView {
	// close tab, if you don't use tab mode, this key close window
	[m_tabBar closeTab:[m_tabView selectedTabViewItem]];
}

- (void)historyKeyTriggerred:(QQTextView*)textView {
	[self onHistory:textView];
}

- (void)sendKeyTriggerred:(QQTextView*)textView {
	NSTabViewItem* item = [m_tabView selectedTabViewItem];
	[[[item identifier] content] send:self];
}

- (void)switchTabKeyTriggerred:(QQTextView*)textView {
	int count = [m_tabView numberOfTabViewItems];
	int index = [m_tabView indexOfTabViewItem:[m_tabView selectedTabViewItem]];
	
	// search from index + 1 to count - 1
	for(int i = index + 1; i < count; i++) {
		NSTabViewItem* item = [m_tabView tabViewItemAtIndex:i];
		id<IMContainer> container = [[item identifier] content];
		if([container objectCount] > 0) {
			[m_tabView selectTabViewItem:item];
			[[self window] makeFirstResponder:[container inputBox]];
			return;
		}
	}
	
	// search from 0 to index - 1
	for(int i = 0; i < index; i++) {
		NSTabViewItem* item = [m_tabView tabViewItemAtIndex:i];
		id<IMContainer> container = [[item identifier] content];
		if([container objectCount] > 0) {
			[m_tabView selectTabViewItem:item];
			[[self window] makeFirstResponder:[container inputBox]];
			return;
		}
	}
}

#pragma mark -
#pragma mark toolbar delegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
	id<IMContainer> container = [[[m_tabView selectedTabViewItem] identifier] content];
	NSToolbarItem* item = [container actionItem:itemIdentifier];
	if(item == nil) {
		if([itemIdentifier isEqualToString:_kToolbarItemOwner]) {
			item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
			
			// create control
			HeadControl* headControl = [[[HeadControl alloc] init] autorelease];
			[container refreshHeadControl:headControl];
			[headControl setTarget:self];
			[headControl setAction:@selector(onHeadItem:)];
			
			// set control to item
			[item setView:headControl];
			
			// set size
			[item setMinSize:NSMakeSize(24, 24)];
			[item setMaxSize:NSMakeSize(24, 24)];
			
			// set tooltip
			[item setToolTip:[NSString stringWithFormat:L(@"LQTooltipOwner", @"BaseIMContainer"), [(id)container description]]];
		} else if([itemIdentifier isEqualToString:_kToolbarItemHistory]) {
			item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
			[item setImage:[NSImage imageNamed:kImageChatHistory]];
			[item setTarget:self];
			[item setAction:@selector(onHistory:)];
			[item setToolTip:L(@"LQTooltipHistory", @"BaseIMContainer")];
		} else if([itemIdentifier isEqualToString:_kToolbarItemKeySetting]) {
			item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
			[item setImage:[NSImage imageNamed:kImageHotKey]];
			[item setTarget:self];
			[item setAction:@selector(onKeySetting:)];
			[item setToolTip:L(@"LQTooltipKeySetting", @"BaseIMContainer")];
		}
	} else {
		[item setTarget:self];
		[item setAction:@selector(onToolbarItem:)];
	}
	return item;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
	if([m_tabView selectedTabViewItem]) {
		id<IMContainer> container = [[[m_tabView selectedTabViewItem] identifier] content];
		NSMutableArray* identifiers = [NSMutableArray arrayWithArray:[container actionIds]];
		[identifiers insertObject:NSToolbarSeparatorItemIdentifier atIndex:0];
		[identifiers insertObject:_kToolbarItemHistory atIndex:0];
		[identifiers insertObject:_kToolbarItemKeySetting atIndex:0];
		[identifiers insertObject:NSToolbarSeparatorItemIdentifier atIndex:0];
		[identifiers insertObject:_kToolbarItemOwner atIndex:0];
		return identifiers;
	} else
		return [NSArray array];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
	if([m_tabView selectedTabViewItem]) {
		id<IMContainer> container = [[[m_tabView selectedTabViewItem] identifier] content];
		NSMutableArray* identifiers = [NSMutableArray arrayWithArray:[container actionIds]];
		[identifiers addObject:_kToolbarItemOwner];
		[identifiers addObject:_kToolbarItemHistory];
		[identifiers addObject:_kToolbarItemKeySetting];
		return identifiers;
	} else
		return [NSArray array];
}

#pragma mark -
#pragma mark actions

- (IBAction)shiftClose:(id)sender {
	[self close];
}

- (IBAction)onHeadItem:(id)sender {
	NSTabViewItem* item = [m_tabView selectedTabViewItem];
	[[[item identifier] content] showOwnerInfo:sender];
}

- (IBAction)onToolbarItem:(id)sender {
	NSTabViewItem* item = [m_tabView selectedTabViewItem];
	[[[item identifier] content] performAction:[sender itemIdentifier]];
}

- (IBAction)onKeySetting:(id)sender {
	if(m_shortcutWindowController == nil) {
		m_shortcutWindowController = [[KeyboardShortcutWindowController alloc] initWithQQ:[[m_mainWindowController me] QQ]];
		[NSBundle loadNibNamed:@"KeyboardShortcutWindow" owner:m_shortcutWindowController];
	}
	
	[m_shortcutWindowController beginSheet:[self window]
							 modalDelegate:nil
							didEndSelector:nil];
}

- (IBAction)onHistory:(id)sender {
	NSTabViewItem* item = [m_tabView selectedTabViewItem];
	HistoryDrawerController* historyController = [m_historyRegistry objectForKey:[[item identifier] content]];
	[[historyController drawer] toggle:self];
}

#pragma mark -
#pragma mark alert delegate

- (void)closeTabConfirmAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	if(returnCode == NSAlertDefaultReturn) {
		m_sheetType = _kSheetCloseTabConfirm;
	}
}

- (void)clusterCommandFailedAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	m_sheetType = _kSheetClusterCommandFailed;
}

#pragma mark -
#pragma mark PSM Tab delegate

- (void)tabBar:(PSMTabBarControl*)aTabBar willAddTabForItem:(NSTabViewItem*)tabViewItem {
	
}

- (BOOL)tabView:(NSTabView *)tabView shouldCloseTabViewItem:(NSTabViewItem *)tabViewItem {
	id<IMContainer> container = [[tabViewItem identifier] content];
	if([container pendingMessageCount] > 0) {
		if([m_tabView selectedTabViewItem] != tabViewItem)
			[m_tabView selectTabViewItem:tabViewItem];
		[AlertTool showConfirm:[self window]
					   message:L(@"LQWarningHasPendingMessage", @"BaseIMContainer")
				 defaultButton:L(@"LQYes")
			   alternateButton:L(@"LQNo")
					  delegate:self
				didEndSelector:@selector(closeTabConfirmAlertDidEnd:returnCode:contextInfo:)];
		return NO;
	} else
		return YES;
}

- (void)tabView:(NSTabView *)tabView willCloseTabViewItem:(NSTabViewItem *)tabViewItem {
	// check history drawer, if opened, close it
	id<IMContainer> container = [[tabViewItem identifier] content];
	HistoryDrawerController* historyDrawer = [m_historyRegistry objectForKey:container];
	if(historyDrawer) {
		[historyDrawer retain];
		[m_historyRegistry removeObjectForKey:container];
		[[historyDrawer drawer] close];
		[historyDrawer release];
	}
	
	// remove qq listener
	[[m_mainWindowController client] removeQQListener:container];
	
	// remove from registry
	[m_containerArray removeObject:container];
}

- (void)tabView:(NSTabView *)aTabView didCloseTabViewItem:(NSTabViewItem *)tabViewItem {
	// close window if no tab
	if([aTabView numberOfTabViewItems] == 0)
		[self close];
}

- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem {
	// check history drawer state
	id<IMContainer> container = [[[m_tabView selectedTabViewItem] identifier] content];
	HistoryDrawerController* historyDrawer = [m_historyRegistry objectForKey:container];
	if(historyDrawer == nil)
		m_historyDrawerOpened = NO;
	else {
		int state = [[historyDrawer drawer] state];
		m_historyDrawerOpened = state == NSDrawerOpenState || state == NSDrawerOpeningState;
		if(m_historyDrawerOpened)
			[[historyDrawer drawer] toggle:self];
	}
	
	return YES;
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
	// get current container
	id<IMContainer> container = [[tabViewItem identifier] content];
	
	// set new window title
	[[self window] setTitle:[(id)container description]];
	
	// install a new toolbar
	NSToolbar* toolbar = [[[NSToolbar alloc] initWithIdentifier:[container owner]] autorelease];
	[toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
	[toolbar setSizeMode:NSToolbarSizeModeSmall];
	[toolbar setAllowsUserCustomization:NO];
	[toolbar setDelegate:self];
	[[self window] setToolbar:toolbar];
	
	// check history
	if(m_historyDrawerOpened) {
		HistoryDrawerController* historyDrawer = [m_historyRegistry objectForKey:container];
		[[historyDrawer drawer] open];
	}
	
	// walk message queue
	[container walkMessageQueue:[m_mainWindowController messageQueue]];
	
	// make input box has focus
	[[self window] makeFirstResponder:[container inputBox]];
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	switch([event eventId]) {
		case kQQEventClusterCommandFailed:
			ret = [self handleClusterCommandFailed:event];
			break;
	}
	return ret;
}

- (BOOL)handleClusterCommandFailed:(QQNotification*)event {
	ClusterCommandPacket* packet = (ClusterCommandPacket*)[event outPacket];
	Cluster* cluster = [[m_mainWindowController groupManager] cluster:[packet internalId]];
	if(cluster) {
		ClusterCommandReplyPacket* replyPacket = (ClusterCommandReplyPacket*)[event object];
		switch([replyPacket reply]) {
			case kQQReplyNoSuchCluster:
			case kQQReplyTempClusterRemoved:
			case kQQReplyNotClusterMember:
			case kQQReplyNotTempClusterMember:
				// find model container
				NSEnumerator* e = [m_containerArray objectEnumerator];
				while(id<IMContainer> container = [e nextObject]) {
					if([container model] == cluster) {
						// activate container
						[self activateContainer:container];
						
						// show warning
						[AlertTool showWarning:[self window]
										 title:L(@"LQFailed")
									   message:[[event object] errorMessage]
									  delegate:self
								didEndSelector:@selector(clusterCommandFailedAlertDidEnd:returnCode:contextInfo:)];
						break;
					}
				}
					
				// remove cluster from ui
				[[m_mainWindowController groupManager] removeCluster:cluster];
				[m_mainWindowController reloadClusters];
				
				break;
		}
	} else {
		// find container
		cluster = [[[Cluster alloc] initWithInternalId:[packet internalId] domain:m_mainWindowController] autorelease];
		id<IMContainer> container = [self findContainer:cluster];
		if(container) {
			// activate container
			[self activateContainer:container];
			
			// show warning
			[AlertTool showWarning:[self window]
							 title:L(@"LQFailed")
						   message:[[event object] errorMessage]
						  delegate:self
					didEndSelector:@selector(clusterCommandFailedAlertDidEnd:returnCode:contextInfo:)];
		}
	}
	return NO;
}

@end
