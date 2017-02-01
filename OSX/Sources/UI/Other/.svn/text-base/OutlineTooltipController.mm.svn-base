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

#import "OutlineTooltipController.h"
#import "MainWindowController.h"
#import "PreferenceCache.h"
#import "NSString-Validate.h"
#import "ImageTool.h"

@implementation OutlineTooltipController

- (id)initWithMainWindow:(MainWindowController*)main {
	self = [super init];
	if(self) {
		m_main = [main retain];
	}
	return self;
}

- (void) dealloc {
	if(m_tooltipPanel)
		[self hideTooltip];
	[m_main release];
	[super dealloc];
}

- (void)awakeFromNib {
	m_userSize = [m_userTipView bounds].size;
	m_memberSize = [m_memberTipView bounds].size;
	m_clusterSize = [m_clusterTipView bounds].size;
	m_mobileSize = [m_mobileTipView bounds].size;
}

- (void)showTooltip:(id)object at:(NSPoint)point {
	/*
	 * Mobile is not supported now
	 */
	PreferenceCache* cache = [PreferenceCache cache:[[m_main me] QQ]];
	if(object != nil && ![cache disableOutlineTooltip] && 
	   ([object isMemberOfClass:[User class]] || [object isMemberOfClass:[Cluster class]])) {
		if(m_tooltipPanel == nil) {
			m_tooltipPanel = [[HMBlkPanel alloc] initWithContentRect:NSMakeRect(100, 100, 300, 150)
														   styleMask:0
															 backing:NSBackingStoreBuffered
															   defer:YES];
			[m_tooltipPanel setShowCloseButton:NO];
			[m_tooltipPanel setHidesOnDeactivate:NO];
		}
		
		// set model info
		if([object isMemberOfClass:[User class]]) {
			// cast to user
			User* u = (User*)object;
			
			// check current outline
			NSString* label = [m_main currentOutlineLabel];
			if([label isEqualToString:kTabViewItemClusters]) {
				// get parent cluster
				Cluster* c = [m_main parentClusterOf:u];
				if(c == nil) {
					[self hideTooltip];
					return;
				}					
				
				// set info
				NSString* nameCard = [[[u getClusterSpecificInfo:[c internalId]] nameCard] name];
				[m_headControl setOwner:[[m_main me] QQ]];
				[m_memberHeadControl setObjectValue:u];
				[m_memberHeadControl setShowStatus:NO];
				[m_txtMemberRemarkName setStringValue:[NSString stringWithFormat:L(@"LQTooltipRemarkName", @"OutlineTooltip"), [[u remarkName] isEmpty] ? L(@"LQTooltipNotSet", @"OutlineTooltip") : [u remarkName]]];
				[m_txtBelongToCluster setStringValue:[NSString stringWithFormat:L(@"LQTooltipBelongToCluster", @"OutlineTooltip"), [c name], [c externalId]]];
				[m_txtClusterNameCard setStringValue:[NSString stringWithFormat:L(@"LQTooltipClusterNameCard", @"OutlineTooltip"), [nameCard isEmpty] ? L(@"LQTooltipNotSet", @"OutlineTooltip") : nameCard]];
				if([u isCreator:c])
					[m_txtMemberRole setStringValue:[NSString stringWithFormat:L(@"LQTooltipMemberRole", @"OutlineTooltip"), L(@"LQRoleCreator", @"OutlineTooltip")]];
				else if([u isAdmin:c])
					[m_txtMemberRole setStringValue:[NSString stringWithFormat:L(@"LQTooltipMemberRole", @"OutlineTooltip"), L(@"LQRoleAdmin", @"OutlineTooltip")]];
				else if([u isStockholder:c])
					[m_txtMemberRole setStringValue:[NSString stringWithFormat:L(@"LQTooltipMemberRole", @"OutlineTooltip"), L(@"LQRoleStockholder", @"OutlineTooltip")]];
				else
					[m_txtMemberRole setStringValue:[NSString stringWithFormat:L(@"LQTooltipMemberRole", @"OutlineTooltip"), L(@"LQRoleNormal", @"OutlineTooltip")]];
				
				// set title
				[m_tooltipPanel setTitle:[NSString stringWithFormat:@"%@(%u)", [u nick], [u QQ]]];
				
				// set size and content
				[m_tooltipPanel setContentSize:m_memberSize];
				[m_tooltipPanel setContentView:m_memberTipView];
			} else {
				// set info
				[m_txtSignature setStringValue:[u signature]];
				[m_headControl setOwner:[[m_main me] QQ]];
				[m_headControl setObjectValue:u];
				[m_headControl setShowStatus:NO];
				[m_userFlagControl setObjectValue:u];
				[m_levelControl setLevel:[u level]];
				[m_levelControl setUpgradeDays:[u upgradeDays]];
				[m_txtRemarkName setStringValue:[NSString stringWithFormat:L(@"LQTooltipRemarkName", @"OutlineTooltip"), [[u remarkName] isEmpty] ? L(@"LQTooltipNotSet", @"OutlineTooltip") : [u remarkName]]];
				[m_txtStatusMessage setStringValue:[NSString stringWithFormat:L(@"LQTooltipStatusMessage", @"OutlineTooltip"), [[u statusMessage] isEmpty] ? L(@"LQTooltipNotSet", @"OutlineTooltip") : [u statusMessage]]];
				
				// get group
				Group* g = [[m_main groupManager] group:[u groupIndex]];
				
				// get group name
				NSString* groupName = g == nil ? L(@"LQTooltipUnknownGroup", @"OutlineTooltip") : [g name];
				
				// get title string
				NSString* title = [NSString stringWithFormat:@"%@ - %@(%u)", groupName, [u nick], [u QQ]];
				
				// set title
				[m_tooltipPanel setTitle:title];
				
				// set size and content
				[m_tooltipPanel setContentSize:m_userSize];
				[m_tooltipPanel setContentView:m_userTipView];
			}
		} else if([object isMemberOfClass:[Cluster class]]) {
			// get cluster
			Cluster* c = (Cluster*)object;
			
			// get creator
			User* creator = [[m_main groupManager] user:[[c info] creator]];

			// set info
			NSImage* image = [ImageTool imageWithName:([c permanent] ? kImageCluster : kImageTempCluster) size:kSizeLarge];
			[m_clusterHeadControl setHead:kHeadUseImage];
			[m_clusterHeadControl setShowStatus:NO];
			[m_clusterHeadControl setImage:image];
			[m_txtCreator setStringValue:[NSString stringWithFormat:L(@"LQTooltipCreator", @"OutlineTooltip"), (creator ? [creator nick] : kStringEmpty), [[c info] creator]]];
			[m_txtNotice setStringValue:[[c info] notice]];
			[m_txtMemberCount setStringValue:[NSString stringWithFormat:L(@"LQTooltipMemberCount", @"OutlineTooltip"), [c memberCount]]];
			if([c permanent]) {
				if([[c info] isAdvanced])
					[m_txtClusterType setStringValue:L(@"LQTypeAdvancedCluster", @"OutlineTooltip")];
				else
					[m_txtClusterType setStringValue:L(@"LQTypeNormalCluster", @"OutlineTooltip")];
				[m_tooltipPanel setTitle:[NSString stringWithFormat:@"%@(%u)", [c name], [c externalId]]];
			} else if([c isSubject]) {
				[m_txtClusterType setStringValue:L(@"LQTypeSubject", @"OutlineTooltip")];
				[m_tooltipPanel setTitle:[c name]];
			} else if([c isDialog]) {
				[m_txtClusterType setStringValue:L(@"LQTypeDialog", @"OutlineTooltip")];
				[m_tooltipPanel setTitle:[c name]];
			}
			
			[m_tooltipPanel setContentSize:m_clusterSize];
			[m_tooltipPanel setContentView:m_clusterTipView];
		} else if([object isMemberOfClass:[Mobile class]]) {
			[m_tooltipPanel setContentSize:m_mobileSize];
			[m_tooltipPanel setContentView:m_mobileTipView];
		}
		
		// set location and show it
		[m_tooltipPanel setFrameTopLeftPoint:NSMakePoint(point.x + 10, point.y - 10)];
		[m_tooltipPanel orderFront:self];
	} else {
		[self hideTooltip];
	}
}

- (void)hideTooltip {
	if(m_tooltipPanel) {
		[m_tooltipPanel orderOut:self];
		[m_tooltipPanel autorelease];
		m_tooltipPanel = nil;
	}
}

@end
