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

#import "TempClusterBaseWindowController.h"
#import "MainWindowController.h"
#import "QQCell.h"
#import "NSString-Validate.h"

@implementation TempClusterBaseWindowController

- (id)initWithTempCluster:(Cluster*)cluster parentCluster:(Cluster*)parentCluster mainWindow:(MainWindowController*)mainWindowController {
	self = [super initWithWindowNibName:@"TempClusterBase"];
	if (self != nil) {
		m_cluster = [cluster retain];
		m_parentCluster = [parentCluster retain];
		m_mainWindowController = [mainWindowController retain];
		m_members = [[NSMutableArray array] retain];
		m_waitingSequence = 0;
		m_sheetType = -1;
		
		// create tree selector
		m_treeSelector = [[TreeSelectorWindowController alloc] initWithMainWindow:m_mainWindowController
																	   dataSource:[self createDataSource]];
		[m_treeSelector setCanClose:NO];
		[m_treeSelector showWindow:self];
	}
	return self;
}

- (id)createDataSource {
	return nil;
}

- (void) dealloc {
	[m_cluster release];
	[m_parentCluster release];
	[m_mainWindowController release];
	[m_members release];
	[super dealloc];
}

- (void)windowDidLoad {
	// set window title
	[[self window] setTitle:[self windowTitle]];
	
	// set button title
	[m_btnAction setTitle:[self actionButtonTitle]];
	
	// set cell for table
	QQCell* qqCell = [[QQCell alloc] init];
	[qqCell setSearchStyle:YES];
	[qqCell setShowStatus:NO];
	[[m_memberTable tableColumnWithIdentifier:@"0"] setDataCell:[qqCell autorelease]];
	
	// give subclass a change to initialize UI
	[self initializeUI];
	
	// add qq listener
	[[m_mainWindowController client] addQQListener:self];
	
	// add observer
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleQQCellDidSelected:)
												 name:kQQCellDidSelectedNotificationName
											   object:nil];
}

- (void)windowDidBecomeKey:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	NSRect frame = [[self window] frame];
	frame.origin.x += frame.size.width;
	frame.size.width = 250;
	
	[[m_treeSelector window] setFrame:frame display:NO];
}

- (void)windowDidMove:(NSNotification *)aNotification {	
	if([aNotification object] != [self window])
		return;
	
	NSRect frame = [[self window] frame];
	frame.origin.x += frame.size.width;
	frame.size.width = 250;
	
	[[m_treeSelector window] setFrame:frame display:NO];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;

	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kQQCellDidSelectedNotificationName
												  object:nil];
	[[m_mainWindowController client] removeQQListener:self];
	if(m_treeSelector) {
		[m_treeSelector close];
		m_treeSelector = nil;
	}		
	[self release];
}

- (IBAction)onAction:(id)sender {
	
}

- (IBAction)onCancel:(id)sender {
	[self close];
}

- (NSString*)memberNick:(User*)user {
	NSString* name = [[user nameCard:[m_parentCluster internalId]] name];
	if([name isEmpty])
		name = [user nick];
	return name;
}

- (NSString*)windowTitle {
	return kStringEmpty;
}

- (NSString*)actionButtonTitle {
	return kStringEmpty;
}

- (void)initializeUI {
	
}

- (void)handleQQCellDidSelected:(NSNotification*)notification {
}

#pragma mark -
#pragma mark helper

- (void)setHint:(NSString*)hint {
	if(hint == nil) {
		[m_piBusy stopAnimation:self];
		[m_piBusy setHidden:YES];
		[m_txtHint setStringValue:kStringEmpty];
	} else {
		[m_piBusy setHidden:NO];
		[m_piBusy startAnimation:self];
		[m_txtHint setStringValue:hint];
	}
}

#pragma mark -
#pragma mark member table data source

- (int)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [m_members count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
	User* user = [m_members objectAtIndex:rowIndex];
	switch([[aTableColumn identifier] intValue]) {
		case 0:
			return user;
		case 1:			
			return [self memberNick:user];
		case 2:
			return [user isMM] ? L(@"LQFemale") : L(@"LQMale");
		case 3:
			return [[NSNumber numberWithChar:[user age]] description];
		default:
			return kStringEmpty;
	}
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	return NO;
}

@end
