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

#import "MessageHistory.h"
#import "FileTool.h"
#import "User.h"
#import "Cluster.h"
#import "Constants.h"

static NSMutableDictionary* _historys;
static UInt32 _lastQQ = 0;

@implementation MessageHistory

+ (void)initialize {
	_historys = [[NSMutableDictionary dictionary] retain];
}

+ (void)addHistory:(NSArray*)messages forModel:(id)model {
	NSMutableArray* history = [self loadHistory:model];
	NSEnumerator* e = [messages objectEnumerator];
	NSDictionary* dict = nil;
	while(dict = [e nextObject]) {
		if([dict objectForKey:kChatLogKeyQQ] != nil)
			[history addObject:dict];
	}
}

+ (void)resetForQQ:(UInt32)QQ {
	if(_lastQQ != QQ) {
		_lastQQ = QQ;
		[_historys removeAllObjects];
	}
}

+ (void)saveHistory:(id)model {
	NSArray* history = [_historys objectForKey:model];
	if(history != nil) {
		NSString* path = nil;
		if([model isMemberOfClass:[User class]])
			path = [FileTool getUserChatLogPath:model];
		else if([model isMemberOfClass:[Cluster class]])
			path = [FileTool getClusterChatLogPath:model];
		
		if(path != nil) {
			[FileTool initDirectoryForFile:path];
			[history writeToFile:path atomically:YES];
		}
	}
}

+ (NSMutableArray*)loadHistory:(id)model {
	NSMutableArray* history = [_historys objectForKey:model];
	if(history == nil) {
		NSString* path = nil;
		if([model isMemberOfClass:[User class]])
			path = [FileTool getUserChatLogPath:model];
		else if([model isMemberOfClass:[Cluster class]])
			path = [FileTool getClusterChatLogPath:model];
		
		if(path != nil && [FileTool isFileExist:path])
			history = [NSMutableArray arrayWithContentsOfFile:path];
		else
			history = [NSMutableArray array];
		[_historys setObject:history forKey:model];
	}
	return history;
}

+ (NSMutableArray*)history:(id)model {
	return [self loadHistory:model];
}

+ (void)removeFromDisk:(id)model {
	// get path
	NSString* path = nil;
	if([model isMemberOfClass:[User class]])
		path = [FileTool getUserChatLogPath:model];
	else if([model isMemberOfClass:[Cluster class]])
		path = [FileTool getClusterChatLogPath:model];
	
	// delete file
	if(path != nil && [FileTool isFileExist:path])
		[FileTool deleteFile:path];
	
	// remove from map
	[_historys removeObjectForKey:model];
}

@end
