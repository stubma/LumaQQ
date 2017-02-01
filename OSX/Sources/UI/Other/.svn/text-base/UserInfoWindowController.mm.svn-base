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

#import "Constants.h"
#import "UserInfoWindowController.h"
#import "MainWindowController.h"
#import "PreferenceManager.h"
#import "FileTool.h"
#import "AlertTool.h"
#import "AuthInfoOpReplyPacket.h"
#import "ModifyInfoReplyPacket.h"
#import "ModifyInfoPacket.h"
#import "SignatureOpPacket.h"
#import "AuthQuestionOpReplyPacket.h"
#import "AuthQuestionOpPacket.h"
#import "PrivacyOpPacket.h"
#import "ClusterGetCardPacket.h"
#import "WindowRegistry.h"
#import "LocalizedStringTool.h"
#import "NSString-Validate.h"

// workflow name
#define _kWorkflowGetInfos @"GetInfos"
#define _kWorkflowModifyInfos @"ModifyInfos"
#define _kWorkflowGetCard @"GetCard"
#define _kWorkflowModifyCard @"ModifyCard"

// workflow unit name
#define _kWorkflowUnitGetAuthInfo @"GetAuthInfo"
#define _kWorkflowUnitGetMyQuestion @"GetMyQuestion"
#define _kWorkflowUnitModifyQuestion @"ModifyQuestion"
#define _kWorkflowUnitGetClusterNameCard @"GetClusterNameCard"
#define _kWorkflowUnitGetUserInfo @"GetUserInfo"
#define _kWorkflowUnitModifyInfo @"ModifyInfo"
#define _kWorkflowUnitSetSearchMeByQQ @"SetSearchMeByQQ"
#define _kWorkflowUnitModifySignature @"ModifySignature"
#define _kWorkflowUnitDeleteSignature @"DeleteSignature"
#define _kWorkflowUnitGetSignature @"GetSignature"
#define _kWorkflowUnitGetLevel @"GetLevel"
#define _kWorkflowUnitModifyClusterNameCard @"ModifyClusterNameCard"
#define _kWorkflowUnitGetPrivacy @"GetPrivacy"

// sheet type
#define _kSheetOperationFinished 0

static const int headMap[][40] = {
	// start from 1, first element is count
	// Male
	{
		30,
		5,  7,  10, 14, 15, 16, 17, 28,
		36, 37, 43, 44, 46, 50, 52, 53,
		54, 60, 61, 63, 68, 72, 74, 77,
		79, 80, 82, 85, 94, 95
	},

	// Female
	{
		29, 
		6,  9,  12, 20, 29, 30, 34, 38,
		40, 45, 47, 49, 51, 55, 57, 58,
		62, 67, 70, 75, 78, 81, 83, 84, 
		86, 87, 88, 89, 90
	},

	// Pet
	{
		36,
		1,  2,  3,  4,  8,  11, 13, 17,
		18, 19, 21, 22, 23, 24, 25, 26,
		31, 32, 33, 35, 39, 41, 42, 48,
		56, 59, 64, 65, 66, 69, 71, 73,
		76, 91, 92, 93
	},

	// QQ Tang
	{
		5,
		96, 97, 98, 99, 100
	},
	
	// QQ fantasy
	{
		5,
		113, 114, 115, 116, 117
	},

	// QQ Sonic
	{
		5,
		101, 102, 103, 104, 105
	},

	// QQ HuaXia
	{
		17,
		106, 107, 108, 109, 110, 111, 112, 118, 
		119, 120, 121, 122, 123, 124, 125, 126,
		127
	}
};

@implementation UserInfoWindowController

- (id)initWithMainWindowController:(MainWindowController*)mainWindowController user:(User*)user {
	return [self initWithMainWindowController:mainWindowController user:user cluster:nil];
}

- (id)initWithMainWindowController:(MainWindowController*)mainWindowController user:(User*)user cluster:(Cluster*)cluster {
	self = [super initWithWindowNibName:@"UserInfo"];
	if(self != nil) {
		m_mainWindowController = [mainWindowController retain];
		m_user = [user retain];
		if(cluster)
			m_cluster = [cluster retain];
		m_sheetType = -1;
	}
	return self;
}

- (void) dealloc {
	[m_mainWindowController release];
	[m_user release];
	if(m_qqShowDownloader) {
		[m_qqShowDownloader cancel];
		[m_qqShowDownloader release];
		m_qqShowDownloader = nil;
	}
	if(m_tempInfo)
		[m_tempInfo release];
	if(m_authInfo)
		[m_authInfo release];
	[super dealloc];
}

- (void)windowDidLoad {
	// remove cluste name card if cluster is nil
	if(m_cluster == nil || [self isMe])
		[m_tabMain removeTabViewItem:[m_tabMain tabViewItemAtIndex:4]];
	
	// set button image
	[m_btnRefreshQQShow setImage:[NSImage imageNamed:kImageRefresh]];
	[m_headControl setEnabled:[self isMe]];
	
	// refresh combo box
	[m_cbProvince reloadData];
	[m_cbCity reloadData];
	
	//
	// init qq show panel
	//
	
	[self reloadQQShow];
	
	//
	// init other
	//
	
	[self reloadInfo];
	
	// init window
	[[self window] setTitle:[NSString stringWithFormat:L(@"LQTitleWindow", @"UserInfo"), [m_user QQ]]];
	
	// create workflow
	m_moderator = [[WorkflowModerator alloc] initWithName:_kWorkflowGetInfos dataSource:self];
	[self buildWorkflow:_kWorkflowGetInfos];
	
	// add listener to alert notification
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleHeadSelectorWindowWillClose:)
												 name:NSWindowWillCloseNotification
											   object:nil];
	
	// start
	m_showAlert = NO;
	[m_moderator start:[m_mainWindowController client]];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	if(m_moderator) {
		[m_moderator cancel];
		[m_moderator release];
		m_moderator = nil;
	}
	[[m_mainWindowController windowRegistry] unregisterUserInfoWindow:[m_user QQ]];
	if(m_headSelector)
		[m_headSelector close];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSWindowWillCloseNotification 
												  object:nil];
	[self release];
}

- (void)windowDidEndSheet:(NSNotification *)aNotification {
	if([aNotification object] != [self window])
		return;
	
	switch(m_sheetType) {
		case _kSheetOperationFinished:
			[self close];
			break;
	}
	
	m_sheetType = -1;
}

#pragma mark -
#pragma mark helper

- (void)handleHeadSelectorWindowWillClose:(NSNotification*)notification {
	if(m_headSelector) {
		if([notification object] == [m_headSelector window])
			m_headSelector = nil;
	}
}

- (void)reloadInfo {
	//
	// init basic info panel
	//
	
	[m_txtQQ setStringValue:[NSString stringWithFormat:@"%u", [m_user QQ]]];
	[m_txtNick setStringValue:[m_user nick]];
	[m_txtSignature setString:[m_user signature]];
	[m_levelControl setLevel:[m_user level]];
	[m_levelControl setUpgradeDays:[m_user upgradeDays]];
	[m_headControl setOwner:[[m_mainWindowController me] QQ]];
	[m_headControl setShowStatus:NO];
	[m_headControl setObjectValue:m_user];
	[m_txtName setStringValue:[m_user name]];
	[m_txtAge setStringValue:[NSString stringWithFormat:@"%d", [m_user age]]];
	if([m_user contact]) {
		[m_cbGender setStringValue:[[m_user contact] gender]];
		[m_txtCollege setStringValue:[[m_user contact] college]];
		[m_cbOccupation setStringValue:[[m_user contact] occupation]];
		[m_txtHomepage setStringValue:[[m_user contact] homepage]];
		[m_txtIntroduction setString:[[m_user contact] introduction]];
		[m_pbHoroscope selectItemAtIndex:[[m_user contact] horoscope]];
		[m_pbZodiac selectItemAtIndex:[[m_user contact] zodiac]];
		[m_pbBlood selectItemAtIndex:[[m_user contact] blood]];
	}
	
	//
	// init contact panel
	//
	
	if([m_user contact]) {
		[m_cbCountry setStringValue:[[m_user contact] country]];
		[m_cbProvince setStringValue:[[m_user contact] province]];
		[m_cbCity setStringValue:[[m_user contact] city]];
		[m_txtZipcode setStringValue:[[m_user contact] zipcode]];
		[m_pbVisibility selectItemAtIndex:[[m_user contact] contactVisibility]];
		[m_txtEmail setStringValue:[[m_user contact] email]];
		[m_txtAddress setStringValue:[[m_user contact] address]];
		[m_txtMobile setStringValue:[[m_user contact] mobile]];
		[m_txtTelephone setStringValue:[[m_user contact] telephone]];
	}
	
	//
	// init auth panel
	//
	
	if([m_user contact]) 
		[m_matrixAuthType selectCellAtRow:[[m_user contact] authType] column:0];
	[self onAuthTypeChanged:self];
}

- (void)reloadQQShow {
	NSString* qqShowPath = [FileTool getQQShowFilePath:[self myQQ] qq:[m_user QQ]];
	if([FileTool isFileExist:qqShowPath]) {
		NSImage* img = [[NSImage alloc] initWithContentsOfFile:qqShowPath];
		[m_ivQQShow setImage:img];
		[m_ivQQShow setAnimates:YES];
		[img release];
	}
}

- (BOOL)isMe {
	return [self myQQ] == [m_user QQ];
}

- (UInt32)myQQ {
	return [[m_mainWindowController me] QQ];
}

- (NSString*)titleOfCancelUpdateButton {
	if([self isMe])
		return L(@"LQCancel");
	else
		return L(@"LQUpdate");
}

- (NSString*)titleOfApplyCloseButton {
	if([self isMe])
		return L(@"LQApply");
	else
		return L(@"LQClose");
}

- (BOOL)isNameCardEditable {
	return [[m_mainWindowController me] isSuperUser:m_cluster] && [m_user isManaged:m_cluster];
}

- (void)buildWorkflow:(NSString*)name {
	[m_moderator reset:name];
	
	if([_kWorkflowGetInfos isEqualToString:name]) {
		[m_moderator addUnit:_kWorkflowUnitGetUserInfo failEvent:0];
		
		// get signature or level of a stranger always timeout, so I have to check it here
		if([[m_mainWindowController groupManager] isUserFriendly:m_user]) {
			[m_moderator addUnit:_kWorkflowUnitGetSignature failEvent:kQQEventGetSignatureFailed];
			[m_moderator addUnit:_kWorkflowUnitGetLevel failEvent:0];
		}

		[m_moderator addUnit:_kWorkflowUnitGetMyQuestion failEvent:0];
		[m_moderator addUnit:_kWorkflowUnitGetClusterNameCard failEvent:kQQEventClusterGetCardFailed];
	} else if([_kWorkflowModifyInfos isEqualToString:name]) {
		[m_moderator addUnit:_kWorkflowUnitGetAuthInfo failEvent:0 critical:YES];
		[m_moderator addUnit:_kWorkflowUnitModifyInfo failEvent:kQQEventModifyInfoFailed critical:YES];
		if([[m_txtSignature string] isEmpty])
			[m_moderator addUnit:_kWorkflowUnitDeleteSignature failEvent:kQQEventDeleteSignatureFailed critical:YES];
		else
			[m_moderator addUnit:_kWorkflowUnitModifySignature failEvent:kQQEventModifySigatureFailed critical:YES];
		[m_moderator addUnit:_kWorkflowUnitSetSearchMeByQQ failEvent:kQQEventPrivacyOpFailed critical:YES];
		[m_moderator addUnit:_kWorkflowUnitModifyQuestion failEvent:kQQEventModifyQuestionFailed critical:YES];
	} else if([_kWorkflowGetCard isEqualToString:name])
		[m_moderator addUnit:_kWorkflowUnitGetClusterNameCard failEvent:kQQEventClusterGetCardFailed critical:YES];
	else if([_kWorkflowModifyCard isEqualToString:name])
		[m_moderator addUnit:_kWorkflowUnitModifyClusterNameCard failEvent:kQQEventClusterModifyCardFailed critical:YES];
}

#pragma mark -
#pragma mark actions

- (IBAction)onOK:(id)sender {
	switch([[[m_tabMain selectedTabViewItem] identifier] intValue]) {
		case 4:
			m_apply = YES;
			m_showAlert = YES;
			[self buildWorkflow:_kWorkflowModifyCard];
			[m_moderator start:[m_mainWindowController client]];
			break;
		default:
			m_apply = NO;
			m_showAlert = YES;
			[self buildWorkflow:_kWorkflowModifyInfos];
			[m_moderator start:[m_mainWindowController client]];
			break;
	}
}

- (IBAction)onCancel:(id)sender {
	if([self isMe])
		[self close];
	else {
		switch([[[m_tabMain selectedTabViewItem] identifier] intValue]) {
			case 4:
				m_showAlert = NO;
				[self buildWorkflow:_kWorkflowGetCard];
				[m_moderator start:[m_mainWindowController client]];
				break;
			default:
				m_showAlert = NO;
				[self buildWorkflow:_kWorkflowGetInfos];
				[m_moderator start:[m_mainWindowController client]];
				break;
		}
	}
}

- (IBAction)onApply:(id)sender {
	if([self isMe]) {
		m_apply = YES;
		m_showAlert = YES;
		[self buildWorkflow:_kWorkflowModifyInfos];
		[m_moderator start:[m_mainWindowController client]];
	} else
		[self close];
}

- (IBAction)onRefreshQQShow:(id)sender {
	// start progress indicator
	[m_piDownloading setHidden:NO];
	[m_piDownloading startAnimation:self];
	[m_btnRefreshQQShow setEnabled:NO];
	
	// ensure the directory is created
	NSString* qqShowPath = [FileTool getQQShowFilePath:[self myQQ] qq:[m_user QQ]];
	[FileTool initDirectoryForFile:qqShowPath];
	
	// start downloading
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:L(@"LQURLQQShow"), [m_user QQ]]];
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	m_qqShowDownloader = [[NSURLDownload alloc] initWithRequest:request delegate:self];
	[m_qqShowDownloader setDeletesFileUponFailure:NO];
	[m_qqShowDownloader setDestination:qqShowPath allowOverwrite:YES];
	[m_qqShowDownloader request];
}

- (IBAction)onAuthTypeChanged:(id)sender {
	[m_cbQuestion setEnabled:([m_matrixAuthType selectedRow] == 3)];
	[m_txtAnswer setEnabled:([m_matrixAuthType selectedRow] == 3)];
}

- (IBAction)onHead:(id)sender {
	if(m_headSelector)
		return;
	
	// get head bound
	NSRect bound = [m_headControl bounds];	
	
	// calculate
	bound = [m_headControl convertRect:bound toView:nil];
		
	// create image selector window controller with frame
	m_headSelector = [[ImageSelectorWindowController alloc] initWithDataSource:self 
																	  delegate:self];
	[m_headSelector showWindow:self];
	[m_headSelector setOneShot:NO];
	[[m_headSelector window] setFrameTopLeftPoint:[[self window] convertBaseToScreen:bound.origin]];
}

#pragma mark -
#pragma mark qq show download delegate

- (void)downloadDidFinish:(NSURLDownload *)download {
	[m_piDownloading setHidden:YES];
	[m_piDownloading stopAnimation:self];
	[m_btnRefreshQQShow setEnabled:YES];
	
	[m_qqShowDownloader release];
	m_qqShowDownloader = nil;
	[self reloadQQShow];
}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error {
	[m_piDownloading setHidden:YES];
	[m_piDownloading stopAnimation:self];
	[m_btnRefreshQQShow setEnabled:YES];
	
	[m_qqShowDownloader release];
	m_qqShowDownloader = nil;
}

#pragma mark -
#pragma mark alert delegate

- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	if(!m_apply) {
		m_sheetType = _kSheetOperationFinished;
	}
}

#pragma mark -
#pragma mark workflow data source

- (BOOL)acceptEvent:(int)eventId {
	return NO;
}

- (void)workflowStart:(NSString*)workflowName {
	[m_piBusy startAnimation:self];
	[m_piBusy setHidden:NO];
	[m_btnOK setEnabled:NO];
	[m_btnCancelOrUpdate setEnabled:NO];
	[m_btnApplyOrCancel setEnabled:NO];
}

- (BOOL)needExecuteWorkflowUnit:(NSString*)unitName {
	if([_kWorkflowUnitGetMyQuestion isEqualToString:unitName])
		return [self isMe] && [[[m_mainWindowController me] contact] authType] == kQQAuthQuestion;
	else if([_kWorkflowUnitGetClusterNameCard isEqualToString:unitName] ||
			[_kWorkflowUnitModifyClusterNameCard isEqualToString:unitName])
		return m_cluster != nil;
	else
		return YES;
}

- (UInt16)executeWorkflowUnit:(NSString*)unitName hint:(NSString*)hint {
	[m_txtHint setStringValue:hint];
	
	if([_kWorkflowUnitGetAuthInfo isEqualToString:unitName])
		return [[m_mainWindowController client] getModifyInfoAuthInfo:[m_user QQ]];
	else if([_kWorkflowUnitGetMyQuestion isEqualToString:unitName])
		return [[m_mainWindowController client] getMyQuestion];
	else if([_kWorkflowUnitModifyQuestion isEqualToString:unitName])
		return [[m_mainWindowController client] modifyQuestion:[m_cbQuestion stringValue] answer:[m_txtAnswer stringValue]];
	else if([_kWorkflowUnitModifySignature isEqualToString:unitName])
		return [[m_mainWindowController client] modifySignature:[m_txtSignature string] authInfo:m_authInfo];
	else if([_kWorkflowUnitDeleteSignature isEqualToString:unitName])
		return [[m_mainWindowController client] deleteSignature:m_authInfo];
	else if([_kWorkflowUnitGetSignature isEqualToString:unitName])
		return [[m_mainWindowController client] getSignatureByQQ:[m_user QQ]];
	else if([_kWorkflowUnitGetLevel isEqualToString:unitName])
		return [[m_mainWindowController client] getFriendLevelByQQ:[m_user QQ]];
	else if([_kWorkflowUnitSetSearchMeByQQ isEqualToString:unitName])
		return [[m_mainWindowController client] setSearchMeByQQOnly:[m_chkSearchByQQ state]];
	else if([_kWorkflowUnitGetClusterNameCard isEqualToString:unitName])
		return [[m_mainWindowController client] getClusterNameCard:[m_cluster internalId] QQ:[m_user QQ]];
	else if([_kWorkflowUnitModifyClusterNameCard isEqualToString:unitName])
		return [[m_mainWindowController client] modifyCard:[m_cluster internalId]
													  name:[m_txtNameCardName stringValue]
											   genderIndex:[m_pbNameCardGender indexOfSelectedItem]
													 phone:[m_txtNameCardPhone stringValue]
													 email:[m_txtNameCardEmail stringValue]
													remark:[m_txtNameCardRemark string]
										  allowAdminModify:kQQClusterNameCardAllowAdminModify];
	else if([_kWorkflowUnitGetUserInfo isEqualToString:unitName])
		return [[m_mainWindowController client] getUserInfo:[m_user QQ]];
	else if([_kWorkflowUnitModifyInfo isEqualToString:unitName]) {
		// compose contact info
		[m_tempInfo release];
		m_tempInfo = [[ContactInfo alloc] init];
		[m_tempInfo setQQ:[m_user QQ]];
		[m_tempInfo setNick:[m_txtNick stringValue]];
		[m_tempInfo setCountry:[m_cbCountry stringValue]];
		[m_tempInfo setProvince:[m_cbProvince stringValue]];
		[m_tempInfo setZipcode:[m_txtZipcode stringValue]];
		[m_tempInfo setAddress:[m_txtAddress stringValue]];
		[m_tempInfo setTelephone:[m_txtTelephone stringValue]];
		[m_tempInfo setAge:[[m_txtAge stringValue] intValue]];
		[m_tempInfo setGender:[m_cbGender stringValue]];
		[m_tempInfo setName:[m_txtName stringValue]];
		[m_tempInfo setEmail:[m_txtEmail stringValue]];
		[m_tempInfo setOccupation:[m_cbOccupation stringValue]];
		[m_tempInfo setHomepage:[m_txtHomepage stringValue]];
		[m_tempInfo setAuthType:[m_matrixAuthType selectedRow]];
		[m_tempInfo setHead:[m_headControl head]];
		[m_tempInfo setMobile:[m_txtMobile stringValue]];
		[m_tempInfo setIntroduction:[m_txtIntroduction string]];
		[m_tempInfo setCity:[m_cbCity stringValue]];
		[m_tempInfo setContactVisibility:[m_pbVisibility indexOfSelectedItem]];
		[m_tempInfo setCollege:[m_txtCollege stringValue]];
		[m_tempInfo setHoroscope:[m_pbHoroscope indexOfSelectedItem]];
		[m_tempInfo setZodiac:[m_pbZodiac indexOfSelectedItem]];
		[m_tempInfo setBlood:[m_pbBlood indexOfSelectedItem]];	
		[m_tempInfo setUserFlag:[m_user userFlag]];
		
		// modify info
		return [[m_mainWindowController client] modifyInfo:m_tempInfo authInfo:m_authInfo];
	} else
		return 0;
}

- (NSString*)workflowUnitHint:(NSString*)unitName {
	if([_kWorkflowUnitGetMyQuestion isEqualToString:unitName])
		return L(@"LQHintGetQuestion", @"UserInfo");
	else if([_kWorkflowUnitModifyQuestion isEqualToString:unitName])
		return L(@"LQHintModifyAuthQuestion", @"UserInfo");
	else if([_kWorkflowUnitModifySignature isEqualToString:unitName])
		return L(@"LQHintModifySignature", @"UserInfo");
	else if([_kWorkflowUnitGetSignature isEqualToString:unitName])
		return L(@"LQHintGetSignature", @"UserInfo");
	else if([_kWorkflowUnitDeleteSignature isEqualToString:unitName])
		return L(@"LQHintDeleteSignature", @"UserInfo");
	else if([_kWorkflowUnitGetLevel isEqualToString:unitName])
		return L(@"LQHintGetLevel", @"UserInfo");
	else if([_kWorkflowUnitGetClusterNameCard isEqualToString:unitName])
		return L(@"LQHintGetCard", @"UserInfo");
	else if([_kWorkflowUnitModifyClusterNameCard isEqualToString:unitName])
		return L(@"LQHintModifyCard", @"UserInfo");
	else if([_kWorkflowUnitGetUserInfo isEqualToString:unitName])
		return L(@"LQHintGetInfo", @"UserInfo");
	else if([_kWorkflowUnitModifyInfo isEqualToString:unitName])
		return L(@"LQHintModifyInfo", @"UserInfo");
	else if([_kWorkflowUnitSetSearchMeByQQ isEqualToString:unitName])
		return L(@"LQHintSetSearchMeByQQ", @"UserInfo");
	else
		return kStringEmpty;
}

- (void)workflow:(NSString*)workflowName end:(BOOL)success {
	// refresh ui
	[m_piBusy stopAnimation:self];
	[m_piBusy setHidden:YES];
	[m_txtHint setStringValue:kStringEmpty];
	[m_btnOK setEnabled:YES];
	[m_btnCancelOrUpdate setEnabled:YES];
	[m_btnApplyOrCancel setEnabled:YES];
	
	// get message
	NSString* message = kStringEmpty;
	if([_kWorkflowModifyInfos isEqualToString:workflowName])
		message = success ? L(@"LQAlertModifyInfoOK", @"UserInfo") : L(@"LQAlertModifyInfoFailed", @"UserInfo");
	else if([_kWorkflowGetInfos isEqualToString:workflowName])
		message = success ? L(@"LQAlertGetInfoOK", @"UserInfo") : L(@"LQAlertGetInfoFailed", @"UserInfo");
	
	// show alert sheet
	if(m_showAlert) {
		[AlertTool showWarning:[self window]
						 title:(success ? L(@"LQSuccess") : L(@"LQFailed"))
					   message:message
					  delegate:self
				didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)];	
	}
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventGetAuthInfoOK:
			ret = [self handleGetAuthInfoOK:event];
			break;
		case kQQEventGetUserInfoOK:
			ret = [self handleGetUserInfoOK:event];
			break;
		case kQQEventModifyInfoOK:
			ret = [self handleModifyInfoOK:event];
			break;
		case kQQEventGetSignatureOK:
			ret = [self handleGetSignatureOK:event];
			break;
		case kQQEventGetFriendLevelOK:
			ret = [self handleGetFriendLevelOK:event];
			break;
		case kQQEventModifySigatureOK:
			ret = [self handleModifySignatureOK:event];
			break;
		case kQQEventDeleteSignatureOK:
			ret = [self handleDeleteSignatureOK:event];
			break;
		case kQQEventGetMyQuestionOK:
			ret = [self handleGetMyQuestionOK:event];
			break;
		case kQQEventModifyQuestionOK:
			ret = [self handleModifyQuestionOK:event];
			break;
		case kQQEventPrivacyOpOK:
			ret = [self handlePrivacyOpOK:event];
			break;
		case kQQEventClusterGetCardOK:
			ret = [self handleGetClusterNameCardOK:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleGetAuthInfoOK:(QQNotification*)event {
	AuthInfoOpReplyPacket* packet = (AuthInfoOpReplyPacket*)[event object];
	if(m_authInfo) {
		[m_authInfo release];
		m_authInfo = nil;
	}
	m_authInfo = [[packet authInfo] retain];
	return NO;
}

- (BOOL)handleModifyInfoOK:(QQNotification*)event {
	// release temp info
	[m_user setContact:m_tempInfo];
	[m_tempInfo release];
	m_tempInfo = nil;
	
	return NO;
}

- (BOOL)handleGetUserInfoOK:(QQNotification*)event {
	GetUserInfoReplyPacket* packet = (GetUserInfoReplyPacket*)[event object];

	[m_user setContact:[packet contact]];
	[self reloadInfo];

	return NO;
}

- (BOOL)handleGetFriendLevelOK:(QQNotification*)event {
	LevelOpReplyPacket* packet = [event object];
	
	NSEnumerator* e = [[packet levels] objectEnumerator];
	while(FriendLevel* level = [e nextObject]) {
		if([level QQ] == [m_user QQ]) {
			[m_levelControl setLevel:[level level]];
			[m_levelControl setUpgradeDays:[level upgradeDays]];
			break;
		}
	}
	
	return NO;
}

- (BOOL)handleGetSignatureOK:(QQNotification*)event {
	SignatureOpReplyPacket* packet = (SignatureOpReplyPacket*)[event object];
	
	NSEnumerator* e = [[packet signatures] objectEnumerator];
	while(Signature* sig = [e nextObject]) {
		if([sig QQ] == [m_user QQ]) {
			[m_txtSignature setString:[sig signature]];			
			break;
		}
	}
	
	return NO;
}

- (BOOL)handleModifySignatureOK:(QQNotification*)event {
	// main listener will change signature, so we don't need to do anything here
	
	return NO;
}

- (BOOL)handleDeleteSignatureOK:(QQNotification*)event {
	[m_user setSignature:kStringEmpty];
	return NO;
}

- (BOOL)handleGetMyQuestionOK:(QQNotification*)event {
	AuthQuestionOpReplyPacket* packet = (AuthQuestionOpReplyPacket*)[event object];
	if([packet question])
		[m_cbQuestion setStringValue:[packet question]];
	if([packet answer])
		[m_txtAnswer setStringValue:[packet answer]];
	
	return NO;
}

- (BOOL)handleModifyQuestionOK:(QQNotification*)event {
	return NO;
}

- (BOOL)handlePrivacyOpOK:(QQNotification*)event {
	return NO;
}

- (BOOL)handleGetClusterNameCardOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	ClusterNameCard* card = [packet clusterNameCard];
	if(m_cluster && [packet internalId] == [m_cluster internalId] && [card QQ] == [m_user QQ]) {
		[m_txtNameCardName setStringValue:[card name]];
		[m_pbNameCardGender selectItemAtIndex:[card genderIndex]];
		[m_txtNameCardPhone setStringValue:[card phone]];
		[m_txtNameCardEmail setStringValue:[card email]];
		[m_txtNameCardRemark setString:[card remark]];
		return YES;
	}
	return NO;
}

#pragma mark -
#pragma mark image selector data source

- (int)panelCount {
	return 7;
}

- (int)rowCount {
	return 5;
}

- (int)columnCount {
	return 8;
}

- (int)imageCount:(int)panel {
	return headMap[panel][0];
}

- (id)imageIdForPanel:(int)panel page:(int)page row:(int)row column:(int)col {
	int seq = page * [self rowCount] * [self columnCount] + row * [self columnCount] + col + 1;
	if(seq > [self imageCount:panel])
		return nil;
	else
		return [NSNumber numberWithInt:headMap[panel][seq]];
}

- (NSImage*)imageForPanel:(int)panel page:(int)page row:(int)row column:(int)col {
	// get id
	NSNumber* num = [self imageIdForPanel:panel page:page row:row column:col];
	
	// use default if nil
	int index = (num == nil) ? 1 : [num intValue];
	
	// get image
	return [NSImage imageNamed:[NSString stringWithFormat:kImageHeadX, index]];
}

- (NSString*)labelForPanel:(int)panel {
	switch(panel) {
		case 0:
			return L(@"LQMale");
		case 1:
			return L(@"LQFemale");
		case 2:
			return L(@"LQHeadPet", @"UserInfo");
		case 3:
			return L(@"LQHeadQQTang", @"UserInfo");
		case 4:
			return L(@"LQHeadQQFantasy", @"UserInfo");
		case 5:
			return L(@"LQHeadQQSonic", @"UserInfo");
		case 6:
			return L(@"LQHeadQQHuaXia", @"UserInfo");
		default:
			return L(@"LQHeadOther", @"UserInfo");
	}
}

- (NSSize)imageSize {
	return kSizeLarge;
}

- (NSString*)auxiliaryButtonLabel {
	return kStringEmpty;
}

- (BOOL)showAuxiliaryButton {
	return NO;
}

#pragma mark -
#pragma mark image selector delegate

- (void)imageChanged:(id)sender image:(NSImage*)image imageId:(id)imageId panel:(int)panelId {
	if(imageId)
		[m_headControl setHead:(([imageId intValue] - 1) * 3)];
}

- (void)enterImage:(id)sender image:(NSImage*)image imageId:(id)imageId panel:(int)panelId {
}

- (void)exitImage:(id)sender image:(NSImage*)image imageId:(id)imageId panel:(int)panelId {	
}

- (void)auxiliaryAction:(id)sender {
}

- (void)showTooltipAtPoint:(NSPoint)screenPoint image:(NSImage*)image imageId:(id)imageId panel:(int)panelId {
	
}

- (void)hideTooltip {
	
}

#pragma mark -
#pragma mark combobox data source

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index {
	if(aComboBox == m_cbProvince)
		return PROVINCE(index + 2);
	else if(aComboBox == m_cbCity) {
		int province = [m_cbProvince indexOfSelectedItem];
		return CITY(province + 2, index + 1);
	} else
		return kStringEmpty;
}

- (int)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	if(aComboBox == m_cbProvince)
		return PROVINCECOUNT - 1;
	else if(aComboBox == m_cbCity) {
		int province = [m_cbProvince indexOfSelectedItem];
		if(province == -1)
			return 0;
		else
			return CITYCOUNT(province + 2);
	} else
		return 0;
}

#pragma mark -
#pragma mark combobox delegate

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
	NSComboBox* comboBox = [notification object];
	if(comboBox == m_cbProvince) {
		[m_cbCity reloadData];
		[m_cbCity selectItemAtIndex:0];
	}
}

#pragma mark -
#pragma mark tab view delegate

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
	switch([[tabViewItem identifier] intValue]) {
		case 4:
			if(![self isMe])
				[m_btnCancelOrUpdate setTitle:([self isNameCardEditable] ? L(@"LQModify") : L(@"LQUpdate"))];
			break;
		default:
			if(![self isMe])
				[m_btnCancelOrUpdate setTitle:L(@"LQUpdate")];
			break;
	}
}

@end
