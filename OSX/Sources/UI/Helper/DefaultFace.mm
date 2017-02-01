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

#import "DefaultFace.h"
#import "LocalizedStringTool.h"

@implementation DefaultFace

+ (int)index2code:(int)index {
	if(index < 0 || index >= DEFAULT_FACE_COUNT)
		return -1;
	return s_seq_code[index][1];
}

+ (int)code2index:(int)code {
	for(int i = 0; i < DEFAULT_FACE_COUNT; i++) {
		if(s_seq_code[i][1] == code)
			return s_seq_code[i][0];
	}
	return -1;
}

+ (int)count {
	return DEFAULT_FACE_COUNT;
}

+ (NSString*)index2name:(int)index {
	return L([NSString stringWithFormat:@"LQDefaultFace.%u", index]);
}

+ (NSString*)code2name:(int)code {
	int index = [DefaultFace code2index:code];
	return [DefaultFace index2name:index];
}

@end
