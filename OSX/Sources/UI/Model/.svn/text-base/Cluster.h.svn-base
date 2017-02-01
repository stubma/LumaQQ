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
#import "ClusterInfo.h"
#import "Dummy.h"
#import "User.h"
#import "Organization.h"

@class MainWindowController;

@interface Cluster : NSObject <NSCoding, NSCopying> {
	UInt32 m_externalId;
	UInt32 m_internalId;
	UInt32 m_parentId;
	NSString* m_name;
	ClusterInfo* m_info;
	BOOL m_permanent;
	char m_tempType; // valid when m_permanent is NO
	char m_notificationRight;
	char m_messageSetting;
	BOOL m_saveMessageSettingInServer;
	
	// ui info
	float m_inputBoxProportion;
	
	// two default dummy
	Dummy* m_organizationsDummy;
	Dummy* m_subjectsDummy;
	
	// sub clusters
	NSMutableArray* m_subClusters;
	
	// members
	NSMutableArray* m_members;
	
	// organizations
	NSMutableDictionary* m_organizations;
	
	// used for QQCell
	UInt32 m_messageCount;
	int m_frame;
	
	// used to describe what operation is performing on this cluster
	NSString* m_operationSuffix;
	
	// cluster name card version id
	UInt32 m_nameCardVersionId;
	
	// for tell the domain
	MainWindowController* m_domain;
}

- (id)initWithInternalId:(UInt32)internalId domain:(MainWindowController*)domain;
- (void)increaseMessageCount;

// compare
- (NSComparisonResult)compare:(Cluster*)cluster;
- (NSComparisonResult)compareName:(Cluster*)cluster;

// sort
- (void)sortAll;

// getter and setter
- (BOOL)isSubject;
- (BOOL)isDialog;
- (NSString*)operationSuffix;
- (void)setOperationSuffix:(NSString*)suffix;
- (UInt32)externalId;
- (void)setExternalId:(UInt32)externalId;
- (UInt32)internalId;
- (void)setInternalId:(UInt32)internalId;
- (UInt32)parentId;
- (void)setParentId:(UInt32)parentId;
- (NSString*)name;
- (void)setName:(NSString*)name;
- (ClusterInfo*)info;
- (void)setClusterInfo:(ClusterInfo*)info;
- (BOOL)permanent;
- (void)setPermanent:(BOOL)permanent;
- (char)tempType;
- (void)setTempType:(char)tempType;
- (Dummy*)organizationsDummy;
- (Dummy*)subjectsDummy;
- (NSMutableArray*)subClusters;
- (NSEnumerator*)subClusterEnumerator;
- (void)setSubClusters:(NSMutableArray*)subClusters;
- (void)addSubCluster:(Cluster*)subCluster;
- (void)removeSubCluster:(Cluster*)subCluster;
- (int)subClusterCount;
- (Cluster*)subCluster:(UInt32)internalId;
- (Cluster*)subClusterAtIndex:(int)index;
- (void)addMember:(User*)member;
- (void)setMembers:(NSMutableArray*)members;
- (NSMutableArray*)members;
- (int)memberCount;
- (int)onlineMemberCount;
- (User*)memberAtIndex:(int)index;
- (void)addOrganization:(Organization*)org;
- (NSMutableDictionary*)organizations;
- (void)setOrganizations:(NSMutableDictionary*)org;
- (Organization*)organization:(UInt8)ID;
- (void)clearMembers;
- (User*)memberInOrganization:(UInt8)ID index:(int)index;
- (int)memberCount:(UInt8)orgId;
- (int)organizationCount:(int)level;
- (int)unorganizedMemberCount;
- (User*)unorganizedMember:(int)index;
- (Organization*)organizationInLevel:(int)level index:(int)index;
- (char)notificationRight;
- (void)setNotificationRight:(char)right;
- (char)messageSetting;
- (void)setMessageSetting:(char)messageSetting;
- (BOOL)saveMessageSettingInServer;
- (void)setSaveMessageSettingInServer:(BOOL)save;
- (UInt32)messageCount;
- (void)setMessageCount:(UInt32)count;
- (int)frame;
- (void)setFrame:(int)frame;
- (UInt32)nameCardVersionId;
- (void)setNameCardVersionId:(UInt32)versionId;
- (float)inputBoxProportion;
- (void)setInputBoxProportion:(float)proportion;
- (MainWindowController*)domain;
- (void)setDomain:(MainWindowController*)domain;

@end
