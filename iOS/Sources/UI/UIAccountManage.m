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
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIBox.h>
#import <UIKit/UIRemoveControl.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIFrameAnimation.h>
#import <UIKit/UIAnimator.h>
#import "UIAccountManage.h"
#import "UIController.h"
#import "FileTool.h"
#import "UIUtil.h"
#import "NSData-MD5.h"
#import "NSData-Base64.h"
#import "LocalizedStringTool.h"

@implementation UIAccountManage

- (void) dealloc {
	[_table release];
	[_accounts release];
	[_cells release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitAccountManage;
}

- (void)begin:(UIController*)uiController {
	// save handle
	_uiController = uiController;
	
	// push navigation item
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:@"LumaQQ"] autorelease];
	[[uiController navBar] pushNavigationItem:item];
	
	// show button
	[[uiController navBar] showButtonsWithLeftTitle:L(@"Edit") rightTitle:L(@"Add")];
	
	// set delegate
	[[uiController navBar] setDelegate:self];
}

- (void)stop:(UIController*)uiController {
	[[uiController navBar] setNavigationItems:[NSArray array]];
	[[uiController navBar] setDelegate:nil];
}

- (UIView*)view {
	if(_table == nil) {
		// create account array
		_accounts = [[NSMutableArray array] retain];
		
		// create cell mapping
		_cells = [[NSMutableDictionary dictionary] retain];
		
		// load accounts from root, every account is saved in a directory whose
		// name is equal to qq number
		NSFileManager* fm = [NSFileManager defaultManager];
		[FileTool createDirectory:kLQDirectoryRoot withFileManager:fm];
		NSArray* subs = [FileTool directoryContentsAtPath:kLQDirectoryRoot];
		NSEnumerator* e = [subs objectEnumerator];
		NSString* sub = nil;
		BOOL bDir;
		while(sub = [e nextObject]) {
			if([fm fileExistsAtPath:[FileTool getAccountPathByString:sub] isDirectory:&bDir]) {
				if(bDir)
					[_accounts addObject:sub];
			}
		}
		
		// create table
		CGRect bound = [_uiController clientRect];
		_table = [[AccountTable alloc] initWithFrame:bound];

		UITableColumn* col = [[[UITableColumn alloc] initWithTitle:@"Account" 
														identifier:@"account"
															 width:bound.size.width] autorelease];
		[_table addTableColumn:col];
		[_table setSeparatorStyle:kTableSeparatorSingle];
		[_table setDelegate:self];
		[_table setDataSource:self];
		[_table reloadData];
	}
	return _table;
}

- (void)refresh:(NSMutableDictionary*)data {	
	// set correct navigation item
	if(_editing) {
		[[_uiController navBar] showLeftButton:L(@"Done") withStyle:kNavButtonStyleBlue rightButton:L(@"Add") withStyle:kNavButtonStyleNormal];
	} else {
		[[_uiController navBar] showButtonsWithLeftTitle:L(@"Edit") rightTitle:L(@"Add")];
	}
		
	// refresh table
	if(data != nil) {
		NSNumber* qq = [data objectForKey:kDataKeyQQ];
		if(qq != nil) {			
			// get account info file path
			NSString* qqStr = [NSString stringWithFormat:@"%u", [qq unsignedIntValue]];
			NSString* path = [FileTool getMyselfPlistByString:qqStr];
			
			// clear plain password
			NSNumber* makeMD5Int = [data objectForKey:kDataKeyDontMakeMD5];
			if(makeMD5Int == nil || makeMD5Int != nil && [makeMD5Int boolValue] == NO) {
				// max password length is 16
				NSString* pwd = [data objectForKey:kDataKeyPassword];
				if([pwd length] > 16)
					pwd = [pwd substringToIndex:16];
				const char* bytes = [pwd UTF8String];
				NSData* pwdData = [NSData dataWithBytes:bytes length:strlen(bytes)];
				pwdData = [pwdData MD5];
				pwdData = [pwdData base64Encode];
				pwd = [[[NSString alloc] initWithBytes:[pwdData bytes] length:[pwdData length] encoding:NSASCIIStringEncoding] autorelease];
				[data setObject:pwd forKey:kDataKeyPassword];
			}
			
			// remove unwanted value
			[data removeObjectForKey:kDataKeyDontMakeMD5];

			// save to file system
			[FileTool initDirectoryForFile:path];
			[data writeToFile:path atomically:YES];
			
			// reload table
			if(![_accounts containsObject:qqStr]) {
				[_accounts addObject:qqStr];
				[_table reloadData];
			}
		}
	}
}

- (void)_setRemoveControlVisible:(BOOL)visible {
	// get all cells, the visibleCells return an array and every 
	// element is an array also, represents a group. The remove
	// control is saved in a dictionary, mapped to cell title
	NSArray* cells = [_table visibleCells];
	NSEnumerator* e = [[cells objectAtIndex:0] objectEnumerator];
	UIImageAndTextTableCell* cell;
	while(cell = [e nextObject]) {
		[cell _showDeleteOrInsertion:visible
					  withDisclosure:visible
							animated:YES
							isDelete:YES
			   andRemoveConfirmation:NO];
	}
}

- (UIAnimation*)_getShowLoginButtonAnimationInCell:(UITableCell*)cell {
	CGRect cellBound = [cell frame];
	CGRect startFrame = CGRectMake(cellBound.size.width, (cellBound.size.height - 32) / 2, 55, 32);
	CGRect endFrame = CGRectMake(cellBound.size.width - 60, (cellBound.size.height - 32) / 2, 55, 32);
	
	// create a login button
	GSFontRef font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 16.0f);
	UIPushButton* button = [[UIPushButton alloc] initWithFrame:startFrame];
	[button setDrawsShadow:YES];
	[button setEnabled:YES];
	[button setStretchBackground:YES];
	[button setBackground:[UIImage imageNamed:kImageLoginButtonUp] forState:kButtonStateUp];
	[button setBackground:[UIImage imageNamed:kImageLoginButtonDown] forState:kButtonStateDown];
	[button setAutosizesToFit:NO];
	[button setTitleFont:font];
	[button setTitle:L(@"Login")];
	[button addTarget:self action:@selector(loginButtonClicked:) forEvents:kUIMouseUp];
	CFRelease(font);

	// add to cell
	[cell addSubview:button];
	[button release];

	// animate
	UIFrameAnimation* animation = [[[UIFrameAnimation alloc] initWithTarget:button] autorelease];
	[animation setStartFrame:startFrame];
	[animation setEndFrame:endFrame];
	[animation setAnimationCurve:kUIAnimationCurveLinear];
	
	return animation;
}

- (UIAnimation*)_getHideLoginButtonAnimation:(UIPushButton*)button inCell:(UITableCell*)cell {
	CGRect cellBound = [cell frame];
	CGRect endFrame = CGRectMake(cellBound.size.width, (cellBound.size.height - 32) / 2, 55, 32);
	
	// animate
	UIFrameAnimation* animation = [[[UIFrameAnimation alloc] initWithTarget:button] autorelease];
	[animation setStartFrame:[button frame]];
	[animation setEndFrame:endFrame];
	[animation setAnimationCurve:kUIAnimationCurveLinear];
	
	return animation;
}

- (void)loginButtonClicked:(UIPushButton*)button {
	// get selected account
	NSString* qqStr = [_accounts objectAtIndex:[_table selectedRow]];
	
	// get myself.plist path
	NSString* path = [FileTool getMyselfPlistByString:qqStr];
	
	// load myself.plist
	NSMutableDictionary* plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	// go to login view
	[_uiController transitTo:kUIUnitLogin style:kTransitionStyleLeftSlide data:plist];
}

#pragma mark -
#pragma mark table data source and delegate

- (UITableCell*)table:(UITable*)table cellForRow:(int)row column:(UITableColumn*)col {
	NSString* qqStr = [_accounts objectAtIndex:row];
	UIImageAndTextTableCell* cell = [_cells objectForKey:qqStr];
	if(cell == nil) {
		cell = [[[UIImageAndTextTableCell alloc] init] autorelease];
		[cell setTitle:qqStr];
		[_cells setObject:cell forKey:qqStr];
	}
	return cell;
}

- (void)table:(UITable*)table willDisplayRowsInRange:(NSRange)range {
	// refresh
	if(_editing) {
		NSEnumerator* e = [_cells objectEnumerator];
		UIImageAndTextTableCell* cell;
		while(cell = [e nextObject]) {
			if(![cell isRemoveControlVisible]) {
				[cell _showDeleteOrInsertion:YES
							  withDisclosure:YES
									animated:NO
									isDelete:YES
					   andRemoveConfirmation:NO];
			}
		}
	}
}

- (int)numberOfRowsInTable:(UITable*)table {
	return [_accounts count];
}

- (BOOL)table:(UITable*)table showDisclosureForRow:(int)row {
	return _editing;
}

- (void)table:(UITable*)table deleteRow:(int)row {
	// remove account from file system
	NSString* path = [FileTool getAccountPathByString:[_accounts objectAtIndex:row]];
	if([FileTool deleteFile:path]) {
		NSString* qqStr = [_accounts objectAtIndex:row];
		[_accounts removeObjectAtIndex:row];
		[_cells removeObjectForKey:qqStr];
	}
}

- (void)tableRowSelected:(NSNotification*)notification {
	// get selected qq string
	NSString* qqStr = [_accounts objectAtIndex:[_table selectedRow]];
	
	// get myself.plist, if not exist, return
	NSString* path = [FileTool getMyselfPlistByString:qqStr];
	if([FileTool isFileExist:path]) {
		NSMutableDictionary* data = [NSMutableDictionary dictionaryWithContentsOfFile:path];
		if(data != nil) {
			if(_editing) {
				[data setObject:[NSNumber numberWithBool:YES] forKey:kDataKeyDontMakeMD5];
				[_uiController transitTo:kUIUnitAccountEdit style:kTransitionStyleLeftSlide data:data];
			} else {
				// get cell
				UITableCell* cell = [_cells objectForKey:qqStr];
				
				// if same cell, return
				if(_loginButton != nil && [_loginButton superview] == cell) 
					return;
				
				// create animation array
				NSMutableArray* animations = [NSMutableArray arrayWithCapacity:2];
				
				// get hide login button animation
				if(_loginButton != nil) {
					UIAnimation* animation = [self _getHideLoginButtonAnimation:_loginButton inCell:cell];
					[animation setDelegate:self];
					[animations addObject:animation];
				}
				
				// get show login button animation
				UIAnimation* animation = [self _getShowLoginButtonAnimationInCell:cell];
				_loginButton = [animation target];
				[animations addObject:animation];
				
				// start animation
				[[UIAnimator sharedAnimator] addAnimations:animations
											  withDuration:0.25
													 start:YES];
			}
		} else {
			[UIUtil showWarning:L(@"InvalidAccountInfoFile") title:L(@"Warning") delegate:self];
		}
	} else
		[UIUtil showWarning:L(@"CanNotFindAccountInfoFile") title:L(@"Warning") delegate:self];
}

#pragma mark -
#pragma mark animation delegate

- (void)animator:(UIAnimator*)animator stopAnimation:(UIAnimation*)animation {
	if ([animation target] != nil) {
		[[animation target] removeFromSuperview];
	}
}

#pragma mark -
#pragma mark alert sheet delegate

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
}

#pragma mark -
#pragma mark navigation bar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button {
	switch(button) {
		case kNavButtonLeft:
			_editing = !_editing;
			[_table setEditing:_editing];
			
			// change navigation title
			if(_editing) {
				[[_uiController navBar] showLeftButton:L(@"Done") withStyle:kNavButtonStyleBlue rightButton:L(@"Add") withStyle:kNavButtonStyleNormal];
				
				// get hide login button animation
				if(_loginButton != nil) {
					NSMutableArray* animations = [NSMutableArray arrayWithCapacity:1];
					UIAnimation* animation = [self _getHideLoginButtonAnimation:_loginButton inCell:[_loginButton superview]];
					[animation setDelegate:self];
					[animations addObject:animation];
					_loginButton = nil;
					
					// start animation
					[[UIAnimator sharedAnimator] addAnimations:animations
												  withDuration:0.25
														 start:YES];
				}
			} else {
				[[_uiController navBar] showButtonsWithLeftTitle:L(@"Edit") rightTitle:L(@"Add")];
			}
				
			// switch remove control
			[self _setRemoveControlVisible:_editing];
			break;
		case kNavButtonRight:
			[_uiController transitTo:kUIUnitAccountEdit style:kTransitionStyleLeftSlide data:nil];
			break;
	}
}

@end
