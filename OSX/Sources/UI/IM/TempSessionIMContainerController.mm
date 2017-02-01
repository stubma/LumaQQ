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

#import "TempSessionIMContainerController.h"
#import "MainWindowController.h"
#import "TimerTaskManager.h"
#import "PreferenceCache.h"
#import "Constants.h"
#import "ImageTool.h"
#import "NSString-Validate.h"
#import "AlertTool.h"
#import "TextTool.h"
#import "FontTool.h"
#import "TempSessionOpReplyPacket.h"
#import "TempSessionOpPacket.h"
#import "AuthInfoOpReplyPacket.h"

@implementation TempSessionIMContainerController

- (void) dealloc {
	if(m_verifyCodeHelper) {
		[m_verifyCodeHelper cancel];
		[m_verifyCodeHelper release];
		m_verifyCodeHelper = nil;
	}
	[super dealloc];
}

#pragma mark -
#pragma mark IMContainer protocol

- (id)initWithObject:(id)obj mainWindow:(MainWindowController*)mainWindowController {
	m_user = (User*)obj;
	m_verifyCodeHelper = [[VerifyCodeHelper alloc] initWithQQ:[m_user QQ] delegate:self];
	return [super initWithObject:obj mainWindow:mainWindowController];
}

- (void)walkMessageQueue:(MessageQueue*)queue {
	if(queue == nil)
		return;
	
	while(InPacket* packet = [queue getTempSessionMessage:[m_user QQ] remove:YES]) {
		[self appendPacket:packet];
	}
	
	// refresh dock icon
	[m_mainWindowController refreshDockIcon];
	
	// adjust message count, stop blink if necessary
	if([m_user tempSessionMessageCount] > 0) {
		Group* g = [[m_mainWindowController groupManager] group:[m_user groupIndex]];
		if(g)
			[g setMessageCount:([g messageCount] - [m_user tempSessionMessageCount])];			
		[m_user setTempSessionMessageCount:0];
	}
}

- (NSString*)owner {
	return [NSString stringWithFormat:@"%u_tempsession", [m_user QQ]];
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
	return [NSString stringWithFormat:L(@"LQTitle", @"TempSessionIMContainer"), name, [m_user QQ]];
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

- (void)refreshHeadControl:(HeadControl*)headControl {
	[headControl setOwner:[[m_mainWindowController me] QQ]];
	[headControl setObjectValue:m_obj];
}

- (NSArray*)actionIds {
	if(m_actionIds == nil) {
		m_actionIds = [[NSArray arrayWithObjects:kToolbarItemFont, 
			kToolbarItemColor, 
			NSToolbarSeparatorItemIdentifier,
			kToolbarItemSmiley,
			nil] retain];
	}
	return m_actionIds;
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

- (NSString*)canSend {
	// get max byte can be sent
	int fontStyleBytes = [[FontTool chatFontStyleWithPreference:[[m_mainWindowController me] QQ]] byteCount];
	int max = kQQMaxMessageFragmentLength - fontStyleBytes;
	
	// get message data
	if(m_data) 
		[m_data release];
	m_data = [TextTool getTextData:[m_txtInput textStorage] faceList:nil];
	
	// check length
	if([m_data length] > max) {
		m_data = nil;
		return L(@"LqWarningTooLong", @"BaseIMContainer");
	} else {
		m_data = nil;
		return nil;
	}
}

- (BOOL)allowCustomFace {
	return NO;
}

#pragma mark -
#pragma mark PSMTabModel protocol

- (int)objectCount {
	return [m_user tempSessionMessageCount];
}

#pragma mark -
#pragma mark actions

- (IBAction)showOwnerInfo:(id)sender {
	[[m_mainWindowController windowRegistry] showUserInfoWindow:m_user mainWindow:m_mainWindowController];
}

#pragma mark -
#pragma mark initialization

- (void)awakeFromNib {
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

- (void)appendPacket:(QQTextView*)textView packet:(InPacket*)inPacket {
	ReceivedIMPacket* packet = (ReceivedIMPacket*)inPacket;		
	TempSessionIM* im = [packet tempSessionIM];
	[self appendMessage:textView 
				   nick:[im nick]
				   data:[im messageData] 
				  style:[im fontStyle] 
				   date:[NSDate dateWithTimeIntervalSince1970:[im sendTime]]
			customFaces:nil];
}

- (UInt16)doSend:(NSData*)data style:(FontStyle*)style fragmentCount:(int)fragmentCount fragmentIndex:(int)fragmentIndex {
	/*
	 * the doSend doesn't do send stuff for temp session im
	 */
	return [[m_mainWindowController client] getUserTempSessionIMAuthInfo:[m_user QQ]];
}

- (void)sendNextMessage {	
	// check queue
	if([m_sendQueue count] == 0) {
		m_sending = NO;
		return;
	}
	
	// temp session im doesn't support fragment, so don't check
	if(m_sending)
		return;
	m_sending = YES;
	
	// get next message
	NSAttributedString* message = [m_sendQueue objectAtIndex:0];
	
	// release old data
	if(m_data) {
		[m_data release];
		m_data = nil;
	}
	
	// get message data
	m_data = [[TextTool getTextData:message faceList:nil] retain];
	
	// send message
	m_waitingSequence = [self doSend:m_data
							   style:nil
					   fragmentCount:1
					   fragmentIndex:0];
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

- (void)showVerifyCodePanel {
	[NSApp beginSheet:m_verifyCodeWindow
	   modalForWindow:[m_imView window]
		modalDelegate:self
	   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
}

- (void)startGetVerifyCodeImage {
	[m_verifyCodeHelper start];
}

#pragma mark -
#pragma mark sheet delegate

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	switch(returnCode) {
		case NO:
			[m_sendQueue removeAllObjects];
			m_sending = NO;
			break;
	}
}

#pragma mark -
#pragma mark downloader delegate

- (void)downloadDidFinish:(NSURLDownload *)download {
	// refresh ui
	[m_btnRefresh setEnabled:YES];
	
	// set verify code image
	[m_ivVerifyCode setImage:[m_verifyCodeHelper image]];
	
	// refresh ui
	[m_piBusy setHidden:YES];
	[m_piBusy stopAnimation:self];
	[m_btnOK setEnabled:YES];
	[m_btnCancel setEnabled:YES];
	[m_btnRefresh setEnabled:YES];
	[m_txtHint setStringValue:kStringEmpty];
	
	// show code panel
	if(![m_verifyCodeWindow isVisible]) 
		[self showVerifyCodePanel];
}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error {
	// refresh ui
	[m_btnRefresh setEnabled:YES];
	
	// show warning
	[AlertTool showWarning:[m_imView window]
				   message:L(@"LQWarningGetVerifyCodeFailed", @"TempSessionIMContainer")];
}

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response {
}

#pragma mark -
#pragma mark actions

- (IBAction)onRefresh:(id)sender {
	[m_piBusy setHidden:NO];
	[m_piBusy startAnimation:self];
	[m_btnRefresh setEnabled:NO];
	[m_btnOK setEnabled:NO];
	[m_btnCancel setEnabled:NO];
	
	[self startGetVerifyCodeImage];
}

- (IBAction)onOK:(id)sender {
	[m_piBusy setHidden:NO];
	[m_piBusy startAnimation:self];
	[m_btnRefresh setEnabled:NO];
	[m_btnOK setEnabled:NO];
	[m_btnCancel setEnabled:NO];
	
	// get auto info by cookie
	NSString* cookieHex = [m_verifyCodeHelper cookie];
	m_waitingSequence = [[m_mainWindowController client] getUserTempSessionIMAuthInfo:[m_user QQ]
																		   verifyCode:[m_txtVerifyCode stringValue]
																			   cookie:cookieHex];
}

- (IBAction)onCancel:(id)sender {
	[NSApp endSheet:m_verifyCodeWindow returnCode:NO];
	[m_verifyCodeWindow orderOut:self];
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventGetUserInfoOK:
			ret = [self handleGetUserInfoOK:event];
			break;
		case kQQEventSendTempSessionIMOK:
			ret = [self handleSendTempSessionIMOK:event];
			break;
		case kQQEventSendTempSessionIMFailed:
			ret = [self handleSendTempSessionIMFailed:event];
			break;
		case kQQEventGetAuthInfoOK:
			ret = [self handleGetAuthInfoOK:event];
			break;
		case kQQEventGetAuthInfoNeedVerifyCode:
			ret = [self handleGetAuthInfoNeedVerifyCode:event];
			break;
		case kQQEventGetAuthInfoByVerifyCodeOK:
			ret = [self handleGetAuthInfoByVerifyCodeOK:event];
			break;
		case kQQEventGetAuthInfoByVerifyCodeRetry:
			ret = [self handleGetAuthInfoByVerifyCodeRetry:event];
			break;
		case kQQEventTimeoutBasic:
			OutPacket* packet = [event outPacket];
			switch([packet command]) {
				case kQQCommandTempSessionOp:
					ret = [self handleTempSessionOpTimeout:event];
					break;
			}
			break;
	}
	
	return NO;
}

- (BOOL)handleGetUserInfoOK:(QQNotification*)event {
	GetUserInfoReplyPacket* packet = [event object];
	if([[packet contact] QQ] == [m_user QQ]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kIMContainerModelDidChangedNotificationName
															object:m_user];
	}
	
	return NO;
}

- (BOOL)handleSendTempSessionIMOK:(QQNotification*)event {
	TempSessionOpReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// remove message from queue
		[m_sendQueue removeObjectAtIndex:0];
		
		// send next
		m_sending = NO;
		[self sendNextMessage];
		return YES;
	}
	return NO;
}

- (BOOL)handleSendTempSessionIMFailed:(QQNotification*)event {
	TempSessionOpReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// get message from queue
		NSAttributedString* message = [[m_sendQueue objectAtIndex:0] retain];
		
		// remove message
		[m_sendQueue removeObjectAtIndex:0];
		
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
		m_sending = NO;
		[self sendNextMessage];
		return YES;
	}
	
	return NO;
}

- (BOOL)handleTempSessionOpTimeout:(QQNotification*)event {
	TempSessionOpPacket* packet = (TempSessionOpPacket*)[event outPacket];
	if([packet sequence] == m_waitingSequence) {
		// get message from queue
		NSAttributedString* message = [[m_sendQueue objectAtIndex:0] retain];
		
		// remove message
		[m_sendQueue removeObjectAtIndex:0];
		
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
		m_sending = NO;
		[self sendNextMessage];
		return YES;
	}
	return NO;
}

- (BOOL)handleGetAuthInfoOK:(QQNotification*)event {
	AuthInfoOpReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {		
		// send temp im
		m_waitingSequence = [[m_mainWindowController client] sendTempSessionIM:[m_user QQ]
																   messageData:m_data
																	senderName:[[m_mainWindowController me] nick]
																	senderSite:@"LumaQQ"
																		 style:[FontTool chatFontStyleWithPreference:[[m_mainWindowController me] QQ]]
																	  authInfo:[packet authInfo]];
		
		// handled, so return YES
		return YES;
	}
	
	return NO;
}

- (BOOL)handleGetAuthInfoNeedVerifyCode:(QQNotification*)event {
	AuthInfoOpReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// save url
		[m_verifyCodeHelper setUrl:[packet url]];
		
		// start to get verify code image
		[self startGetVerifyCodeImage];
		
		return YES;
	}
	
	return NO;
}

- (BOOL)handleGetAuthInfoByVerifyCodeOK:(QQNotification*)event {
	AuthInfoOpReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// hide verify code window
		[m_piBusy setHidden:YES];
		[m_piBusy stopAnimation:self];
		[m_btnOK setEnabled:YES];
		[m_btnCancel setEnabled:YES];
		[m_btnRefresh setEnabled:YES];
		[NSApp endSheet:m_verifyCodeWindow returnCode:YES];
		[m_verifyCodeWindow orderOut:self];
		
		// send temp im
		m_waitingSequence = [[m_mainWindowController client] sendTempSessionIM:[m_user QQ]
																   messageData:m_data
																	senderName:[[m_mainWindowController me] nick]
																	senderSite:@"LumaQQ"
																		 style:[FontTool chatFontStyleWithPreference:[[m_mainWindowController me] QQ]]
																	  authInfo:[packet authInfo]];
		return YES;
	}
	
	return NO;
}

- (BOOL)handleGetAuthInfoByVerifyCodeRetry:(QQNotification*)event {
	AuthInfoOpReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// stop ui
		[m_piBusy setHidden:YES];
		[m_piBusy stopAnimation:self];
		[m_btnOK setEnabled:YES];
		[m_btnCancel setEnabled:YES];
		[m_btnRefresh setEnabled:YES];
		[m_txtHint setStringValue:L(@"LQHintVerifyCodeRetry", @"TempSessionIMContainer")];
		
		return YES;
	}
	return NO;
}

@end
