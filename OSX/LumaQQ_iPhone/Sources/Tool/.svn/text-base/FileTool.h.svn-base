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

#import <Foundation/Foundation.h>
#import "User.h"
#import "Cluster.h"

@interface FileTool : NSObject {

}

+ (BOOL)initDirectoryForFile:(NSString*)filename;
+ (BOOL)createDirectory:(NSString*)dir withFileManager:(NSFileManager*)fm;
+ (NSArray*)directoryContentsAtPath:(NSString*)path;
+ (BOOL)isFileExist:(NSString*)filepath;
+ (BOOL)deleteFile:(NSString*)path;
+ (BOOL)createFile:(NSString*)path;
+ (BOOL)createFile:(NSString*)path withData:(NSData*)data;

+ (NSString*)getMyselfPlistByString:(NSString*)qqStr;
+ (NSString*)getRecentPlistByString:(NSString*)qqStr;
+ (NSString*)getAccountPathByString:(NSString*)qqStr;
+ (NSString*)getFilePath:(UInt32)iQQ ForFile:(NSString*)filename;
+ (NSString*)getCustomHeadPath:(UInt32)QQ md5:(NSData*)md5;
+ (NSArray*)subDirectory:(NSString*)parentDir;
+ (NSArray*)files:(NSString*)parentDir excludes:(NSArray*)excludes;
+ (NSString*)getSoundFilePath:(NSString*)basename scheme:(NSString*)scheme;
+ (NSString*)getChatLogDirectory;
+ (NSString*)getUserChatLogPath:(User*)user;
+ (NSString*)getClusterChatLogPath:(Cluster*)cluster;
+ (NSString*)getThemeFilePath;
+ (NSString*)getUnreadChatLogPath:(NSString*)file;
+ (BOOL)copy:(NSString*)source to:(NSString*)dest;

@end
