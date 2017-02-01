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

#import "MessageRipper.h"
#import "NSData-BytesOperation.h"
#import "ByteTool.h"
#import "DefaultFace.h"
#import "LocalizedStringTool.h"

char* buffer = NULL;

@implementation MessageRipper

+ (void)initialize {
	buffer = (char*)malloc(sizeof(char) * 3000);
}

+ (NSString*)rip:(ReceivedIMPacket*)packet {
	NSData* data = [packet messageData];
	if(data == nil)
		return @"";
	int ripLength = 0;
	
	// the tag we are concerned
	static char tags[] = {
		kQQTagDefaultFace,
		kQQTagCustomFace
	};
	
	// search tag, append message and images
	int i;
	int from = 0;
	int length = [data length];
	const char* bytes = (const char*)[data bytes];
	for(i = [data indexOfBytes:tags length:2 from:from]; i != -1; i = [data indexOfBytes:tags length:2 from:from]) {
		// append message fragment
		if(i - from > 0) {
			memcpy((void*)(buffer + ripLength), (const void*)(bytes + from), i - from);
			ripLength += i - from;
		}
		
		// check face tag
		switch(bytes[i]) {
			case kQQTagDefaultFace:				
			{
				// adjust from
				from = i + 2;
				
				// get text format of default face
				NSString* faceText = [DefaultFace code2name:*(((const unsigned char*)bytes) + i + 1)];
				faceText = [NSString stringWithFormat:@"[%@]", faceText];
				if(faceText != nil) {
					NSData* data = [ByteTool getBytes:faceText];
					memcpy((void*)(buffer + ripLength), [data bytes], [data length]);
					ripLength += [data length];
				}
				break;
			}
			case kQQTagCustomFace:
			{
				switch(*(bytes + i + 1)) {
					case 0x32: // screenshot, user message
						from = i + 10;
						break;
					case 0x33: // new face, user message
					{
						from = i + 2;
						int extLen = *(bytes + from) - '0' + 1;
						from += 32 + 1 + extLen + 1;
						int shortcutLen = *(bytes + from) - 'A';
						from += shortcutLen + 1;
						break;
					}
					case 0x34: // existed face, user message
						from = i + 3;
						break;
					case 0x36: // new face, cluster message
					case 0x37: // existed face, cluster message
					{
						// point to i
						from = i;
						
						// then add length of custom face
						char c = *(bytes + i + 2);
						if(c != 0x20)
							from += (c - '0') * 100;
						c = *(bytes + i + 3);
						if(c != 0x20)
							from += (c - '0') * 10;
						c = *(bytes + i + 4);
						if(c != 0x20)
							from += c - '0';
						break;
					}
					default:
						from = i + 1;
						break;
				}
				
				NSData* data = [ByteTool getBytes:L(@"CustomFace")];
				memcpy((void*)(buffer + ripLength), [data bytes], [data length]);
				ripLength += [data length];
				break;
			}
		}
	}
	if(from < length) {
		memcpy((void *)(buffer + ripLength), (const void*)(bytes + from), length - from);
		ripLength += length - from;
	}
	
	// create string from buffer
	return [ByteTool getString:buffer length:ripLength];
}

@end
