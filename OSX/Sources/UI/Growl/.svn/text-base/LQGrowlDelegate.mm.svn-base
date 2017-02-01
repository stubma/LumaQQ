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

#import "LQGrowlDelegate.h"
#import "Constants.h"
#import "LocalizedStringTool.h"
#import "ByteTool.h"
#import "MainWindowController.h"

static int s_contextId = 0;

@implementation LQGrowlDelegate

- (id) init {
	self = [super init];
	if (self != nil) {
		m_contexts = [[NSMutableDictionary dictionary] retain];
	}
	return self;
}

- (void) dealloc {
	[m_contexts release];
	[super dealloc];
}

- (void)setup {
	NSBundle* bundle = [NSBundle mainBundle];
	NSString* growlPath = [[bundle privateFrameworksPath] stringByAppendingPathComponent:@"Growl.framework"];
	NSBundle* growlBundle = [NSBundle bundleWithPath:growlPath];
	if (growlBundle && [growlBundle load]) {
		// Register ourselves as a Growl delegate
		[GrowlApplicationBridge setGrowlDelegate:self];
	} else {
		NSLog(@"Could not load Growl.framework");
	}
}

#pragma mark -
#pragma mark growl delegate

- (NSDictionary *) registrationDictionaryForGrowl {
	NSArray* notifications = [NSArray arrayWithObjects:L(@"LQNotificationUserOnline", @"Growl"),
		L(@"LQNotificationUserOffline", @"Growl"),
		L(@"LQNotificationUserMessage", @"Growl"),
		L(@"LQNotificationClusterMessage", @"Growl"),
		L(@"LQNotificationSystemMessage", @"Growl"),
		L(@"LQNotificationMobileMessage", @"Growl"),
		L(@"LQNotificationLogin", @"Growl"),
		L(@"LQNotificationLogout", @"Growl"),
		nil];
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	[dict setObject:notifications forKey:GROWL_NOTIFICATIONS_ALL];
	[dict setObject:notifications forKey:GROWL_NOTIFICATIONS_DEFAULT];
	return dict;
}

- (NSString *) applicationNameForGrowl {
	return @"LumaQQ";
}

- (void) growlIsReady {
}

- (void) growlNotificationWasClicked:(id)clickContext {
	NSWindowController* winController = nil;
	
	// get context
	NSDictionary* context = [[[m_contexts objectForKey:clickContext] retain] autorelease];
	[m_contexts removeObjectForKey:clickContext];
	
	// get notification name
	NSString* notify = [context objectForKey:kContextNotificationName];
	if([notify isEqualToString:L(@"LQNotificationUserOnline", @"Growl")]) {
		MainWindowController* main = [context objectForKey:kContextMainWindow];
		User* user = [context objectForKey:kContextUser];
		if([[main messageQueue] getUserMessage:[user QQ] remove:NO] != nil)
			[main onExtractMessage:self];
		else
			winController = [[main windowRegistry] showNormalIMWindowOrTab:user mainWindow:main];
	} else if([notify isEqualToString:L(@"LQNotificationSystemMessage", @"Growl")]) {
		MainWindowController* main = [context objectForKey:kContextMainWindow];
		InPacket* packet = [context objectForKey:kContextPacket];
		[[main messageQueue] moveToTop:packet];
		[main onExtractMessage:self];
	} else if([notify isEqualToString:L(@"LQNotificationClusterMessage", @"Growl")]) {
		MainWindowController* main = [context objectForKey:kContextMainWindow];
		Cluster* cluster = [context objectForKey:kContextCluster];
		[[main messageQueue] moveFirstClusterMessageToFront:[cluster internalId]];
		[main onExtractMessage:self];
	} else if([notify isEqualToString:L(@"LQNotificationMobileMessage", @"Growl")]) {
		MainWindowController* main = [context objectForKey:kContextMainWindow];
		User* user = [context objectForKey:kContextUser];
		Mobile* mobile = [context objectForKey:kContextMobile];
		if(user) {
			[[main messageQueue] moveFirstMobileMessageToFront:[user QQ]];
			[main onExtractMessage:self];
		} else if(mobile) {
			[[main messageQueue] moveFristMobileMessageToFrontByMobile:[mobile mobile]];
			[main onExtractMessage:self];
		}
	} else if([notify isEqualToString:L(@"LQNotificationUserMessage", @"Growl")]) {
		MainWindowController* main = [context objectForKey:kContextMainWindow];
		User* user = [context objectForKey:kContextUser];
		[[main messageQueue] moveFirstUserMessageToFront:[user QQ]];
		[main onExtractMessage:self];
	}
	
	// activate im window
	if(winController) {
		[NSApp activateIgnoringOtherApps:YES];
		[[winController window] orderFront:self];
		[[winController window] makeKeyWindow];		
	}
}

- (void) growlNotificationTimedOut:(id)clickContext {
	[m_contexts removeObjectForKey:clickContext];
}

- (NSData*)_iconData:(User*)user {
	return [[NSImage imageNamed:([user isMM] ? kImageQQMMOnline : kImageQQGGOnline)] TIFFRepresentation];
}

#pragma mark -
#pragma mark LQGrowlNotifyHelper

- (void)loginSuccess:(User*)me lastLoginTime:(UInt32)lastLoginTime loginIp:(const char*)loginIp {
	NSDateFormatter* df = [[NSDateFormatter alloc] initWithDateFormat:@"%Y-%m-%d %H:%M:%S" allowNaturalLanguage:NO];
	NSString* dateString = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:lastLoginTime]];
	[df release];
	
	[GrowlApplicationBridge notifyWithTitle:[NSString stringWithFormat:L(@"LQTitleLoginSuccess", @"Growl"), [me QQ]]
								description:[NSString stringWithFormat:L(@"LQDescLoginSuccess", @"Growl"), dateString, [ByteTool ip2String:loginIp]]
						   notificationName:L(@"LQNotificationLogin", @"Growl")
								   iconData:[self _iconData:me]
								   priority:0
								   isSticky:NO
							   clickContext:nil];
}

- (void)kickedOut:(User*)me {
	[GrowlApplicationBridge notifyWithTitle:[NSString stringWithFormat:L(@"LQTitleKickedOut", @"Growl"), [me QQ]]
								description:L(@"LQDescKickedOut", @"Growl")
						   notificationName:L(@"LQNotificationLogout", @"Growl")
								   iconData:[self _iconData:me]
								   priority:0
								   isSticky:NO
							   clickContext:nil];
}

- (void)logout:(User*)me {
	[GrowlApplicationBridge notifyWithTitle:[NSString stringWithFormat:L(@"LQTitleLogout", @"Growl"), [me QQ]]
								description:L(@"LQDescLogout", @"Growl")
						   notificationName:L(@"LQNotificationLogout", @"Growl")
								   iconData:[self _iconData:me]
								   priority:0
								   isSticky:NO
							   clickContext:nil];
}

- (void)userOffline:(User*)user mainWindow:(MainWindowController*)main {
	[GrowlApplicationBridge notifyWithTitle:[NSString stringWithFormat:L(@"LQTitleUserOffline", @"Growl"), [user remarkOrNickOrQQ]]
								description:[NSString stringWithFormat:L(@"LQDescUserOffline", @"Growl"), [user remarkOrNickOrQQ]]
						   notificationName:L(@"LQNotificationUserOffline", @"Growl")
								   iconData:[self _iconData:[main me]]
								   priority:0
								   isSticky:NO
							   clickContext:nil];
}

- (void)userOnline:(User*)user mainWindow:(MainWindowController*)main {
	// put context
	NSNumber* contextId = [NSNumber numberWithInt:s_contextId++];
	NSDictionary* context = [NSDictionary dictionaryWithObjectsAndKeys:main, kContextMainWindow, 
		user, kContextUser, 
		L(@"LQNotificationUserOnline", @"Growl"), kContextNotificationName, nil];
	[m_contexts setObject:context forKey:contextId];
	
	[GrowlApplicationBridge notifyWithTitle:[NSString stringWithFormat:L(@"LQTitleUserOnline", @"Growl"), [user remarkOrNickOrQQ]]
								description:[NSString stringWithFormat:L(@"LQDescUserOnline", @"Growl"), [user remarkOrNickOrQQ]]
						   notificationName:L(@"LQNotificationUserOnline", @"Growl")
								   iconData:[self _iconData:[main me]]
								   priority:0
								   isSticky:NO
							   clickContext:contextId];
}

- (void)normalIM:(User*)user packet:(ReceivedIMPacket*)packet mainWindow:(MainWindowController*)main {
	// put context
	NSNumber* contextId = [NSNumber numberWithInt:s_contextId++];
	NSDictionary* context = [NSDictionary dictionaryWithObjectsAndKeys:main, kContextMainWindow,
		user, kContextUser, 
		packet, kContextPacket,
		L(@"LQNotificationUserMessage", @"Growl"), kContextNotificationName, nil];
	[m_contexts setObject:context forKey:contextId];
	
	[GrowlApplicationBridge notifyWithTitle:[NSString stringWithFormat:L(@"LQTitleNormalIM", @"Growl"), [user remarkOrNickOrQQ]]
								description:[ByteTool getString:[[packet normalIM] messageData]]
						   notificationName:L(@"LQNotificationUserMessage", @"Growl")
								   iconData:[self _iconData:[main me]]
								   priority:0
								   isSticky:NO
							   clickContext:contextId];
}

- (void)tempSessionIM:(User*)user packet:(ReceivedIMPacket*)packet mainWindow:(MainWindowController*)main {
	// put context
	NSNumber* contextId = [NSNumber numberWithInt:s_contextId++];
	NSDictionary* context = [NSDictionary dictionaryWithObjectsAndKeys:main, kContextMainWindow,
		user, kContextUser, 
		packet, kContextPacket,
		L(@"LQNotificationUserMessage", @"Growl"), kContextNotificationName, nil];
	[m_contexts setObject:context forKey:contextId];
	
	[GrowlApplicationBridge notifyWithTitle:[NSString stringWithFormat:L(@"LQTitleTempSessionIM", @"Growl"), [user remarkOrNickOrQQ]]
								description:[ByteTool getString:[[packet tempSessionIM] messageData]]
						   notificationName:L(@"LQNotificationUserMessage", @"Growl")
								   iconData:[self _iconData:[main me]]
								   priority:0
								   isSticky:NO
							   clickContext:contextId];
}

- (void)clusterIM:(Cluster*)cluster user:(User*)user packet:(ReceivedIMPacket*)packet mainWindow:(MainWindowController*)main {
	// put context
	NSNumber* contextId = [NSNumber numberWithInt:s_contextId++];
	NSDictionary* context = [NSDictionary dictionaryWithObjectsAndKeys:main, kContextMainWindow, 
		user, kContextUser, 
		cluster, kContextCluster,
		packet, kContextPacket,
		L(@"LQNotificationClusterMessage", @"Growl"), kContextNotificationName, 
		nil];
	[m_contexts setObject:context forKey:contextId];
	
	NSString* title = nil;
	if([cluster permanent])
		title = [NSString stringWithFormat:L(@"LQTitleClusterIM", @"Growl"), [user remarkOrNickOrQQ], [cluster name]];
	else if([cluster isSubject])
		title = [NSString stringWithFormat:L(@"LQTitleSubjectIM", @"Growl"), [user remarkOrNickOrQQ], [cluster name]];
	else if([cluster isDialog])
		title = [NSString stringWithFormat:L(@"LQTitleDialogIM", @"Growl"), [user remarkOrNickOrQQ], [cluster name]];
	
	if(title == nil)
		return;
			
	[GrowlApplicationBridge notifyWithTitle:title
								description:[ByteTool getString:[[packet clusterIM] messageData]]
						   notificationName:L(@"LQNotificationClusterMessage", @"Growl")
								   iconData:[self _iconData:[main me]]
								   priority:0
								   isSticky:NO
							   clickContext:contextId];
}

- (void)mobileIM:(Mobile*)mobile packet:(ReceivedIMPacket*)packet mainWindow:(MainWindowController*)main {
	// put context
	NSNumber* contextId = [NSNumber numberWithInt:s_contextId++];
	NSDictionary* context = [NSDictionary dictionaryWithObjectsAndKeys:main, kContextMainWindow, 
		mobile, kContextMobile,
		packet, kContextPacket,
		L(@"LQNotificationMobileMessage", @"Growl"), kContextNotificationName, 
		nil];
	[m_contexts setObject:context forKey:contextId];
	
	[GrowlApplicationBridge notifyWithTitle:[NSString stringWithFormat:L(@"LQTitleMobileIM", @"Growl"), [mobile name]]
								description:[[packet mobileIM] message]
						   notificationName:L(@"LQNotificationMobileMessage", @"Growl")
								   iconData:[self _iconData:[main me]]
								   priority:0
								   isSticky:NO
							   clickContext:contextId];
}

- (void)mobileIMFromUser:(User*)user packet:(ReceivedIMPacket*)packet mainWindow:(MainWindowController*)main {
	// put context
	NSNumber* contextId = [NSNumber numberWithInt:s_contextId++];
	NSDictionary* context = [NSDictionary dictionaryWithObjectsAndKeys:main, kContextMainWindow, 
		user, kContextUser,
		packet, kContextPacket,
		L(@"LQNotificationMobileMessage", @"Growl"), kContextNotificationName, 
		nil];
	[m_contexts setObject:context forKey:contextId];
	
	[GrowlApplicationBridge notifyWithTitle:[NSString stringWithFormat:L(@"LQTitleMobileIMFromUser", @"Growl"), [user remarkOrNickOrQQ]]
								description:[[packet mobileIM] message]
						   notificationName:L(@"LQNotificationMobileMessage", @"Growl")
								   iconData:[self _iconData:[main me]]
								   priority:0
								   isSticky:NO
							   clickContext:contextId];
}

- (void)systemIM:(InPacket*)packet mainWindow:(MainWindowController*)main {
	// put context
	NSNumber* contextId = [NSNumber numberWithInt:s_contextId++];
	NSDictionary* context = [NSDictionary dictionaryWithObjectsAndKeys:main, kContextMainWindow, 
		packet, kContextPacket,
		L(@"LQNotificationSystemMessage", @"Growl"), kContextNotificationName, 
		nil];
	[m_contexts setObject:context forKey:contextId];
	
	// get description
	NSString* desc = nil;
	if([packet isMemberOfClass:[ReceivedIMPacket class]]) {
		ReceivedIMPacketHeader* imHeader = [(ReceivedIMPacket*)packet imHeader];
		switch([imHeader type]) {
			case kQQIMTypeRequestJoinCluster:
			case kQQIMTypeApprovedJoinCluster:
			case kQQIMTypeRejectedJoinCluster:
			case kQQIMTypeClusterCreated:
			case kQQIMTypeClusterRoleChanged:
			case kQQIMTypeJoinedCluster:
			case kQQIMTypeExitedCluster:
				ClusterNotification* notification = [(ReceivedIMPacket*)packet clusterNotification];
				Cluster* cluster = [[main groupManager] clusterByExternalId:[notification externalId]];
				if(cluster)
					desc = SM(packet, [cluster name], [[main me] QQ]);
				else
					desc = SM(packet, nil, [[main me] QQ]);;
				break;
		}
	} else if([packet isMemberOfClass:[SystemNotificationPacket class]]) {
		desc = SM(packet, nil, [(SystemNotificationPacket*)packet sourceQQ]);
	} 
	
	// check nil
	if(desc == nil)
		return;
	
	// notify
	[GrowlApplicationBridge notifyWithTitle:L(@"LQTitleSystemIM", @"Growl")
								description:desc
						   notificationName:L(@"LQNotificationSystemMessage", @"Growl")
								   iconData:[[NSImage imageNamed:kImageSound] TIFFRepresentation]
								   priority:0
								   isSticky:NO
							   clickContext:contextId];
}

@end
