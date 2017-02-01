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

#pragma mark -
#pragma mark global preference

//////////////////////////////////////////////////////
// global preference

#define kLQGlobalLoginHistory @"LoginHistory"
#define kLQGlobalLastQQ @"LastQQ"
#define kLQGlobalUDPServers @"UDPServers"
#define kLQGlobalTCPServers @"TCPServers"

#pragma mark -
#pragma mark preference for every QQ number

//////////////////////////////////////////////////////
// login preference

#define kLQLoginRememberPassword @"RememberPassword"
#define kLQLoginHidden @"LoginHidden"
#define kLQLoginPassword @"Password"

//////////////////////////////////////////////////////
// login network setting

#define kLQLoginProtocol @"LoginProtocol"
#define kLQLoginServer @"LoginServer"
#define kLQLoginPort @"LoginPort"
#define kLQLoginProxyType @"ProxyType"
#define kLQLoginProxyServer @"ProxyServer"
#define kLQLoginProxyPort @"ProxyPort"
#define kLQLoginProxyUsername @"ProxyUsername"
#define kLQLoginProxyPassword @"ProxyPassword"

/////////////////////////////////////////////////////
// version number

#define kLQVersionCurrent @"CurrentVersion"

//////////////////////////////////////////////////////
// ui setting

#define kLQUIWindowX @"WindowX"
#define kLQUIWindowY @"WindowY"
#define kLQUIWindowWidth @"WindowWidth"
#define kLQUIWindowHeight @"WindowHeight"
#define kLQUIShowLargeUserHead @"ShowLargeUserHead"
#define kLQUIShowClusterNameCard @"ShowClusterNameCard"
#define kLQUIShowRealName @"ShowRealName"
#define kLQUIShowNickName @"ShowNickName"
#define kLQUIShowLevel @"ShowLevel"
#define kLQUIShowStatusMessage @"ShowStatusMessage"
#define kLQUIShowOnlineOnly @"ShowOnlineOnly"
#define kLQUIShowSignature @"ShowSignature"
#define kLQUIShowUserProperty @"ShowUserProperty"
#define kLQUIShowHorizontalLine @"ShowHorizontalLine"
#define kLQUIAlternatingRowBackground @"AlternatingRowBackground"
#define kLQUIBackgroundRed @"BackgroundRed"
#define kLQUIBackgroundGreen @"BackgroundGreen"
#define kLQUIBackgroundBlue @"BackgroundBlue"
#define kLQUIChatFontName @"ChatFontName"
#define kLQUIChatFontSize @"ChatFontSize"
#define kLQUIChatFontColorRed @"ChatFontColorRed"
#define kLQUIChatFontColorGreen @"ChatFontColorGreen"
#define kLQUIChatFontColorBlue @"ChatFontColorBlue"
#define kLQUIChatFontStyleBold @"ChatFontStyleBold"
#define kLQUIChatFontStyleItalic @"ChatFontStyleItalic"
#define kLQUIChatFontStyleUnderline @"ChatFontStyleUnderline"
#define kLQUIShowTabStyleIMWindow @"ShowTabStyleIMWindow"
#define kLQUINickFontName @"NickFontName"
#define kLQUINickFontColorRed @"NickFontColorRed"
#define kLQUINickFontColorGreen @"NickFontColorGreen"
#define kLQUINickFontColorBlue @"NickFontColorBlue"
#define kLQUINickFontStyleBold @"NickFontStyleBold"
#define kLQUINickFontStyleItalic @"NickFontStyleItalic"
#define kLQUINickFontSize @"NickFontSize"
#define kLQUISignatureFontName @"SignatureFontName"
#define kLQUISignatureFontColorRed @"SignatureFontColorRed"
#define kLQUISignatureFontColorGreen @"SignatureFontColorGreen"
#define kLQUISignatureFontColorBlue @"SignatureFontColorBlue"
#define kLQUISignatureFontStyleBold @"SignatureFontStyleBold"
#define kLQUISignatureFontStyleItalic @"SignatureFontStyleItalic"
#define kLQUISignatureFontSize @"SignatureFontSize"
#define kLQUIHideToolbar @"HideToolbar"
#define kLQUIShowClusterNameCard @"ShowClusterNameCard"
#define kLQUIDisableDockIconAnimation @"DisableDockIconAnimation"
#define kLQUIShowFakeCamera @"ShowFakeCamera"
#define kLQUIDisableOutlineTooltip @"DisableTooltip"

////////////////////////////////////////////////////////////
// key setting

#define kLQKeyNewLine @"NewLineKey"
#define kLQKeyClose @"CloseKey"
#define kLQKeyHistory @"History"
#define kLQKeySwitchTab @"SwitchTabKey"
#define kLQKeySend @"SendKey"

////////////////////////////////////////////////////////////
// hot key setting

#define kLQHotKeyExtractMessage @"ExtractMessageHotKey"
#define kLQHotKeyScreenscrap @"ScreenscrapHotKey"

////////////////////////////////////////////////////////
// sound setting

#define kLQSoundEnabled @"SoundEnabled"
#define kLQSoundBaseSchema @"SoundBaseSchema"
#define kLQSoundUserMessage @"UserMessageSound"
#define kLQSoundClusterMessage @"ClusterMessageSound"
#define kLQSoundMobileMessage @"MobileMessageSound"
#define kLQSoundSystemMessage @"SystemMessageSound"
#define kLQSoundGoodSystemMessage @"GoodSystemMessageSound"
#define kLQSoundBadSystemMessage @"BadSystemMessageSound"
#define kLQSoundUserOnline @"UserOnlineSound"
#define kLQSoundLogin @"LoginSound"
#define kLQSoundLogout @"LogoutSound"
#define kLQSoundKickedOut @"KickedOutSound"
#define kLQSoundMessageBlocked @"MessageBlockedSound"

//////////////////////////////////////////////////////////
// recent contact setting

#define kLQRecentKeepStranger @"KeepStrangerInRecent"
#define kLQRecentMax @"MaxRecentContact"

////////////////////////////////////////////////////////
// Basic setting

#define kLQBasicAlwaysOnTop @"Always On Top"
#define kLQBasicAutoEjectMessage @"Auto Eject Message"
#define kLQBasicAutoHideMainWindow @"Auto Hide Main Window"
#define kLQBasicUseTabIMStyleWindow @"Use Tab Style IM Window"
#define kLQBasicHideMainWindowWhenClose @"Hide Main Window When Close"
#define kLQBasicRejectStrangerMessage @"Reject Stranger Message"
#define kLQBasicDisableUserOnlineTip @"DisableUserOnlineTip"
#define kLQBasicHideOnClose @"HideOnClose"
#define kLQBasicRejectStranger @"RejectStrangerMessage"
#define kLQBasicDisplayUnreadCountOnDock @"DisplayUnreadCountOnDock"
#define kLQBasicJumpIconWhenReceivedIM @"JumpIconWhenReceivedIM"
#define kLQBasicUploadFriendGroup @"UploadFriendGroup"
#define kLQBasicStatusMessage @"StatusMessage"
#define kLQBasicStatusHistory @"StatusHistory"

/////////////////////////////////////////////////////////
// plugin setting

#define kLQPluginActiveQBarName @"ActiveQBarName"

#pragma mark -
#pragma mark constant value

//////////////////////////////////////////////////////
// login network setting value

#define kLQPortUDP 4000
#define kLQPortTCP 80
#define kLQProtocolUDP @"UDP"
#define kLQProtocolTCP @"TCP"
#define kLQProxyNone @"None"
#define kLQProxyHTTP @"HTTP"
#define kLQProxySocks5 @"Socks5"

///////////////////////////////////////////////////////
// upload friend group value

#define kLQUploadAsk 0
#define kLQUploadAlways 1
#define kLQUploadNever 2