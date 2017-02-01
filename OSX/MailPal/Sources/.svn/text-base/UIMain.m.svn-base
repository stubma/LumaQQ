/*
 * MailPal - A Garbage Code Terminator for iPhone Mail
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
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIPreferencesTableCell.h>
#import "UIMain.h"
#import "LocalizedStringTool.h"
#import "UIController.h"
#import "UIUtil.h"
#import "Mailbox.h"

@implementation UIMain

- (void) dealloc {
	[_pal release];
	[_view release];
	[_mailboxes release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitMain;
}

- (void)begin:(UIController*)uiController {
	// save controller
	_uiController = uiController;
	
	// push navigation item
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:L(@"MailPal")] autorelease];
	[[uiController navBar] pushNavigationItem:item];
	
	// show button
	[[uiController navBar] showButtonsWithLeftTitle:L(@"Start") rightTitle:L(@"About")];
	
	// set delegate
	[[uiController navBar] setDelegate:self];
}

- (void)stop:(UIController*)uiController {
	[[[uiController navBar] navigationItems] removeAllObjects];
	[[uiController navBar] setDelegate:nil];
}

- (UIView*)view {
	if(_view == nil) {										
		// create top view
		CGRect bound = [_uiController clientRect];
		_view = [[UIView alloc] initWithFrame:bound];
		
		// create mailbox table
		_mailboxTable = [[[UITable alloc] initWithFrame:bound] autorelease];
		UITableColumn* col = [[[UITableColumn alloc] initWithTitle:@"Mailbox" 
														identifier:@"Mailbox"
															 width:bound.size.width] autorelease];
		[_mailboxTable addTableColumn:col];
		[_mailboxTable setSeparatorStyle:kTableSeparatorSingle];
		[_mailboxTable setDataSource:self];
		[_mailboxTable setDelegate:self];
		[_view addSubview:_mailboxTable];
		
		// open mail db
		_pal = [[MailPal alloc] initWithFile:[kFileMailDB stringByExpandingTildeInPath]];
		
		// get mailboxes
		if(_pal != nil)
			_mailboxes = [[_pal mailboxes] retain];
		
		// reload table
		[_mailboxTable reloadData];
	}
	return _view;
}

- (void)refresh:(NSMutableDictionary*)data {
	if(data != nil) {
		// save ref
		[data retain];
		[_data release];
		_data = data;
	}
	
	// check pal
	if(_pal == nil) {
		[UIUtil showWarning:L(@"CannotOpenMailDB") title:L(@"Warning") delegate:self];
	}
}

#pragma mark -
#pragma mark navigation bar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button {
	switch(button) {
		case kNavButtonLeft:
			if(_pal != nil)
				[_pal convert:[_mailboxes objectAtIndex:0]];
			break;
		case kNavButtonRight:		
			break;
	}
}

#pragma mark -
#pragma mark alert sheet delegate

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
}

#pragma mark mailbox table datasource

- (UITableCell*)table:(UITable*)table cellForRow:(int)row column:(UITableColumn*)col {
	Mailbox* mailbox = [_mailboxes objectAtIndex:row];
	UIPreferencesTableCell* cell = [[UIPreferencesTableCell alloc] init];
	[cell setTitle:[NSString stringWithFormat:@"%@ (%d)", [mailbox displayName], [mailbox totalCount]]];
	return [cell autorelease];
}

- (float)table:(UITable*)table heightForRow:(int)row {
	return 40.0f;
}

- (int)numberOfRowsInTable:(UITable*)table {
	return [_mailboxes count];
}

@end
