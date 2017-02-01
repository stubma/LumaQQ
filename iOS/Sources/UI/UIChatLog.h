/*
 * LumaQQ - Cross platform QQ client, special edition for iPhone
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

#import <UIKit/UIKit.h>
#import <UIKit/UITable.h>
#import "UIUnit.h"
#import "GroupManager.h"
#import "UISwipeDeleteTable.h"

@class UIController;

@interface UIChatLog : NSObject <UIUnit> {
	UIController* _uiController;
	
	UIView* _view;
	UISwipeDeleteTable* _table;
	UITextField* _searchField;
	UIKeyboard* _keyboard;
	UIPushButton* _searchBar;
	NSMutableDictionary* _data;
	GroupManager* _groupManager;
	id _model;
	BOOL _saveOnBack;
	
	NSMutableArray* _chatlog;
	NSMutableArray* _cells;
	NSString* _searchText;
}

- (void)_showKeyboard;
- (void)_hideKeyboard;

- (void)searchButtonClicked:(UIPushButton*)button;

@end
