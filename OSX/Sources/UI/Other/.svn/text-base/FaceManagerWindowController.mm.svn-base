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

#import "FaceManagerWindowController.h"
#import "FaceManager.h"
#import "FileTool.h"
#import "NSString-Validate.h"
#import "MainWindowController.h"
#import "AlertTool.h"
#import "POIFSFileSystem.h"
#import "FaceConfigParser.h"
#import "NSData-MD5.h"
#import "ByteTool.h"
#import "Constants.h"
#import "NSData-BytesOperation.h"

#define _kSheetOpen 0
#define _kSheetIncludeGroup 1
#define _kSheetNewGroup 2

#define _kImportPicture 0
#define _kImportEIP 1

@implementation FaceManagerWindowController

- (id)initWithMainWindow:(MainWindowController*)mainWindowController {
	self = [super initWithWindowNibName:@"FaceManager"];
	if(self) {
		m_mainWindowController = [mainWindowController retain];
		m_sheetType = -1;
	}
	return self;
}

- (void)windowDidLoad {
	[self createGroupMenuItems];
	
	// set title
	[[self window] setTitle:[NSString stringWithFormat:L(@"LQTitle", @"FaceManager"), [[m_mainWindowController me] QQ]]];
	
	// register
	[[m_mainWindowController windowRegistry] registerFaceManagerWindow:[[m_mainWindowController me] QQ] window:self];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	[[m_mainWindowController windowRegistry] unregisterFaceManagerWindow:[[m_mainWindowController me] QQ]];
	[self release];
}

- (void)windowDidEndSheet:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	switch(m_sheetType) {
		case _kSheetOpen:
		{
			m_sheetType = -1;
			switch(m_importType) {
				case _kImportEIP:
					if(m_importGroups) {
						[AlertTool showConfirm:[self window]
									   message:L(@"LQConfirmIncludeGroups", @"FaceManager")
								 defaultButton:L(@"LQYes")
							   alternateButton:L(@"LQNo")
								   otherButton:L(@"LQCancel")
									  delegate:self
								didEndSelector:@selector(includeGroupAlertDidEnd:returnCode:contextInfo:)];
					}
					break;
				case _kImportPicture:
					// iterate all files, only jpg and gif supported now
					NSEnumerator* e = [m_importPictures objectEnumerator];
					while(NSString* path = [e nextObject]) {						
						// get current group
						int groupIndex = [m_pbGroup indexOfSelectedItem];
						FaceManager* fm = [m_mainWindowController faceManager];
						FaceGroup* group = [fm group:groupIndex];
						
						// create group directory
						UInt32 myQQ = [[m_mainWindowController me] QQ];
						if([FileTool createCustomFaceGroupDir:myQQ group:[group name]]) {
							// load image, do md5
							NSData* data = [NSData dataWithContentsOfFile:path];
							NSData* md5Data = [data MD5];
							
							// create Face object
							Face* face = [[[Face alloc] init] autorelease];
							[face setMd5:[md5Data hexString]];
							[face setOriginal:[NSString stringWithFormat:@"%@.%@", [face md5], [path pathExtension]]];
							[face setThumbnail:[NSString stringWithFormat:@"%@Fixed.bmp", [face md5]]];
							[face setMultiframe:YES];
							
							// save original to group dir
							NSString* destPath = [FileTool getCustomFacePath:myQQ 
																   group:[group name]
																	file:[face original]];
							if([FileTool copy:path to:destPath] == NO && ![FileTool isFileExist:destPath])
								continue;
							
							// save thumbnail to group dir
							NSImage* image = [[[NSImage alloc] initWithContentsOfFile:path] autorelease];
							NSSize originalSize = [image size];
							NSImage *resizedImage = [[[NSImage alloc] initWithSize:kSizeSmall] autorelease];
							[resizedImage lockFocus];
							[image drawInRect: NSMakeRect(0, 0, kSizeSmall.width, kSizeSmall.height) fromRect: NSMakeRect(0, 0, originalSize.width, originalSize.height) operation: NSCompositeSourceOver fraction:1.0];
							[resizedImage unlockFocus];							
							NSBitmapImageRep* rep = [NSBitmapImageRep imageRepWithData:[resizedImage TIFFRepresentation]];
							data = [rep representationUsingType:NSBMPFileType properties:nil];
							destPath = [FileTool getCustomFacePath:myQQ
															 group:[group name]
															  file:[face thumbnail]];
							if([data writeToFile:destPath atomically:YES] == NO && ![FileTool isFileExist:destPath])
								continue;
							
							// add face
							[fm addFace:face groupIndex:groupIndex];
						}
					}
						
					// refresh ui
					[m_faceTable reloadData];
					
					break;
			}
			break;
		}
		case _kSheetIncludeGroup:
		{
			m_sheetType = -1;
			
			// open progress window
			[NSApp beginSheet:m_progressWindow
			   modalForWindow:[self window]
				modalDelegate:nil
			   didEndSelector:nil
				  contextInfo:nil];
			
			// initial progress bar
			int totalSize = [m_poifs totalSizeByPath:@"/Files"];
			[m_progressBar setMaxValue:totalSize];
			
			// get face manager and qq number
			FaceManager* fm = [m_mainWindowController faceManager];
			UInt32 myQQ = [[m_mainWindowController me] QQ];
			
			// dest group
			BOOL bSuccess = YES;
			int groupIndex = [m_pbGroup indexOfSelectedItem];
			int currentIndex = groupIndex;
			FaceGroup* destGroup = m_includeGroup ? nil : [fm group:groupIndex];
			if(!m_includeGroup)
				bSuccess = [FileTool createCustomFaceGroupDir:myQQ group:[destGroup name]];
			
			// traverse groups
			if(bSuccess) {
				NSEnumerator* gEnum = [m_importGroups objectEnumerator];
				while(FaceGroup* g = [gEnum nextObject]) {
					// create group directory, if success, save all faces
					if(m_includeGroup) {
						// grouop already exist?
						if([fm hasGroup:[g name]])
							continue;
						
						bSuccess = [FileTool createCustomFaceGroupDir:myQQ group:[g name]];
						destGroup = [g shallowCopy];
					}
						
					if(bSuccess) {
						// add group to face manager
						if(m_includeGroup) {
							[fm addGroup:destGroup];
							groupIndex = [fm indexOfGroup:destGroup];
						}
						
						// copy all faces, if failed, don't add to group
						NSEnumerator* fEnum = [[g faces] objectEnumerator];
						while(Face* f = [fEnum nextObject]) {	
							[self addFace:f
								  toGroup:destGroup
							 srcGroupName:[g name]
								ungrouped:NO];
						}
					}
				}
			}
				
			// traverse ungrouped faces
			FaceGroup* g = [fm group:currentIndex];
			bSuccess = [FileTool createCustomFaceGroupDir:myQQ group:[g name]];
			if(bSuccess) {
				NSEnumerator* fEnum = [m_importFaces objectEnumerator];
				while(Face* f = [fEnum nextObject]) {
					[self addFace:f
						  toGroup:g
					 srcGroupName:[g name]
						ungrouped:YES];
				}
			}
			
			// refresh ui
			if(m_includeGroup && [m_importGroups count] > 0) {
				[fm sortGroups];
				[self createGroupMenuItems];
				[m_pbGroup selectItemAtIndex:[fm indexOfGroup:destGroup]];
			}				
			[m_faceTable reloadData];
			
			// release
			[m_poifs release];
			m_poifs = nil;
			[m_importGroups release];
			m_importGroups = nil;
			[m_importFaces release];
			m_importFaces = nil;
			
			// close progress window
			[NSApp endSheet:m_progressWindow];
			[m_progressWindow orderOut:self];
			
			// save face.plist to avoid inconsistence
			[fm save];
			
			break;
		}
		case _kSheetNewGroup:
			NSString* name = [m_txtInput stringValue];
			if(![name isEmpty]) {
				FaceGroup* g = [[[FaceGroup alloc] initWithName:name] autorelease];
				[[m_mainWindowController faceManager] addGroup:g];
				[[m_mainWindowController faceManager] sortGroups];
				[self createGroupMenuItems];
				[m_pbGroup selectItemAtIndex:[[m_mainWindowController faceManager] indexOfGroup:g]];
				[self onGroupChanged:m_pbGroup];
			}
			break;
	}
}

- (void)addFace:(Face*)face toGroup:(FaceGroup*)g srcGroupName:(NSString*)srcGroupName ungrouped:(BOOL)ungrouped {
	// already has this face?
	FaceManager* fm = [m_mainWindowController faceManager];
	if([fm hasFace:[face md5]])
		return;
	
	// get group
	UInt32 myQQ = [[m_mainWindowController me] QQ];
	
	// get property of original and thumbnail
	Property* pOrg = ungrouped ? [m_poifs property:[NSString stringWithFormat:@"/Files/%u", [face index]]] : [m_poifs property:[NSString stringWithFormat:@"/Files/%@/%u", srcGroupName, [face index]]];
	Property* pFixed = ungrouped ? [m_poifs property:[NSString stringWithFormat:@"/Files/%uFixed", [face index]]] : [m_poifs property:[NSString stringWithFormat:@"/Files/%@/%uFixed", srcGroupName, [face index]]];
	if(pOrg && pFixed) {
		// update progress bar
		[m_progressBar incrementBy:[pOrg size]];
		[m_progressBar incrementBy:[pFixed size]];
		
		// save org
		NSData* data = [m_poifs getFileBytes:pOrg];
		NSString* path = [FileTool getCustomFacePath:myQQ
											   group:[g name]
												file:[face original]];
		if(![data writeToFile:path atomically:YES]) 
			return;
		
		// save thumbnail
		data = [m_poifs getFileBytes:pFixed];
		path = [FileTool getCustomFacePath:myQQ
									 group:[g name]
									  file:[face thumbnail]];
		if(![data writeToFile:path atomically:YES])
			return;
		
		// add face
		[fm addFace:face groupIndex:[fm indexOfGroup:g]];
	}
}

- (void) dealloc {
	if(m_poifs)
		[m_poifs release];
	if(m_importGroups)
		[m_importGroups release];
	if(m_importFaces)
		[m_importFaces release];
	if(m_importPictures)
		[m_importPictures release];
	[m_mainWindowController release];
	[super dealloc];
}

- (void)createGroupMenuItems {
	// remove all item
	NSMenu* menu = [m_pbGroup menu];
	while([menu numberOfItems] > 0)
		[menu removeItemAtIndex:0];
	
	// create item for every group
	NSEnumerator* e = [[[m_mainWindowController faceManager] groups] objectEnumerator];
	while(FaceGroup* g = [e nextObject]) {
		NSMenuItem* item = [[[NSMenuItem alloc] init] autorelease];
		[item setTitle:[g name]];
		[menu addItem:item];
	}
}

#pragma mark -
#pragma mark actions

- (IBAction)onGroupChanged:(id)sender {
	[m_faceTable reloadData];
	[self onFaceTableSelectionChanged:m_faceTable];
}

- (IBAction)onDeleteFace:(id)sender {
	if([m_faceTable numberOfSelectedRows] > 0) {
		FaceManager* fm = [m_mainWindowController faceManager];
		UInt32 QQ = [[m_mainWindowController me] QQ];
		
		// get selected
		int groupIndex = [m_pbGroup indexOfSelectedItem];
		NSIndexSet* rows = [m_faceTable selectedRowIndexes];
		
		// remove
		int count = [fm faceCount:groupIndex]; 
		for(int i = count - 1; i >= 0; i--) {
			if([rows containsIndex:i]) {
				Face* f = [fm face:groupIndex atIndex:i];
				[fm removeFace:groupIndex face:i];
				if(f) {
					[FileTool deleteFile:[FileTool getCustomFacePath:QQ
															   group:[[fm group:groupIndex] name]
																file:[f thumbnail]]];
					[FileTool deleteFile:[FileTool getCustomFacePath:QQ
															   group:[[fm group:groupIndex] name]
																file:[f original]]];
				}
			}
		}
		
		// reload table
		[m_faceTable reloadData];
		
		// refresh preview
		[self onFaceTableSelectionChanged:m_faceTable];
		
		// save face.plist to avoid inconsistence
		[fm save];
	}
}

- (IBAction)onDeleteGroup:(id)sender {
	if([m_pbGroup numberOfItems] <= 1) {
		[AlertTool showWarning:[self window] message:L(@"LQWarningAtLeastOne", @"FaceManager")];
	} else {
		// get face group object
		FaceManager* fm = [m_mainWindowController faceManager];
		FaceGroup* g = [fm group:[m_pbGroup indexOfSelectedItem]];
		
		// delete group directory
		NSString* path = [FileTool getCustomFaceGroupPath:[[m_mainWindowController me] QQ] group:[g name]];
		if([FileTool deleteFile:path]) {
			// remove group
			[fm removeGroup:[m_pbGroup indexOfSelectedItem]];
			[self createGroupMenuItems];
			[m_pbGroup selectItemAtIndex:0];
			
			// refresh ui
			[m_faceTable reloadData];
			
			// save face.plist to avoid inconsistence
			[fm save];
		} else {
			[AlertTool showWarning:[self window] message:L(@"LQWarningDeleteGroupFailed", @"FaceManager")];
		}
	}
}

- (IBAction)onNewGroup:(id)sender {
	[NSApp beginSheet:m_inputWindow
	   modalForWindow:[self window]
		modalDelegate:self
	   didEndSelector:@selector(inputSheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
}

- (IBAction)onImportPicture:(id)sender {
	// set import type
	m_importType = _kImportPicture;
	
	// open open panel
	NSOpenPanel* panel = [NSOpenPanel openPanel];
	[panel setAllowsMultipleSelection:YES];
	[panel setCanChooseDirectories:NO];
	[panel setCanChooseFiles:YES];
	[panel beginSheetForDirectory:NSHomeDirectory()
							 file:nil
							types:[NSArray arrayWithObjects:@"jpg", @"gif", nil]
				   modalForWindow:[self window]
					modalDelegate:self
				   didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
					  contextInfo:nil];
}

- (IBAction)onImportFacePackage:(id)sender {
	// set import type
	m_importType = _kImportEIP;
	
	// open open panel
	NSOpenPanel* panel = [NSOpenPanel openPanel];
	[panel setAllowsMultipleSelection:NO];
	[panel setCanChooseDirectories:NO];
	[panel setCanChooseFiles:YES];
	[panel beginSheetForDirectory:NSHomeDirectory()
							 file:nil
							types:[NSArray arrayWithObject:@"eip"]
				   modalForWindow:[self window]
					modalDelegate:self
				   didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
					  contextInfo:nil];
}

- (IBAction)onClose:(id)sender {
	[[m_mainWindowController faceManager] save];
	[self close];
}

- (IBAction)onInputOK:(id)sender {
	[NSApp endSheet:m_inputWindow returnCode:YES];
	[m_inputWindow orderOut:self];
}

- (IBAction)onInputCancel:(id)sender {
	[NSApp endSheet:m_inputWindow returnCode:NO];
	[m_inputWindow orderOut:self];
}

- (IBAction)onFaceTableSelectionChanged:(id)sender {
	NSIndexSet* rows = [m_faceTable selectedRowIndexes];
	int row = [rows firstIndex];
	if(row == NSNotFound) {
		[m_ivPreview setImage:nil];
	} else {
		// get face
		FaceGroup* g = [[m_mainWindowController faceManager] group:[m_pbGroup indexOfSelectedItem]];
		Face* f = [g face:row];
		
		// set new image to image view
		NSString* path = [FileTool getCustomFacePath:[[m_mainWindowController me] QQ]
											   group:[g name] 
												file:[f original]];
		NSImage* image = [[[NSImage alloc] initWithContentsOfFile:path] autorelease];
		[m_ivPreview setImage:image];
		[m_ivPreview setAnimates:[f multiframe]];
	}
}

#pragma mark -
#pragma mark sheet delegate

- (void)inputSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void*)contextInfo {
	if(returnCode == YES) {
		m_sheetType = _kSheetNewGroup;
	}
}

#pragma mark -
#pragma mark open panel delegate

- (void)openPanelDidEnd:(NSOpenPanel*)panel returnCode:(int)returnCode contextInfo:(void*)contextInfo {
	if(returnCode == NSOKButton) {
		switch(m_importType) {
			case _kImportEIP:
				// load the file
				NSString* file = [panel filename];
				m_poifs = [[POIFSFileSystem alloc] initWithPath:file];
				[m_poifs load];
				
				// get data of face.xml
				Property* faceConfig = [m_poifs property:@"/config/face.xml"];
				if(!faceConfig)
					return;
				NSData* data = [m_poifs getFileBytes:faceConfig];
				
				// create xml parser
				FaceConfigParser* parser = [[[FaceConfigParser alloc] initWithData:data] autorelease];
				[parser parse];
				
				// get face groups
				m_importGroups = [[parser groups] retain];
				m_importFaces = [[parser faces] retain];
				
				m_sheetType = _kSheetOpen;
				break;
			case _kImportPicture:
				m_importPictures = [[panel filenames] retain];
				m_sheetType = _kSheetOpen;
				break;
		}
	}
}

#pragma mark -
#pragma mark table data source

- (int)numberOfRowsInTableView:(NSTableView *)aTableView {
	int index = [m_pbGroup indexOfSelectedItem];
	FaceGroup* g = [[m_mainWindowController faceManager] group:index];
	return [g faceCount];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
	int index = [m_pbGroup indexOfSelectedItem];
	FaceGroup* g = [[m_mainWindowController faceManager] group:index];
	
	if([[aTableColumn identifier] isEqualToString:@"0"]) {
		Face* f = [g face:rowIndex];
		NSString* path = [FileTool getCustomFacePath:[[m_mainWindowController me] QQ]
											   group:[g name]
												file:[f thumbnail]];
		return [[[NSImage alloc] initWithContentsOfFile:path] autorelease];
	} else
		return [[g face:rowIndex] shortcut];
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
	int index = [m_pbGroup indexOfSelectedItem];
	FaceGroup* g = [[m_mainWindowController faceManager] group:index];
	
	if([[aTableColumn identifier] isEqualToString:@"1"]) {
		Face* f = [g face:rowIndex];
		[f setShortcut:anObject];
	}
}

#pragma mark -
#pragma mark face table delegate

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
	NSTableView* table = [aNotification object];
	if(table == m_faceTable) {
		[self onFaceTableSelectionChanged:table];
	}
}

#pragma mark -
#pragma mark alert delegate

- (void)includeGroupAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	if(returnCode == NSAlertOtherReturn) {
		[m_poifs release];
		m_poifs = nil;
		[m_importGroups release];
		m_importGroups = nil;
	} else {
		m_includeGroup = returnCode == NSAlertDefaultReturn;
		m_sheetType = _kSheetIncludeGroup;
	}
}

@end
