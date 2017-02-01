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
#import "InPacket.h"
#import "SentIM.h"

@interface History : NSObject {
	NSString* m_path;
	NSString* m_owner;
	UInt32 m_myQQ;
	
	NSMutableArray* m_history;
	
	// the day when the history is create
	int m_year;
	int m_month;
	int m_day;
	
	// dirty flag
	BOOL m_dirty;
}

- (id)initWithMyQQ:(UInt32)QQ owner:(NSString*)owner path:(NSString*)path year:(int)year month:(int)month day:(int)day;

// API
- (void)addPacket:(InPacket*)packet;
- (void)addSentIM:(SentIM*)sentIM;
- (void)save;
- (NSArray*)historyOfYear:(int)year month:(int)month day:(int)day;

// getter and setter
- (NSString*)owner;
- (NSString*)path;
- (NSArray*)history;
- (UInt32)myQQ;

@end
