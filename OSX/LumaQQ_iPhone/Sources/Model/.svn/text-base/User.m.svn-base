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

#import "Constants.h"
#import "User.h"
#import "QQConstants.h"
#import "NSString-Validate.h"
#import "Cluster.h"
#import "ImageTool.h"
#import "PreferenceTool.h"
#import "FileTool.h"

// encoding key
#define _kKeyQQ @"QQ"
#define _kKeyHead @"Head"
#define _kKeyNick @"Nick"
#define _kKeyName @"Name"
#define _kKeySignature @"Signature"
#define _kKeySignatureModifiedTime @"SignatureModifiedTime"
#define _kKeyLevel @"Level"
#define _kKeyUpgradeDays @"UpgradeDays"
#define _kKeyFlagEx @"FlagEx"
#define _kKeyFlag @"Flag"
#define _kKeyGroupIndex @"GroupIndex"
#define _kKeyInputBoxPortion @"InputBoxPortion"
#define _kKeyCustomHead @"CustomHead"

extern UInt32 gMyQQ;

@implementation User


- (UIImage*)headWithStatus:(BOOL)handleStatus {
	// head
	UIImage* imgMain = nil;
	
	// check custom head
	if([self hasCustomHead] && m_customHead != nil) {
		NSString* path = [FileTool getCustomHeadPath:gMyQQ md5:[m_customHead md5]];
		imgMain = [UIImage imageNamed:path];
		if(imgMain == nil) {
			if([FileTool isFileExist:path]) {
				imgMain = [[[UIImage alloc] initWithContentsOfFile:path] autorelease];
			}
		}
	}
	
	// check TM
	if(imgMain == nil) {
		if([self isTM]) {
			NSString* name = [self isMM] ? kImageTMFemale : kImageTMMale;
			imgMain = [UIImage imageNamed:name];
		} else
			imgMain = [ImageTool headWithId:m_head];
	}
	
	// check offline
	if(handleStatus && [self isOffline])
		imgMain = [ImageTool grayImage:imgMain];
	
	return imgMain;
}

- (id)initWithQQ:(UInt32)QQ {
	self = [super init];
	if(self) {
		m_QQ = QQ;
		m_level = 0;
		m_upgradeDays = 0;
		m_gender = kQQGenderMale;
		m_status = kQQStatusOffline;
		m_userFlag = 0;
		m_signatureModifiedTime = 0;
		m_groupIndex = kGroupIndexUndefined;
		m_clusterSpecificInfos = [[NSMutableDictionary dictionary] retain];
		m_status = kQQStatusOffline;
		m_mobileChatting = NO;
		m_statusMessage = kStringEmpty;
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	return [self retain];
}

- (void)copyWithFriend:(Friend*)f {
	[self setHead:[f head]];
	[self setAge:[f age]];
	[self setMM:([f gender] == kQQGenderFemale)];
	[self setNick:[f nick]];
	[self setUserFlag:[f userFlag]];
}

- (void)copyWithFriendStatus:(FriendStatus*)fs {
	[self setIp:[fs ip]];
	[self setPort:[fs port]];
	[self setStatus:[fs status]];
	[self setUserFlag:[fs userFlag]];
}

- (void)copyWithFriendStatusChangedNotification:(FriendStatusChangedNotification*)notify {
	[self setStatusMessage:[notify statusMessage]];
}

- (void)copyWithUserProperty:(UserProperty*)p {
	[self setUserFlagEx:[p userFlagEx]];
}

- (void)copyWithFriendLevel:(FriendLevel*)level {
	[self setLevel:[level level]];
	[self setUpgradeDays:[level upgradeDays]];
}

- (void)copyWithSignature:(Signature*)sig {
	[self setSignature:[sig signature]];
	[self setSignatureModifiedTime:[sig lastModifiedTime]];
}

- (void)copyWithSignatureChangedNotification:(SignatureChangedNotification*)notification {
	[self setSignature:[notification signature]];
	[self setSignatureModifiedTime:[notification lastModifiedTime]];
}

- (void)copyWithRemarks:(FriendRemark*)remark {
	[self setRemarkName:[remark name]];
}

- (void) dealloc {
	[m_nick release];
	[m_name release];
	[m_signature release];
	[m_userFlagEx release];
	[m_contact release];
	[m_remarkName release];
	[m_clusterSpecificInfos release];
	[m_statusMessage release];
	[m_customHead release];
	[super dealloc];
}

- (BOOL)isEqual:(id)anObject {
	if([anObject isKindOfClass:[User class]])
		return m_QQ == [(User*)anObject QQ];
	else
		return NO;
}

- (unsigned)hash {
	return m_QQ;
}

#pragma mark -
#pragma mark compare

- (NSComparisonResult)compareQQ:(User*)user {
	if(m_QQ < [user QQ])
		return NSOrderedAscending;
	else if(m_QQ > [user QQ])
		return NSOrderedDescending;
	else
		return NSOrderedSame;
}

- (NSComparisonResult)compareDisplayName:(User*)user {
	NSString* src = (m_name == nil || [m_name isEmpty]) ? m_nick : m_name;
	NSString* dest = ([user name] == nil || [[user name] isEmpty]) ? [user nick] : [user name];
	return [src compare:dest];
}

- (NSComparisonResult)compare:(User*)user {	
	// compare status, then name or nick
	switch(m_status) {
		case kQQStatusOnline:
			switch([user status]) {
				case kQQStatusOnline:
					return [self compareDisplayName:user];
				default:
					return NSOrderedAscending;
			}
			break;
		case kQQStatusQMe:
			switch([user status]) {
				case kQQStatusOnline:
					return NSOrderedDescending;
				case kQQStatusQMe:
					return [self compareDisplayName:user];
				default:
					return NSOrderedAscending;
			}
			break;
		case kQQStatusBusy:
			switch([user status]) {
				case kQQStatusOnline:
				case kQQStatusQMe:
					return NSOrderedDescending;
				case kQQStatusBusy:
					return [self compareDisplayName:user];
				default:
					return NSOrderedAscending;
			}
			break;
		case kQQStatusAway:
			switch([user status]) {
				case kQQStatusOnline:
				case kQQStatusQMe:
				case kQQStatusBusy:
					return NSOrderedDescending;
				case kQQStatusAway:
					return [self compareDisplayName:user];
				default:
					return NSOrderedAscending;
			}
			break;
		case kQQStatusMute:
			switch([user status]) {
				case kQQStatusOnline:
				case kQQStatusQMe:
				case kQQStatusBusy:
				case kQQStatusAway:
					return NSOrderedDescending;
				case kQQStatusMute:
					return [self compareDisplayName:user];
				default:
					return NSOrderedAscending;
			}
			break;
		case kQQStatusHidden:
			switch([user status]) {
				case kQQStatusHidden:
					return [self compareDisplayName:user];
				case kQQStatusOnline:
				case kQQStatusAway:
				case kQQStatusQMe:
				case kQQStatusBusy:
				case kQQStatusMute:
					return NSOrderedDescending;
				default:
					return NSOrderedAscending;
			}
			break;
		case kQQStatusOffline:
			switch([user status]) {
				case kQQStatusOffline:
					return [self compareDisplayName:user];
				default:
					return NSOrderedDescending;
			}
			break;
		default:
			return [self compareDisplayName:user];
	}
}

#pragma mark -
#pragma mark NSCoding protocol

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt32:m_QQ forKey:_kKeyQQ];
	[encoder encodeInt:m_head forKey:_kKeyHead];
	[encoder encodeInt:m_level forKey:_kKeyLevel];
	[encoder encodeInt:m_upgradeDays forKey:_kKeyUpgradeDays];
	[encoder encodeInt:m_userFlag forKey:_kKeyFlag];
	[encoder encodeObject:m_userFlagEx forKey:_kKeyFlagEx];
	[encoder encodeObject:m_nick forKey:_kKeyNick];
	[encoder encodeObject:m_remarkName forKey:_kKeyName];
	[encoder encodeObject:m_signature forKey:_kKeySignature];
	[encoder encodeInt32:m_signatureModifiedTime forKey:_kKeySignatureModifiedTime];
	[encoder encodeInt:m_groupIndex forKey:_kKeyGroupIndex];
	if(m_customHead)
		[encoder encodeObject:m_customHead forKey:_kKeyCustomHead];
}

- (id)initWithCoder:(NSCoder *)decoder {
	m_QQ = [decoder decodeInt32ForKey:_kKeyQQ];
	m_head = [decoder decodeIntForKey:_kKeyHead];
	m_level = [decoder decodeIntForKey:_kKeyLevel];
	m_upgradeDays = [decoder decodeIntForKey:_kKeyUpgradeDays];
	m_userFlag = [decoder decodeIntForKey:_kKeyFlag];
	m_userFlagEx = [[decoder decodeObjectForKey:_kKeyFlagEx] retain];
	m_nick = [[decoder decodeObjectForKey:_kKeyNick] retain];
	m_remarkName = [[decoder decodeObjectForKey:_kKeyName] retain];
	m_signature = [[decoder decodeObjectForKey:_kKeySignature] retain];
	m_signatureModifiedTime = [decoder decodeInt32ForKey:_kKeySignatureModifiedTime];
	m_groupIndex = [decoder decodeIntForKey:_kKeyGroupIndex];
	m_customHead = [[decoder decodeObjectForKey:_kKeyCustomHead] retain];
	
	m_gender = kQQGenderMale;
	m_status = kQQStatusOffline;
	m_contact = [[ContactInfo alloc] init];
	[m_contact setHead:m_head];
	[m_contact setQQ:m_QQ];
	[m_contact setUserFlag:m_userFlag];
	[m_contact setNick:m_nick];
	m_clusterSpecificInfos = [[NSMutableDictionary dictionary] retain];
	m_status = kQQStatusOffline;
	m_mobileChatting = NO;
	m_statusMessage = kStringEmpty;
	return self;
}

#pragma mark -
#pragma mark helper

- (BOOL)checkFlagEx:(int)bit {
	if(m_userFlagEx == nil)
		return NO;
	else {
		const char* bytes = (const char*)[m_userFlagEx bytes];
		int index = bit / 8;
		int shift = bit % 8;
		if(index >= [m_userFlagEx length])
			return NO;
		int r = bytes[index] >> shift;
		return (r & 0x1) == 0x1;
	}
}

- (BOOL)isMember {
	return (m_userFlag & kQQFlagMember) != 0;
}

- (BOOL)isVIP {
	return (m_userFlag & kQQFlagVIP) != 0;
}

- (BOOL)isTM {
	return (m_userFlag & kQQFlagTM) != 0;
}

- (BOOL)isMobileQQ {
	return [self isBind] && (m_userFlag & kQQFlagMobile) != 0;
}

- (BOOL)isBind {
	return (m_userFlag & kQQFlagBind) != 0;
}

- (BOOL)hasCam {
	return (m_userFlag & kQQFlagCamera) != 0;
}

- (BOOL)hasSignature {
	return [self checkFlagEx:kQQFlagExHasSignature];
}

- (BOOL)hasCustomHead {
	return [self checkFlagEx:kQQFlagExHasCustomHead];
}

- (BOOL)has3DShow {
	return [self checkFlagEx:kQQFlagEx3DAvatar];
}

- (BOOL)hasAlbum {
	return [self checkFlagEx:kQQFlagExAlbum];
}

- (BOOL)hasFantasy {
	return [self checkFlagEx:kQQFlagExFantasy];
}

- (BOOL)hasHome {
	return (m_userFlag & kQQFlagHome) != 0;
}

- (BOOL)hasHuaXia {
	return [self checkFlagEx:kQQFlagExHuaXia];
}

- (BOOL)hasLove {
	return [self checkFlagEx:kQQFlagExLove];
}

- (BOOL)hasPet {
	return [self checkFlagEx:kQQFlagExPet] || [self checkFlagEx:kQQFlagExPetEx];
}

- (BOOL)hasRing {
	return (m_userFlag & kQQFlagRing) != 0;
}

- (BOOL)hasSpace {
	return [self checkFlagEx:kQQFlagExSpace];
}

- (BOOL)hasTang {
	return [self checkFlagEx:kQQFlagExTang];
}

- (BOOL)isCreator:(Cluster*)cluster {
	return m_QQ == [[cluster info] creator];
}

- (BOOL)isAdmin:(Cluster*)cluster {
	ClusterSpecificInfo* info = [m_clusterSpecificInfos objectForKey:[NSNumber numberWithUnsignedInt:[cluster internalId]]];
	return [info isAdmin];
}

- (BOOL)isStockholder:(Cluster*)cluster {
	ClusterSpecificInfo* info = [m_clusterSpecificInfos objectForKey:[NSNumber numberWithUnsignedInt:[cluster internalId]]];
	return [info isStockholder];
}

- (BOOL)isManaged:(Cluster*)cluster {
	ClusterSpecificInfo* info = [m_clusterSpecificInfos objectForKey:[NSNumber numberWithUnsignedInt:[cluster internalId]]];
	return [info isManaged];
}

- (BOOL)isSuperUser:(Cluster*)cluster {
	ClusterSpecificInfo* info = [m_clusterSpecificInfos objectForKey:[NSNumber numberWithUnsignedInt:[cluster internalId]]];
	return [[cluster info] creator] == m_QQ || [info isAdmin] || [info isStockholder];
}

- (BOOL)isOffline {
	return m_status == kQQStatusOffline;
}

- (BOOL)isVisible {
	return m_status == kQQStatusAway || 
		m_status == kQQStatusOnline ||
		m_status == kQQStatusQMe ||
		m_status == kQQStatusBusy ||
		m_status == kQQStatusMute;
}

- (NSString*)remarkOrNickOrQQ {
	NSString* dname = [self remarkName];
	if([dname isEmpty])
		dname = [self nick];
	if([dname isEmpty])
		dname = [[NSNumber numberWithUnsignedInt:m_QQ] description];
	return dname;
}

#pragma mark -
#pragma mark getter and setter

- (NSString*)shortDisplayName {
	// get preference
	PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
	BOOL bShowNick = [tool booleanValue:kPreferenceKeyShowNick];
	
	// construct from nick and remark name
	NSString* s = nil;
	if(bShowNick) {
		if(m_remarkName == nil || [m_remarkName isEmpty])
			s = m_nick;
		else
			s = [NSString stringWithFormat:@"%@ [%@]", m_nick, m_remarkName];
	} else {
		if(m_remarkName == nil || [m_remarkName isEmpty])
			s = m_nick;
		else
			s = m_remarkName;
	}
	
	// if still empty, use qq number string
	if(s == nil || [s isEmpty])
		s = [NSString stringWithFormat:@"%u", m_QQ];
	
	return s;
}

- (NSString*)displayName {
	// get preference
	PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
	BOOL bShowStatusMessage = [tool booleanValue:kPreferenceKeyShowStatusMessage];
	
	// construct from nick and remark name
	NSString* s = [self shortDisplayName];
	
	// append status message
	if(bShowStatusMessage) {
		if(m_statusMessage != nil && ![m_statusMessage isEmpty])
			s = [NSString stringWithFormat:@"%@ (%@)", s, m_statusMessage];
	}
	
	return s;
}

- (NSString*)memberDisplayName:(UInt32)internalId {
	// get preference
	PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
	BOOL bShowNick = [tool booleanValue:kPreferenceKeyShowNick];
	
	// construct from nick and remark name, or cluster name card
	ClusterSpecificInfo* info = [self getClusterSpecificInfo:internalId];
	NSString* nameCard = [[info nameCard] name];
	
	NSString* s = nil;
	if(bShowNick) {
		if(![nameCard isEmpty])
			s = [NSString stringWithFormat:@"%@ [%@]", m_nick, nameCard];
		else if(m_remarkName == nil || [m_remarkName isEmpty])
			s = m_nick;
		else
			s = [NSString stringWithFormat:@"%@ [%@]", m_nick, m_remarkName];
	} else {
		if(![nameCard isEmpty])
			s = nameCard;
		else if(m_remarkName == nil || [m_remarkName isEmpty])
			s = m_nick;
		else
			s = m_remarkName;
	}
	
	// if still empty, use qq number string
	if(s == nil || [s isEmpty])
		s = [NSString stringWithFormat:@"%u", m_QQ];
	
	return s;
}

- (ContactInfo*)contact {
	return m_contact;
}

- (void)setContact:(ContactInfo*)contact {
	[contact retain];
	[m_contact release];
	m_contact = contact;
	
	if(m_contact) {
		[self setHead:[m_contact head]];
		[self setNick:[m_contact nick]];
		[self setName:[m_contact name]];
		[self setUserFlag:[m_contact userFlag]];
		[self setMM:[m_contact isMM]];
	}
}

- (UInt32)QQ {
	return m_QQ;
}

- (UInt16)head {
	return m_head;
}

- (void)setHead:(UInt16)head {
	m_head = head;
	if(m_contact)
		[m_contact setHead:head];
}

- (char)age {
	return m_contact ? [m_contact age] : 0;
}

- (void)setAge:(char)age {
	if(m_contact)
		[m_contact setAge:age];
}

- (BOOL)isMM {
	return m_gender == kQQGenderFemale;
}

- (void)setMM:(BOOL)mm {
	m_gender = mm ? kQQGenderFemale : kQQGenderMale;
}

- (int)level {
	return m_level;
}

- (void)setLevel:(int)level {
	m_level = level;
}

- (int)upgradeDays {
	return m_upgradeDays;
}

- (void)setUpgradeDays:(int)days {
	m_upgradeDays = days;
}

- (int)userFlag {
	return m_userFlag;
}

- (void)setUserFlag:(int)flag {
	m_userFlag = flag;
	if(m_contact)
		[m_contact setUserFlag:flag];
}

- (NSString*)nick {
	return m_nick ? m_nick : kStringEmpty;
}

- (void)setNick:(NSString*)nick {
	[nick retain];
	[m_nick release];
	m_nick = nick;
}

- (NSString*)name {
	return m_name ? m_name : kStringEmpty;
}

- (void)setName:(NSString*)name {
	[name retain];
	[m_name release];
	m_name = name;
	
	if(m_contact)
		[m_contact setName:name];
}

- (NSString*)remarkName {
	return m_remarkName ? m_remarkName : kStringEmpty;
}

- (void)setRemarkName:(NSString*)remarkName {
	[remarkName retain];
	[m_remarkName release];
	m_remarkName = remarkName;
}

- (NSString*)signature {
	return m_signature ? m_signature : kStringEmpty;
}

- (void)setSignature:(NSString*)signature {
	[signature retain];
	[m_signature release];
	m_signature = signature;
}

- (char)status {
	return m_status;
}

- (void)setStatus:(char)status {
	m_status = status;
}

- (NSData*)userFlagEx {
	return m_userFlagEx;
}

- (void)setUserFlagEx:(NSData*)userFlagEx {
	[userFlagEx retain];
	[m_userFlagEx release];
	m_userFlagEx = userFlagEx;
}

- (UInt32)signatureModifiedTime {
	return m_signatureModifiedTime;
}

- (void)setSignatureModifiedTime:(UInt32)time {
	m_signatureModifiedTime = time;
}

- (int)groupIndex {
	return m_groupIndex;
}

- (void)setGroupIndex:(int)groupIndex {
	m_groupIndex = groupIndex;
}

- (ClusterSpecificInfo*)getClusterSpecificInfo:(UInt32)internalId {
	ClusterSpecificInfo* info = [m_clusterSpecificInfos objectForKey:[NSNumber numberWithUnsignedInt:internalId]];
	if(info == nil) {
		info = [[ClusterSpecificInfo alloc] init];
		[m_clusterSpecificInfos setObject:info forKey:[NSNumber numberWithUnsignedInt:internalId]];
	} else
		[info retain];
	return [info autorelease];
}

- (void)setRoleFlag:(UInt32)internalId role:(UInt32)role {
	ClusterSpecificInfo* info = [self getClusterSpecificInfo:internalId];
	[info setRoleFlag:role];
}

- (ClusterNameCard*)nameCard:(UInt32)internalId {
	ClusterSpecificInfo* info = [self getClusterSpecificInfo:internalId];
	return [info nameCard];
}

- (void)setNameCard:(UInt32)internalId card:(ClusterNameCard*)card {
	ClusterSpecificInfo* info = [self getClusterSpecificInfo:internalId];
	[info setNameCard:card];
}

- (UInt32)lastTalkTime:(UInt32)internalId {
	ClusterSpecificInfo* info = [self getClusterSpecificInfo:internalId];
	return [info lastTalkTime];
}

- (void)setLastTalkTime:(UInt32)internalId time:(UInt32)time {
	ClusterSpecificInfo* info = [self getClusterSpecificInfo:internalId];
	[info setLastTalkTime:time];
}

- (const char*)ip {
	return m_ip;
}

- (void)setIp:(const char*)ip {
	memcpy(m_ip, ip, 4 * sizeof(char));
}

- (UInt16)port {
	return m_port;
}

- (void)setPort:(UInt16)port {
	m_port = port;
}

- (BOOL)mobileChatting {
	return m_mobileChatting;
}

- (void)setMobileChatting:(BOOL)value {
	m_mobileChatting = value;
}

- (NSString*)statusMessage {
	return m_statusMessage;
}

- (void)setStatusMessage:(NSString*)statusMessage {
	[statusMessage retain];
	[m_statusMessage release];
	m_statusMessage = statusMessage;
}

- (CustomHead*)customHead {
	return m_customHead;
}

- (void)setCustomHead:(CustomHead*)head {
	[head retain];
	[m_customHead release];
	m_customHead = head;
}

@end
