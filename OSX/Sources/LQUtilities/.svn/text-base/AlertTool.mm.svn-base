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

#import "AlertTool.h"
#import "LocalizedStringTool.h"

@implementation AlertTool

+ (void)showWarning:(NSWindow*)docWindow message:(NSString*)msg {
	NSAlert* alert = [NSAlert alertWithMessageText:L(@"LQWarning")
									 defaultButton:L(@"LQOK")
								   alternateButton:nil
									   otherButton:nil
						 informativeTextWithFormat:msg];
	[alert beginSheetModalForWindow:docWindow
					  modalDelegate:nil
					 didEndSelector:nil
						contextInfo:nil];	
}

+ (void)showWarning:(NSWindow*)docWindow title:(NSString*)title message:(NSString*)msg delegate:(id)delegate didEndSelector:(SEL)selector {
	NSAlert* alert = [NSAlert alertWithMessageText:title
									 defaultButton:L(@"LQOK")
								   alternateButton:nil
									   otherButton:nil
						 informativeTextWithFormat:msg];
	[alert beginSheetModalForWindow:docWindow
					  modalDelegate:delegate
					 didEndSelector:selector
						contextInfo:nil];	
}

+ (BOOL)showConfirm:(NSWindow*)docWindow message:(NSString*)msg {
	NSAlert* alert = [NSAlert alertWithMessageText:L(@"LQConfirm")
									 defaultButton:L(@"LQNo")
								   alternateButton:L(@"LQYes")
									   otherButton:nil
						 informativeTextWithFormat:msg];
	
	return [alert runModal] == NSAlertAlternateReturn;
}

+ (void)showConfirm:(NSWindow*)docWindow message:(NSString*)msg defaultButton:(NSString*)defaultButton alternateButton:(NSString*)alternateButton delegate:(id)delegate didEndSelector:(SEL)selector {
	NSAlert* alert = [NSAlert alertWithMessageText:L(@"LQConfirm")
									 defaultButton:defaultButton
								   alternateButton:alternateButton
									   otherButton:nil
						 informativeTextWithFormat:msg];
	[alert beginSheetModalForWindow:docWindow
					  modalDelegate:delegate
					 didEndSelector:selector
						contextInfo:nil];	
}

+ (void)showConfirm:(NSWindow*)docWindow message:(NSString*)msg defaultButton:(NSString*)defaultButton alternateButton:(NSString*)alternateButton otherButton:(NSString*)otherButton delegate:(id)delegate didEndSelector:(SEL)selector {
	NSAlert* alert = [NSAlert alertWithMessageText:L(@"LQConfirm")
									 defaultButton:defaultButton
								   alternateButton:alternateButton
									   otherButton:otherButton
						 informativeTextWithFormat:msg];
	[alert beginSheetModalForWindow:docWindow
					  modalDelegate:delegate
					 didEndSelector:selector
						contextInfo:nil];	
}

@end
