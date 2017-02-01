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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 0 2111-1307 USA
 */

#import "NormalIMContainerController.h"
#import "IPSeeker.h"
#import "SendIMReplyPacket.h"
#import "SendIMPacket.h"
#import "MainWindowController.h"
#import "TimerTaskManager.h"
#import "PreferenceCache.h"
#import "Constants.h"
#import "ImageTool.h"
#import "NSString-Validate.h"
#import "AlertTool.h"
#import "NSString-Filter.h"

@implementation NormalIMContainerController

#pragma mark -
#pragma mark IMContainer protocol

- (id)initWithObject:(id)obj mainWindow:(MainWindowController*)mainWindowController {
	m_user = (User*)obj;
	return [super initWithObject:obj mainWindow:mainWindowController];
}

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventModifySigatureOK:
			ret = [self handleModifySignatureOK:event];
			break;
		case kQQEventGetSignatureOK:
			ret = [self handleGetSignatureOK:event];
			break;
		case kQQEventSendIMOK:
			ret = [self handleSendIMOK:event];
			break;
		case kQQEventGetUserInfoOK:
			ret = [self handleGetUserInfoOK:event];
			break;
		case kQQEventTimeoutBasic:
			OutPacket* packet = [event outPacket];
			switch([packet command]) {
				case kQQCommandSendIM:
					ret = [self handleSendIMTimeout:event];
					break;
			}
			break;
	}
	
	return ret;
}

- (void)walkMessageQueue:(MessageQueue*)queue {
	if(queue == nil)
		return;
	
	// we use count here because [user messageCount] includes temp session im
	while(InPacket* packet = [queue getUserMessage:[m_user QQ] remove:YES]) {
		[self appendPacket:packet];
	}
	
	// refresh dock icon
	[m_mainWindowController refreshDockIcon];
	
	// adjust message count, stop blink if necessary
	if([m_user messageCount] > 0) {
		Group* g = [[m_mainWindowController groupManager] group:[m_user groupIndex]];
		if(g && [g messageCount] > 0)
			[g setMessageCount:([g messageCount] - [m_user messageCount])];			
		[m_user setMessageCount:0];
	}
}

- (NSString*)owner {
	return [NSString stringWithFormat:@"%u", [m_user QQ]];
}

- (void)refreshHeadControl:(HeadControl*)headControl {
	[headControl setOwner:[[m_mainWindowController me] QQ]];
	[headControl setObjectValue:m_obj];
}

- (id)windowKey {
	return [NSNumber numberWithUnsignedInt:[m_user QQ]];
}

- (NSString *)description {
	PreferenceCache* cache = [PreferenceCache cache:[m_user QQ]];
	NSString* name = [m_user nick];
	if([cache showRealName]) {
		if(![[m_user remarkName] isEmpty])
			name = [m_user remarkName];
	}
	return [NSString stringWithFormat:L(@"LQTitle", @"NormalIMContainer"), name, [m_user QQ]];
}

- (NSString*)shortDescription {
	PreferenceCache* cache = [PreferenceCache cache:[m_user QQ]];
	NSString* name = [m_user nick];
	if([cache showRealName]) {
		if(![[m_user remarkName] isEmpty])
			name = [m_user remarkName];
	}
	return name;
}

- (NSImage*)ownerImage {
	return [ImageTool headWithId:[m_user head]];
}

- (void)handleIMContainerAttachedToWindow:(NSNotification*)notification {
	if(m_imView == [notification object]) {
		[m_split setDelegate:self];
		
		// get input box proportion
		float proportion = [m_user inputBoxProportion];
		
		// get split view bound
		NSRect bound = [m_split bounds];
		
		// set input box size
		NSRect frame;
		frame.origin = NSZeroPoint;
		frame.size = bound.size;
		frame.size.height = bound.size.height * (1.0 - proportion);
		frame.size.height = MAX(20.0, frame.size.height);
		frame.size.height = MIN(bound.size.height - 20.0, frame.size.height);
		[(NSView*)[[m_split subviews] objectAtIndex:0] setFrame:frame];
		
		// set output box size
		frame.origin.y = frame.size.height + [m_split dividerThickness];
		frame.size.height = bound.size.height - frame.origin.y;
		[(NSView*)[[m_split subviews] objectAtIndex:1] setFrame:frame];
		
		[m_split adjustSubviews];
	}
}

#pragma mark -
#pragma mark PSMTabModel protocol

- (int)objectCount {
	return [m_user messageCount];
}

#pragma mark -
#pragma mark actions

- (IBAction)onSendPicture:(id)sender {
	[AlertTool showWarning:[m_imView window]
				   message:L(@"LQNotSupported")];
}

- (IBAction)onScreenscrap:(id)sender {
	[AlertTool showWarning:[m_imView window]
				   message:L(@"LQNotSupported")];
}

- (IBAction)showOwnerInfo:(id)sender {
	[[m_mainWindowController windowRegistry] showUserInfoWindow:m_user mainWindow:m_mainWindowController];
}

#pragma mark -
#pragma mark initialization

- (void)awakeFromNib {
	// set ip location
	[m_txtLocation setStringValue:[self ipLocation]];
	
	// set signature
	[self refreshSignature];
	
	[super awakeFromNib];
}

#pragma mark -
#pragma mark split view delegate

- (float)splitView:(NSSplitView *)sender constrainMinCoordinate:(float)proposedMin ofSubviewAt:(int)offset {
	return 20;
}

- (float)splitView:(NSSplitView *)sender constrainMaxCoordinate:(float)proposedMax ofSubviewAt:(int)offset {
	return [sender bounds].size.height - 20 - [sender dividerThickness];
}

- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification {
	NSView* view = [[m_split subviews] objectAtIndex:1];
	float newProp = ([view bounds].size.height + [m_split dividerThickness]) / [m_split bounds].size.height;
	[m_user setInputBoxProportion:newProp];
}

#pragma mark -
#pragma mark helper

- (NSString*)ipLocation {
	return [[IPSeeker shared] getLocation:[m_user ip]];
}

- (void)refreshSignature {
	if([[m_user signature] isEmpty])
		[m_txtSignature setStringValue:L(@"LQHintNoSignature", @"NormalIMContainer")];
	else
		[m_txtSignature setStringValue:[[m_user signature] normalize]];
	[m_txtSignature setToolTip:[m_txtSignature stringValue]];
}

- (void)appendPacket:(QQTextView*)textView packet:(InPacket*)inPacket {
	ReceivedIMPacket* packet = (ReceivedIMPacket*)inPacket;

	switch([[packet normalIMHeader] normalIMType]) {
		case kQQNormalIMTypeText:
			PreferenceCache* cache = [PreferenceCache cache:[m_user QQ]];
			NSString* name = [m_user nick];
			if([cache showRealName]) {
				if(![[m_user remarkName] isEmpty])
					name = [m_user remarkName];
			}
				
			NormalIM* im = [packet normalIM];
			[self appendMessage:textView 
						   nick:name
						   data:[im messageData] 
						  style:[im fontStyle] 
						   date:[NSDate dateWithTimeIntervalSince1970:[im sendTime]]
					customFaces:nil];
			break;
		default:
			NSLog(@"Unsupported normal im type: %x", [[packet normalIMHeader] normalIMType]);
			break;
	}
}

- (UInt16)doSend:(NSData*)data style:(FontStyle*)style fragmentCount:(int)fragmentCount fragmentIndex:(int)fragmentIndex {
	return [[m_mainWindowController client] sendIM:[m_user QQ]
									   messageData:data
											 style:style
									 fragmentCount:fragmentCount
									 fragmentIndex:fragmentIndex];
}

- (void)handleHistoryDidSelected:(NSNotification*)notification {
	History* history = [[notification userInfo] objectForKey:kUserInfoHistory];
	if(history == m_history) {
		id object = [notification object];
		if([object isKindOfClass:[SentIM class]]) {
			[self appendMessageHint:m_txtInput
							   nick:[[m_mainWindowController me] nick]
							   date:[NSDate dateWithTimeIntervalSince1970:[(SentIM*)object sendTime]]
						 attributes:m_myHintAttributes];
			[[m_txtInput textStorage] appendAttributedString:[(SentIM*)object message]];
			if(![m_txtInput allowMultiFont])
				[m_txtInput changeAttributesOfAllText:[m_txtInput typingAttributes]];
		} else if([object isKindOfClass:[InPacket class]]) {
			[self appendPacket:m_txtInput packet:(InPacket*)object];
		}
	}
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleGetUserInfoOK:(QQNotification*)event {
	GetUserInfoReplyPacket* packet = [event object];
	if([[packet contact] QQ] == [m_user QQ]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kIMContainerModelDidChangedNotificationName
															object:m_user];
	}
	
	return NO;
}

- (BOOL)handleSendIMOK:(QQNotification*)event {
	SendIMReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// remove message from queue
		SendIMPacket* request = (SendIMPacket*)[event outPacket];
		if([request fragmentCount] == [request fragmentIndex] + 1)
			[m_sendQueue removeObjectAtIndex:0];
		
		// send next
		[self sendNextMessage];
		return YES;
	}
	return NO;
}

- (BOOL)handleSendIMTimeout:(QQNotification*)event {
	SendIMPacket* packet = (SendIMPacket*)[event outPacket];
	if([packet sequence] == m_waitingSequence) {
		// get message from queue
		NSAttributedString* message = [[m_sendQueue objectAtIndex:0] retain];
		
		// remove message
		[m_sendQueue removeObjectAtIndex:0];
		
		// change fragment index, so we can skip the timeout message
		m_nextFragmentIndex = m_fragmentCount;
		
		// append timeout hint to output text view
		NSAttributedString* string = [[NSAttributedString alloc] initWithString:L(@"LQHintTimeoutHeader", @"BaseIMContainer")
																	 attributes:m_errorHintAttributes];
		[[m_txtOutput textStorage] appendAttributedString:string];
		[string release];
		[[m_txtOutput textStorage] appendAttributedString:message];
		[message release];
		string = [[NSAttributedString alloc] initWithString:L(@"LQHintTimeoutTail", @"BaseIMContainer")
												 attributes:m_errorHintAttributes];
		[[m_txtOutput textStorage] appendAttributedString:string];
		[string release];
		
		// send next
		[self sendNextMessage];
		return YES;
	}
	return NO;
}

- (BOOL)handleModifySignatureOK:(QQNotification*)event {
	if([m_user QQ] == [[m_mainWindowController me] QQ])
		[self refreshSignature];
	return NO;
}

- (BOOL)handleGetSignatureOK:(QQNotification*)event {
	SignatureOpReplyPacket* packet = [event object];
	NSEnumerator* e = [[packet signatures] objectEnumerator];
	while(Signature* sig = [e nextObject]) {
		if([sig QQ] == [m_user QQ]) {
			[self refreshSignature];
			break;
		}
	}
		
	return NO;
}

@end
