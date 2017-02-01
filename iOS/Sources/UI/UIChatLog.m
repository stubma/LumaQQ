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

#import "UIChatLog.h"
#import <UIKit/UINavigationItem.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UIFrameAnimation.h>
#import <UIKit/UIAnimator.h>
#import "Constants.h"
#import "UIController.h"
#import "LocalizedStringTool.h"
#import "User.h"
#import "Cluster.h"
#import "ChatLogIMCell.h"
#import "FileTool.h"
#import "MessageHistory.h"
#import "UIUtil.h"

static const float SEARCH_BAR_HEIGHT = 40.0f;
static const float SEARCH_FIELD_HEIGHT = 26.0f;
static const float SEARCH_BUTTON_HEIGHT = 26.0f;

@implementation UIChatLog

- (void) dealloc {
	[_view release];
	[_table release];
	[_keyboard release];
	[_data release];
	[_cells release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitChatLog;
}

- (void)begin:(UIController*)uiController {
	// save controller
	_uiController = uiController;
	
	// push navigation item
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:L(@"ChatLog")] autorelease];
	[[uiController navBar] pushNavigationItem:item];
	
	// show button
	[[uiController navBar] showLeftButton:L(@"Back") withStyle:kNavButtonStyleBackArrow rightButton:L(@"DeleteAll") withStyle:kNavButtonStyleNormal];
	
	// set delegate
	[[uiController navBar] setDelegate:self];
}

- (void)stop:(UIController*)uiController {
	[[[uiController navBar] navigationItems] removeAllObjects];
	[[uiController navBar] setDelegate:nil];
}

- (UIView*)view {
	if(_view == nil) {		
		// init variables
		_cells = [[NSMutableArray array] retain];
		
		// create edit view
		CGRect bound = [_uiController clientRect];
		_view = [[UIView alloc] initWithFrame:bound];
		
		// create table
		bound.size.height -= SEARCH_BAR_HEIGHT;
		_table = [[UISwipeDeleteTable alloc] initWithFrame:bound];
		UITableColumn* col = [[[UITableColumn alloc] initWithTitle:@"Message" 
														identifier:@"message"
															 width:bound.size.width] autorelease];
		[_table addTableColumn:col];
		[_table setSeparatorStyle:kTableSeparatorSingle];
		[_table setDataSource:self];
		[_table setDelegate:self];
		
		// create search bar
		bound.origin.y += bound.size.height;
		bound.size.height = SEARCH_BAR_HEIGHT;
		_searchBar = [[[UIPushButton alloc] initWithFrame:bound] autorelease];
		[_searchBar setDrawsShadow:YES];
		[_searchBar setStretchBackground:YES];
		[_searchBar setAutosizesToFit:NO];
		[_searchBar setShowPressFeedback:NO];
		[_searchBar setBackground:[UIImage imageNamed:kImageGradientGrayBackground] forState:kButtonStateDown];
		[_searchBar setBackground:[UIImage imageNamed:kImageGradientGrayBackground] forState:kButtonStateUp];
		
		// create round input field background
		bound.origin.x = 8.0f;
		bound.origin.y = (SEARCH_BAR_HEIGHT - SEARCH_FIELD_HEIGHT) / 2.0f;
		bound.size.height = SEARCH_FIELD_HEIGHT;
		bound.size.width = 238.0f;
		UIPushButton* fieldBar = [[[UIPushButton alloc] initWithFrame:bound] autorelease];
		[fieldBar setDrawsShadow:YES];
		[fieldBar setStretchBackground:YES];
		[fieldBar setAutosizesToFit:NO];
		[fieldBar setShowPressFeedback:NO];
		[fieldBar setBackground:[UIImage imageNamed:kImageRoundInputFieldBackground] forState:kButtonStateDown];
		[fieldBar setBackground:[UIImage imageNamed:kImageRoundInputFieldBackground] forState:kButtonStateUp];
		
		// create input field
		bound.origin.x = 24.0f;
		bound.origin.y += 7.0f;
		bound.size.width = bound.size.width - 38.0f;
		bound.size.height = 15.0f;
		_searchField = [[[UITextField alloc] initWithFrame:bound] autorelease];
		GSFontRef font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 12.0f);
		[_searchField setFont:font];
		[_searchField setDelegate:self];
		CFRelease(font);
		
		// create search button
		bound.origin.x = 248.0f;
		bound.origin.y = (SEARCH_BAR_HEIGHT - SEARCH_BUTTON_HEIGHT) / 2.0f;						  
		bound.size.height = SEARCH_BUTTON_HEIGHT;
		bound.size.width = 64.0f;
		font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 16.0f);
		UIPushButton* searchButton = [[[UIPushButton alloc] initWithTitle:L(@"Search")] autorelease];
		[searchButton setTitleFont:font];
		[searchButton setDrawsShadow:YES];
		[searchButton setEnabled:YES];
		[searchButton setStretchBackground:YES];
		[searchButton setAutosizesToFit:NO];
		[searchButton setFrame:bound];
		[searchButton setBackground:[UIImage imageNamed:kImageSmallOrangeButtonDown] forState:kButtonStateDown];
		[searchButton setBackground:[UIImage imageNamed:kImageSmallOrangeButtonUp] forState:kButtonStateUp];
		[searchButton addTarget:self action:@selector(searchButtonClicked:) forEvents:kUIMouseUp];
		CFRelease(font);
		
		// create keyboard
		CGSize kbSize = [UIKeyboard defaultSizeForOrientation:kDeviceOrientationNormal];
		_keyboard = [[UIKeyboard alloc] initWithFrame:CGRectMake(0.0f, [_view bounds].size.height, kbSize.width, kbSize.height)];
		
		// add view
		[_view addSubview:_table];
		[_view addSubview:_searchBar];
		[_searchBar addSubview:fieldBar];
		[_searchBar addSubview:searchButton];
		[_searchBar addSubview:_searchField];
	}
	return _view;
}

- (void)refresh:(NSMutableDictionary*)data {		
	if(data != nil) {		
		// save data
		[data retain];
		[_data release];
		_data = data;
		
		// init variable
		_saveOnBack = NO;
		
		// get model
		_model = [_data objectForKey:kDataKeyChatModel];
		_groupManager = [_data objectForKey:kDataKeyGroupManager];
		
		// load chat log
		_chatlog = [[MessageHistory loadHistory:_model] retain];
		
		// recreate cells
		if(_chatlog != nil) {
			NSEnumerator* e = [_chatlog objectEnumerator];
			NSDictionary* properties;
			while(properties = [e nextObject]) {
				ChatLogIMCell* cell = [[ChatLogIMCell alloc] init];
				[cell setProperties:properties];
				[cell setGroupManager:_groupManager];
				[_cells addObject:[cell autorelease]];
			}
		}
		
		// reload table
		[_table reloadData];
		
		// scroll to last row
		[_table scrollRowToVisible:([_table numberOfRows] - 1)];
	}
}

- (void)_showKeyboard {
	// get keyboard bound
	CGRect kbFrame = [_keyboard frame];
	[_view addSubview:_keyboard];
	
	// animation array
	NSMutableArray* animations = [NSMutableArray arrayWithCapacity:3];
	
	// create animation of table
	CGRect startFrame = [_table frame];
	CGRect endFrame = CGRectMake(startFrame.origin.x, startFrame.origin.y, startFrame.size.width, startFrame.size.height - kbFrame.size.height);
	UIFrameAnimation* animation = [[[UIFrameAnimation alloc] initWithTarget:_table] autorelease];
	[animation setStartFrame:startFrame];
	[animation setEndFrame:endFrame];
	[animation setAnimationCurve:kUIAnimationCurveLinear];
	[animations addObject:animation];
	
	// create animation of search bar
	startFrame = [_searchBar frame];
	endFrame = CGRectMake(startFrame.origin.x, startFrame.origin.y - kbFrame.size.height, startFrame.size.width, startFrame.size.height);
	animation = [[[UIFrameAnimation alloc] initWithTarget:_searchBar] autorelease];
	[animation setStartFrame:startFrame];
	[animation setEndFrame:endFrame];
	[animation setAnimationCurve:kUIAnimationCurveLinear];
	[animations addObject:animation];
	
	// create animation of keyboard
	endFrame = CGRectMake(kbFrame.origin.x, kbFrame.origin.y - kbFrame.size.height, kbFrame.size.width, kbFrame.size.height);
	animation = [[[UIFrameAnimation alloc] initWithTarget:_keyboard] autorelease];
	[animation setStartFrame:kbFrame];
	[animation setEndFrame:endFrame];
	[animation setAnimationCurve:kUIAnimationCurveLinear];
	[animations addObject:animation];
	
	// start animation
	[[UIAnimator sharedAnimator] addAnimations:animations
								  withDuration:0.25
										 start:YES];
}

- (void)_hideKeyboard {
	// get keyboard bound
	CGRect kbFrame = [_keyboard frame];
	
	// animation array
	NSMutableArray* animations = [NSMutableArray arrayWithCapacity:3];
	
	// create animation of table
	CGRect startFrame = [_table frame];
	CGRect endFrame = CGRectMake(startFrame.origin.x, startFrame.origin.y, startFrame.size.width, startFrame.size.height + kbFrame.size.height);
	UIFrameAnimation* animation = [[[UIFrameAnimation alloc] initWithTarget:_table] autorelease];
	[animation setStartFrame:startFrame];
	[animation setEndFrame:endFrame];
	[animation setAnimationCurve:kUIAnimationCurveLinear];
	[animations addObject:animation];
	
	// create animation of search bar
	startFrame = [_searchBar frame];
	endFrame = CGRectMake(startFrame.origin.x, startFrame.origin.y + kbFrame.size.height, startFrame.size.width, startFrame.size.height);
	animation = [[[UIFrameAnimation alloc] initWithTarget:_searchBar] autorelease];
	[animation setStartFrame:startFrame];
	[animation setEndFrame:endFrame];
	[animation setAnimationCurve:kUIAnimationCurveLinear];
	[animations addObject:animation];
	
	// create animation of keyboard
	endFrame = CGRectMake(kbFrame.origin.x, kbFrame.origin.y + kbFrame.size.height, kbFrame.size.width, kbFrame.size.height);
	animation = [[[UIFrameAnimation alloc] initWithTarget:_keyboard] autorelease];
	[animation setStartFrame:kbFrame];
	[animation setEndFrame:endFrame];
	[animation setDelegate:self];
	[animation setAnimationCurve:kUIAnimationCurveLinear];
	[animations addObject:animation];
	
	// start animation
	[[UIAnimator sharedAnimator] addAnimations:animations
								  withDuration:0.25
										 start:YES];
}

- (void)searchButtonClicked:(UIPushButton*)button {
	_searchText = [_searchField text];
	[_searchText retain];
	[_searchField resignFirstResponder];
}

#pragma mark -
#pragma mark alert sheet delegate

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
	
	if(button == 1) {
		// clear
		if(_chatlog)
			[_chatlog removeAllObjects];
		[_cells removeAllObjects];
		
		// clear from disk
		[MessageHistory removeFromDisk:_model];
		
		// refresh table
		[_table reloadData];
	}
}

#pragma mark -
#pragma mark animation delegate

- (void)animator:(UIAnimator*)animator stopAnimation:(UIAnimation*)animation {
	[_keyboard removeFromSuperview];
	[_table reloadData];
}

#pragma mark -
#pragma mark text field delegate

- (void)textFieldDidBecomeFirstResponder:(UITextField*)textField {
	[self _showKeyboard];
}

- (void)textFieldDidResignFirstResponder:(UITextField*)textField {
	[self _hideKeyboard];
}

#pragma mark -
#pragma mark navigation bar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button {
	switch(button) {
		case kNavButtonLeft:
			// save if need
			if(_saveOnBack)
				[MessageHistory saveHistory:_model];
			
			// clear all
			if(_chatlog) {
				[_chatlog release];
				_chatlog = nil;
			}
			[_cells removeAllObjects];
			if(_searchText) {
				[_searchText release];
				_searchText = nil;
			}
				
			// reload to ensure no error occurs when back
			[_table reloadData];
			
			// release focus
			[_searchField resignFirstResponder];
			
			// back
			[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:nil];
			break;
		case kNavButtonRight:
			[UIUtil showQuestion:L(@"ConfirmDeleteHistory") title:L(@"Question") delegate:self];
			break;
	}
}

#pragma mark -
#pragma mark table delegate

- (UITableCell*)table:(UITable*)table cellForRow:(int)row column:(UITableColumn*)col {
	return [_cells objectAtIndex:row];
}

- (float)table:(UITable*)table heightForRow:(int)row {
	ChatLogIMCell* cell = [_cells objectAtIndex:row];
	if([cell isMatched:_searchText])
		return [cell height];
	else
		return 0.0f;
}

- (int)numberOfRowsInTable:(UITable*)table {
	return _chatlog == nil ? 0 : [_chatlog count];
}

- (void)table:(UITable*)table deleteRow:(int)row {
	[_chatlog removeObjectAtIndex:row];
	[_cells removeObjectAtIndex:row];
	[_table reloadData];
	_saveOnBack = YES;
}

@end
