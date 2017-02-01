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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UITransitionView.h>
#import "Constants.h"
#import "UIUnit.h"

// unit name
#define kUIUnitAccountManage @"UIAccountManage"
#define kUIUnitAccountEdit @"UIAccountEdit"
#define kUIUnitLogin @"UILogin"
#define kUIUnitMain @"UIMain"
#define kUIUnitPreference @"UIPreference"
#define kUIUnitUserInfo @"UIUserInfo"
#define kUIUnitClusterInfo @"UIClusterInfo"
#define kUIUnitSelectValue @"UISelectValue"
#define kUIUnitSelectHead @"UISelectHead"
#define kUIUnitUserOperation @"UIUserOperation"
#define kUIUnitGroupOperation @"UIGroupOperation"
#define kUIUnitClusterOperation @"UIClusterOperation"
#define kUIUnitUserChat @"UIUserChat"
#define kUIUnitClusterChat @"UIClusterChat"
#define kUIUnitNameEdit @"UINameEdit"
#define kUIUnitClusterMessageSetting @"UIClusterMessageSetting"
#define kUIUnitChatLog @"UIChatLog"
#define kUIUnitUserAuth @"UIUserAuth"
#define kUIUnitClusterAuth @"UIClusterAuth"

@interface UIController : NSObject {
	UIWindow* _window;
	UINavigationBar* _nav;
	UITransitionView* _transition;
	
	NSMutableDictionary* _unitMap;
	id<UIUnit> _activeUnit;
}

// API
- (void)show;
- (void)addUnit:(id<UIUnit>)unit withName:(NSString*)name;
- (void)transitTo:(NSString*)unitName style:(int)style data:(NSMutableDictionary*)data;
- (UINavigationBar*)navBar;
- (UIView*)contentView;
- (CGRect)clientRect;
- (BOOL)isUnitActive:(NSString*)unitName;

@end
