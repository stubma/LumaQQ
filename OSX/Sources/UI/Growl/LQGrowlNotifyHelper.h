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

#import <Cocoa/Cocoa.h>
#import "User.h"
#import "Cluster.h"
#import "Mobile.h"
#import "ReceivedIMPacket.h"

@class MainWindowController;

@interface NSObject (LQGrowlNotifyHelper)

- (void)loginSuccess:(User*)me lastLoginTime:(UInt32)lastLoginTime loginIp:(const char*)loginIp;
- (void)kickedOut:(User*)me;
- (void)logout:(User*)me;
- (void)userOnline:(User*)user mainWindow:(MainWindowController*)main;
- (void)userOffline:(User*)user mainWindow:(MainWindowController*)main;
- (void)normalIM:(User*)user packet:(ReceivedIMPacket*)packet mainWindow:(MainWindowController*)main;
- (void)tempSessionIM:(User*)user packet:(ReceivedIMPacket*)packet mainWindow:(MainWindowController*)main;
- (void)clusterIM:(Cluster*)cluster user:(User*)user packet:(ReceivedIMPacket*)packet mainWindow:(MainWindowController*)main;
- (void)mobileIM:(Mobile*)mobile packet:(ReceivedIMPacket*)packet mainWindow:(MainWindowController*)main;
- (void)mobileIMFromUser:(User*)user packet:(ReceivedIMPacket*)packet mainWindow:(MainWindowController*)main;
- (void)systemIM:(InPacket*)packet mainWindow:(MainWindowController*)main;

@end