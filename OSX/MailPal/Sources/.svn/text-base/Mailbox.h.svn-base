/*
 * MailPal - A Garbage Code Terminator for iPhone Mail
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


@interface Mailbox : NSObject {
	int _identifier;
	NSString* _url;
	NSString* _displayName;
	int _totalCount;
	int _unreadCount;
	int _deletedCount;
}

- (int)identifier;
- (void)setIdentifier:(int)identifier;
- (NSString*)url;
- (void)setUrl:(NSString*)url;
- (NSString*)displayName;
- (void)setDisplayName:(NSString*)displayName;
- (int)totalCount;
- (void)setTotalCount:(int)totalCount;
- (int)unreadCount;
- (void)setUnreadCount:(int)unreadCount;
- (int)deletedCount;
- (void)setDeletedCount:(int)deletedCount;

@end
