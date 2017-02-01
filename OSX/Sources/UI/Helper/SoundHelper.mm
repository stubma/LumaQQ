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

#import "SoundHelper.h"
#import "PreferenceCache.h"
#import "FileTool.h"

static SoundHelper* s_instance = nil;

@implementation SoundHelper

+ (SoundHelper*)shared {
	if(s_instance == nil)
		s_instance = [[SoundHelper alloc] init];
	return s_instance;
}

- (id) init {
	self = [super init];
	if (self != nil) {
		m_sounds = [[NSMutableArray array] retain];
		m_users = [[NSMutableArray array] retain];
		m_playing = NO;
	}
	return self;
}

- (void) dealloc {
	[m_sounds release];
	[m_users release];
	[super dealloc];
}

- (void)_playNext {
	@synchronized(self) {
		if([m_sounds count] == 0)
			m_playing = NO;
		else {
			NSString* soundKey = [[[m_sounds objectAtIndex:0] retain] autorelease];
			UInt32 QQ = [[m_users objectAtIndex:0] unsignedIntValue];
			[self _playSound:[self getSoundFile:soundKey QQ:QQ]];
		}
	}
}

- (NSString*)getSoundFile:(NSString*)soundKey QQ:(UInt32)QQ {
	// play
	PreferenceCache* cache = [PreferenceCache cache:QQ];
	if([cache isEnableSound]) {
		NSString* file = nil;
		if([soundKey isEqualToString:kLQSoundUserMessage])
			file = [cache userMessageSoundFile];
		else if([soundKey isEqualToString:kLQSoundClusterMessage])
			file = [cache clusterMessageSoundFile];
		else if([soundKey isEqualToString:kLQSoundMobileMessage])
			file = [cache mobileMessageSoundFile];
		else if([soundKey isEqualToString:kLQSoundSystemMessage])
			file = [cache systemMessageSoundFile];
		else if([soundKey isEqualToString:kLQSoundGoodSystemMessage])
			file = [cache goodSystemMessageSoundFile];
		else if([soundKey isEqualToString:kLQSoundBadSystemMessage])
			file = [cache badSystemMessageSoundFile];
		else if([soundKey isEqualToString:kLQSoundUserOnline])
			file = [cache userOnlineSoundFile];
		else if([soundKey isEqualToString:kLQSoundLogin])
			file = [cache loginSoundFile];
		else if([soundKey isEqualToString:kLQSoundLogout])
			file = [cache logoutSoundFile];
		else if([soundKey isEqualToString:kLQSoundKickedOut])
			file = [cache kickedOutSoundFile];
		else if([soundKey isEqualToString:kLQSoundMessageBlocked])
			file = [cache messageBlockedSoundFile];
		
		return file ? file : @"";
	} else
		return @"";
}

- (void)playSound:(NSString*)soundKey QQ:(UInt32)QQ {	
	@synchronized(self) {
		// check flag
		if(m_playing) {
			// check sound queue, if the sound key is same as last, don't play it
			if([m_sounds count] > 0) {
				NSString* lastSound = [m_sounds lastObject];
				if([lastSound isEqualToString:soundKey])
					return;
			}
			
			// add to queue
			[m_sounds addObject:soundKey];
			[m_users addObject:[NSNumber numberWithUnsignedInt:QQ]];
			return;
		} else
			m_playing = YES;
		
		[m_sounds addObject:soundKey];
		[m_users addObject:[NSNumber numberWithUnsignedInt:QQ]];
		[self _playSound:[self getSoundFile:soundKey QQ:QQ]];
	}
}

- (void)_playSound:(NSString*)file {
	@synchronized(self) {
		// create sound and play
		if([FileTool isFileExist:file]) {
			NSSound* sound = [[NSSound alloc] initWithContentsOfFile:file byReference:YES];
			[sound setDelegate:self];
			[sound play];
		} else {
			[m_sounds removeObjectAtIndex:0];
			[m_users removeObjectAtIndex:0];
			[self _playNext];
		}
	}
}

#pragma mark -
#pragma mark NSSound delegate

- (void)sound:(NSSound *)sound didFinishPlaying:(BOOL)aBool {
	@synchronized(self) {
		[sound autorelease];
		[m_sounds removeObjectAtIndex:0];
		[m_users removeObjectAtIndex:0];
		[self _playNext];
	}
}

@end
