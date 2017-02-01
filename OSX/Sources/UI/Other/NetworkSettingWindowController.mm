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

#import "NetworkSettingWindowController.h"
#import "PreferenceConstants.h"
#import "AlertTool.h"
#import "Constants.h"
#import "QQConstants.h"

#define _kProtocolUDP 1
#define _kProtocolTCP 0
#define _kProxyTypeNone 0
#define _kProxyTypeHTTP 1
#define _kProxyTypeSocks5 2

@implementation NetworkSettingWindowController

- (void) dealloc {
	[m_prefMyself release];
	[m_prefGlobal release];
	[super dealloc];
}

- (void)beginSheet:(NSWindow*)docWindow forQQ:(int)iQQ {	
	// init preference
	m_prefMyself = [[PreferenceManager managerWithQQ:iQQ file:kLQFileMyself] retain];
	m_prefGlobal = [[PreferenceManager managerWithFile:kLQFileGlobal] retain];
	
	//
	// read settings
	//
	
	// protocol
	NSString* sProtocol = [m_prefMyself stringForKey:kLQLoginProtocol];
	if(sProtocol != nil) {
		if([sProtocol isEqualToString:kLQProtocolTCP])
			[m_pbProtocol selectItemAtIndex:_kProtocolTCP];
		else
			[m_pbProtocol selectItemAtIndex:_kProtocolUDP];
	} else
		[m_pbProtocol selectItemAtIndex:_kProtocolTCP];
	m_iProtocol = [m_pbProtocol indexOfSelectedItem];
	
	// fill server list
	[m_cbServer setUsesDataSource:YES];
	[m_cbServer setDataSource:self];
	[m_cbServer reloadData];
	
	// server
	NSString* sServer = [m_prefMyself stringForKey:kLQLoginServer];
	if(sServer != nil)
		[m_cbServer setStringValue:sServer];
	else
		[m_cbServer selectItemAtIndex:0];
	
	// port
	int port = [m_prefMyself integerForKey:kLQLoginPort];
	if(port == 0)
		[m_cbPort selectItemAtIndex:0];
	else {
		NSString* sPort = [NSString stringWithFormat:@"%u", port];
		[m_cbPort setStringValue:sPort];	
	}
	
	// proxy type
	NSString* sProxyType = [m_prefMyself stringForKey:kLQLoginProxyType];
	if(sProxyType != nil && [sProxyType isEqualToString:kLQProxyHTTP])
		[m_pbProxyType selectItemAtIndex:_kProxyTypeHTTP];
	else if(sProxyType != nil && [sProxyType isEqualToString:kLQProxySocks5])
		[m_pbProxyType selectItemAtIndex:_kProxyTypeSocks5];
	else
		[m_pbProxyType selectItemAtIndex:_kProxyTypeNone];
	
	// check proxy type, we can't use UDP connection with HTTP proxy
	if(m_iProtocol == _kProtocolUDP && [m_pbProxyType indexOfSelectedItem] == _kProxyTypeHTTP)
		[m_pbProxyType selectItemAtIndex:_kProxyTypeNone];
	
	// proxy server
	NSString* sProxyServer = [m_prefMyself stringForKey:kLQLoginProxyServer];
	if(sProxyServer != nil)
		[m_txtProxyServer setStringValue:sProxyServer];
	else
		[m_txtProxyServer setStringValue:kStringEmpty];

	// proxy port
	int iProxyPort = [m_prefMyself integerForKey:kLQLoginProxyPort];
	[m_txtProxyPort setStringValue:[NSString stringWithFormat:@"%d", iProxyPort]];
	
	// proxy username
	NSString* sProxyUsername = [m_prefMyself stringForKey:kLQLoginProxyUsername];
	if(sProxyUsername != nil)
		[m_txtProxyUsername setStringValue:sProxyUsername];
	else
		[m_txtProxyUsername setStringValue:kStringEmpty];
	
	// proxy password
	NSString* sProxyPassword = [m_prefMyself stringForKey:kLQLoginProxyPassword];
	if(sProxyPassword != nil)
		[m_txtProxyPassword setStringValue:sProxyPassword];
	else
		[m_txtProxyPassword setStringValue:kStringEmpty];
	
	// init control status
	[self onProxyTypeChanged:m_pbProxyType];
	if(m_iProtocol == _kProtocolUDP) {
		[m_cbPort setStringValue:@"8000"];
		[m_cbPort setEnabled:NO];
	}
	
	// open as sheet
	[NSApp beginSheet:m_winNetwork 
	   modalForWindow:docWindow
		modalDelegate:self
	   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
}

#pragma mark -
#pragma mark IBAction

- (IBAction)onOK:(id)sender {	
	// close network setting sheet
	[NSApp endSheet:m_winNetwork returnCode:YES];
	[m_winNetwork orderOut:self];
}

- (IBAction)onCancel:(id)sender {
	// close network setting sheet
	[NSApp endSheet:m_winNetwork returnCode:NO];
	[m_winNetwork orderOut:self];
}

- (IBAction)onProtocolChanged:(id)sender {
	if(m_iProtocol != [m_pbProtocol indexOfSelectedItem]) {
		m_iProtocol = [m_pbProtocol indexOfSelectedItem];
		[m_cbServer reloadData];
		[m_cbServer selectItemAtIndex:0];
		
		// check proxy type, we can't use UDP connection with HTTP proxy
		if(m_iProtocol == _kProtocolUDP) {
			if([m_pbProxyType indexOfSelectedItem] == _kProxyTypeHTTP)
				[m_pbProxyType selectItemAtIndex:_kProxyTypeNone];
			[m_cbPort setStringValue:@"8000"];
			[m_cbPort setEnabled:NO];
		} else {
			[m_cbPort setEnabled:YES];
			[m_cbPort selectItemAtIndex:0];
		}
	}
}

- (IBAction)onProxyTypeChanged:(id)sender {
	BOOL bNone = [m_pbProxyType indexOfSelectedItem] == _kProxyTypeNone;
	
	if([m_pbProxyType indexOfSelectedItem] == _kProxyTypeHTTP) {
		if(m_iProtocol != _kProtocolTCP) {
			[m_pbProtocol selectItemAtIndex:_kProtocolTCP];
			m_iProtocol = _kProtocolTCP;
			[m_cbPort setEnabled:YES];
			[m_cbPort selectItemAtIndex:0];
			[m_cbServer reloadData];
			[m_cbServer selectItemAtIndex:0];
		}
	}
	
	// set controls enablement
	[m_txtProxyServer setEnabled:!bNone];
	[m_txtProxyPort setEnabled:!bNone];
	[m_txtProxyPassword setEnabled:!bNone];
	[m_txtProxyUsername setEnabled:!bNone];
}

#pragma mark -
#pragma mark server combobox data source

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index {
	// get server array
	if(m_iProtocol == _kProtocolUDP)
		return LQUDPServers[index];
	else
		return LQTCPServers[index];
}

- (int)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	if(m_iProtocol == _kProtocolUDP)
		return kLQUDPServerCount;
	else
		return kLQTCPServerCount;
}

#pragma mark -
#pragma mark network sheet window delegate

- (void)sheetDidEnd:(NSWindow*)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	if(returnCode == YES) {
		//
		// if press ok button, save network setting
		//
		
		// protocol
		if(m_iProtocol == _kProtocolUDP) {
			[m_prefMyself setObject:kLQProtocolUDP forKey:kLQLoginProtocol];
			[m_prefMyself setInteger:kLQPortUDP forKey:kLQLoginPort];
		} else {
			[m_prefMyself setObject:kLQProtocolTCP forKey:kLQLoginProtocol];
			[m_prefMyself setInteger:kLQPortTCP forKey:kLQLoginPort];
		}			
		
		// server
		NSString* sServer = [m_cbServer stringValue];
		if(sServer != nil)
			[m_prefMyself setObject:sServer forKey:kLQLoginServer];
		
		// port
		NSString* sPort = [m_cbPort stringValue];
		if(sPort != nil && [sPort intValue] != 0)
			[m_prefMyself setInteger:[sPort intValue] forKey:kLQLoginPort];
		
		// proxy type
		switch([m_pbProxyType indexOfSelectedItem]) {
			case _kProxyTypeNone:
				[m_prefMyself setObject:kLQProxyNone forKey:kLQLoginProxyType];
				break;
			case _kProxyTypeHTTP:
				[m_prefMyself setObject:kLQProxyHTTP forKey:kLQLoginProxyType];
				break;
			case _kProxyTypeSocks5:
				[m_prefMyself setObject:kLQProxySocks5 forKey:kLQLoginProxyType];
				break;
		}
		
		// proxy server
		[m_prefMyself setObject:[m_txtProxyServer stringValue] forKey:kLQLoginProxyServer];
		
		// proxy port
		[m_prefMyself setInteger:[[m_txtProxyPort stringValue] intValue]
						forKey:kLQLoginProxyPort];
		
		// proxy username
		[m_prefMyself setObject:[m_txtProxyUsername stringValue] forKey:kLQLoginProxyUsername];
		
		// proxy password
		[m_prefMyself setObject:[m_txtProxyPassword stringValue] forKey:kLQLoginProxyPassword];
		
		// write to file
		[m_prefMyself sync];
	}
}

#pragma mark -
#pragma mark helper

- (NSArray*)fillServerList {
	NSArray* arrServers;
	if(m_iProtocol == _kProtocolUDP)
		arrServers = [m_prefGlobal arrayForKey:kLQGlobalUDPServers];
	else
		arrServers = [m_prefGlobal arrayForKey:kLQGlobalTCPServers];
	
	// if array is nil or server count is 0, init with default list
	if(arrServers == nil || [arrServers count] == 0) {
		if(m_iProtocol == _kProtocolUDP) {
			arrServers = [NSArray arrayWithObjects:(id*)LQUDPServers count:kLQUDPServerCount];
			[m_prefGlobal setObject:arrServers forKey:kLQGlobalUDPServers];
		} else {
			arrServers = [NSArray arrayWithObjects:(id*)LQTCPServers count:kLQTCPServerCount];
			[m_prefGlobal setObject:arrServers forKey:kLQGlobalTCPServers];
		}
		
		[m_prefGlobal sync];
	}
	
	return arrServers;
}

@end
