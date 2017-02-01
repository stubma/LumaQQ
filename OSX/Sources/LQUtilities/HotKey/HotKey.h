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

#import <Carbon/Carbon.h>
#import <Cocoa/Cocoa.h>

@interface HotKey : NSObject {
	NSString* m_hotKeyString;
	id m_target;
	SEL m_action;
	UInt32 m_id;
	UInt32 m_owner;
	UInt32 m_keyCode;
	UInt32 m_modifier;
	EventHotKeyRef m_hotKeyRef;
}

+ (id)hotKeyWithOwner:(UInt32)owner string:(NSString*)keyString target:(id)target action:(SEL)action;

- (id)initWithOwner:(UInt32)owner string:(NSString*)keyString target:(id)target action:(SEL)action;

- (BOOL)isValid;

// getter and setter
- (NSString*)string;
- (void)setString:(NSString*)string;
- (id)target;
- (void)setTarget:(id)target;
- (SEL)action;
- (void)setAction:(SEL)action;
- (UInt32)identifier;
- (void)setIdentifier:(UInt32)identifier;
- (UInt32)owner;
- (void)setOwner:(UInt32)owner;
- (UInt32)keyCode;
- (void)setKeyCode:(UInt32)keyCode;
- (UInt32)modifier;
- (void)setModifier:(UInt32)modifier;
- (EventHotKeyRef)hotKeyRef;
- (void)setHotKeyRef:(EventHotKeyRef)ref;

@end
