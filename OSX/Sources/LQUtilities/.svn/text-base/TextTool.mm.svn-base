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

#import "TextTool.h"
#import "ByteTool.h"
#import "Constants.h"
#import "QQConstants.h"
#import "NSMutableData-CustomAppending.h"
#import "NSString-Converter.h"

@implementation TextTool

+ (NSData*)getTextData:(NSAttributedString*)string faceList:(CustomFaceList*)faceList {
	NSMutableData* data = [NSMutableData data];
	
	int cfIndex = -1;
	int len = [string length];
	int i = 0;
	while(i < len) {
		NSRange range;
		NSDictionary* attr = [string attributesAtIndex:i effectiveRange:&range];
		NSTextAttachment* attachment = [attr objectForKey:NSAttachmentAttributeName];
		if(attachment == nil) {
			[data appendData:[ByteTool getBytes:[[string string] substringWithRange:range]]];
		} else {
			switch([[attr objectForKey:kFaceAttributeType] intValue]) {
				case kFaceTypeDefault:
					// get code
					char code = [[attr objectForKey:kFaceAttributeCode] unsignedCharValue];
					[data appendByte:kQQTagDefaultFace];
					[data appendByte:code];
					break;
				case kFaceTypeCustomFace:
				case kFaceTypePicture:
				case kFaceTypeScreenscrap:
					cfIndex++;
					if(faceList) {
						CustomFace* face = [faceList face:cfIndex includeReference:YES];
						[data appendData:[face toData]];
					}
					break;
			}
		}
		i += range.length;
	}
	
	// append a space, if don't, the face will be displayed as gabage code in friend side
	[data appendByte:0x20];
	
	return data;
}

+ (CustomFaceList*)getCustomFaceList:(NSAttributedString*)string owner:(UInt32)owner faceManager:(FaceManager*)faceManager {
	CustomFaceList* list = [[CustomFaceList alloc] init];
	
	// create a hash to hold customface list
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	
	int len = [string length];
	int i = 0;
	while(i < len) {
		NSRange range;
		NSDictionary* attr = [string attributesAtIndex:i effectiveRange:&range];
		NSTextAttachment* attachment = [attr objectForKey:NSAttachmentAttributeName];
		if(attachment != nil) {
			int type = [[attr objectForKey:kFaceAttributeType] intValue];
			switch(type) {
				case kFaceTypeCustomFace:
				case kFaceTypeScreenscrap:
				case kFaceTypePicture:
					// get properties
					NSString* md5Str = [attr objectForKey:kFaceAttributeMD5];
					NSString* path = [attr objectForKey:kFaceAttributePath];
					
					// get face object
					Face* faceObj = [faceManager face:md5Str];
					NSString* shortcut = faceObj == nil ? @"" : [faceObj shortcut];
					
					// get properties thru checking
					char typeChar = 0;
					char sourceChar = 0;
					switch(type) {
						case kFaceTypeCustomFace:
							typeChar = 'e';
							sourceChar = kQQImageSourceCustomFace;
							break;
						case kFaceTypeScreenscrap:
							typeChar = 'k';
							sourceChar = kQQImageSourceScreenscrap;
							break;
						case kFaceTypePicture:
							typeChar = 'k';
							sourceChar = kQQImageSourceFile;
							break;
					}
						
					// check existence
					char existenceChar = 0;
					NSNumber* index = [dict objectForKey:md5Str];
					if(index != nil) {
						typeChar = 'A' + [index intValue];
						existenceChar = kQQClusterCustomFaceRef;
					} else
						existenceChar = kQQClusterCustomFace;
					
					// create custom face
					CustomFace* face = [[[CustomFace alloc] initWithOwner:owner
																	 type:typeChar
																   source:sourceChar
																existence:existenceChar
																 shortcut:shortcut
																 filename:[path lastPathComponent]
																	 data:[NSData dataWithContentsOfFile:path]
																	  md5:[md5Str hexData]] autorelease];
					
					// add to list
					[list addCustomFace:face];
					break;
			}
		}
		i += range.length;
	}
	
	return [list autorelease];
}

+ (int)customFaceCount:(NSAttributedString*)string type:(int)faceType {
	int count = 0;
	int len = [string length];
	int i = 0;
	while(i < len) {
		NSRange range;
		NSDictionary* attr = [string attributesAtIndex:i effectiveRange:&range];
		NSTextAttachment* attachment = [attr objectForKey:NSAttachmentAttributeName];
		if(attachment != nil) {
			int type = [[attr objectForKey:kFaceAttributeType] intValue];
			switch(type) {
				case kFaceTypeCustomFace:
				case kFaceTypeScreenscrap:
				case kFaceTypePicture:
					if(type == faceType)
						count++;
					break;
			}
		}
		i += range.length;
	}
	
	return count;
}

@end
