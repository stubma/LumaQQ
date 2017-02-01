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

#import "Constants.h"
#import "SearchClusterDataSource.h"
#import "ClusterInfo.h"

@implementation SearchClusterDataSource

- (id) init {
	self = [super init];
	if (self != nil) {
		m_clusters = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_clusters release];
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

// getter and setter
- (NSArray*)clusters {
	return m_clusters;
}

- (void)setClusters:(NSArray*)clusters {
	[clusters retain];
	[m_clusters release];
	m_clusters = clusters;
}

#pragma mark -
#pragma mark table data source

- (int)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [m_clusters count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
	ClusterInfo* info = [m_clusters objectAtIndex:rowIndex];
	switch([[aTableColumn identifier] intValue]) {
		case 0:
			return info;
		case 1:
			return [info name];
		case 2:
			return [NSString stringWithFormat:@"%u", [info creator]];
		default:
			return kStringEmpty;
	}
}

@end
