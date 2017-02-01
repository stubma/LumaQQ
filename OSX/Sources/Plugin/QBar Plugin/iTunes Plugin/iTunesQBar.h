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
#import "QBarPlugin.h"
#import "QQListener.h"
#import "StatusListener.h"
#import "iTunesConnection.h"
#import "iTunesControlView.h"

@interface iTunesQBar : NSObject <QBarPlugin, QQListener, StatusListener> {
	IBOutlet NSView* m_view;
	IBOutlet NSTextField* m_txtAlbum;
	IBOutlet NSTextField* m_txtArtist;
	IBOutlet NSTextField* m_txtSong;
	IBOutlet iTunesControlView* m_controlView;
	
	BOOL m_activated;
	MainWindowController* m_domain;
	iTunesConnection* m_connection;
	UInt16 m_waitingSequence;
	NSData* m_authInfo;
	NSString* m_oldStatusMessage;
}

// helper
+ (BOOL)isiTunesLaunched;
+ (NSString*)bundleString:(NSString*)key;
- (void)updateUI;
- (void)getPlayerInfo;
- (void)modifyStatusMessage;
- (NSString*)currentMessage;

// qq event handler
- (BOOL)handleModifyStatusMessageOK:(QQNotification*)event;

@end
