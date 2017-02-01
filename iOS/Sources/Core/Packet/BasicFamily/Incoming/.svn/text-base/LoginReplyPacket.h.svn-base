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

#import <Foundation/Foundation.h>
#import "BasicInPacket.h"

/////// format 1 ///////
// header
// --- encrypt start (password key) ---
// reply code, 1 byte, 0x00, means ok
// session key, 16 bytes
// my qq, 4 bytes
// my ip, 4 bytes
// my port, 2 bytes
// server ip, 4 bytes
// server port, 2 bytes
// login time, 4 bytes
// unknown 30 bytes
// ip of unknown server 1, 4 bytes
// port of unknown server 1, 2 bytes
// ip of unknown server 2, 4 bytes
// port of unknown server 2, 2 bytes
// unknown 8 bytes
// client key, 32 bytes
// unknown 12 bytes
// unknown 4 bytes
// last login time, 4 bytes
// unknown time, 4 bytes
// unknown time, 4 bytes
// unknown 41 bytes
// length of unknown data, 2 bytes
// unknown data
// length of unknown data, 2 bytes
// unknown data
// --- encrypt end ---
// tail

///////////////// format 2 //////////
// header
// --------- encrypt start (password key) --------
// reply, 1 byte, 0x0A, means login redirect
// my qq, 4 bytes
// unknown 10 bytes
// ip of redirect server, 4 bytes
// --------- encrypt end ---------
// tail

///////////// format 3 ////////////
// header
// ---------- encrypt start (initial key) ---------
// reply, 1 byte, 0x09, login failed, or 0x05, server busy
// error message
// ---------- encrypt end -------
// tail

@interface LoginReplyPacket : BasicInPacket {
	UInt32 m_QQ;
	
	// for format 1
	NSData* m_sessionKey;
	char m_ip[4];
	UInt16 m_port;
	char m_serverIp[4];
	UInt16 m_serverPort;
	UInt32 m_loginTime;
	NSData* m_authToken;
	NSData* m_clientKey;
	char m_lastLoginIp[4];
	UInt32 m_lastLoginTime;
	
	// for format 2
	char m_redirectServerIp[4];
	
	// for format 3
	NSString* m_errorMessage;
}

// helper
- (BOOL)isRedirectIpNull;

// getter and setter
- (NSData*)sessionKey;
- (UInt32)QQ;
- (const char*)ip;
- (UInt16)port;
- (const char*)serverIp;
- (UInt16)serverPort;
- (UInt32)loginTime;
- (NSData*)authToken;
- (NSData*)clientKey;
- (const char*)lastLoginIp;
- (UInt32)lastLoginTime;
- (const char*)redirectServerIp;
- (NSString*)errorMessage;

@end
