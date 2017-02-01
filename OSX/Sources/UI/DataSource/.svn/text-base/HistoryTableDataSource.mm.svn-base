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

#import "HistoryTableDataSource.h"
#import "MainWindowController.h"
#import "ByteTool.h"
#import "SystemNotificationPacket.h"
#import "ReceivedIMPacket.h"
#import "Constants.h"
#import "NSString-Validate.h"
#import "LocalizedStringTool.h"

@implementation HistoryTableDataSource

- (id)initWithMainWindow:(MainWindowController*)mainWindowController history:(History*)history {
	self = [super init];
	if(self) {
		m_mainMainController = [mainWindowController retain];
		m_history = [history retain];
		m_array = [[NSMutableArray array] retain];
		m_formatter = [[NSDateFormatter alloc] initWithDateFormat:@"%H:%M:%S" allowNaturalLanguage:NO];
	}
	return self;
}

- (void) dealloc {
	[m_mainMainController release];
	[m_history release];
	[m_array release];
	[m_formatter release];
	[super dealloc];
}

- (void)reload {
	[m_array release];
	m_array = [[m_history historyOfYear:m_year month:m_month day:m_day] retain];
}

- (void)setYear:(int)year {
	m_year = year;
}

- (void)setMonth:(int)month {
	m_month = month;
}

- (void)setDay:(int)day {
	m_day = day;
}

- (id)objectAtIndex:(int)index {
	return [m_array objectAtIndex:index];
}

- (History*)history {
	return m_history;
}

#pragma mark -
#pragma mark table data source

- (int)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [m_array count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
	id obj = [m_array objectAtIndex:rowIndex];
	switch([[aTableColumn identifier] intValue]) {
		case 0:
			if([obj isMemberOfClass:[ReceivedIMPacket class]]) {
				ReceivedIMPacketHeader* imHeader = [(ReceivedIMPacket*)obj imHeader];
				switch([imHeader type]) {
					case kQQIMTypeFriend:
					case kQQIMTypeFriendEx:
					case kQQIMTypeStranger:
					case kQQIMTypeStrangerEx:
					case kQQIMTypeTempSession:
						User* user = [[m_mainMainController groupManager] user:[imHeader sender]];
						if(user)
							return [user nick];
						else
							return [NSString stringWithFormat:@"%u", [imHeader sender]];
						return kStringEmpty;
					case kQQIMTypeMobileQQ:
						user = [[m_mainMainController groupManager] user:[imHeader sender]];
						if(user)
							return [user nick];
						else
							return [NSString stringWithFormat:@"%u", [imHeader sender]];
						break;
					case kQQIMTypeMobileQQ2:
						MobileIM* mobileIM = [(ReceivedIMPacket*)obj mobileIM];
						Mobile* mobile = [[m_mainMainController groupManager] mobile:[mobileIM mobile]];
						if(mobile) {
							if([mobile name] != nil && ![[mobile name] isEmpty])
								return [mobile name];
							else
								return [mobile mobile];
						} else
							return [mobileIM mobile];
						break;
					case kQQIMTypeCluster:
					case kQQIMTypeTempCluster:
					case kQQIMTypeClusterUnknown:
						user = [[m_mainMainController groupManager] user:[[(ReceivedIMPacket*)obj clusterIM] sender]];
						if(user)
							return [user nick];
						else
							return [NSString stringWithFormat:@"%u", [imHeader sender]];
						return kStringEmpty;
					default:
						return kStringEmpty;
				}
			} else if([obj isMemberOfClass:[SystemNotificationPacket class]]) {
				return @"10000";
			} else if([obj isKindOfClass:[SentIM class]]) {
				return [[m_mainMainController me] nick];
			} 
			return kStringEmpty;
		case 1:
			if([obj isKindOfClass:[InPacket class]]) {
				return [m_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[(InPacket*)obj timeReceived]]];
			} else if([obj isKindOfClass:[SentIM class]]) {
				return [m_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[(SentIM*)obj sendTime]]];
			}
			return kStringEmpty;
		case 2:
			if([obj isMemberOfClass:[ReceivedIMPacket class]]) {
				ReceivedIMPacketHeader* imHeader = [(ReceivedIMPacket*)obj imHeader];
				switch([imHeader type]) {
					case kQQIMTypeFriend:
					case kQQIMTypeFriendEx:
					case kQQIMTypeStranger:
					case kQQIMTypeStrangerEx:
						return [ByteTool getString:[[(ReceivedIMPacket*)obj normalIM] messageData]];
					case kQQIMTypeTempSession:
						return [ByteTool getString:[[(ReceivedIMPacket*)obj tempSessionIM] messageData]];
					case kQQIMTypeMobileQQ:
					case kQQIMTypeMobileQQ2:
						return [[(ReceivedIMPacket*)obj mobileIM] message];
					case kQQIMTypeCluster:
					case kQQIMTypeTempCluster:
					case kQQIMTypeClusterUnknown:
						return [ByteTool getString:[[(ReceivedIMPacket*)obj clusterIM] messageData]]; 
					case kQQIMTypeRequestJoinCluster:
					case kQQIMTypeApprovedJoinCluster:
					case kQQIMTypeRejectedJoinCluster:
					case kQQIMTypeClusterCreated:
					case kQQIMTypeClusterRoleChanged:
					case kQQIMTypeJoinedCluster:
					case kQQIMTypeExitedCluster:
						ClusterNotification* notification = [(ReceivedIMPacket*)obj clusterNotification];
						Cluster* cluster = [[m_mainMainController groupManager] clusterByExternalId:[notification externalId]];
						if(cluster)
							return SM(obj, [cluster name], [[m_mainMainController me] QQ]);
						else
							return SM(obj, nil, [[m_mainMainController me] QQ]);;
					default:
						return kStringEmpty;
				}
			} else if([obj isMemberOfClass:[SystemNotificationPacket class]]) {
				return SM(obj, nil, [(SystemNotificationPacket*)obj sourceQQ]);
			} else if([obj isKindOfClass:[SentIM class]]) {
				return [[(SentIM*)obj message] string];
			} 
			return kStringEmpty;
	}
	
	return kStringEmpty;
}

@end
