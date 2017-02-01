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

#import "FileTool.h"
#import "Constants.h"
#import "NSData-BytesOperation.h"

@implementation FileTool

+ (BOOL)initDirectoryForFile:(NSString*)filename {
	NSFileManager* fm = [NSFileManager defaultManager];
	return [self createDirectory:[filename stringByDeletingLastPathComponent] withFileManager:fm];
}

+ (BOOL)createDirectory:(NSString*)dir withFileManager:(NSFileManager*)fm {
    if([fm fileExistsAtPath:dir])
		return YES;
    else {
		if([self createDirectory:[dir stringByDeletingLastPathComponent] withFileManager:fm])
			return [fm createDirectoryAtPath:dir attributes:nil];
	}
	return NO;
}

+ (BOOL)isFileExist:(NSString*)filepath {
	return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

+ (BOOL)deleteFile:(NSString*)path {
	if([self isFileExist:path])
		return [[NSFileManager defaultManager] removeFileAtPath:path handler:nil];
	else
		return YES;
}

+ (BOOL)createCustomFaceGroupDir:(UInt32)QQ group:(NSString*)groupName {
	NSString* path = [self getCustomFaceGroupPath:QQ group:groupName];
	return [self createDirectory:path withFileManager:[NSFileManager defaultManager]];
}

+ (BOOL)copy:(NSString*)source to:(NSString*)dest {
	return [[NSFileManager defaultManager] copyPath:source toPath:dest handler:nil];
}

+ (NSString*)getFilePath:(UInt32)iQQ ForFile:(NSString*)filename {
	// get full path name according to qq number and file name
	NSString* sPath = kLQDirectoryRoot;
	sPath = [sPath stringByExpandingTildeInPath];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u", iQQ]];
	sPath = [sPath stringByAppendingPathComponent:filename];
	return sPath;
}

+ (NSString*)getQQShowFilePath:(UInt32)myQQ qq:(UInt32)friendQQ {
	// get full path of qq show file
	NSString* sPath = kLQDirectoryRoot;
	sPath = [sPath stringByExpandingTildeInPath];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u", myQQ]];
	sPath = [sPath stringByAppendingPathComponent:kLQDirectoryQQShow];	
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:kImageQQShowX, friendQQ]];
	return sPath;
}

+ (NSString*)getGlobalFilePath:(NSString*)filename {
	// get global preference file full path
	NSString* sPath = kLQDirectoryRoot;
	sPath = [sPath stringByExpandingTildeInPath];
	sPath = [sPath stringByAppendingPathComponent:filename];
	return sPath;
}

+ (NSString*)getCustomFacePath:(UInt32)QQ group:(NSString*)groupName file:(NSString*)filename {
	NSString* sPath = kLQDirectoryRoot;
	sPath = [sPath stringByExpandingTildeInPath];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u", QQ]];
	sPath = [sPath stringByAppendingPathComponent:kLQDirectoryCustomFace];	
	sPath = [sPath stringByAppendingPathComponent:groupName];
	sPath = [sPath stringByAppendingPathComponent:filename];
	return sPath;
}

+ (NSString*)getCustomHeadPath:(UInt32)QQ md5:(NSData*)md5 {
	NSString* sPath = kLQDirectoryRoot;
	sPath = [sPath stringByExpandingTildeInPath];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u", QQ]];
	sPath = [sPath stringByAppendingPathComponent:kLQDirectoryCustomHead];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.bmp", [md5 hexString:NO]]];
	return sPath;
}

+ (NSString*)getReceivedCustomFacePath:(UInt32)QQ file:(NSString*)filename {
	NSString* sPath = kLQDirectoryRoot;
	sPath = [sPath stringByExpandingTildeInPath];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u", QQ]];
	sPath = [sPath stringByAppendingPathComponent:kLQDirectoryReceivedCustomFace];	
	sPath = [sPath stringByAppendingPathComponent:filename];
	return sPath;
}

+ (NSString*)getCustomFaceGroupPath:(UInt32)QQ group:(NSString*)groupName {
	NSString* sPath = kLQDirectoryRoot;
	sPath = [sPath stringByExpandingTildeInPath];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u", QQ]];
	sPath = [sPath stringByAppendingPathComponent:kLQDirectoryCustomFace];	
	sPath = [sPath stringByAppendingPathComponent:groupName];
	return sPath;
}

+ (NSString*)getHistoryPath:(UInt32)QQ owner:(NSString*)owner year:(int)year month:(int)month day:(int)day {
	NSString* sPath = kLQDirectoryRoot;
	sPath = [sPath stringByExpandingTildeInPath];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u", QQ]];
	sPath = [sPath stringByAppendingPathComponent:kLQDirectoryHistory];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u", year]];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u", month]];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u", day]];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.xml", owner]];
	return sPath;
}

@end
