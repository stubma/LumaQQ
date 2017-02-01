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

#import <arpa/inet.h>
#import <netdb.h>
#import "ByteTool.h"
#import "Socks5Interceptor.h"
#import "ByteBuffer.h"
#import "QQConnection.h"
#import "NSMutableData-CustomAppending.h"
#import "NSString-Validate.h"

#define _kStatusInit 0
#define _kStatusAuthenticating 1
#define _kStatusConnect 2
#define _kStatusAssociate 3
#define _kStatusReady 4

static const char _kVersion5 = 5;

static const char _kNoAuth = 0;
static const char _kBasicAuth = 2;

static const char _kReqConnect = 1;
static const char _kReqAssociate = 3;

static const char _kAddrTypeIpv4 = 1;
static const char _kAddrTypeDomainName = 3;
static const char _kAddrTypeIpv6 = 4;

static const char _kReplyOK = 0;
static const char _kReplyBasicAuth = 2;

@implementation Socks5Interceptor

- (id)initWithConnection:(QQConnection*)conn {
	self = [super init];
	if(self) {
		m_status = _kStatusInit;
		m_connection = [conn retain];
	}
	return self;
}

- (void) dealloc {
	[m_connection release];
	[super dealloc];
}

#pragma mark -
#pragma mark Interceptor protocol

- (void)kickoff {
	[self initialize];
	m_status = _kStatusInit;
}

- (BOOL)isReady {
	return m_status == _kStatusReady;
}

- (void)initialize {
	/*
	* init request
	* +----+----------+----------+
	* |VER | NMETHODS | METHODS  |
	* +----+----------+----------+
	* | 1  |    1     | 1 to 255 |
	* +----+----------+----------+
	*/
	
	// check user name
	BOOL bAuth = NO;
	if(![[m_connection proxyUsername] isEmpty] && ![[m_connection proxyPassword] isEmpty])
		bAuth = YES;
	
	// send
	NSMutableData* data = [NSMutableData data];
	[data appendByte:_kVersion5];
	[data appendByte:1];
	[data appendByte:(bAuth ? _kBasicAuth : _kNoAuth)];
	[m_connection write:data];
}

- (void)associate {
	/*
	 * establish udp connection
     * +----+-----+-------+------+----------+----------+
     * |VER | CMD |  RSV  | ATYP | DST.ADDR | DST.PORT |
     * +----+-----+-------+------+----------+----------+
     * | 1  |  1  | X'00' |  1   | Variable |    2     |
     * +----+-----+-------+------+----------+----------+
     */
	
	// check server address format
	NSData* ip = [ByteTool string2IpData:[m_connection server]];
	BOOL isIp = ip != nil;
	
	// get port
	uint16_t port = htons([[m_connection proxyPort] unsignedShortValue]);
	
	NSMutableData* data = [NSMutableData data];
	[data appendByte:_kVersion5];
	[data appendByte:_kReqAssociate];
	[data appendByte:0];
	[data appendByte:(isIp ? _kAddrTypeIpv4 : _kAddrTypeDomainName)];
	if(isIp)
		[data appendData:ip];
	else {
		[data appendByte:[[m_connection server] cStringLength]];
		[data appendBytes:[[m_connection server] cString] length:[[m_connection server] cStringLength]];
	}
	[data appendBytes:(const void*)&port length:2];
	[m_connection write:data];
}

- (void)connect {
	/*
	 * establish tcp connection
     * +----+-----+-------+------+----------+----------+
     * |VER | CMD |  RSV  | ATYP | DST.ADDR | DST.PORT |
     * +----+-----+-------+------+----------+----------+
     * | 1  |  1  | X'00' |  1   | Variable |    2     |
     * +----+-----+-------+------+----------+----------+
     */
	
	// check server address format
	NSData* ip = [ByteTool string2IpData:[m_connection server]];
	BOOL isIp = ip != nil;
	
	// get port
	uint16_t port = htons([[m_connection proxyPort] unsignedShortValue]);
	
	NSMutableData* data = [NSMutableData data];
	[data appendByte:_kVersion5];
	[data appendByte:_kReqConnect];
	[data appendByte:0];
	[data appendByte:(isIp ? _kAddrTypeIpv4 : _kAddrTypeDomainName)];
	if(isIp)
		[data appendData:ip];
	else {
		[data appendByte:[[m_connection server] cStringLength]];
		[data appendBytes:[[m_connection server] cString] length:[[m_connection server] cStringLength]];
	}
	[data appendBytes:(const void*)&port length:2];
	[m_connection write:data];
}

- (void)auth {
	/*
	 * auth request
     * +----+------+----------+------+----------+
     * |VER | ULEN |  UNAME   | PLEN |  PASSWD  |
     * +----+------+----------+------+----------+
     * | 1  |  1   | 1 to 255 |  1   | 1 to 255 |
     * +----+------+----------+------+----------+
     */
	
	NSMutableData* data = [NSMutableData data];
	[data appendByte:_kVersion5];
	[data appendByte:[[m_connection proxyUsername] cStringLength]];
	[data appendBytes:[[m_connection proxyUsername] cString] length:[[m_connection proxyUsername] cStringLength]];
	[data appendByte:[[m_connection proxyPassword] cStringLength]];
	[data appendBytes:[[m_connection proxyPassword] cString] length:[[m_connection proxyPassword] cStringLength]];
	[m_connection write:data];
}

- (void)put:(NSData*)data {
	if(m_status == _kStatusReady)
		[m_connection put:data];
	else {
		const char* bytes = (const char*)[data bytes];
		if(bytes[0] != _kVersion5) {
			[m_connection sendConnectionBrokenMessage];
		} else {
			switch(m_status) {
				case _kStatusInit:
					if(bytes[1] == _kNoAuth) {
						if([m_connection isUdp]) {
							m_status = _kStatusAssociate;
							[self associate];
						} else {
							m_status = _kStatusConnect;
							[self connect];
						}
					} else if(bytes[1] == _kBasicAuth) {
						NSLog(@"Socks5 proxy need auth");
						[self auth];
						m_status = _kStatusAuthenticating;
					} else
						[m_connection sendConnectionBrokenMessage];
					break;
				case _kStatusAuthenticating:
					if(bytes[1] == _kReplyOK) {
						NSLog(@"Socks5 proxy auth ok");
						if([m_connection isUdp]) {
							m_status = _kStatusAssociate;
							[self associate];
						} else {
							m_status = _kStatusConnect;
							[self connect];
						}					
					} else
						[m_connection sendConnectionBrokenMessage];
					break;
				case _kStatusConnect:
					if(bytes[1] == _kReplyOK) {
						NSLog(@"Socks proxy: TCP connection established");
						m_status = _kStatusReady;
						[m_connection sendConnectionEstablishMessage];
					} else
						[m_connection sendConnectionBrokenMessage];
					break;
				case _kStatusAssociate:
					if(bytes[1] == _kReplyOK) {
						// get buffer
						ByteBuffer* buf = [ByteBuffer bufferWithBytes:(char*)bytes length:[data length]];
						
						// get address type
						[buf skip:3];
						char addrType = [buf getByte];
						
						// get address data
						char* addrBytes = (char*)malloc([data length] - 6);
						[buf getBytes:addrBytes length:([data length] - 6)];
						
						// check address type
						NSString* proxy = nil;
						if(addrType == _kAddrTypeIpv4) {
							proxy = [ByteTool ip2String:addrBytes];
						} else if(addrType == _kAddrTypeDomainName) {
							proxy = [NSString stringWithCString:addrBytes length:([data length] - 6)];
						} else {
							NSLog(@"Unsupport address type");
							[m_connection sendConnectionBrokenMessage];
							break;
						}
						
						// log
						NSLog(@"bind address: %@", proxy);
						
						// get port
						UInt16 port = [buf getUInt16];
						
						// create socket address
						struct sockaddr_in addr;
						struct hostent* hostAddr;
						if ((hostAddr = gethostbyname([proxy cString])) == NULL)
							addr.sin_addr.s_addr = inet_addr((const char*)[proxy cString]);
						else {
							bzero(&addr, sizeof(addr));
							bcopy(hostAddr->h_addr, (char *)&addr.sin_addr, hostAddr->h_length);
						}
						addr.sin_len = sizeof(addr);
						addr.sin_family = AF_INET;
						addr.sin_port = htons(port);
						
						// reassociate
						if(connect([m_connection socket], (const struct sockaddr*)&addr, sizeof(addr)) < 0) {
							NSLog(@"Failed to connect to %@", proxy);
							[m_connection sendConnectionBrokenMessage];
							return;
						}
						
						// change status
						NSLog(@"Socks5 proxy: UDP connection established");
						m_status = _kStatusReady;
						
						// release
						free(addrBytes);
						
						// notify
						[m_connection sendConnectionEstablishMessage];
					} else
						[m_connection sendConnectionBrokenMessage];
					break;
			}
		}
	}
}

@end
