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

#import "UIUserChat.h"
#import "BubbleIMCell.h"
#import "Constants.h"
#import "UIController.h"

@implementation UIUserChat

- (void) dealloc {
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitUserChat;
}

- (void)refresh:(NSMutableDictionary*)data {
	[super refresh:data];
	
	if(data != nil) {
		// get user
		_user = [_data objectForKey:kDataKeyUser];
		
		// reload messages
		[self _reloadMessages];
	}
	
	// set navigation bar title
	[[[_uiController navBar] topItem] setTitle:[_user shortDisplayName]];
}

- (UInt16)doSend:(id)obj data:(NSData*)data style:(FontStyle*)style fragmentCount:(int)fragmentCount fragmentIndex:(int)fragmentIndex {
	return [_client sendIM:[obj QQ]
			   messageData:data
					 style:style
			 fragmentCount:fragmentCount
			 fragmentIndex:fragmentIndex];
}

- (void)_reloadMessages {
	// add packets
	NSArray* packets = [_messageManager userMessages:_user];
	if(packets != nil && [packets count] > 0) {
		int oldCount = [_msgModels count];
		[_msgModels addObjectsFromArray:packets];
		[_messageManager removeUserMessages:_user];
		int newCount = [_msgModels count];
		
		// create cells
		for(; oldCount < newCount; oldCount++) {
			NSDictionary* prop = [_msgModels objectAtIndex:oldCount];
			BubbleIMCell* cell = [[[BubbleIMCell alloc] init] autorelease];
			[cell setGroupManager:_groupManager];
			[cell setProperties:prop];
			[_cells addObject:cell];
		}
	}
	
	// reload table
	[_table reloadData];
	[_table scrollRowToVisible:([_table numberOfRows] - 1)];
}

- (id)_model {
	return _user;
}

- (BOOL)shouldInsertPacket:(NSDictionary*)dict forUser:(User*)user {
	if([user isEqual:_user] && ![UIApp isSuspended]) {
		[self _appendMessage:dict];
		return NO;
	}
	return YES;
}

@end
