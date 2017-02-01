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

@class MainWindowController;

@interface UserOutlineDataSource : NSObject {
	MainWindowController* m_mainWindowController;
	
	BOOL m_showOnlineOnly;
	BOOL m_showOnlineOnlyBackup;
	BOOL m_showLargeHead;
	int m_searchMode;
	NSString* m_searchText;
	
	BOOL m_dragging;
}

- (id)initWithMainWindow:(MainWindowController*)mainWindowController;

- (BOOL)searchByQQ:(id)item;
- (BOOL)searchByNick:(id)item;
- (BOOL)searchByRemark:(id)item;
- (BOOL)searchBySignature:(id)item;
- (void)saveShowOnlineOnlyOption;
- (void)rollbackShowOnlineOnlyOption;

// getter and setter
- (void)setSearchMode:(int)searchMode;
- (void)setSearchText:(NSString*)searchText;
- (void)setShowOnlineOnly:(BOOL)showOnlineOnly;
- (void)setShowLargeHead:(BOOL)showLargeHead;

@end
