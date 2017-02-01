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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 0 2111-1307 USA
 */

#import <Cocoa/Cocoa.h>
#import "KeyDevour.h"
#import "QQTextViewDelegate.h"
#import "FaceManager.h"
#import "CustomFaceList.h"

@interface QQTextView : NSTextView <KeyDevour> {
	BOOL m_allowMultiFont;
	NSMutableDictionary* m_attributes;
	UInt32 m_QQ;
	
	// workaround for enter send key
	// if send key is enter, check inserted text, if empty, trigger send
	// we will check this when this flag is yes
	BOOL m_checkEnterSendKey;
}

- (void)customizeInitialization:(UInt32)QQ;

// helper
- (void)setAllowMultiFont:(BOOL)flag;
- (BOOL)allowMultiFont;
- (void)changeAttributesOfAllText:(NSDictionary*)newAttribute;
- (void)addAttributedString:(NSAttributedString*)string insert:(BOOL)insert;
- (void)insertDefaultFace:(int)index;
- (void)appendDefaultFace:(int)index;
- (NSAttributedString*)createDefaultFace:(int)index;
- (void)insertCustomFace:(int)type md5:(NSString*)md5 path:(NSString*)path received:(BOOL)received;
- (NSRange)appendCustomFace:(int)type md5:(NSString*)md5 path:(NSString*)path received:(BOOL)received;
- (void)replaceCustomFaceAtIndex:(int)location path:(NSString*)path;
- (NSAttributedString*)createCustomFace:(int)type md5:(NSString*)md5 path:(NSString*)path received:(BOOL)received;

@end
