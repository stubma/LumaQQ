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

#import "Constants.h"
#import "LocalizedStringTool.h"
#import "MainWindowController.h"
#import "PreferenceCache.h"
#import "PreferenceWindowController.h"
#import "WindowRegistry.h"
#import "HotKeyManager.h"
#import "AlertTool.h"
#import "NSString-Validate.h"
#import "ImageTool.h"
#import "MessageWingTask.h"
#import "TimerTaskManager.h"

#define _kTagAlwaysOnTop 5
#define _kTagAutoEjectMessage 1
#define _kTagAutoHideMainWindow 2
#define _kTagUseTabStyleIMWindow 3
#define _kTagHideMainWindowWhenClose 4
#define _kTagDisableOutlineTooltip 6

#define _kTagRejectStrangerMessage 0
#define _kTagDisableUserOnlineTip 1
#define _kTagDisplayUnreadCountOnDock 2
#define _kTagJumpIconWhenReceivedIM 3
#define _kTagDisableDockIconAnimation 4

#define _kProtocolUDP 1
#define _kProtocolTCP 0
#define _kProxyTypeNone 0
#define _kProxyTypeHTTP 3
#define _kProxyTypeSocks4 1
#define _kProxyTypeSocks5 2

@implementation PreferenceWindowController

- (id)initWithMainWindow:(MainWindowController*)mainWindowController {
	self = [super init];
	if (self != nil) {
		m_mainWindowController = [mainWindowController retain];
		m_soundFiles = [[NSMutableDictionary dictionary] retain];
	}
	return self;
}

- (NSString *)windowNibName {
	return @"Preference";
}

- (NSString*)toolbarIdentifier {
	return @"LumaQQPreferenceToolbar";
}

- (void) dealloc {
	[m_mainWindowController release];
	[m_soundFiles release];
	[super dealloc];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	// refresh dock icon
	PreferenceCache* cache = [PreferenceCache cache:[[m_mainWindowController me] QQ]];
	[m_mainWindowController refreshDockIcon];
	if(![cache disableDockIconAnimation] && [[m_mainWindowController messageQueue] pendingMessageCount] > 0)
		[[TimerTaskManager sharedManager] addTask:[MessageWingTask taskWithMainWindow:m_mainWindowController]];
	
	[WindowRegistry unregisterPreferenceWindow:[[m_mainWindowController me] QQ]];
	[super windowWillClose:aNotification];
}

- (void)windowDidLoad {
	[super windowDidLoad];
	
	// set window title
	[[self window] setTitle:[NSString stringWithFormat:L(@"LQTitle", @"Preference"), [[m_mainWindowController me] QQ]]];
	
	// get preference
	PreferenceCache* cache = [PreferenceCache cache:[[m_mainWindowController me] QQ]];
	
	// init basic panel
	if([cache alwaysOnTop])
		[m_mxWindow selectCellWithTag:_kTagAlwaysOnTop];
	if([cache autoEjectMessage])
		[m_mxWindow selectCellWithTag:_kTagAutoEjectMessage];
	if([cache autoHideMainWindow])
		[m_mxWindow selectCellWithTag:_kTagAutoHideMainWindow];
	if([cache useTabStyleIMWindow])
		[m_mxWindow selectCellWithTag:_kTagUseTabStyleIMWindow];
	if([cache hideOnClose])
		[m_mxWindow selectCellWithTag:_kTagHideMainWindowWhenClose];
	if([cache disableOutlineTooltip])
		[m_mxWindow selectCellWithTag:_kTagDisableOutlineTooltip];
	if([cache rejectStrangerMessage])
		[m_mxOverall selectCellWithTag:_kTagRejectStrangerMessage];
	if(![cache isUserOnlineTipEnabled])
		[m_mxOverall selectCellWithTag:_kTagDisableUserOnlineTip];
	if([cache displayUnreadCountOnDock])
		[m_mxOverall selectCellWithTag:_kTagDisplayUnreadCountOnDock];
	if([cache jumpIconWhenReceivedIM])
		[m_mxOverall selectCellWithTag:_kTagJumpIconWhenReceivedIM];
	if([cache disableDockIconAnimation])
		[m_mxOverall selectCellWithTag:_kTagDisableDockIconAnimation];
	[m_mxUpload selectCellWithTag:[cache uploadFriendGroupMode]];
	
	// init hotkey panel
	[m_hotKeyExtractMessage setAlignment:NSCenterTextAlignment];
	[m_hotKeyExtractMessage setString:[cache extractMessageHotKey]];
	[m_hotKeyScreenscrap setAlignment:NSCenterTextAlignment];
	[m_hotKeyScreenscrap setString:[cache screenscrapHotKey]];
	
	// init sound panel
	[m_chkEnableSound setState:[cache isEnableSound]];
	[self enableSoundBox:[cache isEnableSound]];
	[self onSoundTypeChanged:m_pbSoundType];
	
	// load sound schema menu from plugin
	NSMenu* menu = [m_pbSoundSchema menu];
	[[menu itemAtIndex:0] setAction:@selector(onSoundSchemaChanged:)];
	[[menu itemAtIndex:0] setTarget:self];
	int index = 0;
	int selected = 0;
	NSEnumerator* e = [[m_mainWindowController pluginManager] soundPluginEnumerator];
	while(id<LQPlugin> plugin = [e nextObject]) {
		NSMenuItem* item = [[[NSMenuItem alloc] init] autorelease];
		[item setTitle:[plugin pluginDescription]];
		[item setAction:@selector(onSoundSchemaChanged:)];
		[item setTarget:self];
		[menu addItem:item];
		
		index++;
		if([[cache baseSoundSchema] isEqualToString:[plugin pluginName]])
			selected = index;
	}
	
	// set sound schema
	[m_pbSoundSchema selectItemAtIndex:selected];
	
	// init recent contact panel
	[m_chkKeepStrangerInRecentContactList setState:[cache keepStrangerInRecentContact]];
	[m_txtMaxRecentContact setStringValue:[NSString stringWithFormat:@"%u", [cache maxRecentContact]]];
	
	// save preference, so we can undo it if user press cancel
	[cache sync];
}

#pragma mark -
#pragma mark helper

- (void)enableSoundBox:(BOOL)enable {
	[m_pbSoundType setEnabled:enable];
	[m_btnPlay setEnabled:enable];
	[m_btnBrowse setEnabled:enable];
	[m_txtSoundFile setEditable:enable];
	[m_txtSoundFile setTextColor:(enable ? [NSColor textColor] : [NSColor disabledControlTextColor])];
	[m_lblSoundFile setTextColor:(enable ? [NSColor textColor] : [NSColor disabledControlTextColor])];
	[m_lblSoundSchema setTextColor:(enable ? [NSColor textColor] : [NSColor disabledControlTextColor])];
	[m_lblSoundType setTextColor:(enable ? [NSColor textColor] : [NSColor disabledControlTextColor])];
	[m_pbSoundSchema setEnabled:enable];
}

- (NSString*)validate {
	// get preference
	PreferenceCache* cache = [PreferenceCache cache:[[m_mainWindowController me] QQ]];
	
	// duplicated hot key?
	NSString* newExMsgKey = [m_hotKeyExtractMessage string];
	NSString* newScrapKey = [m_hotKeyScreenscrap string];
	if([newExMsgKey isEqualToString:newScrapKey])
		return L(@"LQWarningDuplicatedHotKey", @"Preference");
	
	// hot key registered?	
	NSString* oldKey = [cache extractMessageHotKey];
	if(![newExMsgKey isEmpty] && ![newExMsgKey isEqualToString:oldKey]) {
		if([[HotKeyManager sharedHotKeyManager] isHotKeyRegistered:newExMsgKey owner:[[m_mainWindowController me] QQ]])
			return L(@"LQWarningConflictedExtractMessageKey", @"Preference");
	}
	oldKey = [cache screenscrapHotKey];
	if(![newScrapKey isEmpty] && ![newScrapKey isEqualToString:oldKey]) {
		if([[HotKeyManager sharedHotKeyManager] isHotKeyRegistered:newScrapKey owner:[[m_mainWindowController me] QQ]])
			return L(@"LQWarningConflictedScreenscrapKey", @"Preference");
	}
	
	return nil;
}

- (void)savePreference {
	// get preference
	PreferenceCache* cache = [PreferenceCache cache:[[m_mainWindowController me] QQ]];
	
	// save sound setting
	[cache setEnableSound:[m_chkEnableSound state]];
	int schema = [m_pbSoundSchema indexOfSelectedItem];
	if(schema == 0)
		[cache setBaseSoundSchema:@""];
	else
		[cache setBaseSoundSchema:[[[m_mainWindowController pluginManager] soundPluginAtIndex:(schema - 1)] pluginName]];
	for(int i = kSoundIdUserMessage; i <= kSoundIdMessageBlocked; i++) {
		NSString* file = [m_soundFiles objectForKey:[NSNumber numberWithInt:i]];
		if(file) {
			switch(i) {
				case kSoundIdUserMessage:
					[cache setUserMessageSoundFile:file];
					break;
				case kSoundIdClusterMessage:
					[cache setClusterMessageSoundFile:file];
					break;
				case kSoundIdMobileMessage:
					[cache setMobileMessageSoundFile:file];
					break;
				case kSoundIdSystemMessage:
					[cache setSystemMessageSoundFile:file];
					break;
				case kSoundIdGoodSystemMessage:
					[cache setGoodSystemMessageSoundFile:file];
					break;
				case kSoundIdBadSystemMessage:
					[cache setBadSystemMessageSoundFile:file];
					break;
				case kSoundIdUserOnline:
					[cache setUserOnlineSoundFile:file];
					break;
				case kSoundIdLogin:
					[cache setLoginSoundFile:file];
					break;
				case kSoundIdLogout:
					[cache setLogoutSoundFile:file];
					break;
				case kSoundIdKickedOut:
					[cache setKickedOutSoundFile:file];
					break;
				case kSoundIdMessageBlocked:
					[cache setMessageBlockedSoundFile:file];
					break;
			}
		}
	}
	
	// save window setting
	NSEnumerator* e = [[m_mxWindow cells] objectEnumerator];
	while(NSCell* cell = [e nextObject]) {
		switch([cell tag]) {
			case _kTagAlwaysOnTop:
				[cache setAlwaysOnTop:[cell state]];
				[[m_mainWindowController window] setLevel:([cache alwaysOnTop] ? NSScreenSaverWindowLevel : NSNormalWindowLevel)];
				break;
			case _kTagAutoEjectMessage:
				[cache setAutoEjectMessage:[cell state]];
				break;
			case _kTagAutoHideMainWindow:
				[cache setAutoHideMainWindow:[cell state]];
				break;
			case _kTagUseTabStyleIMWindow:
				[cache setUseTabStyleIMWindow:[cell state]];
				break;
			case _kTagHideMainWindowWhenClose:
				[cache setHideOnClose:[cell state]];
				break;
			case _kTagDisableOutlineTooltip:
				[cache setDisableOutlineTooltip:[cell state]];
				break;
		}
	}
	
	// save overall setting
	e = [[m_mxOverall cells] objectEnumerator];
	while(NSCell* cell = [e nextObject]) {
		switch([cell tag]) {
			case _kTagRejectStrangerMessage:
				[cache setRejectStrangerMessage:[cell state]];
				break;
			case _kTagDisableUserOnlineTip:
				[cache enableUserOnlineTip:![cell state]];
				break;
			case _kTagDisplayUnreadCountOnDock:
				[cache setDisplayUnreadCountOnDock:[cell state]];
				break;
			case _kTagJumpIconWhenReceivedIM:
				[cache setJumpIconWhenReceivedIM:[cell state]];
				break;
			case _kTagDisableDockIconAnimation:
				[cache setDisableDockIconAnimation:[cell state]];
				break;
		}
	}
	
	// save friend group setting
	[cache setUploadFriendGroupMode:[m_mxUpload selectedTag]];
	
	// save recent contact setting
	[cache setKeepStrangerInRecentContact:[m_chkKeepStrangerInRecentContactList state]];
	[cache setMaxRecentContact:[[m_txtMaxRecentContact stringValue] intValue]];
	
	// remove old key and register new key
	NSString* oldKey = [cache extractMessageHotKey];
	[cache setExtractMessageHotKey:[m_hotKeyExtractMessage string]];
	[[HotKeyManager sharedHotKeyManager] unregisterHotKeyByString:oldKey owner:[[m_mainWindowController me] QQ]];
	[m_mainWindowController registerExtractMessageHotKey];
	
	oldKey = [cache screenscrapHotKey];
	[cache setScreenscrapHotKey:[m_hotKeyScreenscrap string]];
	[[HotKeyManager sharedHotKeyManager] unregisterHotKeyByString:oldKey owner:[[m_mainWindowController me] QQ]];
	[m_mainWindowController registerScreenscrapHotKey];
}

- (void)setupToolbar {
	[self addView:m_basicView label:L(@"LQBasic", @"Preference") image:[NSImage imageNamed:kImageBasic]];
	[self addView:m_hotKeyView label:L(@"LQHotKey", @"Preference") image:[NSImage imageNamed:kImageHotKey]];
	[self addView:m_soundView label:L(@"LQSound", @"Preference") image:[NSImage imageNamed:kImageSound]];
	[self addView:m_recentContactView label:L(@"LQRecentContact", @"Preference") image:[NSImage imageNamed:kImageRecentContact]];
}

#pragma mark -
#pragma mark actions

- (IBAction)onEnableSound:(id)sender {
	[self enableSoundBox:[m_chkEnableSound state]];
}

- (IBAction)onSoundSchemaChanged:(id)sender {
	// get plugin
	int schema = [m_pbSoundSchema indexOfSelectedItem];
	id<SoundSchemaPlugin> plugin = schema > 0 ? [[m_mainWindowController pluginManager] soundPluginAtIndex:(schema - 1)] : nil;
	if(plugin) {
		[m_soundFiles removeAllObjects];
		for(int i = kSoundIdUserMessage; i <= kSoundIdMessageBlocked; i++)
			[m_soundFiles setObject:[plugin soundPath:i] forKey:[NSNumber numberWithInt:i]];
		[self onSoundTypeChanged:m_pbSoundType];
	} 
}

- (IBAction)onSoundTypeChanged:(id)sender {
	// get preference
	PreferenceCache* cache = [PreferenceCache cache:[[m_mainWindowController me] QQ]];
	
	NSString* file = [m_soundFiles objectForKey:[NSNumber numberWithInt:[[m_pbSoundType selectedItem] tag]]];
	if(file)
		[m_txtSoundFile setString:file];
	else {
		switch([[m_pbSoundType selectedItem] tag]) {
			case kSoundIdUserMessage:
				[m_txtSoundFile setString:[cache userMessageSoundFile]];
				break;
			case kSoundIdClusterMessage:
				[m_txtSoundFile setString:[cache clusterMessageSoundFile]];
				break;
			case kSoundIdMobileMessage:
				[m_txtSoundFile setString:[cache mobileMessageSoundFile]];
				break;
			case kSoundIdSystemMessage:
				[m_txtSoundFile setString:[cache systemMessageSoundFile]];
				break;
			case kSoundIdGoodSystemMessage:
				[m_txtSoundFile setString:[cache goodSystemMessageSoundFile]];
				break;
			case kSoundIdBadSystemMessage:
				[m_txtSoundFile setString:[cache badSystemMessageSoundFile]];
				break;
			case kSoundIdUserOnline:
				[m_txtSoundFile setString:[cache userOnlineSoundFile]];
				break;
			case kSoundIdLogin:
				[m_txtSoundFile setString:[cache loginSoundFile]];
				break;
			case kSoundIdLogout:
				[m_txtSoundFile setString:[cache logoutSoundFile]];
				break;
			case kSoundIdKickedOut:
				[m_txtSoundFile setString:[cache kickedOutSoundFile]];
				break;
			case kSoundIdMessageBlocked:
				[m_txtSoundFile setString:[cache messageBlockedSoundFile]];
				break;
		}
	}
}

- (IBAction)onOK:(id)sender {
	// validate
	NSString* error = [self validate];
	if(error) {
		[AlertTool showWarning:[self window] message:error];
	} else {
		[self savePreference];
		[self close];
	}
}

- (IBAction)onCancel:(id)sender {
	[self close];
}

- (IBAction)onBrowse:(id)sender {
	// get container path
	NSString* file = [m_txtSoundFile string];
	file = [file stringByDeletingLastPathComponent];
	if([file isEmpty]) {
		file = @"~";
		file = [file stringByExpandingTildeInPath];
	}
	
	// open open file panel
	NSOpenPanel* panel = [NSOpenPanel openPanel];
	[panel setCanChooseDirectories:NO];
	[panel setAllowsMultipleSelection:NO];
	[panel beginSheetForDirectory:file
							 file:nil
				   modalForWindow:[self window]
					modalDelegate:self
				   didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
					  contextInfo:nil];
}

- (IBAction)onPlay:(id)sender {
	NSSound* sound = [[[NSSound alloc] initWithContentsOfFile:[m_txtSoundFile string] byReference:YES] autorelease];
	[sound play];
}

#pragma mark -
#pragma mark text field delegate

- (void)textDidChange:(NSNotification *)aNotification {
	id control = [aNotification object];
	if(control == m_txtSoundFile)
		[m_soundFiles setObject:[m_txtSoundFile string] forKey:[NSNumber numberWithInt:[[m_pbSoundType selectedItem] tag]]];		
}

#pragma mark -
#pragma mark open panel delegate

- (void)openPanelDidEnd:(NSOpenPanel*)panel returnCode:(int)returnCode contextInfo:(void*)contextInfo {
	if(returnCode = NSOKButton) {
		[m_txtSoundFile setString:[panel filename]];
		[m_soundFiles setObject:[panel filename] forKey:[NSNumber numberWithInt:[[m_pbSoundType selectedItem] tag]]];
	}
}

@end
