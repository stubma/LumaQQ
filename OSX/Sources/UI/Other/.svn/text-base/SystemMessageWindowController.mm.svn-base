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

#import "SystemMessageWindowController.h"
#import "MainWindowController.h"
#import "ClusterAuthWindowController.h"
#import "UserAuthWindowController.h"
#import "SystemNotificationPacket.h"

@implementation SystemMessageWindowController

- (id)initWithMainWindow:(MainWindowController*)mainWindowController {
	self = [super initWithWindowNibName:@"SystemMessage"];
	if(self) {
		m_mainMainController = [mainWindowController retain];
		m_dataSource = [[HistoryTableDataSource alloc] initWithMainWindow:mainWindowController
																  history:[[m_mainMainController historyManager] getHistoryToday:@"10000"]];
	}
	return self;
}

- (void) dealloc {
	[m_mainMainController release];
	[m_dataSource release];
	[super dealloc];
}

- (void)windowDidLoad {
	[m_datePicker setDatePickerMode:NSSingleDateMode];
	[m_datePicker setDateValue:[NSDate date]];
	[m_historyTable setDataSource:m_dataSource];
	[m_historyTable setTarget:self];
	[m_historyTable setDoubleAction:@selector(onDoubleClick:)];
	
	[self updateDate];
	[self reload];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	[WindowRegistry unregisterSystemMessageWindow:[[m_mainMainController me] QQ]];
	[self release];
}

- (void)reload {
	[m_dataSource reload];
	[m_historyTable reloadData];
}

- (void)updateDate {
	NSDate* date = [m_datePicker dateValue];
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* comp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
										 fromDate:date];
	[m_dataSource setYear:[comp year]];
	[m_dataSource setMonth:[comp month]];
	[m_dataSource setDay:[comp day]];
}

#pragma mark -
#pragma mark actions

- (IBAction)onDateChanged:(id)sender {
	[self updateDate];
	[self reload];
}

- (IBAction)onDoubleClick:(id)sender {
	id obj = [m_dataSource objectAtIndex:[m_historyTable selectedRow]];
	if([obj isMemberOfClass:[ReceivedIMPacket class]]) {
		ClusterAuthWindowController* caw = [[ClusterAuthWindowController alloc] initWithObject:obj mainWindow:m_mainMainController];
		[caw showWindow:self];
	} else if([obj isMemberOfClass:[SystemNotificationPacket class]]) {
		UserAuthWindowController* uaw = [[UserAuthWindowController alloc] initWithObject:obj mainWindow:m_mainMainController];
		[uaw showWindow:self];
	}
}

- (IBAction)onClose:(id)sender {
	[self close];
}

@end
