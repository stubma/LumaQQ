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
#import "POIFSFileSystem.h"
#import "Face.h"
#import "FaceGroup.h"

@class MainWindowController;

@interface FaceManagerWindowController : NSWindowController {
	IBOutlet NSPopUpButton* m_pbGroup;
	IBOutlet NSImageView* m_ivPreview;
	IBOutlet NSTableView* m_faceTable;
	IBOutlet NSWindow* m_inputWindow;
	IBOutlet NSTextField* m_txtInput;
	IBOutlet NSWindow* m_progressWindow;
	IBOutlet NSProgressIndicator* m_progressBar;
	
	MainWindowController* m_mainWindowController;
	NSArray* m_importGroups;
	NSArray* m_importFaces;
	NSArray* m_importPictures;
	int m_sheetType;
	int m_importType;
	BOOL m_includeGroup;
	POIFSFileSystem* m_poifs;
}

- (id)initWithMainWindow:(MainWindowController*)mainWindowController;

- (void)createGroupMenuItems;

- (IBAction)onGroupChanged:(id)sender;
- (IBAction)onDeleteFace:(id)sender;
- (IBAction)onDeleteGroup:(id)sender;
- (IBAction)onNewGroup:(id)sender;
- (IBAction)onImportPicture:(id)sender;
- (IBAction)onImportFacePackage:(id)sender;
- (IBAction)onClose:(id)sender;
- (IBAction)onInputOK:(id)sender;
- (IBAction)onInputCancel:(id)sender;
- (IBAction)onFaceTableSelectionChanged:(id)sender;

- (void)includeGroupAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;
- (void)addFace:(Face*)face toGroup:(FaceGroup*)g srcGroupName:(NSString*)srcGroupName ungrouped:(BOOL)ungrouped;

@end
