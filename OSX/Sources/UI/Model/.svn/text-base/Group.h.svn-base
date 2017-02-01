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
#import "Mobile.h"

// group flag constant
#define kGroupUser 0x0001
#define kGroupCluster 0x0002
#define kGroupFriendly 0x0004
#define kGroupBlacklist 0x0008
#define kGroupMobile 0x0010

@interface Group : NSObject <NSCoding, NSCopying> {
	// group name
	NSString* m_name;
	
	// group flag
	int m_flag;
	
	// user array
	NSMutableArray* m_users;
	
	// cluster array
	NSMutableArray* m_clusters;
	
	// mobile array
	NSMutableArray* m_mobiles;
	
	// used for QQCell
	UInt32 m_messageCount;
	int m_frame;
	
	// used for outline
	BOOL m_expanded;
}

- (id)initWithFlag:(int)flag;
- (id)initWithFlag:(int)flag name:(NSString*)name;
- (id)initWithGroup:(Group*)group;

// sort
- (void)sort;

// helper
- (BOOL)isUser;
- (BOOL)isCluster;
- (BOOL)isFriendly;
- (BOOL)isStranger;
- (BOOL)isBlacklist;
- (BOOL)isMobile;
- (void)clearFlag;
- (void)setUser;
- (void)setCluster;
- (void)setFriendly;
- (void)setBlacklist;
- (void)addMobile:(Mobile*)mobile;
- (void)removeMobile:(Mobile*)mobile;
- (BOOL)addUser:(User*)user;
- (void)removeUser:(User*)user;
- (void)removeCluster:(Cluster*)cluster;
- (BOOL)addCluster:(Cluster*)cluster;
- (void)increaseMessageCount;

// getter and setter
- (int)flag;
- (NSString*)name;
- (void)setName:(NSString*)name;
- (NSEnumerator*)userEnumerator;
- (NSEnumerator*)clusterEnumerator;
- (NSEnumerator*)mobileEnumerator;
- (int)userCount;
- (int)onlineUserCount;
- (int)clusterCount;
- (int)mobileCount;
- (User*)user:(int)index;
- (Cluster*)cluster:(int)index;
- (Mobile*)mobile:(int)index;
- (NSMutableArray*)users;
- (NSMutableArray*)clusters;
- (NSMutableArray*)mobiles;
- (void)setUsers:(NSMutableArray*)users;
- (void)setClusters:(NSMutableArray*)clusters;
- (void)setMobiles:(NSMutableArray*)mobiles;
- (void)clearUsers;
- (UInt32)messageCount;
- (void)setMessageCount:(UInt32)count;
- (int)frame;
- (void)setFrame:(int)frame;
- (BOOL)expanded;
- (void)setExpanded:(BOOL)flag;

@end
