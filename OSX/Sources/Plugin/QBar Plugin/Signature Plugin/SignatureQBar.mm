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

#import "SignatureQBar.h"
#import "MainWindowController.h"
#import "SignatureOpPacket.h"
#import "NSString-Validate.h"
#import "StatusEvent.h"

@implementation SignatureQBar

- (id) init {
	self = [super init];
	if (self != nil) {
		m_activated = NO;
		m_waitingSequence = 0;
	}
	return self;
}

- (NSView*)pluginView {
	return m_view;
}

- (void)awakeFromNib {
	[m_txtSignature setStringValue:@""];
}

- (void)installPlugin:(MainWindowController*)domain {
	m_domain = [domain retain];
	[NSBundle loadNibNamed:@"SignatureQBar" owner:self];
}

- (void)uninstallPlugin:(MainWindowController*)domain {
	[m_domain release];
}

- (NSString*)pluginName {
	return @"Signature QBar";
}

- (NSString*)pluginDescription {
	return NSLocalizedStringFromTableInBundle(@"LQPluginDescription", @"SignatureQBar", [NSBundle bundleForClass:[self class]], nil);
}

- (void)pluginActivated {
	m_activated = YES;
	[[m_domain client] addStatusListener:self];
}

- (void)pluginReactivated {
	m_activated = YES;
	[[m_domain client] addStatusListener:self];
}

- (void)pluginDeactivated {
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
		case kQQEventGetSignatureOK:
			ret = [self handleGetSignatureOK:event];
			break;
		case kQQEventModifySigatureOK:
			ret = [self handleModifySignatureOK:event];
			break;
		case kQQEventDeleteSignatureOK:
			ret = [self handleDeleteSignatureOK:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleGetSignatureOK:(QQNotification*)event {
	SignatureOpReplyPacket* packet = [event object];
	if(m_waitingSequence == [packet sequence]) {
		if([[packet signatures] count] > 0) {
			NSEnumerator* e = [[packet signatures] objectEnumerator];
			while(Signature* sig = [e nextObject]) {
				if([sig QQ] == [[m_domain me] QQ]) {
					if([[sig signature] isEmpty]) {
						[m_txtSignature setTextColor:[NSColor grayColor]];
						[m_txtSignature setStringValue:NSLocalizedStringFromTableInBundle(@"LQNoSignature", @"SignatureQBar", [NSBundle bundleForClass:[self class]], nil)];
					} else {
						[m_txtSignature setTextColor:[NSColor blackColor]];
						[m_txtSignature setStringValue:[sig signature]];
					}
					break;
				}
			}
		} else {
			[m_txtSignature setTextColor:[NSColor grayColor]];
			[m_txtSignature setStringValue:NSLocalizedStringFromTableInBundle(@"LQNoSignature", @"SignatureQBar", [NSBundle bundleForClass:[self class]], nil)];
		}
	}

	return NO;
}

- (BOOL)handleModifySignatureOK:(QQNotification*)event {
	SignatureOpPacket* packet = (SignatureOpPacket*)[event outPacket];
	if([[packet user] QQ] == [[m_domain me] QQ]) {
		[m_txtSignature setTextColor:[NSColor blackColor]];
		[m_txtSignature setStringValue:[packet signature]];
	}
	return NO;
}

- (BOOL)handleDeleteSignatureOK:(QQNotification*)event {
	[m_txtSignature setTextColor:[NSColor grayColor]];
	[m_txtSignature setStringValue:NSLocalizedStringFromTableInBundle(@"LQNoSignature", @"SignatureQBar", [NSBundle bundleForClass:[self class]], nil)];
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
					m_waitingSequence = [[m_domain client] getSignatureByQQ:[[m_domain me] QQ]];
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
