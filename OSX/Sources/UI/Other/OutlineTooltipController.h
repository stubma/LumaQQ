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
#import "HMBlkPanel.h"
#import "LevelControl.h"
#import "HeadControl.h"
#import "UserFlagControl.h"

@class MainWindowController;

@interface OutlineTooltipController : NSObject {
	IBOutlet NSView* m_userTipView;
	IBOutlet NSView* m_memberTipView;
	IBOutlet NSView* m_clusterTipView;
	IBOutlet NSView* m_mobileTipView;
	
	// user tip view
	IBOutlet UserFlagControl* m_userFlagControl;
	IBOutlet LevelControl* m_levelControl;
	IBOutlet HeadControl* m_headControl;
	IBOutlet NSTextField* m_txtSignature;
	IBOutlet NSTextField* m_txtRemarkName;
	IBOutlet NSTextField* m_txtStatusMessage;
	
	// member tip view
	IBOutlet HeadControl* m_memberHeadControl;
	IBOutlet NSTextField* m_txtBelongToCluster;
	IBOutlet NSTextField* m_txtMemberRemarkName;
	IBOutlet NSTextField* m_txtMemberRole;
	IBOutlet NSTextField* m_txtClusterNameCard;
	
	// cluster tip view
	IBOutlet HeadControl* m_clusterHeadControl;
	IBOutlet NSTextField* m_txtCreator;
	IBOutlet NSTextField* m_txtNotice;
	IBOutlet NSTextField* m_txtMemberCount;
	IBOutlet NSTextField* m_txtClusterType;
	
	// view size
	NSSize m_userSize;
	NSSize m_memberSize;
	NSSize m_clusterSize;
	NSSize m_mobileSize;
	
	HMBlkPanel* m_tooltipPanel;
	MainWindowController* m_main;
}

- (id)initWithMainWindow:(MainWindowController*)main;

- (void)showTooltip:(id)object at:(NSPoint)point;
- (void)hideTooltip;

@end
