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

#import "GroupManager.h"
#import "FriendGroup.h"
#import "UserProperty.h"
#import "Signature.h"
#import "SubCluster.h"
#import "QQConstants.h"
#import "Member.h"
#import "LocalizedStringTool.h"
#import "FileTool.h"
#import "Constants.h"

#define _kKeyFriendlyGroups @"FriendlyGroup"
#define _kKeyStrangerGroup @"StrangerGroup"
#define _kKeyBlacklistGroup @"BlacklistGroup"
#define _kKeyClusterGroup @"ClusterGroup"

@implementation GroupManager

- (id) init {
	NSException* e = [NSException exceptionWithName:@"InitializationException"
											 reason:@"Don't use init of GroupManager"
										   userInfo:nil];
	[e raise];
	return nil;
}

- (id)initWithQQ:(UInt32)QQ {
	self = [super init];
	if (self != nil) {
		m_QQ = QQ;
		m_dirty = NO;
		m_changed = NO;
		m_userRegistry = [[NSMutableDictionary dictionary] retain];
		m_clusterRegistry = [[NSMutableDictionary dictionary] retain];
		
		// create me
		m_me = [[User alloc] initWithQQ:QQ];
		[m_userRegistry setObject:m_me forKey:[NSNumber numberWithUnsignedInt:QQ]];
	}
	return self;
}

- (void) dealloc {
	[m_groups release];
	[m_strangerGroup release];
	[m_blacklistGroup release];
	[m_clusterGroup release];
	[m_userRegistry release];
	[m_clusterRegistry release];
	[m_me release];
	[super dealloc];
}

#pragma mark -
#pragma mark load/save/initialize

- (void)loadGroups {
	// get path
	NSString* sFilePath = [FileTool getFilePath:m_QQ ForFile:kLQFileGroups];
	
	NSData* data = [NSData dataWithContentsOfFile:sFilePath];
	if(data) {
		NSKeyedUnarchiver* unar = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		m_groups = [[unar decodeObjectForKey:_kKeyFriendlyGroups] retain];
		m_strangerGroup = [[unar decodeObjectForKey:_kKeyStrangerGroup] retain];
		m_blacklistGroup = [[unar decodeObjectForKey:_kKeyBlacklistGroup] retain];
		m_clusterGroup = [[unar decodeObjectForKey:_kKeyClusterGroup] retain];
		[unar finishDecoding];
		[unar release];
		
		// check error
		if(m_groups == nil ||
		   m_strangerGroup == nil ||
		   m_blacklistGroup == nil ||
		   m_clusterGroup == nil) {
			// release all and renew
			[m_groups release];
			[m_strangerGroup release];
			[m_blacklistGroup release];
			[m_clusterGroup release];
			m_groups = nil;
			m_strangerGroup = nil;
			m_blacklistGroup = nil;
			m_clusterGroup = nil;
			[self initializeGroups:[NSArray array]];
		} else {
			// hash users and clusters
			Group* g;
			NSEnumerator* groupEnum = [m_groups objectEnumerator];
			while(g = [groupEnum nextObject]) {
				[self registerGroup:g];
			}
			[self registerGroup:m_strangerGroup];
			[self registerGroup:m_blacklistGroup];
			[self registerGroup:m_clusterGroup];
		}
	} else
		[self initializeGroups:[NSArray array]];
}

- (void)saveGroups {
	if(!m_dirty)
		return;	
	m_dirty = NO;
	
	// get path
	NSString* sFilePath = [FileTool getFilePath:m_QQ ForFile:kLQFileGroups];
	
	// save to file
	NSMutableData* data = [NSMutableData data];
	NSKeyedArchiver* ar = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[ar setOutputFormat:NSPropertyListXMLFormat_v1_0];
	[ar encodeObject:m_groups forKey:_kKeyFriendlyGroups];
	[ar encodeObject:m_strangerGroup forKey:_kKeyStrangerGroup];
	[ar encodeObject:m_blacklistGroup forKey:_kKeyBlacklistGroup];
	[ar encodeObject:m_clusterGroup forKey:_kKeyClusterGroup];
	[ar finishEncoding];
	[data writeToFile:sFilePath atomically:YES];
}

- (void)registerGroup:(Group*)g {
	NSEnumerator* e = nil;
	if([g isUser]) {
		User* u;
		e = [g userEnumerator];
		while(u = [e nextObject]) {
			[m_userRegistry setObject:u forKey:[NSNumber numberWithUnsignedInt:[u QQ]]];
		}						
	} else if([g isCluster]) {
		Cluster* c;
		e = [g clusterEnumerator];
		while(c = [e nextObject]) {
			[m_clusterRegistry setObject:c forKey:[NSNumber numberWithUnsignedInt:[c internalId]]];
		}
	}
}

- (void)registerUser:(User*)u {
	NSNumber* key = [NSNumber numberWithUnsignedInt:[u QQ]];
	if([m_userRegistry objectForKey:key] == nil)
		[m_userRegistry setObject:u forKey:key];
}

// 
// initialize groups, this will clear all groups and reconstruct them again
// not including "stranger" and "blacklist"
//
- (void)initializeGroups:(NSArray*)groupNames {
	// create
	if(m_groups == nil)
		m_groups = [[NSMutableArray array] retain];
	if(m_strangerGroup == nil)
		m_strangerGroup = [[Group alloc] initWithFlag:kGroupUser name:L(@"GroupStranger")];
	if(m_blacklistGroup == nil)
		m_blacklistGroup = [[Group alloc] initWithFlag:(kGroupUser | kGroupBlacklist) name:L(@"GroupBlacklist")];
	if(m_clusterGroup == nil)
		m_clusterGroup = [[Group alloc] initWithFlag:kGroupCluster];
	
	// clean
	[m_groups removeAllObjects];
	
	// reset user group index
	User* u;
	NSEnumerator* e = [[m_userRegistry allValues] objectEnumerator];
	while(u = [e nextObject]) {
		[u setGroupIndex:kGroupIndexUndefined];
	}
	
	// add me
	[m_userRegistry setObject:m_me forKey:[NSNumber numberWithUnsignedInt:m_QQ]];
	
	// add my friends group
	if([m_groups count] == 0) {
		Group* g = [[Group alloc] initWithFlag:(kGroupUser | kGroupFriendly) name:L(@"GroupMyFriends")];
		[m_groups addObject:g];
		[g release];
	}
	
	// add normal friendly group
	int i;
	int count = [m_groups count];
	int nameCount = [groupNames count];
	for(i = 0; i < nameCount; i++) {
		// get group object or create a new one
		Group* g = nil;
		if(i + 1 < count)
			g = [self group:(i + 1)];
		else {
			g = [[Group alloc] init];
			[m_groups addObject:g];
			[g release];
		}		
		
		// set group name
		[g setName:[groupNames objectAtIndex:i]];
	}
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)QQ {
	return m_QQ;
}

- (User*)me {
	return [self user:m_QQ];
}

- (Group*)group:(int)index {
	if(index < 0)
		return nil;
	
	// if index exceed user friendly group, return others
	int count = [m_groups count];
	if(index >= count) {
		switch(index - count) {
			case 0:
				return m_strangerGroup;
			case 1:
				return m_blacklistGroup;
			case 2:
				return m_clusterGroup;
			default:
				return nil;
		}
	} else
		return [m_groups objectAtIndex:index];
}

- (Group*)clusterGroup {
	return m_clusterGroup;
}

- (Group*)strangerGroup {
	return m_strangerGroup;
}

- (Group*)blacklistGroup {
	return m_blacklistGroup;
}

#pragma mark -
#pragma mark for data source

- (int)userTableRowCount {
	int row = [self userGroupCount];
	if([m_strangerGroup expanded])
		row += [m_strangerGroup userCount];
	if([m_blacklistGroup expanded])
		row += [m_blacklistGroup userCount];
	int count = [m_groups count];
	int i;
	for(i = 0; i < count; i++) {
		Group* g = [m_groups objectAtIndex:i];
		if([g expanded])
			row += [g userCount];
	}
	return row;
}

- (int)clusterTableRowCount {
	int row = 0;
	int i;
	NSArray* clusters = [m_clusterGroup clusters];
	int size = [clusters count];
	for(i = 0; i < size; i++) {
		Cluster* c = [clusters objectAtIndex:i];
		if([c expanded])
			row += [c memberCount];
	}
	row += [clusters count];
	return row;
}

- (id)linearLocate:(int)index {
	if(index < 0)
		return nil;
	
	int i;
	int size = [m_groups count];
	for(i = 0; i < size; i++) {
		Group* g = [m_groups objectAtIndex:i];
		if(index == 0)
			return g;
		index--;
		
		// check user count
		if([g expanded]) {
			int userCount = [g userCount];
			if(index < userCount)
				return [g user:index];
			index -= userCount;
		}
	}
	
	if(index == 0)
		return m_strangerGroup;
	index--;
	if([m_strangerGroup expanded]) {
		int strangerCount = [m_strangerGroup userCount];
		if(index < strangerCount)
			return [m_strangerGroup user:index];
		index -= strangerCount;
	}
	
	if(index == 0)
		return m_blacklistGroup;
	index--;
	if([m_blacklistGroup expanded]) {
		int blackCount = [m_blacklistGroup userCount];
		if(index < blackCount)
			return [m_blacklistGroup user:index];
	}
	return nil;
}

- (id)linearLocateInCluster:(int)index {
	if(index < 0)
		return nil;
	
	int i;
	NSArray* clusters = [m_clusterGroup clusters];
	int size = [clusters count];
	for(i = 0; i < size; i++) {
		Cluster* c = [clusters objectAtIndex:i];
		if(index == 0)
			return c;
		index--;
		
		if([c expanded]) {
			int memberCount = [c memberCount];
			if(index < memberCount)
				return [c memberAtIndex:index];
			index -= memberCount;
		}
	}
	
	return nil;
}

- (Cluster*)parentCluster:(int)index {
	if(index < 0)
		return nil;
	
	int i;
	NSArray* clusters = [m_clusterGroup clusters];
	int size = [clusters count];
	for(i = 0; i < size; i++) {
		Cluster* c = [clusters objectAtIndex:i];
		if(index == 0)
			return nil;
		index--;
		
		if([c expanded]) {
			int memberCount = [c memberCount];
			if(index < memberCount)
				return c;
			index -= memberCount;
		}
	}
	
	return nil;
}

#pragma mark -
#pragma mark sort

- (void)sortAll {
	NSEnumerator* e = [m_groups objectEnumerator];
	Group* g = nil;
	while(g = [e nextObject])
		[g sort];
}

#pragma mark -
#pragma mark user type check

- (BOOL)isUserFriendly:(User*)user {
	Group* g = [self group:[user groupIndex]];
	return g != nil && [g isUser] && [g isFriendly];
}

- (BOOL)isUserStranger:(User*)user {
	Group* g = [self group:[user groupIndex]];
	return g == nil || [g isUser] && [g isStranger];
}

- (BOOL)isUserBlacklist:(User*)user {
	Group* g = [self group:[user groupIndex]];
	return g != nil && [g isBlacklist];
}

#pragma mark -
#pragma mark edit methods

- (void)addFriendGroups:(NSArray*)friendGroups {
	NSEnumerator* e = [friendGroups objectEnumerator];
	FriendGroup* fg = nil;
	while(fg = [e nextObject]) {		
		// get group object
		Group* g = [fg isUser] ? [self group:[fg groupIndex]] : [self clusterGroup];
		
		// create user or cluster
		if([g isUser]) {
			if([fg QQ] == m_QQ) {
				[g addUser:[self user:m_QQ]];
				[[self user:m_QQ] setGroupIndex:[fg groupIndex]];
			} else {
				User* u = [m_userRegistry objectForKey:[NSNumber numberWithUnsignedInt:[fg QQ]]];
				if(u == nil)
					u = [[[User alloc] initWithQQ:[fg QQ]] autorelease];
				if([g addUser:u]) {
					// set group index
					[u setGroupIndex:[fg groupIndex]];
					
					// add to registry
					[m_userRegistry setObject:u forKey:[NSNumber numberWithUnsignedInt:[u QQ]]];
				}
			}
		} else {
			Cluster* c = [m_clusterRegistry objectForKey:[NSNumber numberWithUnsignedInt:[fg QQ]]];
			if(c == nil)
				c = [[[Cluster alloc] initWithInternalId:[fg QQ]] autorelease];
			if([g addCluster:c]) {
				// add to registry
				[m_clusterRegistry setObject:c forKey:[NSNumber numberWithUnsignedInt:[c internalId]]];
			}			
		}		
		
		// set dirty flag
		m_dirty = YES;
	}
}

- (void)addFriends:(NSArray*)friends {
	NSEnumerator* e = [friends objectEnumerator];
	Friend* f = nil;
	while(f = [e nextObject]) {
		User* u = [self user:[f QQ]];
		if(u) {
			[u copyWithFriend:f];
			m_dirty = YES;
		}			
	}
}

- (void)setUserProperty:(NSArray*)properties {
	NSEnumerator* e = [properties objectEnumerator];
	UserProperty* prop = nil;
	while(prop = [e nextObject]) {
		User* u = [self user:[prop QQ]];
		if(u) {
			[u copyWithUserProperty:prop];
		}			
	}
}

- (void)setFriendLevel:(NSArray*)levels {
	NSEnumerator* e = [levels objectEnumerator];
	FriendLevel* level = nil;
	while(level = [e nextObject]) {
		User* u = [self user:[level QQ]];
		if(u) {
			[u copyWithFriendLevel:level];
		}			
	}
}

- (void)setSignature:(NSArray*)signatures {
	NSEnumerator* e = [signatures objectEnumerator];
	Signature* sig = nil;
	while(sig = [e nextObject]) {
		User* u = [self user:[sig QQ]];
		if(u) {
			[u copyWithSignature:sig];
		}			
	}
}

- (void)setRemarks:(NSArray*)remarks {
	NSEnumerator* e = [remarks objectEnumerator];
	FriendRemark* remark = nil;
	while(remark = [e nextObject]) {
		User* u = [self user:[remark QQ]];
		if(u) {
			[u copyWithRemarks:remark];
			m_dirty = YES;
		}
	}
}

- (void)setClusterInfo:(ClusterInfo*)info {
	Cluster* c = [self cluster:[info internalId]];
	
	if(c) {
		[c setClusterInfo:info];
		m_dirty = YES;
	}
}

- (void)setMembers:(UInt32)internalId members:(NSArray*)members {
	Cluster* c = [self cluster:internalId];
	if(c) {
		Member* member;
		NSEnumerator* e = [members objectEnumerator];
		while(member = [e nextObject]) {
			// get a user or create a new one
			User* user = [m_userRegistry objectForKey:[NSNumber numberWithUnsignedInt:[member QQ]]];
			if(user == nil) {
				user = [[User alloc] initWithQQ:[member QQ]];
				[m_userRegistry setObject:user forKey:[NSNumber numberWithUnsignedInt:[user QQ]]];
			} else
				[user retain];
			
			// set role and organization
			if([c permanent]) {
				[user setRoleFlag:internalId role:[member roleFlag]];
			}

			// add it to cluster
			[c addMember:user];
			
			// release
			[user release];
		}
	}
}

- (void)setClusterNameCards:(UInt32)internalId nameCards:(NSArray*)nameCards {
	ClusterNameCard* card;
	NSEnumerator* e = [nameCards objectEnumerator];
	while(card = [e nextObject]) {
		User* user = [self user:[card QQ]];
		ClusterSpecificInfo* info = [user getClusterSpecificInfo:internalId];
		[info setNameCard:card];
	}
}

- (void)setMemberInfos:(NSArray*)memberInfos {
	Friend* f;
	NSEnumerator* e = [memberInfos objectEnumerator];
	while(f = [e nextObject]) {
		User* u = [self user:[f QQ]];
		if(u) {
			[u copyWithFriend:f];
			m_dirty = YES;
		}			
	}
}

- (void)setOnlineMembers:(NSArray*)onlineMembers {
	NSNumber* qq;
	NSEnumerator* e = [onlineMembers objectEnumerator];
	while(qq = [e nextObject]) {
		User* u = [self user:[qq intValue]];
		if(u)
			[u setStatus:kQQStatusOnline];
	}
}

- (BOOL)removeUser:(User*)user {
	Group* g = [self group:[user groupIndex]];
	if(g == nil)
		return NO;
	
	// remove
	[g removeUser:user];
	[user setGroupIndex:kGroupIndexUndefined];
	m_dirty = YES;
	m_changed = YES;

	// return
	return YES;
}

- (BOOL)removeCluster:(Cluster*)cluster {
	if([cluster permanent]) {
		[m_clusterGroup removeCluster:cluster];
		[m_clusterRegistry removeObjectForKey:[NSNumber numberWithUnsignedInt:[cluster internalId]]];
		m_dirty = YES;
		return YES;
	}
	return NO;
}

- (BOOL)removeGroup:(Group*)group {
	return [self removeGroupAt:[self indexOfGroup:group]];
}

- (BOOL)removeGroupAt:(int)groupIndex {
	if(groupIndex < 0 || groupIndex >= [m_groups count])
		return NO;
	
	Group* group = [m_groups objectAtIndex:groupIndex];
	if([group userCount] > 0)
		return NO;
	
	// remove
	[m_groups removeObjectAtIndex:groupIndex];
	
	// adjust user's groupindex
	User* u;
	NSEnumerator* e = [m_userRegistry objectEnumerator];
	while(u = [e nextObject]) {
		int oldIndex = [u groupIndex];
		if(oldIndex > groupIndex)
			[u setGroupIndex:(oldIndex - 1)];
	}
	
	// dirty flag
	m_dirty = YES;
	m_changed = YES;
	
	return YES;
}

- (void)addUser:(User*)user group:(Group*)group {
	// check user
	User* tmp = [self user:[user QQ]];
	if(tmp)
		user = tmp;
	
	// add it
	if(group) {
		[group addUser:user];
		[user setGroupIndex:[self indexOfGroup:group]];
		m_changed = YES;
	}

	// register it
	[m_userRegistry setObject:user forKey:[NSNumber numberWithUnsignedInt:[user QQ]]];
	
	// dirty flag
	m_dirty = YES;
}

- (void)addUser:(User*)user groupIndex:(int)groupIndex {
	// check group
	Group* g = [self group:groupIndex];	
	[self addUser:user group:g];
}

- (int)moveUser:(User*)user toGroupIndex:(int)groupIndex {
	// get new group
	Group* newGroup = [self group:groupIndex];
	if(newGroup == nil)
		return kGroupIndexUndefined;
	
	return [self moveUser:user toGroup:newGroup];
}

- (int)moveUser:(User*)user toGroup:(Group*)group {
	// check user
	if([self user:[user QQ]] == nil)
		return kGroupIndexUndefined;
	
	// remove from old group
	[user retain];
	int oldGroupIndex = [user groupIndex];
	Group* g = [self group:oldGroupIndex];
	if(g)
		[g removeUser:user];
	
	// add to new group
	[group addUser:user];
	[user setGroupIndex:[self indexOfGroup:group]];	
	[user release];
	
	// sort
	[group sort];
	
	// dirty flag
	m_dirty = YES;
	m_changed = YES;
		
	// return
	return oldGroupIndex;
}

- (void)moveAllUsersFrom:(int)fromGroup to:(int)toGroup {
	Group* srcGroup = [self group:fromGroup];
	if(srcGroup == nil)
		return;
	
	Group* destGroup = [self group:toGroup];
	if(destGroup == nil)
		return;
	
	// move
	User* u;
	NSEnumerator* e = [srcGroup userEnumerator];
	while(u = [e nextObject]) {
		[destGroup addUser:u];
		[u setGroupIndex:toGroup];
	}
	
	[srcGroup clearUsers];
	
	// sort
	[destGroup sort];
	
	// dirty flag
	m_dirty = YES;
	m_changed = YES;
}

- (void)addCluster:(Cluster*)cluster {
	if([cluster permanent]) {
		// check cluster
		Cluster* tmp = [self cluster:[cluster internalId]];
		if(tmp)
			cluster = tmp;
		
		// add it
		[m_clusterGroup addCluster:cluster];
		
		// register it
		[m_clusterRegistry setObject:cluster forKey:[NSNumber numberWithUnsignedInt:[cluster internalId]]];
		
		// dirty flag
		m_dirty = YES;
	} 	
}

- (Group*)addFriendlyGroup:(NSString*)name {
	Group* group = [[[Group alloc] initWithFlag:(kGroupUser | kGroupFriendly) name:name] autorelease];
	[m_groups addObject:group];
	m_dirty = YES;
	m_changed = YES;
	
	// get new group index
	int groupIndex = [m_groups count] - 1;
	
	// adjust user's groupindex
	User* u;
	NSEnumerator* e = [m_userRegistry objectEnumerator];
	while(u = [e nextObject]) {
		int oldIndex = [u groupIndex];
		if(oldIndex >= groupIndex)
			[u setGroupIndex:(oldIndex + 1)];
	}
	
	return group;
}

- (void)setGroupName:(Group*)group name:(NSString*)name {
	[group setName:name];
	m_dirty = YES;
}

#pragma mark -
#pragma mark read-only methods

- (BOOL)dirty {
	return m_dirty;
}

- (void)setDirty:(BOOL)flag {
	m_dirty = flag;
}

- (BOOL)changed {
	return m_changed;
}

- (void)setChanged:(BOOL)flag {
	m_changed = flag;
}

- (int)userCount {
	int ret = 0;
	int count = [m_groups count];
	Group* g;
	int i;
	for(i = 0; i < count; i++)
		ret += [[m_groups objectAtIndex:i] userCount];
	ret += [m_strangerGroup userCount];
	ret += [m_blacklistGroup userCount];
	return ret;
}

- (int)userCount:(int)groupIndex {
	Group* g = [self group:groupIndex];
	return [g userCount];
}

- (int)friendCount {
	NSEnumerator* e = [m_groups objectEnumerator];
	if(e) {
		int count = 0;
		Group* g = nil;
		while(g = [e nextObject])
			count += [g userCount];
		return count;
	} else
		return 0;	
}

- (int)clusterCount {
	return [m_clusterRegistry count];
}

- (int)userGroupCount {
	return [m_groups count] + 2;
}

- (int)friendlyGroupCount {
	return [m_groups count];
}

- (int)strangerGroupIndex {
	return [m_groups count];
}

- (int)blacklistGroupIndex {
	return [m_groups count] + 1;
}

- (BOOL)hasUser:(UInt32)QQ {
	return [m_userRegistry objectForKey:[NSNumber numberWithUnsignedInt:QQ]] != nil;
}

- (NSArray*)allUsers {
	return [m_userRegistry allValues];
}

- (NSArray*)allUserQQs {
	return [m_userRegistry allKeys];
}

- (NSArray*)allClusters {
	return [m_clusterRegistry allValues];
}

- (NSArray*)allClusterInternalIds {
	return [m_clusterRegistry allKeys];
}

- (NSArray*)allUserGroups {
	NSMutableArray* array = [NSMutableArray arrayWithArray:m_groups];
	[array addObject:m_strangerGroup];
	[array addObject:m_blacklistGroup];
	return array;
}

- (NSArray*)allUserGroupNames {
	int i;
	int count = [m_groups count];
	NSMutableArray* array = [NSMutableArray arrayWithCapacity:count];
	for(i = 0; i < count; i++) {
		[array addObject:[[m_groups objectAtIndex:i] name]];
	}
	[array addObject:[m_strangerGroup name]];
	[array addObject:[m_blacklistGroup name]];
	return array;
}

- (NSArray*)friendlyGroupNamesExceptMyFriends {
	int i;
	int count = [m_groups count];
	NSMutableArray* array = [NSMutableArray arrayWithCapacity:(count - 1)];
	for(i = 1; i < count; i++) {
		[array addObject:[[m_groups objectAtIndex:i] name]];
	}
	return array;
}

- (NSArray*)friendlyGroupNames {
	int i;
	int count = [m_groups count];
	NSMutableArray* array = [NSMutableArray arrayWithCapacity:count];
	for(i = 0; i < count; i++) {
		[array addObject:[[m_groups objectAtIndex:i] name]];
	}
	return array;
}

- (NSArray*)friendlyGroups {
	return m_groups;
}

- (NSDictionary*)friendGroupMapping {
	User* u;
	NSMutableDictionary* mapping = [NSMutableDictionary dictionary];
	NSEnumerator* e = [m_userRegistry objectEnumerator];
	while(u = [e nextObject]) {
		if([u groupIndex] >= 0 && [u groupIndex] < [m_groups count])
			[mapping setObject:[NSNumber numberWithInt:[u groupIndex]] forKey:[NSNumber numberWithUnsignedInt:[u QQ]]];
	}
	return mapping;
}

- (int)groupIndexByName:(NSString*)name {
	int i;
	int count = [m_groups count];
	for(i = 0; i < count; i++) {
		Group* group = [m_groups objectAtIndex:i];
		if([name isEqualToString:[group name]])
			return i;
	}
	if([name isEqualToString:[m_strangerGroup name]])
		return [self strangerGroupIndex];
	else if([name isEqualToString:[m_blacklistGroup name]])
		return [self blacklistGroupIndex];
	return -1;
}

- (User*)user:(UInt32)QQ {
	return [m_userRegistry objectForKey:[NSNumber numberWithUnsignedInt:QQ]];
}

- (Cluster*)cluster:(UInt32)internalId {
	NSNumber* key = [NSNumber numberWithUnsignedInt:internalId];
	Cluster* c = [m_clusterRegistry objectForKey:key];
	return c;
}

- (Cluster*)clusterByExternalId:(UInt32)externalId {
	Cluster* c;
	NSEnumerator* e = [m_clusterRegistry objectEnumerator];
	while(c = [e nextObject]) {
		if([c externalId] == externalId)
			return c;
	}
	return nil;
}

- (int)indexOfGroup:(Group*)group {
	if(group == m_strangerGroup)
		return [m_groups count];
	else if(group == m_blacklistGroup)
		return [m_groups count] + 1;
	else if(group == m_clusterGroup)
		return kGroupIndexUndefined;
	else
		return [m_groups indexOfObject:group];
}

- (BOOL)isBuiltInGroup:(Group*)group {
	int index = [self indexOfGroup:group];
	return index == 0 || index == [self strangerGroupIndex] || index == [self blacklistGroupIndex];
}

@end
