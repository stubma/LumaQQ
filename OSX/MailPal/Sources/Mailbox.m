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

#import "Mailbox.h"
#import "Constants.h"
#import "LocalizedStringTool.h"

@implementation Mailbox

- (void) dealloc {
	[_url release];
	[_displayName release];
	[super dealloc];
}

- (int)identifier {
	return _identifier;
}

- (void)setIdentifier:(int)identifier {
	_identifier = identifier;
}

- (NSString*)url {
	return _url;
}

- (void)setUrl:(NSString*)url {
	[url retain];
	[_url release];
	_url = url;
}

- (NSString*)displayName {
	return _displayName;
}

- (void)setDisplayName:(NSString*)displayName {
	[displayName retain];
	[_displayName release];
	_displayName = displayName;
}

- (int)totalCount {
	return _totalCount;
}

- (void)setTotalCount:(int)totalCount {
	_totalCount = totalCount;
}
		
- (int)unreadCount {
	return _unreadCount;
}

- (void)setUnreadCount:(int)unreadCount {
	_unreadCount = unreadCount;
}

- (int)deletedCount {
	return _deletedCount;
}
		
- (void)setDeletedCount:(int)deletedCount {
	_deletedCount = deletedCount;	
}
		
@end
