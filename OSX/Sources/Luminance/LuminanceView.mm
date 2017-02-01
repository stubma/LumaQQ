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

#import "LuminanceView.h"
#import "FontTool.h"
#import "NSData-BytesOperation.h"
#import "IntegerInterpreter.h"
#import "IPInterpreter.h"
#import "Md5Interpreter.h"
#import "StringInterpreter.h"

@implementation LuminanceView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		m_debugging = NO;
		m_debugObjects = [[NSMutableArray array] retain];
		m_unecryptedMap = [[NSMutableDictionary dictionary] retain];
		m_encryptedMap = [[NSMutableDictionary dictionary] retain];
		m_interpreters = [[NSMutableArray array] retain];
		m_evaluatedResults = [[NSMutableArray array] retain];
		m_keyNames = [[NSMutableArray array] retain];
		m_keys = [[NSMutableArray array] retain];
		
		[m_interpreters addObject:[[[IntegerInterpreter alloc] init] autorelease]];
		[m_interpreters addObject:[[[IPInterpreter alloc] init] autorelease]];
		[m_interpreters addObject:[[[Md5Interpreter alloc] init] autorelease]];
		[m_interpreters addObject:[[[StringInterpreter alloc] init] autorelease]];
    }
    return self;
}

- (void) dealloc {
	[m_main release];
	[m_debugObjects release];
	[m_unecryptedMap release];
	[m_encryptedMap release];
	[m_interpreters release];
	[m_evaluatedResults release];
	[m_keyNames release];
	[m_keys release];
	[m_selected release];
	[super dealloc];
}

- (void)awakeFromNib {
	NSFont* font = [FontTool fontWithName:@"Courier" size:14 bold:NO italic:NO];
	[m_txtDecrypted setFont:font];
	[m_txtEncrypted setFont:font];
}

- (BOOL)handleDebugEvent:(DebugEvent*)event {
	[m_debugObjects addObject:[event packet]];
	[m_unecryptedMap setObject:[event data] forKey:[self packetKey:[event packet]]];
	[m_packetView reloadData];
	return YES;
}

#pragma mark -
#pragma mark helper

- (NSString*)packetKey:(Packet*)packet {
	return [NSString stringWithFormat:@"%@ %u", [packet className], [packet hash]];
}

#pragma mark -
#pragma mark API

- (void)addKey:(NSData*)key name:(NSString*)keyName {
	[m_keys addObject:key];
	[m_keyNames addObject:keyName];
}

- (void)beginDebug {
	if(!m_debugging && [self canDebug]) {
		[[m_main client] addDebugListener:self];
		m_debugging = YES;
	}
}

- (void)endDebug {
	if(m_debugging && [self canDebug]) {
		[[m_main client] removeDebugListener:self];
		m_debugging = NO;
	}
}

- (BOOL)isDebugging {
	return m_debugging;
}

- (BOOL)canDebug {
	return m_main != nil;
}

#pragma mark -
#pragma mark getter and setter

- (void)setMainWindowController:(MainWindowController*)main {
	[main retain];
	[m_main release];
	m_main = main;
}

#pragma mark -
#pragma mark packet table delegate

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
	int row = [m_packetView selectedRow];
	[m_txtDecrypted setString:@""];
	[m_txtEncrypted setString:@""];
	if(row == -1)
		return;
	
	NSData* unencrypted = nil;
	NSData* encrypted = nil;
	id obj = [m_debugObjects objectAtIndex:row];	
	if([obj isKindOfClass:[Packet class]]) {
		NSString* key = [self packetKey:obj];
		unencrypted = [m_unecryptedMap objectForKey:key];
		encrypted = [m_encryptedMap objectForKey:key];
	}

	if(unencrypted != nil)
		[m_txtDecrypted setString:[unencrypted hexString]];
	if(encrypted != nil)
		[m_txtEncrypted setString:[encrypted hexString]];
}

#pragma mark -
#pragma mark packet table data source

- (int)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [m_debugObjects count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
	id obj = [m_debugObjects objectAtIndex:rowIndex];
	if([obj isKindOfClass:[Packet class]]) {
		if([obj isKindOfClass:[InPacket class]])
			return [NSString stringWithFormat:@"(I) %@", [obj className]];
		else
			return [NSString stringWithFormat:@"(O) %@", [obj className]];
	} else
		return @"Unknown Debug Object";
}

#pragma mark -
#pragma mark menu delegate

- (int)numberOfItemsInMenu:(NSMenu *)menu {
	if(menu == m_textMenu) {
		[m_evaluatedResults removeAllObjects];
		if(m_selected != nil) {
			NSEnumerator* e = [m_interpreters objectEnumerator];
			while(id<DataInterpreter> di = [e nextObject]) {
				NSString* result = [di interpret:m_selected];
				if(result != nil)
					[m_evaluatedResults addObject:result];
			}
		}
		return 3 + [m_evaluatedResults count];
	} else if(menu == m_decryptMenu || menu == m_encryptMenu)
		return [m_keys count];
	else
		return 0;
}

- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(int)index shouldCancel:(BOOL)shouldCancel {
	if(menu == m_textMenu) {
		if(index < 3) {
			[item setEnabled:YES];
		} else {
			NSString* result = [m_evaluatedResults objectAtIndex:(index - 3)];
			[item setEnabled:YES];
			[item setTitle:result];
		}
	} else if(menu == m_decryptMenu || menu == m_encryptMenu) {
		[item setEnabled:YES];
		[item setTitle:[m_keyNames objectAtIndex:index]];
	}
	
	return YES;
}

#pragma mark -
#pragma mark text view delegate

- (void)textViewDidChangeSelection:(NSNotification *)aNotification {
	NSTextView* text = [aNotification object];
	NSRange range = [text selectedRange];
	NSString* string = [[text string] substringWithRange:range];
	[m_selected release];
	m_selected = [[NSData dataWithHexString:string] retain];
	[m_lblHint setStringValue:[NSString stringWithFormat:@"Length: %u or 0x%X", [m_selected length], [m_selected length]]];
}

@end
