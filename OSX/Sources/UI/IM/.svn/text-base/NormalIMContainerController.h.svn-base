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
#import "BaseIMContainer.h"
#import "QQSplitView.h"
#import "User.h"

@class MainWindowController;

@interface NormalIMContainerController : BaseIMContainer {	
	IBOutlet QQSplitView* m_split;
	IBOutlet NSTextField* m_txtLocation;
	IBOutlet NSTextField* m_txtSignature;
	
	User* m_user;
}

// helper
- (NSString*)ipLocation;
- (void)refreshSignature;

// qq event handler
- (BOOL)handleGetUserInfoOK:(QQNotification*)event;
- (BOOL)handleSendIMOK:(QQNotification*)event;
- (BOOL)handleSendIMTimeout:(QQNotification*)event;
- (BOOL)handleModifySignatureOK:(QQNotification*)event;
- (BOOL)handleGetSignatureOK:(QQNotification*)event;

@end
