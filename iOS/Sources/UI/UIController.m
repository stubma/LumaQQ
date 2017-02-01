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

#import "UIController.h"
#import "UIAccountManage.h"
#import "UIAccountEdit.h"
#import "UIUnit.h"
#import "UILogin.h"
#import "UIMain.h"
#import "UIPreference.h"
#import "UIUserInfo.h"
#import "UISelectHead.h"
#import "UISelectValue.h"
#import "UIUserOperation.h"
#import "UIGroupOperation.h"
#import "UIClusterOperation.h"
#import "UIUserChat.h"
#import "UIClusterChat.h"
#import "UIClusterInfo.h"
#import "UINameEdit.h"
#import "UIClusterMessageSetting.h"
#import "UIChatLog.h"
#import "UIUserAuth.h"
#import "UIClusterAuth.h"

@implementation UIController

- (id) init {
	self = [super init];
	if (self != nil) {		
		// create unit map
		_unitMap = [[NSMutableDictionary dictionary] retain];
		
		// create units
		[self addUnit:[[[UIAccountManage alloc] init] autorelease] withName:kUIUnitAccountManage];
		[self addUnit:[[[UIAccountEdit alloc] init] autorelease] withName:kUIUnitAccountEdit];
		[self addUnit:[[[UILogin alloc] init] autorelease] withName:kUIUnitLogin];
		[self addUnit:[[[UIMain alloc] init] autorelease] withName:kUIUnitMain];
		[self addUnit:[[[UIPreference alloc] init] autorelease] withName:kUIUnitPreference];
		[self addUnit:[[[UIUserInfo alloc] init] autorelease] withName:kUIUnitUserInfo];
		[self addUnit:[[[UISelectValue alloc] init] autorelease] withName:kUIUnitSelectValue];
		[self addUnit:[[[UISelectHead alloc] init] autorelease] withName:kUIUnitSelectHead];
		[self addUnit:[[[UIUserOperation alloc] init] autorelease] withName:kUIUnitUserOperation];
		[self addUnit:[[[UIGroupOperation alloc] init] autorelease] withName:kUIUnitGroupOperation];
		[self addUnit:[[[UIClusterOperation alloc] init] autorelease] withName:kUIUnitClusterOperation];
		[self addUnit:[[[UIUserChat alloc] init] autorelease] withName:kUIUnitUserChat];
		[self addUnit:[[[UIClusterChat alloc] init] autorelease] withName:kUIUnitClusterChat];
		[self addUnit:[[[UIClusterInfo alloc] init] autorelease] withName:kUIUnitClusterInfo];
		[self addUnit:[[[UINameEdit alloc] init] autorelease] withName:kUIUnitNameEdit];
		[self addUnit:[[[UIClusterMessageSetting alloc] init] autorelease] withName:kUIUnitClusterMessageSetting];
		[self addUnit:[[[UIChatLog alloc] init] autorelease] withName:kUIUnitChatLog];
		[self addUnit:[[[UIUserAuth alloc] init] autorelease] withName:kUIUnitUserAuth];
		[self addUnit:[[[UIClusterAuth alloc] init] autorelease] withName:kUIUnitClusterAuth];
		
		// create window
		_window = [[UIWindow alloc] initWithFrame:[UIHardware fullScreenApplicationContentRect]];
		
		// create and set content view
		CGRect windowBound = [_window bounds];
		UIView* contentView = [[UIView alloc] initWithFrame:windowBound];
		[_window setContentView:contentView];
		
		// create navigation bar
		CGSize navSize = [UINavigationBar defaultSize];
		_nav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, navSize.width, navSize.height)];
		[_nav setBarStyle:5];
		[_nav enableAnimation];
		
		// create transition view
		_transition = [[UITransitionView alloc] initWithFrame:CGRectMake(0, navSize.height, windowBound.size.width, windowBound.size.height - navSize.height)];
		
		// add sub views
		[contentView addSubview:_nav];
		[contentView addSubview:_transition];
	}
	return self;
}

- (void) dealloc {
	[_unitMap release];
	[_nav release];
	[_window release];
	[super dealloc];
}

- (void)show {
	// show
	[_window orderFront:self];
	[_window makeKey:self];
}

- (void)addUnit:(id<UIUnit>)unit withName:(NSString*)name {
	[_unitMap setObject:unit forKey:name];
}

- (void)transitTo:(NSString*)unitName style:(int)style data:(NSMutableDictionary*)data {
	// stop current unit
	if(_activeUnit != nil) {
		[_activeUnit stop:self];
		[[_activeUnit view] resignFirstResponder];
		_activeUnit = nil;
	}
	
	// find the unit
	_activeUnit = [_unitMap objectForKey:unitName];
	if(_activeUnit != nil) {
		[_activeUnit begin:self];
		[[_activeUnit view] becomeFirstResponder];
		[_activeUnit refresh:data];
		[_transition transition:style toView:[_activeUnit view]];
	}
}

- (UINavigationBar*)navBar {
	return _nav;
}

- (UIView*)contentView {
	return [_window contentView];
}

- (CGRect)clientRect {
	return [_transition bounds];
}

- (BOOL)isUnitActive:(NSString*)unitName {
	return [unitName isEqualToString:[_activeUnit name]];
}

@end
