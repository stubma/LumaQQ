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

#import "UILogin.h"
#import "QQClient.h"
#import <UIKit/UINavigationItem.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UIFrameAnimation.h>
#import <UIKit/UIAnimator.h>
#import "UIController.h"
#import "NSData-Base64.h"
#import "NSData-MD5.h"
#import "PasswordVerifyReplyPacket.h"
#import "GroupDataOpPacket.h"
#import "UIUtil.h"
#import "LocalizedStringTool.h"
#import "GetFriendGroupJob.h"
#import "GroupManager.h"

#define _kRowRefreshButton 4
#define _kRowOKButton 6

@implementation UILogin

- (void) dealloc {
	[_box release];
	[_view release];
	[_hint release];
	[_connectData release];
	[_client release];
	[_packet release];
	[_imageCell release];
	[_textCell release];
	[_refreshCell release];
	[_okCell release];
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitLogin;
}

- (void)begin:(UIController*)uiController {
	// save controller
	_uiController = uiController;
	
	// push navigation item
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:L(@"Login")] autorelease];
	[[uiController navBar] pushNavigationItem:item];
	
	// show button
	[[uiController navBar] showButtonsWithLeftTitle:nil rightTitle:L(@"Cancel")];
	
	// set delegate
	[[uiController navBar] setDelegate:self];
}

- (void)stop:(UIController*)uiController {
	[[[uiController navBar] navigationItems] removeAllObjects];
	[[uiController navBar] setDelegate:nil];
}

- (UIView*)view {
	if(_box == nil) {
		[UIKeyboard initImplementationNow];
		
		// create box
		CGRect bound = [_uiController clientRect];
		_box = [[UIBox alloc] initWithFrame:bound];
		
		// create content view
		_view = [[UIView alloc] initWithFrame:bound];
		[_box setContentView:_view];
		
		// create hint label
		CGRect hintBound = CGRectMake(10, 0, bound.size.width - 40, 40);
		_hint = [[UITextLabel alloc] initWithFrame:hintBound];
		
		// create font
		GSFontRef font = GSFontCreateWithName("Verdana", kGSFontTraitBold, 16.0f);
		
		// create icon view
		UIImage* icon = [UIImage imageNamed:kImageOnlineIcon];
		CGSize size = [icon size];
		CGRect iconBound = CGRectMake((bound.size.width - size.width) / 2.0f, hintBound.origin.y + hintBound.size.height + 20.0f, size.width, size.height);
		UIImageView* iconView = [[[UIImageView alloc] initWithImage:icon] autorelease];
		[iconView setFrame:iconBound];
		
		// product label
		CGRect labelBound = CGRectMake(10.0f, iconBound.origin.y + iconBound.size.height + 5.0f, bound.size.width - 20.0f, 30.0f);
		UITextLabel* productLabel = [[[UITextLabel alloc] initWithFrame:labelBound] autorelease];
		[productLabel setCentersHorizontally:YES];
		[productLabel setText:L(@"LumaQQ")];
		[productLabel setFont:font];
		
		// build label
		labelBound.origin.y += labelBound.size.height;
		UITextLabel* buildLabel = [[[UITextLabel alloc] initWithFrame:labelBound] autorelease];
		[buildLabel setCentersHorizontally:YES];
		[buildLabel setText:[NSString stringWithFormat:L(@"Build"), kLumaQQVersionString]];
		[buildLabel setFont:font];
		
		// author label
		labelBound.origin.y += labelBound.size.height;
		UITextLabel* authorLabel = [[[UITextLabel alloc] initWithFrame:labelBound] autorelease];
		[authorLabel setCentersHorizontally:YES];
		[authorLabel setText:L(@"Author")];
		[authorLabel setFont:font];
		
		// sponsor label
		labelBound.origin.y += labelBound.size.height;
		UITextLabel* sponsorLabel = [[[UITextLabel alloc] initWithFrame:labelBound] autorelease];
		[sponsorLabel setCentersHorizontally:YES];
		[sponsorLabel setText:L(@"Sponsor")];
		[sponsorLabel setFont:font];
		
		// artwork label
		labelBound.origin.y += labelBound.size.height;
		labelBound.size.height *= 2;
		UITextLabel* artworkLabel = [[[UITextLabel alloc] initWithFrame:labelBound] autorelease];
		[artworkLabel setCentersHorizontally:YES];
		[artworkLabel setText:L(@"Artwork")];
		[artworkLabel setWrapsText:YES];
		[artworkLabel setFont:font];
		
		// thanks label
		labelBound.origin.y += labelBound.size.height;
		labelBound.size.height /= 2;
		UITextLabel* thanksLabel = [[[UITextLabel alloc] initWithFrame:labelBound] autorelease];
		[thanksLabel setCentersHorizontally:YES];
		[thanksLabel setText:L(@"ThanksDonator")];
		[thanksLabel setFont:font];
		
		// special thanks label
		labelBound.origin.y += labelBound.size.height;
		labelBound.size.height = bound.size.height - labelBound.origin.y;
		UITextLabel* specialThanksLabel = [[[UITextLabel alloc] initWithFrame:labelBound] autorelease];
		[specialThanksLabel setCentersHorizontally:YES];
		[specialThanksLabel setWrapsText:YES];
		[specialThanksLabel setText:L(@"SpecialThanks")];
		[specialThanksLabel setFont:font];
		
		// add to view
		[_view addSubview:_hint];
		[_view addSubview:iconView];
		[_view addSubview:productLabel];
		[_view addSubview:buildLabel];
		[_view addSubview:authorLabel];
		[_view addSubview:sponsorLabel];
		[_view addSubview:artworkLabel];
		[_view addSubview:thanksLabel];
		[_view addSubview:specialThanksLabel];
		
		// release
		CFRelease(font);
	}
	
	return _box;
}

- (void)refresh:(NSMutableDictionary*)data {
	// if data is nil, return to account manage, however, it should not be nil
	if(data == nil)
		[_uiController transitTo:kUIUnitAccountManage style:kTransitionStyleRightSlide data:nil];
	else {		
		// save connection data
		[data retain];
		[_connectData release];
		_connectData = data;
		
		// start
		[self _start];
	}
}

- (void)_start {
	// start progress indicator
	[UIApp setStatusBarShowsProgress:YES];
	
	// create connection
	NSString* server = [_connectData objectForKey:kDataKeyServer];
	NSString* protocol = [_connectData objectForKey:kDataKeyProtocol];
	NSNumber* port = [_connectData objectForKey:kDataKeyPort];
	BOOL bUDP = [protocol isEqualToString:kQQProtocolUDP];
	NSNumber* n = [_connectData objectForKey:kDataKeyEnableHTTPProxy];
	BOOL bHTTPProxy = n == nil ? NO : [n boolValue];
	NSString* proxyServer = [_connectData objectForKey:kDataKeyHTTPProxyServer];
	n = [_connectData objectForKey:kDataKeyHTTPProxyPort];
	int proxyPort = n == nil ? 0 : [n intValue];
	NSString* proxyUsername = [_connectData objectForKey:kDataKeyHTTPProxyUsername];
	NSString* proxyPassword = [_connectData objectForKey:kDataKeyHTTPProxyPassword];
	QQConnection* connection = [[QQConnection alloc] initWithServer:server
														   port:[port intValue]
													   protocol:protocol
													  proxyType:((bHTTPProxy && !bUDP) ? kQQProxyHTTP : kQQProxyNone)
													proxyServer:(proxyServer == nil ? @"" : proxyServer)
													  proxyPort:proxyPort
												  proxyUsername:(proxyUsername == nil ? @"" : proxyUsername)
												  proxyPassword:(proxyPassword == nil ? @"" : proxyPassword)];
	
	// create qq client
	_client = [[QQClient alloc] initWithConnection:connection];
	[_client addQQListener:self];
	
	// get qq number
	NSNumber* qq = [_connectData objectForKey:kDataKeyQQ];
	
	// get password md5 and key
	NSString* base64 = [_connectData objectForKey:kDataKeyPassword];
	const char* bytes = [base64 UTF8String];
	NSData* pwdMd5 = [NSData dataWithBytes:bytes length:strlen(bytes)];
	pwdMd5 = [pwdMd5 base64Decode];
	NSData* pwdKey = [pwdMd5 MD5];
	
	// login hidden?
	NSNumber* loginHidden = [_connectData objectForKey:kDataKeyLoginHidden];
	char loginStatus = [loginHidden boolValue] ? kQQStatusHidden : kQQStatusOnline;
	
	// create qq user
	QQUser* user = [[QQUser alloc] initWithQQ:[qq unsignedIntValue] passwordKey:pwdKey passwordMd5:pwdMd5];
	[user setLoginStatus:loginStatus];
	[_client setQQUser:user];
	[user release];
	
	// start to login
	[_client start];
	
	// release
	[connection release];
}

- (void)_stop {
	// destory client
	[_client shutdown];
	[_client release];
	_client = nil;
	
	// stop progress indicator
	[UIApp setStatusBarShowsProgress:NO];
}

- (void)_createVerifyBox {
	if(_verifyBox == nil) {
		// red color
		float redComponents[] = {
			1.0, 0, 0, 1.0
		};
		
		// color space
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		
		// get verify box bound
		CGRect bound = [_view bounds];
		float hintHeight = [_hint bounds].size.height;
		bound.origin.y += hintHeight;
		bound.size.height -= hintHeight;
		bound.origin.y += bound.size.height;
		
		// create box
		_verifyBox = [[UIPreferencesTable alloc] initWithFrame:bound];
		
		// create image cell
		_imageCell = [[UIPreferencesControlTableCell alloc] init];
		[_imageCell setTitle:L(@"VerifyImage")];
		_verifyImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(150, 10, 100, 20)] autorelease];
		[_imageCell setControl:_verifyImageView];
		[_imageCell setShowSelection:NO];
		
		// text cell
		_textCell = [[UIPreferencesTextTableCell alloc] init];
		[_textCell setTitle:L(@"PleaseInput")];
		[_textCell setEnabled:YES];
		[[_textCell textField] setAutoCorrectionType:kAutoCorrectionNo];
		
		// create refresh button
		_refreshCell = [[PushButtonTableCell alloc] initWithTitle:L(@"RefreshImage")
													  upImageName:kImageOrangeButtonUp
													downImageName:kImageOrangeButtonDown];
		[[_refreshCell control] addTarget:self action:@selector(refreshImageButtonClicked:) forEvents:kUIMouseUp];
		
		// create ok button
		_okCell = [[PushButtonTableCell alloc] initWithTitle:L(@"OK")
												 upImageName:kImageGreenButtonUp
											   downImageName:kImageGreenButtonDown];
		[[_okCell control] addTarget:self action:@selector(okButtonClicked:) forEvents:kUIMouseUp];
		
		// init table
		[_verifyBox setDataSource:self];
		[_verifyBox reloadData];
		
		// add verify box
		[_view addSubview:_verifyBox];
	}
}

- (void)_cancel {
	// remove self from listeners
	[_client removeQQListener:self];
	
	// go back to account manage
	[self _hideVerifyBox];
	[_connectData release];
	_connectData = nil;
	[_uiController transitTo:kUIUnitAccountManage style:kTransitionStyleRightSlide data:nil];
}

- (void)_gotoMain {
	// remove self from listeners
	[_client removeQQListener:self];
	
	[_connectData setObject:_client forKey:kDataKeyClient];
	[_client release];
	_client = nil;
	if(_cachedMessages != nil) {
		[_connectData setObject:_cachedMessages forKey:kDataKeyCachedMessages];
		[_cachedMessages autorelease];
		_cachedMessages = nil;
	}
	if(_cachedSystemNotifications != nil) {
		[_connectData setObject:_cachedSystemNotifications forKey:kDataKeyCachedSystemNotifications];
		[_cachedSystemNotifications autorelease];
		_cachedSystemNotifications = nil;
	}
	[_connectData autorelease];
	[_uiController transitTo:kUIUnitMain style:kTransitionStyleLeftSlide data:_connectData];
	_connectData = nil;
}

- (void)_refreshVerifyImage:(GetLoginTokenReplyPacket*)packet {
	// save ref
	[packet retain];
	[_packet release];
	_packet = packet;
	
	// reset image and reload table
	UIImage* image = [[[UIImage alloc] initWithData:[packet puzzleData] cache:NO] autorelease];
	CGRect frame = [_verifyImageView frame];
	frame.size = [image size];
	[_verifyImageView setFrame:frame];
	[_verifyImageView setImage:image];
	[_refreshCell setEnabled:YES];
	[_okCell setEnabled:YES];
	[_verifyBox reloadData];
}

- (void)_showVerifyBox:(GetLoginTokenReplyPacket*)packet {
	NSMutableArray* animations = [NSMutableArray arrayWithCapacity:1];
	
	// create verify box
	[self _createVerifyBox];
	[self _refreshVerifyImage:packet];
	
	// create animation of box
	CGRect startFrame = [_verifyBox frame];
	CGRect endFrame = CGRectMake(startFrame.origin.x, startFrame.origin.y - startFrame.size.height, startFrame.size.width, startFrame.size.height);
	UIFrameAnimation* animation = [[[UIFrameAnimation alloc] initWithTarget:_verifyBox] autorelease];
	[animation setStartFrame:startFrame];
	[animation setEndFrame:endFrame];
	[animation setDelegate:self];
	[animation setAnimationCurve:kUIAnimationCurveLinear];
	[animations addObject:animation];
	
	// start animation
	_show = YES;
	[[UIAnimator sharedAnimator] addAnimations:animations
								  withDuration:0.25
										 start:YES];
}

- (void)_hideVerifyBox {
	if(_verifyBox != nil) {
		NSMutableArray* animations = [NSMutableArray arrayWithCapacity:1];
		
		// create animation of box
		CGRect startFrame = [_verifyBox frame];
		CGRect endFrame = CGRectMake(startFrame.origin.x, startFrame.origin.y + startFrame.size.height, startFrame.size.width, startFrame.size.height);
		UIFrameAnimation* animation = [[[UIFrameAnimation alloc] initWithTarget:_verifyBox] autorelease];
		[animation setStartFrame:startFrame];
		[animation setEndFrame:endFrame];
		[animation setDelegate:self];
		[animation setAnimationCurve:kUIAnimationCurveLinear];
		[animations addObject:animation];
		
		// start animation
		_show = NO;
		[[UIAnimator sharedAnimator] addAnimations:animations
									  withDuration:0.25
											 start:YES];
	}
}

#pragma mark -
#pragma mark alert sheet delegate

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
	[self _cancel];
}

#pragma mark -
#pragma mark animation delegate

- (void)animator:(UIAnimator*)animator stopAnimation:(UIAnimation*)animation {
	if (_show) {
		[(UITextField*)[_textCell textField] becomeFirstResponder];
	} else {
		// hide keyboard
		if([_verifyBox keyboardVisible])
			[_verifyBox setKeyboardVisible:NO animated:YES];
		
		// remove verify box
		if(_verifyBox != nil) {
			[_verifyBox removeFromSuperview];
			[_verifyBox release];
			_verifyBox = nil;
		}
	}
}

#pragma mark -
#pragma mark navigation bar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button {
	switch(button) {
		case kNavButtonLeft:
			break;
		case kNavButtonRight:		
			[self _stop];
			[self _cancel];
			break;
	}
}

#pragma mark -
#pragma mark preference table delegate and data source

-(int)numberOfGroupsInPreferencesTable:(UIPreferencesTable*)aTable {
	return 3;
}

-(int)preferencesTable:(UIPreferencesTable*)aTable numberOfRowsInGroup:(int)group {
	switch(group) {
		case 0: // image and input
			return 2;
		case 1: // refresh button
			return 1;
		case 2: // ok button
			return 1;
		default:
			return 0;
	}
}

-(float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed {
	switch(group) {
		case 0:
			switch(row) {
				case 0: // verify image cell
					return [_verifyImageView bounds].size.height + 20;
				default:
					return proposed;
			}
			break;
		default:
			return proposed;
	}
}

-(BOOL)preferencesTable:(UIPreferencesTable*)aTable isLabelGroup:(int)group {
	return NO;
}

-(UIPreferencesTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForRow:(int)row inGroup:(int)group {
	switch(group) {
		case 0:
			switch(row) {
				case 0:
					return _imageCell;
				case 1:
					return _textCell;
			}
			break;
		case 1:
			switch(row) {
				case 0:
					return _refreshCell;
			}
			break;
		case 2:
			switch(row) {
				case 0:
					return _okCell;
			}
			break;
	}
	return nil; 
}

- (void)refreshImageButtonClicked:(UIPushButton*)button {
	// disable refresh and ok
	[_refreshCell setEnabled:NO];
	[_okCell setEnabled:NO];
	
	// show progress
	[UIApp setStatusBarShowsProgress:YES];
	
	// refresh
	[_hint setText:L(@"HintRefreshImage")];
	[_client refreshVerifyCodeImage:[_packet token]];
}

- (void)okButtonClicked:(UIPushButton*)button {
	// show progress
	[UIApp setStatusBarShowsProgress:YES];
	
	// hide verify box
	[self _hideVerifyBox];
	
	// submit verify code
	[_hint setText:L(@"HintGetLoginToken")];
	[_client submitVerifyCode:[_packet token]
				   verifyCode:[_textCell value]];
}

- (void)getFriendGroupJobTerminated:(JobController*)jobController {
	// goto main UI
	[jobController autorelease];
	[UIApp setStatusBarShowsProgress:NO];
	[[_connectData objectForKey:kDataKeyGroupManager] sortAll];
	[self _gotoMain];
}

#pragma mark -
#pragma mark qq event handle

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;

	switch([event eventId]) {
		case kQQEventNetworkStarted:
			ret = [self handleNetworkStarted:event];
			break;
		case kQQEventNetworkConnectionEstablished:
			ret = [self handleConnectionEstablished:event];
			break;
		case kQQEventNetworkError:
			ret = [self handleNetworkError:event];
			break;
		case kQQEventSelectServerOK:
			ret = [self handleSelectServerOK:event];
			break;
		case kQQEventGetServerTokenOK:
			ret = [self handleGetServerTokenOK:event];
			break;
		case kQQEventGetLoginTokenOK:
			ret = [self handleGetLoginTokenOK:event];
			break;
		case kQQEventPasswordVerifyOK:
			ret = [self handlePasswordVerifyOK:event];
			break;
		case kQQEventNeedVerifyCode:
			ret = [self handleNeedVerifyCode:event];
			break;
		case kQQEventTimeoutBasic:
			ret = [self handleTimeout:event];
			break;
		case kQQEventLoginOK:
			ret = [self handleLoginOK:event];
			break;
		case kQQEventLoginFailed:
			ret = [self handleLoginFailed:event];
			break;
		case kQQEventPasswordVerifyFailed:
			ret = [self handlePasswordVerifyFailed:event];
			break;
		case kQQEventGetFriendGroupOK:
			ret = [self handleGetFriendGroupOK:event];
			break;
		case kQQEventDownloadGroupNamesOK:
			ret = [self handleDownloadGroupNameOK:event];
			break;
		case kQQEventReceivedIM:
			ret = [self handleReceivedIM:event];
			break;
		case kQQEventReceivedSystemNotification:
			ret = [self handleReceivedSystemNotification:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleNetworkStarted:(QQNotification*)event {
	[_hint setText:L(@"HintConnect")];
	return YES;
}

- (BOOL)handleConnectionEstablished:(QQNotification*)event {
	if([event connectionId] == [_client mainConnectionId]) {
		[_hint setText:L(@"HintSelectServer")];
	}		
	return NO;
}

- (BOOL)handleNetworkError:(QQNotification*)event {
	if([event connectionId] == [_client mainConnectionId]) {
		[_hint setText:L(@"HintConnect")];
		[self _stop];
		[self _start];
	}
	return NO;
}

- (BOOL)handleSelectServerOK:(QQNotification*)event {
	[_hint setText:L(@"HintGetServerToken")];
	return YES;
}

- (BOOL)handleGetServerTokenOK:(QQNotification*)event {
	[_hint setText:L(@"HintGetLoginToken")];
	return YES;
}

- (BOOL)handleGetLoginTokenOK:(QQNotification*)event {
	[_hint setText:L(@"HintVerifyPassword")];
	return YES;
}

- (BOOL)handlePasswordVerifyOK:(QQNotification*)event {
	[_hint setText:L(@"HintLogin")];
	return YES;
}

- (BOOL)handleNeedVerifyCode:(QQNotification*)event {
	// stop progress
	[UIApp setStatusBarShowsProgress:NO];
	
	// set hint
	[_hint setText:L(@"HintNeedVerify")];
	
	// get packet
	GetLoginTokenReplyPacket* packet = (GetLoginTokenReplyPacket*)[event object];
	
	if(_verifyBox != nil)
		[self _refreshVerifyImage:packet];
	else
		[self _showVerifyBox:packet];
	return YES;
}

- (BOOL)handleTimeout:(QQNotification*)event {
	OutPacket* packet = (OutPacket*)[event outPacket];
	
	switch([packet command]) {
		case kQQCommandGetLoginToken:
		case kQQCommandPasswordVerify:
		case kQQCommandLogin:
			[_hint setText:L(@"HintConnect")];
			[self _stop];
			[self _start];
			return YES;
		case kQQCommandGetFriendGroup:
		case kQQCommandGetFriendList:
			[_client sendPacket:packet];
			return YES;
		case kQQCommandGroupDataOp:
		{
			GroupDataOpPacket* gop = (GroupDataOpPacket*)packet;
			switch([gop subCommand]) {
				case kQQSubCommandDownloadGroupName:
					[_client sendPacket:packet];
					return YES;
			}
			return NO;
		}
		default:
			return NO;
	}
}

- (BOOL)handleLoginOK:(QQNotification*)event {
	[_hint setText:L(@"HintLoginSuccess")];
	
	// load groups
	NSNumber* qq = [_connectData objectForKey:kDataKeyQQ];
	GroupManager* gm = [[[GroupManager alloc] initWithQQ:[qq unsignedIntValue]] autorelease];
	[_connectData setObject:gm forKey:kDataKeyGroupManager];
	[gm loadGroups];
	
	// check friend count
	if([gm friendCount] == 0) {
		// if zero, downloading friends
		[_hint setText:L(@"HintDownloadGroupName")];
		
		// install jobs
		JobController* jobController = [[JobController alloc] initWithContext:[NSDictionary dictionaryWithObjectsAndKeys:gm, kDataKeyGroupManager, _client, kDataKeyClient, nil]];
		[jobController setTarget:self];
		[jobController setAction:@selector(getFriendGroupJobTerminated:)];
		[jobController startJob:[[[GetFriendGroupJob alloc] initWithGroupManager:gm] autorelease]];
	} else {
		// goto main UI
		[UIApp setStatusBarShowsProgress:NO];
		[self _gotoMain];
	}
		
	return YES;
}

- (BOOL)handleLoginFailed:(QQNotification*)event {
	// auto restart
	[_hint setText:L(@"HintConnect")];
	[self _stop];
	[self _start];
	
	return YES;
}

- (BOOL)handlePasswordVerifyFailed:(QQNotification*)event {
	// stop progress
	[UIApp setStatusBarShowsProgress:NO];
	
	// show alert
	PasswordVerifyReplyPacket* packet = (PasswordVerifyReplyPacket*)[event object];
	[UIUtil showWarning:[packet errorMessage] title:L(@"HintLoginFailed") delegate:self];
	
	return YES;
}

- (BOOL)handleGetFriendGroupOK:(QQNotification*)event {
	[_hint setText:L(@"HintDownloadFriend")];	
	return NO;
}

- (BOOL)handleDownloadGroupNameOK:(QQNotification*)event {
	[_hint setText:L(@"HintDownloadFriendGroup")];
	return NO;
}

- (BOOL)handleReceivedIM:(QQNotification*)event {
	if(_cachedMessages == nil)
		_cachedMessages = [[NSMutableArray array] retain];
	[_cachedMessages addObject:[event object]];
	return YES;
}

- (BOOL)handleReceivedSystemNotification:(QQNotification*)event {
	if(_cachedSystemNotifications == nil)
		_cachedSystemNotifications = [[NSMutableArray array] retain];
	[_cachedSystemNotifications addObject:[event object]];
	return YES;
}

@end
