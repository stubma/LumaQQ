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

#import "iTunesQBar.h"
#import "MainWindowController.h"
#import "StatusEvent.h"
#import "ChangeStatusReplyPacket.h"
#import "PreferenceCache.h"

@implementation iTunesQBar

- (id) init {
	self = [super init];
	if (self != nil) {
		m_activated = NO;
		m_waitingSequence = 0;
	}
	return self;
}

- (void) dealloc {
	[m_connection release];
	[m_authInfo release];
	if(m_oldStatusMessage)
		[m_oldStatusMessage release];
	[super dealloc];
}

#pragma mark -
#pragma mark helper

+ (BOOL)isiTunesLaunched {
	NSArray *apps = [[NSWorkspace sharedWorkspace] launchedApplications];
	NSEnumerator *appIter = [apps objectEnumerator];
	NSDictionary *appInfo;
	
	while((appInfo = [appIter nextObject]))
		if([[appInfo objectForKey:@"NSApplicationName"] isEqualToString:@"iTunes"])
			return YES;
	
	return NO;	
}

+ (NSString*)bundleString:(NSString*)key {
	return NSLocalizedStringFromTableInBundle(key, @"iTunesQBar", [NSBundle bundleForClass:[self class]], nil);
}

- (void)updateUI {
	if([m_connection playing]) {
		[m_txtSong setStringValue:[NSString stringWithFormat:[iTunesQBar bundleString:@"LQHintPlayingSong"], [m_connection song]]];
	} else {
		[m_txtSong setStringValue:[NSString stringWithFormat:[iTunesQBar bundleString:@"LQHintPausedSong"], [m_connection song]]];
	}
	
	// update song info
	[m_txtAlbum setStringValue:[NSString stringWithFormat:[iTunesQBar bundleString:@"LQHintAlbum"], [m_connection album]]];
	[m_txtArtist setStringValue:[NSString stringWithFormat:[iTunesQBar bundleString:@"LQHintArtist"], [m_connection artist]]];
}

- (void)getPlayerInfo {
	// load the script from a resource by fetching its URL from within our bundle
    NSString* path = [[NSBundle bundleForClass:[self class]] pathForResource:@"iTunes" ofType:@"scpt"];
    if (path != nil) {
        NSURL* url = [NSURL fileURLWithPath:path];
        if(url != nil) {
            NSDictionary* errors = [NSDictionary dictionary];
            NSAppleScript* appleScript = [[NSAppleScript alloc] initWithContentsOfURL:url error:&errors];
            if (appleScript != nil) {				
                // create the AppleEvent target
                ProcessSerialNumber psn = {0, kCurrentProcess};
                NSAppleEventDescriptor* target = [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber
																								bytes:&psn
																							   length:sizeof(ProcessSerialNumber)];
				
                // create an NSAppleEventDescriptor with the script's method name to call,
                // Note that the routine name must be in lower case.
                NSAppleEventDescriptor* handler = [NSAppleEventDescriptor descriptorWithString:@"get_info"];
				
                // create the event for an AppleScript subroutine
                NSAppleEventDescriptor* event = [NSAppleEventDescriptor appleEventWithEventClass:kASAppleScriptSuite
																						 eventID:kASSubroutineEvent
																				targetDescriptor:target
																						returnID:kAutoGenerateReturnID
																				   transactionID:kAnyTransactionID];
                [event setParamDescriptor:handler forKeyword:keyASSubroutineName];
				
                // call the event in AppleScript
				NSAppleEventDescriptor* ret = [appleScript executeAppleEvent:event error:&errors];
                if(ret != nil) {
					if([ret descriptorType] == typeAEList && [ret numberOfItems] == 4) {
						[m_connection setAlbum:[[ret descriptorAtIndex:1] stringValue]];
						[m_connection setArtist:[[ret descriptorAtIndex:2] stringValue]];
						[m_connection setSong:[[ret descriptorAtIndex:3] stringValue]];
						OSType state = [[ret descriptorAtIndex:4] enumCodeValue];
						[m_connection setPlaying:(state == 'kPSP')]; // kPSP is playing, kPSp is pause
					}
                }
				
                [appleScript release];
            }
        }
    }	
}

- (void)modifyStatusMessage {	
	PreferenceCache* cache = [PreferenceCache cache:[[m_domain me] QQ]];
	if([m_connection playing]) {
		[cache setStatusMessage:[self currentMessage]];
	} else {
		if(m_oldStatusMessage)
			[cache setStatusMessage:m_oldStatusMessage];
	}
	m_waitingSequence = [[m_domain client] changeStatusMessage:[cache statusMessage]];
}

- (NSString*)currentMessage {
	NSString* song = [m_connection song];
	NSString* artist = [m_connection artist];
	if([artist length] == 0)
		return [NSString stringWithFormat:@"<%@: %@>", [iTunesQBar bundleString:@"LQHintListening"], song];
	else
		return [NSString stringWithFormat:@"<%@: %@ - %@>", [iTunesQBar bundleString:@"LQHintListening"], artist, song];	
}

#pragma mark -
#pragma mark iTunes connection delegate

- (void)iTunesPlayerInfoDidChanged:(iTunesConnection*)conn {
	[self updateUI];
	[self modifyStatusMessage];
}

#pragma mark -
#pragma mark QBarPlugin protocol

- (NSView*)pluginView {
	return m_view;
}

- (void)installPlugin:(MainWindowController*)domain {
	m_domain = [domain retain];
	[NSBundle loadNibNamed:@"iTunesQBar" owner:self];
}

- (void)uninstallPlugin:(MainWindowController*)domain {
	[m_domain release];
}

- (NSString*)pluginName {
	return @"iTunes QBar";
}

- (NSString*)pluginDescription {
	return [iTunesQBar bundleString:@"LQPluginDescription"];
}

- (void)pluginReactivated {	
	m_activated = YES;
	[[m_domain client] addStatusListener:self];
}

- (void)pluginActivated {
	m_activated = YES;
	
	// save old message
	PreferenceCache* cache = [PreferenceCache cache:[[m_domain me] QQ]];
	m_oldStatusMessage = [[cache statusMessage] retain];
	
	// create iTunes connection
	m_connection = [[iTunesConnection alloc] initWithDelegate:self];
	
	// check iTunes
	if([iTunesQBar isiTunesLaunched]) {
		[self getPlayerInfo];
		[m_controlView setPlaying:[m_connection playing]];
		[self updateUI];
	} else {
		[m_txtAlbum setStringValue:[iTunesQBar bundleString:@"LQHintNoiTunes"]];
		[m_txtArtist setStringValue:@""];
		[m_txtSong setStringValue:@""];
		[m_connection setPlaying:NO];
		[m_controlView setPlaying:NO];
	}
	
	// add status listener
	[[m_domain client] addStatusListener:self];
}

- (void)pluginDeactivated {
	// set playing to no and change signature
	if([m_connection playing]) {
		[m_connection setPlaying:NO];
		[self modifyStatusMessage];
	}
	
	// release connection
	[m_connection release];
	m_connection = nil;
	
	// remove status listener
	[[m_domain client] removeStatusListener:self];
	
	m_activated = NO;
}

- (BOOL)isActivated {
	return m_activated;
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventChangeStatusOK:
			ret = [self handleModifyStatusMessageOK:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleModifyStatusMessageOK:(QQNotification*)event {
	ChangeStatusReplyPacket* packet = (ChangeStatusReplyPacket*)[event object];
	if([packet sequence] == m_waitingSequence)  {
		return YES;
	}		
	return NO;
}

#pragma mark -
#pragma mark status listener

- (BOOL)handleStatusEvent:(StatusEvent*)event {
	switch([event eventId]) {
		case kQQClientStatusChanged:
			switch([event newStatus]) {
				case kQQStatusReadyToSpeak:
					[[m_domain client] addQQListener:self];
					[self modifyStatusMessage];
					break;
				case kQQStatusPreLogout:
					[m_connection setPlaying:NO];
					[self modifyStatusMessage];
					break;
				case kQQStatusDead:
					[[m_domain client] removeQQListener:self];
					[[m_domain client] removeStatusListener:self];
					break;
				default:
					[[m_domain client] removeQQListener:self];
					break;
			}			
			break;
	}
	return NO;
}

@end

