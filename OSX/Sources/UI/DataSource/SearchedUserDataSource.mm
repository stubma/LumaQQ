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
#import "SearchedUserDataSource.h"
#import "AdvancedSearchedUser.h"
#import "SearchedUser.h"
#import "LocalizedStringTool.h"

@implementation SearchedUserDataSource

- (id) init {
	self = [super init];
	if (self != nil) {
		m_users = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_users release];
	[super dealloc];
}

#pragma mark -
#pragma mark getter and setter

- (NSArray*)users {
	return m_users;
}

- (void)setUsers:(NSArray*)users {
	[users retain];
	[m_users release];
	m_users = users;
}

#pragma mark -
#pragma mark table data source

- (int)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [m_users count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
	id object = [m_users objectAtIndex:rowIndex];
	switch([[aTableColumn identifier] intValue]) {
		case 0:
			return object;
		case 1:
			return [object nick];
		case 2:
			if([object isMemberOfClass:[SearchedUser class]])
				return kStringEmpty;
			else {
				UInt8 genderIndex = [(AdvancedSearchedUser*)object genderIndex];
				return GENDER(genderIndex);
			}
			break;
		case 3:
			if([object isMemberOfClass:[SearchedUser class]])
				return kStringEmpty;
			else
				return [NSString stringWithFormat:@"%u", [(AdvancedSearchedUser*)object age]];
			break;
		case 4:
			if([object isMemberOfClass:[SearchedUser class]])
				return [(SearchedUser*)object province];
			else {
				UInt16 provinceIndex = [(AdvancedSearchedUser*)object provinceIndex];
				UInt16 cityIndex = [(AdvancedSearchedUser*)object cityIndex];
				return [NSString stringWithFormat:@"%@ %@", PROVINCE(provinceIndex), CITY(provinceIndex, cityIndex)];
			}
			break;
		case 5:
			if([object isMemberOfClass:[SearchedUser class]])
				return kStringEmpty;
			else
				return [(AdvancedSearchedUser*)object online] ? L(@"LQOnline") : L(@"LQOffline");
			break;
		default:
			return kStringEmpty;
	}
}

@end
