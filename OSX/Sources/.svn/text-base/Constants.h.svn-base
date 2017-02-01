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

//
// used to define constants which is not related to QQ protocol
//

#import <Cocoa/Cocoa.h>

// current version
#define kLumaQQVersionString @"200804261800"

// preference dir and file name

#define kLQDirectoryRoot @"~/Documents/LumaQQ Data/"
#define kLQDirectoryCustomFace @"CustomFace"
#define kLQDirectoryReceivedCustomFace @"ReceivedCustomFace"
#define kLQDirectoryQQShow @"QQShow"
#define kLQDirectoryHistory @"History"
#define kLQDirectoryCustomHead @"CustomHead"

#define kLQFileGlobal @"Global.plist"
#define kLQFileMyself @"Myself.plist"
#define kLQFileFaces @"Faces.plist"
#define kLQFileGroups @"Groups.plist"
#define kLQFileSystem @"System.plist"
#define kLQFileUpdate @"/tmp/update.txt"

// shortcut char
static const UniChar kLQUnicodeSpaceCharacter = 0x2423;
static const UniChar kLQUnicodeEnterCharacter = 0x23CE;
static const UniChar kLQUnicodeCommandCharacter = 0x2318;
static const UniChar kLQUnicodeOptionCharacter = 0x2325;
static const UniChar kLQUnicodeControlCharacter = 0x2303;
static const UniChar kLQUnicodeEscapeCharacter = 0x238B;
static const UniChar kLQUnicodeShiftCharacter = 0x21E7;
static const UniChar kLQUnicodeUpArrow = 0x2191;
static const UniChar kLQUnicodeDownArrow = 0x2193;
static const UniChar kLQUnicodeLeftArrow = 0x2190;
static const UniChar kLQUnicodeRightArrow = 0x2192;

// triggered when main window toolbar is toggled
// object is main window
#define kMainToolbarToggledVisibilityNotificationName @"MainToolbarToggledVisibility"

// triggered when an image selector window need to be closed
#define kImageSelectorWindowNeedToBeClosedNotificationName @"ImageSelectorWindowNeedToBeClosed"

// triggerred when a checked QQCell is checked/unchecked
// object is QQCell, use @"UserInfoState" to get state
// use @"UserInfoObjectValue" to get QQCell object value
#define kQQCellDidSelectedNotificationName @"QQCellDidSelected"
#define kUserInfoState @"UserInfoState"
#define kUserInfoObjectValue @"UserInfoObjectValue"

// triggered when user double click a history record in history table
// user info contain "History"
#define kHistoryDidSelectedNotificationName @"HistoryDidSelected"
#define kUserInfoHistory @"History"

// triggered when user is moved from a group to another
// use @"FromGroup" to get old group, use @"ToGroup" to get new group
// use @"UserInfoDomain" to get main window controller, because we support separate different account
#define kUserDidMovedNotificationName @"UserDidMoved"
#define kUserInfoFromGroup @"FromGroup"
#define kUserInfoToGroup @"ToGroup"
#define kUserInfoDomain @"UserInfoDomain"

// triggered when user is removed from a group
// use @"FromGroup" to get source group
// use @"UserInfoDomain" to get main window controller, because we support separate different account
#define kUserDidRemovedNotificationName @"UserDidRemoved"

// triggered when a custom face is received
// the object is custom face filename
#define kCustomFaceDidReceivedNotificationName @"CustomFaceDidReceived"

// triggered when a custom face fail to receive
// the object is custom face filename
#define kCustomFaceFailedToReceiveNotificationName @"CustomFaceFailedToReceive"

// triggered when a custom face is sent
// the object is custom face
#define kCustomFaceDidSentNotificationName @"CustomFaceDidSent"

// triggered when a custom face fail to send
// the object is custom face, use @"ErrorMessage" to get error message from user info
#define kCustomFaceListFailedToSendNotificationName @"CustomFaceFailedToSend"
#define kUserInfoErrorMessage @"ErrorMessage"

// triggered when a custom head is received
// the object is custom head, use @"CustomHeadData" to get data from user info
// if @"CustomHeadData" is nil, then the head is already get
#define kCustomHeadDidReceivedNotificationName @"CustomHeadDidReceived"
#define kUserInfoCustomHeadData @"CustomHeadData"

// triggered when a custom head failed to receive
#define kCustomHeadFailedToReceiveNotificationName @"CustomHeadFailedToReceive"

// triggered when screenscrap finished
// the object is a NSValue object from rect
#define kScreenscrapDidFinishedNotificationName @"ScreenscrapDidFinished"

// triggered when screenscrap data is got and put to pastboard
// object is NSData of image, use @"ImagePath" to get temp image file path
#define kScreenscrapDataDidPopulatedNotificationName @"ScreenscrapDataDidPopulated"
#define kUserInfoImagePath @"ImagePath"

// triggered when a picture is converted into a temp jpg image file
// object is NSData of image, use @"ImagePath" to get temp image file path
#define kTempJPGFileDidCreatedNotificationName @"TempJPGFileDidCreated"

// triggered when a cluster message setting is changed
// object is cluster, use @"NewMessageSetting" to get new message setting
#define kClusterMessageSettingDidChangedNotificationName @"ClusterMessageSettingDidChanged"

// triggered when model in im container is changed
// object is model
#define kIMContainerModelDidChangedNotificationName @"IMContainerModelDidChanged"

// triggered when a im container attached to a window
// object is view, use @"AttachToWindow" to get window object
#define kIMContainerAttachedToWindowNotificationName @"IMContainerAttachedToWindow"
#define kUserInfoAttachToWindow @"UserInfoAttachToWindow"

// trigger when message count changed in model
// object is model, use @"UserInfoOldMessageCount" and @"UserInfoNewMessageCount" to get count
// use @"UserInfoDomain" to get main window controller, because we support separate different account
#define kModelMessageCountChangedNotificationName @"ModelMessageCountChanged"
#define kUserInfoOldMessageCount @"UserInfoOldMessageCount"
#define kUserInfoNewMessageCount @"UserInfoNewMessageCount"

// search flag
#define kFlagSearchNone 0x0
#define kFlagSearchByName 0x1
#define kFlagSearchByNick 0x2
#define kFlagSearchByQQ 0x4
#define kFlagSearchBySignature 0x8

// drag type
#define kDragQQNumberType @"QQNumberType"

// face attribute
#define kFaceAttributeCode @"DefaultFaceCode"
#define kFaceAttributeMD5 @"CustomFaceMD5"
#define kFaceAttributeType @"FaceType"
#define kFaceAttributeReceived @"FaceIsRecevied"
#define kFaceAttributePath @"FacePath"

// face type
#define kFaceTypeDefault 0
#define kFaceTypeCustomFace 1
#define kFaceTypePicture 2
#define kFaceTypeScreenscrap 3

// head size
static const NSSize kSizeSmall = {
	20, 20
};
static const NSSize kSizeLarge = {
	40, 40
};

// max unread count displayed
#define kMaxUnreadCount 99

// constant string
#define kStringEmpty @""

// side constant
#define kSideLeft 1
#define kSideRight 2
#define kSideTop 4
#define kSideBottom 8

// image file name
#define kImageQQMMHasMessage @"QQMM_Message.icns"
#define kImageQQMMOffline @"QQMM_Offline.icns"
#define kImageQQMMOnline @"QQMM_Online.icns"
#define kImageQQGGHasMessage @"QQGG_Message.icns"
#define kImageQQGGOffline @"QQGG_Offline.icns"
#define kImageQQGGOnline @"QQGG_Online.icns"
#define kImageMobiles @"mobiles.png"
#define kImageTwoDigitsBadge @"two_digits_badge.png"
#define kImageThreeDigitsBadge @"three_digits_badge.png"
#define kImageTMMale @"tm_male.gif"
#define kImageTMFemale @"tm_female.gif"
#define kImageOnline @"online.gif"
#define kImageOffline @"offline.gif"
#define kImageAway @"away.gif"
#define kImageHidden @"hidden.gif"
#define kImageQMe @"QMe.gif"
#define kImageBusy @"busy.gif"
#define kImageMute @"mute.gif"
#define kImageSun @"sun.gif"
#define kImageMoon @"moon.gif"
#define kImageStar @"star.gif"
#define kImageOutlineDisplaySetting @"outline_display_setting.png"
#define kImageSearch @"search.png"
#define kImageRefresh @"refresh.icns"
#define kImageHeadX @"%u.bmp"
#define kImageDefaultHead @"1.bmp"
#define kImageClusterCreator @"cluster_creator.gif"
#define kImageClusterAdmin @"cluster_admin.gif"
#define kImageClusterStockholder @"cluster_stockholder.gif"
#define kImageFaceX @"face%u.gif"
#define kImageQQShowX @"%u.gif"
#define kImageTempCluster @"temp_cluster.png"
#define kImageClusters @"clusters.png"
#define kImageCluster @"cluster.png"
#define kImageFriends @"friends.png"
#define kImageFriendlyGroup @"friendly_group.png"
#define kImageStrangerGroup @"stranger_group.png"
#define kImageBlacklistGroup @"blacklist_group.png"
#define kImageBasic @"basic.png"
#define kImageHotKey @"hotkey.png"
#define kImageSound @"sound.png"
#define kImageRecentContact @"recent_contact.png"
#define kImageReceivingImage @"receiving_image.gif"
#define kImageNotFound @"not_found.gif"
#define kImageSystemMessageListButton @"system_message_list.png"
#define kImageScreenscrapHint @"screenscrap_hint.png"
#define kImageNoSuchImage @"no_image.png"
#define kImageMobileQQ @"mobileqq.gif"
#define kImageBindQQ @"bindqq.gif"
#define kImageFont @"font.png"
#define kImageColor @"color.png"
#define kImageSmiley @"smiley.png"
#define kImageSendFile @"send_file.png"
#define kImageSendPicture @"send_image.png"
#define kImageScreenscrap @"screenscrap.png"
#define kImageChatHistory @"chat_history.png"
#define kImageInformation @"infomation.png"
#define kImageAddButton @"add_button.png"
#define kImageAddButtonPressed @"add_button_pressed.png"
#define kImageAddButtonHovered @"add_button_hovered.png"
#define kImageMobileChatting @"mobile_chatting.gif"
#define kImageQQ3DShow @"QQ3DShow.gif"
#define kImageQQAlbum @"QQAlbum.gif"
#define kImageQQBindToMobile @"QQBindToMobile.gif"
#define kImageQQBoke @"QQBoke.gif"
#define kImageQQFantasy @"QQFantasy.gif"
#define kImageQQHome @"QQHome.gif"
#define kImageQQHuaXia @"QQHuaXia.gif"
#define kImageQQLove @"QQLove.gif"
#define kImageQQMember @"QQMember.gif"
#define kImageQQPet @"QQPet.gif"
#define kImageQQRing @"QQRing.gif"
#define kImageQQSpace @"QQSpace.gif"
#define kImageQQTang @"QQTang.gif"
#define kImageQQTenpay @"QQTenpay.gif"
#define kImageQQVIP @"QQVIP.gif"