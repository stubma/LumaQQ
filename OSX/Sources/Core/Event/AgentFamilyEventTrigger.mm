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

#import "AgentFamilyEventTrigger.h"
#import "RequestAgentReplyPacket.h"
#import "ServerTransferPacket.h"

@implementation AgentFamilyEventTrigger

+ (void)trigger:(QQClient*)client packet:(InPacket*)packet outPacket:(OutPacket*)outPacket connectionId:(int)connectionId {
	QQNotification* event = nil;
	switch([packet command]) {
		case kQQCommandRequestAgent:
			event = [self processRequestAgentReply:packet];
			break;
		case kQQCommandRequestBegin:
			event = [self processRequestBeginReply:packet];
			break;
		case kQQCommandRequestFace:
			event = [self processRequestFaceReply:packet];
			break;
		case kQQCommandTransfer:
			event = [self processServerTransferPacket:packet];
			break;
	}
	
	// trigger event
	if(event) {
		[event retain];
		[event setConnectionId:connectionId];
		[event setOutPacket:outPacket];
		[client trigger:event];
		[event release];
	}
}

+ (QQNotification*)processServerTransferPacket:(InPacket*)packet {
	QQNotification* event = nil;
	ServerTransferPacket* p = (ServerTransferPacket*)packet;
	if([p version] != kQQVersionCurrent) {
		switch([p sequence]) {
			case 0:
				NSLog(@"Custom Face Info Received");
				event = [[QQNotification alloc] initWithId:kQQEventImageInfoReceived packet:p];
				break;
			default:
				NSLog(@"Custom Face Data Received");
				event = [[QQNotification alloc] initWithId:kQQEventImageDataReceived packet:p];
				break;
		}
	} else {
		if([p restartPoint] == -1) {
			NSLog(@"Image Data Acknowledged, seq: %d", [p sequence]);
			event = [[QQNotification alloc] initWithId:kQQEventImageDataAcknowledged packet:p];
		} else {
			NSLog(@"Image Info Acknowledged");
			event = [[QQNotification alloc] initWithId:kQQEventImageInfoAcknowledged packet:p];
		}
	}
	
	if(event)
		return [event autorelease];
	else
		return nil;
}

+ (QQNotification*)processRequestAgentReply:(InPacket*)packet {
	QQNotification* event = nil;
	RequestAgentReplyPacket* p = (RequestAgentReplyPacket*)packet;
	switch([p reply]) {
		case kQQReplyOK:
			NSLog(@"Request Agent OK");
			event = [[QQNotification alloc] initWithId:kQQEventRequestAgentOK packet:p];
			break;
		case kQQReplyRequestAgentRedirect:
			NSLog(@"Request Agent Redirect");
			event = [[QQNotification alloc] initWithId:kQQEventRequestAgentRedirect packet:p];
			break;
		case kQQReplyRequestAgentRejected:
			NSLog(@"Request Agent Rejected");
			event = [[QQNotification alloc] initWithId:kQQEventRequestAgentRejected packet:p];
			break;
		default:
			NSLog(@"Unknown Request Agent Reply Code: %d", [p reply]);
			break;
	}
	
	if(event)
		return [event autorelease];
	else
		return nil;
}

+ (QQNotification*)processRequestBeginReply:(InPacket*)packet {
	NSLog(@"Request Begin OK, sequence: %d", [packet sequence]);
	QQNotification* event = [[QQNotification alloc] initWithId:kQQEventRequestBeginOK packet:packet];
	return [event autorelease];
}

+ (QQNotification*)processRequestFaceReply:(InPacket*)packet {
	NSLog(@"Request Face OK, sequence: %d", [packet sequence]);
	QQNotification* event = [[QQNotification alloc] initWithId:kQQEventRequestFaceOK packet:packet];
	return [event autorelease];
}

@end
