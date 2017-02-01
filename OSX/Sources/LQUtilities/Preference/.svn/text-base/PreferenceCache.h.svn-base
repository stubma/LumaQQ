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

//
// a class to hold some preference which will be queried frequently
//
@interface PreferenceCache : NSObject {
	NSRect m_windowFrame;
	BOOL m_showLargeUserHead;
	BOOL m_showClusterNameCard;
	BOOL m_showRealName;
	BOOL m_showNickName;
	BOOL m_showLevel;
	BOOL m_showOnlineOnly;
	BOOL m_showSignature;
	BOOL m_showUserProperty;
	BOOL m_showStatusMessage;
	BOOL m_showHorizontalLine;
	BOOL m_alternatingRowBackground;
	float m_backgroundRed;
	float m_backgroundGreen;
	float m_backgroundBlue;
	float m_chatFontColorRed;
	float m_chatFontColorGreen;
	float m_chatFontColorBlue;
	NSString* m_chatFontName;
	BOOL m_chatFontStyleBold;
	BOOL m_chatFontStyleItalic;
	BOOL m_chatFontStyleUnderline;
	UInt32 m_chatFontSize;
	BOOL m_showTabStyleIMWindow;
	NSString* m_nickFontName;
	float m_nickFontColorRed;
	float m_nickFontColorGreen;
	float m_nickFontColorBlue;
	BOOL m_nickFontStyleBold;
	BOOL m_nickFontStyleItalic;
	UInt32 m_nickFontSize;
	NSString* m_signatureFontName;
	float m_signatureFontColorRed;
	float m_signatureFontColorGreen;
	float m_signatureFontColorBlue;
	BOOL m_signatureFontStyleBold;
	BOOL m_signatureFontStyleItalic;
	UInt32 m_signatureFontSize;
	BOOL m_hideToolbar;
	BOOL m_disableDockIconAnimation;
	BOOL m_showFakeCamera;
	BOOL m_disableOutlineTooltip;
	
	NSString* m_newLineKey;
	NSString* m_closeKey;
	NSString* m_historyKey;
	NSString* m_switchTabKey;
	NSString* m_sendKey;
	
	NSString* m_extractMessageHotKey;
	NSString* m_screenscrapHotKey;
	
	BOOL m_enableSound;
	NSString* m_baseSoundSchema;
	NSString* m_userMessageSoundFile;
	NSString* m_clusterMessageSoundFile;
	NSString* m_mobileMessageSoundFile;
	NSString* m_systemMessageSoundFile;
	NSString* m_userOnlineSoundFile;
	NSString* m_goodSystemMessageSoundFile;
	NSString* m_badSystemMessageSoundFile;
	NSString* m_loginSoundFile;
	NSString* m_logoutSoundFile;
	NSString* m_messageBlockedSoundFile;
	NSString* m_kickedOutSoundFile;
	
	BOOL m_alwaysOnTop;
	BOOL m_autoEjectMessage;
	BOOL m_autoHideMainWindow;
	BOOL m_useTabStyleIMWindow;
	BOOL m_hideOnClose;
	BOOL m_rejectStrangerMessage;
	BOOL m_disableUserOnlineTip;	
	BOOL m_displayUnreadCountOnDock;
	BOOL m_jumpIconWhenReceivedIM;
	int m_uploadFriendGroupMode;
	NSString* m_statusMessage;
	NSMutableArray* m_statusHistory;
	
	BOOL m_keepStrangerInRecentContact;
	int m_maxRecentContact;
	
	NSString* m_activeQBarName;
	
	UInt32 m_QQ;
	BOOL m_dirty;
}

+ (PreferenceCache*)cache:(UInt32)QQ;

- (id)initWithQQ:(UInt32)QQ;
- (void)reload;
- (void)sync;
- (BOOL)dirty;

// getter and setter
- (BOOL)showLargeUserHead;
- (void)setShowLargeUserHead:(BOOL)flag;
- (BOOL)showClusterNameCard;
- (void)setShowClusterNameCard:(BOOL)flag;
- (BOOL)showRealName;
- (void)setShowRealName:(BOOL)showRealName;
- (NSRect)windowFrame;
- (void)setWnidowFrame:(NSRect)frame;
- (BOOL)showNickName;
- (void)setShowNickName:(BOOL)showNickName;
- (BOOL)showLevel;
- (void)setShowLevel:(BOOL)showLevel;
- (BOOL)showOnlineOnly;
- (void)setShowOnlineOnly:(BOOL)showOnlineOnly;
- (BOOL)showSignature;
- (void)setShowSignature:(BOOL)showSignature;
- (BOOL)showUserProperty;
- (void)setShowUserProperty:(BOOL)showUserProperty;
- (BOOL)showStatusMessage;
- (void)setShowStatusMessage:(BOOL)showStatusMessage;
- (BOOL)showHorizontalLine;
- (void)setShowHorizontalLine:(BOOL)showHorizontalLine;
- (BOOL)alternatingRowBackground;
- (void)setAlternatingRowBackground:(BOOL)alternatingRowBackground;
- (NSColor*)background;
- (void)setBackground:(NSColor*)background;
- (NSColor*)chatFontColor;
- (void)setChatFontColor:(NSColor*)color;
- (NSString*)chatFontName;
- (void)setChatFontName:(NSString*)name;
- (BOOL)chatFontStyleBold;
- (void)setChatFontStyleBold:(BOOL)flag;
- (BOOL)chatFontStyleItalic;
- (void)setChatFontStyleItalic:(BOOL)flag;
- (BOOL)chatFontStyleUnderline;
- (void)setChatFontStyleUnderline:(BOOL)flag;
- (UInt32)chatFontSize;
- (void)setChatFontSize:(UInt32)size;
- (BOOL)showTabStyleIMWindow;
- (void)setShowTabStyleIMWindow:(BOOL)flag;
- (NSColor*)nickFontColor;
- (void)setNickFontColor:(NSColor*)color;
- (NSString*)nickFontName;
- (void)setNickFontName:(NSString*)name;
- (BOOL)nickFontStyleBold;
- (void)setNickFontStyleBold:(BOOL)flag;
- (BOOL)nickFontStyleItalic;
- (void)setNickFontStyleItalic:(BOOL)flag;
- (UInt32)nickFontSize;
- (void)setNickFontSize:(UInt32)size;
- (NSColor*)signatureFontColor;
- (void)setSignatureFontColor:(NSColor*)color;
- (NSString*)signatureFontName;
- (void)setSignatureFontName:(NSString*)name;
- (BOOL)signatureFontStyleBold;
- (void)setSignatureFontStyleBold:(BOOL)flag;
- (BOOL)signatureFontStyleItalic;
- (void)setSignatureFontStyleItalic:(BOOL)flag;
- (UInt32)signatureFontSize;
- (void)setSignatureFontSize:(UInt32)size;
- (BOOL)hideToolbar;
- (void)setHideToolbar:(BOOL)flag;
- (BOOL)disableDockIconAnimation;
- (void)setDisableDockIconAnimation:(BOOL)flag;
- (BOOL)showFakeCamera;
- (void)setShowFakeCamera:(BOOL)flag;
- (BOOL)disableOutlineTooltip;
- (void)setDisableOutlineTooltip:(BOOL)flag;

- (NSString*)newLineKey;
- (void)setNewLineKey:(NSString*)key;
- (NSString*)closeKey;
- (void)setCloseKey:(NSString*)key;
- (NSString*)historyKey;
- (void)setHistoryKey:(NSString*)key;
- (NSString*)switchTabKey;
- (void)setSwitchTabKey:(NSString*)key;
- (NSString*)sendKey;
- (void)setSendKey:(NSString*)key;

- (NSString*)extractMessageHotKey;
- (void)setExtractMessageHotKey:(NSString*)key;
- (NSString*)screenscrapHotKey;
- (void)setScreenscrapHotKey:(NSString*)key;

- (BOOL)isEnableSound;
- (void)setEnableSound:(BOOL)enable;
- (NSString*)baseSoundSchema;
- (void)setBaseSoundSchema:(NSString*)schema;
- (NSString*)userMessageSoundFile;
- (void)setUserMessageSoundFile:(NSString*)file;
- (NSString*)clusterMessageSoundFile;
- (void)setClusterMessageSoundFile:(NSString*)file;
- (NSString*)mobileMessageSoundFile;
- (void)setMobileMessageSoundFile:(NSString*)file;
- (NSString*)systemMessageSoundFile;
- (void)setSystemMessageSoundFile:(NSString*)file;
- (NSString*)userOnlineSoundFile;
- (void)setUserOnlineSoundFile:(NSString*)file;
- (NSString*)badSystemMessageSoundFile;
- (void)setBadSystemMessageSoundFile:(NSString*)file;
- (NSString*)goodSystemMessageSoundFile;
- (void)setGoodSystemMessageSoundFile:(NSString*)file;
- (NSString*)loginSoundFile;
- (void)setLoginSoundFile:(NSString*)file;
- (NSString*)logoutSoundFile;
- (void)setLogoutSoundFile:(NSString*)file;
- (NSString*)messageBlockedSoundFile;
- (void)setMessageBlockedSoundFile:(NSString*)file;
- (NSString*)kickedOutSoundFile;
- (void)setKickedOutSoundFile:(NSString*)file;

- (BOOL)alwaysOnTop;
- (void)setAlwaysOnTop:(BOOL)flag;
- (BOOL)autoEjectMessage;
- (void)setAutoEjectMessage:(BOOL)flag;
- (BOOL)autoHideMainWindow;
- (void)setAutoHideMainWindow:(BOOL)flag;
- (BOOL)useTabStyleIMWindow;
- (void)setUseTabStyleIMWindow:(BOOL)flag;
- (BOOL)isUserOnlineTipEnabled;
- (void)enableUserOnlineTip:(BOOL)flag;
- (BOOL)hideOnClose;
- (void)setHideOnClose:(BOOL)hideOnClose;
- (BOOL)rejectStrangerMessage;
- (void)setRejectStrangerMessage:(BOOL)flag;
- (BOOL)displayUnreadCountOnDock;
- (void)setDisplayUnreadCountOnDock:(BOOL)flag;
- (BOOL)jumpIconWhenReceivedIM;
- (void)setJumpIconWhenReceivedIM:(BOOL)flag;
- (int)uploadFriendGroupMode;
- (void)setUploadFriendGroupMode:(int)mode;
- (NSString*)statusMessage;
- (void)setStatusMessage:(NSString*)statusMessage;
- (NSMutableArray*)statusHistory;
- (int)statusHistoryCount;
- (void)addStatusMessage:(NSString*)statusMessage;
- (void)clearStatusHistory;

- (BOOL)keepStrangerInRecentContact;
- (void)setKeepStrangerInRecentContact:(BOOL)flag;
- (int)maxRecentContact;
- (void)setMaxRecentContact:(int)max;

- (NSString*)activeQBarName;
- (void)setActiveQBarName:(NSString*)name;

@end
