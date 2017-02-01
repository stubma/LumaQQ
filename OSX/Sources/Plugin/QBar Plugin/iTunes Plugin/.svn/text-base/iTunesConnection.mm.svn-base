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

#import "iTunesConnection.h"
#import "iTunesConnectionDelegate.h"

@implementation iTunesConnection

- (id)initWithDelegate:(id)delegate {
	self = [super init];
	if(self) {
		m_delegate = [delegate retain];
		
		// listener song changed
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self
															selector:@selector(handlerPlayerInfoChanged:)
																name:kiTunesPlayerInfoChangedNotificationName
															  object:nil];
	}
	
    return self;
}

- (void) dealloc {
	[m_delegate release];
	[m_song release];
	[m_album release];
	[m_artist release];
	
	// remove observer
	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self
															   name:kiTunesPlayerInfoChangedNotificationName
															 object:nil];
	[super dealloc];
}

- (void)handlerPlayerInfoChanged:(NSNotification *)notification {
	NSDictionary* dict = [notification userInfo];
	m_playing = [[dict objectForKey:kUserInfoPlayerState] isEqualToString:kPlayerStatePlaying];
	m_song = [[dict objectForKey:kUserInfoName] retain];
	m_album = [[dict objectForKey:kUserInfoAlbum] retain];
	m_artist = [[dict objectForKey:kUserInfoArtist] retain];
	
	if(m_delegate)
		[m_delegate iTunesPlayerInfoDidChanged:self];
}

#pragma mark -
#pragma mark getter and setter

- (BOOL)playing {
	return m_playing;
}

- (void)setPlaying:(BOOL)value {
	m_playing = value;
}

- (NSString*)song {
	return m_song ? m_song : @"";
}

- (void)setSong:(NSString*)song {
	[song retain];
	[m_song release];
	m_song = song;
}

- (NSString*)album {
	return m_album ? m_album : @"";
}

- (void)setAlbum:(NSString*)album {
	[album retain];
	[m_album release];
	m_album = album;
}

- (NSString*)artist {
	return m_artist ? m_artist : @"";
}

- (void)setArtist:(NSString*)artist {
	[artist retain];
	[m_artist release];
	m_artist = artist;
}

@end
