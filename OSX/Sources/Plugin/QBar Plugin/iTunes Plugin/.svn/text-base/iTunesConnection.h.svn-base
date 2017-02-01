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

#define kiTunesPlayerInfoChangedNotificationName @"com.apple.iTunes.playerInfo"
#define kUserInfoName @"Name"
#define kUserInfoAlbum @"Album"
#define kUserInfoPlayerState @"Player State"
#define kUserInfoArtist @"Artist"

#define kPlayerStatePlaying @"Playing"
#define kPlayerStatePaused @"Paused"

@interface iTunesConnection : NSObject {
	BOOL m_playing;
	NSString* m_song;
	NSString* m_album;
	NSString* m_artist;
	
	id m_delegate;
}

- (id)initWithDelegate:(id)delegate;

- (void)handlerPlayerInfoChanged:(NSNotification *)notification;

// getter and setter
- (BOOL)playing;
- (void)setPlaying:(BOOL)value;
- (NSString*)song;
- (void)setSong:(NSString*)song;
- (NSString*)album;
- (void)setAlbum:(NSString*)album;
- (NSString*)artist;
- (void)setArtist:(NSString*)artist;

@end
