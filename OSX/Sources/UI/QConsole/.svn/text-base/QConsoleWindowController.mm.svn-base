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

#import "QConsoleWindowController.h"
#import "WindowRegistry.h"
#import "FontTool.h"

@implementation QConsoleWindowController

- (id) init {
	self = [super initWithWindowNibName:@"QConsole"];
	if(self != nil) {
		
	}
	return self;
}

- (void)awakeFromNib {
	NSFont* font = [FontTool fontWithName:@"Monaco" size:16 bold:NO italic:NO];
	[m_txtConsole setTextColor:[NSColor greenColor]];
	[m_txtConsole setFont:font];
	[m_txtInput setFont:font];
}

- (void)windowWillClose:(NSNotification *)aNotification { 
	if([aNotification object] != [self window])
		return;
	
	[WindowRegistry unregisterQConsole];
	[self release];
}

- (void)appendCommand:(NSString*)command {
	NSString* s = [NSString stringWithFormat:@"QConsole> %@\r\n", command];
	NSMutableAttributedString* string = [[[NSMutableAttributedString alloc] initWithString:s] autorelease];
	NSRange range = NSMakeRange(0, [s length]);
	[string addAttribute:NSForegroundColorAttributeName value:[NSColor greenColor] range:range];
	[string addAttribute:NSFontAttributeName value:[FontTool fontWithName:@"Monaco" size:16 bold:NO italic:NO] range:range];
	NSTextStorage* storage = [m_txtConsole textStorage];
	[storage appendAttributedString:string];

	// refresh ui
	[[self window] resetCursorRects];
	[m_txtConsole scrollRangeToVisible:NSMakeRange([storage length], 0)];
}

- (void)appendNormalText:(NSString*)text {
	NSString* s = [NSString stringWithFormat:@"%@\r\n\r\n", text];
	NSMutableAttributedString* string = [[[NSMutableAttributedString alloc] initWithString:s] autorelease];
	NSRange range = NSMakeRange(0, [s length]);
	[string addAttribute:NSForegroundColorAttributeName value:[NSColor cyanColor] range:range];
	[string addAttribute:NSFontAttributeName value:[FontTool fontWithName:@"Monaco" size:16 bold:NO italic:NO] range:range];
	NSTextStorage* storage = [m_txtConsole textStorage];
	[storage appendAttributedString:string];
	
	// refresh ui
	[[self window] resetCursorRects];
	[m_txtConsole scrollRangeToVisible:NSMakeRange([storage length], 0)];
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification {
	[self appendCommand:[m_txtInput stringValue]];
	[self appendNormalText:@"result test"];
}

@end
