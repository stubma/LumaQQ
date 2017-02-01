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

#import <Cocoa/Cocoa.h>
#import "HeadControl.h"
#import "WorkflowModerator.h"
#import "User.h"

@class MainWindowController;

@interface DeleteUserWindowController : NSWindowController <WorkflowDataSource> {
	IBOutlet HeadControl* m_headControl;
	IBOutlet NSProgressIndicator* m_piBusy;
	IBOutlet NSTextField* m_txtTitle;
	IBOutlet NSTextField* m_txtHint;
	
	NSData* m_authInfo;
	User* m_user;
	MainWindowController* m_mainWindowController;
	
	WorkflowModerator* m_moderator;
}

- (id)initWithUser:(User*)user mainWindow:(MainWindowController*)mainWindowController;

// helper
- (void)buildWorkflow:(NSString*)name;
- (void)startHint:(NSString*)hint;
- (void)stopHint;

// action
- (IBAction)onClose:(id)sender;

// qq event handler
- (BOOL)handleGetAuthInfoOK:(QQNotification*)event;
- (BOOL)handleDeleteFriendOK:(QQNotification*)event;
- (BOOL)handleRemoveFriendFromServerListOK:(QQNotification*)event;

@end
