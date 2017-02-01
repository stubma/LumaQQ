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

#import "UIClusterChat.h"
#import "UIController.h"
#import "BubbleIMCell.h"
#import "Constants.h"

@implementation UIClusterChat

- (void) dealloc {
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitClusterChat;
}

- (void)refresh:(NSMutableDictionary*)data {
	[super refresh:data];
	
	if(data != nil) {
		// get cluster
		_cluster = [_data objectForKey:kDataKeyCluster];
		
		// reload messages
		[self _reloadMessages];
	}
	
	// set navigation bar title
	[[[_uiController navBar] topItem] setTitle:[_cluster name]];
}

- (UInt16)doSend:(id)obj data:(NSData*)data style:(FontStyle*)style fragmentCount:(int)fragmentCount fragmentIndex:(int)fragmentIndex {
	if([obj permanent]) {
		return [_client sendClusterIM:[obj internalId]
						  messageData:data
								style:style
						fragmentCount:fragmentCount
						fragmentIndex:fragmentIndex];
	} else {
		return [_client sendTempClusterIM:[obj internalId]
								   parent:[obj parentId] 
							  clusterType:[obj tempType]
							  messageData:data
									style:style
							fragmentCount:fragmentCount
							fragmentIndex:fragmentIndex];
	}
}

- (void)_reloadMessages {
	// add packets
	NSArray* packets = [_messageManager clusterMessages:_cluster];
	if(packets != nil && [packets count] > 0) {
		int oldCount = [_msgModels count];
		[_msgModels addObjectsFromArray:packets];
		[_messageManager removeClusterMessages:_cluster];
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
	return _cluster;
}

- (BOOL)shouldInsertPacket:(NSDictionary*)dict forCluster:(Cluster*)cluster {
	if([cluster isEqual:_cluster] && ![UIApp isSuspended]) {
		[self _appendMessage:dict];
		return NO;
	}
	return YES;
}

@end
