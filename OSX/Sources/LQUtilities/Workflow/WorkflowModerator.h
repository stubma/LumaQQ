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
#import "QQClient.h"
#import "QQListener.h"
#import "WorkflowDataSource.h"
#import "WorkflowUnit.h"

@interface WorkflowModerator : NSObject <QQListener> {
	NSString* m_name;
	NSMutableArray* m_units;
	id<WorkflowDataSource> m_dataSource;
	int m_current;
	UInt16 m_waitingSequence;
	QQClient* m_client;
	
	BOOL m_operating;
}

- (id)initWithName:(NSString*)name dataSource:(id<WorkflowDataSource>)dataSource;

// API
- (void)start:(QQClient*)client;
- (void)cancel;
- (void)reset:(NSString*)newName;
- (void)endCurrentUnit:(BOOL)success;
- (void)addUnit:(NSString*)name failEvent:(int)failEvent;
- (void)addUnit:(NSString*)name failEvent:(int)failEvent critical:(BOOL)critical;
- (void)addUnit:(NSString*)name failEvent:(int)failEvent critical:(BOOL)critical repeats:(int)repeats;
- (BOOL)operating;

// helper
- (void)executeNextUnit;

// getter and setter
- (NSString*)name;

@end
