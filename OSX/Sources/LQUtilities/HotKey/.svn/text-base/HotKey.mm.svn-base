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

#import "HotKey.h"

static UInt32 s_id = 0;

@implementation HotKey

+ (id)hotKeyWithOwner:(UInt32)owner string:(NSString*)keyString target:(id)target action:(SEL)action {
	HotKey* hotKey = [[HotKey alloc] initWithOwner:owner
											string:keyString
											target:target
											action:action];
	return [hotKey autorelease];
}

- (id)initWithOwner:(UInt32)owner string:(NSString*)keyString target:(id)target action:(SEL)action {
	self = [super init];
	if(self) {
		[self setIdentifier:s_id++];
		[self setString:keyString];
		[self setTarget:target];
		[self setAction:action];
		[self setOwner:owner];
	}
	return self;
}

- (BOOL)isValid {
	return m_target && m_action && m_hotKeyString;
}

- (void) dealloc {
	[m_target release];
	[m_hotKeyString release];
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

- (NSString*)string {
	return m_hotKeyString;
}

- (void)setString:(NSString*)string {
	[string retain];
	[m_hotKeyString release];
	m_hotKeyString = string;
}

- (id)target {
	return m_target;
}

- (void)setTarget:(id)target {
	[target retain];
	[m_target release];
	m_target = target;
}

- (SEL)action {
	return m_action;
}

- (void)setAction:(SEL)action {
	m_action = action;
}

- (UInt32)identifier {
	return m_id;
}

- (void)setIdentifier:(UInt32)identifier {
	m_id = identifier;
}

- (UInt32)owner {
	return m_owner;
}

- (void)setOwner:(UInt32)owner {
	m_owner = owner;
}

- (UInt32)keyCode {
	return m_keyCode;
}

- (void)setKeyCode:(UInt32)keyCode {
	m_keyCode = keyCode;
}

- (UInt32)modifier {
	return m_modifier;
}

- (void)setModifier:(UInt32)modifier {
	m_modifier = modifier;
}

- (EventHotKeyRef)hotKeyRef {
	return m_hotKeyRef;
}

- (void)setHotKeyRef:(EventHotKeyRef)ref {
	m_hotKeyRef = ref;
}

@end
