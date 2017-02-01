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

#pragma mark -
#pragma mark status event

#define kQQClientStatusChanged 1000

#pragma mark -
#pragma mark status constant

// network is not started
#define kQQStatusNotStarted 0

// network is started
#define kQQStatusStarted 1

// logged
#define kQQStatusLoggedIn 2

// ready to speak, in QQ, means status changed successfully
#define kQQStatusReadyToSpeak 3

// logged out
#define kQQStatusLoggedOut 4

// network shutdown, same as kQQStatusNotStarted
#define kQQStatusDead 5

// before logout. In fact, it's not a normal status but it provide a chance to let listener do something before client quit
#define kQQStatusPreLogout 6

@interface StatusEvent : NSObject {
	int m_eventId;
	int m_oldStatus;
	int m_newStatus;
}

- (id)initWithId:(int)eventId oldStatus:(int)oldStatus newStatus:(int)newStatus;

	// getter and setter
- (int)eventId;
- (void)setEventId:(int)value;
- (int)oldStatus;
- (void)setOldStatus:(int)value;
- (int)newStatus;
- (void)setNewStatus:(int)value;

@end