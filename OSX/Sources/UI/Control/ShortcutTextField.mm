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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 0 2111-1307 USA
 */

#import "ShortcutTextField.h"
#import "KeyTool.h"

@implementation ShortcutTextField

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	if(self) {
		[self setAlignment:NSCenterTextAlignment];
	}
	return self;
}

- (id)initWithFrame:(NSRect)frameRect textContainer:(NSTextContainer *)aTextContainer {
	self = [super initWithFrame:frameRect textContainer:aTextContainer];
	if(self) {
		[self setAlignment:NSCenterTextAlignment];
	}
	return self;
}

- (void)keyDown:(NSEvent *)theEvent {
	if(([theEvent modifierFlags] & (NSCommandKeyMask | NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask)) == 0) {
		NSString* str = [theEvent charactersIgnoringModifiers];
		if([str length] == 1 && [str characterAtIndex:0] == NSTabCharacter) {
			[[self window] selectNextKeyView:self];
			return;
		}
	}
		
	[self setString:[KeyTool key2String:theEvent]];
	if([self delegate])
		[[self delegate] shortcutDidChanged:self];
}

- (void)keyUp:(NSEvent *)theEvent {
}

- (BOOL)eatKey:(NSEvent*)theEvent {
	return YES;
}

@end
