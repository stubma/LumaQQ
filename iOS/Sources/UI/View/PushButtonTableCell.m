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
#import "PushButtonTableCell.h"
#import <UIKit/UIPushButton.h>
#import <UIKit/UINavigationBar.h>
#import <GraphicsServices/GraphicsServices.h>
#import "LocalizedStringTool.h"

@implementation PushButtonTableCell

- (id)initWithTitle:(NSString*)title upImageName:(NSString*)upImageName downImageName:(NSString*)downImageName {
	self = [super init];
	if(self) {
		// create button
		UIPushButton* button = [[UIPushButton alloc] initWithTitle:title];
		GSFontRef font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 20.0f);
		[button setTitleFont:font];
		[button setDrawsShadow:YES];
		[button setEnabled:YES];
		[button setStretchBackground:YES];
		[button setAutosizesToFit:NO];
		[button setFrame:CGRectMake(10, 0, 300, 44)];
		[button setBackground:[UIImage imageNamed:upImageName] forState:kButtonStateUp];
		[button setBackground:[UIImage imageNamed:downImageName] forState:kButtonStateDown];
		[self setControl:button];
		[button release];
		CFRelease(font);
	}
	return self;
}

- (void)setEnabled:(BOOL)flag {
	[super setEnabled:flag];
	[[self control] setEnabled:flag];
}

@end
