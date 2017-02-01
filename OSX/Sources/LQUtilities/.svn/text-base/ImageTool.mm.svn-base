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

#import "Constants.h"
#import "ImageTool.h"
#import "QQConstants.h"

// max head
#define _kMaxHeadNumber 117

@implementation ImageTool

+ (NSImage*)grayImage:(NSImage*)image size:(NSSize)size {	
	// get gray image
	NSImage* grayImage = [self grayImage:image];
	
	// get gray image size and compare with the desired size
	NSSize imageSize = [grayImage size];	
	if(imageSize.width == size.width && imageSize.height == size.height)
		return grayImage;
	else {
		NSString* smallName = [NSString stringWithFormat:@"%@_gray_%d_%d", [image name], (int)size.width, (int)size.height];
		NSImage* sizedGrayImage = [NSImage imageNamed:smallName];
		if(sizedGrayImage == nil) {
			sizedGrayImage = grayImage;
			[sizedGrayImage setName:smallName];
			[sizedGrayImage setScalesWhenResized:YES];
			[sizedGrayImage setSize:size];
		}
		return sizedGrayImage;
	}
}

+ (NSImage*)grayImage:(NSImage*)image {
	// check cache first
	NSString* name = [NSString stringWithFormat:@"%@_gray", [image name]];
	NSImage* grayImage = [NSImage imageNamed:name];
	if(grayImage)
		return grayImage;
	
	// get image rep, don't support 8 bits now
	NSBitmapImageRep* rep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
	if([rep bitsPerSample] != 8)
		return image;
	
	// get image data
	unsigned char* data = [rep bitmapData];
	int height = [rep pixelsHigh];
	int bytesPerRow = [rep bytesPerRow];
	int bytesPerPixel = [rep bitsPerPixel] / 8;
	for(int line = 0; line < height; line++) {
		unsigned char* p = data + line * bytesPerRow;
		int byteCount = bytesPerRow;
		while(byteCount >= bytesPerPixel) {
			byteCount -= bytesPerPixel;
			UInt8 gray = p[0] * 0.3 + p[1] * 0.6 + p[2] * 0.1;
			p[0] = p[1] = p[2] = gray;
			p += bytesPerPixel;
		}
	}
	
	grayImage = [[[NSImage alloc] initWithData:[rep representationUsingType:NSBMPFileType properties:nil]] autorelease];
	[grayImage setName:name];
	return grayImage;
}

+ (NSImage*)headWithId:(int)head {
	// validate
	if(head < 0)
		head = 1;
	head /= 3;
	head++;
	if(head > 117)
		head = 1;
	
	// get image
	NSImage* image = [NSImage imageNamed:[NSString stringWithFormat:@"%d.bmp", head]];
	return image;
}

+ (NSImage*)headWithId:(int)head size:(NSSize)size {
	// validate
	if(head < 0)
		head = 1;
	head /= 3;
	head++;
	if(head > 117)
		head = 1;
	
	NSString* smallName = [NSString stringWithFormat:@"head_%d_%d_%d.bmp", (int)size.width, (int)size.height, head];
	NSImage* image = [NSImage imageNamed:smallName];
	if(image == nil) {
		image = [NSImage imageNamed:[NSString stringWithFormat:@"%d.bmp", head]];
		[image setName:smallName];
		[image setScalesWhenResized:YES];
		[image setSize:size];
	}
	return image;
}

+ (NSImage*)imageWithName:(NSString*)name size:(NSSize)size {
	NSString* smallName = [NSString stringWithFormat:@"image_%d_%d_%@", (int)size.width, (int)size.height, name];
	NSImage* image = [NSImage imageNamed:smallName];
	if(image == nil) {
		image = [NSImage imageNamed:name];
		image = [image copyWithZone:nil];
		[image setName:smallName];
		[image setScalesWhenResized:YES];
		[image setSize:size];
	}
	return image;
}

+ (NSImage*)iconWithMessageCount:(BOOL)mm status:(char)status unread:(int)unread showUnread:(BOOL)showUnread hasMessage:(BOOL)hasMessage {
	// if offline, return directly
	if(status == kQQStatusOffline)
		return [NSImage imageNamed:(mm ? kImageQQMMOffline : kImageQQGGOffline)];
	
	// load main icon
	NSImage* icon = nil;
	if(hasMessage)
		icon = [NSImage imageNamed:(mm ? kImageQQMMHasMessage : kImageQQGGHasMessage)];
	else {
		// TODO return different icon if Sim Wong...
		switch(status) {
			default:
				icon = [NSImage imageNamed:(mm ? kImageQQMMOnline : kImageQQGGOnline)];
				break;
		}
	}		

	// get icon size
	NSSize iconSize = [icon size];
	
	// check zero
	if(unread <= 0 || !showUnread)
		return icon;
	
	// get badge image
	NSImage* badge = [self unreadMessageBadge:unread];
	
	// create return image
	NSImage* ret = [[NSImage alloc] initWithSize:iconSize];
	[ret setCacheMode:NSImageCacheNever];
	[ret setFlipped:YES];
	[ret lockFocus];
	[icon compositeToPoint:NSMakePoint(0, iconSize.height) operation:NSCompositeSourceOver];
	[badge compositeToPoint:NSMakePoint(0, [badge size].height) operation:NSCompositeSourceOver];
	[ret unlockFocus];

	
	return [ret autorelease];
}

+ (NSImage*)unreadMessageBadge:(int)count {
	// 999 unread messages should be enough for anyone
	if (count >= 1000)
		count = 999;
	
	// get badge image
	NSImage* badgeToComposite = count < 10 ? [NSImage imageNamed:kImageTwoDigitsBadge] : [NSImage imageNamed:kImageThreeDigitsBadge];
	
	// get number string
	NSString* numString = [[NSNumber numberWithInt:count] description];

	// get badge bound
	NSRect rect = { NSZeroPoint, [badgeToComposite size] };
	
	// get number font
	NSFont* font = [NSFont fontWithName:@"Helvetica-Bold" size:24];	
	if(font == nil) 
		font = [NSFont systemFontOfSize:24];
	
	// create attributes
	NSDictionary* atts = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor whiteColor], NSForegroundColorAttributeName, font, NSFontAttributeName, nil];
	
	// calculate number rect
	NSSize numSize = [numString sizeWithAttributes:atts];
	rect.origin.x = (rect.size.width / 2) - (numSize.width / 2);
	rect.origin.y = (rect.size.height / 2) - (numSize.height / 2);
	
	// create badge image and draw
	NSImage* badge = [[NSImage alloc] initWithSize:rect.size];
	[badge setCacheMode:NSImageCacheNever];
	[badge setFlipped:YES];
	[badge lockFocus];
	[badgeToComposite compositeToPoint:NSMakePoint(0, rect.size.height) operation:NSCompositeSourceOver];
	[numString drawInRect:rect withAttributes:atts];
	[badge unlockFocus];

	// return
	return [badge autorelease];
}

@end
