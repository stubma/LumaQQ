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

#import "Constants.h"
#import "ImageTool.h"
#import "QQConstants.h"
#import <CoreSurface/CoreSurface.h>

// max head
#define _kMaxHeadNumber 127

@implementation ImageTool

+ (UIImage*)headWithId:(int)head {
	// validate
	if(head < 0)
		head = 1;
	head /= 3;
	head++;
	if(head > _kMaxHeadNumber)
		head = 1;
	
	// get image
	UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", head]];
	return image;
}

+ (UIImage*)headWithRealId:(int)head {
	// validate
	if(head <= 0)
		head = 1;
	if(head > _kMaxHeadNumber)
		head = 1;
	
	// get image
	UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", head]];
	return image;
}

+ (UIImage*)decorateImage:(UIImage*)image decorator:(UIImage*)decorator {
	CGImageRef cgImage = [image imageRef];
	
	// Get image width, height. We'll use the entire image.
    size_t w = CGImageGetWidth(cgImage);
    size_t h = CGImageGetHeight(cgImage);
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    int bytesPerRow = w * 4;
    int byteCount = bytesPerRow * h;
	int bytesPerPixel = 4;
	
	// Use the generic RGB color space.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	if(colorSpace != NULL) {
		// Allocate memory for image data. This is the destination in memory
		// where any drawing to the bitmap context will be rendered.
		unsigned char* data = (unsigned char*)malloc(byteCount);
		if(data != NULL) {
			// Create the bitmap context. We want pre-multiplied ARGB, 8-bits
			// per component. Regardless of what the source image format is
			// (CMYK, Grayscale, and so on) it will be converted over to the format
			// specified here by CGBitmapContextCreate.
			CGContextRef context = CGBitmapContextCreate(data,
														 w,
														 h,
														 8,
														 bytesPerRow,
														 colorSpace,
														 kCGImageAlphaPremultipliedFirst);
			if(context != NULL) {
				// Draw the image to the bitmap context. Once we draw, the memory
				// allocated for the context for rendering will then contain the
				// raw image data in the specified color space.
				CGContextDrawImage(context, CGRectMake(0, 0, w, h), cgImage);
				
				// draw decorator
				cgImage = [decorator imageRef];
				size_t decoW = CGImageGetWidth(cgImage);
				size_t decoH = CGImageGetHeight(cgImage);
				CGContextDrawImage(context, CGRectMake(w - decoW, h - decoH, decoW, decoH), cgImage);
				
				// create CGImage from transformed data
				CGImageRef decoratedImage = CGBitmapContextCreateImage(context);
				image = [[[UIImage alloc] initWithImageRef:decoratedImage] autorelease];
				CGImageRelease(decoratedImage);
				
				// Make sure and release colorspace before returning
				CGContextRelease(context);
			} else
				NSLog(@"create CGContext failed");
			
			free(data);
		} else
			NSLog(@"bitmap data malloc failed");
		
		CGColorSpaceRelease(colorSpace);
    } else
		NSLog(@"color space is null");
	
	return image;
}

+ (UIImage*)grayImage:(UIImage*)image {
	CGImageRef cgImage = [image imageRef];
	
	// Get image width, height. We'll use the entire image.
    size_t w = CGImageGetWidth(cgImage);
    size_t h = CGImageGetHeight(cgImage);
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    int bytesPerRow = w * 4;
    int byteCount = bytesPerRow * h;
	
	// weird, some png reports 8 bits for a pixel, not 24, have to hard code it.
	int bytesPerPixel = 4; //CGImageGetBitsPerPixel(cgImage) / 8;
	
	// Use the generic RGB color space.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    if(colorSpace != NULL) {
		// Allocate memory for image data. This is the destination in memory
		// where any drawing to the bitmap context will be rendered.
		unsigned char* data = (unsigned char*)malloc(byteCount);
		if(data != NULL) {
			// Create the bitmap context. We want pre-multiplied ARGB, 8-bits
			// per component. Regardless of what the source image format is
			// (CMYK, Grayscale, and so on) it will be converted over to the format
			// specified here by CGBitmapContextCreate.
			CGContextRef context = CGBitmapContextCreate(data,
														 w,
														 h,
														 8,
														 bytesPerRow,
														 colorSpace,
														 kCGImageAlphaPremultipliedFirst);
			if(context != NULL) {
				// Draw the image to the bitmap context. Once we draw, the memory
				// allocated for the context for rendering will then contain the
				// raw image data in the specified color space.
				CGContextDrawImage(context, CGRectMake(0, 0, w, h), cgImage);
				
				// process to get gray image
				int line;
				for(line = 0; line < h; line++) {
					unsigned char* p = data + line * bytesPerRow;
					int count = bytesPerRow;
					while(count >= bytesPerPixel) {
						count -= bytesPerPixel;
						UInt8 gray = p[1] * 0.3 + p[2] * 0.6 + p[3] * 0.1;
						p[1] = p[2] = p[3] = gray;
						p += bytesPerPixel;
					}
				}
				
				// create CGImage from transformed data
				CGImageRef grayImage = CGBitmapContextCreateImage(context);
				image = [[[UIImage alloc] initWithImageRef:grayImage] autorelease];
				CGImageRelease(grayImage);

				// Make sure and release colorspace before returning
				CGContextRelease(context);
			} else
				NSLog(@"create CGContext failed");
		
			free(data);
		} else
			NSLog(@"bitmap data malloc failed");
		
		CGColorSpaceRelease(colorSpace);
    } else
		NSLog(@"color space is null");
	
	return image;
}

@end
