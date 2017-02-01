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

#import "UIBaseChat.h"
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIBox.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UIFrameAnimation.h>
#import <UIKit/UIAnimator.h>
#import "UIController.h"
#import "NSString-Validate.h"
#import "LocalizedStringTool.h"
#import "Constants.h"
#import "BubbleIMCell.h"
#import "MessageManagerDelegate.h"
#import "ByteTool.h"
#import "MessageHistory.h"
#import "UIUtil.h"
#import "DefaultFace.h"
#import "ImageChooser.h"

#define _kTagFace 1
#define _kTagKeyboard 2
#define _kTagHide 3

static const float KEYBOARD_HEIGHT = 216.0f;
static const float INPUT_HEIGHT = 40.0f;
static const float BUTTON_BAR_HEIGHT = 45.0;
static const float INPUT_FIELD_HEIGHT = 26.0f;
static const float SEND_BUTTON_HEIGHT = 26.0f;

extern UInt32 gMyQQ;

@implementation UIBaseChat

- (void) dealloc {
	// remove notification handler
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kWillResumeNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kSendIMTimeoutNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kSendClusterIMFailedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kSendClusterIMTimeoutNotificationName
												  object:nil];
	
	[_view release];
	[_data release];
	[_msgModels release];
	[_cells release];
	[super dealloc];
}

- (NSString*)name {
	return @"";
}

- (void)begin:(UIController*)uiController {
	// save controller
	_uiController = uiController;
	
	// push navigation item
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:L(@"")] autorelease];
	[[uiController navBar] pushNavigationItem:item];
	
	// show button
	[[uiController navBar] showLeftButton:L(@"Back") withStyle:kNavButtonStyleBackArrow rightButton:L(@"ChatLog") withStyle:kNavButtonStyleNormal];
	
	// set delegate
	[[uiController navBar] setDelegate:self];
	
	// initialize variables
	_waitingCount = 0;
}

- (void)stop:(UIController*)uiController {
	[[[uiController navBar] navigationItems] removeAllObjects];
	[[uiController navBar] setDelegate:nil];
}

- (UIView*)view {
	if(_view == nil) {		
		// init variables
		_msgModels = [[NSMutableArray array] retain];
		_cells = [[NSMutableArray array] retain];
		
		// create top view
		CGRect bound = [_uiController clientRect];
		_view = [[UIView alloc] initWithFrame:bound];
		
		// create table
		bound.size.height -= INPUT_HEIGHT + BUTTON_BAR_HEIGHT;
		_table = [[[UITable alloc] initWithFrame:bound] autorelease];
		UITableColumn* col = [[[UITableColumn alloc] initWithTitle:@"Message" 
														identifier:@"message"
															 width:bound.size.width] autorelease];
		[_table addTableColumn:col];
		[_table setDataSource:self];
		
		// create input bar
		bound.origin.y += bound.size.height;
		bound.size.height = INPUT_HEIGHT;
		_inputBar = [[[UIPushButton alloc] initWithFrame:bound] autorelease];
		[_inputBar setDrawsShadow:YES];
		[_inputBar setStretchBackground:YES];
		[_inputBar setAutosizesToFit:NO];
		[_inputBar setShowPressFeedback:NO];
		[_inputBar setBackground:[UIImage imageNamed:kImageGradientGrayBackground] forState:kButtonStateDown];
		[_inputBar setBackground:[UIImage imageNamed:kImageGradientGrayBackground] forState:kButtonStateUp];
		
		// create round input field background
		bound.origin.x = 8.0f;
		bound.origin.y = (INPUT_HEIGHT - INPUT_FIELD_HEIGHT) / 2.0f;
		bound.size.height = INPUT_FIELD_HEIGHT;
		bound.size.width = 238.0f;
		UIPushButton* fieldBar = [[[UIPushButton alloc] initWithFrame:bound] autorelease];
		[fieldBar setDrawsShadow:YES];
		[fieldBar setStretchBackground:YES];
		[fieldBar setAutosizesToFit:NO];
		[fieldBar setShowPressFeedback:NO];
		[fieldBar setBackground:[UIImage imageNamed:kImageRoundInputFieldBackground] forState:kButtonStateDown];
		[fieldBar setBackground:[UIImage imageNamed:kImageRoundInputFieldBackground] forState:kButtonStateUp];
		
		// create input field
		bound.origin.x = 24.0f;
		bound.origin.y += 5.0f;
		bound.size.width = bound.size.width - 38.0f;
		bound.size.height = 16.0f;
		_inputField = [[[UITextField alloc] initWithFrame:bound] autorelease];
		GSFontRef font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 14.0f);
		[_inputField setFont:font];
		[_inputField setReturnKeyType:kReturnKeyTypeReturn];
		[_inputField setAutoEnablesReturnKey:YES];
		[_inputField setAutoCorrectionType:kAutoCorrectionNo];
		[_inputField setAutoCapsType:kAutoCapsNo];
		[_inputField setEditingDelegate:self];
		CFRelease(font);
		
		// create face button
		bound.origin.x = 248.0f;
		bound.origin.y = (INPUT_HEIGHT - SEND_BUTTON_HEIGHT) / 2.0f;						  
		bound.size.height = SEND_BUTTON_HEIGHT;
		bound.size.width = 64.0f;
		font = GSFontCreateWithName("Helvetica", kGSFontTraitBold, 16.0f);
		_faceButton = [[[UIPushButton alloc] initWithTitle:L(@"Send")] autorelease];
		[_faceButton setTitleFont:font];
		[_faceButton setDrawsShadow:YES];
		[_faceButton setEnabled:YES];
		[_faceButton setStretchBackground:YES];
		[_faceButton setAutosizesToFit:NO];
		[_faceButton setFrame:bound];
		[_faceButton setBackground:[UIImage imageNamed:kImageSmallOrangeButtonDown] forState:kButtonStateDown];
		[_faceButton setBackground:[UIImage imageNamed:kImageSmallOrangeButtonUp] forState:kButtonStateUp];
		[_faceButton addTarget:self action:@selector(sendButtonClicked:) forEvents:kUIMouseUp];
		CFRelease(font);
		
		// create button bar
		bound = [_inputBar frame];
		bound.origin.y += bound.size.height;
		bound.size.height = BUTTON_BAR_HEIGHT;
		[self _createButtonBar:bound];
		
		// create keyboard
		bound.origin.y += bound.size.height;
		bound.size.height = KEYBOARD_HEIGHT;
		_keyboard = [[[UIKeyboard alloc] initWithFrame:bound] autorelease];
		[_keyboard setTapDelegate:_view];
		[_keyboard setDefaultReturnKeyType:kReturnKeyTypeReturn];
		
		// create face chooser view
		_faceChooser = [[[ImageChooser alloc] initWithFrame:bound] autorelease];
		[_faceChooser setProvider:self];
		[_faceChooser setDelegate:self];
		[_faceChooser setRow:5];
		[_faceChooser setColumn:7];
		
		// add to top views
		[_view addSubview:_table];
		[_view addSubview:_inputBar];
		[_view addSubview:_keyboard];
		[_view addSubview:_faceChooser];
		[_inputBar addSubview:fieldBar];
		[_inputBar addSubview:_faceButton];
		[_inputBar addSubview:_inputField];
		
		// set button bar frame again
		bound = [_inputBar frame];
		bound.origin.y += bound.size.height;
		bound.size.height = BUTTON_BAR_HEIGHT;
		[_buttonBar setFrame:bound];
		
		// add notification handle
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleWillResume:)
													 name:kWillResumeNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleSendIMTimeout:)
													 name:kSendIMTimeoutNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleSendClusterIMFailed:)
													 name:kSendClusterIMFailedNotificationName
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleSendClusterIMTimeout:)
													 name:kSendClusterIMTimeoutNotificationName
												   object:nil];
	}
	
	// set default selection
	[_buttonBar showSelectionForButton:_kTagHide];
	_selectedTag = _kTagHide;
	
	return _view;
}

- (void)refresh:(NSMutableDictionary*)data {	
	// set focus to input field
	[_inputField becomeFirstResponder];
	
	if(data != nil) {
		// save data
		[data retain];
		[_data release];
		_data = data;
		
		// get groupmanager and client
		_groupManager = [_data objectForKey:kDataKeyGroupManager];
		_client = [_data objectForKey:kDataKeyClient];
		_messageManager = [_data objectForKey:kDataKeyMessageManager];
		[_messageManager setDelegate:self];
	}
}

- (void)_createButtonBar:(CGRect)frame {
	// create item dictionarys
	NSDictionary* faceDict = [NSDictionary dictionaryWithObjectsAndKeys:self, kUIButtonBarButtonTarget,
		@"faceButtonClicked:", kUIButtonBarButtonAction,
		[NSNumber numberWithUnsignedInt:_kTagFace], kUIButtonBarButtonTag,
		kImageFaceButtonOff, kUIButtonBarButtonInfo,
		kImageFaceButtonOn, kUIButtonBarButtonSelectedInfo,
		@"", kUIButtonBarButtonTitle,
		nil];
	NSDictionary* keyboardDict = [NSDictionary dictionaryWithObjectsAndKeys:self, kUIButtonBarButtonTarget,
		@"keyboardButtonClicked:", kUIButtonBarButtonAction,
		[NSNumber numberWithUnsignedInt:_kTagKeyboard], kUIButtonBarButtonTag,
		kImageKeyboardButtonOff, kUIButtonBarButtonInfo,
		kImageKeyboardButtonOn, kUIButtonBarButtonSelectedInfo,
		@"", kUIButtonBarButtonTitle,
		nil];
	NSDictionary* hideDict = [NSDictionary dictionaryWithObjectsAndKeys:self, kUIButtonBarButtonTarget,
		@"hideButtonClicked:", kUIButtonBarButtonAction,
		[NSNumber numberWithUnsignedInt:_kTagHide], kUIButtonBarButtonTag,
		kImageHideButtonOff, kUIButtonBarButtonInfo,
		kImageHideButtonOn, kUIButtonBarButtonSelectedInfo,
		@"", kUIButtonBarButtonTitle,
		nil];
	NSArray* items = [NSArray arrayWithObjects:faceDict, keyboardDict, hideDict, nil];
	_buttonBar = [[[UIButtonBar alloc] initInView:_view withFrame:frame withItemList:items] autorelease];
	[_buttonBar setDelegate:self];
	[_buttonBar setBarStyle:kButtonBarStyleBlack];
	[_buttonBar setButtonBarTrackingMode:2];
	
	// register group
	int buttons[] = {
		_kTagFace, _kTagKeyboard, _kTagHide
	};
	[_buttonBar registerButtonGroup:0 withButtons:buttons withCount:3];
	[_buttonBar showButtonGroup:0 withDuration:0.0f];
	[_buttonBar showSelectionForButton:_kTagHide];
	_selectedTag = _kTagHide;
}

- (void)_back {
	// add to history
	if([_msgModels count] > 0) {
		[MessageHistory addHistory:_msgModels forModel:[self _model]];
		[MessageHistory saveHistory:[self _model]];
	}
	
	// clear 
	[_msgModels removeAllObjects];
	[_cells removeAllObjects];
	[_messageManager setDelegate:nil];
	[_table reloadData];
	[self hideButtonClicked:nil];
	
	// back
	[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:nil];
}

- (void)_appendString:(NSString*)string {	
	// create cell
	BubbleIMCell* cell = [[[BubbleIMCell alloc] init] autorelease];
	[cell setGroupManager:_groupManager];
	
	// create dict
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:string, kChatLogKeyMessage,
		[NSNumber numberWithUnsignedInt:gMyQQ], kChatLogKeyQQ,
		[NSNumber numberWithUnsignedInt:(unsigned int)[[NSDate date] timeIntervalSince1970]], kChatLogKeyTime,
		nil];
	[cell setProperties:dict];
	[_cells addObject:cell];
	
	// add to models
	[_msgModels addObject:dict];
	
	// reload table
	[_table reloadDataForInsertionOfRows:NSMakeRange([_table numberOfRows], 1) animated:YES];
	[_table scrollRowToVisible:([_table numberOfRows] - 1)];
}

- (void)_appendError:(NSString*)string {
	// create cell
	BubbleIMCell* cell = [[[BubbleIMCell alloc] init] autorelease];
	[cell setGroupManager:_groupManager];
	
	// create dict, error message has only message
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:string, kChatLogKeyMessage,
						  nil];
	[cell setProperties:dict];
	[_cells addObject:cell];
	
	// add to models
	[_msgModels addObject:dict];
	
	// reload table
	[_table reloadDataForInsertionOfRows:NSMakeRange([_table numberOfRows], 1) animated:YES];
	[_table scrollRowToVisible:([_table numberOfRows] - 1)];
}

- (id)_model {
	// subclass need override this
}

- (void)_appendMessage:(NSDictionary*)properties {
	// add to models
	[_msgModels addObject:properties];
	
	// create cell
	BubbleIMCell* cell = [[[BubbleIMCell alloc] init] autorelease];
	[cell setGroupManager:_groupManager];
	[cell setProperties:properties];
	[_cells addObject:cell];
	
	// reload table
	[_table reloadDataForInsertionOfRows:NSMakeRange([_table numberOfRows], 1) animated:YES];
	[_table scrollRowToVisible:([_table numberOfRows] - 1)];
}

- (void)_showFaceChooser {
	// get keyboard bound
	CGRect frame = [_faceChooser frame];
	
	// animation array
	NSMutableArray* animations = [NSMutableArray array];
	
	// create animation of face chooser
	CGRect endFrame = CGRectMake(frame.origin.x, frame.origin.y - frame.size.height, frame.size.width, frame.size.height);
	UIFrameAnimation* animation = [[[UIFrameAnimation alloc] initWithTarget:_faceChooser] autorelease];
	[animation setStartFrame:frame];
	[animation setEndFrame:endFrame];
	[animation setAnimationCurve:kUIAnimationCurveLinear];
	[animation setDelegate:self];
	[animations addObject:animation];
	
	// check current status
	switch(_selectedTag) {
		case _kTagKeyboard:
		{
			frame = [_keyboard frame];
			UIFrameAnimation* animation = [[[UIFrameAnimation alloc] initWithTarget:_keyboard] autorelease];
			[animation setStartFrame:frame];
			[animation setEndFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, frame.size.height)];
			[animation setAnimationCurve:kUIAnimationCurveLinear];
			[animation setDelegate:self];
			[animations addObject:animation];
			
			_waitingCount = 2;
			break;
		}
		case _kTagHide:
		{
			frame = [_buttonBar frame];
			UIFrameAnimation* animation = [[[UIFrameAnimation alloc] initWithTarget:_buttonBar] autorelease];
			[animation setStartFrame:frame];
			[animation setEndFrame:CGRectMake(frame.origin.x, frame.origin.y - KEYBOARD_HEIGHT, frame.size.width, frame.size.height)];
			[animation setAnimationCurve:kUIAnimationCurveLinear];
			[animation setDelegate:self];
			[animations addObject:animation];
			
			frame = [_inputBar frame];
			animation = [[[UIFrameAnimation alloc] initWithTarget:_inputBar] autorelease];
			[animation setStartFrame:frame];
			[animation setEndFrame:CGRectMake(frame.origin.x, frame.origin.y - KEYBOARD_HEIGHT, frame.size.width, frame.size.height)];
			[animation setAnimationCurve:kUIAnimationCurveLinear];
			[animation setDelegate:self];
			[animations addObject:animation];
			
			frame = [_table frame];
			animation = [[[UIFrameAnimation alloc] initWithTarget:_table] autorelease];
			[animation setStartFrame:frame];
			[animation setEndFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - KEYBOARD_HEIGHT)];
			[animation setAnimationCurve:kUIAnimationCurveLinear];
			[animation setDelegate:self];
			[animations addObject:animation];
			
			_waitingCount = 4;
			break;
		}
	}
	
	// start animation
	[[UIAnimator sharedAnimator] addAnimations:animations
								  withDuration:0.25
										 start:YES];
}

- (void)_showKeyboard {
	// get keyboard bound
	CGRect frame = [_keyboard frame];
	
	// animation array
	NSMutableArray* animations = [NSMutableArray array];
	
	// create animation of keyboard
	UIFrameAnimation* animation = [[[UIFrameAnimation alloc] initWithTarget:_keyboard] autorelease];
	[animation setStartFrame:frame];
	[animation setEndFrame:CGRectMake(frame.origin.x, frame.origin.y - frame.size.height, frame.size.width, frame.size.height)];
	[animation setAnimationCurve:kUIAnimationCurveLinear];
	[animation setDelegate:self];
	[animations addObject:animation];
	
	switch(_selectedTag) {
		case _kTagFace:
		{
			frame = [_faceChooser frame];
			UIFrameAnimation* animation = [[[UIFrameAnimation alloc] initWithTarget:_faceChooser] autorelease];
			[animation setStartFrame:frame];
			[animation setEndFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, frame.size.height)];
			[animation setAnimationCurve:kUIAnimationCurveLinear];
			[animation setDelegate:self];
			[animations addObject:animation];
			
			_waitingCount = 2;
			break;
		}
		case _kTagHide:
		{
			frame = [_buttonBar frame];
			UIFrameAnimation* animation = [[[UIFrameAnimation alloc] initWithTarget:_buttonBar] autorelease];
			[animation setStartFrame:frame];
			[animation setEndFrame:CGRectMake(frame.origin.x, frame.origin.y - KEYBOARD_HEIGHT, frame.size.width, frame.size.height)];
			[animation setAnimationCurve:kUIAnimationCurveLinear];
			[animation setDelegate:self];
			[animations addObject:animation];
			
			frame = [_inputBar frame];
			animation = [[[UIFrameAnimation alloc] initWithTarget:_inputBar] autorelease];
			[animation setStartFrame:frame];
			[animation setEndFrame:CGRectMake(frame.origin.x, frame.origin.y - KEYBOARD_HEIGHT, frame.size.width, frame.size.height)];
			[animation setAnimationCurve:kUIAnimationCurveLinear];
			[animation setDelegate:self];
			[animations addObject:animation];
			
			frame = [_table frame];
			animation = [[[UIFrameAnimation alloc] initWithTarget:_table] autorelease];
			[animation setStartFrame:frame];
			[animation setEndFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - KEYBOARD_HEIGHT)];
			[animation setAnimationCurve:kUIAnimationCurveLinear];
			[animation setDelegate:self];
			[animations addObject:animation];
			
			_waitingCount = 4;
			break;
		}
	}
	
	// start animation
	[[UIAnimator sharedAnimator] addAnimations:animations
								  withDuration:0.25
										 start:YES];
}

- (void)_hide {
	// animation array
	NSMutableArray* animations = [NSMutableArray array];
	
	switch(_selectedTag) {
		case _kTagFace:
		{
			CGRect frame = [_faceChooser frame];
			UIFrameAnimation* animation = [[[UIFrameAnimation alloc] initWithTarget:_faceChooser] autorelease];
			[animation setStartFrame:frame];
			[animation setEndFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, frame.size.height)];
			[animation setAnimationCurve:kUIAnimationCurveLinear];
			[animation setDelegate:self];
			[animations addObject:animation];
			
			break;
		}
		case _kTagKeyboard:
		{
			CGRect frame = [_keyboard frame];
			UIFrameAnimation* animation = [[[UIFrameAnimation alloc] initWithTarget:_keyboard] autorelease];
			[animation setStartFrame:frame];
			[animation setEndFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, frame.size.height)];
			[animation setAnimationCurve:kUIAnimationCurveLinear];
			[animation setDelegate:self];
			[animations addObject:animation];
			
			break;
		}
	}
	
	CGRect frame = [_buttonBar frame];
	UIFrameAnimation* animation = [[[UIFrameAnimation alloc] initWithTarget:_buttonBar] autorelease];
	[animation setStartFrame:frame];
	[animation setEndFrame:CGRectMake(frame.origin.x, frame.origin.y + KEYBOARD_HEIGHT, frame.size.width, frame.size.height)];
	[animation setAnimationCurve:kUIAnimationCurveLinear];
	[animation setDelegate:self];
	[animations addObject:animation];
	
	frame = [_inputBar frame];
	animation = [[[UIFrameAnimation alloc] initWithTarget:_inputBar] autorelease];
	[animation setStartFrame:frame];
	[animation setEndFrame:CGRectMake(frame.origin.x, frame.origin.y + KEYBOARD_HEIGHT, frame.size.width, frame.size.height)];
	[animation setAnimationCurve:kUIAnimationCurveLinear];
	[animation setDelegate:self];
	[animations addObject:animation];
	
	frame = [_table frame];
	animation = [[[UIFrameAnimation alloc] initWithTarget:_table] autorelease];
	[animation setStartFrame:frame];
	[animation setEndFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + KEYBOARD_HEIGHT)];
	[animation setAnimationCurve:kUIAnimationCurveLinear];
	[animation setDelegate:self];
	[animations addObject:animation];
	
	_waitingCount = 4;
	
	// start animation
	[[UIAnimator sharedAnimator] addAnimations:animations
								  withDuration:0.25
										 start:YES];
}

- (UInt16)doSend:(id)obj data:(NSData*)data style:(FontStyle*)style fragmentCount:(int)fragmentCount fragmentIndex:(int)fragmentIndex {
	return 0;
}

- (void)_reloadMessages {
}

- (void)handleWillResume:(NSNotification*)notification {
	// workground to resolve the black keyboard problem
	[_keyboard retain];
	[_keyboard removeFromSuperview];
	[_view addSubview:_keyboard];
	[_keyboard autorelease];
	
	// reload message if some message is cached during suspension
	if([_uiController isUnitActive:[self name]])
		[self _reloadMessages];
}

- (void)handleSendIMTimeout:(NSNotification*)notification {
	if([_uiController isUnitActive:[self name]]) {
		id obj = [notification object];
		if([self _model] != nil && [[self _model] isEqual:obj]) {
			// append timeout hint to output text view
			NSString* message = [[notification userInfo] objectForKey:kUserInfoMessage];
			[self _appendError:[NSString stringWithFormat:L(@"SendTimeout"), message]];
		}
	}
}

- (void)handleSendClusterIMTimeout:(NSNotification*)notification {
	if([_uiController isUnitActive:[self name]]) {
		id obj = [notification object];
		if([self _model] != nil && [[self _model] isEqual:obj]) {
			// append timeout hint to output text view
			NSString* message = [[notification userInfo] objectForKey:kUserInfoMessage];
			[self _appendError:[NSString stringWithFormat:L(@"SendTimeout"), message]];
		}
	}
}

- (void)handleSendClusterIMFailed:(NSNotification*)notification {
	if([_uiController isUnitActive:[self name]]) {
		id obj = [notification object];
		if([self _model] != nil && [[self _model] isEqual:obj]) {
			// append timeout hint to output text view
			NSString* message = [[notification userInfo] objectForKey:kUserInfoMessage];
			[self _appendError:[NSString stringWithFormat:L(@"SendFailed"), message]];
		}
	}
}

- (void)sendButtonClicked:(UIPushButton*)button {
	// get message
	NSString* msg = [_inputField text];
	if(msg == nil || [msg isEmpty])
		return;
	else
		[msg retain];
	
	// add message
	[self _appendString:msg];
	
	// clear input field
	[_inputField setText:@""];
	
	// begin sending
	[_client callIMService:[msg autorelease]
					   obj:[self _model]
				  callback:self];
}

- (void)faceButtonClicked:(UIButtonBarButton*)button {
	if(_selectedTag == _kTagFace || _waitingCount > 0)
		return;
	
	[self _showFaceChooser];
	_selectedTag = _kTagFace;
}

- (void)keyboardButtonClicked:(UIButtonBarButton*)button {
	if(_selectedTag == _kTagKeyboard || _waitingCount > 0)
		return;
	
	[self _showKeyboard];
	_selectedTag = _kTagKeyboard;
}

- (void)hideButtonClicked:(UIButtonBarButton*)button {
	if(_selectedTag == _kTagHide || _waitingCount > 0)
		return;
	
	[self _hide];
	_selectedTag = _kTagHide;
}

#pragma mark -
#pragma mark message manager delegate

- (BOOL)shouldInsertPacket:(NSDictionary*)dict forUser:(User*)user {
	return YES;
}

- (BOOL)shouldInsertPacket:(NSDictionary*)dict forCluster:(Cluster*)cluster {
	return YES;
}

#pragma mark -
#pragma mark navigation bar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button {
	switch(button) {
		case kNavButtonLeft:
			[self _back];
			break;
		case kNavButtonRight:
			[self hideButtonClicked:nil];
			[_uiController transitTo:kUIUnitChatLog
							   style:kTransitionStyleLeftSlide 
								data:[NSMutableDictionary dictionaryWithObjectsAndKeys:[self _model], kDataKeyChatModel, [self name], kDataKeyFrom, _groupManager, kDataKeyGroupManager, nil]];
			break;
	}
}

#pragma mark -
#pragma mark editing delegate

- (BOOL)keyboardInput:(id)field shouldInsertText:(NSString*)text isMarkedText:(int)b {
	if([text characterAtIndex:0] == '\n') {
		return NO;
	}
	
	return YES;
}

#pragma mark -
#pragma mark animation delegate

- (void)animator:(UIAnimator*)animator stopAnimation:(UIAnimation*)animation {
	_waitingCount--;
}

#pragma mark -
#pragma mark table data source and delegate

- (UITableCell*)table:(UITable*)table cellForRow:(int)row column:(UITableColumn*)col {
	return [_cells objectAtIndex:row];
}

- (int)numberOfRowsInTable:(UITable*)table {
	return [_msgModels count];
}

- (float)table:(UITable*)table heightForRow:(int)row {
	return [(BubbleIMCell*)[_cells objectAtIndex:row] height];
}

- (BOOL)table:(UITable*)table showDisclosureForRow:(int)row {
	return NO;
}

#pragma mark -
#pragma mark image provider

- (UIImage*)imageAtIndex:(int)index {
	return [UIImage imageNamed:[NSString stringWithFormat:@"face%u.png", index]];
}

- (NSString*)titleAtIndex:(int)index {
	return L([NSString stringWithFormat:@"DefaultFace.%u", index]);
}

- (BOOL)shouldShowTitle {
	return YES;
}

- (int)imageCount {
	return 105;
}

#pragma mark -
#pragma mark image chooser delegate

- (void)imageClicked:(int)index {
	if(index >= 0 && index < USEABLE_FACE_COUNT) {
		NSRange sel = [_inputField selectionRange];
		NSString* text = [_inputField text];
		NSString* front = [text substringToIndex:sel.location];
		NSString* end = [text substringFromIndex:(sel.location + sel.length)];
		text = [NSString stringWithFormat:@"%@/%@%@", front, s_shortcut[index], end];
		[_inputField setText:text];
		sel.location = sel.location + [s_shortcut[index] length] + 1;
		sel.length = 0;
		[_inputField setSelectionRange:sel];
	}
}

@end
