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
#import "Property.h"

@interface POIFSFileSystem : NSObject {
	NSFileHandle* m_file;
	FileBuffer* m_buffer;
	
	int* m_bat;
	int* m_sbat;
	
	int m_batCount;
	int m_sbatStart;
	int m_sbatCount;
	int m_propStart;
	
	Property* m_root;
}

- (id)initWithPath:(NSString*)path;

- (void)load;
- (void)seekBlock:(int)block;
- (void)seekSmallBlock:(int)block;
- (int)nextBlock:(int)index;
- (int)nextSmallBlock:(int)index;
- (void)seekProperty:(int)index;
- (NSData*)getFileBytes:(Property*)property;
- (Property*)property:(NSString*)path;
- (Property*)subProperty:(NSString*)pathComponent parent:(Property*)parent;
- (int)totalSizeByPath:(NSString*)parentPath;
- (int)totalSize:(Property*)property;

@end
