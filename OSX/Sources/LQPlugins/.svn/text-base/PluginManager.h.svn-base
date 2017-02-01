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
#import "QBarPlugin.h"
#import "SoundSchemaPlugin.h"

// LumaQQ Plugin Idenifier prefix
#define kLQPluginPrefixQBar @"edu.tsinghua.LumaQQ.QBar"
#define kLQPluginPrefixSoundSchema @"edu.tsinghua.LumaQQ.SoundSchema"

@class MainWindowController;

@interface PluginManager : NSObject {
	MainWindowController* m_domain;
	
	NSMutableArray* m_qbarPlugins;
	NSMutableArray* m_soundPlugins;
}

- (id)initWithDomain:(MainWindowController*)domain;

// API
- (void)loadPlugins;
- (void)unloadPlugins;
- (id<QBarPlugin>)QBarPluginWithName:(NSString*)name;
- (id<QBarPlugin>)QBarPluginAtIndex:(int)index;
- (int)QBarPluginCount;
- (NSEnumerator*)soundPluginEnumerator;
- (id<SoundSchemaPlugin>)soundPluginWithName:(NSString*)name;
- (id<SoundSchemaPlugin>)soundPluginAtIndex:(int)index;

@end
