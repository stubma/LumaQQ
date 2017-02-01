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

#import "FaceConfigParser.h"
#import "FaceGroup.h"

#define TAG_CUSTOMFACEGROUP @"<CUSTOMFACEGROUP"
#define TAG_CUSTOMFACE @"<CUSTOMFACE version"
#define TAG_FACE @"<FACE"
#define TAG_FILE_ORG @"<FILE ORG>"
#define TAG_END_FILE_ORG @"</FILE ORG>"
#define TAG_FILE_FIXED @"<FILE FIXED>"
#define TAG_END_FILE_FIXED @"</FILE FIXED>"
#define ATTR_NAME @"name=\""
#define ATTR_ID @"id=\""
#define ATTR_SHORTCUT @"shortcut=\""
#define ATTR_TIP @"tip=\""
#define ATTR_MULTIFRAME @"multiframe=\""
#define ATTR_FILEINDEX @"FileIndex=\""

@implementation FaceConfigParser

- (id)initWithData:(NSData*)data {
	self = [super init];
	if (self != nil) {
		m_data = [data retain];
		m_groups = [[NSMutableArray array] retain];
		m_faces = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_data release];
	[m_groups release];
	[m_faces release];
	[super dealloc];
}

- (NSArray*)faces {
	return m_faces;
}

- (NSArray*)groups {
	return m_groups;
}

- (void)parse {
	NSString* content = (NSString*)CFStringCreateFromExternalRepresentation(kCFAllocatorDefault, (CFDataRef)m_data, kCFStringEncodingGB_18030_2000);
	int length = [content length];
	
	int start = 0;
	FaceGroup* group = nil;
	NSRange nextGroupRange;
	NSRange range = [content rangeOfString:TAG_CUSTOMFACEGROUP options:NSCaseInsensitiveSearch];
	while(range.location != NSNotFound) {
		start = range.location + range.length;
		
		// get next group range
		nextGroupRange = [content rangeOfString:TAG_CUSTOMFACEGROUP options:NSCaseInsensitiveSearch range:NSMakeRange(start, length - start)];
		
		// serach name attr
		range = [content rangeOfString:ATTR_NAME options:NSCaseInsensitiveSearch range:NSMakeRange(start, length - start)];
		if(range.location != NSNotFound) {
			start = range.location + range.length;
			
			range = [content rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(start, length - start)];
			if(range.location != NSNotFound) {
				// create group
				NSString* name = [content substringWithRange:NSMakeRange(start, range.location - start)];
				group = [[[FaceGroup alloc] initWithName:name] autorelease];
				[m_groups addObject:group];
				start = range.location + range.length;
				
				// search face now
				range = [content rangeOfString:TAG_FACE options:NSCaseInsensitiveSearch range:NSMakeRange(start, length - start)];
				while(range.location != NSNotFound) {
					// if the face range is before next group, then the group is not changed
					if(nextGroupRange.location == NSNotFound || range.location < nextGroupRange.location) {
						start = range.location + range.length;
						Face* face = [self readFace:content start:&start length:length];
						if(face)
							[group addFace:face];
						range = [content rangeOfString:TAG_FACE options:NSCaseInsensitiveSearch range:NSMakeRange(start, length - start)];
					} else
						break;
				}
			}
		}
		
		// set next group range
		range = nextGroupRange;
	}
	
	//
	// search for ungrouped face
	//
	
	range = [content rangeOfString:TAG_CUSTOMFACE options:NSCaseInsensitiveSearch];
	while(range.location != NSNotFound) {
		start = range.location + range.length;
		
		// search face now
		range = [content rangeOfString:TAG_FACE options:NSCaseInsensitiveSearch range:NSMakeRange(start, length - start)];
		while(range.location != NSNotFound) {
			start = range.location + range.length;
			Face* face = [self readFace:content start:&start length:length];
			if(face)
				[m_faces addObject:face];
			range = [content rangeOfString:TAG_FACE options:NSCaseInsensitiveSearch range:NSMakeRange(start, length - start)];
		}
	}
	
	[content release];
}

- (Face*)readFace:(NSString*)content start:(int*)start length:(int)length {
	// create face
	Face* face = [[[Face alloc] init] autorelease];
	BOOL bValid = YES;
	
	// search id attr
	NSRange range = [content rangeOfString:ATTR_ID options:NSCaseInsensitiveSearch range:NSMakeRange(*start, length - *start)];
	if(range.location != NSNotFound) {
		*start = range.location + range.length;
		range = [content rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(*start, length - *start)];
		if(range.location != NSNotFound) {
			NSString* md5 = [content substringWithRange:NSMakeRange(*start, range.location - *start)];
			[face setMd5:md5];
		} else
			bValid = NO;
	} else
		bValid = NO;
	
	*start = range.location + range.length;
	
	// search shortcut attr
	range = [content rangeOfString:ATTR_SHORTCUT options:NSCaseInsensitiveSearch range:NSMakeRange(*start, length - *start)];
	if(range.location != NSNotFound) {
		*start = range.location + range.length;
		range = [content rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(*start, length - *start)];
		if(range.location != NSNotFound) {
			NSString* shortcut = [content substringWithRange:NSMakeRange(*start, range.location - *start)];
			[face setShortcut:shortcut];
		}
	}
	
	*start = range.location + range.length;
	
	// search tip attr
	range = [content rangeOfString:ATTR_TIP options:NSCaseInsensitiveSearch range:NSMakeRange(*start, length - *start)];
	if(range.location != NSNotFound) {
		*start = range.location + range.length;
		range = [content rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(*start, length - *start)];
		if(range.location != NSNotFound) {
			NSString* tip = [content substringWithRange:NSMakeRange(*start, range.location - *start)];
			[face setTip:tip];
		}
	}
	
	*start = range.location + range.length;
	
	// search multiframe attr
	range = [content rangeOfString:ATTR_MULTIFRAME options:NSCaseInsensitiveSearch range:NSMakeRange(*start, length - *start)];
	if(range.location != NSNotFound) {
		*start = range.location + range.length;
		range = [content rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(*start, length - *start)];
		if(range.location != NSNotFound) {
			NSString* multiframe = [content substringWithRange:NSMakeRange(*start, range.location - *start)];
			[face setMultiframe:([multiframe intValue] > 0)];
		}
	}
	
	*start = range.location + range.length;
	
	// search fileindex attr
	range = [content rangeOfString:ATTR_FILEINDEX options:NSCaseInsensitiveSearch range:NSMakeRange(*start, length - *start)];
	if(range.location != NSNotFound) {
		*start = range.location + range.length;
		range = [content rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(*start, length - *start)];
		if(range.location != NSNotFound) {
			NSString* index = [content substringWithRange:NSMakeRange(*start, range.location - *start)];
			[face setIndex:[index intValue]];
		}
	}
	
	// search file org
	range = [content rangeOfString:TAG_FILE_ORG options:NSCaseInsensitiveSearch range:NSMakeRange(*start, length - *start)];
	if(range.location != NSNotFound) {
		*start = range.location + range.length;
		
		range = [content rangeOfString:TAG_END_FILE_ORG options:NSCaseInsensitiveSearch range:NSMakeRange(*start, length - *start)];
		if(range.location != NSNotFound) {
			NSString* fileOrg = [content substringWithRange:NSMakeRange(*start, range.location - *start)];
			[face setOriginal:fileOrg];
		} else
			bValid = NO;
	} else
		bValid = NO;
	
	// search file fixed
	range = [content rangeOfString:TAG_FILE_FIXED options:NSCaseInsensitiveSearch range:NSMakeRange(*start, length - *start)];
	if(range.location != NSNotFound) {
		*start = range.location + range.length;
		
		range = [content rangeOfString:TAG_END_FILE_FIXED options:NSCaseInsensitiveSearch range:NSMakeRange(*start, length - *start)];
		if(range.location != NSNotFound) {
			NSString* fileFixed = [content substringWithRange:NSMakeRange(*start, range.location - *start)];
			[face setThumbnail:fileFixed];
		} else
			bValid = NO;
	} else
		bValid = NO;
	
	if(bValid)
		return face;
	else
		return nil;
}

@end
