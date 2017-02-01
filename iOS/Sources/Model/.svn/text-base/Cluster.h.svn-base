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
#import "ClusterInfo.h"
#import "User.h"

@interface Cluster : NSObject <NSCopying, NSCoding> {
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

	// sub clusters
	NSMutableArray* m_subClusters;
	
	// members
	NSMutableArray* m_members;

	// cluster name card version id
	UInt32 m_nameCardVersionId;
	
	// used for outline
	BOOL m_expanded;
}

- (id)initWithInternalId:(UInt32)internalId;

// compare
- (NSComparisonResult)compare:(Cluster*)cluster;
- (NSComparisonResult)compareName:(Cluster*)cluster;

// sort
- (void)sortAll;

// getter and setter
- (NSString*)displayName;
- (BOOL)isSubject;
- (BOOL)isDialog;
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
- (void)clearMembers;
- (char)notificationRight;
- (void)setNotificationRight:(char)right;
- (char)messageSetting;
- (void)setMessageSetting:(char)messageSetting;
- (BOOL)saveMessageSettingInServer;
- (void)setSaveMessageSettingInServer:(BOOL)save;
- (UInt32)nameCardVersionId;
- (void)setNameCardVersionId:(UInt32)versionId;
- (BOOL)expanded;
- (void)setExpanded:(BOOL)flag;

@end
