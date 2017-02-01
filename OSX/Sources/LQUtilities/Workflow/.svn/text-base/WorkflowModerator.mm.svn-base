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

#import "WorkflowModerator.h"


@implementation WorkflowModerator

- (id)initWithName:(NSString*)name dataSource:(id<WorkflowDataSource>)dataSource {
	self = [super init];
	if(self) {
		m_name = [name retain];
		m_units = [[NSMutableArray array] retain];
		m_dataSource = [(NSObject*)dataSource retain];
		m_current = -1;
		m_operating = NO;
	}
	return self;
}

- (void) dealloc {
	[m_name release];
	[m_units release];
	[m_client release];
	[(NSObject*)m_dataSource release];
	[super dealloc];
}

#pragma mark -
#pragma mark API

- (void)cancel {
	[m_client removeQQListener:self];
	m_operating = NO;
}

- (void)start:(QQClient*)client {
	if(m_operating)
		return;	
	m_operating = YES;
	
	if(m_client)
		[m_client release];
	m_client = [client retain];
	[client addQQListener:self];
	[m_dataSource workflowStart:m_name];
	[self executeNextUnit];
}

- (void)reset:(NSString*)newName {
	if(m_client)
		[m_client removeQQListener:self];
	if(m_name)
		[m_name release];
	m_name = [newName retain];
	[m_units removeAllObjects];
	m_current = -1;
}

- (void)addUnit:(NSString*)name failEvent:(int)failEvent {
	[self addUnit:name failEvent:failEvent critical:NO];
}

- (void)addUnit:(NSString*)name failEvent:(int)failEvent critical:(BOOL)critical {
	[self addUnit:name failEvent:failEvent critical:critical repeats:1];
}

- (void)addUnit:(NSString*)name failEvent:(int)failEvent critical:(BOOL)critical repeats:(int)repeats {
	WorkflowUnit* unit = [WorkflowUnit unitWithName:name
										  failEvent:failEvent
										   critical:critical
											repeats:repeats];
	[m_units addObject:unit];
}

- (BOOL)operating {
	return m_operating;
}

#pragma mark -
#pragma mark helper

- (void)executeNextUnit {
	// check current
	m_current++;
	if(m_current >= [m_units count]) {
		m_operating = NO;
		[m_client removeQQListener:self];
		[m_dataSource workflow:m_name end:YES];
		return;
	}
	
	do {
		// get current
		WorkflowUnit* unit = [m_units objectAtIndex:m_current];
		
		// need execute?
		if([m_dataSource needExecuteWorkflowUnit:[unit name]]) {
			// do request
			m_waitingSequence = [m_dataSource executeWorkflowUnit:[unit name] hint:[m_dataSource workflowUnitHint:[unit name]]];
			[unit increaseRepeat];
			return;
		} else
			m_current++;
	} while(m_current < [m_units count]);
	
	// if execute to here, then end
	m_operating = NO;
	[m_client removeQQListener:self];
	[m_dataSource workflow:m_name end:YES];
}

- (void)endCurrentUnit:(BOOL)success {
	// get current
	WorkflowUnit* unit = [m_units objectAtIndex:m_current];
	if(!success && [unit critical]) {
		m_operating = NO;
		[m_client removeQQListener:self];
		[m_dataSource workflow:m_name end:NO];
	} else
		[self executeNextUnit];
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	// get packet
	Packet* packet = [event outPacket];
	if(packet == nil)
		packet = [event object];
	
	// check sequence
	BOOL ret = NO;
	if([packet sequence] == m_waitingSequence)
		ret = [m_dataSource handleQQEvent:event];
	else if([m_dataSource acceptEvent:[event eventId]]) {
		ret = [m_dataSource handleQQEvent:event];
		return ret;
	} else
		return ret;
	
	// get current
	WorkflowUnit* unit = [m_units objectAtIndex:m_current];
	
	// fail or timeout?
	BOOL timeout = ([event eventId] & kQQEventTimeout) != 0 && [[event outPacket] sequence] == m_waitingSequence;
	if([unit failEvent] == [event eventId] || timeout) {
		// if need repeat
		if(timeout && [unit repeatCount] < [unit repeats]) {
			[unit increaseRepeat];
			[m_client sendPacket:[event outPacket]];
		} else if([unit critical]) {
			m_operating = NO;
			[m_client removeQQListener:self];
			[m_dataSource workflow:m_name end:NO];
		} else {
			// next step, because it's not a critical unit
			[self executeNextUnit];
		}
	} else {
		// next step
		[self executeNextUnit];
	}
	
	return ret;
}

#pragma mark -
#pragma mark getter and setter

- (NSString*)name {
	return m_name;
}

@end
