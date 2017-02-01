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

#import "PluginManager.h"
#import "Constants.h"

@implementation PluginManager

- (id)initWithDomain:(MainWindowController*)domain {
	self = [super init];
	if(self) {
		m_domain = [domain retain];
		m_qbarPlugins = [[NSMutableArray array] retain];
		m_soundPlugins = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_domain release];
	[m_qbarPlugins release];
	[m_soundPlugins release];
	[super dealloc];
}

#pragma mark -
#pragma mark API

- (void)loadPlugins {
	NSString* pluginBase = [[NSBundle mainBundle] builtInPlugInsPath];
	NSEnumerator* e = [[[NSFileManager defaultManager] directoryContentsAtPath:pluginBase] objectEnumerator];
	while(NSString* plugin = [e nextObject]) {
		NSBundle* pluginBundle = [NSBundle bundleWithPath:[pluginBase stringByAppendingPathComponent:plugin]];
		if(pluginBundle) {
			// get plugin identifier
			NSString* identifier = [pluginBundle objectForInfoDictionaryKey:@"CFBundleIdentifier"];
			
			// check weather it's a QBar
			if([identifier rangeOfString:kLQPluginPrefixQBar].location != NSNotFound) {
				Class klass = [pluginBundle principalClass];
				if(klass) {
					id instance = [[klass alloc] init];
					if([instance conformsToProtocol:@protocol(QBarPlugin)]) {
						[instance installPlugin:m_domain];
						[m_qbarPlugins addObject:instance];
					}
					[instance release];
				}
			} else if([identifier rangeOfString:kLQPluginPrefixSoundSchema].location != NSNotFound) {
				Class klass = [pluginBundle principalClass];
				if(klass) {
					id instance = [[klass alloc] init];
					if([instance conformsToProtocol:@protocol(SoundSchemaPlugin)]) {
						[instance installPlugin:m_domain];
						[m_soundPlugins addObject:instance];
					}
					[instance release];
				}
			}
		}
	}
}

- (void)unloadPlugins {
	NSEnumerator* e = [m_qbarPlugins objectEnumerator];
	while(id<LQPlugin> plugin = [e nextObject]) {
		if([plugin isActivated])
			[plugin pluginDeactivated];
		[plugin uninstallPlugin:m_domain];
	}
	
	e = [m_soundPlugins objectEnumerator];
	while(id<LQPlugin> plugin = [e nextObject]) {
		if([plugin isActivated])
			[plugin pluginDeactivated];
		[plugin uninstallPlugin:m_domain];
	}
}

- (int)QBarPluginCount {
	return [m_qbarPlugins count];
}

- (id<QBarPlugin>)QBarPluginWithName:(NSString*)name {
	NSEnumerator* e = [m_qbarPlugins objectEnumerator];
	while(id<QBarPlugin> plugin = [e nextObject]) {
		if([name isEqualToString:[plugin pluginName]])
			return plugin;
	}
	
	// if not found, return first plugin or nil if no plugin at all
	if([m_qbarPlugins count] == 0)
		return nil;
	else
		return [m_qbarPlugins objectAtIndex:0];
}

- (id<QBarPlugin>)QBarPluginAtIndex:(int)index {
	if(index < 0 || index >= [self QBarPluginCount])
		return nil;
	return [m_qbarPlugins objectAtIndex:index];
}

- (NSEnumerator*)soundPluginEnumerator {
	return [m_soundPlugins objectEnumerator];
}

- (id<SoundSchemaPlugin>)soundPluginWithName:(NSString*)name {
	NSEnumerator* e = [self soundPluginEnumerator];
	while(id<SoundSchemaPlugin> plugin = [e nextObject]) {
		if([[plugin pluginName] isEqualToString:name])
			return plugin;
	}
	return nil;
}

- (id<SoundSchemaPlugin>)soundPluginAtIndex:(int)index {
	return [m_soundPlugins objectAtIndex:index];
}

@end
