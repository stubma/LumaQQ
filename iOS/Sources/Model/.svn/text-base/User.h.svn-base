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
#import <UIKit/UIKit.h>
#import "Friend.h"
#import "ContactInfo.h"
#import "UserProperty.h"
#import "FriendLevel.h"
#import "Signature.h"
#import "FriendRemark.h"
#import "FriendStatus.h"
#import "ClusterSpecificInfo.h"
#import "ClusterNameCard.h"
#import "SignatureChangedNotification.h"
#import "FriendStatusChangedNotification.h"
#import "CustomHead.h"

// group index constant
#define kGroupIndexUndefined -1

@class Cluster;

@interface User : NSObject <NSCopying, NSCoding> {
	// user info
	UInt32 m_QQ;
	UInt16 m_head;
	NSString* m_nick;
	NSString* m_name;
	NSString* m_remarkName;
	NSString* m_signature;
	UInt32 m_signatureModifiedTime;
	int m_level;
	int m_upgradeDays;
	char m_gender;
	int m_userFlag;
	NSData* m_userFlagEx;
	char m_status;
	ContactInfo* m_contact;
	int m_groupIndex;
	char m_ip[4];
	UInt16 m_port;
	NSString* m_statusMessage;
	
	// cluster specific info
	NSMutableDictionary* m_clusterSpecificInfos;
	
	// used for QQCell
	BOOL m_mobileChatting;
	
	// for custom head
	CustomHead* m_customHead;
}

- (UIImage*)headWithStatus:(BOOL)handleStatus;

// init
- (id)initWithQQ:(UInt32)QQ;
- (void)copyWithFriend:(Friend*)f;
- (void)copyWithFriendStatus:(FriendStatus*)fs;
- (void)copyWithFriendStatusChangedNotification:(FriendStatusChangedNotification*)notify;
- (void)copyWithUserProperty:(UserProperty*)p;
- (void)copyWithFriendLevel:(FriendLevel*)level;
- (void)copyWithSignature:(Signature*)sig;
- (void)copyWithRemarks:(FriendRemark*)remark;
- (void)copyWithSignatureChangedNotification:(SignatureChangedNotification*)notification;

// compare
- (NSComparisonResult)compareQQ:(User*)user;
- (NSComparisonResult)compareDisplayName:(User*)user;
- (NSComparisonResult)compare:(User*)user;

// helper
- (BOOL)isMember;
- (BOOL)isVIP;
- (BOOL)isTM;
- (BOOL)isMobileQQ;
- (BOOL)isBind;
- (BOOL)hasCam;
- (BOOL)hasSignature;
- (BOOL)hasCustomHead;
- (BOOL)has3DShow;
- (BOOL)hasAlbum;
- (BOOL)hasFantasy;
- (BOOL)hasHome;
- (BOOL)hasHuaXia;
- (BOOL)hasLove;
- (BOOL)hasPet;
- (BOOL)hasRing;
- (BOOL)hasSpace;
- (BOOL)hasTang;
- (BOOL)isCreator:(Cluster*)cluster;
- (BOOL)isAdmin:(Cluster*)cluster;
- (BOOL)isStockholder:(Cluster*)cluster;
- (BOOL)isManaged:(Cluster*)cluster;
- (BOOL)isSuperUser:(Cluster*)cluster;
- (BOOL)isOffline;
- (BOOL)isVisible;
- (NSString*)remarkOrNickOrQQ;
- (BOOL)checkFlagEx:(int)bit;

// getter and setter
- (NSString*)shortDisplayName;
- (NSString*)displayName;
- (NSString*)memberDisplayName:(UInt32)internalId;
- (BOOL)mobileChatting;
- (void)setMobileChatting:(BOOL)value;
- (UInt32)QQ;
- (UInt16)head;
- (void)setHead:(UInt16)head;
- (char)age;
- (void)setAge:(char)age;
- (BOOL)isMM;
- (void)setMM:(BOOL)mm;
- (int)level;
- (void)setLevel:(int)level;
- (int)upgradeDays;
- (void)setUpgradeDays:(int)days;
- (int)userFlag;
- (void)setUserFlag:(int)flag;
- (NSString*)nick;
- (void)setNick:(NSString*)nick;
- (NSString*)name;
- (void)setName:(NSString*)name;
- (NSString*)remarkName;
- (void)setRemarkName:(NSString*)remarkName;
- (NSString*)signature;
- (void)setSignature:(NSString*)signature;
- (char)status;
- (void)setStatus:(char)status;
- (ContactInfo*)contact;
- (void)setContact:(ContactInfo*)contact;
- (NSData*)userFlagEx;
- (void)setUserFlagEx:(NSData*)userFlagEx;
- (UInt32)signatureModifiedTime;
- (void)setSignatureModifiedTime:(UInt32)time;
- (int)groupIndex;
- (void)setGroupIndex:(int)groupIndex;
- (void)setRoleFlag:(UInt32)internalId role:(UInt32)role;
- (ClusterNameCard*)nameCard:(UInt32)internalId;
- (void)setNameCard:(UInt32)internalId card:(ClusterNameCard*)card;
- (UInt32)lastTalkTime:(UInt32)internalId;
- (void)setLastTalkTime:(UInt32)internalId time:(UInt32)time;
- (ClusterSpecificInfo*)getClusterSpecificInfo:(UInt32)internalId;
- (const char*)ip;
- (void)setIp:(const char*)ip;
- (UInt16)port;
- (void)setPort:(UInt16)port;
- (NSString*)statusMessage;
- (void)setStatusMessage:(NSString*)statusMessage;
- (CustomHead*)customHead;
- (void)setCustomHead:(CustomHead*)head;

@end
