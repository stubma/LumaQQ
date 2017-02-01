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

#import "Mobile.h"
#import "Constants.h"

#define _kKeyName @"Name"
#define _kKeyMobile @"Mobile"
#define _kKeyInputBoxPortion @"InputBoxPortion"

@implementation Mobile

- (id)initWithMobile:(NSString*)mobile domain:(MainWindowController*)domain {
	self = [super init];
	if(self) {
		m_domain = [domain retain];
		[self setMobile:mobile];
		m_name = kStringEmpty;
		m_messageCount = 0;
		m_frame = 0;
		m_inputBoxProportion = 0.2;
	}
	return self;
}

- (id)initWithName:(NSString*)name mobile:(NSString*)mobile domain:(MainWindowController*)domain {
	self = [super init];
	if(self) {
		m_domain = [domain retain];
		[self setMobile:mobile];
		[self setName:name];
		m_messageCount = 0;
		m_frame = 0;
		m_inputBoxProportion = 0.2;
	}
	return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:m_name forKey:_kKeyName];
	[encoder encodeObject:m_mobile forKey:_kKeyMobile];
	[encoder encodeFloat:m_inputBoxProportion forKey:_kKeyInputBoxPortion];
}

- (id)initWithCoder:(NSCoder *)decoder {
	m_name = [[decoder decodeObjectForKey:_kKeyName] retain];
	m_mobile = [[decoder decodeObjectForKey:_kKeyMobile] retain];
	m_inputBoxProportion = [decoder decodeFloatForKey:_kKeyInputBoxPortion];
	if(m_inputBoxProportion <= 0)
		m_inputBoxProportion = 0.2;
	if(m_name == nil)
		m_name = kStringEmpty;
	if(m_mobile == nil)
		m_mobile = kStringEmpty;
	m_messageCount = 0;
	m_frame = 0;
	return self;
}

- (void) dealloc {
	[m_domain release];
	[m_name release];
	[m_mobile release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
	return [self retain];
}

- (BOOL)isEqual:(id)anObject {
	if([anObject isKindOfClass:[Mobile class]])
		return [m_mobile isEqualToString:[(Mobile*)anObject mobile]];
	else
		return NO;
}

- (void)increaseMessageCount {
	m_messageCount++;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kModelMessageCountChangedNotificationName
														object:self
													  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(m_messageCount - 1)], kUserInfoOldMessageCount, [NSNumber numberWithInt:m_messageCount], kUserInfoNewMessageCount, m_domain, kUserInfoDomain, nil]];
}

- (NSString*)name {
	return m_name;
}

- (void)setName:(NSString*)name {
	[name retain];
	[m_name release];
	m_name = name;
}

- (NSString*)mobile {
	return m_mobile;
}

- (void)setMobile:(NSString*)mobile {
	[mobile retain];
	[m_mobile release];
	m_mobile = mobile;
}

- (UInt32)messageCount {
	return m_messageCount;
}

- (void)setMessageCount:(UInt32)count {
	NSNumber* oldCount = [NSNumber numberWithInt:m_messageCount];
	m_messageCount = count;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kModelMessageCountChangedNotificationName
														object:self
													  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:oldCount, kUserInfoOldMessageCount, [NSNumber numberWithInt:count], kUserInfoNewMessageCount, m_domain, kUserInfoDomain, nil]];
}

- (int)frame {
	return m_frame;
}

- (void)setFrame:(int)frame {
	m_frame = frame;
}

- (float)inputBoxProportion {
	return m_inputBoxProportion;
}

- (void)setInputBoxProportion:(float)proportion {
	m_inputBoxProportion = proportion;
}

- (MainWindowController*)domain {
	return m_domain;
}

- (void)setDomain:(MainWindowController*)domain {
	[domain retain];
	[m_domain release];
	m_domain = domain;
}

@end
