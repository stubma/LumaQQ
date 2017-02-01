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
#import "User.h"
#import "Cluster.h"
#import "Group.h"
#import "Dummy.h"

@class MainWindowController;

@interface GroupManager : NSObject {
	UInt32 m_QQ;
	
	// friend groups
	NSMutableArray* m_groups;
	
	// default groups
	Group* m_strangerGroup;
	Group* m_blacklistGroup;
	Group* m_clusterGroup;
	Group* m_mobileGroup;
	
	// recent contact list
	NSMutableArray* m_recentContacts;
	
	// hash map for user and cluster
	NSMutableDictionary* m_userRegistry;
	NSMutableDictionary* m_clusterRegistry;
	NSMutableDictionary* m_tempClusterRegistry;
	NSMutableDictionary* m_mobileRegistry;
	
	// dialogs dummy
	Dummy* m_dialogsDummy;
	
	// dialogs, element is Cluster
	NSMutableArray* m_dialogs;
	
	// dirty flag
	BOOL m_dirty;
	
	// change flag, it is not same as dirty
	// dirty means groups.plist must be saved
	// changed means friend group setting changed, need to be uploaded
	BOOL m_changed;
	
	// my object
	User* m_me;
	
	// for tell the domain
	MainWindowController* m_domain;
}

// init
- (id)initWithQQ:(UInt32)QQ domain:(MainWindowController*)domain;

// load/save/initialize
- (void)loadGroups;
- (void)saveGroups;
- (void)registerGroup:(Group*)g;
- (void)initializeGroups:(NSArray*)groupNames;

// sort
- (void)sortAll;

// getter and setter
- (UInt32)QQ;
- (NSArray*)recentContacts;
- (Group*)group:(int)index;
- (Group*)clusterGroup;
- (Group*)strangerGroup;
- (Group*)blacklistGroup;
- (Group*)mobileGroup;

// user type check
- (BOOL)isUserFriendly:(User*)user;
- (BOOL)isUserStranger:(User*)user;
- (BOOL)isUserBlacklist:(User*)user;

// edit method
- (void)addRecentContact:(id)object;
- (void)removeRecentContactAtIndex:(int)index;
- (void)removeAllRecentContacts;
- (void)addFriendGroups:(NSArray*)friendGroups;
- (void)addFriends:(NSArray*)friends;
- (void)setUserProperty:(NSArray*)properties;
- (void)setFriendLevel:(NSArray*)levels;
- (void)setSignature:(NSArray*)signatures;
- (void)setRemarks:(NSArray*)remarks;
- (void)setClusterInfo:(ClusterInfo*)info;
- (void)setSubjects:(UInt32)clusterInternalId subjects:(NSArray*)subjects;
- (void)setMembers:(UInt32)internalId members:(NSArray*)members;
- (void)setClusterNameCards:(UInt32)internalId nameCards:(NSArray*)nameCards;
- (void)setOrganizations:(UInt32)internalId organizations:(NSArray*)organizations;
- (void)setMemberInfos:(NSArray*)memberInfos;
- (void)setOnlineMembers:(NSArray*)onlineMembers;
- (BOOL)removeUser:(User*)user;
- (BOOL)removeCluster:(Cluster*)cluster;
- (BOOL)removeGroup:(Group*)group;
- (BOOL)removeGroupAt:(int)groupIndex;
- (void)addUser:(User*)user groupIndex:(int)groupIndex;
- (void)addUser:(User*)user group:(Group*)group;
- (int)moveUser:(User*)user toGroupIndex:(int)groupIndex;
- (int)moveUser:(User*)user toGroup:(Group*)group;
- (void)moveAllUsersFrom:(int)fromGroup to:(int)toGroup;
- (void)addCluster:(Cluster*)cluster;
- (Group*)addFriendlyGroup:(NSString*)name;
- (void)setGroupName:(Group*)group name:(NSString*)name;
- (void)addMobile:(Mobile*)mobile;
- (void)removeMobile:(Mobile*)mobile;

// read-only method
- (BOOL)dirty;
- (void)setDirty:(BOOL)flag;
- (BOOL)changed;
- (void)setChanged:(BOOL)flag;
- (int)userCount;
- (int)userCount:(int)groupIndex;
- (int)friendCount;
- (int)clusterCount;
- (int)tempClusterCount;
- (int)userGroupCount;
- (int)mobileCount;
- (int)friendlyGroupCount;
- (int)strangerGroupIndex;
- (int)blacklistGroupIndex;
- (BOOL)hasUser:(UInt32)QQ;
- (Mobile*)mobileAtIndex:(int)index;
- (Mobile*)mobile:(NSString*)mobile;
- (User*)user:(UInt32)QQ;
- (Cluster*)cluster:(UInt32)internalId;
- (Cluster*)clusterByExternalId:(UInt32)externalId;
- (NSArray*)allUsers;
- (NSArray*)allUserQQs;
- (NSArray*)allClusters;
- (NSArray*)allClusterInternalIds;
- (NSArray*)allUserGroups;
- (NSArray*)friendlyGroupNamesExceptMyFriends;
- (NSArray*)friendlyGroups;
- (NSDictionary*)friendGroupMapping;
- (Dummy*)dialogsDummy;
- (int)dialogCount;
- (Cluster*)dialog:(UInt32)internalId;
- (Cluster*)dialogAtIndex:(int)index;
- (int)indexOfGroup:(Group*)group;

@end
