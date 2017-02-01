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

#import "FaceSelectorDataSource.h"
#import "LocalizedStringTool.h"
#import "Constants.h"
#import "DefaultFace.h"
#import "FileTool.h"

@implementation FaceSelectorDataSource

- (id)initWithFaceManager:(FaceManager*)faceManager {
	return [self initWithFaceManager:faceManager showCustomFace:YES];
}

- (id)initWithFaceManager:(FaceManager*)faceManager showCustomFace:(BOOL)showCustomFace {
	self = [super init];
	if(self) {
		m_faceManager = [faceManager retain];
		m_showCustomFace = showCustomFace;
	}
	return self;
}

- (void) dealloc {
	[m_faceManager release];
	[super dealloc];
}

- (int)panelCount {
	return 1 + (m_showCustomFace ? [m_faceManager groupCount] : 0);
}

- (int)rowCount {
	return 8;
}

- (int)columnCount {
	return 15;
}

- (int)imageCount:(int)panel {
	switch(panel) {
		case 0:
			return DEFAULT_FACE_COUNT;
		default:
			if(panel > [m_faceManager groupCount])
				return 0;
			else
				return [m_faceManager faceCount:(panel - 1)];
	}
}

- (id)imageIdForPanel:(int)panel page:(int)page row:(int)row column:(int)col {
	int index = page * [self columnCount] * [self rowCount] + row * [self columnCount] + col;
	switch(panel) {
		case 0:
			return [NSNumber numberWithInt:[DefaultFace index2code:index]];
		default:
			if(panel > [m_faceManager groupCount])
				return nil;
			else if(index >= [m_faceManager faceCount:(panel - 1)])
				return nil;
			else
				return [[m_faceManager face:(panel - 1) atIndex:index] md5];
			break;
	}
}

- (NSImage*)imageForPanel:(int)panel page:(int)page row:(int)row column:(int)col {
	int index = page * [self columnCount] * [self rowCount] + row * [self columnCount] + col;
	switch(panel) {
		case 0:
			return [NSImage imageNamed:[NSString stringWithFormat:kImageFaceX, index]];
		default:
			if(panel > [m_faceManager groupCount])
				return nil;
			else if(index >= [m_faceManager faceCount:(panel - 1)])
				return nil;
			else {
				Face* f = [m_faceManager face:(panel - 1) atIndex:index];
				NSString* path = [FileTool getCustomFacePath:[m_faceManager QQ]
													   group:[[m_faceManager group:(panel - 1)] name]
														file:[f thumbnail]];
				return [[[NSImage alloc] initWithContentsOfFile:path] autorelease];
			}
			break;
	}
}

- (NSString*)labelForPanel:(int)panel {
	switch(panel) {
		case 0:
			return L(@"LQDefault");
		default:
			if(panel > [m_faceManager groupCount])
				return kStringEmpty;
			else
				return [[m_faceManager group:(panel - 1)] name];
			break;
	}
}

- (NSSize)imageSize {
	return kSizeSmall;
}

- (NSString*)auxiliaryButtonLabel {
	return L(@"LQManageCustomFace");
}

- (BOOL)showAuxiliaryButton {
	return YES;
}

@end
