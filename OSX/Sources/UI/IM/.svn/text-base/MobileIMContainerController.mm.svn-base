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

#import "MobileIMContainerController.h"
#import "Constants.h"
#import "MainWindowController.h"
#import "ByteTool.h"
#import "ImageTool.h"
#import "SendSMSPacket.h"
#import "SendSMSReplyPacket.h"
#import "AlertTool.h"
#import "SMSReply.h"
#import "NSString-Validate.h"
#import "TimerTaskManager.h"

@implementation MobileIMContainerController

#pragma mark -
#pragma mark IMContainer protocol

- (id)initWithObject:(id)obj mainWindow:(MainWindowController*)mainWindowController {
	m_useMobile = [obj isMemberOfClass:[Mobile class]];
	if(m_useMobile)
		m_mobile = (Mobile*)obj;
	else
		m_user = (User*)obj;
	return [super initWithObject:obj mainWindow:mainWindowController];
}

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventSMSSent:
			ret = [self handleSMSSent:event];
			break;
		case kQQEventTimeoutBasic:
			OutPacket* packet = [event outPacket];
			switch([packet command]) {
				case kQQEventSMSSent:
					ret = [self handleSendSMSTimeout:event];
					break;
			}
			break;
	}
	
	return ret;
}

- (void)walkMessageQueue:(MessageQueue*)queue {
	if(queue == nil)
		return;
	
	if(m_useMobile) {
		while(InPacket* packet = [queue getMobileMessageByMobile:[m_mobile mobile] remove:YES])
			[self appendPacket:packet];
	} else {
		while(InPacket* packet = [queue getMobileMessage:[m_user QQ] remove:YES])
			[self appendPacket:packet];
	}
	
	// refresh dock icon
	[m_mainWindowController refreshDockIcon];
	
	// adjust message count, stop blink if necessary
	if(m_useMobile) {
		[m_mobile setMessageCount:0];
	} else {
		if([m_user mobileMessageCount] > 0) {
			Group* g = [[m_mainWindowController groupManager] group:[m_user groupIndex]];
			if(g)
				[g setMessageCount:([g messageCount] - [m_user mobileMessageCount])];			
			[m_user setMobileMessageCount:0];
		}
	}
}

- (NSString*)owner {
	if(m_useMobile)
		return [m_mobile mobile];
	else 
		return [NSString stringWithFormat:@"%u_mobile", [m_user QQ]];
}

- (NSImage*)ownerImage {
	if(m_useMobile)
		return [NSImage imageNamed:kImageMobiles];
	else
		return [ImageTool headWithId:[m_user head]];
}

- (void)refreshHeadControl:(HeadControl*)headControl {
	if([m_obj isMemberOfClass:[Mobile class]]) {
		[headControl setHead:kHeadUseImage];
		[headControl setShowStatus:NO];
		[headControl setImage:[self ownerImage]];
	} else
		[headControl setObjectValue:m_obj];
}

- (id)windowKey {
	if(m_useMobile)
		return [m_mobile mobile];
	else
		return [NSNumber numberWithUnsignedInt:[m_user QQ]];
}

- (NSString*)description {
	NSString* title = L(@"LQTitle", @"MobileIMContainer");
	if(m_useMobile) 
		return [NSString stringWithFormat:title, [m_mobile name], [m_mobile mobile]];
	else 
		return [NSString stringWithFormat:title, [m_user nick], [NSNumber numberWithUnsignedInt:[m_user QQ]]];
}

- (NSString*)shortDescription {
	if(m_useMobile)
		return [m_mobile name];
	else
		return [m_user nick];
}

- (NSArray*)actionIds {
	if(m_actionIds == nil) {
		m_actionIds = [[NSArray array] retain];
	}
	return m_actionIds;
}

- (IBAction)showOwnerInfo:(id)sender {
	if(!m_useMobile)
		[[m_mainWindowController windowRegistry] showUserInfoWindow:m_user mainWindow:m_mainWindowController];
}

- (void)handleIMContainerAttachedToWindow:(NSNotification*)notification {
	if(m_imView == [notification object]) {
		[m_split setDelegate:self];
		
		// get input box proportion
		float proportion = [m_obj inputBoxProportion];
		
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
	if(m_useMobile)
		return [m_mobile messageCount];
	else
		return [m_user mobileMessageCount];
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
	[m_obj setInputBoxProportion:newProp];
}

#pragma mark -
#pragma mark helper

- (void)appendPacket:(QQTextView*)textView packet:(InPacket*)inPacket {
	ReceivedIMPacket* packet = (ReceivedIMPacket*)inPacket;
	
	// get nick
	NSString* nick = nil;
	if(m_useMobile) {
		if([m_mobile name] != nil || [[m_mobile name] isEmpty])
			nick = [m_mobile name];
		else
			nick = [m_mobile mobile];
	} else
		nick = [m_user nick];
	
	// append time
	MobileIM* im = [packet mobileIM];
	[self appendMessageHint:textView
					   nick:nick
					   date:[NSDate dateWithTimeIntervalSince1970:[im sendTime]]
				 attributes:m_otherHintAttributes];
	
	// append im
	NSAttributedString* string = [[NSAttributedString alloc] initWithString:[im message]
																 attributes:[m_txtInput typingAttributes]];
	[[textView textStorage] appendAttributedString:string];
	[string release];
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

- (UInt16)doSend:(NSData*)data style:(FontStyle*)style fragmentCount:(int)fragmentCount fragmentIndex:(int)fragmentIndex {
	if(m_useMobile) {
		return [[m_mainWindowController client] sendSMSToMobile:[m_mobile mobile]
													 senderName:[m_txtSenderName stringValue]
														message:data
													   sequence:fragmentIndex];
	} else {
		return [[m_mainWindowController client] sendSMSToQQ:[m_user QQ]
												 senderName:[m_txtSenderName stringValue]
													message:data
												   sequence:fragmentIndex];
	}
}

- (IBAction)send:(id)sender {
	if([[m_txtInput textStorage] length] == 0) {
		[AlertTool showWarning:[m_imView window]
					   message:L(@"LQWarningEmptyMessage", @"BaseIMContainer")];
	} else {
		// create SentIM
		NSDate* date = [NSDate date];
		SentIM* sentIM = [[[SentIM alloc] initWithTime:[date timeIntervalSince1970]
											   message:[[[m_txtInput textStorage] copyWithZone:nil] autorelease]] autorelease];
		
		// add to history
		[m_history addSentIM:sentIM];
		
		// add message to send queue
		[m_sendQueue addObject:[sentIM message]];
		
		// append hint
		[self appendMessageHint:[m_txtSenderName stringValue]
						   date:date
					 attributes:m_myHintAttributes];
		
		// add to output
		[[m_txtOutput textStorage] appendAttributedString:[sentIM message]];
		[m_txtOutput scrollRangeToVisible:NSMakeRange([[m_txtOutput textStorage] length], 0)];
		
		// clear input
		[m_txtInput setString:kStringEmpty];
		
		// calculate max fragment length
		m_maxLength = kQQMaxSMSCharacters - [[m_txtSenderName stringValue] length];
		
		// send
		if(!m_sending)
			[self sendNextMessage];
	}
}

- (void)sendNextMessage {	
	// check queue
	if([m_sendQueue count] == 0) {
		m_sending = NO;
		return;
	}
	
	// get next message
	NSString* message = [[m_sendQueue objectAtIndex:0] string];
	
	// if sending, check fragment count
	if(m_sending) {
		if(m_fragmentCount > 1 && m_nextFragmentIndex < m_fragmentCount) {
			//
			// has more fragment need to be sent
			//
			
			// get data and send
			int length = MIN(m_maxLength, [message length] - m_nextFragmentIndex * m_maxLength);
			NSString* subMessage = [message substringWithRange:NSMakeRange(m_nextFragmentIndex * m_maxLength, length)];
			subMessage = [NSString stringWithFormat:@"%d/%d\n%@", (m_nextFragmentIndex + 1), m_fragmentCount, subMessage];
			NSData* messageData = [ByteTool getBytes:subMessage];
			m_waitingSequence = [self doSend:messageData
									   style:nil
							   fragmentCount:m_fragmentCount
							   fragmentIndex:m_nextFragmentIndex];
			m_nextFragmentIndex++;				
			return;
		}
	} else
		m_sending = YES;
	
	//
	// if program executes to here, means previous message is not long message
	// so we go on next
	//
	
	// calculate fragment count
	m_fragmentCount = ([message length] - 1) / m_maxLength + 1;
	
	if(m_fragmentCount > 1) {
		// set next index
		m_nextFragmentIndex = 0;
		
		// send first fragment
		NSString* subMessage = [message substringToIndex:m_maxLength];
		subMessage = [NSString stringWithFormat:@"%d/%d\n%@", (m_nextFragmentIndex + 1), m_fragmentCount, subMessage];
		NSData* messageData = [ByteTool getBytes:subMessage];
		m_waitingSequence = [self doSend:messageData
								   style:nil
						   fragmentCount:m_fragmentCount
						   fragmentIndex:m_nextFragmentIndex];
		m_nextFragmentIndex++;
	} else {
		// send message
		m_waitingSequence = [self doSend:[ByteTool getBytes:message]
								   style:nil
						   fragmentCount:1
						   fragmentIndex:0];
	}
}

#pragma mark -
#pragma mark initialization

- (void)awakeFromNib {
	[super awakeFromNib];
	
	// sender name
	[m_txtSenderName setStringValue:[[m_mainWindowController me] nick]];
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleSMSSent:(QQNotification*)event {
	SendSMSReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// get reply 
		SMSReply* reply = nil;
		if(m_useMobile)
			reply = [[packet mobileReplies] objectAtIndex:0];
		else
			reply = [[packet QQReplies] objectAtIndex:0];
		
		// get request packet
		SendSMSPacket* request = (SendSMSPacket*)[event outPacket];
		
		// failed?
		if([reply reply] != kQQReplyOK || m_fragmentCount == [request messageSequence] + 1) {			
			// append hint to output text view
			NSString* hint = [NSString stringWithFormat:@"\n%@, %@", [reply message], [packet replyMessage]];
			NSAttributedString* string = [[NSAttributedString alloc] initWithString:hint
																		 attributes:m_errorHintAttributes];
			[[m_txtOutput textStorage] appendAttributedString:string];
			[string release];
			
			// remove sending message
			[m_sendQueue removeObjectAtIndex:0];
		} 

		// send next
		if([reply reply] == kQQReplyOK)
			[self sendNextMessage];
		return YES;
	}
	return NO;
}

- (BOOL)handleSendSMSTimeout:(QQNotification*)event {
	SendSMSPacket* packet = (SendSMSPacket*)[event outPacket];
	if([packet sequence] == m_waitingSequence) {
		// append hint
		NSString* message = [[m_sendQueue objectAtIndex:0] string];
		NSString* hint = [NSString stringWithFormat:L(@"LQHintTimeout", @"MobileIMContainer"), message];
		NSAttributedString* string = [[NSAttributedString alloc] initWithString:hint
																	 attributes:m_errorHintAttributes];
		[[m_txtOutput textStorage] appendAttributedString:string];
		[string release];

		// remove sending message
		[m_sendQueue removeObjectAtIndex:0];

		[self sendNextMessage];
		
		return YES;
	}
	return NO;
}

@end
