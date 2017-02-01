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

#import <Cocoa/Cocoa.h>

@class MainWindowController;

@interface Mobile : NSObject <NSCoding, NSCopying> {
	NSString* m_name;
	NSString* m_mobile;
	
	// ui info
	float m_inputBoxProportion;
	
	// used for QQCell
	UInt32 m_messageCount;
	int m_frame;
	
	// for tell the domain
	MainWindowController* m_domain;
}

- (id)initWithMobile:(NSString*)mobile domain:(MainWindowController*)domain;
- (id)initWithName:(NSString*)name mobile:(NSString*)mobile domain:(MainWindowController*)domain;

- (void)increaseMessageCount;

// getter and setter
- (NSString*)name;
- (void)setName:(NSString*)name;
- (NSString*)mobile;
- (void)setMobile:(NSString*)mobile;
- (UInt32)messageCount;
- (void)setMessageCount:(UInt32)count;
- (int)frame;
- (void)setFrame:(int)frame;
- (float)inputBoxProportion;
- (void)setInputBoxProportion:(float)proportion;
- (MainWindowController*)domain;
- (void)setDomain:(MainWindowController*)domain;

@end
