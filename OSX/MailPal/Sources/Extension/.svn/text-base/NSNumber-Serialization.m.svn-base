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

#import "NSNumber-Serialization.h"


@implementation NSNumber (Serialization)

- (NSData*)serialize {
	NSMutableData* data = [NSMutableData data];
	NSArchiver* ar = [[NSArchiver alloc] initForWritingWithMutableData:data];
	[ar encodeObject:self];
	[ar release];
	return data;
}

+ (NSNumber*)deserialize:(NSData*)data {
	NSUnarchiver* unar = [[NSUnarchiver alloc] initForReadingWithData:data];
	NSNumber* num = [unar decodeObject];
	NSNumber* ret = [[NSNumber numberWithInt:[num intValue]] retain];
	[unar release];
	return [ret autorelease];
}

@end
