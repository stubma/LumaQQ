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
#import "ContactInfo.h"

@protocol DebugListener;
@class DebugEvent;

@interface QQUser : NSObject {
	// keys
	NSData* m_passwordKey;
	NSData* m_initialKey;
	NSData* m_loginTokenRandomKey;
	NSData* m_selectServerRandomKey;
	NSData* m_passwordVerifyRandomKey;
	NSData* m_sessionKey;
	NSData* m_fileSessionKey;
	NSData* m_clientKey;
	NSMutableDictionary* m_001DKeys;
	
	// tokens
	NSData* m_loginToken;
	NSData* m_authToken;
	NSData* m_passport;
	NSData* m_selectedServer;
	NSData* m_serverToken;
	NSMutableDictionary* m_001DTokens;
	
	// user property
	UInt32 m_QQ;
	char m_ip[4];
	int m_port;
	char m_serverIp[4];
	int m_serverPort;
	UInt32 m_loginTime;
	char m_lastLoginIp[4];
	UInt32 m_lastLoginTime;
	BOOL m_logged;
	char m_loginStatus;
	char m_status;
	
	// other
	NSData* m_passwordMd5;
	int m_onlines;
	ContactInfo* m_info;
	
	// for debug
	NSMutableArray* m_debugListeners;
}

// initialization
- (id)initWithQQ:(int)iQQ passwordKey:(NSData*)key passwordMd5:(NSData*)md5;

// helper
- (void)refreshSelectServerRandomKey;

// getter and setter
- (NSData*)passwordKey;
- (NSData*)loginTokenRandomKey;
- (NSData*)selectServerRandomKey;
- (NSData*)passwordVerifyRandomKey;
- (NSData*)initialKey;
- (void)setInitialKey:(NSData*)key;
- (NSData*)sessionKey;
- (void)setSessionKey:(NSData*)key;
- (NSData*)fileSessionKey;
- (void)setFileSessionKey:(NSData*)key;
- (NSData*)loginToken;
- (void)setLoginToken:(NSData*)loginToken;
- (NSData*)authToken;
- (void)setAuthToken:(NSData*)authToken;
- (NSData*)clientKey;
- (void)setClientKey:(NSData*)clientKey;
- (NSData*)passport;
- (void)setPassport:(NSData*)passport;
- (NSData*)selectedServer;
- (void)setSelectedServer:(NSData*)selectedServer;
- (NSData*)serverToken;
- (void)setServerToken:(NSData*)token;
- (NSData*)get001DKey:(char)subCommand;
- (void)set001DKey:(char)subCommand key:(NSData*)key;
- (NSData*)get001DToken:(char)subCommand;
- (void)set001DToken:(char)subCommand token:(NSData*)token;
- (NSData*)fileAgentKey;
- (NSData*)fileAgentToken;

- (UInt32)QQ;
- (BOOL)logged;
- (void)setLogged:(BOOL)logged;
- (char)loginStatus;
- (void)setLoginStatus:(char)loginStatus;
- (char)status;
- (void)setStatus:(char)status;
- (const char*)ip;
- (void)setIp:(const char*)ip;
- (UInt16)port;
- (void)setPort:(UInt16)port;
- (const char*)serverIp;
- (void)setServerIp:(const char*)ip;
- (UInt16)serverPort;
- (void)setServerPort:(UInt16)port;
- (const char*)lastLoginIp;
- (void)setLastLoginIp:(const char*)ip;
- (UInt32)lastLoginTime;
- (void)setLastLoginTime:(UInt32)lastLoginTime;
- (UInt32)loginTime;
- (void)setLoginTime:(UInt32)loginTime;

- (NSData*)passwordMd5;
- (int)onlines;
- (void)setOnlines:(int)onlines;
- (ContactInfo*)info;
- (void)setContact:(ContactInfo*)info;

- (BOOL)isDebugging;
- (void)addDebugListener:(id<DebugListener>)listener;
- (void)removeDebugListener:(id<DebugListener>)listener;
- (void)deliveryDebugEvent:(DebugEvent*)event;

@end
