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

#import "MyselfTableDataSource.h"
#import "Constants.h"
#import "LocalizedStringTool.h"
#import "QQConstants.h"
#import "NSString-Validate.h"

@implementation MyselfTableDataSource

- (void) dealloc {
	[_onlineCell release];
	[_busyCell release];
	[_muteCell release];
	[_qMeCell release];
	[_awayCell release];
	[_hiddenCell release];
	[_infoCell release];
	[super dealloc];
}

- (id) init {
	self = [super init];
	if (self != nil) {
		// create status cells
		_onlineCell = [[UIPreferencesTableCell alloc] init];
		[_onlineCell setTitle:L(@"StatusOnline")];
		[_onlineCell setImage:[UIImage imageNamed:kImageOnline]];
		_qMeCell = [[UIPreferencesTableCell alloc] init];
		[_qMeCell setTitle:L(@"StatusQMe")];
		[_qMeCell setImage:[UIImage imageNamed:kImageQMe]];
		_busyCell = [[UIPreferencesTableCell alloc] init];
		[_busyCell setTitle:L(@"StatusBusy")];
		[_busyCell setImage:[UIImage imageNamed:kImageBusy]];
		_muteCell = [[UIPreferencesTableCell alloc] init];
		[_muteCell setTitle:L(@"StatusMute")];
		[_muteCell setImage:[UIImage imageNamed:kImageMute]];
		_awayCell = [[UIPreferencesTableCell alloc] init];
		[_awayCell setTitle:L(@"StatusAway")];
		[_awayCell setImage:[UIImage imageNamed:kImageAway]];
		_hiddenCell = [[UIPreferencesTableCell alloc] init];
		[_hiddenCell setTitle:L(@"StatusHidden")];
		[_hiddenCell setImage:[UIImage imageNamed:kImageHidden]];
		
		// create status message cell
		_statusMessageCell = [[UIPreferencesTextTableCell alloc] init];
		[_statusMessageCell setTitle:L(@"StatusMessage")];
		[_statusMessageCell setEnabled:YES];
		
		// create info cell
		_infoCell = [[PushButtonTableCell alloc] initWithTitle:L(@"ViewPersonalInfo")
												   upImageName:kImageOrangeButtonUp
												 downImageName:kImageOrangeButtonDown];
		
		// create apply cell
		_applyCell = [[PushButtonTableCell alloc] initWithTitle:L(@"ApplyChange")
													upImageName:kImageGreenButtonUp
												  downImageName:kImageGreenButtonDown];
	}
	return self;
}

- (void)_checkCellAtRow:(int)row {
	if(row < 3 || row > 8)
		return;
	
	// clear check flag
	[_onlineCell setChecked:NO];
	[_qMeCell setChecked:NO];
	[_busyCell setChecked:NO];
	[_muteCell setChecked:NO];
	[_awayCell setChecked:NO];
	[_hiddenCell setChecked:NO];
	
	switch(row) {
		case 3:
			[_onlineCell setChecked:YES];
			break;
		case 4:
			[_qMeCell setChecked:YES];
			break;
		case 5:
			[_busyCell setChecked:YES];
			break;
		case 6:
			[_muteCell setChecked:YES];
			break;
		case 7:
			[_awayCell setChecked:YES];
			break;
		case 8:
			[_hiddenCell setChecked:YES];
			break;
	}
}

- (char)status {
	if([_onlineCell isChecked])
		return kQQStatusOnline;	
	else if([_qMeCell isChecked])
		return kQQStatusQMe;
	else if([_busyCell isChecked])
		return kQQStatusBusy;
	else if([_muteCell isChecked])
		return kQQStatusMute;
	else if([_awayCell isChecked])
		return kQQStatusAway;
	else if([_hiddenCell isChecked])
		return kQQStatusHidden;
	else
		return kQQStatusHidden;
}

- (NSString*)statusMessage {
	NSString* msg = [_statusMessageCell value];
	return msg == nil ? @"" : msg;
}

- (PushButtonTableCell*)infoCell {
	return _infoCell;
}

- (PushButtonTableCell*)applyCell {
	return _applyCell;
}

- (void)updateStatus:(char)status {
	// clear check flag
	[_onlineCell setChecked:NO];
	[_qMeCell setChecked:NO];
	[_busyCell setChecked:NO];
	[_muteCell setChecked:NO];
	[_awayCell setChecked:NO];
	[_hiddenCell setChecked:NO];
	
	switch(status) {
		case kQQStatusOnline:
			[_onlineCell setChecked:YES];
			break;
		case kQQStatusQMe:
			[_qMeCell setChecked:YES];
			break;
		case kQQStatusBusy:
			[_busyCell setChecked:YES];
			break;
		case kQQStatusMute:
			[_muteCell setChecked:YES];
			break;
		case kQQStatusAway:
			[_awayCell setChecked:YES];
			break;
		case kQQStatusHidden:
			[_hiddenCell setChecked:YES];
			break;
	}
}

- (void)updateStatusMessage:(NSString*)statusMessage {
	if(statusMessage != nil && ![statusMessage isEmpty]) 
		[_statusMessageCell setValue:statusMessage];
}

- (void)updateFocus:(UIPreferencesTable*)table {
	[(UIResponder*)[_statusMessageCell textField] resignFirstResponder];
	[(UIResponder*)[_infoCell control] becomeFirstResponder];
	[table setKeyboardVisible:NO];
}

-(int)numberOfGroupsInPreferencesTable:(UIPreferencesTable*)aTable {
	return 4;
}

-(int)preferencesTable:(UIPreferencesTable*)aTable numberOfRowsInGroup:(int)group {
	switch(group) {
		case 0: 
			return 1;
		case 1:
			return 6;
		case 2:
			return 1;
		case 3:
			return 1;
		default:
			return 0;
	}
}

- (id)preferencesTable:(UIPreferencesTable*)aTable titleForGroup:(int)group {
	switch(group) {
		case 1:
			return L(@"GroupChangeStatus");
	}
	return nil;
}

-(float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed {
	switch(group) {
		case 0:
			switch(row) {
				case 0:
					return 44.0;
			}
			break;
		case 3:
			switch(row) {
				case 0:
					return 44.0;
			}
			break;
	}
	return proposed;
}

-(BOOL)preferencesTable:(UIPreferencesTable*)aTable isLabelGroup:(int)group {
	return NO;
}

-(UIPreferencesTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForRow:(int)row inGroup:(int)group {
	switch(group) {
		case 0:
			switch(row) {
				case 0:
					return _infoCell;
			}
			break;
		case 1:
			switch(row) {
				case 0:
					return _onlineCell;
				case 1:
					return _qMeCell;
				case 2:
					return _busyCell;
				case 3:
					return _muteCell;
				case 4:
					return _awayCell;
				case 5:
					return _hiddenCell;
			}
			break;
		case 2:
			switch(row) {
				case 0:
					return _statusMessageCell;
			}
			break;
		case 3:
			switch(row) {
				case 0:
					return _applyCell;
			}
			break;
	}
	return nil; 
}

- (void)tableSelectionDidChange:(NSNotification*)notification {
	int row = [[notification object] selectedRow];
	[self _checkCellAtRow:row];
}

@end
