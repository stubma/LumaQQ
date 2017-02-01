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

#import <Cocoa/Cocoa.h>
#import "FileBuffer.h"
#import "POIFSConstants.h"

@interface Property : NSObject {
	NSString* m_name;
	int m_size;
	int m_startBlock;
	int m_type;
	int m_firstChild;
	int m_next;
	int m_previous;
	
	NSMutableArray* m_children;
}

- (void)load:(FileBuffer*)buffer;

- (NSString*)name;
- (int)size;
- (int)startBlock;
- (BOOL)isFile;
- (BOOL)isDirectory;
- (BOOL)isRoot;
- (NSArray*)children;
- (void)addChild:(Property*)child;
- (int)firstChild;
- (int)next;
- (int)previous;
- (BOOL)isUnused;
- (BOOL)isSmall;

@end
