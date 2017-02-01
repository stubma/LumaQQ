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

#import "NSString-Filter.h"


@implementation NSString (Filter)

- (NSString*)filterByte:(UniChar)byte {
	NSString* s = [NSString stringWithCharacters:&byte length:1];
	NSRange range = [self rangeOfString:s];
	if(range.location == NSNotFound) 
		return self;
	else {
		NSMutableString* copy = [self mutableCopy];
		[copy replaceOccurrencesOfString:s
							  withString:@" "
								 options:0
								   range:NSMakeRange(0, [self length])];
		return copy;
	}
}

- (NSString*)normalize {
	NSString* ret = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	ret = [ret filterByte:'\r'];
	ret = [ret filterByte:'\n'];
	return ret;
}

@end
