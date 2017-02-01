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

#import "HistoryTableDataSource.h"
#import "FileTool.h"
#import "Constants.h"
#import "LocalizedStringTool.h"
#import "MessageHistory.h"

extern UInt32 gMyQQ;

@implementation HistoryTableDataSource

- (void) dealloc {
	if(_logObjects)
		[_logObjects release];
	[super dealloc];
}

- (id)initWithGroupManager:(GroupManager*)groupManager {
	self = [super init];
	if(self) {
		_groupManager = groupManager;
		_logObjects = [[NSMutableArray array] retain];
	}
	return self;
}

- (id)logObjectAtRow:(int)row {
	return [_logObjects objectAtIndex:row];
}

- (void)table:(UITable*)table deleteRow:(int)row {
	// get path
	NSString* path = nil;
	id obj = [self logObjectAtRow:row];
	[MessageHistory removeFromDisk:obj];
	
	// remove log object
	[_logObjects removeObjectAtIndex:row];
	
	// reload table
	[table reloadData];
}

- (void)deleteAll:(UITable*)table {
	NSEnumerator* e = [_logObjects objectEnumerator];
	id obj = nil;
	while(obj = [e nextObject]) {
		[MessageHistory removeFromDisk:obj];
	}
	
	// remove objects
	[_logObjects removeAllObjects];
	
	// reload table
	[table reloadData];
}

- (void)update:(UITable*)table {
	[_logObjects removeAllObjects];
	
	NSString* dir = [FileTool getChatLogDirectory];
	NSArray* files = [FileTool files:dir excludes:[NSArray arrayWithObject:kLQFileUnread]];
	NSEnumerator* e = [files objectEnumerator];
	NSString* filename = nil;
	while(filename = [e nextObject]) {
		NSRange range = [filename rangeOfString:@".lumaqqchatlog"];
		if(range.location != NSNotFound) {
			if([filename characterAtIndex:0] == 'c') {
				NSString* rawName = [filename substringWithRange:NSMakeRange(1, range.location - 1)];
				UInt32 internalId = [rawName intValue];
				Cluster* c = [_groupManager cluster:internalId];
				if(c == nil)
					c = [[[Cluster alloc] initWithInternalId:internalId] autorelease];
				[_logObjects addObject:c];
			} else {
				NSString* rawName = [filename substringToIndex:range.location];
				UInt32 qq = [rawName intValue];
				User* u = [_groupManager user:qq];
				if(u == nil)
					u = [[[User alloc] initWithQQ:qq] autorelease];
				[_logObjects addObject:u];
			}
		}
	}
	
	[table reloadData];
}

- (UITableCell*)table:(UITable*)table cellForRow:(int)row column:(UITableColumn*)col {
	id obj = [_logObjects objectAtIndex:row];
	UIImageAndTextTableCell* cell = [[[UIImageAndTextTableCell alloc] init] autorelease];
	if([obj isMemberOfClass:[User class]]) {
		[cell setTitle:[NSString stringWithFormat:L(@"ChatLogWithUser"), [obj shortDisplayName]]];
	} else if([obj isMemberOfClass:[Cluster class]]) {
		[cell setTitle:[NSString stringWithFormat:L(@"ChatLogWithCluster"), [obj displayName]]];
	}
	[cell setDisclosureStyle:kDisclosureStyleRoundArrow];
	[cell setDisclosureClickable:YES];
	return cell;
}

- (int)numberOfRowsInTable:(UITable*)table {
	return [_logObjects count];
}

@end
