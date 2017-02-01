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

#import <Foundation/Foundation.h>
#import "UIKitComplement.h"

// current version
#define kLumaQQVersionString @"200804262300"

// empty string
#define kStringEmpty @""

// preference dir
#define kLQDirectoryRoot @"~/Library/LumaQQ"
#define kLQDirectoryCustomHead @"CustomHead"
#define kLQBundleDirectorySound @"Sound"
#define kLQDirectoryChatLog @"ChatLog"

// preference file
#define kLQFileMyself @"Myself.plist"
#define kLQFileGroups @"Groups.plist"
#define kLQFileSystem @"System.plist"
#define kLQFileUnread @"Unread.lumaqqchatlog"
#define kLQFileRecent @"Recent.plist"

// theme file
#define kLQFileTheme @"Theme.plist"

// other file
#define kLumaQQStatusIconFSO @"/Applications/LumaQQ.app/FSO_LumaQQ.png"
#define kLumaQQStatusIconDefault @"/Applications/LumaQQ.app/Default_LumaQQ.png"
#define kLumaQQStatusIconMessageFSO @"/Applications/LumaQQ.app/FSO_LumaQQ_Message.png"
#define kLumaQQStautsIconMessageDefault @"/Applications/LumaQQ.app/Default_LumaQQ_Message.png"
#define kSpringBoardStatusIconFSO @"/System/Library/CoreServices/SpringBoard.app/FSO_LumaQQ.png"
#define kSpringBoardStatusIconDefault @"/System/Library/CoreServices/SpringBoard.app/Default_LumaQQ.png"
#define kSpringBoardStatusIconMessageFSO @"/System/Library/CoreServices/SpringBoard.app/FSO_LumaQQ_Message.png"
#define kSpringBoardStatusIconMessageDefault @"/System/Library/CoreServices/SpringBoard.app/Default_LumaQQ_Message.png"

// default frame of switch
static const CGRect DEFAULT_SWITCH_RECT = {
	 200, 10, 50, 20
};

// theme struct
typedef struct _tagTheme {
	float userBg[4];
	float userSelectedBg[4];
	float userTextFg[4];
	float userSigTextFg[4];
	float memberTextFg[4];
	float clusterBg[4];
	float clusterSelectedBg[4];
	float clusterTextFg[4];
	float advancedClusterTextFg[4];
	float unreadHintFg[4];
	float messageTextFg[4];
	float userIMTextFg[4];
	float clusterIMTextFg[4];
	float systemBg[4];
	float systemSelectedBg[4];
	float systemIMTextFg[4];
	float errorTextFg[4];
	float bubbleIMTextFg[4];
	float bubbleBg[4];
	float chatLogBg[4];
	float chatLogSelectedBg[4];
	float chatLogTextFg[4];
	float chatLogOtherMsgFg[4];
	float chatLogMyMsgFg[4];
	
	int mainButtonBarStyle;
} Theme;

// data key
#define kDataKeyQQ @"QQ"
#define kDataKeyPassword @"Password"
#define kDataKeyDontMakeMD5 @"DontMakeMD5"
#define kDataKeyLoginHidden @"LoginHidden"
#define kDataKeyProtocol @"Protocol"
#define kDataKeyServer @"Server"
#define kDataKeyPort @"Port"
#define kDataKeyEnableHTTPProxy @"EnableHTTPProxy"
#define kDataKeyHTTPProxyServer @"HTTPProxyServer"
#define kDataKeyHTTPProxyPort @"HTTPProxyPort"
#define kDataKeyHTTPProxyUsername @"HTTPProxyUsername"
#define kDataKeyHTTPProxyPassword @"HTTPProxyPassword"
#define kDataKeyClient @"Client"
#define kDataKeyGroupManager @"GroupManager"
#define kDataKeyFrom @"From"
#define kDataKeyStringValueArray @"StringValueArray"
#define kDataKeyStringValue @"StringValue"
#define kDataKeyNumberValue @"NumberValue"
#define kDataKeyNotificationName @"NotificationName"
#define kDataKeyGroup @"Group"
#define kDataKeyCluster @"Cluster"
#define kDataKeyCachedMessages @"CachedMessages"
#define kDataKeyCachedSystemNotifications @"CachedSystemNotifications"
#define kDataKeyUser @"User"
#define kDataKeyMessageManager @"MessageManager"
#define kDataKeyReturnedData @"ReturnedData"
#define kDataKeyTitle @"Title"
#define kDataKeyGroupTitle @"GroupTitle"
#define kDataKeyNotificationObject @"NotificationObject"
#define kDataKeyTextCellTitle @"TextCellTitle"
#define kDataKeyApplyButtonTitle @"ApplyButtonTitle"
#define kDataKeyChatModel @"ChatModel"
#define kDataKeyDictionary @"Dictionary"

// chat log key
#define kChatLogKeyMessage @"Message"
#define kChatLogKeyQQ @"QQ"
#define kChatLogKeyTime @"Time"
#define kChatLogKeyCluster @"Cluster" // this field is only used for saveUnread/loadUnread
#define kChatLogKeySourceQQ @"SourceQQ"
#define kChatLogKeyClusterInternalID @"ClusterInternalID"
#define kChatLogKeyDestQQ @"DestQQ"
#define kChatLogKeySMType @"SMType"
#define kChatLogKeyAuthInfo @"AuthInfo"

// defined for kChatLogKeySMType
#define kSMTypeRequestJoinCluster 0
#define kSMTypeApproveJoinCluster 1
#define kSMTypeRejectJoinCluster 2
#define kSMTypeExitCluster 3
#define kSMTypeCreateCluster 4
#define kSMTypeJoinCluster 5
#define kSMTypeRequestAddMe 6
#define kSMTypeRequestAddMeAndAllowAddHim 7
#define kSMTypeApproveMyRequest 8
#define kSMTypeApproveMyRequestAndAddMe 9
#define kSMTypeRejectMyRequest 10
#define kSMTypeAddMe 11

// preference
#define kPreferenceKeyShowOnlineOnly @"ShowOnlineOnly"
#define kPreferenceKeyShowNick @"ShowNick"
#define kPreferenceKeyShowLevel @"ShowLevel"
#define kPreferenceKeyShowSignature @"ShowSignature"
#define kPreferenceKeyShowStatusMessage @"ShowStatusMessage"
#define kPreferenceKeyStatusMessage @"StatusMessage"
#define kPreferenceKeyRejectStrangerMessage @"RejectStrangerMessage"
#define kPreferenceKeyDisableSound @"DisableSound"
#define kPreferenceKeySoundScheme @"SoundScheme"
#define kPreferenceKeyButtonBar @"ButtonBar"
#define kPreferenceKeyButtonBarButtonCount @"ButtonBarButtonCount"

// images
#define kImageOnlineIcon @"online_icon.png"
#define kImageGradientBlueBackground @"gradient_blue_background.png"
#define kImageGradientGrayBackground @"gradient_gray_background.png"
#define kImageRoundInputFieldBackground @"round_inputfield_background.png"
#define kImageGreenButtonUp @"green_button_up.png"
#define kImageGreenButtonDown @"green_button_down.png"
#define kImageBlueButtonUp @"blue_button_up.png"
#define kImageBlueButtonDown @"blue_button_down.png"
#define kImageOrangeButtonUp @"orange_button_up.png"
#define kImageOrangeButtonDown @"orange_button_down.png"
#define kImageSmallOrangeButtonDown @"small_orange_button_down.png"
#define kImageSmallOrangeButtonUp @"small_orange_button_up.png"
#define kImageLoginButtonUp @"loginbutton_up.png"
#define kImageLoginButtonDown @"loginbutton_down.png"
#define kImageTMMale @"tm_male.png"
#define kImageTMFemale @"tm_female.png"
#define kImageUserButtonOn @"users_on.png"
#define kImageUserButtonOff @"users_off.png"
#define kImageClusterButtonOn @"clusters_on.png"
#define kImageClusterButtonOff @"clusters_off.png"
#define kImageMyselfButtonOn @"myself_on.png"
#define kImageMyselfButtonOff @"myself_off.png"
#define kImageSearchButtonOn @"search_on.png"
#define kImageSearchButtonOff @"search_off.png"
#define kImageMessageButtonOn @"message_on.png"
#define kImageMessageButtonOff @"message_off.png"
#define kImageCustomizeButtonOn @"customize_on.png"
#define kImageCustomizeButtonOff @"customize_off.png"
#define kImageRecentButtonOn @"recent_on.png"
#define kImageRecentButtonOff @"recent_off.png"
#define kImageHistoryButtonOn @"history_on.png"
#define kImageHistoryButtonOff @"history_off.png"
#define kImageFaceButtonOff @"face_off.png"
#define kImageFaceButtonOn @"face_on.png"
#define kImageKeyboardButtonOff @"keyboard_off.png"
#define kImageKeyboardButtonOn @"keyboard_on.png"
#define kImageHideButtonOff @"hide_off.png"
#define kImageHideButtonOn @"hide_on.png"
#define kImageExpand @"expand.png"
#define kImageCollapse @"collapse.png"
#define kImageOnline @"online.png"
#define kImageOffline @"offline.png"
#define kImageAway @"away.png"
#define kImageHidden @"hidden.png"
#define kImageQMe @"QMe.png"
#define kImageBusy @"busy.png"
#define kImageMute @"mute.png"
#define kImageCluster @"cluster.png"
#define kImageClusterAdmin @"cluster_admin.png"
#define kImageClusterCreator @"cluster_creator.png"
#define kImageClusterStockholder @"cluster_stockholder.png"
#define kImageGrayBubbleTopLeft @"chat_graybubble_topleft.png"
#define kImageGrayBubbleTopMiddle @"chat_graybubble_topmiddle.png"
#define kImageGrayBubbleTopRight @"chat_graybubble_topright.png"
#define kImageGrayBubbleLeft @"chat_graybubble_left.png"
#define kImageGrayBubbleMiddle @"chat_graybubble_middle.png"
#define kImageGrayBubbleRight @"chat_graybubble_right.png"
#define kImageGrayBubbleBottomLeft @"chat_graybubble_bottomleft.png"
#define kImageGrayBubbleBottomMiddle @"chat_graybubble_bottommiddle.png"
#define kImageGrayBubbleBottomRight @"chat_graybubble_bottomright.png"
#define kImageBlueBubbleTopLeft @"chat_bluebubble_topleft.png"
#define kImageBlueBubbleTopMiddle @"chat_bluebubble_topmiddle.png"
#define kImageBlueBubbleTopRight @"chat_bluebubble_topright.png"
#define kImageBlueBubbleLeft @"chat_bluebubble_left.png"
#define kImageBlueBubbleMiddle @"chat_bluebubble_middle.png"
#define kImageBlueBubbleRight @"chat_bluebubble_right.png"
#define kImageBlueBubbleBottomLeft @"chat_bluebubble_bottomleft.png"
#define kImageBlueBubbleBottomMiddle @"chat_bluebubble_bottommiddle.png"
#define kImageBlueBubbleBottomRight @"chat_bluebubble_bottomright.png"

// notification

// triggerred when application will be suspended
// object is nil
#define kWillSuspendNotificationName @"WillSuspend"

// triggered when application will be resumed
// object is nil
#define kWillResumeNotificationName @"WillResume"

// triggered when a custom head is received
// the object is custom head, use @"CustomHeadData" to get data from user info
// if @"CustomHeadData" is nil, then the head is already get
#define kCustomHeadDidReceivedNotificationName @"CustomHeadDidReceived"
#define kUserInfoCustomHeadData @"CustomHeadData"

// triggered when a custom head failed to receive
#define kCustomHeadFailedToReceiveNotificationName @"CustomHeadFailedToReceive"

// triggered when a group expand status changed
// object is Group
#define kGroupExpandStatusChangedNotificationName @"GroupExpandStatusChanged"

// triggered when a cluster expand status changed
// object is Cluster
#define kClusterExpandStatusChangedNotificationName @"ClusterExpandStatusChanged"

// triggerred when a head is selected
// object is head id, the id is not multiple with 3
#define kHeadSelectedNotificationName @"HeadSelected"

// triggerred when a zodiac is selected
// object is zodiac id
// use kUserInfoStringValue to get string value
#define kZodiacSelectedNotificationName @"ZodiacSelected"
#define kUserInfoStringValue @"StringValue"

// triggerred when a horoscope is selected
// object is horoscope id
// use kUserInfoStringValue to get string value
#define kHoroscopeSelectedNotificationName @"HoroscopeSelected"

// triggerred when a blood is selected
// object is blood id
// use kUserInfoStringValue to get string value
#define kBloodSelectedNotificationName @"BloodSelected"

// triggerred when a Gender is selected
// object is Gender id
// use kUserInfoStringValue to get string value
#define kGenderSelectedNotificationName @"GenderSelected"

// triggerred when a Occupation is selected
// object is Occupation id
// use kUserInfoStringValue to get string value
#define kOccupationSelectedNotificationName @"OccupationSelected"

// triggerred when a message source is populated, i.e., a message array is removed from message manager 
// object is message manager
#define kMessageSourcePopulatedNotificationName @"MessageSourcePopulated"

// triggered when there is unread message, it will be only triggered when the old message count is 0
// object is message manager
#define kHasMessageUnreadNotificationName @"HasMessageUnread"

// triggered when a server is selected
// object is server index
// use kUserInfoStringValue to get string value
#define kServerSelectedNotificationName @"ServerSelected"

// triggered when a port is selected
// object is port index
// use kUserInfoStringValue to get string value
#define kPortSelectedNotificationName @"PortSelected"

// triggered when a cell is double tapped
// object is the cell model
#define kCellDoubleTappedNotificationName @"CellDoubleTapped"

// triggered when a group name is changed
// object is group object
// use kUserInfoStringValue to get string value
#define kGroupNameChangedNotificationName @"GroupNameChanged"

// triggered when a group need to be created
// object is nil
// use kUserInfoStringValue to get group name
#define kGroupWillBeCreatedNotificationName @"GroupWillBeCreated"

// triggered when a user's remark has been changed
// object is user
// use kUserInfoStringValue to get new remark name
#define kUserRemarkNameChangedNotificationName @"UserRemarkNameChanged"

// triggered when you want to delete a group
// object is the group to be deleted
// use kUserInfoStringValue to get the destination group name users will be moved to
#define kWantToDeleteGroupNotificationName @"WantToDeleteGroup"

// triggered when a cluster is exited
// object is the cluster
#define kClusterExitedNotificationName @"ClusterExited"

// triggerred when cluster message setting changed
// object is the cluster
#define kClusterMessagetSettingChangedNotificationName @"ClusterMessagetSettingChanged"

// triggerred when preference changed
// object is nil
#define kPreferenceChangedNotificationName @"PreferenceChanged"

// triggerred if a user want to be moved to other group
// object is user
// use kUserInfoStringValue to get dest group name
#define kUserWillBeMovedToGroupNotificationName @"UserWillBeMovedToGroup"

// triggered if a group is selected
// object is index
// use kUserInfoStringValue to get dest group name
#define kGroupSelectedNotificationName @"GroupSelected"

// triggered if a user is removed
// object is user
#define kUserRemovedNotificationName @"UserRemoved"

// triggered if a sound scheme is selected
// object doesn't have means
// use kUserInfoStringValue to get sound scheme name
#define kSoundSchemeSelectedNotificationName @"SoundSchemeSelected"

// triggered if you are kicked out
// object doesn't have means
#define kKickedOutBySystemNotificationName @"KickedOutBySystem"

// triggered when friend group is rebuilt
// object is nil
#define kFriendGroupRebuiltNotificationName @"FriendGroupRebuilt"

// debug method
void LQLog(const char *text, ...);