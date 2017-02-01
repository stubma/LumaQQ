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

#import "BaseIMContainer.h"
#import "NSData-BytesOperation.h"
#import "ByteTool.h"
#import "MainWindowController.h"
#import "AlertTool.h"
#import "PreferenceCache.h"
#import "Constants.h"
#import "FontTool.h"
#import "FaceSelectorDataSource.h"
#import "FileTool.h"
#import "ScreenscrapHelper.h"
#import "TextTool.h"

@implementation BaseIMContainer

#pragma mark -
#pragma mark IMContainer protocol

- (NSString*)canSend {
	// get picture count and screenscrap count
	int count = [TextTool customFaceCount:[m_txtInput textStorage] type:kFaceTypeScreenscrap];
	count += [TextTool customFaceCount:[m_txtInput textStorage] type:kFaceTypePicture];
	
	// if count > 2, forbid sending
	if(count > 1)
		return L(@"LQWarningTooManyPicture", @"BaseIMContainer");
	else
		return nil;
}

- (IBAction)send:(id)sender {
	if([[m_txtInput textStorage] length] == 0) {
		// no more sheet hint now because it's a little boring
		// if need it, uncomment them
//		[AlertTool showWarning:[m_imView window]
//					   message:L(@"LQWarningEmptyMessage", @"BaseIMContainer")];
	} else {
		// can send?
		NSString* msg = [self canSend];
		if(msg != nil) {
			[AlertTool showWarning:[m_imView window]
						   message:msg];
			return;
		}
		
		// create SentIM
		NSDate* date = [NSDate date];
		SentIM* sentIM = [[[SentIM alloc] initWithTime:[date timeIntervalSince1970]
											   message:[[[m_txtInput textStorage] copyWithZone:nil] autorelease]] autorelease];
		
		// add to history
		[m_history addSentIM:sentIM];
		
		// add message to send queue
		[m_sendQueue addObject:[sentIM message]];
		
		// append hint
		[self appendMessageHint:[[m_mainWindowController me] nick]
						   date:date
					 attributes:m_myHintAttributes];
		
		// add to output
		[[m_txtOutput textStorage] appendAttributedString:[sentIM message]];
		[m_txtOutput scrollRangeToVisible:NSMakeRange([[m_txtOutput textStorage] length], 0)];
		
		// clear input
		[m_txtInput setString:kStringEmpty];
		
		// send
		if(!m_sending)
			[self sendNextMessage];
	}
}

- (id)initWithObject:(id)obj mainWindow:(MainWindowController*)mainWindowController {
	self = [super init];
	if(self) {
		m_obj = [obj retain];
		m_mainWindowController = [mainWindowController retain];
		m_sendQueue = [[NSMutableArray array] retain];
		m_sending = NO;
		m_formatter = [[NSDateFormatter alloc] initWithDateFormat:@"%Y-%m-%d %H:%M:%S" allowNaturalLanguage:NO];
		m_faceWaitingList = [[NSMutableDictionary dictionary] retain];
		m_faceSendingList = [[NSMutableDictionary dictionary] retain];
		m_objectController = [[NSObjectController alloc] initWithContent:self];
		
		NSFont* font = [NSFont fontWithName:@"Helvetica" size:[NSFont systemFontSize]];
		m_myHintAttributes = [[NSMutableDictionary dictionary] retain];
		[m_myHintAttributes setObject:font forKey:NSFontAttributeName];
		[m_myHintAttributes setObject:[NSColor colorWithCalibratedRed:0 green:0.51 blue:0.26 alpha:1.0] forKey:NSForegroundColorAttributeName];
		
		m_otherHintAttributes = [[NSMutableDictionary dictionary] retain];
		[m_otherHintAttributes setObject:font forKey:NSFontAttributeName];
		[m_otherHintAttributes setObject:[NSColor blueColor] forKey:NSForegroundColorAttributeName];
		
		m_errorHintAttributes = [[NSMutableDictionary dictionary] retain];
		[m_errorHintAttributes setObject:font forKey:NSFontAttributeName];
		[m_errorHintAttributes setObject:[NSColor grayColor] forKey:NSForegroundColorAttributeName];
		
		// get history
		m_history = [[[m_mainWindowController historyManager] getHistoryToday:[self owner]] retain];
		
		// add observer
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleWindowWillClose:)
													 name:NSWindowWillCloseNotification
												   object:nil];	
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleHistoryDidSelected:)
													 name:kHistoryDidSelectedNotificationName
												   object:nil];		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleCustomFaceDidReceived:)
													 name:kCustomFaceDidReceivedNotificationName
												   object:nil];	
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleCustomFaceFailedToReceive:)
													 name:kCustomFaceFailedToReceiveNotificationName
												   object:nil];	
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleCustomFaceDidSent:)
													 name:kCustomFaceDidSentNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleCustomFaceListFailedToSend:)
													 name:kCustomFaceListFailedToSendNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleIMContainerAttachedToWindow:)
													 name:kIMContainerAttachedToWindowNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleModelMessageCountChanged:)
													 name:kModelMessageCountChangedNotificationName
												   object:nil];
	}
	return self;
}

- (id)windowKey {
	NSException* e = [NSException exceptionWithName:@"Method Not Implemented"
											 reason:@"Must Implement owner Method"
										   userInfo:nil];
	[e raise];
	return nil;
}

- (id)model {
	return m_obj;
}

- (int)pendingMessageCount {
	return [m_sendQueue count];
}

- (NSString*)owner {
	NSException* e = [NSException exceptionWithName:@"Method Not Implemented"
											 reason:@"Must Implement owner Method"
										   userInfo:nil];
	[e raise];
	return nil;
}

- (NSImage*)ownerImage {
	NSException* e = [NSException exceptionWithName:@"Method Not Implemented"
											 reason:@"Must Implement owner Method"
										   userInfo:nil];
	[e raise];
	return nil;
}

- (void)refreshHeadControl:(HeadControl*)headControl {
}

- (IBAction)showOwnerInfo:(id)sender {
	
}

- (BOOL)handleQQEvent:(QQNotification*)event {
	return NO;
}

- (BOOL)accept:(InPacket*)packet {
	return NO;
}

- (void)walkMessageQueue:(MessageQueue*)queue {
}

- (NSArray*)actionIds {
	if(m_actionIds == nil) {
		m_actionIds = [[NSArray arrayWithObjects:kToolbarItemFont, 
			kToolbarItemColor, 
			NSToolbarSeparatorItemIdentifier,
			kToolbarItemSmiley,
			NSToolbarSeparatorItemIdentifier,
			kToolbarItemSendPicture,
			kToolbarItemScreenscrap,
			nil] retain];
	}
	return m_actionIds;
}

- (void)performAction:(NSString*)actionId {
	if([actionId isEqualToString:kToolbarItemFont])
		[self onFont:self];
	else if([actionId isEqualToString:kToolbarItemColor])
		[self onColor:self];
	else if([actionId isEqualToString:kToolbarItemSmiley])
		[self onSmiley:self];
	else if([actionId isEqualToString:kToolbarItemSendPicture])
		[self onSendPicture:self];
	else if([actionId isEqualToString:kToolbarItemScreenscrap])
		[self onScreenscrap:self];
}

- (NSImage*)actionImage:(NSString*)actionId {
	if([actionId isEqualToString:kToolbarItemFont])
		return [NSImage imageNamed:kImageFont];
	else if([actionId isEqualToString:kToolbarItemColor])
		return [NSImage imageNamed:kImageColor];
	else if([actionId isEqualToString:kToolbarItemSmiley])
		return [NSImage imageNamed:kImageSmiley];
	else if([actionId isEqualToString:kToolbarItemSendPicture])
		return [NSImage imageNamed:kImageSendPicture];
	else if([actionId isEqualToString:kToolbarItemScreenscrap])
		return [NSImage imageNamed:kImageScreenscrap];
	else
		return nil;
}

- (NSString*)actionTooltip:(NSString*)actionId {
	if([actionId isEqualToString:kToolbarItemFont])
		return L(@"LQTooltipFont", @"BaseIMContainer");
	else if([actionId isEqualToString:kToolbarItemColor])
		return L(@"LQTooltipColor", @"BaseIMContainer");
	else if([actionId isEqualToString:kToolbarItemSmiley])
		return L(@"LQTooltipFace", @"BaseIMContainer");
	else if([actionId isEqualToString:kToolbarItemSendPicture])
		return L(@"LQTooltipSendPicture", @"BaseIMContainer");
	else if([actionId isEqualToString:kToolbarItemScreenscrap])
		return L(@"LQTooltipScreenscrap", @"BaseIMContainer");
	else
		return kStringEmpty;
}

- (NSToolbarItem*)actionItem:(NSString*)actionId {
	if([actionId isEqualToString:NSToolbarSeparatorItemIdentifier])
		return nil;
	else if(![m_actionIds containsObject:actionId])
		return nil;
	else {
		NSToolbarItem* item = [[NSToolbarItem alloc] initWithItemIdentifier:actionId];
		[item setImage:[self actionImage:actionId]];
		[item setToolTip:[self actionTooltip:actionId]];
		return [item autorelease];
	}
}

- (BOOL)allowCustomFace {
	return YES;
}

- (NSString*)shortDescription {
	return kStringEmpty;
}

#pragma mark -
#pragma mark PSMTabModel protocol

- (BOOL)isProcessing {
	return NO;
}

- (void)setIsProcessing:(BOOL)value {
	
}

- (NSImage*)icon {
	return nil;
}

- (void)setIcon:(NSImage*)icon {
	
}

- (NSString*)iconName {
	return kStringEmpty;
}

- (void)setIconName:(NSString*)iconName {
	
}

- (int)objectCount {
	return 0;
}

- (void)setObjectCount:(int)value {
	
}

- (NSObjectController*)controller {
	return m_objectController;
}

#pragma mark -
#pragma mark initialization

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSWindowWillCloseNotification 
												  object:nil];	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kHistoryDidSelectedNotificationName 
												  object:nil];	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kCustomFaceDidReceivedNotificationName 
												  object:nil];	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kCustomFaceFailedToReceiveNotificationName
												  object:nil];	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kCustomFaceDidSentNotificationName 
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kCustomFaceListFailedToSendNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kIMContainerAttachedToWindowNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kModelMessageCountChangedNotificationName
												  object:nil];
	
	if(m_faceSelector)
		[m_faceSelector close];
	if(m_data)
		[m_data release];	
	if(m_winFacePreview) {
		[m_winFacePreview close];
		[m_winFacePreview release];
	}	
	
	[m_objectController release];
	[m_actionIds release];
	[m_faceList release];
	[m_history release];
	[m_faceWaitingList release];
	[m_faceSendingList release];
	[m_myHintAttributes release];
	[m_otherHintAttributes release];
	[m_errorHintAttributes release];
	[m_formatter release];
	[m_obj release];
	[m_mainWindowController release];
	[super dealloc];
}

- (void)awakeFromNib {
	// text
	[m_txtOutput customizeInitialization:[[m_mainWindowController me] QQ]];
	[m_txtInput customizeInitialization:[[m_mainWindowController me] QQ]];
	[m_txtOutput setUsesFontPanel:NO];
	[m_txtInput setAllowMultiFont:NO];
	[m_txtInput setTextContainerInset:NSMakeSize(0, 2)];
	[m_txtOutput setTextContainerInset:NSMakeSize(0, 2)];
}

- (BOOL)isEqual:(id)anObject {
	if([self class] == [anObject class] && [m_obj isEqual:[anObject model]])
		return YES;
	else
		return NO;
}

- (id)copyWithZone:(NSZone *)zone {
	return [self retain];
}

#pragma mark -
#pragma mark helper

- (void)handleWindowWillClose:(NSNotification*)notification {
	if(m_faceSelector) {
		if([notification object] == [m_faceSelector window]) {
			m_faceSelector = nil;
		}
	}
}

- (void)appendMessageHint:(NSString*)nick date:(NSDate*)date attributes:(NSDictionary*)attributes {
	[self appendMessageHint:m_txtOutput nick:nick date:date attributes:attributes];
}

- (void)appendMessageHint:(QQTextView*)textView nick:(NSString*)nick date:(NSDate*)date attributes:(NSDictionary*)attributes {
	NSString* hint = [NSString stringWithFormat:@"\n%@ %@\n", nick, [m_formatter stringFromDate:date]];
	NSAttributedString* string = [[NSAttributedString alloc] initWithString:hint attributes:([textView allowMultiFont] ? attributes : [textView typingAttributes])];
	[[textView textStorage] appendAttributedString:string];
	[string release];
}

- (void)appendPacket:(InPacket*)inPacket {
	[self appendPacket:m_txtOutput packet:inPacket];
}

- (void)appendPacket:(QQTextView*)textView packet:(InPacket*)inPacket {
}

- (void)appendMessage:(NSString*)nick data:(NSData*)data style:(FontStyle*)style date:(NSDate*)date customFaces:(CustomFaceList*)faceList {
	[self appendMessage:m_txtOutput nick:nick data:data style:style date:date customFaces:faceList];
}

- (void)appendMessage:(QQTextView*)textView nick:(NSString*)nick data:(NSData*)data style:(FontStyle*)style date:(NSDate*)date customFaces:(CustomFaceList*)faceList {
	// create font attributes
	NSMutableDictionary* attributes = nil;
	if([textView allowMultiFont]) {
		attributes = [NSMutableDictionary dictionary];
		NSFont* font = [FontTool fontWithStyle:style];
		[attributes setObject:font forKey:NSFontAttributeName];
		if([style underline])
			[attributes setObject:[NSNumber numberWithBool:YES] forKey:NSUnderlineStyleAttributeName];
		[attributes setObject:[style fontColor] forKey:NSForegroundColorAttributeName];
	} else
		attributes = (NSMutableDictionary*)[textView typingAttributes];
	
	// append hint
	[self appendMessageHint:textView
					   nick:nick
					   date:date
				 attributes:m_otherHintAttributes];
	
	// the tag we are concerned
	static char tags[] = {
		kQQTagDefaultFace,
		kQQTagCustomFace
	};
	
	// search tag, append message and images
	int cfIndex = -1;
	int from = 0;
	int length = [data length];
	const char* bytes = (const char*)[data bytes];
	for(int i = [data indexOfBytes:tags length:2 from:from]; i != -1; i = [data indexOfBytes:tags length:2 from:from]) {
		// append message fragment
		if(i - from > 0) {
			NSData* tmp = [NSData dataWithBytes:(bytes + from) length:(i - from)];
			NSString* string = [ByteTool getString:tmp];
			NSAttributedString* attrString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
			[[textView textStorage] appendAttributedString:attrString];
			[attrString release];
		}
		
		// check face tag
		switch(bytes[i]) {
			case kQQTagDefaultFace:				
				// append default face
				[textView appendDefaultFace:[DefaultFace code2index:(bytes[i + 1] & 0xFF)]];
				
				// adjust from
				from = i + 2;
				break;
			case kQQTagCustomFace:
				// get face index
				cfIndex++;
				
				// if face list is not nil, get face or show a sending image
				// if it's nil, bypass the face
				if(faceList) {
					// get face
					CustomFace* face = [faceList face:cfIndex includeReference:YES];
					int length = [face length];
					if([face isReference])
						face = [faceList face:[face faceIndex]];
					
					// hope not null
					if(face == nil)
						from = i + 1;
					else {
						FaceManager* fm = [m_mainWindowController faceManager];
						NSString* md5 = [[face filename] stringByDeletingPathExtension];
						if([fm hasFace:md5]) {
							// get face object
							Face* faceModel = [fm face:md5];
							
							// get face group
							FaceGroup* group = [fm group:[faceModel groupIndex]];
							NSAssert(group != nil, @"Face group shouldn't be nil");
							
							// append custom face
							[textView appendCustomFace:kFaceTypeCustomFace
												   md5:md5
												  path:[FileTool getCustomFacePath:[[m_mainWindowController me] QQ] group:[group name] file:[face filename]]
											  received:NO];
						} else if([fm hasReceivedFace:[face filename]]) {
							// append received face
							[textView appendCustomFace:kFaceTypeCustomFace
												   md5:md5
												  path:[FileTool getReceivedCustomFacePath:[[m_mainWindowController me] QQ] file:[face filename]]
											  received:YES];
						} else {
							if(textView == m_txtInput) {
								//
								// in input, means user is browsing history
								//
								
								NSString* path = [[NSBundle mainBundle] pathForImageResource:kImageNotFound];
								[textView appendCustomFace:kFaceTypePicture
													   md5:nil
													  path:path
												  received:NO];
							} else if(textView == m_txtOutput) {
								//
								// in output, means we are receiving faces!
								//
								
								NSString* path = [[NSBundle mainBundle] pathForImageResource:kImageReceivingImage];
								NSRange range = [textView appendCustomFace:kFaceTypePicture
																	   md5:nil
																	  path:path
																  received:YES];
								
								// put current face to waiting list
								[m_faceWaitingList setObject:[NSNumber numberWithInt:range.location] forKey:[face filename]];
							}
						}
						
						// adjust from
						from = i + length;
					}
				} else {
					from = i + 1;
				}
				break;
		}
	}
	if(from < length) {
		// append message fragment
		NSData* tmp = [NSData dataWithBytes:(bytes + from) length:(length - from)];
		NSString* string = [ByteTool getString:tmp];
		NSAttributedString* attrString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
		[[textView textStorage] appendAttributedString:attrString];		
		[attrString release];
	}
	
	// make message visible
	[textView scrollRangeToVisible:NSMakeRange([[textView textStorage] length], 0)];
}

- (void)createPreviewWindow {
	if(m_winFacePreview == nil) {
		// create window
		m_winFacePreview = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 128, 150)
													   styleMask:NSBorderlessWindowMask
														 backing:NSBackingStoreBuffered
														   defer:YES];
		[m_winFacePreview setReleasedWhenClosed:NO];
		[m_winFacePreview setLevel:NSScreenSaverWindowLevel];
		
		// create image view
		m_ivPreview = [[[NSImageView alloc] initWithFrame:NSMakeRect(0, 22, 128, 128)] autorelease];
		[m_ivPreview setImageFrameStyle:NSImageFramePhoto];
		[m_ivPreview setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		
		// add to window
		[[m_winFacePreview contentView] addSubview:m_ivPreview];
		
		// create shortcut text
		m_txtShortcut = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 128, 22)] autorelease];
		[m_txtShortcut setAutoresizingMask:(NSViewWidthSizable | NSViewMaxYMargin)];
		[m_txtShortcut setAlignment:NSCenterTextAlignment];
		[m_txtShortcut setEditable:NO];
		[m_txtShortcut setBezeled:NO];
		[m_txtShortcut setDrawsBackground:NO];
		[[m_winFacePreview contentView] addSubview:m_txtShortcut];
	}
}

- (void)showPreviewWindow {
	[self createPreviewWindow];
	
	NSRect frame = [[m_faceSelector window] frame];
	NSSize previewSize = [m_winFacePreview frame].size;
	frame.origin.x -= previewSize.width;
	frame.origin.y += frame.size.height - previewSize.height;
	frame.size = previewSize;
	[m_winFacePreview setFrame:frame display:NO];
	[m_winFacePreview orderFront:self];
}

- (void)sendNextMessage {	
	// check queue
	if([m_sendQueue count] == 0) {
		m_sending = NO;
		return;
	}
	
	// get next message
	NSAttributedString* message = [m_sendQueue objectAtIndex:0];
	
	// generate font style
	FontStyle* style = [FontTool chatFontStyleWithPreference:[[m_mainWindowController me] QQ]];
	
	// if sending, check fragment count
	if(m_sending) {
		if(m_fragmentCount > 1 && m_nextFragmentIndex < m_fragmentCount) {
			//
			// has more fragment need to be sent
			//
			
			// get data
			if(m_data) {
				int length = MIN(kQQMaxMessageFragmentLength, [m_data length] - m_nextFragmentIndex * kQQMaxMessageFragmentLength);
				NSData* messageData = [NSData dataWithBytes:(((const char*)[m_data bytes]) + m_nextFragmentIndex * kQQMaxMessageFragmentLength) length:length];
				m_waitingSequence = [self doSend:messageData
										   style:style
								   fragmentCount:m_fragmentCount
								   fragmentIndex:m_nextFragmentIndex];
				m_nextFragmentIndex++;				
				return;
			}
		}
	} else
		m_sending = YES;
	
	//
	// if program executes to here, means previous message is not long message
	// so we go on next
	//
	
	// release old data
	if(m_data) {
		[m_data release];
		m_data = nil;
	}
	
	// get custom face list
	if(m_faceList) {
		[m_faceList release];
		m_faceList = nil;
	}		
	m_faceList = [TextTool getCustomFaceList:message 
									   owner:[[self owner] intValue]
								 faceManager:[m_mainWindowController faceManager]];
	[m_faceList retain];
	
	// check face count, if 0, following normal process
	if([m_faceList count] == 0) {		
		// get message data
		m_data = [[TextTool getTextData:message faceList:nil] retain];
		
		// calculate fragment count
		m_fragmentCount = ([m_data length] - 1) / kQQMaxMessageFragmentLength + 1;
		
		if(m_fragmentCount > 1) {
			// set next index
			m_nextFragmentIndex = 0;
			
			// send first fragment
			NSData* messageData = [NSData dataWithBytes:[m_data bytes] length:kQQMaxMessageFragmentLength];
			m_waitingSequence = [self doSend:messageData
									   style:style
							   fragmentCount:m_fragmentCount
							   fragmentIndex:m_nextFragmentIndex];
			m_nextFragmentIndex++;
		} else {
			// send message
			m_waitingSequence = [self doSend:m_data
									   style:style
							   fragmentCount:1
							   fragmentIndex:0];
			[m_data release];
			m_data = nil;
		}
	} else {
		// build sending list
		[m_faceSendingList removeAllObjects];
		for(int i = 0; i < [m_faceList count]; i++) {
			CustomFace* face = [m_faceList face:i includeReference:NO];
			if(face == nil)
				break;
			else
				[m_faceSendingList setObject:face forKey:[face filename]];
		}
		
		// begin sending custom face
		[self sendCustomFaces:m_faceList];
	}
}

- (void)sendCustomFaces:(CustomFaceList*)faceList {
	NSLog(@"Send Custom Face, Subclass must implement this");
}

- (UInt16)doSend:(NSData*)data style:(FontStyle*)style fragmentCount:(int)fragmentCount fragmentIndex:(int)fragmentIndex {
	return 0;
}

- (void)handleHistoryDidSelected:(NSNotification*)notification {
}

- (void)handleCustomFaceFailedToReceive:(NSNotification*)notification {
	NSString* filename = [notification object];
	NSNumber* loc = [m_faceWaitingList objectForKey:filename];
	if(loc) {
		NSString* path = [[NSBundle mainBundle] pathForImageResource:kImageNoSuchImage];
		[m_txtOutput replaceCustomFaceAtIndex:[loc intValue] path:path];
		[m_faceWaitingList removeObjectForKey:filename];
	}
}

- (void)handleCustomFaceDidReceived:(NSNotification*)notification {
	NSString* filename = [notification object];
	NSNumber* loc = [m_faceWaitingList objectForKey:filename];
	if(loc) {
		NSString* path = [FileTool getReceivedCustomFacePath:[[m_mainWindowController me] QQ] file:filename];
		[m_txtOutput replaceCustomFaceAtIndex:[loc intValue] path:path];
		[m_faceWaitingList removeObjectForKey:filename];
	}
}

- (void)handleCustomFaceListFailedToSend:(NSNotification*)notification {
	if([m_faceSendingList count] > 0) {
		CustomFaceList* faceList = [notification object];
		
		if(faceList == m_faceList) {
			// clear sending list
			[m_faceSendingList removeAllObjects];

			// append error hint if count is 0
			NSAttributedString* hint = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:L(@"LQHintCustomFaceFailedToSend", @"BaseIMContainer"), [[notification userInfo] objectForKey:kUserInfoErrorMessage]]
																	   attributes:m_errorHintAttributes];
			[[m_txtOutput textStorage] appendAttributedString:hint];
			
			// cancel sending current message
			[m_sendQueue removeObjectAtIndex:0];
			
			// send next message
			m_sending = NO;
			[self sendNextMessage];
		}
	}
}

- (void)handleCustomFaceDidSent:(NSNotification*)notification {
	if([m_faceSendingList count] > 0) {
		CustomFace* face = [notification object];
		if([face owner] == [[self owner] intValue]) {
			[m_faceSendingList removeObjectForKey:[face filename]];
			if([m_faceSendingList count] == 0) {
				// get next message
				NSAttributedString* message = [m_sendQueue objectAtIndex:0];
				
				// generate font style
				FontStyle* style = [FontTool chatFontStyleWithPreference:[[m_mainWindowController me] QQ]];
				
				// get message data
				m_data = [[TextTool getTextData:message faceList:m_faceList] retain];
				
				// calculate fragment count
				m_fragmentCount = ([m_data length] - 1) / kQQMaxMessageFragmentLength + 1;
				
				if(m_fragmentCount > 1) {
					// set next index
					m_nextFragmentIndex = 0;
					
					// send first fragment
					NSData* messageData = [NSData dataWithBytes:[m_data bytes] length:kQQMaxMessageFragmentLength];
					m_waitingSequence = [self doSend:messageData
											   style:style
									   fragmentCount:m_fragmentCount
									   fragmentIndex:m_nextFragmentIndex];
					m_nextFragmentIndex++;
				} else {
					// send message
					m_waitingSequence = [self doSend:m_data
											   style:style
									   fragmentCount:1
									   fragmentIndex:0];
					[m_data release];
					m_data = nil;
				}
			}
		}
	}
}

- (void)handleIMContainerAttachedToWindow:(NSNotification*)notification {
	
}

- (void)handleModelMessageCountChanged:(NSNotification*)notification {
	if(m_obj == [notification object])
		[self setObjectCount:3];
}

#pragma mark -
#pragma mark actions

- (IBAction)onFont:(id)sender {
	NSFontManager* fm = [NSFontManager sharedFontManager];
	[fm orderFrontFontPanel:self];
}

- (IBAction)onColor:(id)sender {
	NSColorPanel* colorPanel = [NSColorPanel sharedColorPanel];
	[colorPanel setTarget:self];
	[colorPanel setAction:@selector(onColorChanged:)];
	[colorPanel orderFront:self];
}

- (IBAction)onSmiley:(id)sender {
	if(m_faceSelector)
		return;
	
	// get button bound
	NSRect bound = [m_txtInput bounds];	
	
	// calculate
	bound = [m_txtInput convertRect:bound toView:nil];
	bound.origin.y += bound.size.height;
	
	// create image selector window controller with frame
	m_faceSelector = [[ImageSelectorWindowController alloc] initWithDataSource:[[[FaceSelectorDataSource alloc] initWithFaceManager:[m_mainWindowController faceManager] showCustomFace:[self allowCustomFace]] autorelease] 
																	  delegate:self];
	[m_faceSelector showWindow:self];
	[[m_faceSelector window] setFrameOrigin:[[m_imView window] convertBaseToScreen:bound.origin]];
}

- (IBAction)onColorChanged:(id)sender {
	NSColor* color = [sender color];
	[m_txtInput setTextColor:color];
}

- (IBAction)onFaceManager:(id)sender {
	[[m_mainWindowController windowRegistry] showFaceManagerWindow:[[m_mainWindowController me] QQ] mainWindow:m_mainWindowController];
}

- (IBAction)onSendPicture:(id)sender {
	// open open panel
	NSOpenPanel* panel = [NSOpenPanel openPanel];
	[panel setAllowsMultipleSelection:NO];
	[panel setCanChooseDirectories:NO];
	[panel setCanChooseFiles:YES];
	[panel beginSheetForDirectory:NSHomeDirectory()
							 file:nil
							types:[NSArray arrayWithObjects:@"jpg", @"gif", @"bmp", @"png", @"tiff", nil]
				   modalForWindow:[m_imView window]
					modalDelegate:self
				   didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
					  contextInfo:nil];
}

- (IBAction)onScreenscrap:(id)sender {
	ScreenscrapHelper* helper = [ScreenscrapHelper sharedHelper];
	[helper beginScreenscrap];
}

- (IBAction)onSend:(id)sender {
	[self send:self];
}

#pragma mark -
#pragma mark open panel delegate

- (void)openPanelDidEnd:(NSOpenPanel*)panel returnCode:(int)returnCode contextInfo:(void*)contextInfo {
	if(returnCode = NSOKButton) {
		// load image file
		NSString* file = [panel filename];
		NSBitmapImageRep* rep = [NSBitmapImageRep imageRepWithData:[NSData dataWithContentsOfFile:file]];
		if(rep == nil)
			return;
		
		// convert to jpg file
		NSData* data = [rep representationUsingType:NSJPEGFileType
										 properties:nil];
		
		// save to a temp file named by UUID
		CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
		NSString* uuidStr = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuid);
		CFRelease(uuid);
		
		// write to file
		NSString* path = [NSString stringWithFormat:@"/tmp/{%@}.JPG", uuidStr];
		[data writeToFile:path atomically:YES];
		[uuidStr release];
		
		// post notification
		NSNotification* n = [NSNotification notificationWithName:kTempJPGFileDidCreatedNotificationName
														  object:data
														userInfo:[NSDictionary dictionaryWithObject:path forKey:kUserInfoImagePath]];
		[[NSNotificationQueue defaultQueue] enqueueNotification:n
												   postingStyle:NSPostASAP];
	}
}

#pragma mark -
#pragma mark getter and setter

- (NSView*)view {
	return m_imView;
}

- (QQTextView*)inputBox {
	return m_txtInput;
}

- (QQTextView*)outputBox {
	return m_txtOutput;
}

- (History*)history {
	return m_history;
}

#pragma mark -
#pragma mark image selector delegate

- (void)imageChanged:(id)sender image:(NSImage*)image imageId:(id)imageId panel:(int)panelId {
	// check image id
	if(imageId) {
		if([imageId isKindOfClass:[NSNumber class]]) {
			int index = [DefaultFace code2index:[imageId intValue]];
			if(index != -1)
				[m_txtInput insertDefaultFace:index];
		} else if([imageId isKindOfClass:[NSString class]]) {
			Face* face = [[m_mainWindowController faceManager] face:imageId];
			NSString* path = [FileTool getCustomFacePath:[[m_mainWindowController me] QQ]
												   group:[[[m_mainWindowController faceManager] group:(panelId - 1)] name]
													file:[face original]];
			[m_txtInput insertCustomFace:kFaceTypeCustomFace
									 md5:imageId
									path:path
								received:NO];
		}
	}
}

- (void)enterImage:(id)sender image:(NSImage*)image imageId:(id)imageId panel:(int)panelId {
}

- (void)exitImage:(id)sender image:(NSImage*)image imageId:(id)imageId panel:(int)panelId {
}

- (void)auxiliaryAction:(id)sender {
	[self onFaceManager:sender];
}

- (void)showTooltipAtPoint:(NSPoint)screenPoint image:(NSImage*)image imageId:(id)imageId panel:(int)panelId {
	[self showPreviewWindow];
	
	if(imageId) {
		if([imageId isKindOfClass:[NSNumber class]]) {
			[self showPreviewWindow];
			[m_ivPreview setImage:image];
			[m_ivPreview setAnimates:YES];
				[m_txtShortcut setStringValue:[DefaultFace code2name:[imageId intValue]]];
		} else {
			[self showPreviewWindow];
			Face* face = [[m_mainWindowController faceManager] face:imageId];
			NSString* path = [FileTool getCustomFacePath:[[m_mainWindowController me] QQ]
												   group:[[[m_mainWindowController faceManager] group:(panelId - 1)] name]
													file:[face original]];
			NSImage* image = [[[NSImage alloc] initWithContentsOfFile:path] autorelease];
			[m_ivPreview setImage:image];
			[m_ivPreview setAnimates:[face multiframe]];
			[m_txtShortcut setStringValue:[face shortcut]];
		}
	}
}

- (void)hideTooltip {
	if(m_winFacePreview) {
		[m_winFacePreview orderOut:self];
		[m_winFacePreview autorelease];
		m_winFacePreview = nil;
	}
}

@end
