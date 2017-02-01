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

#import "CustomHeadReceiver.h"
#import "QQClient.h"
#import "GetCustomHeadDataReplyPacket.h"

#define _kMaxSize 80000
#define _kFragmentSize 800

@implementation CustomHeadReceiver

- (id)initWithClient:(QQClient*)client {
	self = [super init];
	if(self) {
		m_getting = NO;
		m_headSize = 0xFFFFFFFF;
		m_test = NULL;
		m_buffer = NULL;
		m_client = [client retain];
		[m_client addStatusListener:self];
		m_customHeads = [[NSMutableArray array] retain];
		
		m_timer = [[NSTimer scheduledTimerWithTimeInterval:5.0
													target:self
												  selector:@selector(onTimer:)
												  userInfo:nil
												   repeats:YES] retain];
	}
	return self;
}

- (void) dealloc {
	if(m_buffer != NULL)
		free(m_buffer);
	if(m_test != NULL)
		free(m_test);
	[m_client removeStatusListener:self];
	[m_client release];
	[m_connection release];
	[m_customHeads release];
	if(m_timer) {
		if([m_timer isValid])
			[m_timer invalidate];
		[m_timer release];
	}
	[super dealloc];
}

#pragma mark -
#pragma mark status event handler

- (BOOL)handleStatusEvent:(StatusEvent*)event {
	switch([event newStatus]) {
		case kQQStatusStarted:
			if(m_connection) {
				[m_connection release];
				m_connection = nil;
			}
			m_connection = [[Connection alloc] initWithServer:kCustomHeadDownloadServer
													 port:kQQPortUDP
												 protocol:kQQProtocolUDP];
			[m_connection setAdvisorId:[NSNumber numberWithInt:kQQFamilyAuxiliary]];
			[m_client newConnection:m_connection];
			break;
		case kQQStatusDead:
			[m_connection close];
			[m_client releaseConnection:[[m_connection connectionId] intValue]];
			break;
	}
	return NO;
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventGetCustomHeadDataOK:
			ret = [self handleGetCustomHeadDataOK:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleGetCustomHeadDataOK:(QQNotification*)event {
	GetCustomHeadDataReplyPacket* packet = (GetCustomHeadDataReplyPacket*)[event object];
	
	// abandon if qq number is not right
	if([packet QQ] != [m_currentHead QQ])
		return YES;
	
	// check head size
	if(m_headSize == 0xFFFFFFFF) {
		m_headSize = [packet fileSize];
		NSLog(@"Head size: %u", m_headSize);
		
		if(m_headSize > _kMaxSize) {
			// notify delegate
			if([m_client delegate])
				[[m_client delegate] customHeadFailedToReceive:m_currentHead];
			
			// get next
			m_getting = NO;
			[self getNextHead];
			return YES;
		}
		
		// allocate buffer
		if(m_buffer == NULL || m_buffer != NULL && m_oldSize < m_headSize) {
			if(m_buffer != NULL) {
				free(m_buffer);
				m_buffer = NULL;
			}
			m_buffer = (char*)malloc(m_headSize);
		}
		if(m_test == NULL || m_test != NULL && m_oldSize < m_headSize) {
			if(m_test != NULL) {
				free(m_test);
				m_test = NULL;
			}
			m_test = (char*)calloc(m_headSize, sizeof(char));
		} else
			memset(m_test, 0, m_headSize);
	}
	
	// write date to buffer
	UInt32 offset = [packet offset];
	int length = [[packet data] length];
	memcpy(m_buffer + offset, [[packet data] bytes], length);
	memset(m_test + offset, 1, length);
	NSLog(@"Head data for %u, offset: %u, length: %u", [m_currentHead QQ], offset, length);
	
	// check remaining
	if([self isAllReceived]) {
		// notify delegate
		if([m_client delegate])
			[[m_client delegate] customHeadDidReceived:m_currentHead data:[NSData dataWithBytes:m_buffer length:m_headSize]];
		
		// get next
		m_getting = NO;
		[self getNextHead];
	} else {
		// set last time
		m_lastTime = [[NSDate date] timeIntervalSince1970];
	}
	
	return YES;
}

#pragma mark -
#pragma mark helper

- (BOOL)isAllReceived {
	return memchr(m_test, 0, m_headSize) == NULL;
}

- (void)nextHole:(UInt32*)offset length:(UInt32*)length start:(UInt32)start {
	char* p = (char*)memchr(m_test + start, 0, m_headSize - start);
	if(p == NULL) {
		*offset = 0;
		*length = 0;
	} else {
		*offset = p - m_test;
		char* q = (char*)memchr(p, 1, m_headSize - *offset);
		if(q == NULL)
			*length = m_headSize - *offset;
		else
			*length = q - p;
	}
}

- (void)onTimer:(NSTimer*)timer {
	if(m_currentHead && m_getting) {
		if([[NSDate date] timeIntervalSince1970] - m_lastTime >= 5.0) {
			// timeout or not?
			m_timeoutCount++;
			if(m_timeoutCount >= 5) {
				// notify delegate
				if([m_client delegate])
					[[m_client delegate] customHeadFailedToReceive:m_currentHead];
				
				// get next
				m_getting = NO;
				[self getNextHead];
			} else {
				// try to get fragment or begin get data
				if(m_headSize != 0xFFFFFFFF) {
					UInt32 offset = 0, length = 0;
					[self nextHole:&offset length:&length start:0];
					while(length > 0) {
						[m_client getCustomHeadData:[m_currentHead QQ]
										  timestamp:[m_currentHead timestamp]
											 offset:offset
											 length:length];
						[self nextHole:&offset length:&length start:(offset + length)];
					}
				} else {
					[m_client getCustomHeadData:[m_currentHead QQ]
									  timestamp:[m_currentHead timestamp]];
				}
				m_lastTime = [[NSDate date] timeIntervalSince1970];
			}
		}	
	}
}

- (void)getNextHead {
	// check busy
	if(m_getting)
		return;
	m_getting = YES;
	
	// get next head need to be get
	BOOL bGet = NO;
	do {
		// release previous head
		if(m_currentHead) {
			[m_currentHead release];
			m_currentHead = nil;
		}
		
		// get head and remove from queue
		if([m_customHeads count] > 0)
			m_currentHead = [m_customHeads objectAtIndex:0];
		if(m_currentHead) {
			[m_currentHead retain];
			[m_customHeads removeObjectAtIndex:0];	
			
			// check delegate
			if([m_client delegate]) {
				bGet = [[m_client delegate] shouldReceiveCustomHead:m_currentHead];
				if(!bGet) {
					NSLog(@"For QQ: %u, no need to get custom head", [m_currentHead QQ]);
					[[m_client delegate] customHeadDidReceived:m_currentHead data:nil];
				}
			}
		} else
			break;
	} while(!bGet);
	
	// if nil, return
	if(m_currentHead == nil) {
		m_getting = NO;
		return;
	}
	
	// get data
	m_oldSize = m_headSize;
	m_headSize = -1;
	m_timeoutCount = 0;
	[m_client getCustomHeadData:[m_currentHead QQ] timestamp:[m_currentHead timestamp]];
}

#pragma mark -
#pragma mark API

- (NSNumber*)connectionId {
	if(m_connection == nil)
		return [NSNumber numberWithInt:-1];
	else
		return [m_connection connectionId];
}

- (void)addCustomHead:(CustomHead*)head {
	[m_customHeads addObject:head];
	[self getNextHead];
}

@end
