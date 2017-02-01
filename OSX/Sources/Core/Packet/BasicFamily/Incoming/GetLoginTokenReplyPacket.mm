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

#import "GetLoginTokenReplyPacket.h"


@implementation GetLoginTokenReplyPacket : BasicInPacket

- (void) dealloc {
	[m_token release];
	[m_puzzleData release];
	[m_nextFragmentToken release];
	[super dealloc];
}

#pragma mark -
#pragma mark override super

- (void)parseBody:(ByteBuffer*)buf {
	m_subCommand = [buf getByte];
	[buf getUInt16];
	m_reply = [buf getByte];
	
	// puzzle token
	UInt16 length = [buf getUInt16];
	m_token = [[NSMutableData dataWithLength:length] retain];
	[buf getBytes:(NSMutableData*)m_token];
	
	switch(m_reply) {
		case kQQReplyNeedVerifyCode:
			// puzzle data
			length = [buf getUInt16];
			m_puzzleData = [[NSMutableData dataWithLength:length] retain];
			[buf getBytes:(NSMutableData*)m_puzzleData];
			
			// fragments
			m_fragmentIndex = [buf getByte] & 0xFF;
			m_nextFragmentIndex = [buf getByte] & 0xFF;
			
			// fragment token
			length = [buf getUInt16];
			m_nextFragmentToken = [[NSMutableData dataWithLength:length] retain];
			[buf getBytes:(NSMutableData*)m_nextFragmentToken];
			break;
	}
}

- (NSData*)getDecryptKey {
	return [m_user loginTokenRandomKey];
}

#pragma mark -
#pragma mark getter and setter

- (NSData*)token {
	return m_token;
}

- (void)setToken:(NSData*)token {
	[token retain];
	[m_token release];
	m_token = token;
}

- (NSData*)puzzleData {
	return m_puzzleData;
}

- (void)setPuzzleData:(NSData*)data {
	[data retain];
	[m_puzzleData release];
	m_puzzleData = data;
}

- (NSData*)nextFragmentToken {
	return m_nextFragmentToken;
}

- (void)setNextFragmentToken:(NSData*)token {
	[token retain];
	[m_nextFragmentToken release];
	m_nextFragmentToken = token;
}

- (int)fragmentIndex {
	return m_fragmentIndex;
}

- (int)nextFragmentIndex {
	return m_nextFragmentIndex;
}

- (BOOL)finished {
	return m_nextFragmentIndex == 0;
}

@end
