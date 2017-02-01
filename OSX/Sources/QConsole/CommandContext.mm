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

#import "CommandContext.h"
#import "MainWindowController.h"

@implementation CommandContext

- (void) dealloc {
	[m_domain release];
	[m_connection release];
	[super dealloc];
}

- (Connection*)connection {
	return m_connection;
}

- (void)setConnection:(Connection*)conn {
	[conn retain];
	[m_connection release];
	m_connection = conn;
}

- (MainWindowController*)domain {
	return m_domain;
}

- (void)setDomain:(MainWindowController*)domain {
	[domain retain];
	[m_domain release];
	m_domain = domain;
}

- (QQClient*)client {
	return [m_domain client];
}

- (User*)me {
	return [m_domain me];
}

@end
