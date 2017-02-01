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

#import "VerifyCodeHelper.h"


@implementation VerifyCodeHelper

- (void) dealloc {
	[m_url release];
	[m_cookie release];
	[m_verifyCodeDownloader release];
	[m_filename release];
	[m_delegate release];
	[super dealloc];
}

- (id)initWithQQ:(UInt32)QQ delegate:(id)delegate {
	self = [super init];
	if(self) {
		m_QQ = QQ;
		m_delegate = [delegate retain];
	}
	return self;
}

#pragma mark -
#pragma mark API

- (void)start {
	// construct temp file name
	if(m_filename) {
		[m_filename release];
		m_filename = nil;
	}
	m_filename = [[NSString stringWithFormat:@"/tmp/%u-%ld.gif", m_QQ, (UInt64)[[NSDate date] timeIntervalSince1970]] retain];
	
	// start download
	NSURL* url = [NSURL URLWithString:m_url];
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
	if(m_cookie)
		[request setValue:m_cookie forHTTPHeaderField:@"Cookie"];
	m_verifyCodeDownloader = [[NSURLDownload alloc] initWithRequest:request delegate:self];
	[m_verifyCodeDownloader setDeletesFileUponFailure:YES];
	[m_verifyCodeDownloader setDestination:m_filename allowOverwrite:YES];
	[m_verifyCodeDownloader request];
}

- (void)cancel {
	if(m_verifyCodeDownloader != nil)
		[m_verifyCodeDownloader cancel];
}

#pragma mark -
#pragma mark getter and setter

- (NSString*)cookie {
	// m_cookie contains "getqqsession:", remove it
	if(m_cookie == nil)
		return nil;
	else {
		NSRange range = [m_cookie rangeOfString:@"getqqsession:"];
		NSString* cookieHex = [m_cookie substringFromIndex:(range.location + range.length)];
		return cookieHex;
	}
}

- (NSImage*)image {
	return m_image;
}

- (NSString*)url {
	return m_url;
}

- (void)setUrl:(NSString*)url {
	[url retain];
	[m_url release];
	m_url = url;
}

#pragma mark -
#pragma mark downloader delegate

- (void)downloadDidFinish:(NSURLDownload *)download {
	// release
	[m_verifyCodeDownloader release];
	m_verifyCodeDownloader = nil;
	
	// set verify code image
	if(m_image) {
		[m_image release];
		m_image = nil;
	}
	m_image = [[NSImage alloc] initWithContentsOfFile:m_filename];
	
	// call delegate
	if(m_delegate != nil)
		[m_delegate downloadDidFinish:download];
}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error {
	// release
	[m_verifyCodeDownloader release];
	m_verifyCodeDownloader = nil;
	
	// clear image
	if(m_image) {
		[m_image release];
		m_image = nil;
	}
	
	// call delegate
	if(m_delegate != nil)
		[m_delegate download:download didFailWithError:error];
}

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response {
	// save cookie
	if([response isMemberOfClass:[NSHTTPURLResponse class]]) {
		NSHTTPURLResponse* http = (NSHTTPURLResponse*)response;
		NSDictionary* headers = [http allHeaderFields];
		NSString* cookie = [headers objectForKey:@"Set-Cookie"];
		if(cookie) {
			[cookie retain];
			[m_cookie release];
			m_cookie = cookie;
		}
	}
	
	// call delegate
	if(m_delegate != nil)
		[m_delegate download:download didReceiveResponse:response];
}

@end
