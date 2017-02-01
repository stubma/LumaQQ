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

#import <Cocoa/Cocoa.h>
#import "WorkflowModerator.h"
#import "HeadControl.h"

#define kWorkflowApproveReject @"ApproveReject"

@class MainWindowController;

@interface AuthWindowController : NSWindowController <WorkflowDataSource> {
	IBOutlet NSTextView* m_txtMessage;
	IBOutlet HeadControl* m_headControl;
	IBOutlet NSMatrix* m_matrixResponse;
	IBOutlet NSTextField* m_txtRejectReason;
	IBOutlet NSButton* m_chkOption;
	IBOutlet NSBox* m_boxApproveReject;
	
	IBOutlet NSProgressIndicator* m_piBusy;
	IBOutlet NSTextField* m_txtHint;
	IBOutlet NSButton* m_btnOK;
	
	IBOutlet NSTextField* m_txtToGroup;
	IBOutlet NSComboBox* m_cbGroup;
	
	id m_object;
	MainWindowController* m_mainWindowController;
	
	WorkflowModerator* m_moderator;
}

- (id)initWithObject:(id)obj mainWindow:(MainWindowController*)mainWindowController;

// subclass should implement following
- (BOOL)showMessageOnly;
- (NSString*)windowTitle;
- (void)initControl;
- (void)initModel;
- (NSString*)message;
- (void)buildWorkflow:(NSString*)name;
- (void)startHint:(NSString*)hint;
- (void)stopHint;

// action
- (IBAction)onHead:(id)sender;
- (IBAction)onOK:(id)sender;
- (IBAction)onResponseChange:(id)sender;
- (IBAction)onOptionChanged:(id)sender;

@end
