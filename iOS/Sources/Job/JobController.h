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
#import "JobDelegate.h"

#define kJobGetUserProperty @"JobGetUserProperty"
#define kJobGetFriendLevel @"JobGetFriendLevel"
#define kJobGetUserSignature @"JobGetUserSignature"
#define kJobGetFriendRemark @"JobGetFriendRemark"
#define kJobGetCustomHeadInfo @"JobGetCustomHeadInfo"
#define kJobGetCustomHeadData @"JobGetCustomHeadData"
#define kJobGetClusterInfo @"JobGetClusterInfo"
#define kJobGetClusterMemberInfo @"JobGetClusterMemberInfo"
#define kJobGetClusterOnlineMember @"JobGetClusterOnlineMember"
#define kJobGetClusterVersionId @"JobGetClusterVersionId"
#define kJobGetClusterMessageSetting @"JobGetClusterMessageSetting"
#define kJobUploadFriendGroup @"JobUploadFriendGroup"
#define kJobGetFriendGroup @"JobGetFriendGroup"
#define kJobUpdateFriendGroup @"JobUpdateFriendGroup"
#define kJobGetClusterNameCard @"GetClusterNameCard"

@interface JobController : NSObject <JobDelegate> {
	NSMutableDictionary* _jobs;
	NSMutableDictionary* _context;
	id _target;
	SEL _action;
}

- (id)initWithContext:(NSMutableDictionary*)context;
- (void)startJob:(id<Job>)job;
- (BOOL)hasJob:(NSString*)name;
- (void)terminate;
- (void)setTarget:(id)target;
- (void)setAction:(SEL)action;

@end
