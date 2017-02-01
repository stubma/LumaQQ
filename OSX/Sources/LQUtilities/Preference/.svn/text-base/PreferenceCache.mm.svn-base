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


#import "PreferenceCache.h"
#import "PreferenceConstants.h"
#import "PreferenceManager.h"
#import "KeyTool.h"
#import "Constants.h"

static NSMutableDictionary* caches = nil;

@implementation PreferenceCache

+ (void)initialize {
	caches = [[NSMutableDictionary dictionary] retain];
}

+ (PreferenceCache*)cache:(UInt32)QQ {
	PreferenceCache* cache = [caches objectForKey:[NSNumber numberWithUnsignedInt:QQ]];
	if(!cache)
		cache = [[PreferenceCache alloc] initWithQQ:QQ];
	return cache;
}

- (id)initWithQQ:(UInt32)QQ {
	self = [super init];
	if (self) {		
		m_QQ = QQ;
		m_dirty = NO;
		
		// default value
		m_windowFrame = NSMakeRect(0, 0, 0, 0);
		m_showLargeUserHead = YES;
		m_showClusterNameCard = YES;
		m_showRealName = YES;
		m_showNickName = YES;
		m_showLevel = YES;
		m_showSignature = YES;
		m_showUserProperty = YES;
		m_showStatusMessage = YES;
		m_showOnlineOnly = NO;
		m_alternatingRowBackground = NO;
		m_showHorizontalLine = NO;
		m_backgroundRed = 1.0;
		m_backgroundGreen = 1.0;
		m_backgroundBlue = 1.0;
		m_chatFontColorRed = 0.0;
		m_chatFontColorGreen = 0.0;
		m_chatFontColorBlue = 0.0;
		m_chatFontSize = [NSFont systemFontSize];
		m_chatFontStyleBold = NO;
		m_chatFontStyleItalic = NO;
		m_chatFontStyleUnderline = NO;
		m_chatFontName = @"Helvetica";
		m_showTabStyleIMWindow = NO;
		m_nickFontName = @"Lucida Grande";
		m_nickFontSize = [NSFont systemFontSize];
		m_nickFontStyleBold = NO;
		m_nickFontStyleItalic = NO;
		m_nickFontColorRed = 0.0;
		m_nickFontColorGreen = 0.0;
		m_nickFontColorBlue = 0.0;
		m_signatureFontName = @"Lucida Grande";
		m_signatureFontSize = [NSFont systemFontSize];
		m_signatureFontStyleBold = NO;
		m_signatureFontStyleItalic = NO;
		m_signatureFontColorRed = 0.5;
		m_signatureFontColorGreen = 0.5;
		m_signatureFontColorBlue = 0.5;
		m_hideToolbar = NO;
		m_disableDockIconAnimation = NO;
		m_showFakeCamera = NO;
		m_disableOutlineTooltip = NO;
		
		m_newLineKey = [[KeyTool key2String:NSCommandKeyMask character:NSCarriageReturnCharacter] retain];
		m_closeKey = [[KeyTool key2String:NSAlternateKeyMask character:'C'] retain];
		m_historyKey = [[KeyTool key2String:NSAlternateKeyMask character:'H'] retain];
		m_switchTabKey = [[KeyTool key2String:NSAlternateKeyMask character:'Q'] retain];
		m_sendKey = [[KeyTool key2String:0 character:NSCarriageReturnCharacter] retain];
		
		m_extractMessageHotKey = [[KeyTool key2String:(NSCommandKeyMask | NSControlKeyMask) character:'Z'] retain];
		m_screenscrapHotKey = [[KeyTool key2String:(NSCommandKeyMask | NSControlKeyMask) character:'A'] retain];
		
		m_enableSound = YES;
		m_baseSoundSchema = kStringEmpty;
		m_userMessageSoundFile = m_clusterMessageSoundFile = m_mobileMessageSoundFile = m_systemMessageSoundFile =
			m_badSystemMessageSoundFile = m_goodSystemMessageSoundFile = m_loginSoundFile = m_logoutSoundFile =
			m_kickedOutSoundFile = m_userOnlineSoundFile = m_messageBlockedSoundFile = kStringEmpty;
		
		m_alwaysOnTop = NO;
		m_autoEjectMessage = NO;
		m_autoHideMainWindow = NO;
		m_useTabStyleIMWindow = NO;
		m_disableUserOnlineTip = YES;
		m_hideOnClose = YES;
		m_rejectStrangerMessage = NO;
		m_displayUnreadCountOnDock = YES;
		m_jumpIconWhenReceivedIM = YES;
		m_uploadFriendGroupMode = kLQUploadAsk;
		m_statusMessage = kStringEmpty;
		m_statusHistory = [[NSMutableArray array] retain];
		
		m_keepStrangerInRecentContact = YES;
		m_maxRecentContact = 20;
		
		m_activeQBarName = kStringEmpty;
		
		// reload
		[self reload];
		
		// cache it
		[caches setObject:self forKey:[NSNumber numberWithUnsignedInt:QQ]];
	}
	return self;
}

- (void) dealloc {
	if(m_dirty)
		[self sync];
	[m_chatFontName release];
	[m_nickFontName release];
	[m_signatureFontName release];
	[m_newLineKey release];
	[m_closeKey release];
	[m_historyKey release];
	[m_switchTabKey release];
	[m_sendKey release];
	[m_extractMessageHotKey release];
	[m_userMessageSoundFile release];
	[m_clusterMessageSoundFile release];
	[m_mobileMessageSoundFile release];
	[m_systemMessageSoundFile release];
	[m_userOnlineSoundFile release];
	[m_activeQBarName release];
	[m_statusMessage release];
	[m_statusHistory release];
	[super dealloc];
}

- (void)reload {	
	// load system preference
	if([PreferenceManager isPerferenceExist:m_QQ file:kLQFileSystem]) {
		PreferenceManager* prefSystem = [PreferenceManager managerWithQQ:m_QQ file:kLQFileSystem];
		m_showLargeUserHead = [prefSystem boolForKey:kLQUIShowLargeUserHead];
		m_showClusterNameCard = [prefSystem boolForKey:kLQUIShowClusterNameCard];
		m_showRealName = [prefSystem boolForKey:kLQUIShowRealName];
		m_showNickName = [prefSystem boolForKey:kLQUIShowNickName];
		m_showLevel = [prefSystem boolForKey:kLQUIShowLevel];
		m_showOnlineOnly = [prefSystem boolForKey:kLQUIShowOnlineOnly];
		m_showSignature = [prefSystem boolForKey:kLQUIShowSignature];
		m_showUserProperty = [prefSystem boolForKey:kLQUIShowUserProperty];
		m_showStatusMessage = [prefSystem boolForKey:kLQUIShowStatusMessage];
		m_alternatingRowBackground = [prefSystem boolForKey:kLQUIAlternatingRowBackground];
		m_showHorizontalLine = [prefSystem boolForKey:kLQUIShowHorizontalLine];
		m_windowFrame.origin.x = [prefSystem integerForKey:kLQUIWindowX];
		m_windowFrame.origin.y = [prefSystem integerForKey:kLQUIWindowY];
		m_windowFrame.size.width = [prefSystem integerForKey:kLQUIWindowWidth];
		m_windowFrame.size.height = [prefSystem integerForKey:kLQUIWindowHeight];
		m_backgroundRed = [prefSystem floatForKey:kLQUIBackgroundRed];
		m_backgroundGreen = [prefSystem floatForKey:kLQUIBackgroundGreen];
		m_backgroundBlue = [prefSystem floatForKey:kLQUIBackgroundBlue];
		m_chatFontColorRed = [prefSystem floatForKey:kLQUIChatFontColorRed];
		m_chatFontColorGreen = [prefSystem floatForKey:kLQUIChatFontColorGreen];
		m_chatFontColorBlue = [prefSystem floatForKey:kLQUIChatFontColorBlue];
		m_chatFontStyleBold = [prefSystem boolForKey:kLQUIChatFontStyleBold];
		m_chatFontStyleItalic = [prefSystem boolForKey:kLQUIChatFontStyleItalic];
		m_chatFontStyleUnderline = [prefSystem boolForKey:kLQUIChatFontStyleUnderline];
		m_chatFontSize = [prefSystem integerForKey:kLQUIChatFontSize];
		m_nickFontColorRed = [prefSystem floatForKey:kLQUINickFontColorRed];
		m_nickFontColorGreen = [prefSystem floatForKey:kLQUINickFontColorGreen];
		m_nickFontColorBlue = [prefSystem floatForKey:kLQUINickFontColorBlue];
		m_nickFontStyleBold = [prefSystem boolForKey:kLQUINickFontStyleBold];
		m_nickFontStyleItalic = [prefSystem boolForKey:kLQUINickFontStyleItalic];
		m_nickFontSize = [prefSystem integerForKey:kLQUINickFontSize];
		m_signatureFontColorRed = [prefSystem floatForKey:kLQUISignatureFontColorRed];
		m_signatureFontColorGreen = [prefSystem floatForKey:kLQUISignatureFontColorGreen];
		m_signatureFontColorBlue = [prefSystem floatForKey:kLQUISignatureFontColorBlue];	
		m_signatureFontStyleBold = [prefSystem boolForKey:kLQUISignatureFontStyleBold];
		m_signatureFontStyleItalic = [prefSystem boolForKey:kLQUISignatureFontStyleItalic];
		m_signatureFontSize = [prefSystem integerForKey:kLQUISignatureFontSize];
		m_hideToolbar = [prefSystem boolForKey:kLQUIHideToolbar];
		m_disableDockIconAnimation = [prefSystem boolForKey:kLQUIDisableDockIconAnimation];
		m_showFakeCamera = [prefSystem boolForKey:kLQUIShowFakeCamera];
		m_disableOutlineTooltip = [prefSystem boolForKey:kLQUIDisableOutlineTooltip];
		NSString* s = [prefSystem stringForKey:kLQUIChatFontName];
		if(s)
			[self setChatFontName:s];
		s = [prefSystem stringForKey:kLQUINickFontName];
		if(s)
			[self setNickFontName:s];
		s = [prefSystem stringForKey:kLQUISignatureFontName];
		if(s)
			[self setSignatureFontName:s];
		m_showTabStyleIMWindow = [prefSystem boolForKey:kLQUIShowTabStyleIMWindow];
		s = [prefSystem stringForKey:kLQKeyNewLine];
		if(s)
			[self setNewLineKey:s];
		s = [prefSystem stringForKey:kLQKeyClose];
		if(s)
			[self setCloseKey:s];
		s = [prefSystem stringForKey:kLQKeyHistory];
		if(s)
			[self setHistoryKey:s];
		s = [prefSystem stringForKey:kLQKeySwitchTab];
		if(s)
			[self setSwitchTabKey:s];
		s = [prefSystem stringForKey:kLQKeySend];
		if(s)
			[self setSendKey:s];
		s = [prefSystem stringForKey:kLQHotKeyExtractMessage];
		if(s)
			[self setExtractMessageHotKey:s];
		s = [prefSystem stringForKey:kLQHotKeyScreenscrap];
		if(s)
			[self setScreenscrapHotKey:s];
		
		m_enableSound = [prefSystem boolForKey:kLQSoundEnabled];
		s = [prefSystem stringForKey:kLQSoundBaseSchema];
		if(s)
			[self setBaseSoundSchema:s];
		s = [prefSystem stringForKey:kLQSoundUserMessage];
		if(s)
			[self setUserMessageSoundFile:s];
		s = [prefSystem stringForKey:kLQSoundClusterMessage];
		if(s)
			[self setClusterMessageSoundFile:s];
		s = [prefSystem stringForKey:kLQSoundMobileMessage];
		if(s)
			[self setMobileMessageSoundFile:s];
		s = [prefSystem stringForKey:kLQSoundSystemMessage];
		if(s)
			[self setSystemMessageSoundFile:s];
		s = [prefSystem stringForKey:kLQSoundUserOnline];
		if(s)
			[self setUserOnlineSoundFile:s];
		s = [prefSystem stringForKey:kLQSoundBadSystemMessage];
		if(s)
			[self setBadSystemMessageSoundFile:s];
		s = [prefSystem stringForKey:kLQSoundGoodSystemMessage];
		if(s)
			[self setGoodSystemMessageSoundFile:s];
		s = [prefSystem stringForKey:kLQSoundLogin];
		if(s)
			[self setLoginSoundFile:s];
		s = [prefSystem stringForKey:kLQSoundLogout];
		if(s)
			[self setLogoutSoundFile:s];
		s = [prefSystem stringForKey:kLQSoundKickedOut];
		if(s)
			[self setKickedOutSoundFile:s];
		s = [prefSystem stringForKey:kLQSoundMessageBlocked];
		if(s)
			[self setMessageBlockedSoundFile:s];
		
		m_alwaysOnTop = [prefSystem boolForKey:kLQBasicAlwaysOnTop];
		m_autoEjectMessage = [prefSystem boolForKey:kLQBasicAutoEjectMessage];
		m_autoHideMainWindow = [prefSystem boolForKey:kLQBasicAutoHideMainWindow];
		m_useTabStyleIMWindow = [prefSystem boolForKey:kLQBasicUseTabIMStyleWindow];
		m_disableUserOnlineTip = [prefSystem boolForKey:kLQBasicDisableUserOnlineTip];
		m_hideOnClose = [prefSystem boolForKey:kLQBasicHideOnClose];
		m_rejectStrangerMessage = [prefSystem boolForKey:kLQBasicRejectStranger];
		m_displayUnreadCountOnDock = [prefSystem boolForKey:kLQBasicDisplayUnreadCountOnDock];
		m_jumpIconWhenReceivedIM = [prefSystem boolForKey:kLQBasicJumpIconWhenReceivedIM];
		m_uploadFriendGroupMode = [prefSystem integerForKey:kLQBasicUploadFriendGroup];
		s = [prefSystem stringForKey:kLQBasicStatusMessage];
		if(s)
			[self setStatusMessage:s];
		NSMutableArray* tempArray = [prefSystem objectForKey:kLQBasicStatusHistory];
		if(tempArray != m_statusHistory) {
			[self clearStatusHistory];
			[m_statusHistory addObjectsFromArray:tempArray];
		}
		
		m_keepStrangerInRecentContact = [prefSystem boolForKey:kLQRecentKeepStranger];
		int temp = [prefSystem integerForKey:kLQRecentMax];
		if(temp != 0)
			m_maxRecentContact = temp;
		
		s = [prefSystem objectForKey:kLQPluginActiveQBarName];
		if(s)
			[self setActiveQBarName:s];
	} 
}

- (void)sync {
	if(!m_dirty)
		return;
	
	// load file
	PreferenceManager* prefSystem = [PreferenceManager managerWithQQ:m_QQ file:kLQFileSystem];
	
	// initialize values
	[prefSystem setInteger:m_windowFrame.origin.x forKey:kLQUIWindowX];
	[prefSystem setInteger:m_windowFrame.origin.y forKey:kLQUIWindowY];
	[prefSystem setInteger:m_windowFrame.size.width forKey:kLQUIWindowWidth];
	[prefSystem setInteger:m_windowFrame.size.height forKey:kLQUIWindowHeight];
	[prefSystem setBool:m_showLargeUserHead forKey:kLQUIShowLargeUserHead];
	[prefSystem setBool:m_showClusterNameCard forKey:kLQUIShowClusterNameCard];
	[prefSystem setBool:m_showRealName forKey:kLQUIShowRealName];
	[prefSystem setBool:m_showNickName forKey:kLQUIShowNickName];
	[prefSystem setBool:m_showLevel forKey:kLQUIShowLevel];
	[prefSystem setBool:m_showSignature forKey:kLQUIShowSignature];
	[prefSystem setBool:m_showOnlineOnly forKey:kLQUIShowOnlineOnly];
	[prefSystem setBool:m_showUserProperty forKey:kLQUIShowUserProperty];
	[prefSystem setBool:m_showStatusMessage forKey:kLQUIShowStatusMessage];
	[prefSystem setBool:m_alternatingRowBackground forKey:kLQUIAlternatingRowBackground];
	[prefSystem setBool:m_showHorizontalLine forKey:kLQUIShowHorizontalLine];
	[prefSystem setFloat:m_backgroundRed forKey:kLQUIBackgroundRed];
	[prefSystem setFloat:m_backgroundGreen forKey:kLQUIBackgroundGreen];
	[prefSystem setFloat:m_backgroundBlue forKey:kLQUIBackgroundBlue];
	[prefSystem setFloat:m_chatFontColorRed forKey:kLQUIChatFontColorRed];
	[prefSystem setFloat:m_chatFontColorGreen forKey:kLQUIChatFontColorGreen];
	[prefSystem setFloat:m_chatFontColorBlue forKey:kLQUIChatFontColorBlue];
	[prefSystem setBool:m_chatFontStyleBold forKey:kLQUIChatFontStyleBold];
	[prefSystem setBool:m_chatFontStyleItalic forKey:kLQUIChatFontStyleItalic];
	[prefSystem setBool:m_chatFontStyleUnderline forKey:kLQUIChatFontStyleUnderline];
	[prefSystem setInteger:m_chatFontSize forKey:kLQUIChatFontSize];
	[prefSystem setObject:m_chatFontName forKey:kLQUIChatFontName];
	[prefSystem setObject:m_nickFontName forKey:kLQUINickFontName];
	[prefSystem setFloat:m_nickFontColorRed forKey:kLQUINickFontColorRed];
	[prefSystem setFloat:m_nickFontColorGreen forKey:kLQUINickFontColorGreen];
	[prefSystem setFloat:m_nickFontColorBlue forKey:kLQUINickFontColorBlue];
	[prefSystem setBool:m_nickFontStyleBold forKey:kLQUINickFontStyleBold];
	[prefSystem setBool:m_nickFontStyleItalic forKey:kLQUINickFontStyleItalic];
	[prefSystem setInteger:m_nickFontSize forKey:kLQUINickFontSize];
	[prefSystem setObject:m_signatureFontName forKey:kLQUISignatureFontName];
	[prefSystem setFloat:m_signatureFontColorRed forKey:kLQUISignatureFontColorRed];
	[prefSystem setFloat:m_signatureFontColorGreen forKey:kLQUISignatureFontColorGreen];
	[prefSystem setFloat:m_signatureFontColorBlue forKey:kLQUISignatureFontColorBlue];
	[prefSystem setBool:m_signatureFontStyleBold forKey:kLQUISignatureFontStyleBold];
	[prefSystem setBool:m_signatureFontStyleItalic forKey:kLQUISignatureFontStyleItalic];
	[prefSystem setInteger:m_signatureFontSize forKey:kLQUISignatureFontSize];
	[prefSystem setBool:m_showTabStyleIMWindow forKey:kLQUIShowTabStyleIMWindow];
	[prefSystem setBool:m_hideToolbar forKey:kLQUIHideToolbar];
	[prefSystem setBool:m_disableDockIconAnimation forKey:kLQUIDisableDockIconAnimation];
	[prefSystem setBool:m_showFakeCamera forKey:kLQUIShowFakeCamera];
	[prefSystem setBool:m_disableOutlineTooltip forKey:kLQUIDisableOutlineTooltip];
	
	[prefSystem setObject:m_newLineKey forKey:kLQKeyNewLine];
	[prefSystem setObject:m_closeKey forKey:kLQKeyClose];
	[prefSystem setObject:m_historyKey forKey:kLQKeyHistory];
	[prefSystem setObject:m_switchTabKey forKey:kLQKeySwitchTab];
	[prefSystem setObject:m_sendKey forKey:kLQKeySend];
	
	[prefSystem setObject:m_extractMessageHotKey forKey:kLQHotKeyExtractMessage];
	[prefSystem setObject:m_screenscrapHotKey forKey:kLQHotKeyScreenscrap];
	
	[prefSystem setBool:m_enableSound forKey:kLQSoundEnabled];
	[prefSystem setObject:m_baseSoundSchema forKey:kLQSoundBaseSchema];
	[prefSystem setObject:m_userMessageSoundFile forKey:kLQSoundUserMessage];
	[prefSystem setObject:m_clusterMessageSoundFile forKey:kLQSoundClusterMessage];
	[prefSystem setObject:m_mobileMessageSoundFile forKey:kLQSoundMobileMessage];
	[prefSystem setObject:m_systemMessageSoundFile forKey:kLQSoundSystemMessage];
	[prefSystem setObject:m_userOnlineSoundFile forKey:kLQSoundUserOnline];
	[prefSystem setObject:m_badSystemMessageSoundFile forKey:kLQSoundBadSystemMessage];
	[prefSystem setObject:m_goodSystemMessageSoundFile forKey:kLQSoundGoodSystemMessage];
	[prefSystem setObject:m_loginSoundFile forKey:kLQSoundLogin];
	[prefSystem setObject:m_logoutSoundFile forKey:kLQSoundLogout];
	[prefSystem setObject:m_kickedOutSoundFile forKey:kLQSoundKickedOut];
	[prefSystem setObject:m_messageBlockedSoundFile forKey:kLQSoundMessageBlocked];
	
	[prefSystem setBool:m_alwaysOnTop forKey:kLQBasicAlwaysOnTop];
	[prefSystem setBool:m_autoEjectMessage forKey:kLQBasicAutoEjectMessage];
	[prefSystem setBool:m_autoHideMainWindow forKey:kLQBasicAutoHideMainWindow];
	[prefSystem setBool:m_useTabStyleIMWindow forKey:kLQBasicUseTabIMStyleWindow];
	[prefSystem setBool:m_disableUserOnlineTip forKey:kLQBasicDisableUserOnlineTip];
	[prefSystem setBool:m_hideOnClose forKey:kLQBasicHideOnClose];
	[prefSystem setBool:m_rejectStrangerMessage forKey:kLQBasicRejectStranger];
	[prefSystem setBool:m_displayUnreadCountOnDock forKey:kLQBasicDisplayUnreadCountOnDock];
	[prefSystem setBool:m_jumpIconWhenReceivedIM forKey:kLQBasicJumpIconWhenReceivedIM];
	[prefSystem setInteger:m_uploadFriendGroupMode forKey:kLQBasicUploadFriendGroup];
	[prefSystem setObject:m_statusMessage forKey:kLQBasicStatusMessage];
	[prefSystem setObject:m_statusHistory forKey:kLQBasicStatusHistory];
	
	[prefSystem setBool:m_keepStrangerInRecentContact forKey:kLQRecentKeepStranger];
	[prefSystem setInteger:m_maxRecentContact forKey:kLQRecentMax];
	
	[prefSystem setObject:m_activeQBarName forKey:kLQPluginActiveQBarName];
	
	// save to disk
	[prefSystem sync];
	
	m_dirty = NO;
}

- (BOOL)dirty {
	return m_dirty;
}

#pragma mark -
#pragma mark getter and setter

- (BOOL)showLargeUserHead {
	return m_showLargeUserHead;
}

- (void)setShowLargeUserHead:(BOOL)flag {
	m_showLargeUserHead = flag;
	m_dirty = YES;
}

- (BOOL)showClusterNameCard {
	return m_showClusterNameCard;
}

- (void)setShowClusterNameCard:(BOOL)flag {
	m_showClusterNameCard = flag;
	m_dirty = YES;
}

- (BOOL)showRealName {
	return m_showRealName;
}

- (void)setShowRealName:(BOOL)showRealName {
	m_showRealName = showRealName;
	m_dirty = YES;
}

- (NSRect)windowFrame {
	return m_windowFrame;
}

- (void)setWnidowFrame:(NSRect)frame {
	m_windowFrame = frame;
	m_dirty = YES;
}

- (BOOL)showNickName {
	return m_showNickName;
}

- (void)setShowNickName:(BOOL)showNickName {
	m_showNickName = showNickName;
	m_dirty = YES;
}

- (BOOL)showLevel {
	return m_showLevel;
}

- (void)setShowLevel:(BOOL)showLevel {
	m_showLevel = showLevel;
	m_dirty = YES;
}

- (BOOL)showOnlineOnly {
	return m_showOnlineOnly;
}

- (void)setShowOnlineOnly:(BOOL)showOnlineOnly {
	m_showOnlineOnly = showOnlineOnly;
	m_dirty = YES;
}

- (BOOL)showSignature {
	return m_showSignature;
}

- (void)setShowSignature:(BOOL)showSignature {
	m_showSignature = showSignature;
	m_dirty = YES;
}

- (BOOL)showUserProperty {
	return m_showUserProperty;
}

- (void)setShowUserProperty:(BOOL)showUserProperty {
	m_showUserProperty = showUserProperty;
	m_dirty = YES;
}

- (BOOL)showStatusMessage {
	return m_showStatusMessage;
}

- (void)setShowStatusMessage:(BOOL)showStatusMessage {
	m_showStatusMessage = showStatusMessage;
}

- (BOOL)showHorizontalLine {
	return m_showHorizontalLine;
}

- (void)setShowHorizontalLine:(BOOL)showHorizontalLine {
	m_showHorizontalLine = showHorizontalLine;
	m_dirty = YES;
}

- (BOOL)alternatingRowBackground {
	return m_alternatingRowBackground;
}

- (void)setAlternatingRowBackground:(BOOL)alternatingRowBackground {
	m_alternatingRowBackground = alternatingRowBackground;
	m_dirty = YES;
}

- (NSColor*)background {
	return [NSColor colorWithCalibratedRed:m_backgroundRed
									 green:m_backgroundGreen
									  blue:m_backgroundBlue
									 alpha:1.0];
}

- (void)setBackground:(NSColor*)background {
	[background getRed:&m_backgroundRed
				 green:&m_backgroundGreen
				  blue:&m_backgroundBlue
				 alpha:NULL];
	m_dirty = YES;
}

- (NSColor*)chatFontColor {
	return [NSColor colorWithCalibratedRed:m_chatFontColorRed
									 green:m_chatFontColorGreen
									  blue:m_chatFontColorBlue
									 alpha:1.0];
}

- (void)setChatFontColor:(NSColor*)color {
	[color getRed:&m_chatFontColorRed
			green:&m_chatFontColorGreen
			 blue:&m_chatFontColorBlue
			alpha:NULL];
	m_dirty = YES;
}

- (NSString*)chatFontName {
	return m_chatFontName;
}

- (void)setChatFontName:(NSString*)name {
	[name retain];
	[m_chatFontName release];
	m_chatFontName = name;
	m_dirty = YES;
}

- (BOOL)chatFontStyleBold {
	return m_chatFontStyleBold;
}

- (void)setChatFontStyleBold:(BOOL)flag {
	m_chatFontStyleBold = flag;
	m_dirty = YES;
}

- (BOOL)chatFontStyleItalic {
	return m_chatFontStyleItalic;
}

- (void)setChatFontStyleItalic:(BOOL)flag {
	m_chatFontStyleItalic = flag;
	m_dirty = YES;
}

- (BOOL)chatFontStyleUnderline {
	return m_chatFontStyleUnderline;
}

- (void)setChatFontStyleUnderline:(BOOL)flag {
	m_chatFontStyleUnderline = flag;
	m_dirty = YES;
}

- (UInt32)chatFontSize {
	return m_chatFontSize;
}

- (void)setChatFontSize:(UInt32)size {
	m_chatFontSize = size;
	m_dirty = YES;
}

- (NSColor*)nickFontColor {
	return [NSColor colorWithCalibratedRed:m_nickFontColorRed
									 green:m_nickFontColorGreen
									  blue:m_nickFontColorBlue
									 alpha:1.0];
}

- (void)setNickFontColor:(NSColor*)color {
	[color getRed:&m_nickFontColorRed
			green:&m_nickFontColorGreen
			 blue:&m_nickFontColorBlue
			alpha:NULL];
	m_dirty = YES;
}

- (NSString*)nickFontName {
	return m_nickFontName;
}

- (void)setNickFontName:(NSString*)name {
	[name retain];
	[m_nickFontName release];
	m_nickFontName = name;
	m_dirty = YES;
}

- (BOOL)nickFontStyleBold {
	return m_nickFontStyleBold;
}

- (void)setNickFontStyleBold:(BOOL)flag {
	m_nickFontStyleBold = flag;
	m_dirty = YES;
}

- (BOOL)nickFontStyleItalic {
	return m_nickFontStyleItalic;
}

- (void)setNickFontStyleItalic:(BOOL)flag {
	m_nickFontStyleItalic = flag;
	m_dirty = YES;
}

- (UInt32)nickFontSize {
	return m_nickFontSize;
}

- (void)setNickFontSize:(UInt32)size {
	m_nickFontSize = size;
	m_dirty = YES;
}

- (NSColor*)signatureFontColor {
	return [NSColor colorWithCalibratedRed:m_signatureFontColorRed
									 green:m_signatureFontColorGreen
									  blue:m_signatureFontColorBlue
									 alpha:1.0];
}

- (void)setSignatureFontColor:(NSColor*)color {
	[color getRed:&m_signatureFontColorRed
			green:&m_signatureFontColorGreen
			 blue:&m_signatureFontColorBlue
			alpha:NULL];
	m_dirty = YES;
}

- (NSString*)signatureFontName {
	return m_signatureFontName;
}

- (void)setSignatureFontName:(NSString*)name {
	[name retain];
	[m_signatureFontName release];
	m_signatureFontName = name;
	m_dirty = YES;
}

- (BOOL)signatureFontStyleBold {
	return m_signatureFontStyleBold;
}

- (void)setSignatureFontStyleBold:(BOOL)flag {
	m_signatureFontStyleBold = flag;
	m_dirty = YES;
}

- (BOOL)signatureFontStyleItalic {
	return m_signatureFontStyleItalic;
}

- (void)setSignatureFontStyleItalic:(BOOL)flag {
	m_signatureFontStyleItalic = flag;
	m_dirty = YES;
}

- (UInt32)signatureFontSize {
	return m_signatureFontSize;
}

- (void)setSignatureFontSize:(UInt32)size {
	m_signatureFontSize = size;
	m_dirty = YES;
}

- (BOOL)showTabStyleIMWindow {
	return m_showTabStyleIMWindow;
}

- (void)setShowTabStyleIMWindow:(BOOL)flag {
	m_showTabStyleIMWindow = flag;
}

- (NSString*)newLineKey {
	return m_newLineKey;
}

- (void)setNewLineKey:(NSString*)key {
	[key retain];
	[m_newLineKey release];
	m_newLineKey = key;
	m_dirty = YES;
}

- (NSString*)closeKey {
	return m_closeKey;
}

- (void)setCloseKey:(NSString*)key {
	[key retain];
	[m_closeKey release];
	m_closeKey = key;
	m_dirty = YES;
}

- (NSString*)historyKey {
	return m_historyKey;
}

- (void)setHistoryKey:(NSString*)key {
	[key retain];
	[m_historyKey release];
	m_historyKey = key;
	m_dirty = YES;
}

- (NSString*)switchTabKey {
	return m_switchTabKey;
}

- (void)setSwitchTabKey:(NSString*)key {
	[key retain];
	[m_switchTabKey release];
	m_switchTabKey = key;
	m_dirty = YES;
}

- (NSString*)sendKey {
	return m_sendKey;
}

- (void)setSendKey:(NSString*)key {
	[key retain];
	[m_sendKey release];
	m_sendKey = key;
	m_dirty = YES;
}

- (NSString*)extractMessageHotKey {
	return m_extractMessageHotKey;
}

- (void)setExtractMessageHotKey:(NSString*)key {
	[key retain];
	[m_extractMessageHotKey release];
	m_extractMessageHotKey = key;
	m_dirty = YES;
}

- (NSString*)screenscrapHotKey {
	return m_screenscrapHotKey;
}

- (void)setScreenscrapHotKey:(NSString*)key {
	[key retain];
	[m_screenscrapHotKey release];
	m_screenscrapHotKey = key;
	m_dirty = YES;
}

- (BOOL)isEnableSound {
	return m_enableSound;
}

- (void)setEnableSound:(BOOL)enable {
	m_enableSound = enable;
	m_dirty = YES;
}

- (NSString*)baseSoundSchema {
	return m_baseSoundSchema;
}

- (void)setBaseSoundSchema:(NSString*)schema {
	[schema retain];
	[m_baseSoundSchema release];
	m_baseSoundSchema = schema;
	m_dirty = YES;
}

- (NSString*)userMessageSoundFile {
	return m_userMessageSoundFile;
}

- (void)setUserMessageSoundFile:(NSString*)file {
	[file retain];
	[m_userMessageSoundFile release];
	m_userMessageSoundFile = file;
	m_dirty = YES;
}

- (NSString*)clusterMessageSoundFile {
	return m_clusterMessageSoundFile;
}

- (void)setClusterMessageSoundFile:(NSString*)file {
	[file retain];
	[m_clusterMessageSoundFile release];
	m_clusterMessageSoundFile = file;
	m_dirty = YES;
}

- (NSString*)mobileMessageSoundFile {
	return m_mobileMessageSoundFile;
}

- (void)setMobileMessageSoundFile:(NSString*)file {
	[file retain];
	[m_mobileMessageSoundFile release];
	m_mobileMessageSoundFile = file;
	m_dirty = YES;
}

- (NSString*)systemMessageSoundFile {
	return m_systemMessageSoundFile;
}

- (void)setSystemMessageSoundFile:(NSString*)file {
	[file retain];
	[m_systemMessageSoundFile release];
	m_systemMessageSoundFile = file;
	m_dirty = YES;
}

- (NSString*)userOnlineSoundFile {
	return m_userOnlineSoundFile;
}

- (void)setUserOnlineSoundFile:(NSString*)file {
	[file retain];
	[m_userOnlineSoundFile release];
	m_userOnlineSoundFile = file;
	m_dirty = YES;
}

- (NSString*)badSystemMessageSoundFile {
	return m_badSystemMessageSoundFile;
}

- (void)setBadSystemMessageSoundFile:(NSString*)file {
	[file retain];
	[m_badSystemMessageSoundFile release];
	m_badSystemMessageSoundFile = file;
	m_dirty = YES;
}

- (NSString*)goodSystemMessageSoundFile {
	return m_goodSystemMessageSoundFile;
}

- (void)setGoodSystemMessageSoundFile:(NSString*)file {
	[file retain];
	[m_goodSystemMessageSoundFile release];
	m_goodSystemMessageSoundFile = file;
	m_dirty = YES;
}

- (NSString*)loginSoundFile {
	return m_loginSoundFile;
}

- (void)setLoginSoundFile:(NSString*)file {
	[file retain];
	[m_loginSoundFile release];
	m_loginSoundFile = file;
	m_dirty = YES;
}

- (NSString*)logoutSoundFile {
	return m_logoutSoundFile;
}

- (void)setLogoutSoundFile:(NSString*)file {
	[file retain];
	[m_logoutSoundFile release];
	m_logoutSoundFile = file;
	m_dirty = YES;
}

- (NSString*)messageBlockedSoundFile {
	return m_messageBlockedSoundFile;
}

- (void)setMessageBlockedSoundFile:(NSString*)file {
	[file retain];
	[m_messageBlockedSoundFile release];
	m_messageBlockedSoundFile = file;
	m_dirty = YES;
}

- (NSString*)kickedOutSoundFile {
	return m_kickedOutSoundFile;
}

- (void)setKickedOutSoundFile:(NSString*)file {
	[file retain];
	[m_kickedOutSoundFile release];
	m_kickedOutSoundFile = file;
	m_dirty = YES;
}

- (BOOL)alwaysOnTop {
	return m_alwaysOnTop;
}

- (void)setAlwaysOnTop:(BOOL)flag {
	m_alwaysOnTop = flag;
	m_dirty = YES;
}

- (BOOL)autoEjectMessage {
	return m_autoEjectMessage;
}

- (void)setAutoEjectMessage:(BOOL)flag {
	m_autoEjectMessage = flag;
	m_dirty = YES;
}

- (BOOL)autoHideMainWindow {
	return m_autoHideMainWindow;
}

- (void)setAutoHideMainWindow:(BOOL)flag {
	m_autoHideMainWindow = flag;
	m_dirty = YES;
}

- (BOOL)useTabStyleIMWindow {
	return m_useTabStyleIMWindow;
}

- (void)setUseTabStyleIMWindow:(BOOL)flag {
	m_useTabStyleIMWindow = flag;
	m_dirty = YES;
}

- (BOOL)isUserOnlineTipEnabled {
	return !m_disableUserOnlineTip;
}

- (void)enableUserOnlineTip:(BOOL)flag {
	m_disableUserOnlineTip = !flag;
	m_dirty = YES;
}

- (BOOL)rejectStrangerMessage {
	return m_rejectStrangerMessage;
}

- (void)setRejectStrangerMessage:(BOOL)flag {
	m_rejectStrangerMessage = flag;
	m_dirty = YES;
}

- (BOOL)hideOnClose {
	return m_hideOnClose;
}

- (void)setHideOnClose:(BOOL)hideOnClose {
	m_hideOnClose = hideOnClose;
	m_dirty = YES;
}

- (BOOL)displayUnreadCountOnDock {
	return m_displayUnreadCountOnDock;
}

- (void)setDisplayUnreadCountOnDock:(BOOL)flag {
	m_displayUnreadCountOnDock = flag;
	m_dirty = YES;
}

- (BOOL)jumpIconWhenReceivedIM {
	return m_jumpIconWhenReceivedIM;
}

- (void)setJumpIconWhenReceivedIM:(BOOL)flag {
	m_jumpIconWhenReceivedIM = flag;
	m_dirty = YES;
}

- (BOOL)disableDockIconAnimation {
	return m_disableDockIconAnimation;
}

- (void)setDisableDockIconAnimation:(BOOL)flag {
	m_disableDockIconAnimation = flag;
}

- (BOOL)showFakeCamera {
	return m_showFakeCamera;
}

- (void)setShowFakeCamera:(BOOL)flag {
	m_showFakeCamera = flag;
}

- (BOOL)disableOutlineTooltip {
	return m_disableOutlineTooltip;
}

- (void)setDisableOutlineTooltip:(BOOL)flag {
	m_disableOutlineTooltip = flag;
}

- (int)uploadFriendGroupMode {
	return m_uploadFriendGroupMode;
}

- (void)setUploadFriendGroupMode:(int)mode {
	m_uploadFriendGroupMode = mode;
}

- (BOOL)keepStrangerInRecentContact {
	return m_keepStrangerInRecentContact;
}

- (void)setKeepStrangerInRecentContact:(BOOL)flag {
	m_keepStrangerInRecentContact = flag;
	m_dirty = YES;
}

- (NSString*)statusMessage {
	return m_statusMessage;
}

- (void)setStatusMessage:(NSString*)statusMessage {
	[statusMessage retain];
	[m_statusMessage release];
	m_statusMessage = statusMessage;
}

- (int)statusHistoryCount {
	return [m_statusHistory count];
}

- (NSMutableArray*)statusHistory {
	return m_statusHistory;
}

- (void)addStatusMessage:(NSString*)statusMessage {
	[m_statusHistory addObject:statusMessage];
}

- (void)clearStatusHistory {
	[m_statusHistory removeAllObjects];
}

- (int)maxRecentContact {
	return m_maxRecentContact;
}

- (void)setMaxRecentContact:(int)max {
	m_maxRecentContact = max;
	m_dirty = YES;
}

- (BOOL)hideToolbar {
	return m_hideToolbar;
}

- (void)setHideToolbar:(BOOL)flag {
	m_hideToolbar = flag;
}

- (NSString*)activeQBarName {
	return m_activeQBarName;
}

- (void)setActiveQBarName:(NSString*)name {
	[name retain];
	[m_activeQBarName release];
	m_activeQBarName = name;
}

@end