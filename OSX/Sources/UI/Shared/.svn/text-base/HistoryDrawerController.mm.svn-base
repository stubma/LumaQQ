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

#import "HistoryDrawerController.h"
#import "MainWindowController.h"
#import "Constants.h"

@implementation HistoryDrawerController

- (id)initWithMainWindow:(MainWindowController*)mainWindowController history:(History*)history {
	self = [super init];
	if(self) {
		m_dataSource = [[HistoryTableDataSource alloc] initWithMainWindow:mainWindowController history:history];
	}
	return self;
}

- (void) dealloc {
	[m_dataSource release];
	[super dealloc];
}

- (void)awakeFromNib {
	[m_datePicker setDatePickerMode:NSSingleDateMode];
	[m_datePicker setDateValue:[NSDate date]];
	[m_historyTable setDataSource:m_dataSource];
	[m_historyTable setTarget:self];
	[m_historyTable setDoubleAction:@selector(onDoubleClick:)];
	[self updateDate];
}

#pragma mark -
#pragma mark API

- (void)reload {
	[m_dataSource reload];
	[m_historyTable reloadData];
}

#pragma mark -
#pragma mark actions

- (IBAction)onDateChanged:(id)sender {
	[self updateDate];
	[self reload];
}

- (IBAction)onDoubleClick:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:kHistoryDidSelectedNotificationName
														object:[m_dataSource objectAtIndex:[m_historyTable selectedRow]]
													  userInfo:[NSDictionary dictionaryWithObject:[m_dataSource history] forKey:kUserInfoHistory]];
}

#pragma mark -
#pragma mark helper

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
#pragma mark getter and setter

- (NSDrawer*)drawer {
	return m_drawer;
}

- (NSDatePicker*)datePicker {
	return m_datePicker;
}

#pragma mark -
#pragma mark drawer delegate

- (void)drawerWillOpen:(NSNotification *)notification {
	[self reload];
}

@end
