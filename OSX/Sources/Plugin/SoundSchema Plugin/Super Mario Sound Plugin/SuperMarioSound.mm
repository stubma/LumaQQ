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

#import "SuperMarioSound.h"


@implementation SuperMarioSound

- (void)installPlugin:(MainWindowController*)domain {
	
}

- (void)uninstallPlugin:(MainWindowController*)domain {
	
}

- (NSString*)pluginName {
	return @"Super Mario Sound";
}

- (NSString*)pluginDescription {
	return NSLocalizedStringFromTableInBundle(@"LQPluginDescription", @"SuperMarioSound", [NSBundle bundleForClass:[self class]], nil);
}

- (void)pluginReactivated {
	
}

- (void)pluginActivated {
	
}

- (void)pluginDeactivated {
	
}

- (BOOL)isActivated {
	return YES;
}

- (NSString*)soundPath:(int)soundId {
	// get bundle
	NSBundle* bundle = [NSBundle bundleForClass:[self class]];
	
	// set sound file path
	switch(soundId) {
		case kSoundIdUserMessage:
			return [bundle pathForResource:@"user_message" ofType:@"wav"];
		case kSoundIdClusterMessage:
			return [bundle pathForResource:@"cluster_message" ofType:@"wav"];
		case kSoundIdMobileMessage:
			return [bundle pathForResource:@"user_message" ofType:@"wav"];
		case kSoundIdSystemMessage:
			return [bundle pathForResource:@"system" ofType:@"wav"];
		case kSoundIdGoodSystemMessage:
			return [bundle pathForResource:@"good_system" ofType:@"wav"];
		case kSoundIdBadSystemMessage:
			return [bundle pathForResource:@"bad_system" ofType:@"wav"];
		case kSoundIdUserOnline:
			return [bundle pathForResource:@"online" ofType:@"wav"];
		case kSoundIdLogin:
			return [bundle pathForResource:@"login" ofType:@"wav"];
		case kSoundIdLogout:
			return [bundle pathForResource:@"logout" ofType:@"wav"];
		case kSoundIdKickedOut:
			return [bundle pathForResource:@"kicked_out" ofType:@"wav"];
		case kSoundIdMessageBlocked:
			return @"";
		default:
			return @"";
	}
}

@end
