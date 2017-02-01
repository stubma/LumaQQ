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

#import "Constants.h"
#import "AuthWindowController.h"
#import "MainWindowController.h"

@implementation AuthWindowController

- (id)initWithObject:(id)obj mainWindow:(MainWindowController*)mainWindowController {
	self = [super initWithWindowNibName:@"AuthWindow"];
	if(self) {
		m_object = [obj retain];
		m_mainWindowController = [mainWindowController retain];
		[self initModel];
	}
	return self;
}

- (void) dealloc {
	[m_object release];
	[m_mainWindowController release];
	[super dealloc];
}

- (void)windowDidLoad {
	// init controls
	[self initControl];
	[m_txtMessage setString:[self message]];
	[self onResponseChange:m_matrixResponse];
	
	// init title
	[[self window] setTitle:[self windowTitle]];
	
	// init layout
	if([self showMessageOnly]) {
		NSRect frame = [[self window] frame];
		NSRect bound = [m_boxApproveReject bounds];
		[m_boxApproveReject removeFromSuperview];
		[m_chkOption removeFromSuperview];
		frame.size.height -= bound.size.height;
		[[self window] setFrame:frame display:NO];
	}
	
	// create workflow moderator
	m_moderator = [[WorkflowModerator alloc] initWithName:kWorkflowApproveReject dataSource:self];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	if(m_moderator) {
		[m_moderator cancel];
		[m_moderator release];
		m_moderator = nil;
	}
	[self release];
}

- (void)startHint:(NSString*)hint {
	[m_piBusy setHidden:NO];
	[m_piBusy startAnimation:self];
	[m_txtHint setStringValue:hint];
}

- (void)stopHint {
	[m_piBusy stopAnimation:self];
	[m_piBusy setHidden:YES];
	[m_txtHint setStringValue:kStringEmpty];
}

#pragma mark -
#pragma mark subclass should implement following

- (void)buildWorkflow:(NSString*)name {
}

- (NSString*)message {
	return kStringEmpty;
}

- (BOOL)showMessageOnly {
	return YES;
}

- (NSString*)windowTitle {
	return kStringEmpty;
}

- (void)initControl {
}

- (void)initModel {
}

#pragma mark -
#pragma mark actions

- (IBAction)onHead:(id)sender {
	
}

- (IBAction)onOK:(id)sender {
	[self close];
}

- (IBAction)onResponseChange:(id)sender {
}

- (IBAction)onOptionChanged:(id)sender {
}

#pragma mark -
#pragma mark workflow data source protocol

- (BOOL)handleQQEvent:(QQNotification*)event {
	return NO;
}

- (void)workflowStart:(NSString*)workflowName {
	[m_btnOK setEnabled:NO];
}

- (UInt16)executeWorkflowUnit:(NSString*)unitName hint:(NSString*)hint {
	return 0;
}

- (NSString*)workflowUnitHint:(NSString*)unitName {
	return kStringEmpty;
}

- (void)workflow:(NSString*)workflowName end:(BOOL)success {
	[self stopHint];
	[m_btnOK setEnabled:YES];
	if(success) {
		[m_txtHint setStringValue:L(@"LQHintSuccess", @"AuthWindow")];
		[self close];
	} else
		[m_txtHint setStringValue:L(@"LQHintFail", @"AuthWindow")];
}

- (BOOL)needExecuteWorkflowUnit:(NSString*)unitName {
	return YES;
}

- (BOOL)acceptEvent:(int)eventId {
	return NO;
}

#pragma mark -
#pragma mark combobox data source

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index {
	return [[[m_mainWindowController groupManager] group:index] name];
}

- (int)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	return [[m_mainWindowController groupManager] friendlyGroupCount];
}

@end
