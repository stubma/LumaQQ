/*
 * MailPal - A Garbage Code Terminator for iPhone Mail
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

#import "NSMutableData-CustomAppending.h"


@implementation NSMutableData (CustomAppending)

- (void)appendByte:(char)byte {
	[self appendBytes:&byte length:1];
}

- (void)appendSInt32:(SInt32)value littleEndian:(BOOL)littleEndian {
	SInt32 temp;
	if(littleEndian)
		temp = EndianS32_NtoL(value);
	else
		temp = EndianS32_NtoB(value);
	[self appendByte:*((char*)&value)];
	[self appendByte:*(((char*)&value) + 1)];
	[self appendByte:*(((char*)&value) + 2)];
	[self appendByte:*(((char*)&value) + 3)];
}

- (void)appendSInt16:(SInt32)value littleEndian:(BOOL)littleEndian {
	SInt16 temp;
	if(littleEndian)
		temp = EndianS16_NtoL(value);
	else
		temp = EndianS16_NtoB(value);
	[self appendByte:*((char*)&value)];
	[self appendByte:*(((char*)&value) + 1)];
}

@end
