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

#import <Cocoa/Cocoa.h>


@interface FileTool : NSObject {

}

+ (BOOL)initDirectoryForFile:(NSString*)filename;
+ (BOOL)createDirectory:(NSString*)dir withFileManager:(NSFileManager*)fm;
+ (BOOL)isFileExist:(NSString*)filepath;
+ (BOOL)deleteFile:(NSString*)path;

+ (NSString*)getFilePath:(UInt32)iQQ ForFile:(NSString*)filename;
+ (NSString*)getQQShowFilePath:(UInt32)myQQ qq:(UInt32)friendQQ;
+ (NSString*)getGlobalFilePath:(NSString*)filename;
+ (NSString*)getCustomFacePath:(UInt32)QQ group:(NSString*)groupName file:(NSString*)filename;
+ (NSString*)getReceivedCustomFacePath:(UInt32)QQ file:(NSString*)filename;
+ (NSString*)getCustomFaceGroupPath:(UInt32)QQ group:(NSString*)groupName;
+ (NSString*)getHistoryPath:(UInt32)QQ owner:(NSString*)owner year:(int)year month:(int)month day:(int)day;
+ (NSString*)getCustomHeadPath:(UInt32)QQ md5:(NSData*)md5;
+ (BOOL)createCustomFaceGroupDir:(UInt32)QQ group:(NSString*)groupName;
+ (BOOL)copy:(NSString*)source to:(NSString*)dest;

@end
