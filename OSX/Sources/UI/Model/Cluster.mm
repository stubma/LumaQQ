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

#import "Cluster.h"
#import "Constants.h"
#import "LocalizedStringTool.h"

// encoding key
#define _kKeyInternalId @"InternalId"
#define _kKeyExternalId @"ExternalId"
#define _kKeyParentId @"ParentId"
#define _kKeyPermanent @"Permanent"
#define _kKeyLevelFlag @"LevelFlag"
#define _kKeyTempType @"TempType"
#define _kKeyClusterName @"ClusterName"
#define _kKeySubClusters @"SubClusters"
#define _kKeyOrganizations @"Organizations"
#define _kKeyMessageSetting @"MessageSetting"
#define _kKeyInputBoxPortion @"InputBoxPortion"
#define _kKeyCreator @"Creator"

@implementation Cluster

- (id)initWithInternalId:(UInt32)internalId domain:(MainWindowController*)domain {
	self = [super init];
	if(self) {
		m_domain = [domain retain];
		m_internalId = internalId;
		m_externalId = 0;
		m_parentId = 0;
		m_permanent = YES;
		m_organizationsDummy = [[Dummy alloc] initWithType:kDummyOrganizations name:@"Organizations"];
		[m_organizationsDummy setClusterInternalId:internalId];
		m_subjectsDummy = [[Dummy alloc] initWithType:kDummySubjects name:@"Subjects"];
		[m_subjectsDummy setClusterInternalId:internalId];
		m_subClusters = [[NSMutableArray array] retain];
		m_members = [[NSMutableArray array] retain];
		m_organizations = [[NSMutableDictionary dictionary] retain];
		m_notificationRight = kQQClusterNotificationAllowUserSend | kQQClusterNotificationAllowAdminSend;
		m_messageSetting = kQQClusterMessageAccept;
		m_saveMessageSettingInServer = YES;
		m_info = [[ClusterInfo alloc] init];
		m_messageCount = 0;
		m_frame = 0;
		m_operationSuffix = kStringEmpty;
		m_nameCardVersionId = 0;
		m_inputBoxProportion = 0.2;
	}
	return self;
}

- (void) dealloc {
	[m_domain release];
	[m_name release];
	[m_info release];
	[m_organizationsDummy release];
	[m_subjectsDummy release];
	[m_subClusters release];
	[m_members release];
	[m_organizations release];
	[m_operationSuffix release];
	[super dealloc];
}

- (BOOL)isEqual:(id)anObject {
	if([anObject isKindOfClass:[Cluster class]])
		return m_internalId == [(Cluster*)anObject internalId];
	else
		return NO;
}

- (unsigned)hash {
	return m_internalId;
}

- (void)increaseMessageCount {
	m_messageCount++;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kModelMessageCountChangedNotificationName
														object:self
													  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(m_messageCount - 1)], kUserInfoOldMessageCount, [NSNumber numberWithInt:m_messageCount], kUserInfoNewMessageCount, m_domain, kUserInfoDomain, nil]];
}

- (id)copyWithZone:(NSZone *)zone {
	return [self retain];
}

#pragma mark -
#pragma mark NSCoding protocol

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt32:m_internalId forKey:_kKeyInternalId];
	[encoder encodeInt32:m_externalId forKey:_kKeyExternalId];
	[encoder encodeInt32:m_parentId forKey:_kKeyParentId];
	[encoder encodeBool:m_permanent forKey:_kKeyPermanent];
	[encoder encodeInt32:[m_info levelFlag] forKey:_kKeyLevelFlag];
	[encoder encodeInt:m_tempType forKey:_kKeyTempType];
	[encoder encodeObject:m_name forKey:_kKeyClusterName];
	[encoder encodeObject:m_subClusters forKey:_kKeySubClusters];
	[encoder encodeObject:m_organizations forKey:_kKeyOrganizations];
	[encoder encodeInt:m_messageSetting forKey:_kKeyMessageSetting];
	[encoder encodeFloat:m_inputBoxProportion forKey:_kKeyInputBoxPortion];
	[encoder encodeInt32:[m_info creator] forKey:_kKeyCreator];
}

- (id)initWithCoder:(NSCoder *)decoder {
	// create cluster info
	m_info = [[ClusterInfo alloc] init];
	
	// decoder
	m_internalId = [decoder decodeInt32ForKey:_kKeyInternalId];
	m_externalId = [decoder decodeInt32ForKey:_kKeyExternalId];
	m_parentId = [decoder decodeInt32ForKey:_kKeyParentId];
	m_permanent = [decoder decodeBoolForKey:_kKeyPermanent];
	m_tempType = [decoder decodeIntForKey:_kKeyTempType];
	[m_info setCreator:[decoder decodeInt32ForKey:_kKeyCreator]];
	m_name = [[decoder decodeObjectForKey:_kKeyClusterName] retain];
	m_subClusters = [[decoder decodeObjectForKey:_kKeySubClusters] retain];
	m_organizations = [[decoder decodeObjectForKey:_kKeyOrganizations] retain];
	m_messageSetting = [decoder decodeIntForKey:_kKeyMessageSetting];
	m_inputBoxProportion = [decoder decodeFloatForKey:_kKeyInputBoxPortion];
	if(m_inputBoxProportion <= 0)
		m_inputBoxProportion = 0.2;
	
	// initialize dummy
	m_organizationsDummy = [[Dummy alloc] initWithType:kDummyOrganizations name:L(@"LQClusterOrganizations")];
	[m_organizationsDummy setClusterInternalId:m_internalId];
	m_subjectsDummy = [[Dummy alloc] initWithType:kDummySubjects name:L(@"LQClusterSubjects")];
	[m_subjectsDummy setClusterInternalId:m_internalId];
	
	// initialize other
	m_members = [[NSMutableArray array] retain];
	m_notificationRight = kQQClusterNotificationAllowUserSend | kQQClusterNotificationAllowAdminSend;
	m_saveMessageSettingInServer = YES;
	[m_info setLevelFlag:[decoder decodeInt32ForKey:_kKeyLevelFlag]];
	m_messageCount = 0;
	m_frame = 0;
	m_operationSuffix = kStringEmpty;
	m_nameCardVersionId = 0;
	
	return self;
}

#pragma mark -
#pragma mark compare

- (NSComparisonResult)compare:(Cluster*)cluster {
	if(m_externalId < [cluster externalId])
		return NSOrderedAscending;
	else if(m_externalId > [cluster externalId])
		return NSOrderedDescending;
	else
		return NSOrderedSame;
}

- (NSComparisonResult)compareName:(Cluster*)cluster {
	return [m_name compare:[cluster name]];
}

- (void)sortAll {
	[m_members sortUsingSelector:@selector(compare:)];
	[m_subClusters sortUsingSelector:@selector(compareName:)];
}

#pragma mark -
#pragma mark getter and setter

- (BOOL)isSubject {
	return m_permanent == NO && m_tempType == kQQTempClusterTypeSubject;
}

- (BOOL)isDialog {
	return m_permanent == NO && m_tempType == kQQTempClusterTypeDialog;
}

- (void)addMember:(User*)member {
	[m_members addObject:member];
}

- (int)subClusterCount {
	return [m_subClusters count];
}

- (Cluster*)subCluster:(UInt32)internalId {
	int count = [m_subClusters count];
	for(int i = 0; i < count; i++) {
		Cluster* sub = [m_subClusters objectAtIndex:i];
		if([sub internalId] == internalId)
			return sub;
	}
	return nil;
}

- (void)clearMembers {
	[m_members removeAllObjects];
}

- (User*)memberInOrganization:(UInt8)ID index:(int)index {
	NSEnumerator* e = [m_members objectEnumerator];
	while(User* u = [e nextObject]) {
		if([u organization:m_internalId] == ID) {
			index--;
			if(index < 0)
				return u;
		}
	}
	return nil;
}

- (int)memberCount:(UInt8)orgId {
	int ret = 0;
	int count = [m_members count];
	for(int i = 0; i < count; i++) {
		User* u = [m_members objectAtIndex:i];
		if([u organization:m_internalId] == orgId) 
			ret++;
	}
	return ret;
}

- (NSEnumerator*)subClusterEnumerator {
	return [m_subClusters objectEnumerator];
}

- (Cluster*)subClusterAtIndex:(int)index {
	return [m_subClusters objectAtIndex:index];
}

- (Dummy*)organizationsDummy {
	return m_organizationsDummy;
}

- (Dummy*)subjectsDummy {
	return m_subjectsDummy;
}

- (UInt32)externalId {
	return m_externalId;
}

- (void)setExternalId:(UInt32)externalId {
	m_externalId = externalId;
}

- (UInt32)internalId {
	return m_internalId;
}

- (void)setInternalId:(UInt32)internalId {
	m_internalId = internalId;
}

- (UInt32)parentId {
	return m_parentId;
}

- (void)setParentId:(UInt32)parentId {
	m_parentId = parentId;
}

- (NSString*)name {
	return m_name ? m_name : kStringEmpty;
}

- (void)setName:(NSString*)name {
	[name retain];
	[m_name release];
	m_name = name;
}

- (ClusterInfo*)info {
	return m_info;
}

- (void)setClusterInfo:(ClusterInfo*)info {
	[info retain];
	[m_info release];
	m_info = info;
	
	if(m_info) {
		[self setName:[m_info name]];
		[self setInternalId:[m_info internalId]];
		[self setExternalId:[m_info externalId]];
		[self setParentId:[m_info parentId]];
	}
}

- (BOOL)permanent {
	return m_permanent;
}

- (void)setPermanent:(BOOL)permanent {
	m_permanent = permanent;
}

- (char)tempType {
	return m_tempType;
}

- (void)setTempType:(char)tempType {
	m_tempType = tempType;
}

- (NSMutableArray*)subClusters {
	return m_subClusters;
}

- (void)setSubClusters:(NSMutableArray*)subClusters {
	[subClusters retain];
	[m_subClusters release];
	m_subClusters = subClusters;
}

- (void)addSubCluster:(Cluster*)subCluster {
	[m_subClusters addObject:subCluster];
}

- (void)removeSubCluster:(Cluster*)subCluster {
	[m_subClusters removeObject:subCluster];
}

- (int)memberCount {
	return [m_members count];
}

- (int)onlineMemberCount {
	int count = 0;
	NSEnumerator* e = [m_members objectEnumerator];
	while(User* user = [e nextObject]) {
		if([user isVisible])
			count++;
	}
	return count;
}

- (User*)memberAtIndex:(int)index {
	if(index < 0 || index >= [m_members count])
		return nil;
	return [m_members objectAtIndex:index];
}

- (void)setMembers:(NSMutableArray*)members {
	[m_members addObjectsFromArray:members];
}

- (NSMutableArray*)members {
	return m_members;
}

- (void)addOrganization:(Organization*)org {
	[org setClusterInternalId:m_internalId];
	[m_organizations setObject:org forKey:[NSNumber numberWithInt:[org ID]]];
}

- (Organization*)organization:(UInt8)ID {
	return [m_organizations objectForKey:[NSNumber numberWithInt:ID]];
}

- (NSMutableDictionary*)organizations {
	return m_organizations;
}

- (void)setOrganizations:(NSMutableDictionary*)org {
	[org retain];
	[m_organizations release];
	m_organizations = org;
}

- (int)organizationCount:(int)level {
	int ret = 0;
	NSEnumerator* e = [m_organizations objectEnumerator];
	while(Organization* org = [e nextObject]) {
		if([org level] == level)
			ret++;
	}
	return ret;
}

- (int)unorganizedMemberCount {
	int ret = 0;
	NSEnumerator* e = [m_members objectEnumerator];
	while(User* u = [e nextObject]) {
		if([self organization:[u organization:m_internalId]] == nil)
			ret++;
	}
	return ret;
}

- (User*)unorganizedMember:(int)index {
	NSEnumerator* e = [m_members objectEnumerator];
	while(User* u = [e nextObject]) {
		if([self organization:[u organization:m_internalId]] == nil) {
			index--;
			if(index < 0)
				return u;
		}
	}
	return nil;
}

- (Organization*)organizationInLevel:(int)level index:(int)index {
	NSEnumerator* e = [m_organizations objectEnumerator];
	while(Organization* org = [e nextObject]) {
		if([org level] == level) {
			index--;
			if(index < 0)
				return org;
		}
	}
	return nil;
}

- (char)notificationRight {
	return m_notificationRight;
}

- (void)setNotificationRight:(char)right {
	m_notificationRight = right;
}

- (char)messageSetting {
	return m_messageSetting;
}

- (void)setMessageSetting:(char)messageSetting {
	m_messageSetting = messageSetting;
}

- (BOOL)saveMessageSettingInServer {
	return m_saveMessageSettingInServer;
}

- (void)setSaveMessageSettingInServer:(BOOL)save {
	m_saveMessageSettingInServer = save;
}

- (UInt32)messageCount {
	return m_messageCount;
}

- (void)setMessageCount:(UInt32)count {
	NSNumber* oldCount = [NSNumber numberWithInt:m_messageCount];
	m_messageCount = count;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kModelMessageCountChangedNotificationName
														object:self
													  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:oldCount, kUserInfoOldMessageCount, [NSNumber numberWithInt:count], kUserInfoNewMessageCount, m_domain, kUserInfoDomain, nil]];
}

- (int)frame {
	return m_frame;
}

- (void)setFrame:(int)frame {
	m_frame = frame;
}

- (NSString*)operationSuffix {
	return m_operationSuffix;
}

- (void)setOperationSuffix:(NSString*)suffix {
	[suffix retain];
	[m_operationSuffix release];
	m_operationSuffix = suffix;
}

- (UInt32)nameCardVersionId {
	return m_nameCardVersionId;
}

- (void)setNameCardVersionId:(UInt32)versionId {
	m_nameCardVersionId = versionId;
}

- (float)inputBoxProportion {
	return m_inputBoxProportion;
}

- (void)setInputBoxProportion:(float)proportion {
	m_inputBoxProportion = proportion;
}

- (MainWindowController*)domain {
	return m_domain;
}

- (void)setDomain:(MainWindowController*)domain {
	[domain retain];
	[m_domain release];
	m_domain = domain;
}

@end
