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
#import "HeadCell.h"
#import "QQEvent.h"
#import "Constants.h"

#define kSpacing 2

@interface QQCell : HeadCell {
	UInt32 m_QQ; // my QQ
	BOOL m_searchStyle;
	BOOL m_checkStyle;
	BOOL m_memberStyle; // treat User object as member in cluster
	BOOL m_largeClusterHeadStyle;
	BOOL m_ignoreLargeUserHeadPreference;
	UInt32 m_internalId; // if cluster internal is known, set it here
	
	NSButtonCell* m_checker;
	NSMutableDictionary* m_stateMap;
	
	// used to identify this QQCell
	int m_identifier;
}

- (id)initWithQQ:(UInt32)QQ;

// drawing routine
- (void)drawGroupWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
- (void)drawMobileWithFrame:(NSRect)cellFrame inView:(NSView*)controlView;
- (void)drawUserWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
- (void)drawMemberWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
- (void)drawClusterWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
- (void)drawDummyWithFrame:(NSRect)cellFrame inView:(NSView*)controlView;
- (void)drawOrganizationWithFrame:(NSRect)cellFrame inView:(NSView*)controlView;
- (void)drawSearchUserResultWithFrame:(NSRect)cellFrame inView:(NSView*)controlView;
- (void)drawSearchClusterResultWithFrame:(NSRect)cellFrame inView:(NSView*)controlView;
- (void)drawSearchStyleUserWithFrame:(NSRect)cellFrame inView:(NSView*)controlView;
- (int)drawChecker:(NSRect)cellFrame inView:(NSView*)controlView;

// getter and setter
- (void)setQQ:(UInt32)QQ;
- (void)setSearchStyle:(BOOL)flag;
- (void)setCheckStyle:(BOOL)flag;
- (void)setMemberStyle:(BOOL)flag;
- (void)setLargeClusterHeadStyle:(BOOL)flag;
- (void)setIgnoreLargeUserHeadPreference:(BOOL)flag;
- (void)setInternalId:(UInt32)internalId;
- (void)setStateMap:(NSMutableDictionary*)map;
- (NSMutableDictionary*)stateMap;
- (int)identifier;
- (void)setIdentifier:(int)identifier;

// action
- (IBAction)onCheck:(id)sender;

// helper
- (NSCellStateValue)state:(id)obj;
- (void)set:(id)obj state:(NSCellStateValue)state;
- (void)clearState;

@end
