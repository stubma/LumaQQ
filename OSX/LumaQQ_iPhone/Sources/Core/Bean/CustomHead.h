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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 0 2111-1307 USA
 */

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface CustomHead : NSObject <NSCoding> {
	UInt32 m_QQ;
	UInt32 m_timestamp;
	NSData* m_md5;
}

- (void)read:(ByteBuffer*)buf;

- (UInt32)QQ;
- (UInt32)timestamp;
- (NSData*)md5;

@end
