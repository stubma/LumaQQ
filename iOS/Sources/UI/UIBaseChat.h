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

#import <UIKit/UIKit.h>
#import <UIKit/UITable.h>
#import <UIKit/UIButtonBarButton.h>
#import "UIUnit.h"
#import "MessageManager.h"
#import "GroupManager.h"
#import "QQClient.h"
#import "ImageChooser.h"
#import "IMServiceCallback.h"

@interface UIBaseChat : NSObject <UIUnit, ImageProvider, IMServiceCallback> {
	UIController* _uiController;
	
	UIView* _view;
	UITable* _table;
	UIKeyboard* _keyboard;
	UITextField* _inputField;
	UIPushButton* _faceButton;
	UIPushButton* _inputBar;
	ImageChooser* _faceChooser;
	UIButtonBar* _buttonBar;
	NSMutableDictionary* _data;
	GroupManager* _groupManager;
	MessageManager* _messageManager;
	QQClient* _client;
	int _selectedTag;
	
	// models for table, maybe ReceivedIMPacket, maybe NSString
	NSMutableArray* _msgModels;
	NSMutableArray* _cells;
	
	// control animation
	int _waitingCount;
}

- (void)_back;
- (void)_appendString:(NSString*)string;
- (void)_appendError:(NSString*)string;
- (id)_model;
- (void)_appendMessage:(NSDictionary*)properties;
- (void)_showFaceChooser;
- (void)_showKeyboard;
- (void)_hide;
- (void)_reloadMessages;
- (void)_createButtonBar:(CGRect)frame;

- (void)sendButtonClicked:(UIPushButton*)button;
- (void)faceButtonClicked:(UIButtonBarButton*)button;
- (void)keyboardButtonClicked:(UIButtonBarButton*)button;
- (void)hideButtonClicked:(UIButtonBarButton*)button;

- (void)handleWillResume:(NSNotification*)notification;
- (void)handleSendIMTimeout:(NSNotification*)notification;
- (void)handleSendClusterIMTimeout:(NSNotification*)notification;
- (void)handleSendClusterIMFailed:(NSNotification*)notification;

@end
