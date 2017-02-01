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

// dummy type
#define kDummyDialogs 0
#define kDummySubjects 1
#define kDummyOrganizations 2

//
// dummy class used to represents a logic unit, it will not be put in registry
//
@interface Dummy : NSObject <NSCopying> {
	int m_type;
	NSString* m_name;	
	UInt32 m_clusterInternalId;
	
	// operation status
	BOOL m_requested;
	
	// used to describe what operation is performing on this dummy
	NSString* m_operationSuffix;
}

- (id)initWithType:(int)type;
- (id)initWithType:(int)type name:(NSString*)name;

// getter and setter
- (NSString*)operationSuffix;
- (void)setOperationSuffix:(NSString*)suffix;
- (int)type;
- (void)setType:(int)type;
- (NSString*)name;
- (void)setName:(NSString*)name;
- (UInt32)clusterInternalId;
- (void)setClusterInternalId:(UInt32)clusterInternalId;
- (BOOL)requested;
- (void)setRequested:(BOOL)requested;

@end
