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

#import "HotKeyManager.h"
#import "KeyTool.h"
#import "KeyDevour.h"

#define _kLQHotKeySignature 'LQHK'

static HotKeyManager* s_instance = nil;

static OSStatus gHotKeyEventHandler(EventHandlerCallRef inHandlerRef, EventRef inEvent, void* refCon) {
	return [[HotKeyManager sharedHotKeyManager] handleHotKeyEvent:inEvent];
}

@implementation HotKeyManager

+ (HotKeyManager*)sharedHotKeyManager {
	if(s_instance == nil) {
		s_instance = [[HotKeyManager alloc] init];
		
		EventTypeSpec eventSpec[] = {
			{ kEventClassKeyboard, kEventHotKeyPressed }
		};    
		
		InstallEventHandler(GetApplicationEventTarget(),
							(EventHandlerProcPtr)gHotKeyEventHandler, 
							1, 
							eventSpec, 
							nil, 
							nil);
	}
		
	return s_instance;
}

- (id) init {
	self = [super init];
	if (self != nil) {
		m_keys = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_keys release];
	[super dealloc];
}

- (void)clean {
	// unregister all
	int count = [m_keys count];
	for(int i = count - 1; i >= 0; i--)
		[self unregisterHotKey:[m_keys objectAtIndex:i]];
}

- (OSStatus)handleHotKeyEvent:(EventRef)inEvent {
	OSStatus err;
	EventHotKeyID keyId;
	
	err = GetEventParameter(inEvent,
							kEventParamDirectObject, 
							typeEventHotKeyID,
							nil,
							sizeof(EventHotKeyID),
							nil,
							&keyId);
	if(err)
		return err;
	
	NSEnumerator* e = [m_keys objectEnumerator];
	while(HotKey* key = [e nextObject]) {
		if([key identifier] == keyId.id) {
			//
			// check whether a shortcut textfield is on focus
			// if it is, don't trigger hot key
			// otherwise, trigger hotkey
			//
			NSWindow* keyWindow = [NSApp keyWindow];
			NSResponder* responder = nil;
			if(keyWindow)
				responder = [keyWindow firstResponder];			
		
			if(responder && [responder conformsToProtocol:@protocol(KeyDevour)]) {
				UniChar keyChar = [KeyTool string2KeyChar:[key string]];
				NSString* characters = keyChar == 0 ? @"z" : [NSString stringWithCharacters:&keyChar length:1];
				NSEvent* event = [NSEvent keyEventWithType:NSKeyDown
												  location:NSMakePoint(0, 0)
											 modifierFlags:[KeyTool string2Modifier:[key string]]
												 timestamp:0
											  windowNumber:0
												   context:nil
												characters:characters
							   charactersIgnoringModifiers:characters
												 isARepeat:NO
												   keyCode:[KeyTool string2KeyCode:[key string]]];
				if([(id<KeyDevour>)responder eatKey:event]) {
					[responder tryToPerform:@selector(keyDown:) with:event];
					return noErr;
				}
			} 
			
			[[key target] performSelector:[key action] withObject:key];
			return noErr;
		}
	}
	
	return eventNotHandledErr;
}

- (BOOL)registerHotKey:(HotKey*)hotKey {
	// validate
	if(![hotKey isValid])
		return NO;
	
	// is registered before?
	NSEnumerator* e = [m_keys objectEnumerator];
	while(HotKey* key = [e nextObject]) {
		if([[hotKey string] isEqualToString:[key string]])
			return NO;
	}
	
	// generate keycode and modifier
	UInt32 keyCode = [KeyTool string2KeyCode:[hotKey string]];
	if(keyCode == -1)
		return NO;
	[hotKey setKeyCode:keyCode];
	[hotKey setModifier:[KeyTool cocoaModifier2CarbonModifier:[KeyTool string2Modifier:[hotKey string]]]];
	
	// register
	EventHotKeyID keyId;
	EventHotKeyRef ref;
	keyId.signature = _kLQHotKeySignature;
	keyId.id = [hotKey identifier];
	OSStatus err = RegisterEventHotKey([hotKey keyCode],
									   [hotKey modifier],
									   keyId,
									   GetApplicationEventTarget(),
									   nil,
									   &ref);
	if(err != noErr)
		return NO;
	
	// save hot key ref
	[hotKey setHotKeyRef:ref];
	
	// add to cache
	[m_keys addObject:hotKey];
	
	return YES;
}

- (BOOL)unregisterHotKey:(HotKey*)hotKey {
	if([hotKey hotKeyRef]) {
		OSStatus err = UnregisterEventHotKey([hotKey hotKeyRef]);
		if(err == noErr) {
			[hotKey setHotKeyRef:nil];
			[m_keys removeObject:hotKey];
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)unregisterHotKeyById:(UInt32)identifier {
	NSEnumerator* e = [m_keys objectEnumerator];
	while(HotKey* key = [e nextObject]) {
		if([key identifier] == identifier)
			return [self unregisterHotKey:key];
	}
	return NO;
}

- (BOOL)unregisterHotKeyByString:(NSString*)keyString {
	NSEnumerator* e = [m_keys objectEnumerator];
	while(HotKey* key = [e nextObject]) {
		if([[key string] isEqualToString:keyString])
			return [self unregisterHotKey:key];
	}
	return NO;
}

- (BOOL)unregisterHotKeyByString:(NSString*)keyString owner:(UInt32)owner {
	NSEnumerator* e = [m_keys objectEnumerator];
	while(HotKey* key = [e nextObject]) {
		if([[key string] isEqualToString:keyString] && [key owner] == owner)
			return [self unregisterHotKey:key];
	}
	return NO;
}

- (BOOL)isHotKeyRegistered:(NSString*)keyString owner:(UInt32)owner {
	NSEnumerator* e = [m_keys objectEnumerator];
	while(HotKey* key = [e nextObject]) {
		if([[key string] isEqualToString:keyString] && [key owner] != owner)
			return YES;
	}
	return NO;
}

@end
