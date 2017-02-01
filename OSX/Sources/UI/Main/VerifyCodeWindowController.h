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
#import "GetLoginTokenReplyPacket.h"

@class MainWindowController;

@interface VerifyCodeWindowController : NSObject {
	IBOutlet NSWindow* winVerifyCode;
    IBOutlet NSImageView *imgVerifyCode;
    IBOutlet NSTextField *txtVerifyCode;
	IBOutlet NSButton* btnOK;
	IBOutlet NSButton* btnCancel;
	IBOutlet NSButton* btnChangeImage;
	IBOutlet NSProgressIndicator* piBusy;
	
	IBOutlet MainWindowController* mainWindowController;
	
	// reply packet
	GetLoginTokenReplyPacket* m_packet;
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;
- (void)beginSheet:(GetLoginTokenReplyPacket*)packet;
- (void)refresh:(GetLoginTokenReplyPacket*)packet;

// action
- (IBAction)onCancel:(id)sender;
- (IBAction)onChangeImage:(id)sender;
- (IBAction)onOK:(id)sender;

// getter and setter
- (NSWindow*)window;

@end
