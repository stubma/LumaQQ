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

#import "QQTextView.h"
#import "PreferenceCache.h"
#import "DefaultFace.h"
#import "NSMutableData-CustomAppending.h"
#import "ByteTool.h"
#import "QQConstants.h"
#import "KeyTool.h"
#import "FontTool.h"
#import "Constants.h"
#import "NSString-Converter.h"
#import "NSString-Validate.h"

@implementation QQTextView

- (void)customizeInitialization:(UInt32)QQ {
	m_QQ = QQ;
	m_attributes = [[NSMutableDictionary dictionary] retain];
	m_allowMultiFont = YES;
	
	// create attributes from preference
	PreferenceCache* cache = [PreferenceCache cache:QQ];
	NSFont* font = [FontTool chatFontWithPreference:QQ];
	if([cache chatFontStyleUnderline])
		[m_attributes setObject:[NSNumber numberWithBool:YES] forKey:NSUnderlineStyleAttributeName];
	[m_attributes setObject:font forKey:NSFontAttributeName];
	[m_attributes setObject:[cache chatFontColor] forKey:NSForegroundColorAttributeName];
	
	// change attribute
	[self changeAttributesOfAllText:m_attributes];
}

#pragma mark -
#pragma mark override super methods

- (void) dealloc {
	[m_attributes release];
	[super dealloc];
}

- (void)changeFont:(id)sender {
	if(m_allowMultiFont)
		[super changeFont:sender];
	else {
		NSFont* newFont = [[sender fontPanel:NO] panelConvertFont:[m_attributes objectForKey:NSFontAttributeName]];
		[m_attributes setObject:newFont forKey:NSFontAttributeName];
		[self changeAttributesOfAllText:m_attributes];
		
		// get font trait mask
		NSFontTraitMask mask = [[NSFontManager sharedFontManager] traitsOfFont:newFont];
		
		// save font info to preference
		PreferenceCache* cache = [PreferenceCache cache:m_QQ];
		[cache setChatFontName:[newFont familyName]];
		[cache setChatFontSize:[newFont pointSize]];
		[cache setChatFontStyleBold:((mask & NSBoldFontMask) != 0)];
		[cache setChatFontStyleItalic:((mask & NSItalicFontMask) != 0)];
		[cache setChatFontStyleUnderline:([m_attributes objectForKey:NSUnderlineStyleAttributeName] != nil)];
	}
}

- (void)setTextColor:(NSColor *)color {
	[m_attributes setObject:color forKey:NSForegroundColorAttributeName];
	
	// change attribute
	[self changeAttributesOfAllText:m_attributes];
	
	// save color to preference
	PreferenceCache* cache = [PreferenceCache cache:m_QQ];
	[cache setChatFontColor:color];
}

- (void)paste:(id)sender {
	[super paste:sender];
	[self changeAttributesOfAllText:m_attributes];
}

- (NSDictionary *)typingAttributes {
	return m_attributes;
}

#pragma mark -
#pragma mark responder override

- (void)insertText:(id)aString {
	if(m_checkEnterSendKey && [aString isKindOfClass:[NSString class]] && [aString isNewLine])
		[[self delegate] sendKeyTriggerred:self];
	else
		[super insertText:aString];
}

- (void)keyDown:(NSEvent *)theEvent {
	m_checkEnterSendKey = NO;
	NSString* shortcut = [KeyTool key2String:theEvent];
	PreferenceCache* cache = [PreferenceCache cache:m_QQ];
	if([shortcut isEqualToString:[cache sendKey]]) {
		if([[cache sendKey] length] == 1 && [[cache sendKey] characterAtIndex:0] == kLQUnicodeEnterCharacter) {
			m_checkEnterSendKey = YES;
			[super keyDown:theEvent];
		} else
			[[self delegate] sendKeyTriggerred:self];
	} else if([shortcut isEqualToString:[cache closeKey]])
		[[self delegate] closeKeyTriggerred:self];
	else if([shortcut isEqualToString:[cache historyKey]])
		[[self delegate] historyKeyTriggerred:self];
	else if([shortcut isEqualToString:[cache newLineKey]])
		[[self textStorage] appendAttributedString:[[[NSAttributedString alloc] initWithString:@"\n"] autorelease]];
	else if([shortcut isEqualToString:[cache switchTabKey]])
		[[self delegate] switchTabKeyTriggerred:self];
	else
		[super keyDown:theEvent];
}

#pragma mark -
#pragma mark KeyDevour protocol

- (BOOL)eatKey:(NSEvent*)theEvent {
	NSString* shortcut = [KeyTool key2String:theEvent];
	PreferenceCache* cache = [PreferenceCache cache:m_QQ];
	return [shortcut isEqualToString:[cache sendKey]] ||
		[shortcut isEqualToString:[cache closeKey]] ||
		[shortcut isEqualToString:[cache historyKey]] ||
		[shortcut isEqualToString:[cache newLineKey]] ||
		[shortcut isEqualToString:[cache switchTabKey]];
}

#pragma mark -
#pragma mark helper

- (void)setAllowMultiFont:(BOOL)flag {
	m_allowMultiFont = flag;
}

- (BOOL)allowMultiFont {
	return m_allowMultiFont;
}

- (void)changeAttributesOfAllText:(NSDictionary*)newAttribute {
	NSTextStorage* storage = [self textStorage];
	[storage addAttributes:newAttribute range:NSMakeRange(0, [storage length])];
}

- (void)addAttributedString:(NSAttributedString*)string insert:(BOOL)insert {
	// add to text view
	BOOL bEditable = [self isEditable];
	[self setEditable:YES];
	if(insert)
		[self insertText:string];
	else
		[[self textStorage] appendAttributedString:string];
	[self setEditable:bEditable];
	
	// refresh ui
	[[self window] resetCursorRects];
	[self scrollRangeToVisible:NSMakeRange([[self textStorage] length], 0)];
}

- (void)insertCustomFace:(int)type md5:(NSString*)md5 path:(NSString*)path received:(BOOL)received {
	NSAttributedString* string = [self createCustomFace:type 
													md5:md5
												   path:path
											   received:received];
	[self addAttributedString:string insert:YES];
}

- (NSRange)appendCustomFace:(int)type md5:(NSString*)md5 path:(NSString*)path received:(BOOL)received {
	NSAttributedString* string = [self createCustomFace:type
													md5:md5
												   path:path
											   received:received];
	[self addAttributedString:string insert:NO];
	return NSMakeRange([[self textStorage] length] - 1, 1);
}

- (void)replaceCustomFaceAtIndex:(int)location path:(NSString*)path {
	// get attribute
	NSDictionary* attr = [[self textStorage] attributesAtIndex:location effectiveRange:nil];
	if([attr objectForKey:NSAttachmentAttributeName] == nil)
		return;
	
	// create new attributes
	NSMutableDictionary* newAttr = [NSMutableDictionary dictionaryWithDictionary:attr];
	[newAttr removeObjectForKey:NSAttachmentAttributeName];
	
	// create wrapper
	NSFileWrapper* wrapper = [[[NSFileWrapper alloc] initWithPath:path] autorelease];
	
	// create attachment
	NSTextAttachment* attachment = [[[NSTextAttachment alloc] initWithFileWrapper:wrapper] autorelease];
	
	// create attribute string
	NSMutableAttributedString* string = (NSMutableAttributedString*)[NSMutableAttributedString attributedStringWithAttachment:attachment];
	
	// set attributes
	[string addAttributes:newAttr range:NSMakeRange(0, 1)];
	
	// replace
	[[self textStorage] replaceCharactersInRange:NSMakeRange(location, 1) withAttributedString:string];
	
	[[self window] resetCursorRects];
	[self scrollRangeToVisible:NSMakeRange([[self textStorage] length], 0)];
}

- (NSAttributedString*)createCustomFace:(int)type md5:(NSString*)md5 path:(NSString*)path received:(BOOL)received {
	// create wrapper
	NSFileWrapper* wrapper = [[[NSFileWrapper alloc] initWithPath:path] autorelease];
	
	// create attachment
	NSTextAttachment* attachment = [[[NSTextAttachment alloc] initWithFileWrapper:wrapper] autorelease];
	
	// create attribute string
	NSMutableAttributedString* string = (NSMutableAttributedString*)[NSMutableAttributedString attributedStringWithAttachment:attachment];
	
	// set attribute of code
	NSRange range = NSMakeRange(0, 1);
	if(md5)
		[string addAttribute:kFaceAttributeMD5 value:md5 range:range];
	[string addAttribute:kFaceAttributeType value:[NSNumber numberWithInt:type] range:range];
	[string addAttribute:kFaceAttributeReceived value:[NSNumber numberWithBool:received] range:range];
	[string addAttribute:kFaceAttributePath value:path range:range];
	[string addAttributes:m_attributes range:range];
	
	return string;
}

- (void)insertDefaultFace:(int)index {
	NSAttributedString* string = [self createDefaultFace:index];
	[self addAttributedString:string insert:YES];
}

- (void)appendDefaultFace:(int)index {
	NSAttributedString* string = [self createDefaultFace:index];
	[self addAttributedString:string insert:NO];
}

- (NSAttributedString*)createDefaultFace:(int)index {
	// get file path
	NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"face%u", index]
													 ofType:@"gif"];
	
	// create wrapper
	NSFileWrapper* wrapper = [[[NSFileWrapper alloc] initWithPath:path] autorelease];
	
	// create attachment
	NSTextAttachment* attachment = [[[NSTextAttachment alloc] initWithFileWrapper:wrapper] autorelease];
	
	// create attribute string
	NSMutableAttributedString* string = (NSMutableAttributedString*)[NSMutableAttributedString attributedStringWithAttachment:attachment];
	
	// set attribute of code
	NSNumber* code = [NSNumber numberWithInt:[DefaultFace index2code:index]];
	NSRange range = NSMakeRange(0, 1);
	[string addAttribute:kFaceAttributeCode value:code range:range];
	[string addAttribute:kFaceAttributeType value:[NSNumber numberWithInt:kFaceTypeDefault] range:range];
	[string addAttributes:m_attributes range:range];
	
	return string;
}

@end
