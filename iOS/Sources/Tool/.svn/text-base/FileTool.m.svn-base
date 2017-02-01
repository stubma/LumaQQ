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

#import <sys/stat.h>
#import "NSData-BytesOperation.h"
#import "FileTool.h"
#import "Constants.h"

extern UInt32 gMyQQ;

@implementation FileTool

+ (BOOL)initDirectoryForFile:(NSString*)filename {
	NSFileManager* fm = [NSFileManager defaultManager];
	return [self createDirectory:[filename stringByDeletingLastPathComponent] withFileManager:fm];
}

+ (BOOL)createDirectory:(NSString*)dir withFileManager:(NSFileManager*)fm {
	dir = [dir stringByExpandingTildeInPath];
    if([fm fileExistsAtPath:dir])
		return YES;
    else {
		if([self createDirectory:[dir stringByDeletingLastPathComponent] withFileManager:fm])
			return [fm createDirectoryAtPath:dir attributes:nil];
	}
	return NO;
}

+ (NSArray*)directoryContentsAtPath:(NSString*)path {
	path = [path stringByExpandingTildeInPath];
	NSFileManager* fm = [NSFileManager defaultManager];
	return [fm directoryContentsAtPath:path];
}

+ (BOOL)createFile:(NSString*)path {
	return [self createFile:path withData:[NSData data]];
}

+ (BOOL)createFile:(NSString*)path withData:(NSData*)data {
	return [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
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

/*
 * in iPhone, no copyPath method in NSFileManager, we have to implement it
 */
+ (BOOL)copy:(NSString*)source to:(NSString*)dest {
	BOOL ret = NO;
	FILE *f;
	struct stat s;
	if (!stat([source fileSystemRepresentation], &s)) {
		unsigned char* d = malloc(s.st_size);
		if(d) {
			f = fopen([source fileSystemRepresentation], "rb");
			if(f) {
				fread(d, s.st_size, 1, f);
				fclose(f);
				f = fopen([dest fileSystemRepresentation], "wb");
				if(f) {
					fwrite(d, s.st_size, 1, f);
					fclose(f);
					ret = YES;
				}
			}
			free(d);
		}   
	}
	return ret;
}

+ (NSString*)getChatLogDirectory {
	NSString* sPath = kLQDirectoryRoot;
	sPath = [sPath stringByExpandingTildeInPath];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u", gMyQQ]];
	sPath = [sPath stringByAppendingPathComponent:kLQDirectoryChatLog];
	return sPath;
}

+ (NSString*)getUserChatLogPath:(User*)user {
	NSString* sPath = kLQDirectoryRoot;
	sPath = [sPath stringByExpandingTildeInPath];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u", gMyQQ]];
	sPath = [sPath stringByAppendingPathComponent:kLQDirectoryChatLog];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u.lumaqqchatlog", [user QQ]]];
	return sPath;
}

+ (NSString*)getClusterChatLogPath:(Cluster*)cluster {
	NSString* sPath = kLQDirectoryRoot;
	sPath = [sPath stringByExpandingTildeInPath];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u", gMyQQ]];
	sPath = [sPath stringByAppendingPathComponent:kLQDirectoryChatLog];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"c%u.lumaqqchatlog", [cluster internalId]]];
	return sPath;
}

+ (NSString*)getUnreadChatLogPath:(NSString*)file {
	NSString* sPath = kLQDirectoryRoot;
	sPath = [sPath stringByExpandingTildeInPath];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u", gMyQQ]];
	sPath = [sPath stringByAppendingPathComponent:kLQDirectoryChatLog];
	sPath = [sPath stringByAppendingPathComponent:file];
	return sPath;
}

+ (NSString*)getRecentPlistByString:(NSString*)qqStr {
	NSString* sPath = kLQDirectoryRoot;
	sPath = [sPath stringByExpandingTildeInPath];
	sPath = [sPath stringByAppendingPathComponent:qqStr];
	sPath = [sPath stringByAppendingPathComponent:kLQFileRecent];
	return sPath;
}

+ (NSString*)getMyselfPlistByString:(NSString*)qqStr {
	NSString* sPath = kLQDirectoryRoot;
	sPath = [sPath stringByExpandingTildeInPath];
	sPath = [sPath stringByAppendingPathComponent:qqStr];
	sPath = [sPath stringByAppendingPathComponent:kLQFileMyself];
	return sPath;
}

+ (NSString*)getAccountPathByString:(NSString*)qqStr {
	NSString* sPath = kLQDirectoryRoot;
	sPath = [sPath stringByExpandingTildeInPath];
	sPath = [sPath stringByAppendingPathComponent:qqStr];
	return sPath;
}

+ (NSString*)getFilePath:(UInt32)iQQ ForFile:(NSString*)filename {
	// get full path name according to qq number and file name
	NSString* sPath = kLQDirectoryRoot;
	sPath = [sPath stringByExpandingTildeInPath];
	sPath = [sPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u", iQQ]];
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

+ (NSArray*)subDirectory:(NSString*)parentDir {
	NSMutableArray* subs = [NSMutableArray array];
	NSFileManager* fm = [NSFileManager defaultManager];
	NSArray* contents = [fm directoryContentsAtPath:parentDir];
	NSEnumerator* e = [contents objectEnumerator];
	NSString* content;
	BOOL bDir = NO;
	while(content = [e nextObject]) {
		NSString* fullPath = [parentDir stringByAppendingPathComponent:content];
		if([fm fileExistsAtPath:fullPath isDirectory:&bDir]) {
			if(bDir)
				[subs addObject:content];
		}
	}
	return subs;
}

+ (NSArray*)files:(NSString*)parentDir excludes:(NSArray*)excludes {
	NSMutableArray* subs = [NSMutableArray array];
	NSFileManager* fm = [NSFileManager defaultManager];
	NSArray* contents = [fm directoryContentsAtPath:parentDir];
	NSEnumerator* e = [contents objectEnumerator];
	NSString* content;
	BOOL bDir = NO;
	while(content = [e nextObject]) {
		NSString* fullPath = [parentDir stringByAppendingPathComponent:content];
		if([fm fileExistsAtPath:fullPath isDirectory:&bDir]) {
			if(!bDir) {
				if(excludes == nil || ![excludes containsObject:content])
					[subs addObject:content];
			}
		}
	}
	return subs;
}

+ (NSString*)getSoundFilePath:(NSString*)basename scheme:(NSString*)scheme {
	NSString* path = [[NSBundle mainBundle] bundlePath];
	path = [path stringByAppendingPathComponent:kLQBundleDirectorySound];
	path = [path stringByAppendingPathComponent:scheme];
	path = [path stringByAppendingPathComponent:basename];
	
	NSString* file = [path stringByAppendingString:@".wav"];
	if([self isFileExist:file])
		return file;
	
	file = [path stringByAppendingString:@".aif"];
	if([self isFileExist:file])
		return file;
	
	return nil;
}

+ (NSString*)getThemeFilePath {
	NSString* path = [[NSBundle mainBundle] bundlePath];
	path = [path stringByAppendingPathComponent:kLQFileTheme];
	return path;
}

@end
