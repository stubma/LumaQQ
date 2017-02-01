/*
 * LumaQQ - Cross platform QQ client, special edition for iPhone
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

#import "QQUser.h"
#import "ByteTool.h"
#import "QQConstants.h"

@implementation QQUser

- (id)initWithQQ:(int)iQQ passwordKey:(NSData*)key passwordMd5:(NSData*)md5{
	self = [super init];
	if(self) {
		m_QQ = iQQ;
		[key retain];
		[md5 retain];
		m_passwordKey = key;
		m_passwordMd5 = md5;
		m_loginTokenRandomKey = [[ByteTool randomKey] retain];
		m_selectServerRandomKey = [[ByteTool randomKey] retain];
		m_passwordVerifyRandomKey = [[ByteTool randomKey] retain];
		m_debugListeners = [[NSMutableArray array] retain];
		m_001DKeys = [[NSMutableDictionary dictionary] retain];
		m_001DTokens = [[NSMutableDictionary dictionary] retain];
		
		m_onlines = 0;
		m_info = [[ContactInfo alloc] init];
	}
	return self;
}

- (void) dealloc {
	[m_passwordKey release];
	[m_selectServerRandomKey release];
	[m_loginTokenRandomKey release];
	[m_passwordVerifyRandomKey release];
	[m_initialKey release];
	[m_sessionKey release];
	[m_fileSessionKey release];
	[m_001DKeys release];
	[m_clientKey release];
	[m_passport release];
	[m_selectedServer release];
	[m_serverToken release];
	
	[m_loginToken release];
	[m_authToken release];
	[m_001DTokens release];
	[m_info release];
	[m_passwordMd5 release];
	[m_debugListeners release];
	[super dealloc];
}

- (void)refreshSelectServerRandomKey {
	[m_selectServerRandomKey release];
	m_selectServerRandomKey = [[ByteTool randomKey] retain];
}

#pragma mark -
#pragma mark getter and setter

- (NSData*)get001DKey:(char)subCommand {
	return [m_001DKeys objectForKey:[NSNumber numberWithChar:subCommand]];
}

- (void)set001DKey:(char)subCommand key:(NSData*)key {
	[m_001DKeys setObject:key forKey:[NSNumber numberWithChar:subCommand]];
}

- (NSData*)get001DToken:(char)subCommand {
	return [m_001DTokens objectForKey:[NSNumber numberWithChar:subCommand]];
}

- (void)set001DToken:(char)subCommand token:(NSData*)token {
	[m_001DTokens setObject:token forKey:[NSNumber numberWithChar:subCommand]];
}

- (NSData*)fileAgentKey {
	return [self get001DKey:kQQSubCommandGetFileAgentKey];
}

- (NSData*)fileAgentToken {
	return [self get001DToken:kQQSubCommandGetFileAgentKey];
}

- (NSData*)passwordKey {
	return m_passwordKey;
}

- (NSData*)loginTokenRandomKey {
	return m_loginTokenRandomKey;
}

- (NSData*)selectServerRandomKey {
	return m_selectServerRandomKey;
}

- (NSData*)passwordVerifyRandomKey {
	return m_passwordVerifyRandomKey;
}

- (NSData*)initialKey {
	return m_initialKey;
}

- (void)setInitialKey:(NSData*)key {
	[key retain];
	[m_initialKey release];
	m_initialKey = key;
}

- (NSData*)sessionKey {
	return m_sessionKey;
}

- (void)setSessionKey:(NSData*)key {
	[key retain];
	[m_sessionKey release];
	m_sessionKey = key;
}

- (NSData*)fileSessionKey {
	return m_fileSessionKey;
}

- (void)setFileSessionKey:(NSData*)key {
	[key retain];
	[m_fileSessionKey release];
	m_fileSessionKey = key;
}

- (NSData*)loginToken {
	return m_loginToken;
}

- (void)setLoginToken:(NSData*)loginToken {
	[loginToken retain];
	[m_loginToken release];
	m_loginToken = loginToken;
}

- (NSData*)authToken {
	return m_authToken;
}

- (void)setAuthToken:(NSData*)authToken {
	[authToken retain];
	[m_authToken release];
	m_authToken = authToken;
}

- (NSData*)clientKey {
	return m_clientKey;
}

- (void)setClientKey:(NSData*)clientKey {
	[clientKey retain];
	[m_clientKey release];
	m_clientKey = clientKey;
}

- (NSData*)passport {
	return m_passport;
}

- (void)setPassport:(NSData*)passport {
	[passport retain];
	[m_passport release];
	m_passport = passport;
}

- (NSData*)selectedServer {
	return m_selectedServer;
}

- (void)setSelectedServer:(NSData*)selectedServer {
	[selectedServer retain];
	[m_selectedServer release];
	m_selectedServer = selectedServer;
}

- (NSData*)serverToken {
	return m_serverToken;
}

- (void)setServerToken:(NSData*)token {
	[token retain];
	[m_serverToken release];
	m_serverToken = token;
}

- (UInt32)QQ {
	return m_QQ;
}

- (BOOL)logged {
	return m_logged;
}

- (void)setLogged:(BOOL)logged {
	m_logged = logged;
}

- (char)loginStatus {
	return m_loginStatus;
}

- (void)setLoginStatus:(char)loginStatus {
	m_loginStatus = loginStatus;
}

- (char)status {
	return m_status;
}

- (void)setStatus:(char)status {
	m_status = status;
}

- (char*)ip {
	return m_ip;
}

- (void)setIp:(const char*)ip {
	memcpy(m_ip, ip, 4);
}

- (UInt16)port {
	return m_port;
}

- (void)setPort:(UInt16)port {
	m_port = port;
}

- (const char*)serverIp {
	return m_serverIp;
}

- (void)setServerIp:(const char*)ip {
	memcpy(m_serverIp, ip, 4);
}

- (UInt16)serverPort {
	return m_serverPort;
}

- (void)setServerPort:(UInt16)port {
	m_serverPort = port;
}

- (const char*)lastLoginIp {
	return m_lastLoginIp;
}

- (void)setLastLoginIp:(const char*)ip {
	memcpy(m_lastLoginIp, ip, 4);
}

- (UInt32)lastLoginTime {
	return m_lastLoginTime;
}

- (void)setLastLoginTime:(UInt32)lastLoginTime {
	m_lastLoginTime = lastLoginTime;
}

- (UInt32)loginTime {
	return m_loginTime;
}

- (void)setLoginTime:(UInt32)loginTime {
	m_loginTime = loginTime;
}

- (NSData*)passwordMd5 {
	return m_passwordMd5;
}

- (int)onlines {
	return m_onlines;
}

- (void)setOnlines:(int)onlines {
	m_onlines = onlines;
}

- (ContactInfo*)info {
	return m_info;
}

- (void)setContact:(ContactInfo*)info {
	[info retain];
	[m_info release];
	m_info = info;
}

@end
