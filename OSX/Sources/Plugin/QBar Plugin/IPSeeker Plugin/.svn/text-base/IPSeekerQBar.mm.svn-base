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

#import "IPSeekerQBar.h"
#import "IPSeeker.h"
#import "ByteTool.h"

@implementation IPSeekerQBar

- (id) init {
	self = [super init];
	if (self != nil) {
		m_activated = NO;
	}
	return self;
}

- (void)awakeFromNib {
	[m_txtIp setTarget:self];
	[m_txtIp setAction:@selector(onSearch:)];
	[m_txtLocation setStringValue:@""];
}

- (NSView*)pluginView {
	return m_view;
}

- (void)installPlugin:(MainWindowController*)domain {
	[NSBundle loadNibNamed:@"IPSeekerQBar" owner:self];
}

- (void)uninstallPlugin:(MainWindowController*)domain {
}

- (NSString*)pluginName {
	return @"IPSeeker QBar";
}

- (NSString*)pluginDescription {
	return NSLocalizedStringFromTableInBundle(@"LQPluginDescription", @"IPSeekerQBar", [NSBundle bundleForClass:[self class]], nil);
}

- (void)pluginActivated {
	m_activated = YES;
}

- (void)pluginReactivated {
	m_activated = YES;
}

- (void)pluginDeactivated {
	m_activated = NO;
}

- (BOOL)isActivated {
	return m_activated;
}

- (IBAction)onSearch:(id)sender {
	NSData* ipData = [ByteTool string2IpData:[m_txtIp stringValue]];
	if(ipData) {
		NSString* loc = [[IPSeeker shared] getLocation:(const char*)[ipData bytes] locationOnly:YES];
		if(loc)
			[m_txtLocation setStringValue:loc];
	} else {
		[m_txtLocation setStringValue:NSLocalizedStringFromTableInBundle(@"LQHintErrorIP", @"IPSeekerQBar", [NSBundle bundleForClass:[self class]], nil)];
	}
}

@end
