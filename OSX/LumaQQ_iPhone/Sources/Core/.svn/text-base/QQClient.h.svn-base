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

#import <Foundation/Foundation.h>
#import "CustomHead.h"
#import "QQConnection.h"
#import "QQNotification.h"
#import "QQEvent.h"
#import "QQConstants.h"
#import "QQUser.h"
#import "QQNotificationCenter.h"
#import "QQListener.h"
#import "OutPacket.h"
#import "InPacket.h"
#import "LoginReplyPacket.h"
#import "GetLoginTokenReplyPacket.h"
#import "GetKeyReplyPacket.h"
#import "KeepAliveReplyPacket.h"
#import "GetOnlineOpReplyPacket.h"
#import "ChangeStatusPacket.h"
#import "FriendRemark.h"
#import "ContactInfo.h"
#import "NormalIM.h"
#import "ClusterIM.h"
#import "GetServerTokenReplyPacket.h"
#import "SelectServerReplyPacket.h"
#import "PacketParser.h"
#import "QQClientDelegate.h"
#import "StatusListener.h"
#import "ReceivedIMPacket.h"
#import "CustomHeadReceiver.h"
#import "QQListener.h"
#import "IMService.h"

@interface QQClient : NSObject <QQListener> {
	// delegate
	id m_delegate;
	
	// timer
	NSTimer* m_resendTimer;
	NSTimer* m_keepAliveTimer;
	
	// custom head listener
	CustomHeadReceiver* m_customHeadReceiver;
	
	// services
	IMService* _imService;
	
	// qq client status listener
	NSMutableArray* m_statusListeners;
	NSMutableArray* m_statusListenersBackup;
	BOOL m_statusListenerChanged;
	int m_status;
	
	// is network started?
	BOOL m_bNetworkStarted;
	
	// main connection parameters
	QQConnection* m_mainConnection;
	
	// connection mapping
	NSMutableDictionary* m_connections;
	
	// qq user bean
	QQUser* m_user;
	
	// packet parser
	PacketParser* m_parser;
	
	// resend queue
	NSMutableArray* m_resendQueue;
	
	// duplicate cache, it saves server initiative packet hash value
	// when a server initiative packet is received, it checks the cache
	// to determine whether it's duplicate. This cache will 
	NSMutableArray* m_duplicateCache;
	
	// notification center
	QQNotificationCenter* m_notificationCenter;
	
	// for redirect
	LoginReplyPacket* m_loginReplyPacket;
	SelectServerReplyPacket* m_selectServerReplyPacket;
	NSString* m_previousServerIpString;
	BOOL m_redirect;
	int m_selectServerTimeoutCount;
	
	// for message restruction
	NSMutableDictionary* m_fragmentCache;
	
	// for login puzzle
	GetLoginTokenReplyPacket* m_firstGLTRP;
	
	// for change status packet, status version
	UInt16 m_statusVersion;
	
	// online cache
	NSMutableArray* m_onlines;
	
	// cluster name card cache
	NSMutableArray* m_clusterNameCards;
}

// fragment cache
- (void)addFragment:(id)im;
- (NSData*)constructMessage:(UInt16)messageId;
- (BOOL)isAllReceived:(UInt16)messageId;
- (void)clearFragments:(UInt16)messageId;

// timer
- (void)handleResendTimer:(NSTimer*)theTimer;
- (void)handleKeepAliveTimer:(NSTimer*)theTimer;

// initialization
- (id)initWithConnection:(QQConnection*)connection;

// network layer operation
- (void)start;
- (void)shutdown;
- (void)newConnection:(QQConnection*)connection;
- (void)releaseConnection:(int)connId;
- (QQConnection*)getConnection:(int)connId;

// status listener
- (void)addStatusListener:(id)listener;
- (void)removeStatusListener:(id)listener;
- (void)internalChangeStatus:(int)toStatus;

// common packet send routin
- (void)sendPacket:(OutPacket*)packet;
- (void)sendPacket:(OutPacket*)packet connection:(NSNumber*)connId;

// resend/duplicate management
- (OutPacket*)removeResendPacket:(InPacket*)packet;
- (void)cacheServerInitiativePacket:(InPacket*)packet;
- (BOOL)isDuplicate:(InPacket*)packet;

// qq listener
- (void)addQQListener:(id<QQListener>)listener;
- (void)removeQQListener:(id<QQListener>)listener;
- (void)trigger:(QQNotification*)event;

// qq event handler
- (BOOL)handleConnectionEstablished:(QQNotification*)event;
- (BOOL)handleConnectionReleased:(QQNotification*)event;
- (BOOL)handleSelectServerOK:(QQNotification*)event;
- (BOOL)handleSelectServerRedirect:(QQNotification*)event;
- (BOOL)handleTimeout:(QQNotification*)event;
- (BOOL)handleGetServerTokenOK:(QQNotification*)event;
- (BOOL)handleGetLoginTokenOK:(QQNotification*)event;
- (BOOL)handleNeedVerifyCode:(QQNotification*)event;
- (BOOL)handlePasswordVerifyOK:(QQNotification*)event;
- (BOOL)handleLoginOK:(QQNotification*)event;
- (BOOL)handleGetKeyOK:(QQNotification*)event;
- (BOOL)handleLoginRedirect:(QQNotification*)event;
- (BOOL)handleKeepAliveOK:(QQNotification*)event;
- (BOOL)handleGetOnlineFriendOK:(QQNotification*)event;
- (BOOL)handleChangeStatusOK:(QQNotification*)event;
- (BOOL)handleReceivedIM:(QQNotification*)event;
- (BOOL)handleBatchGetClusterNameCardOK:(QQNotification*)event;

// service
- (void)callIMService:(NSString*)msg obj:(id)obj callback:(id<IMServiceCallback>)callback;

// login methods
- (UInt16)selectServerFirstTime;
- (UInt16)selectServer:(UInt16)times unknown1:(char)unknown1 unknown2:(UInt32)unknown2 unknown3:(UInt32)unknown3 previousServerIp:(const char*)previousServerIp;
- (UInt16)getServerToken;
- (UInt16)getLoginToken;
- (UInt16)getLoginToken:(NSData*)serverToken;
- (UInt16)getLoginToken:(NSData*)serverToken imageToken:(NSData*)imageToken fragmentIndex:(int)fragmentIndex;
- (UInt16)verifyPassword;
- (UInt16)refreshVerifyCodeImage:(NSData*)token;
- (UInt16)submitVerifyCode:(NSData*)token verifyCode:(NSString*)code;
- (UInt16)login;
- (UInt16)logout;
- (UInt16)changeStatus:(char)status;
- (UInt16)changeStatus:(char)status message:(NSString*)statusMessage;
- (UInt16)changeStatusMessage:(NSString*)statusMessage;

// other methods
- (UInt16)getKey:(char)subCommand;
- (UInt16)getWeather;

// user related methods
- (UInt16)getUserInfo:(UInt32)QQ;
- (UInt16)getOnlineFriend;
- (UInt16)getOnlineFriend:(UInt32)startPosition;
- (UInt16)downloadGroupNames;
- (UInt16)uploadGroupNames:(NSArray*)groupNames;
- (UInt16)getFriendList;
- (UInt16)getFriendList:(UInt16)startPosition;
- (UInt16)getFriendGroup;
- (UInt16)getFriendGroup:(UInt32)startPosition;
- (UInt16)getFriendLevel:(NSArray*)friends;
- (UInt16)getFriendLevelByQQ:(UInt32)QQ;
- (UInt16)getUesrProperty;
- (UInt16)getUserProperty:(UInt16)startPosition;
- (UInt16)modifySignature:(NSString*)signature authInfo:(NSData*)authInfo;
- (UInt16)deleteSignature:(NSData*)authInfo;
- (UInt16)getSignature:(NSArray*)friends;
- (UInt16)getSignatureByQQ:(UInt32)QQ;
- (UInt16)getRemark:(UInt32)QQ;
- (UInt16)batchGetRemark:(char)page;
- (UInt16)uploadRemark:(FriendRemark*)remark;
- (UInt16)removeFriendFromServerList:(UInt32)QQ;
- (UInt16)modifyRemarkName:(UInt32)QQ name:(NSString*)name;
- (UInt16)modifyInfo:(ContactInfo*)info authInfo:(NSData*)authInfo;
- (UInt16)getMyQuestion;
- (UInt16)getUserQuestion:(UInt32)QQ;
- (UInt16)modifyQuestion:(NSString*)question answer:(NSString*)answer;
- (UInt16)answerQuestion:(UInt32)QQ answer:(NSString*)answer;
- (UInt16)setSearchMeByQQOnly:(BOOL)selected;
- (UInt16)setShareGeography:(BOOL)selected;
- (UInt16)searchOnlineUsers:(UInt32)page;
- (UInt16)searchUserByQQ:(UInt32)QQ page:(UInt32)page;
- (UInt16)searchUserByNick:(NSString*)nick page:(UInt32)page;
- (UInt16)advancedSearchUser:(BOOL)online hasCam:(BOOL)hasCam ageIndex:(UInt8)ageIndex genderIndex:(UInt8)genderIndex provinceIndex:(UInt16)provinceIndex cityIndex:(UInt16)cityIndex page:(int)page;
- (UInt16)addFriend:(UInt32)QQ;
- (UInt16)getModifyInfoAuthInfo:(UInt32)QQ;
- (UInt16)getDeleteUserAuthInfo:(UInt32)QQ;
- (UInt16)getUserAuthInfo:(UInt32)QQ;
- (UInt16)getUserAuthInfo:(UInt32)QQ verifyCode:(NSString*)verifyCode cookie:(NSString*)cookie;
- (UInt16)getUserTempSessionIMAuthInfo:(UInt32)QQ;
- (UInt16)getUserTempSessionIMAuthInfo:(UInt32)QQ verifyCode:(NSString*)verifyCode cookie:(NSString*)cookie;
- (UInt16)authorize:(UInt32)QQ authInfo:(NSData*)authInfo message:(NSString*)message allowAddMe:(BOOL)allowAddMe group:(int)destGroup;
- (UInt16)authorize:(UInt32)QQ authInfo:(NSData*)authInfo questionAuthInfo:(NSData*)questionAuthInfo allowAddMe:(BOOL)allowAddMe group:(int)destGroup;
- (UInt16)approveAuthorization:(UInt32)QQ;
- (UInt16)approveAuthorizationAndAddHim:(UInt32)QQ message:(NSString*)message;
- (UInt16)rejectAuthorization:(UInt32)QQ message:(NSString*)message;
- (UInt16)deleteFriend:(UInt32)QQ authInfo:(NSData*)authInfo;
- (UInt16)sendIM:(UInt32)receiver messageData:(NSData*)messageData style:(FontStyle*)style;
- (UInt16)sendIM:(UInt32)receiver messageData:(NSData*)messageData style:(FontStyle*)style fragmentCount:(int)fragmentCount fragmentIndex:(int)fragmentIndex;
- (UInt16)removeSelfFrom:(UInt32)QQ;
- (UInt16)uploadFriendGroup:(NSDictionary*)groupMapping;
- (UInt16)sendSMSToQQ:(UInt32)QQ senderName:(NSString*)senderName message:(NSData*)message sequence:(int)sequence;
- (UInt16)sendSMSToMobile:(NSString*)mobile senderName:(NSString*)senderName message:(NSData*)message sequence:(int)sequence;
- (UInt16)sendTempSessionIM:(UInt32)receiver messageData:(NSData*)messageData senderName:(NSString*)name senderSite:(NSString*)site style:(FontStyle*)style authInfo:(NSData*)authInfo;

// cluster methods
- (UInt16)getClusterInfo:(UInt32)internalId;
- (UInt16)modifyClusterInfo:(UInt32)internalId authType:(char)authType category:(UInt32)category name:(NSString*)name notice:(NSString*)notice description:(NSString*)description;
- (UInt16)updateOrganization:(UInt32)internalId;
- (UInt16)getMemberInfo:(UInt32)internalId members:(NSArray*)members;
- (UInt16)getOnlineMember:(UInt32)internalId;
- (UInt16)searchCluster:(UInt32)internalId;
- (UInt16)getClusterNameCard:(UInt32)internalId QQ:(UInt32)QQ;
- (UInt16)batchGetClusterNameCard:(UInt32)internalId versionId:(UInt32)versionId;
- (UInt16)batchGetClusterNameCard:(UInt32)internalId versionId:(UInt32)versionId startPosition:(UInt32)pos;
- (UInt16)getMessageSetting:(NSArray*)clusters;
- (UInt16)modifyMessageSetting:(UInt32)internalId externalId:(UInt32)externalId messageSetting:(char)messagetSetting;
- (UInt16)modifyChannelSetting:(UInt32)internalId notificationRight:(char)right;
- (UInt16)modifyChannelSetting:(UInt32)internalId channelId:(UInt32)channelId;
- (UInt16)modifyChannelSetting:(UInt32)internalId notificationRight:(char)right channelId:(UInt32)channelId;
- (UInt16)getChannelSetting:(UInt32)internalId externalId:(UInt32)externalId;
- (UInt16)getLastTalkTime:(UInt32)internalId externalId:(UInt32)externalId;
- (UInt16)modifyCard:(UInt32)internalId name:(NSString*)name genderIndex:(int)genderIndex phone:(NSString*)phone email:(NSString*)email remark:(NSString*)remark allowAdminModify:(BOOL)flag;
- (UInt16)addMember:(UInt32)internalId members:(NSArray*)members;
- (UInt16)removeMember:(UInt32)internalId members:(NSArray*)members;
- (UInt16)sendClusterIM:(UInt32)internalId messageData:(NSData*)messageData style:(FontStyle*)style;
- (UInt16)sendClusterIM:(UInt32)internalId messageData:(NSData*)messageData style:(FontStyle*)style fragmentCount:(int)fragmentCount fragmentIndex:(int)fragmentIndex;
- (UInt16)exitCluster:(UInt32)internalId;
- (UInt16)activateCluster:(UInt32)internalId;
- (UInt16)activateSubject:(UInt32)internalId parent:(UInt32)parentId;
- (UInt16)activateDialog:(UInt32)internalId;
- (UInt16)setAdminRole:(UInt32)internalId user:(UInt32)QQ;
- (UInt16)unsetAdminRole:(UInt32)internalId user:(UInt32)QQ;
- (UInt16)transferRole:(UInt32)internalId user:(UInt32)QQ;
- (UInt16)dismissCluster:(UInt32)internalId;
- (UInt16)getClusterAuthInfo:(UInt32)externalId;
- (UInt16)getClusterAuthInfo:(UInt32)externalId verifyCode:(NSString*)verifyCode cookie:(NSString*)cookie;
- (UInt16)joinCluster:(UInt32)internalId;
- (UInt16)requestJoinCluster:(UInt32)internalId authInfo:(NSData*)authInfo message:(NSString*)message;
- (UInt16)approveJoinCluster:(UInt32)internalId receiver:(UInt32)QQ authInfo:(NSData*)authInfo;
- (UInt16)rejectJoinCluster:(UInt32)internalId receiver:(UInt32)QQ authInfo:(NSData*)authInfo message:(NSString*)message;
- (UInt16)getVersionId:(UInt32)internalId;

// temp cluster methods
- (UInt16)getSubjectInfo:(UInt32)internalId parent:(UInt32)parentId;
- (UInt16)getDialogInfo:(UInt32)internalId;
- (UInt16)getSubjects:(UInt32)parentId;
- (UInt16)getDialogs;
- (UInt16)sendTempClusterIM:(UInt32)internalId parent:(UInt32)parentInternalId clusterType:(char)clusterType messageData:(NSData*)messageData style:(FontStyle*)style;
- (UInt16)sendTempClusterIM:(UInt32)internalId parent:(UInt32)parentInternalId clusterType:(char)clusterType messageData:(NSData*)messageData style:(FontStyle*)style fragmentCount:(int)fragmentCount fragmentIndex:(int)fragmentIndex;
- (UInt16)createSubject:(NSString*)name parent:(UInt32)parentInternalId members:(NSArray*)members;
- (UInt16)createDialog:(NSString*)name members:(NSArray*)members;
- (UInt16)exitSubject:(UInt32)internalId parent:(UInt32)parentId;
- (UInt16)exitDialog:(UInt32)internalId;
- (UInt16)modifySubjectInfo:(UInt32)internalId parent:(UInt32)parentInternalId name:(NSString*)name;
- (UInt16)modifyDialogInfo:(UInt32)internalId name:(NSString*)name;
- (UInt16)addSubjectMember:(UInt32)internalId parent:(UInt32)parentInternalId members:(NSArray*)members;
- (UInt16)removeSubjectMember:(UInt32)internalId parent:(UInt32)parentInternalId members:(NSArray*)members;
- (UInt16)addDialogMember:(UInt32)internalId members:(NSArray*)members;
- (UInt16)removeDialogMember:(UInt32)internalId members:(NSArray*)members;

// connection
- (UInt16)keepAlive;

// custom head methods
- (void)getCustomHeadInfo:(NSArray*)friends;
- (void)getCustomHeadData:(CustomHead*)head;
- (void)getCustomHeadData:(UInt32)QQ timestamp:(UInt32)timestamp;
- (void)getCustomHeadData:(UInt32)QQ timestamp:(UInt32)timestamp offset:(UInt32)offset length:(UInt32)length;

// setter and getter
- (BOOL)networkStarted;
- (QQUser*)user;
- (void)setQQUser:(QQUser*)user;
- (void)setDelegate:(id)delegate;
- (id)delegate;
- (QQConnection*)mainConnection;
- (int)mainConnectionId;

@end
