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

#import "IMService.h"
#import "QQClient.h"
#import "DefaultFace.h"
#import "ByteTool.h"
#import "ClusterCommandPacket.h"
#import "ClusterCommandReplyPacket.h"
#import "ClusterSendIMExPacket.h"
#import "SendIMReplyPacket.h"
#import "SendIMPacket.h"
#import "NSMutableData-CustomAppending.h"

@implementation IMService

- (void) dealloc {
	[_sendQueue release];
	[_objQueue release];
	[_callbackQueue release];
	[_msgData release]; 
	[super dealloc];
}

- (id)initWithClient:(QQClient*)client {
	self = [super init];
	if(self) {
		_client = client;
		_sendQueue = [[NSMutableArray array] retain];
		_objQueue = [[NSMutableArray array] retain];
		_callbackQueue = [[NSMutableArray array] retain];
	}
	return self;
}

- (void)send:(NSString*)msg to:(id)obj callback:(id<IMServiceCallback>)callback {
	[_sendQueue addObject:msg];
	[_objQueue addObject:obj];
	[_callbackQueue addObject:callback];
	
	// send
	if(!_sending)
		[self _sendNextMessage];
}

- (void)_sendNextMessage {	
	// check queue
	if([_sendQueue count] == 0) {
		_sending = NO;
		return;
	}
	
	// get next message
	NSString* message = [_sendQueue objectAtIndex:0];
	
	// get callback and object
	id<IMServiceCallback> callback = [_callbackQueue objectAtIndex:0];
	id obj = [_objQueue objectAtIndex:0];
	
	// generate font style
	FontStyle* style = [FontStyle defaultStyle];
	
	// if sending, check fragment count
	if(_sending) {
		if(_fragmentCount > 1 && _nextFragmentIndex < _fragmentCount) {
			//
			// has more fragment need to be sent
			//
			
			// get data
			if(_msgData) {
				int length = MIN(kQQMaxMessageFragmentLength, [_msgData length] - _nextFragmentIndex * kQQMaxMessageFragmentLength);
				NSData* messageData = [NSData dataWithBytes:(((const char*)[_msgData bytes]) + _nextFragmentIndex * kQQMaxMessageFragmentLength) length:length];
				_waitingSequence = [callback doSend:obj
											   data:messageData
										   style:style
								   fragmentCount:_fragmentCount
								   fragmentIndex:_nextFragmentIndex];
				_nextFragmentIndex++;				
				return;
			}
		}
	} else
		_sending = YES;
	
	//
	// if program executes to here, means previous message is not long message
	// so we go on next
	//
	
	// release old data
	if(_msgData) {
		[_msgData release];
		_msgData = nil;
	}
	
	// get message data
	_msgData = [[NSMutableData data] retain];
	int appendFrom = 0;
	int to;
	int length = [message length];
	NSRange searchRange = NSMakeRange(0, length);
	NSRange range = [message rangeOfString:@"/"];
	while(range.location != NSNotFound && searchRange.location < length) {
		unsigned char code = [DefaultFace parseEscape:message from:(range.location + 1) to:&to];
		if(to >= range.location + 1) {
			NSData* data = [ByteTool getBytes:[message substringWithRange:NSMakeRange(appendFrom, range.location - appendFrom)]];
			[_msgData appendData:data];
			[_msgData appendByte:0x14];
			[_msgData appendByte:code];
			searchRange.location = to + 1;
			appendFrom = to + 1;
		} else
			searchRange.location = range.location + 1;
		
		searchRange.length = length - searchRange.location;
		range = [message rangeOfString:@"/" options:0 range:searchRange];
	}
	NSData* data = [ByteTool getBytes:[message substringWithRange:NSMakeRange(appendFrom, length - appendFrom)]];
	[_msgData appendData:data];
	[_msgData appendByte:0x20]; // necessary whitespace
	
	// calculate fragment count
	_fragmentCount = ([_msgData length] - 1) / kQQMaxMessageFragmentLength + 1;
	
	if(_fragmentCount > 1) {
		// set next index
		_nextFragmentIndex = 0;
		
		// send first fragment
		NSData* messageData = [NSData dataWithBytes:[_msgData bytes] length:kQQMaxMessageFragmentLength];
		_waitingSequence = [callback doSend:obj
									   data:messageData
									  style:style
							  fragmentCount:_fragmentCount
							  fragmentIndex:_nextFragmentIndex];
		_nextFragmentIndex++;
	} else {
		// send message
		_waitingSequence = [callback doSend:obj
									   data:_msgData
									  style:style
							  fragmentCount:1
							  fragmentIndex:0];
		[_msgData release];
		_msgData = nil;
	}
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventSendIMOK:
			ret = [self handleSendIMOK:event];
			break;
		case kQQEventClusterSendIMOK:
			ret = [self handleClusterSendIMOK:event];
			break;
		case kQQEventClusterSendIMFailed:
			ret = [self handleClusterSendIMFailed:event];
			break;
		case kQQEventTimeoutBasic:
		{
			OutPacket* packet = [event outPacket];
			switch([packet command]) {
				case kQQCommandSendIM:
					ret = [self handleSendIMTimeout:event];
					break;
				case kQQCommandCluster:
				{
					ClusterCommandPacket* ccp = (ClusterCommandPacket*)packet;
					switch([ccp subCommand]) {
						case kQQSubCommandClusterSendIMEx:
							ret = [self handleClusterSendIMTimeout:event];
							break;
					}
					break;
				}
			}
			break;
		}
	}
	
	return ret;
}

- (BOOL)handleSendIMOK:(QQNotification*)event {
	SendIMReplyPacket* packet = [event object];
	if([packet sequence] == _waitingSequence) {
		// remove message from queue
		SendIMPacket* request = (SendIMPacket*)[event outPacket];
		if([request fragmentCount] == [request fragmentIndex] + 1) {
			[_sendQueue removeObjectAtIndex:0];
			[_objQueue removeObjectAtIndex:0];
			[_callbackQueue removeObjectAtIndex:0];
			
			// notify
			[[NSNotificationCenter defaultCenter] postNotificationName:kSendIMOKNotificationName
																object:[NSNumber numberWithUnsignedInt:[request receiver]]];	
		}
		
		// send next
		[self _sendNextMessage];
		return YES;
	}
	return NO;
}

- (BOOL)handleSendIMTimeout:(QQNotification*)event {
	SendIMPacket* packet = (SendIMPacket*)[event outPacket];
	if([packet sequence] == _waitingSequence) {
		// get message and dest obj
		NSString* message = [[_sendQueue objectAtIndex:0] retain];
		id obj = [[_objQueue objectAtIndex:0] retain];
		
		// remove message
		[_sendQueue removeObjectAtIndex:0];
		[_objQueue removeObjectAtIndex:0];
		[_callbackQueue removeObjectAtIndex:0];
		
		// change fragment index, so we can skip the timeout message
		_nextFragmentIndex = _fragmentCount;
		
		// notify
		[[NSNotificationCenter defaultCenter] postNotificationName:kSendIMTimeoutNotificationName
															object:obj
														  userInfo:[NSDictionary dictionaryWithObject:message forKey:kUserInfoMessage]];
		
		// send next
		[self _sendNextMessage];
		
		// release
		[message release];
		[obj release];
		return YES;
	}
	return NO;
}

- (BOOL)handleClusterSendIMOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if([packet sequence] == _waitingSequence) {
		// remove message from queue
		ClusterSendIMExPacket* request = (ClusterSendIMExPacket*)[event outPacket];
		if([request fragmentCount] == [request fragmentIndex] + 1) {
			[_sendQueue removeObjectAtIndex:0];
			[_objQueue removeObjectAtIndex:0];
			[_callbackQueue removeObjectAtIndex:0];
		}
			
		// send next
		[self _sendNextMessage];
		return YES;
	}
	return NO;
}

- (BOOL)handleClusterSendIMFailed:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if([packet sequence] == _waitingSequence) {
		// get message from queue
		NSString* message = [[_sendQueue objectAtIndex:0] retain];
		id obj = [[_objQueue objectAtIndex:0] retain];
		
		// remove message
		[_sendQueue removeObjectAtIndex:0];
		[_objQueue removeObjectAtIndex:0];
		[_callbackQueue removeObjectAtIndex:0];
		
		// change fragment index, so we can skip the timeout message
		_nextFragmentIndex = _fragmentCount;
		
		// notify
		[[NSNotificationCenter defaultCenter] postNotificationName:kSendClusterIMFailedNotificationName
															object:obj
														  userInfo:[NSDictionary dictionaryWithObject:message forKey:kUserInfoMessage]];
		
		// send next
		[self _sendNextMessage];
		
		// release
		[message release];
		return YES;
	}
	return NO;
}

- (BOOL)handleClusterSendIMTimeout:(QQNotification*)event {
	ClusterSendIMExPacket* packet = (ClusterSendIMExPacket*)[event outPacket];
	if([packet sequence] == _waitingSequence) {
		// get message from queue
		NSString* message = [[_sendQueue objectAtIndex:0] retain];
		id obj = [[_objQueue objectAtIndex:0] retain];
		
		// remove message
		[_sendQueue removeObjectAtIndex:0];
		[_objQueue removeObjectAtIndex:0];
		[_callbackQueue removeObjectAtIndex:0];
		
		// change fragment index, so we can skip the timeout message
		_nextFragmentIndex = _fragmentCount;
		
		// notify
		[[NSNotificationCenter defaultCenter] postNotificationName:kSendClusterIMTimeoutNotificationName
															object:obj
														  userInfo:[NSDictionary dictionaryWithObject:message forKey:kUserInfoMessage]];
		
		// send next
		[self _sendNextMessage];
		
		// release
		[message release];
		return YES;
	}
	return NO;
}

@end
