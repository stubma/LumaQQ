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
#import "Cluster.h"
#import "TreeSelectorWindowController.h"
#import "QQListener.h"

@class MainWindowController;

@interface TempClusterBaseWindowController : NSWindowController <QQListener> {
	IBOutlet NSButton* m_btnAction;
	IBOutlet NSTableView* m_memberTable;
	IBOutlet NSTextField* m_txtName;
	IBOutlet NSProgressIndicator* m_piBusy;
	IBOutlet NSTextField* m_txtHint;
	
	NSMutableArray* m_members;
	MainWindowController* m_mainWindowController;
	Cluster* m_cluster;
	Cluster* m_parentCluster;
	TreeSelectorWindowController* m_treeSelector;
	UInt16 m_waitingSequence;
	int m_sheetType;
}

- (id)initWithTempCluster:(Cluster*)cluster parentCluster:(Cluster*)parentCluster mainWindow:(MainWindowController*)mainWindowController;

- (IBAction)onAction:(id)sender;
- (IBAction)onCancel:(id)sender;

// helper
- (void)setHint:(NSString*)hint;

// subclass need implement
- (NSString*)memberNick:(User*)user;
- (NSString*)windowTitle;
- (NSString*)actionButtonTitle;
- (void)initializeUI;
- (void)handleQQCellDidSelected:(NSNotification*)notification;
- (id)createDataSource;

@end
