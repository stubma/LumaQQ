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

#import "VerifyCodeWindowController.h"
#import "MainWindowController.h"

@implementation VerifyCodeWindowController

- (void) dealloc {
	[m_packet release];
	[super dealloc];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	if(returnCode) {
		// when end, if ok, submit verify code
		[[mainWindowController client] submitVerifyCode:[m_packet token]
											 verifyCode:[txtVerifyCode stringValue]];
	} else {
		// if cancel, return to login window
		[mainWindowController shutdownNetwork];
		[mainWindowController returnToLogin];
	}
	[m_packet release];
	m_packet = nil;
}

- (void)beginSheet:(GetLoginTokenReplyPacket*)packet {	
	// save packet
	[packet retain];
	[m_packet release];
	m_packet = packet;
	
	// set verify code image
	NSImage* image = [[NSImage alloc] initWithData:[packet puzzleData]];
	if(image != nil) {
		[imgVerifyCode setImage:image];
		[image release];
	}
	
	// begin sheet
	[NSApp beginSheet:winVerifyCode
	   modalForWindow:[mainWindowController window]
		modalDelegate:self
	   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
}

- (void)refresh:(GetLoginTokenReplyPacket*)packet {
	// save packet
	[packet retain];
	[m_packet release];
	m_packet = packet;
	
	// set verify code image
	NSImage* image = [[NSImage alloc] initWithData:[packet puzzleData]];
	if(image != nil) {
		[imgVerifyCode setImage:image];
		[image release];
	}
	
	// enable controls
	[btnOK setEnabled:YES];
	[btnCancel setEnabled:YES];
	[btnChangeImage setEnabled:YES];
	
	// hide progress indicator
	[piBusy stopAnimation:self];
	[piBusy setHidden:YES];
}

#pragma mark -
#pragma mark actions

- (IBAction)onCancel:(id)sender
{
	// close network setting sheet
	[NSApp endSheet:winVerifyCode returnCode:NO];
	[winVerifyCode orderOut:self];
}

- (IBAction)onChangeImage:(id)sender
{
	// disable buttons
	[btnOK setEnabled:NO];
	[btnCancel setEnabled:NO];
	[btnChangeImage setEnabled:NO];
	
	// start indicator
	[piBusy setHidden:NO];
	[piBusy startAnimation:self];
	
	// send refresh image request
	[[mainWindowController client] refreshVerifyCodeImage:[m_packet token]];
}

- (IBAction)onOK:(id)sender
{
	// close network setting sheet
	[NSApp endSheet:winVerifyCode returnCode:YES];
	[winVerifyCode orderOut:self];
}

#pragma mark -
#pragma mark getter and setter

- (NSWindow*)window {
	return winVerifyCode;
}

@end
