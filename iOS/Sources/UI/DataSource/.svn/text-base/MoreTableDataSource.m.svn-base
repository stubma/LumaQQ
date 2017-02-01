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

#import "MoreTableDataSource.h"
#import "LocalizedStringTool.h"
#import "UIMain.h"

@implementation MoreTableDataSource

- (void) dealloc {
	[_invisibleTags release];
	[super dealloc];
}

- (id)initWithMain:(UIMain*)main {
	self = [super init];
	if(self) {
		_main = main;
		_invisibleTags = [[NSMutableArray array] retain];
	}
	return self;
}

- (void)update:(UITable*)table {
	[_invisibleTags removeAllObjects];
	
	unsigned int count;
	int* buttons = (int*)malloc(sizeof(int) * 10);
	[[_main _buttonBar] getVisibleButtonTags:buttons count:&count maxItems:10];
	int i;
	for(i = kTagMyself; i <= kTagSearch; i++) {
		BOOL bFound = NO;
		int j;
		for(j = 0; j < count; j++) {
			if(buttons[j] == i) {
				bFound = YES;
				break;
			}
		}
		
		if(!bFound)
			[_invisibleTags addObject:[NSNumber numberWithInt:i]];
	}
	free(buttons);
	
	[table reloadData];
}

- (int)tagAtRow:(int)row {
	return [[_invisibleTags objectAtIndex:row] intValue];
}

- (NSString*)_tagName:(int)tag {
	switch(tag) {
		case kTagMyself:
			return L(@"Myself");
		case kTagUsers:
			return L(@"Friends");
		case kTagClusters:
			return L(@"Clusters");
		case kTagMessage:
			return L(@"Message");
		case kTagHistory:
			return L(@"History");
		case kTagCustomize:
			return L(@"Customize");
		case kTagSearch:
			return L(@"Search");
		case kTagRecent:
			return L(@"Recent");
		default:
			return @"";
	}
}

- (UIImage*)_tagIcon:(int)tag {
	switch(tag) {
		case kTagMyself:
			return [UIImage imageNamed:kImageMyselfButtonOff];
		case kTagUsers:
			return [UIImage imageNamed:kImageUserButtonOff];
		case kTagClusters:
			return [UIImage imageNamed:kImageClusterButtonOff];
		case kTagMessage:
			return [UIImage imageNamed:kImageMessageButtonOff];
		case kTagHistory:
			return [UIImage imageNamed:kImageHistoryButtonOff];
		case kTagCustomize:
			return [UIImage imageNamed:kImageCustomizeButtonOff];
		case kTagSearch:
			return [UIImage imageNamed:kImageSearchButtonOff];
		case kTagRecent:
			return [UIImage imageNamed:kImageRecentButtonOff];
		default:
			return nil;
	}
}

- (UITableCell*)table:(UITable*)table cellForRow:(int)row column:(UITableColumn*)col {
	NSNumber* tag = [_invisibleTags objectAtIndex:row];
	UIImageAndTextTableCell* cell = [[[UIImageAndTextTableCell alloc] init] autorelease];
	[cell setTitle:[self _tagName:[tag intValue]]];
	[cell setImage:[self _tagIcon:[tag intValue]]];
	[cell setShowDisclosure:YES];
	return cell;
}

- (int)numberOfRowsInTable:(UITable*)table {
	return [_invisibleTags count];
}

@end
