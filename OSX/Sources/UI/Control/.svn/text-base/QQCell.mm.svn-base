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

#import "QQCell.h"
#import "User.h"
#import "Group.h"
#import "Cluster.h"
#import "FileTool.h"
#import "PreferenceCache.h"
#import "NSString-Validate.h"
#import "ImageTool.h"
#import "QQConstants.h"
#import "Dummy.h"
#import "SearchedUser.h"
#import "AdvancedSearchedUser.h"
#import "FontTool.h"
#import "ParentLocatableOutlineDataSource.h"

static int s_identifier = 0;

@implementation QQCell

- (id) init {
	self = [super init];
	if(self) {
		m_QQ = 0;
		m_internalId = 0;
		m_searchStyle = NO;
		m_checkStyle = NO;
		m_memberStyle = NO;
		m_largeClusterHeadStyle = NO;
		m_ignoreLargeUserHeadPreference = NO;
		m_checker = [[NSButtonCell alloc] init];
		[m_checker setAllowsMixedState:YES];
		[m_checker setButtonType:NSSwitchButton];
		[m_checker setTitle:kStringEmpty];
		m_stateMap = [[NSMutableDictionary dictionary] retain];
		m_identifier = s_identifier++;
	}
	return self;
}

- (id)initWithQQ:(UInt32)QQ {
	self = [super init];
	if(self) {
		m_QQ = QQ;
		m_internalId = 0;
		m_searchStyle = NO;
		m_checkStyle = NO;
		m_checker = [[NSButtonCell alloc] init];
		[m_checker setButtonType:NSSwitchButton];
		[m_checker setTitle:kStringEmpty];
		[m_checker setAllowsMixedState:YES];
		m_stateMap = [[NSMutableDictionary dictionary] retain];
		m_identifier = s_identifier++;
	}
	return self;
}

- (void) dealloc {
	[m_checker release];
	[m_stateMap release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone*)zone {
    QQCell* newCopy = [[QQCell alloc] init];
	[newCopy setQQ:m_QQ];
	[newCopy setInternalId:m_internalId];
	[newCopy setSearchStyle:m_searchStyle];
	[newCopy setCheckStyle:m_checkStyle];
	[newCopy setLargeClusterHeadStyle:m_largeClusterHeadStyle];
	[newCopy setIgnoreLargeUserHeadPreference:m_ignoreLargeUserHeadPreference];
	[newCopy setMemberStyle:m_memberStyle];
	[newCopy setShowStatus:m_showStatus];
	[newCopy setHead:m_head];
	[newCopy setStateMap:m_stateMap];
	[newCopy setIdentifier:m_identifier];
    return newCopy;
}

- (void)drawGroupWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	// get group object
	Group* g = [self objectValue];
	
	// get group image
	NSImage* imgMain = nil;
	if([g isBlacklist])
		imgMain = [ImageTool imageWithName:kImageBlacklistGroup size:kSizeSmall];
	else if([g isStranger])
		imgMain = [ImageTool imageWithName:kImageStrangerGroup size:kSizeSmall];
	else
		imgMain = [ImageTool imageWithName:kImageFriendlyGroup size:kSizeSmall];
	
	// get main image rect and draw
	NSSize imgSize = [imgMain size];
	int x = (m_checkStyle ? [self drawChecker:cellFrame inView:controlView] : cellFrame.origin.x) + kSpacing;
	int y = NSMinY(cellFrame);
	NSRect imgRect = NSMakeRect(x,
								y,
								MIN(NSWidth(cellFrame), imgSize.width),
								MIN(NSHeight(cellFrame), imgSize.height));
	
	if ([controlView isFlipped])
		imgRect.origin.y += ceil((cellFrame.size.height + imgRect.size.height) / 2);
	else
		imgRect.origin.y += ceil((cellFrame.size.height - imgRect.size.height) / 2);
	[imgMain compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
	
	// blink some icon if has message unread
	if([g messageCount] == 0 || [g messageCount] > 0 && [g frame] == 1) {
		// compose group string
		NSString* string = [NSString stringWithFormat:@"%@ (%d/%d)", [g name], [g onlineUserCount], [g userCount]];
		
		// get string attribute
		NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
		[attributes setObject:[FontTool nickFontWithPreference:m_QQ] forKey:NSFontAttributeName];
		
		// get string bound
		NSRect bound = [string boundingRectWithSize:cellFrame.size
											options:NSStringDrawingUsesLineFragmentOrigin
										 attributes:attributes];
		
		// draw center vertical
		[string drawAtPoint:NSMakePoint(x + imgSize.width + kSpacing, cellFrame.origin.y + MAX(0, (cellFrame.size.height - bound.size.height) / 2))
			 withAttributes:attributes];
	}
	
	[g setFrame:(([g frame] + 1) % 2)];
}

- (void)drawMobileWithFrame:(NSRect)cellFrame inView:(NSView*)controlView {
	// get group object
	Mobile* m = [self objectValue];
	
	// get group image
	NSImage* imgMain = [NSImage imageNamed:kImageMobiles];
	
	// get main image rect
	NSSize imgSize = [imgMain size];
	
	// compare cell frame and image size
	if(imgSize.height > NSHeight(cellFrame)) 
		imgMain = [ImageTool imageWithName:[imgMain name] size:NSMakeSize(cellFrame.size.height, cellFrame.size.height)];
	
	// draw image
	int x = (m_checkStyle ? [self drawChecker:cellFrame inView:controlView] : cellFrame.origin.x) + kSpacing;
	int y = NSMinY(cellFrame);
	NSRect imgRect = NSMakeRect(x,
								y,
								MIN(NSWidth(cellFrame), imgSize.width),
								MIN(NSHeight(cellFrame), imgSize.height));
	
	if ([controlView isFlipped])
		imgRect.origin.y += ceil((cellFrame.size.height + imgRect.size.height) / 2);
	else
		imgRect.origin.y += ceil((cellFrame.size.height - imgRect.size.height) / 2);
	[imgMain compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
	
	// blink some icon if has message unread
	if([m messageCount] == 0 || [m messageCount] > 0 && [m frame] == 1) {
		// compose group string
		NSString* string = ([m name] == nil || [[m name] isEmpty]) ? [m mobile] : [m name];
		
		// get string attribute
		PreferenceCache* cache = [PreferenceCache cache:m_QQ];
		NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
		[attributes setObject:[FontTool nickFontWithPreference:m_QQ] forKey:NSFontAttributeName];
		[attributes setObject:[cache nickFontColor] forKey:NSForegroundColorAttributeName];
		
		// get string bound
		NSRect bound = [string boundingRectWithSize:cellFrame.size
											options:NSStringDrawingUsesLineFragmentOrigin
										 attributes:attributes];
		
		// draw center vertical
		[string drawAtPoint:NSMakePoint(x + imgSize.width + kSpacing, cellFrame.origin.y + MAX(0, (cellFrame.size.height - bound.size.height) / 2))
			 withAttributes:attributes];
	}
	
	[m setFrame:(([m frame] + 1) % 2)];
}

- (void)drawSearchStyleUserWithFrame:(NSRect)cellFrame inView:(NSView*)controlView {	
	// get head
	NSImage* imgMain = [ImageTool headWithId:[[self objectValue] head] size:kSizeSmall];
	
	// get main image rect and draw
	NSSize imgSize = [imgMain size];
	int x = cellFrame.origin.x + kSpacing;
	int y = NSMinY(cellFrame);
	NSRect imgRect = NSMakeRect(x,
								y,
								MIN(NSWidth(cellFrame), imgSize.width),
								MIN(NSHeight(cellFrame), imgSize.height));
	
	if ([controlView isFlipped])
		imgRect.origin.y += ceil((cellFrame.size.height + imgRect.size.height) / 2);
	else
		imgRect.origin.y += ceil((cellFrame.size.height - imgRect.size.height) / 2);
	[imgMain compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
	
	// get text x start
	x += imgRect.size.width + kSpacing;
	
	// get qq string
	NSString* qqStr = [NSString stringWithFormat:@"%u", [[self objectValue] QQ]];
	
	// get string attribute
	NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
	NSFont* font = [FontTool nickFontWithPreference:m_QQ];
	font = [[NSFontManager sharedFontManager] convertFont:font toSize:[NSFont systemFontSize]];
	[attributes setObject:font forKey:NSFontAttributeName];
	
	// get string bound
	NSRect bound = [qqStr boundingRectWithSize:cellFrame.size
									   options:NSStringDrawingUsesLineFragmentOrigin
									attributes:attributes];
	
	// draw center vertical
	[qqStr drawAtPoint:NSMakePoint(x, cellFrame.origin.y + MAX(0, (cellFrame.size.height - bound.size.height) / 2))
		withAttributes:attributes];
}

- (void)drawUserWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	if(m_searchStyle) {
		[self drawSearchStyleUserWithFrame:cellFrame inView:controlView];
		return;
	}
	
	// get user object
	User* u = [self objectValue];
	
	// get preference
	PreferenceCache* cache = [PreferenceCache cache:m_QQ];
	
	// get large flag
	BOOL bLarge = [cache showLargeUserHead];
	if(m_ignoreLargeUserHeadPreference)
		bLarge = cellFrame.size.height >= kSizeLarge.height;
	
	// head
	NSImage* imgMain = [u head:m_QQ handleStatus:YES];
	if(!bLarge)
		imgMain = [ImageTool imageWithName:[imgMain name] size:kSizeSmall];
	
	// get main image rect
	NSSize imgSize = [imgMain size];
	int x = (m_checkStyle ? [self drawChecker:cellFrame inView:controlView] : cellFrame.origin.x) + kSpacing;
	int y = NSMinY(cellFrame);
	NSRect imgRect = NSMakeRect(x,
								y,
								MIN(NSWidth(cellFrame), imgSize.width),
								MIN(NSHeight(cellFrame), imgSize.height));
	
	if ([controlView isFlipped])
		imgRect.origin.y += ceil((cellFrame.size.height + imgRect.size.height) / 2);
	else
		imgRect.origin.y += ceil((cellFrame.size.height - imgRect.size.height) / 2);
	
	// blink some icon if has message unread
	int frame = [u frameArray][0] % 2;
	if([u messageCount] + [u mobileMessageCount] == 0 ||
	   [u messageCount] + [u mobileMessageCount] > 0 && frame == 1) {
		[imgMain compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
		
		// draw status decoration or mobile chatting decoration, mobile chatting first
		if([u mobileChatting]) {
			NSImage* mobileChatting = bLarge ? [NSImage imageNamed:kImageMobileChatting] : [ImageTool imageWithName:kImageMobileChatting size:NSMakeSize(10, 10)];
			[self drawDecoration:mobileChatting headRect:imgRect];
		} else {
			switch(m_status) {
				case kQQStatusAway:
					[self drawDecoration:[NSImage imageNamed:kImageAway] headRect:imgRect];
					break;
				case kQQStatusHidden:
					[self drawDecoration:[NSImage imageNamed:kImageHidden] headRect:imgRect];
					break;
				case kQQStatusQMe:
					[self drawDecoration:[NSImage imageNamed:kImageQMe] headRect:imgRect];
					break;
				case kQQStatusBusy:
					[self drawDecoration:[NSImage imageNamed:kImageBusy] headRect:imgRect];
					break;
				case kQQStatusMute:
					[self drawDecoration:[NSImage imageNamed:kImageMute] headRect:imgRect];
					break;
			}
		}
	}
	
	// change frame
	[u setFrame:(frame + 1) index:0];
	
	// get display setting
	BOOL bShowRealName = [cache showRealName];
	BOOL bShowNickName = [cache showNickName];
	BOOL bShowLevel = [cache showLevel];
	BOOL bShowSignature = [cache showSignature];
	BOOL bShowUserProperty = [cache showUserProperty];
	BOOL bShowStatusMessage = [cache showStatusMessage];
	
	// draw user property is necessary
	if(bShowUserProperty) {
		NSImage* imgProp = nil;
		if([u isMobileQQ])
			imgProp = [NSImage imageNamed:kImageMobileQQ];
		else if([u isBind])
			imgProp = [NSImage imageNamed:kImageBindQQ];
		if(imgProp) {
			NSSize size = [imgProp size];
			[imgProp compositeToPoint:NSMakePoint(x - size.width - kSpacing, imgRect.origin.y) 
							operation:NSCompositeSourceOver];
		}
	}
	
	// get text x start
	x += imgRect.size.width + kSpacing;
	
	// get first line
	NSString* string = nil;
	if(bShowNickName)
		string = [u nick];
	if(bShowRealName) {
		if(string == nil && ![[u remarkName] isEmpty])
			string = [u remarkName];
		else if(![[u remarkName] isEmpty])
			string = [NSString stringWithFormat:@"%@ [%@]", string, [u remarkName]];
		else
			string = [u nick];
	}
	if(bShowLevel) {
		if(string == nil)
			string = [NSString stringWithFormat:@"(Level: %d)", [u level]];
		else
			string = [NSString stringWithFormat:@"%@ (Level: %d)", string, [u level]];
	}
	if(bShowStatusMessage && ![[u statusMessage] isEmpty]) {
		if(string == nil)
			string = [NSString stringWithFormat:@"(%@)", [u statusMessage]];
		else
			string = [NSString stringWithFormat:@"%@ (%@)", string, [u statusMessage]];
	}
	if(!bLarge && bShowSignature && [u signature])
		string = [NSString stringWithFormat:@"%@ %@", string, [u signature]];
	
	// get string attribute
	NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
	[attributes setObject:[FontTool nickFontWithPreference:m_QQ] forKey:NSFontAttributeName];
	
	// set color, check online flag
	if([u onlining]) {
		int frame = [u frameArray][1] % 4;
		switch(frame) {
			case 0:
				[attributes setObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
				break;
			case 1:
				[attributes setObject:[NSColor greenColor] forKey:NSForegroundColorAttributeName];
				break;
			case 2:
				[attributes setObject:[NSColor blueColor] forKey:NSForegroundColorAttributeName];
				break;
			case 3:
				[attributes setObject:[cache nickFontColor] forKey:NSForegroundColorAttributeName];
				break;
		}
		[u setFrame:(frame + 1) index:1];
	} else
		[attributes setObject:[cache nickFontColor] forKey:NSForegroundColorAttributeName];
	
	// get string bound
	NSRect stringBound = [string boundingRectWithSize:NSMakeSize(10000, cellFrame.size.height)
											  options:NSStringDrawingUsesLineFragmentOrigin
										   attributes:attributes];
	
	[string drawAtPoint:NSMakePoint(x, y) withAttributes:attributes];
	
	// draw signature if need
	if(bLarge && bShowSignature && [u signature] && ![[u signature] isEmpty]) {
		// get signature attribute
		[attributes setObject:[FontTool signatureFontWithPreference:m_QQ] forKey:NSFontAttributeName];
		[attributes setObject:[cache signatureFontColor] forKey:NSForegroundColorAttributeName];
		
		y += stringBound.size.height;
		[[u signature] drawAtPoint:NSMakePoint(x, y) withAttributes:attributes];
	}
}

- (void)drawMemberWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	if(m_searchStyle) {
		[self drawSearchStyleUserWithFrame:cellFrame inView:controlView];
		return;
	}
	
	// get user object
	User* u = [self objectValue];
	
	// head
	NSImage* imgMain = [u head:m_QQ handleStatus:YES];
	imgMain = [ImageTool imageWithName:[imgMain name] size:kSizeSmall];
	
	// get main image rect and draw
	NSSize imgSize = [imgMain size];
	int x = (m_checkStyle ? [self drawChecker:cellFrame inView:controlView] : cellFrame.origin.x) + kSpacing;
	int y = NSMinY(cellFrame);
	NSRect imgRect = NSMakeRect(x,
								y,
								MIN(NSWidth(cellFrame), imgSize.width),
								MIN(NSHeight(cellFrame), imgSize.height));
	
	if ([controlView isFlipped])
		imgRect.origin.y += ceil((cellFrame.size.height + imgRect.size.height) / 2);
	else
		imgRect.origin.y += ceil((cellFrame.size.height - imgRect.size.height) / 2);
	[imgMain compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
	
	// draw status decoration
	switch(m_status) {
		case kQQStatusAway:
			[self drawDecoration:[NSImage imageNamed:kImageAway] headRect:imgRect];
			break;
		case kQQStatusHidden:
			[self drawDecoration:[NSImage imageNamed:kImageHidden] headRect:imgRect];
			break;
	}
	
	// get display setting
	PreferenceCache* cache = [PreferenceCache cache:m_QQ];
	BOOL bShowClusterNameCard = [cache showClusterNameCard];
	
	// get text x start
	x += imgRect.size.width + kSpacing;
	
	// get name
	NSString* name = [u nick];
	if(bShowClusterNameCard) {
		// get related cluster internal id
		int cId = m_internalId;
		if(cId == 0) {
			if([controlView isMemberOfClass:[NSOutlineView class]]) {
				NSOutlineView* outline = (NSOutlineView*)controlView;
				id dataSource = [outline dataSource];
				if(dataSource) {
					id parent = [dataSource outlineView:outline parentOfItem:u];
					while(parent && ![parent isMemberOfClass:[Cluster class]])
						parent = [dataSource outlineView:outline parentOfItem:parent];
					
					if(parent)
						cId = [(Cluster*)parent internalId];
				}
			}
		}
		
		// if can't find parent cluster, don't append clustern name card
		if(cId != 0) {
			ClusterSpecificInfo* info = [u getClusterSpecificInfo:cId];
			if(![[[info nameCard] name] isEmpty])
				name = [NSString stringWithFormat:@"%@ [%@]", name, [[info nameCard] name]];
		}
	}
	
	// get string attribute
	NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
	[attributes setObject:[FontTool nickFontWithPreference:m_QQ] forKey:NSFontAttributeName];
	[attributes setObject:[cache nickFontColor] forKey:NSForegroundColorAttributeName];
	
	// get string bound
	NSRect bound = [name boundingRectWithSize:cellFrame.size
									  options:NSStringDrawingUsesLineFragmentOrigin
								   attributes:attributes];
	
	// draw center vertical
	[name drawAtPoint:NSMakePoint(x, cellFrame.origin.y + MAX(0, (cellFrame.size.height - bound.size.height) / 2))
	   withAttributes:attributes];
}

- (void)drawClusterWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	// get cluster object
	Cluster* c = [self objectValue];
	
	// check TM
	NSImage* imgMain = nil;
	if([c permanent])
		imgMain = [ImageTool imageWithName:kImageCluster size:(m_largeClusterHeadStyle ? kSizeLarge : kSizeSmall)];
	else
		imgMain = [ImageTool imageWithName:kImageTempCluster size:(m_largeClusterHeadStyle ? kSizeLarge : kSizeSmall)];
	
	// get main image rect and draw
	NSSize imgSize = [imgMain size];
	int x = (m_checkStyle ? [self drawChecker:cellFrame inView:controlView] : cellFrame.origin.x) + kSpacing;
	int y = NSMinY(cellFrame);
	NSRect imgRect = NSMakeRect(x,
								y,
								MIN(NSWidth(cellFrame), imgSize.width),
								MIN(NSHeight(cellFrame), imgSize.height));
	
	if ([controlView isFlipped])
		imgRect.origin.y += ceil((cellFrame.size.height + imgRect.size.height) / 2);
	else
		imgRect.origin.y += ceil((cellFrame.size.height - imgRect.size.height) / 2);
	[imgMain compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
	
	// blink some icon if has message unread
	if([c permanent]) {
		if(!([c messageCount] > 0 && [c messageSetting] == kQQClusterMessageAccept && [c frame] == 1)) {
			// get cluster name
			NSString* name = nil;
			if([c name])
				name = [c name];
			else if([c externalId] != 0)
				name = [NSString stringWithFormat:@"%u", [c externalId]];
			else
				name = [NSString stringWithFormat:@"%u", [c internalId]];
			if([c messageSetting] == kQQClusterMessageDisplayCount && [c messageCount] > 0)
				name = [NSString stringWithFormat:@"%@ (%d)", name, [c messageCount]];
			if(![[c operationSuffix] isEmpty])
				name = [NSString stringWithFormat:@"%@ (%@)", name, [c operationSuffix]];
			
			// get string attribute
			NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
			[attributes setObject:[FontTool nickFontWithPreference:m_QQ] forKey:NSFontAttributeName];
			
			// set cluster to red if it's advanced cluster
			if([[c info] isAdvanced])
				[attributes setObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
			
			// get name bound
			NSRect bound = [name boundingRectWithSize:cellFrame.size
											  options:NSStringDrawingUsesLineFragmentOrigin
										   attributes:attributes];
			
			// draw name
			[name drawAtPoint:NSMakePoint(x + imgRect.size.width + kSpacing, MAX(0, y + (cellFrame.size.height - bound.size.height) / 2))
			   withAttributes:attributes];
		}
	} else if([c messageCount] == 0 || [c frame] == 1) {
		// get cluster name
		NSString* name = [c name];
		// append operation suffix
		if(![[c operationSuffix] isEmpty])
			name = [NSString stringWithFormat:@"%@ (%@)", name, [c operationSuffix]];
		
		// get string attribute
		NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
		[attributes setObject:[FontTool nickFontWithPreference:m_QQ] forKey:NSFontAttributeName];
		
		// get name bound
		NSRect bound = [name boundingRectWithSize:cellFrame.size
										  options:NSStringDrawingUsesLineFragmentOrigin
									   attributes:attributes];
		
		// draw name
		[name drawAtPoint:NSMakePoint(x + imgRect.size.width + kSpacing, MAX(0, y + (cellFrame.size.height - bound.size.height) / 2))
		   withAttributes:attributes];
	}

	
	[c setFrame:(([c frame] + 1) % 2)];
}

- (void)drawDummyWithFrame:(NSRect)cellFrame inView:(NSView*)controlView {
	// get dummy object
	Dummy* dummy = [self objectValue];
	
	// check TM
	NSImage* imgMain = [ImageTool imageWithName:kImageTempCluster size:kSizeSmall];
	
	// get main image rect and draw
	NSSize imgSize = [imgMain size];
	int x = cellFrame.origin.x + kSpacing;
	int y = NSMinY(cellFrame);
	NSRect imgRect = NSMakeRect(x,
								y,
								MIN(NSWidth(cellFrame), imgSize.width),
								MIN(NSHeight(cellFrame), imgSize.height));
	
	if ([controlView isFlipped])
		imgRect.origin.y += ceil((cellFrame.size.height + imgRect.size.height) / 2);
	else
		imgRect.origin.y += ceil((cellFrame.size.height - imgRect.size.height) / 2);
	[imgMain compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
	
	// draw name
	NSString* name = [dummy name];
	if(![[dummy operationSuffix] isEmpty]) 
		name = [NSString stringWithFormat:@"%@ (%@)", name, [dummy operationSuffix]];
	
	// get string attribute
	NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
	[attributes setObject:[FontTool nickFontWithPreference:m_QQ] forKey:NSFontAttributeName];
	
	// get name bound
	NSRect bound = [name boundingRectWithSize:cellFrame.size
									  options:NSStringDrawingUsesLineFragmentOrigin
								   attributes:attributes];
	
	// draw name
	[name drawAtPoint:NSMakePoint(x + imgRect.size.width + kSpacing, MAX(0, y + (cellFrame.size.height - bound.size.height) / 2)) 
	   withAttributes:attributes];		
}

- (void)drawOrganizationWithFrame:(NSRect)cellFrame inView:(NSView*)controlView {
	// get organization object
	Organization* org = [self objectValue];
	
	// check TM
	NSImage* imgMain = [ImageTool imageWithName:kImageTempCluster size:kSizeSmall];
	
	// get main image rect and draw
	NSSize imgSize = [imgMain size];
	int x = cellFrame.origin.x + kSpacing;
	int y = NSMinY(cellFrame);
	NSRect imgRect = NSMakeRect(x,
								y,
								MIN(NSWidth(cellFrame), imgSize.width),
								MIN(NSHeight(cellFrame), imgSize.height));
	
	if ([controlView isFlipped])
		imgRect.origin.y += ceil((cellFrame.size.height + imgRect.size.height) / 2);
	else
		imgRect.origin.y += ceil((cellFrame.size.height - imgRect.size.height) / 2);
	[imgMain compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
	
	// draw name
	if([org name] && ![[org name] isEmpty]) {
		NSString* name = [org name];
		
		// get string attribute
		NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
		[attributes setObject:[FontTool nickFontWithPreference:m_QQ] forKey:NSFontAttributeName];
		
		// get name bound
		NSRect bound = [name boundingRectWithSize:cellFrame.size
										  options:NSStringDrawingUsesLineFragmentOrigin
									   attributes:attributes];
		
		// draw name
		[name drawAtPoint:NSMakePoint(x + imgRect.size.width + kSpacing, MAX(0, y + (cellFrame.size.height - bound.size.height) / 2)) 
		   withAttributes:attributes];	
	}
}

- (void)drawSearchUserResultWithFrame:(NSRect)cellFrame inView:(NSView*)controlView {
	id object = [self objectValue];
	BOOL online = YES;
	if([object isMemberOfClass:[AdvancedSearchedUser class]])
		online = [(AdvancedSearchedUser*)object online];
	
	// get head
	NSImage* imgMain = [ImageTool headWithId:[object head] size:kSizeSmall];
	
	// check online
	if(!online)
		imgMain = [ImageTool grayImage:imgMain size:kSizeSmall];
	
	// get main image rect and draw
	NSSize imgSize = [imgMain size];
	int x = cellFrame.origin.x + kSpacing;
	int y = NSMinY(cellFrame);
	NSRect imgRect = NSMakeRect(x,
								y,
								MIN(NSWidth(cellFrame), imgSize.width),
								MIN(NSHeight(cellFrame), imgSize.height));
	
	if ([controlView isFlipped])
		imgRect.origin.y += ceil((cellFrame.size.height + imgRect.size.height) / 2);
	else
		imgRect.origin.y += ceil((cellFrame.size.height - imgRect.size.height) / 2);
	[imgMain compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
	
	// get text x start
	x += imgRect.size.width + kSpacing;
	
	// get qq string
	NSString* qqStr = [NSString stringWithFormat:@"%u", [object QQ]];
	
	// get string attribute
	NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
	NSFont* font = [FontTool nickFontWithPreference:m_QQ];
	font = [[NSFontManager sharedFontManager] convertFont:font toSize:[NSFont systemFontSize]];
	[attributes setObject:font forKey:NSFontAttributeName];
	
	// get string bound
	NSRect bound = [qqStr boundingRectWithSize:cellFrame.size
									   options:NSStringDrawingUsesLineFragmentOrigin
									attributes:attributes];
	
	// draw center vertical
	[qqStr drawAtPoint:NSMakePoint(x, cellFrame.origin.y + MAX(0, (cellFrame.size.height - bound.size.height) / 2))
		withAttributes:attributes];
}

- (void)drawSearchClusterResultWithFrame:(NSRect)cellFrame inView:(NSView*)controlView {
	id object = [self objectValue];
	
	// get image
	NSImage* imgMain = [ImageTool imageWithName:kImageCluster size:kSizeSmall];
	
	// get main image rect and draw
	NSSize imgSize = [imgMain size];
	int x = cellFrame.origin.x + kSpacing;
	int y = NSMinY(cellFrame);
	NSRect imgRect = NSMakeRect(x,
								y,
								MIN(NSWidth(cellFrame), imgSize.width),
								MIN(NSHeight(cellFrame), imgSize.height));
	
	if ([controlView isFlipped])
		imgRect.origin.y += ceil((cellFrame.size.height + imgRect.size.height) / 2);
	else
		imgRect.origin.y += ceil((cellFrame.size.height - imgRect.size.height) / 2);
	[imgMain compositeToPoint:imgRect.origin operation:NSCompositeSourceOver];
	
	// get text x start
	x += imgRect.size.width + kSpacing;
	
	// get external id string
	NSString* idStr = [NSString stringWithFormat:@"%u", [object externalId]];
	
	// get string attribute
	NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
	NSFont* font = [FontTool nickFontWithPreference:m_QQ];
	font = [[NSFontManager sharedFontManager] convertFont:font toSize:[NSFont systemFontSize]];
	[attributes setObject:font forKey:NSFontAttributeName];
	
	// get string bound
	NSRect bound = [idStr boundingRectWithSize:cellFrame.size
									   options:NSStringDrawingUsesLineFragmentOrigin
									attributes:attributes];
	
	// draw center vertical
	[idStr drawAtPoint:NSMakePoint(x, cellFrame.origin.y + MAX(0, (cellFrame.size.height - bound.size.height) / 2))
		withAttributes:attributes];
}

- (int)drawChecker:(NSRect)cellFrame inView:(NSView*)controlView {
	[m_checker setState:[self state:[self objectValue]]];
	cellFrame.origin.x += kSpacing;
	[m_checker drawWithFrame:cellFrame inView:controlView];
	NSSize size = [m_checker cellSize];
	return cellFrame.origin.x + size.width;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	// if filtered, return
	if(NSHeight(cellFrame) < kSizeSmall.height)
		return;
	
	id object = [self objectValue];
	if([object isMemberOfClass:[Group class]])
		[self drawGroupWithFrame:cellFrame inView:controlView];
	else if([object isMemberOfClass:[User class]]) {
		if(m_memberStyle)
			[self drawMemberWithFrame:cellFrame inView:controlView];
		else
			[self drawUserWithFrame:cellFrame inView:controlView];
	} else if([object isMemberOfClass:[Mobile class]])
		[self drawMobileWithFrame:cellFrame inView:controlView];
	else if([object isMemberOfClass:[Cluster class]])
		[self drawClusterWithFrame:cellFrame inView:controlView];
	else if([object isMemberOfClass:[Dummy class]])
		[self drawDummyWithFrame:cellFrame inView:controlView];
	else if([object isMemberOfClass:[Organization class]])
		[self drawOrganizationWithFrame:cellFrame inView:controlView];
	else if([object isMemberOfClass:[SearchedUser class]] || [object isMemberOfClass:[AdvancedSearchedUser class]])
		[self drawSearchUserResultWithFrame:cellFrame inView:controlView];
	else if([object isMemberOfClass:[ClusterInfo class]])
		[self drawSearchClusterResultWithFrame:cellFrame inView:controlView];
}

- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)flag {
	if(m_checkStyle) {
		NSPoint locationInCellFrame = [controlView convertPoint:[theEvent locationInWindow] fromView:nil];
		
		NSSize size = [m_checker cellSize];
		NSRect frame;
		frame.origin.x = cellFrame.origin.x + kSpacing;
		frame.origin.y = cellFrame.origin.y + (cellFrame.size.height - size.height) / 2;
		frame.size = size;
		
		if(NSPointInRect(locationInCellFrame, frame)) {
			NSEvent* event = theEvent;
			do {
				switch([event type]) {
					case NSLeftMouseDown:
						id obj = [self objectValue];
						[self set:obj state:([self state:obj] != 0 ? NSOffState : NSOnState)];
						[(NSControl*)controlView updateCell:self];
						
						// send notification
						[[NSNotificationCenter defaultCenter] postNotificationName:kQQCellDidSelectedNotificationName
																			object:self
																		  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[self state:obj]], kUserInfoState, obj, kUserInfoObjectValue, nil]];
						break;
					case NSLeftMouseDragged:
						break;
					default:
						return YES;
				}
			} while(event = [[controlView window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask) untilDate:[NSDate distantFuture] inMode:NSEventTrackingRunLoopMode dequeue:YES]);
		}		
			
		return YES;
	} else
		return [super trackMouse:theEvent
						  inRect:cellFrame
						  ofView:controlView 
					untilMouseUp:flag];
}

#pragma mark -
#pragma mark actions

- (IBAction)onCheck:(id)sender {
	NSLog(@"action");
}

#pragma mark -
#pragma mark getter and setter

- (void)setQQ:(UInt32)QQ {
	m_QQ = QQ;
}

- (void)setSearchStyle:(BOOL)flag {
	m_searchStyle = flag;
}

- (void)setCheckStyle:(BOOL)flag {
	m_checkStyle = flag;
}

- (void)setMemberStyle:(BOOL)flag {
	m_memberStyle = flag;
}

- (void)setLargeClusterHeadStyle:(BOOL)flag {
	m_largeClusterHeadStyle = flag;
}

- (void)setIgnoreLargeUserHeadPreference:(BOOL)flag {
	m_ignoreLargeUserHeadPreference = flag;
}

- (void)setInternalId:(UInt32)internalId {
	m_internalId = internalId;
}

- (NSMutableDictionary*)stateMap {
	return m_stateMap;
}

- (void)setStateMap:(NSMutableDictionary*)map {
	[map retain];
	[m_stateMap release];
	m_stateMap = map;
}

- (int)identifier {
	return m_identifier;
}

#pragma mark -
#pragma mark helper

- (NSCellStateValue)state:(id)obj {
	NSNumber* value = [m_stateMap objectForKey:obj];
	if(value == nil)
		return NSOffState;
	else
		return (NSCellStateValue)[value intValue];
}

- (void)set:(id)obj state:(NSCellStateValue)state {
	[m_stateMap setObject:[NSNumber numberWithInt:state] forKey:obj];
}

- (void)setIdentifier:(int)identifier {
	m_identifier = identifier;
}

- (void)clearState {
	[m_stateMap removeAllObjects];
}

@end
