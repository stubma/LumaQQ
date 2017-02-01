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

#import "UIUserInfo.h"
#import <UIKit/UINavigationItem.h>
#import "UIController.h"
#import "LocalizedStringTool.h"
#import "ImageTool.h"
#import "GetUserInfoReplyPacket.h"
#import "ContactInfo.h"
#import "AuthQuestionOpReplyPacket.h"
#import "SignatureOpPacket.h"
#import "SignatureOpReplyPacket.h"
#import "AuthInfoOpReplyPacket.h"
#import "AuthQuestionOpReplyPacket.h"
#import "ModifyInfoReplyPacket.h"
#import "Signature.h"
#import "UIUtil.h"
#import "NSString-Validate.h"

extern UInt32 gMyQQ;

#define _kIndexHead 0
#define _kIndexQQ 1
#define _kIndexNick 2
#define _kIndexName 3
#define _kIndexAge 4
#define _kIndexCollege 5
#define _kIndexHomePage 6
#define _kIndexGender 7
#define _kIndexOccupation 8
#define _kIndexZodiac 9
#define _kIndexHoroscope 10
#define _kIndexBlood 11

#define _kRowHead 3
#define _kRowGender 10
#define _kRowOccupation 11
#define _kRowZodiac 12
#define _kRowHoroscope 13
#define _kRowBlood 14
#define _kRowNoAuth 25
#define _kRowNeedAuth 26
#define _kRowDenyAll 27
#define _kRowNeedQuestion 28
#define _kRowVisibleToAll 32
#define _kRowVisibleToFriend 33
#define _kRowVisibleToNobody 34

@implementation UIUserInfo

- (void) dealloc {
	[_data release];
	[_refreshCell release];
	[_saveCell release];
	[_qqCell release];
	[_headCell release];
	[_nickCell release];
	[_nameCell release];
	[_ageCell release];
	[_homePageCell release];
	[_zodiacCell release];
	[_horoscopeCell release];
	[_collegeCell release];
	[_occupationCell release];
	[_genderCell release];
	[_bloodCell release];
	[_emailCell release];
	[_telephoneCell release];
	[_mobileCell release];
	[_countryCell release];
	[_provinceCell release];
	[_cityCell release];
	[_addressCell release];
	[_zipcodeCell release];
	[_noAuthCell release];
	[_needAuthCell release];
	[_denyCell release];
	[_needQuestionCell release];
	[_authQuestionCell release];
	[_authAnswerCell release];
	[_contactOpenCell release];
	[_contactVisibleToFriendCell release];
	[_contactSecretCell release];
	[_signatureCell release];
	[_tempContact release];
	[_authInfo release];
	[_introductionCell release];
	
	[super dealloc];
}

- (NSString*)name {
	return kUIUnitUserInfo;
}

- (void)begin:(UIController*)uiController {
	// save controller
	_uiController = uiController;
	
	// push navigation item
	UINavigationItem* item = [[[UINavigationItem alloc] initWithTitle:@""] autorelease];
	[[uiController navBar] pushNavigationItem:item];
	
	// show button
	[[uiController navBar] showLeftButton:L(@"Back") withStyle:kNavButtonStyleBackArrow rightButton:nil withStyle:0];
	
	// set delegate
	[[uiController navBar] setDelegate:self];
	
	// add notification handle
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleHeadSelectedNotification:)
												 name:kHeadSelectedNotificationName
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleGenderSelectedNotification:)
												 name:kGenderSelectedNotificationName
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleZodiacSelectedNotification:)
												 name:kZodiacSelectedNotificationName
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleHoroscopeSelectedNotification:)
												 name:kHoroscopeSelectedNotificationName
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleOccupationSelectedNotification:)
												 name:kOccupationSelectedNotificationName
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleBloodSelectedNotification:)
												 name:kBloodSelectedNotificationName
											   object:nil];
}

- (void)stop:(UIController*)uiController {
	[[[uiController navBar] navigationItems] removeAllObjects];
	[[uiController navBar] setDelegate:nil];
	
	// remove notification handler
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kHeadSelectedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kGenderSelectedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kZodiacSelectedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kHoroscopeSelectedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kOccupationSelectedNotificationName
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:kBloodSelectedNotificationName
												  object:nil];
	
	// remove qq listener
	[_client removeQQListener:self];
}

- (UIView*)view {
	if(_table == nil) {		
		// init variable
		_tempContact = [[ContactInfo alloc] init];
		_waitingSequence = 0;
		
		// create edit view
		CGRect bound = [_uiController clientRect];
		_table = [[UIPreferencesTable alloc] initWithFrame:bound];
		
		// create refresh button
		_refreshCell = [[PushButtonTableCell alloc] initWithTitle:L(@"RefreshInfo")
													  upImageName:kImageOrangeButtonUp
													downImageName:kImageOrangeButtonDown];
		[[_refreshCell control] addTarget:self action:@selector(refreshInfoButtonClicked:) forEvents:kUIMouseUp];
		
		// create save button
		_saveCell = [[PushButtonTableCell alloc] initWithTitle:L(@"SaveInfo")
												   upImageName:kImageGreenButtonUp
												 downImageName:kImageGreenButtonDown];
		[[_saveCell control] addTarget:self action:@selector(saveInfoButtonClicked:) forEvents:kUIMouseUp];
		
		// qq cell
		_qqCell = [[UIPreferencesTableCell alloc] init];
		[_qqCell setTitle:L(@"QQNo")];
		
		// head cell
		_headCell = [[UIPreferencesTableCell alloc] init];
		[_headCell setTitle:L(@"Head")];
		
		// nick cell
		_nickCell = [[UIPreferencesTextTableCell alloc] init];
		[_nickCell setTitle:L(@"Nick")];
		
		// name cell
		_nameCell = [[UIPreferencesTextTableCell alloc] init];
		[_nameCell setTitle:L(@"Name")];
		
		// age cell
		_ageCell = [[UIPreferencesTextTableCell alloc] init];
		[_ageCell setTitle:L(@"Age")];
		
		// home page cell
		_homePageCell = [[UIPreferencesTextTableCell alloc] init];
		[_homePageCell setTitle:L(@"HomePage")];
		
		// zodiac cell
		_zodiacCell = [[UIPreferencesTableCell alloc] init];
		[_zodiacCell setTitle:L(@"Zodiac")];
		
		// horoscope
		_horoscopeCell = [[UIPreferencesTableCell alloc] init];
		[_horoscopeCell setTitle:L(@"Horoscope")];
		
		// occupation cell
		_occupationCell = [[UIPreferencesTableCell alloc] init];
		[_occupationCell setTitle:L(@"Occupation")];
		
		// gender cell
		_genderCell = [[UIPreferencesTableCell alloc] init];
		[_genderCell setTitle:L(@"Gender")];
		
		// blood cell
		_bloodCell = [[UIPreferencesTableCell alloc] init];
		[_bloodCell setTitle:L(@"Blood")];
		
		// college cell
		_collegeCell = [[UIPreferencesTextTableCell alloc] init];
		[_collegeCell setTitle:L(@"College")];
		
		// email cell
		_emailCell = [[UIPreferencesTextTableCell alloc] init];
		[_emailCell setTitle:L(@"Email")];
		
		// telephone cell
		_telephoneCell = [[UIPreferencesTextTableCell alloc] init];
		[_telephoneCell setTitle:L(@"Telephone")];
		
		// mobile cell
		_mobileCell = [[UIPreferencesTextTableCell alloc] init];
		[_mobileCell setTitle:L(@"Mobile")];
		
		// country cell
		_countryCell = [[UIPreferencesTextTableCell alloc] init];
		[_countryCell setTitle:L(@"Country")];
		
		// province cell
		_provinceCell = [[UIPreferencesTextTableCell alloc] init];
		[_provinceCell setTitle:L(@"Province")];
		
		// city cell
		_cityCell = [[UIPreferencesTextTableCell alloc] init];
		[_cityCell setTitle:L(@"City")];
		
		// address cell
		_addressCell = [[UIPreferencesTextTableCell alloc] init];
		[_addressCell setTitle:L(@"Address")];
		
		// zipcode cell
		_zipcodeCell = [[UIPreferencesTextTableCell alloc] init];
		[_zipcodeCell setTitle:L(@"Zipcode")];
		
		// no auth cell
		_noAuthCell = [[UIPreferencesTableCell alloc] init];
		[_noAuthCell setTitle:L(@"NoAuth")];
		
		// need auth cell
		_needAuthCell = [[UIPreferencesTableCell alloc] init];
		[_needAuthCell setTitle:L(@"NeedAuth")];
		
		// deny all cell
		_denyCell = [[UIPreferencesTableCell alloc] init];
		[_denyCell setTitle:L(@"DenyAll")];
		
		// auth question cell
		_needQuestionCell = [[UIPreferencesTableCell alloc] init];
		[_needQuestionCell setTitle:L(@"NeedQuestion")];
		
		// question cell
		_authQuestionCell = [[UIPreferencesTextTableCell alloc] init];
		[_authQuestionCell setTitle:L(@"AuthQuestion")];
		
		// answer cell
		_authAnswerCell = [[UIPreferencesTextTableCell alloc] init];
		[_authAnswerCell setTitle:L(@"AuthAnswer")];
		
		// contact open cell
		_contactOpenCell = [[UIPreferencesTableCell alloc] init];
		[_contactOpenCell setTitle:L(@"ContactOpen")];
		
		// contact only to friend cell
		_contactVisibleToFriendCell = [[UIPreferencesTableCell alloc] init];
		[_contactVisibleToFriendCell setTitle:L(@"ContactVisibleToFriend")];
		
		// contact secret cell
		_contactSecretCell = [[UIPreferencesTableCell alloc] init];
		[_contactSecretCell setTitle:L(@"ContactSecret")];
		
		// signature cell
		_signatureCell = [[UIPreferencesTextTableCell alloc] init];
		[_signatureCell setTitle:L(@"Signature")];
		
		// introduction cell
		_introductionCell = [[UIPreferencesTextTableCell alloc] init];
		[_introductionCell setTitle:L(@"Introduction")];
		
		// init table
		[_table setDataSource:self];
		[_table setDelegate:self];
	}
	return _table;
}

- (void)refresh:(NSMutableDictionary*)data {
	// hide keyboard
	[_table setKeyboardVisible:NO];
	
	// clear selection
	[_table selectRow:-1 byExtendingSelection:NO withFade:NO];
	
	if(data != nil) {
		// save data
		[data retain];
		[_data release];
		_data = data;
		
		// get user
		_user = [_data objectForKey:kDataKeyUser];
		
		// is me?
		BOOL bEditable = [_user QQ] == gMyQQ;
		
		// get group manager and client
		_client = [_data objectForKey:kDataKeyClient];
		
		// set head
		[_tempContact setHead:[_user head]];
		
		// initial disclosure
		[_headCell setShowDisclosure:bEditable];
		[_genderCell setShowDisclosure:bEditable];
		[_occupationCell setShowDisclosure:bEditable];
		[_zodiacCell setShowDisclosure:bEditable];
		[_horoscopeCell setShowDisclosure:bEditable];
		[_bloodCell setShowDisclosure:bEditable];
		
		// initial enablement
		[_headCell setEnabled:bEditable];
		[_qqCell setEnabled:bEditable];
		[_genderCell setEnabled:bEditable];
		[_occupationCell setEnabled:bEditable];
		[_zodiacCell setEnabled:bEditable];
		[_horoscopeCell setEnabled:bEditable];
		[_bloodCell setEnabled:bEditable];
		[_nickCell setEnabled:bEditable];
		[_nameCell setEnabled:bEditable];
		[_ageCell setEnabled:bEditable];
		[_collegeCell setEnabled:bEditable];
		[_homePageCell setEnabled:bEditable];
		[_emailCell setEnabled:bEditable];
		[_telephoneCell setEnabled:bEditable];
		[_mobileCell setEnabled:bEditable];
		[_countryCell setEnabled:bEditable];
		[_provinceCell setEnabled:bEditable];
		[_cityCell setEnabled:bEditable];
		[_addressCell setEnabled:bEditable];
		[_zipcodeCell setEnabled:bEditable];
		[_noAuthCell setEnabled:bEditable];
		[_needAuthCell setEnabled:bEditable];
		[_denyCell setEnabled:bEditable];
		[_needQuestionCell setEnabled:bEditable];
		[_authQuestionCell setEnabled:bEditable];
		[_authAnswerCell setEnabled:bEditable];
		[_contactOpenCell setEnabled:bEditable];
		[_contactVisibleToFriendCell setEnabled:bEditable];
		[_contactSecretCell setEnabled:bEditable];
		[_signatureCell setEnabled:bEditable];
		[_introductionCell setEnabled:bEditable];
		
		// reload table
		[_table reloadData];
		
		// initial value
		[self _reloadContact];
	} 
	
	// set navigation bar title
	[[[_uiController navBar] topItem] setTitle:(([_user QQ] == gMyQQ) ? L(@"MyInfo") : L(@"UserInfo"))];
	
	// add qq listener
	[_client addQQListener:self];
}

- (void)_reloadContact {
	[_headCell setIcon:[_user headWithStatus:NO]];
	[_qqCell setValue:[NSString stringWithFormat:@"%u", [_user QQ]]];
	[_nickCell setValue:[_user nick]];
	[_nameCell setValue:[_user name]];
	
	ContactInfo* contact = [_user contact];
	if(contact != nil) {
		[_ageCell setValue:[NSString stringWithFormat:@"%d", [contact age]]];
		[_collegeCell setValue:[contact college]];
		[_homePageCell setValue:[contact homepage]];
		[_occupationCell setValue:[contact occupation]];
		[_genderCell setValue:[contact gender]];
		[_zodiacCell setValue:L([NSString stringWithFormat:@"Zodiac.%u", [contact zodiac]])];
		[_horoscopeCell setValue:L([NSString stringWithFormat:@"Horoscope.%u", [contact horoscope]])];
		[_bloodCell setValue:L([NSString stringWithFormat:@"Blood.%u", [contact blood]])];
		[_emailCell setValue:[contact email]];
		[_telephoneCell setValue:[contact telephone]];
		[_mobileCell setValue:[contact mobile]];
		[_countryCell setValue:[contact country]];
		[_provinceCell setValue:[contact province]];
		[_cityCell setValue:[contact city]];
		[_addressCell setValue:[contact address]];
		[_zipcodeCell setValue:[contact zipcode]];
		[_introductionCell setValue:[contact introduction]];
		[self _checkAuthType:[contact authType]];
		[self _checkContactVisibility:[contact contactVisibility]];
	}
}

- (void)_checkContactVisibility:(char)contactVisibility {
	[_contactOpenCell setChecked:NO];
	[_contactVisibleToFriendCell setChecked:NO];
	[_contactSecretCell setChecked:NO];
	
	switch(contactVisibility) {
		case kQQContactVisibilityAll:
			[_contactOpenCell setChecked:YES];
			break;
		case kQQContactVisibilityFriend:
			[_contactVisibleToFriendCell setChecked:YES];
			break;
		case kQQContactVisibilityNo:
			[_contactSecretCell setChecked:YES];
			break;
	}
}

- (void)_checkAuthType:(char)authType {
	[_noAuthCell setChecked:NO];
	[_needAuthCell setChecked:NO];
	[_denyCell setChecked:NO];
	[_needQuestionCell setChecked:NO];
	
	switch(authType) {
		case kQQAuthNo:
			[_noAuthCell setChecked:YES];
			break;
		case kQQAuthNeed:
			[_needAuthCell setChecked:YES];
			break;
		case kQQAuthReject:
			[_denyCell setChecked:YES];
			break;
		case kQQAuthQuestion:
			[_needQuestionCell setChecked:YES];
			break;
	}
}

- (NSArray*)_loadValueArray:(NSString*)name {
	NSString* countStr = L([NSString stringWithFormat:@"%@.count", name]);
	int count = [countStr intValue];
	int i;
	NSMutableArray* array = [NSMutableArray arrayWithCapacity:count];
	for(i = 0; i < count; i++) {
		[array addObject:L([NSString stringWithFormat:@"%@.%u", name, i])];
	}
	return array;
}

- (void)handleHeadSelectedNotification:(NSNotification*)notification {
	NSNumber* headIdInt = [notification object];
	UInt16 headId = [headIdInt unsignedIntValue];
	[_tempContact setHead:((headId - 1) * 3)];
	[_headCell setIcon:[ImageTool headWithRealId:headId]];
}

- (void)handleGenderSelectedNotification:(NSNotification*)notification {
	NSNumber* index = [notification object];
	NSString* gender = [[notification userInfo] objectForKey:kUserInfoStringValue];
	[_genderCell setValue:gender];
}

- (void)handleZodiacSelectedNotification:(NSNotification*)notification {
	NSNumber* index = [notification object];
	NSString* zodiac = [[notification userInfo] objectForKey:kUserInfoStringValue];
	[_zodiacCell setValue:zodiac];
	[_tempContact setZodiac:[index intValue]];
}

- (void)handleHoroscopeSelectedNotification:(NSNotification*)notification {
	NSNumber* index = [notification object];
	NSString* horoscope = [[notification userInfo] objectForKey:kUserInfoStringValue];
	[_horoscopeCell setValue:horoscope];
	[_tempContact setHoroscope:[index intValue]];
}

- (void)handleOccupationSelectedNotification:(NSNotification*)notification {
	NSNumber* index = [notification object];
	NSString* occupation = [[notification userInfo] objectForKey:kUserInfoStringValue];
	[_occupationCell setValue:occupation];
}

- (void)handleBloodSelectedNotification:(NSNotification*)notification {
	NSNumber* index = [notification object];
	NSString* blood = [[notification userInfo] objectForKey:kUserInfoStringValue];
	[_bloodCell setValue:blood];
	[_tempContact setBlood:[index intValue]];
}

- (void)refreshInfoButtonClicked:(UIPushButton*)button {
	// show alert
	_alertSheet = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
	[_alertSheet setBodyText:L(@"RefreshingUserInfo")];
	[_alertSheet presentSheetFromAboveView:_table];
	
	// get user info
	_waitingSequence = [_client getUserInfo:[_user QQ]];
}

- (void)saveInfoButtonClicked:(UIPushButton*)button {
	ContactInfo* contact = [_user contact];
	
	// save setting in temp contact
	[_tempContact setQQ:[contact QQ]];
	[_tempContact setNick:[_nickCell value]];
	[_tempContact setAge:[[_ageCell value] intValue]];
	[_tempContact setGender:[_genderCell value]];
	[_tempContact setName:[_nameCell value]];
	[_tempContact setOccupation:[_occupationCell value]];
	[_tempContact setHomepage:[_homePageCell value]];
	[_tempContact setCollege:[_collegeCell value]];
	[_tempContact setEmail:[_emailCell value]];
	[_tempContact setTelephone:[_telephoneCell value]];
	[_tempContact setMobile:[_mobileCell value]];
	[_tempContact setCountry:[_countryCell value]];
	[_tempContact setProvince:[_provinceCell value]];
	[_tempContact setCity:[_cityCell value]];
	[_tempContact setAddress:[_addressCell value]];
	[_tempContact setZipcode:[_zipcodeCell value]];
	[_tempContact setIntroduction:[_introductionCell value]];
	if([_noAuthCell isChecked])
		[_tempContact setAuthType:kQQAuthNo];
	else if([_needAuthCell isChecked])
		[_tempContact setAuthType:kQQAuthNeed];
	else if([_denyCell isChecked])
		[_tempContact setAuthType:kQQAuthReject];
	else if([_needQuestionCell isChecked])
		[_tempContact setAuthType:kQQAuthQuestion];
	if([_contactOpenCell isChecked])
		[_tempContact setContactVisibility:kQQContactVisibilityAll];
	else if([_contactVisibleToFriendCell isChecked])
		[_tempContact setContactVisibility:kQQContactVisibilityFriend];
	else if([_contactSecretCell isChecked])
		[_tempContact setContactVisibility:kQQContactVisibilityNo];
	
	// show alert
	_alertSheet = [[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 240, 320, 240)];
	[_alertSheet setBodyText:L(@"GettingAuthInfo")];
	[_alertSheet presentSheetFromAboveView:_table];
	
	// start modify info, first, we need get auth info
	_waitingSequence = [_client getModifyInfoAuthInfo:gMyQQ];
}

#pragma mark -
#pragma mark navigation bar delegate

- (void)navigationBar:(UINavigationBar*)navbar buttonClicked:(int)button {
	switch(button) {
		case kNavButtonLeft:
			[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:nil];
			break;
		case kNavButtonRight:
			break;
	}
}

#pragma mark -
#pragma mark alert delegate

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button {
	[sheet dismiss];
		
	// 1 is ok button, the index starts from 0!
	if(button == 1) {		
		// back to previous view
		[_uiController transitTo:[_data objectForKey:kDataKeyFrom] style:kTransitionStyleRightSlide data:nil];
	}
}

#pragma mark -
#pragma mark preference table delegate and data source

-(int)numberOfGroupsInPreferencesTable:(UIPreferencesTable*)aTable {
	// if not me, we can't modify info, last group is a save info button
	return 6 + (([_user QQ] == gMyQQ) ? 1 : 0);
}

-(int)preferencesTable:(UIPreferencesTable*)aTable numberOfRowsInGroup:(int)group {
	switch(group) {
		case 0: 
			return 1;
		case 1: 
			return 12;
		case 2:
			return 8;
		case 3:
			return 6;
		case 4:
			return 3;
		case 5:
			return 2;
		case 6:
			return 1;
		default:
			return 0;
	}
}

- (id)preferencesTable:(UIPreferencesTable*)aTable titleForGroup:(int)group {
	switch(group) {
		case 3:
			return L(@"AuthGroup");
		case 4:
			return L(@"ContactGroup");
	}
	return nil;
}

-(float)preferencesTable:(UIPreferencesTable*)aTable heightForRow:(int)row inGroup:(int)group withProposedHeight:(float)proposed {
	switch(group) {
		case 1:
			switch(row) {
				case _kIndexHead: // head cell
					return 50.0f;
			}
	}
	return proposed;
}

-(BOOL)preferencesTable:(UIPreferencesTable*)aTable isLabelGroup:(int)group {
	return NO;
}

-(UIPreferencesTableCell*)preferencesTable:(UIPreferencesTable*)aTable cellForRow:(int)row inGroup:(int)group {
	switch(group) {
		case 0:
			switch(row) {
				case 0:
					return _refreshCell;
			}
			break;
		case 1:
			switch(row) {
				case _kIndexHead:
					return _headCell;
				case _kIndexQQ:
					return _qqCell;
				case _kIndexNick:
					return _nickCell;
				case _kIndexName:
					return _nameCell;
				case _kIndexAge:
					return _ageCell;
				case _kIndexCollege:
					return _collegeCell;
				case _kIndexHomePage:
					return _homePageCell;
				case _kIndexGender:
					return _genderCell;
				case _kIndexOccupation:
					return _occupationCell;
				case _kIndexZodiac:
					return _zodiacCell;
				case _kIndexHoroscope:
					return _horoscopeCell;
				case _kIndexBlood:
					return _bloodCell;
			}
			break;
		case 2:
			switch(row) {
				case 0:
					return _emailCell;
				case 1:
					return _telephoneCell;
				case 2:
					return _mobileCell;
				case 3:
					return _countryCell;
				case 4:
					return _provinceCell;
				case 5:
					return _cityCell;
				case 6:
					return _addressCell;
				case 7:
					return _zipcodeCell;
			}
			break;
		case 3:
			switch(row) {
				case 0:
					return _noAuthCell;
				case 1:
					return _needAuthCell;
				case 2:
					return _denyCell;
				case 3:
					return _needQuestionCell;
				case 4:
					return _authQuestionCell;
				case 5:
					return _authAnswerCell;
			}
			break;
		case 4:
			switch(row) {
				case 0:
					return _contactOpenCell;
				case 1:
					return _contactVisibleToFriendCell;
				case 2:
					return _contactSecretCell;
			}
			break;
		case 5:
			switch(row) {
				case 0:
					return _signatureCell;
				case 1:
					return _introductionCell;
			}
			break;
		case 6:
			switch(row) {
				case 0:
					return _saveCell;
			}
			break;
	}
	return nil; 
}

- (void)tableRowSelected:(NSNotification*)notification {
	switch([_table selectedRow]) {
		case _kRowHead:
			[_uiController transitTo:kUIUnitSelectHead
							   style:kTransitionStyleLeftSlide
								data:[NSMutableDictionary dictionaryWithObjectsAndKeys:kUIUnitUserInfo, kDataKeyFrom,
									nil]];
			break;		
		case _kRowGender:
			[_uiController transitTo:kUIUnitSelectValue
							   style:kTransitionStyleLeftSlide
								data:[NSMutableDictionary dictionaryWithObjectsAndKeys:[self _loadValueArray:@"Gender"], kDataKeyStringValueArray,
									[_genderCell value], kDataKeyStringValue,
									kUIUnitUserInfo, kDataKeyFrom,
									kGenderSelectedNotificationName, kDataKeyNotificationName,
									nil]];
			break;
		case _kRowZodiac:
			[_uiController transitTo:kUIUnitSelectValue
							   style:kTransitionStyleLeftSlide
								data:[NSMutableDictionary dictionaryWithObjectsAndKeys:[self _loadValueArray:@"Zodiac"], kDataKeyStringValueArray,
									[_zodiacCell value], kDataKeyStringValue,
									kUIUnitUserInfo, kDataKeyFrom,
									kZodiacSelectedNotificationName, kDataKeyNotificationName,
									nil]];
			break;
		case _kRowHoroscope:
			[_uiController transitTo:kUIUnitSelectValue
							   style:kTransitionStyleLeftSlide
								data:[NSMutableDictionary dictionaryWithObjectsAndKeys:[self _loadValueArray:@"Horoscope"], kDataKeyStringValueArray,
									[_horoscopeCell value], kDataKeyStringValue,
									kUIUnitUserInfo, kDataKeyFrom,
									kHoroscopeSelectedNotificationName, kDataKeyNotificationName,
									nil]];
			break;
		case _kRowBlood:
			[_uiController transitTo:kUIUnitSelectValue
							   style:kTransitionStyleLeftSlide
								data:[NSMutableDictionary dictionaryWithObjectsAndKeys:[self _loadValueArray:@"Blood"], kDataKeyStringValueArray,
									[_bloodCell value], kDataKeyStringValue,
									kUIUnitUserInfo, kDataKeyFrom,
									kBloodSelectedNotificationName, kDataKeyNotificationName,
									nil]];
			break;
		case _kRowOccupation:
			[_uiController transitTo:kUIUnitSelectValue
							   style:kTransitionStyleLeftSlide
								data:[NSMutableDictionary dictionaryWithObjectsAndKeys:[self _loadValueArray:@"Occupation"], kDataKeyStringValueArray,
									[_occupationCell value], kDataKeyStringValue,
									kUIUnitUserInfo, kDataKeyFrom,
									kOccupationSelectedNotificationName, kDataKeyNotificationName,
									nil]];
			break;
		case _kRowNoAuth:
			[self _checkAuthType:kQQAuthNo];
			break;
		case _kRowNeedAuth:
			[self _checkAuthType:kQQAuthNeed];
			break;
		case _kRowDenyAll:
			[self _checkAuthType:kQQAuthReject];
			break;
		case _kRowNeedQuestion:
			[self _checkAuthType:kQQAuthQuestion];
			break;
		case _kRowVisibleToAll:
			[self _checkContactVisibility:kQQContactVisibilityAll];
			break;
		case _kRowVisibleToFriend:
			[self _checkContactVisibility:kQQContactVisibilityFriend];
			break;
		case _kRowVisibleToNobody:
			[self _checkContactVisibility:kQQContactVisibilityNo];
			break;
	}
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventTimeoutBasic:
			ret = [self handleTimeout:event];
			break;
		case kQQEventGetUserInfoOK:
			ret = [self handleGetUserInfoOK:event];
			break;
		case kQQEventGetMyQuestionOK:
			ret = [self handleGetMyQuestionOK:event];
			break;
		case kQQEventGetSignatureOK:
			ret = [self handleGetSignatureOK:event];
			break;
		case kQQEventGetAuthInfoOK:
			ret = [self handleGetAuthInfoOK:event];
			break;
		case kQQEventModifyInfoOK:
			ret = [self handleModifyInfoOK:event];
			break;
		case kQQEventModifySigatureOK:
			ret = [self handleModifySignatureOK:event];
			break;
		case kQQEventDeleteSignatureOK:
			ret = [self handleDeleteSignatureOK:event];
			break;
		case kQQEventModifyQuestionOK:
			ret = [self handleModifyQuestionOK:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleGetUserInfoOK:(QQNotification*)event {
	// get contact
	GetUserInfoReplyPacket* packet = (GetUserInfoReplyPacket*)[event object];
	if(_waitingSequence == [packet sequence]) {		
		// refresh UI
		[self _reloadContact];
		
		// get my question
		if([_user QQ] == gMyQQ) {
			[_alertSheet setBodyText:L(@"GettingMyQuestion")];
			_waitingSequence = [_client getMyQuestion];
		} else {
			// dismiss alert
			[_alertSheet dismiss];
			[_alertSheet release];
			_alertSheet = nil;
		}
		
		return YES;
	}
	
	return NO;
}

- (BOOL)handleGetMyQuestionOK:(QQNotification*)event {
	AuthQuestionOpReplyPacket* packet = (AuthQuestionOpReplyPacket*)[event object];
	if(_waitingSequence == [packet sequence]) {
		// refresh UI
		if([packet question])
			[_authQuestionCell setValue:[packet question]];
		if([packet answer])
			[_authAnswerCell setValue:[packet answer]];
		
		// get signature
		if([_user QQ] == gMyQQ) {
			[_alertSheet setBodyText:L(@"GettingSignature")];
			_waitingSequence = [_client getSignatureByQQ:gMyQQ];
		} else {
			// dismiss alert
			[_alertSheet dismiss];
			[_alertSheet release];
			_alertSheet = nil;
		}
		
		return YES;
	}
	
	return NO;
}

- (BOOL)handleGetSignatureOK:(QQNotification*)event {
	SignatureOpReplyPacket* packet = (SignatureOpReplyPacket*)[event object];
	
	if(_waitingSequence == [packet sequence]) {
		// refresh UI
		NSEnumerator* e = [[packet signatures] objectEnumerator];
		Signature* sig;
		while(sig = [e nextObject]) {
			if([sig QQ] == [_user QQ]) {
				[_signatureCell setValue:[sig signature]];			
				break;
			}
		}
		
		// dismiss alert
		[_alertSheet dismiss];
		[_alertSheet release];
		_alertSheet = nil;
		
		return YES;
	}
	
	return NO;
}

- (BOOL)handleGetAuthInfoOK:(QQNotification*)event {
	AuthInfoOpReplyPacket* packet = (AuthInfoOpReplyPacket*)[event object];
	if(_waitingSequence == [packet sequence]) {		
		// save auto info
		if(_authInfo) {
			[_authInfo release];
			_authInfo = nil;
		}
		_authInfo = [[packet authInfo] retain];
		
		// modify info
		[_alertSheet setBodyText:L(@"ModifyingUserInfo")];
		_waitingSequence = [_client modifyInfo:_tempContact authInfo:_authInfo];
		
		return YES;
	}

	return NO;
}

- (BOOL)handleModifyInfoOK:(QQNotification*)event {
	ModifyInfoReplyPacket* packet = (ModifyInfoReplyPacket*)[event object];
	if(_waitingSequence == [packet sequence]) {
		// release temp info
		[_user setContact:_tempContact];
		
		// delete or modify signature
		NSString* sig = [_signatureCell value];
		if(sig == nil || [sig isEmpty]) {
			[_alertSheet setBodyText:L(@"DeletingSignature")];
			_waitingSequence = [_client deleteSignature:_authInfo];
		} else {
			[_alertSheet setBodyText:L(@"ModifyingSignature")];
			_waitingSequence = [_client modifySignature:sig authInfo:_authInfo];
		}			
		
		return YES;
	}
	
	return NO;
}

- (BOOL)handleModifySignatureOK:(QQNotification*)event {
	SignatureOpPacket* packet = (SignatureOpPacket*)[event outPacket];
	if(_waitingSequence == [packet sequence]) {
		// set signature to model
		[_user setSignature:[packet signature]];
		
		// modify auth question
		[_alertSheet setBodyText:L(@"ModifyingAuthQuestion")];
		_waitingSequence = [_client modifyQuestion:[_authQuestionCell value] answer:[_authAnswerCell value]];
		
		return YES;
	}
	
	return NO;
}

- (BOOL)handleDeleteSignatureOK:(QQNotification*)event {
	SignatureOpReplyPacket* packet = (SignatureOpReplyPacket*)[event object];
	if(_waitingSequence == [packet sequence]) {
		// clear signature
		[_user setSignature:kStringEmpty];
		
		// modify auth question
		[_alertSheet setBodyText:L(@"ModifyingAuthQuestion")];
		_waitingSequence = [_client modifyQuestion:[_authQuestionCell value] answer:[_authAnswerCell value]];
		
		return YES;
	}
	
	return NO;
}

- (BOOL)handleModifyQuestionOK:(QQNotification*)event {
	AuthQuestionOpReplyPacket* packet = (AuthQuestionOpReplyPacket*)[event object];
	if(_waitingSequence == [packet sequence]) {
		// dismiss alert
		[_alertSheet dismiss];
		[_alertSheet release];
		_alertSheet = nil;
		
		// show dialog
		[UIUtil showWarning:L(@"ModifyInfoSuccess") title:L(@"Success") delegate:self];
		
		return YES;
	}
	return NO;
}

- (BOOL)handleTimeout:(QQNotification*)event {
	OutPacket* packet = [event outPacket];
	if(_waitingSequence == [packet sequence]) {
		// dismiss alert
		[_alertSheet dismiss];
		[_alertSheet release];
		_alertSheet = nil;
		
		// return yes
		return YES;
	}
	return NO;
}

@end
