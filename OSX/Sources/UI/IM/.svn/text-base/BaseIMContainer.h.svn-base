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
#import "IMContainer.h"
#import "QQTextView.h"
#import "HeadControl.h"
#import "ImageSelectorWindowController.h"
#import "FontStyle.h"
#import "ReceivedIMPacket.h"
#import "QQEvent.h"
#import "LocalizedStringTool.h"
#import "DefaultFace.h"
#import "History.h"
#import "HistoryDrawerController.h"
#import "CustomFaceList.h"

// common toolbar items
#define kToolbarItemFont @"ToolbarItemFont"
#define kToolbarItemColor @"ToolbarItemColor"
#define kToolbarItemSmiley @"ToolbarItemSmiley"
#define kToolbarItemSendPicture @"ToolbarItemSendPicture"
#define kToolbarItemScreenscrap @"ToolbarItemScreenscrap"

@interface BaseIMContainer : NSObject <IMContainer, NSCopying> {
	IBOutlet NSView* m_imView;
	
	IBOutlet QQTextView* m_txtInput;
	IBOutlet QQTextView* m_txtOutput;
	
	// for psm tab
	NSObjectController* m_objectController;
	
	// main window, image selector window
	id m_obj;
	MainWindowController* m_mainWindowController;	
	ImageSelectorWindowController* m_faceSelector;
	
	// message send queue and sending related variables
	NSMutableArray* m_sendQueue;
	BOOL m_sending;
	UInt16 m_waitingSequence;
	int m_fragmentCount;
	int m_nextFragmentIndex;
	NSData* m_data;
	CustomFaceList* m_faceList;
	
	// date formatter
	NSDateFormatter* m_formatter;
	
	// default attribute
	NSMutableDictionary* m_myHintAttributes;
	NSMutableDictionary* m_otherHintAttributes;
	NSMutableDictionary* m_errorHintAttributes;
	
	// history
	History* m_history;
	
	// custom face waiting list, to track receiving faces
	// key is filename, value is NSTextAttachment
	NSMutableDictionary* m_faceWaitingList;
	
	// custom face sending list, to track sending faces
	// key is filename, valude is CustomFace
	NSMutableDictionary* m_faceSendingList;
	
	// action id array
	NSArray* m_actionIds;
	
	// for face preview
	NSWindow* m_winFacePreview;
	NSImageView* m_ivPreview;
	NSTextField* m_txtShortcut;
}

// helper
- (void)handleWindowWillClose:(NSNotification*)notification;
- (void)sendNextMessage;
- (void)createPreviewWindow;
- (void)showPreviewWindow;
- (void)sendCustomFaces:(CustomFaceList*)faceList;
- (UInt16)doSend:(NSData*)data style:(FontStyle*)style fragmentCount:(int)fragmentCount fragmentIndex:(int)fragmentIndex;
- (void)appendPacket:(InPacket*)inPacket;
- (void)appendPacket:(QQTextView*)textView packet:(InPacket*)inPacket;
- (void)appendMessage:(NSString*)nick data:(NSData*)data style:(FontStyle*)style date:(NSDate*)date customFaces:(CustomFaceList*)faceList;
- (void)appendMessage:(QQTextView*)textView nick:(NSString*)nick data:(NSData*)data style:(FontStyle*)style date:(NSDate*)date customFaces:(CustomFaceList*)faceList;
- (void)appendMessageHint:(NSString*)nick date:(NSDate*)date attributes:(NSDictionary*)attributes;
- (void)appendMessageHint:(QQTextView*)textView nick:(NSString*)nick date:(NSDate*)date attributes:(NSDictionary*)attributes;
- (void)handleHistoryDidSelected:(NSNotification*)notification;
- (void)handleCustomFaceDidReceived:(NSNotification*)notification;
- (void)handleCustomFaceFailedToReceive:(NSNotification*)notification;
- (void)handleCustomFaceDidSent:(NSNotification*)notification;
- (void)handleCustomFaceListFailedToSend:(NSNotification*)notification;
- (void)handleIMContainerAttachedToWindow:(NSNotification*)notification;
- (void)handleModelMessageCountChanged:(NSNotification*)notification;

// actions
- (IBAction)onFont:(id)sender;
- (IBAction)onColor:(id)sender;
- (IBAction)onSmiley:(id)sender;
- (IBAction)onColorChanged:(id)sender;
- (IBAction)onFaceManager:(id)sender;
- (IBAction)onSendPicture:(id)sender;
- (IBAction)onScreenscrap:(id)sender;
- (IBAction)onSend:(id)sender;

// getter and setter
- (QQTextView*)outputBox;

@end
