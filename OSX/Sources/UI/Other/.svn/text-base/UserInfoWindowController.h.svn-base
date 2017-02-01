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
#import "LevelControl.h"
#import "HeadControl.h"
#import "User.h"
#import "QQListener.h"
#import "ImageSelectorWindowController.h"
#import "WorkflowModerator.h"

@class MainWindowController;

@interface UserInfoWindowController : NSWindowController <WorkflowDataSource> {
	MainWindowController* m_mainWindowController;
	User* m_user;
	Cluster* m_cluster;
	
	// basic info panel
	IBOutlet NSTextField* m_txtQQ;
	IBOutlet NSTextField* m_txtNick;
	IBOutlet NSTextView* m_txtSignature;
	IBOutlet LevelControl* m_levelControl;
	IBOutlet HeadControl* m_headControl;
	IBOutlet NSComboBox* m_cbGender;
	IBOutlet NSTextField* m_txtName;
	IBOutlet NSTextField* m_txtAge;
	IBOutlet NSTextField* m_txtCollege;
	IBOutlet NSComboBox* m_cbOccupation;
	IBOutlet NSTextField* m_txtHomepage;
	IBOutlet NSTextView* m_txtIntroduction;
	IBOutlet NSPopUpButton* m_pbHoroscope;
	IBOutlet NSPopUpButton* m_pbZodiac;
	IBOutlet NSPopUpButton* m_pbBlood;
	
	// qq show panel
	IBOutlet NSButton* m_btnRefreshQQShow;
	IBOutlet NSProgressIndicator* m_piDownloading;
	IBOutlet NSImageView* m_ivQQShow;
	
	// contact panel
	IBOutlet NSComboBox* m_cbCountry;
	IBOutlet NSComboBox* m_cbProvince;
	IBOutlet NSComboBox* m_cbCity;
	IBOutlet NSTextField* m_txtZipcode;
	IBOutlet NSPopUpButton* m_pbVisibility;
	IBOutlet NSTextField* m_txtEmail;
	IBOutlet NSTextField* m_txtAddress;
	IBOutlet NSTextField* m_txtMobile;
	IBOutlet NSTextField* m_txtTelephone;
	
	// auth panel
	IBOutlet NSButton* m_chkSearchByQQ;
	IBOutlet NSMatrix* m_matrixAuthType;
	IBOutlet NSComboBox* m_cbQuestion;
	IBOutlet NSTextField* m_txtAnswer;
	
	// cluster name card panel
	IBOutlet NSTextField* m_txtNameCardName;
	IBOutlet NSPopUpButton* m_pbNameCardGender;
	IBOutlet NSTextField* m_txtNameCardPhone;
	IBOutlet NSTextField* m_txtNameCardEmail;
	IBOutlet NSTextView* m_txtNameCardRemark;
	
	// other
	IBOutlet NSProgressIndicator* m_piBusy;
	IBOutlet NSTextField* m_txtHint;
	IBOutlet NSTabView* m_tabMain;
	
	// if view other users info, hide it
	IBOutlet NSButton* m_btnOK;
	
	// if view other users info, it is update button
	IBOutlet NSButton* m_btnCancelOrUpdate;
	
	// if view other users info, it is cancel button
	IBOutlet NSButton* m_btnApplyOrCancel;
	
	// qq show download
	NSURLDownload* m_qqShowDownloader;
	
	// operation flag
	BOOL m_apply;
	BOOL m_showAlert;
	
	// temp contact info
	ContactInfo* m_tempInfo;
	
	// modify info auth info
	NSData* m_authInfo;
	
	// head selector window
	ImageSelectorWindowController* m_headSelector;
	
	// workflow
	WorkflowModerator* m_moderator;
	
	// check sheet type
	int m_sheetType;
}

- (id)initWithMainWindowController:(MainWindowController*)mainWindowController user:(User*)user;
- (id)initWithMainWindowController:(MainWindowController*)mainWindowController user:(User*)user cluster:(Cluster*)cluster;

// action
- (IBAction)onOK:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onApply:(id)sender;
- (IBAction)onRefreshQQShow:(id)sender;
- (IBAction)onAuthTypeChanged:(id)sender;
- (IBAction)onHead:(id)sender;

// helper
- (BOOL)isMe;
- (UInt32)myQQ;
- (void)reloadQQShow;
- (void)reloadInfo;
- (NSString*)titleOfCancelUpdateButton;
- (NSString*)titleOfApplyCloseButton;
- (void)handleHeadSelectorWindowWillClose:(NSNotification*)notification;
- (BOOL)isNameCardEditable;
- (void)buildWorkflow:(NSString*)name;

// qq event
- (BOOL)handleGetAuthInfoOK:(QQNotification*)event;
- (BOOL)handleGetUserInfoOK:(QQNotification*)event;
- (BOOL)handleModifyInfoOK:(QQNotification*)event;
- (BOOL)handleGetSignatureOK:(QQNotification*)event;
- (BOOL)handleGetFriendLevelOK:(QQNotification*)event;
- (BOOL)handleModifySignatureOK:(QQNotification*)event;
- (BOOL)handleDeleteSignatureOK:(QQNotification*)event;
- (BOOL)handleGetMyQuestionOK:(QQNotification*)event;
- (BOOL)handleModifyQuestionOK:(QQNotification*)event;
- (BOOL)handlePrivacyOpOK:(QQNotification*)event;
- (BOOL)handleGetClusterNameCardOK:(QQNotification*)event;

@end
