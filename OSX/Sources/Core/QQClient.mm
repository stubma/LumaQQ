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

#import <netinet/in.h>
#import <arpa/inet.h>
#import <sys/types.h>
#import <sys/socket.h>
#import "QQClient.h"
#import "QQEvent.h"
#import "NSNumber-Serialization.h"
#import "GetLoginTokenPacket.h"
#import "PasswordVerifyReplyPacket.h"
#import "NSData-MD5.h"
#import "NSData-QQCrypt.h"
#import "PacketParser.h"
#import "EventRouter.h"
#import "ByteTool.h"
#import "PasswordVerifyPacket.h"
#import "KeepAlivePacket.h"
#import "LogoutPacket.h"
#import "TempSessionOpPacket.h"
#import "TempClusterExitPacket.h"
#import "TempClusterActivatePacket.h"
#import "ClusterSetRolePacket.h"
#import "ClusterJoinPacket.h"
#import "LoginPacket.h"
#import "ClusterAuthorizePacket.h"
#import "GetCustomHeadDataPacket.h"
#import "GetKeyPacket.h"
#import "ChangeStatusPacket.h"
#import "GetUserInfoPacket.h"
#import "SendSMSPacket.h"
#import "UploadFriendGroupPacket.h"
#import "GetOnlineOpPacket.h"
#import "ClusterTransferRolePacket.h"
#import "ClusterDismissPacket.h"
#import "ClusterModifyCardPacket.h"
#import "ByteTool.h"
#import "FriendStatus.h"
#import "GetFriendListPacket.h"
#import "GetFriendGroupPacket.h"
#import "ClusterGetChannelSettingPacket.h"
#import "ClusterSendIMExPacket.h"
#import "ClusterActivatePacket.h"
#import "ClusterExitPacket.h"
#import "GroupDataOpPacket.h"
#import "ClusterGetLastTalkTimePacket.h"
#import "GetServerTokenPacket.h"
#import "LevelOpPacket.h"
#import "PropertyOpPacket.h"
#import "SignatureOpPacket.h"
#import "ReceivedIMPacket.h"
#import "ReceivedIMReplyPacket.h"
#import "ClusterModifyChannelSettingPacket.h"
#import "FriendDataOpPacket.h"
#import "ClusterGetInfoPacket.h"
#import "TempClusterGetInfoPacket.h"
#import "SelectServerPacket.h"
#import "ClusterModifyMessageSettingPacket.h"
#import "ClusterSubOpPacket.h"
#import "ClusterGetMessageSettingPacket.h"
#import "ClusterBatchGetCardPacket.h"
#import "ClusterUpdateOrganizationPacket.h"
#import "ClusterModifyInfoPacket.h"
#import "ClusterGetMemberInfoPacket.h"
#import "ClusterGetOnlineMemberPacket.h"
#import "ClusterModifyMemberPacket.h"
#import "ClusterGetCardPacket.h"
#import "ModifyInfoPacket.h"
#import "AuthQuestionOpPacket.h"
#import "PrivacyOpPacket.h"
#import "SearchUserPacket.h"
#import "AdvancedSearchUserPacket.h"
#import "ClusterSearchPacket.h"
#import "AuthInfoOpPacket.h"
#import "AddFriendPacket.h"
#import "AuthorizePacket.h"
#import "DeleteFriendPacket.h"
#import "SendIMPacket.h"
#import "RemoveSelfPacket.h"
#import "RequestFacePacket.h"
#import "BasicConnectionAdvisor.h"
#import "AgentConnectionAdvisor.h"
#import "RequestBeginPacket.h"
#import "ClientTransferPacket.h"
#import "RequestAgentPacket.h"
#import "ClusterGetVersionIdPacket.h"
#import "WeatherOpPacket.h"
#import "StatusEvent.h"
#import "TempClusterSendIMPacket.h"
#import "TempClusterCreatePacket.h"
#import "TempClusterModifyMemberPacket.h"
#import "TempClusterModifyInfoPacket.h"
#import "AuxiliaryConnectionAdvisor.h"
#import "GetCustomHeadInfoPacket.h"

@implementation QQClient

- (id) init {
	NSException* e = [NSException exceptionWithName:@"InitializationException"
											 reason:@"Forbid to use init() to initialize QQClient"
										   userInfo:nil];
	[e raise];
	return nil;
}

- (id)initWithConnection:(Connection*)connection {
	self = [super init];
	if(self) {
		[connection retain];
		m_mainConnection = connection;
		m_resendQueue = [[NSMutableArray array] retain];
		m_duplicateCache = [[NSMutableArray arrayWithCapacity:31] retain];
		m_fragmentCache = [[NSMutableDictionary dictionary] retain];
		m_redirect = NO;
		m_selectServerTimeoutCount = 0;
		m_network = nil;
		m_parser = [[PacketParser alloc] initWithKeyProvider:self];
		m_statusListenerChanged = NO;
		m_statusListeners = [[NSMutableArray array] retain];
		m_statusListenersBackup = [[NSMutableArray array] retain];
		m_onlines = [[NSMutableArray array] retain];
		m_status = kQQStatusNotStarted;
		m_statusVersion = 1;
		
		// install observers
		m_notificationCenter = [[QQNotificationCenter alloc] init];
		[m_notificationCenter addQQListener:self];
		
		// install custom face listener
		m_clusterFaceReceiver = [[ClusterFaceReceiver alloc] initWithClient:self];
		[m_notificationCenter addQQListener:m_clusterFaceReceiver];
		m_clusterFaceSender = [[ClusterFaceSender alloc] initWithClient:self];
		[m_notificationCenter addQQListener:m_clusterFaceSender];
		m_customFaceListMapping = [[NSMutableDictionary dictionary] retain];
		
		// install custom head listener
		m_customHeadReceiver = [[CustomHeadReceiver alloc] initWithClient:self];
		[m_notificationCenter addQQListener:m_customHeadReceiver];
		
		// initial timer
		m_resendTimer = [[NSTimer scheduledTimerWithTimeInterval:1
										 target:self
									   selector:@selector(handleResendTimer:)
									   userInfo:nil
										repeats:YES] retain];
		m_keepAliveTimer = [[NSTimer scheduledTimerWithTimeInterval:120
										 target:self
									   selector:@selector(handleKeepAliveTimer:)
									   userInfo:nil
										repeats:YES] retain];
	}
	return self;
}

- (void) dealloc {	
	// release timer
	if(m_resendTimer) {
		if([m_resendTimer isValid])
			[m_resendTimer invalidate];
		[m_resendTimer release];
	}
	if(m_keepAliveTimer) {
		if([m_keepAliveTimer isValid])
			[m_keepAliveTimer invalidate];
		[m_keepAliveTimer release];
	}
	
	// remove listener
	[m_notificationCenter removeQQListener:self];
	[m_notificationCenter removeQQListener:m_clusterFaceReceiver];
	[m_notificationCenter removeQQListener:m_clusterFaceSender];
	[m_notificationCenter removeQQListener:m_customHeadReceiver];
	
	// release object
	[m_mainLoop release];
	[m_customFaceListMapping release];
	[m_statusListeners release];
	[m_statusListenersBackup release];
	[m_resendQueue release];
	[m_parser release];
	[m_localPort release];
	[m_networkPort release];
	[m_mainConnection release];
	[m_user release];
	[m_notificationCenter release];
	[m_duplicateCache release];
	[m_fragmentCache release];
	[m_delegate release];
	[m_clusterFaceReceiver release];
	[m_clusterFaceSender release];
	[m_customHeadReceiver release];
	[m_network release];
	[m_firstGLTRP release];
	[m_onlines release];
	[super dealloc];
}

#pragma mark -
#pragma mark network layer operation

- (void)startNetworkLayer {
	// reset timeout count
	m_selectServerTimeoutCount = 0;
	
	// create my port
	m_localPort = [[NSMachPort port] retain];
	
	if(m_localPort) {		
		// create network layer object
		if(m_network)
			[m_network release];
		m_network = [[NetworkLayer alloc] init];
		
		// register connection advisor
		[m_network registerConnectionAdvisor:kQQFamilyBasic advisor:[[[BasicConnectionAdvisor alloc] init] autorelease]];
		[m_network registerConnectionAdvisor:kQQFamilyAgent advisor:[[[AgentConnectionAdvisor alloc] init] autorelease]];
		[m_network registerConnectionAdvisor:kQQFamilyAuxiliary advisor:[[[AuxiliaryConnectionAdvisor alloc] init] autorelease]];
		
		// set delegate to self
		[m_localPort setDelegate:self];
		
		// add port to main thread loop
		m_mainLoop = [[NSRunLoop currentRunLoop] retain];
		[m_localPort scheduleInRunLoop:m_mainLoop forMode:NSDefaultRunLoopMode];
		
		// create network layer thread
		m_bNetworkStarted = YES;
		[NSThread detachNewThreadSelector:@selector(threadEntryPoint:)
								 toTarget:m_network withObject:m_localPort];
	}
}

- (void)shutdownNetworkLayer {
	// if network is startd, send shutdown message
	if(m_bNetworkStarted) {
		NSPortMessage* msg = [[NSPortMessage alloc] initWithSendPort:m_networkPort
														 receivePort:m_localPort
														  components:nil];
		if(msg) {
			[msg setMsgid:kQQMessageShutdown];
			[msg sendBeforeDate:[NSDate date]];
			[msg release];
		}
		
		// remove port
		[m_localPort removeFromRunLoop:m_mainLoop forMode:NSDefaultRunLoopMode];
		
		// ensure user is not logged
		[m_user setLogged:NO];
		
		// reset cluster face receiver status
		[m_clusterFaceReceiver reset];
		
		// internal change status
		[self internalChangeStatus:kQQStatusDead];
		
		// change flag
		m_bNetworkStarted = NO;
	}
}

- (void)newConnection:(Connection*)connection {
	// send connection parameters to network thread
	if(m_bNetworkStarted) {
		NSMutableArray* array = [NSMutableArray array];
		[array addObject:[connection serialize]];
		NSPortMessage* msg = [[NSPortMessage alloc] initWithSendPort:m_networkPort
														 receivePort:m_localPort
														  components:array];
		if(msg) {
			[msg setMsgid:kQQMessageNewConnection];
			[msg sendBeforeDate:[NSDate date]];
			[msg release];
		}
	}
}

- (void)releaseConnection:(int)connId {
	if(m_bNetworkStarted) {
		NSArray* component = [NSArray arrayWithObject:[[NSNumber numberWithInt:connId] serialize]];
		NSPortMessage* msg = [[NSPortMessage alloc] initWithSendPort:m_networkPort
														 receivePort:m_localPort
														  components:component];
		if(msg) {
			[msg setMsgid:kQQMessageReleaseConnection];
			[msg sendBeforeDate:[NSDate date]];
			[msg release];
		}
	}
}

- (Connection*)getConnection:(int)connId {
	return [m_network getConnection:[NSNumber numberWithInt:connId]];
}

#pragma mark -
#pragma mark mach port delegate

- (void)handlePortMessage:(NSPortMessage*)portMessage
{	
    unsigned int message = [portMessage msgid];

	switch(message) {
		case kQQMessageCheckIn:
			[self handleCheckInMessage:portMessage];
			break;
		case kQQMessageConnectionEstablished:
			[self handleConnectionEstablishedMessage:portMessage];
			break;
		case kQQMessageConnectionCreationFailed:
			[self handleConnectionCreationFailedMessage:portMessage];
			break;
		case kQQMessageConnectionReleased:
			[self handleConnectionReleasedMessage:portMessage];
			break;
		case kQQMessageConnectionBroken:
			[self handleConnectionBrokenMessage:portMessage];
			break;
		case kQQMessageReceived:
			[self handleReceivedMessage:portMessage];
			break;
	}
}

#pragma mark -
#pragma mark message handler

- (void)handleCheckInMessage:(NSPortMessage*)portMessage {	
	// save network layer port
	m_networkPort = [[portMessage sendPort] retain];
	
	// send qq event
	QQNotification* event = [[QQNotification alloc] initWithId:kQQEventNetworkStarted packet:nil];
	[self trigger:event];
	[event release];
	
	// change status
	[self internalChangeStatus:kQQStatusStarted];
	
	// start main connection
	[self newConnection:m_mainConnection];
}

- (void)handleConnectionEstablishedMessage:(NSPortMessage*)portMessage {
	// get connection id
	NSArray* component = [portMessage components];
	NSNumber* connId = [NSNumber deserialize:[component objectAtIndex:0]];
	
	// log
	NSLog(@"Connection %d is established!", [connId intValue]);
	
	// trigger event
	QQNotification* event = [[QQNotification alloc] initWithId:kQQEventNetworkConnectionEstablished connection:[connId intValue]];
	[self trigger:event];
	[event release];
}

- (void)handleConnectionReleasedMessage:(NSPortMessage*)portMessage {
	// get connection id
	NSArray* component = [portMessage components];
	NSNumber* connId = [NSNumber deserialize:[component objectAtIndex:0]];
	
	// log
	NSLog(@"Connection %d is released", [connId intValue]);
	
	// trigger event
	QQNotification* event = [[QQNotification alloc] initWithId:kQQEventNetworkConnectionReleased connection:[connId intValue]];
	[self trigger:event];
	[event release];
}

- (void)handleConnectionCreationFailedMessage:(NSPortMessage*)portMessage {
	[self handleConnectionBrokenMessage:portMessage];
}

- (void)handleConnectionBrokenMessage:(NSPortMessage*)portMessage {
	// get connection id
	NSArray* component = [portMessage components];
	NSNumber* connId = [NSNumber deserialize:[component objectAtIndex:0]];
	
	// trigger event
	QQNotification* event = [[QQNotification alloc] initWithId:kQQEventNetworkError connection:[connId intValue]];
	[self trigger:event];
	[event release];
}

- (void)handleReceivedMessage:(NSPortMessage*)portMessage {
	// iterate all received packet and trigger event
	NSArray* component = [portMessage components];
	NSNumber* connId = [NSNumber deserialize:[component objectAtIndex:0]];

	NSEnumerator* e = [component objectEnumerator];
	[e nextObject]; // skip connection id
	while(NSData* encryptedData = [e nextObject]) {
		// get packet
		InPacket* packet = [m_parser packetWithData:encryptedData user:m_user];
		
		if(packet) {
			// retain
			[packet retain];
			
			// is server initiative?
			if([packet isServerInitiative]) {
				if(![self isDuplicate:packet]) {
					[self cacheServerInitiativePacket:packet];
					[EventRouter route:packet outPacket:nil connectionId:[connId intValue] client:self];
				}
			} else {
				// remove resend packet
				if(OutPacket* outPacket = [self removeResendPacket:packet]) {				
					// trigger qq event
					[EventRouter route:packet outPacket:outPacket connectionId:[connId intValue] client:self];
				} else if([packet triggerAnyway]) {
					[EventRouter route:packet outPacket:nil connectionId:[connId intValue] client:self];
				}
			}
			
			// release
			[packet release];
		}
	}
}

#pragma mark -
#pragma mark status listener

- (void)addStatusListener:(id<StatusListener>)listener {
	[m_statusListeners addObject:listener];
	m_statusListenerChanged = YES;
	
	// trigger event when a new listener attached
	[self internalChangeStatus:m_status];
}

- (void)removeStatusListener:(id<StatusListener>)listener {
	[m_statusListeners removeObject:listener];
	m_statusListenerChanged = YES;
}

- (void)internalChangeStatus:(int)toStatus {
	// check listener array
	if(m_statusListenerChanged) {
		[m_statusListenersBackup removeAllObjects];
		[m_statusListenersBackup addObjectsFromArray:m_statusListeners];
		m_statusListenerChanged = NO;
	}
	
	// create notification object
	StatusEvent* n = [[[StatusEvent alloc] initWithId:kQQClientStatusChanged oldStatus:m_status newStatus:toStatus] autorelease];
	
	// deliver
	int count = [m_statusListenersBackup count];
	for(int i = 0; i < count; i++) {
		id<StatusListener> listener = [m_statusListenersBackup objectAtIndex:i];
		if([listener handleStatusEvent:n])
			break;
	}
	
	// make change
	m_status = toStatus;
}

#pragma mark -
#pragma mark fragment cache

- (void)addFragment:(id)im {
	NSNumber* key = [NSNumber numberWithInt:[im messageId]];
	NSMutableArray* array = [m_fragmentCache objectForKey:key];
	if(array == nil) {
		array = [NSMutableArray array];
		[m_fragmentCache setObject:array forKey:key];
	}
	if(![array containsObject:im])
		[array addObject:im];
}

- (NSData*)constructMessage:(UInt16)messageId {
	// get fragment array
	NSMutableArray* array = [m_fragmentCache objectForKey:[NSNumber numberWithInt:messageId]];
	if(array == nil)
		return @"";
	
	// sort
	[array sortUsingSelector:@selector(compare:)];

	// create whole data
	NSMutableData* data = [NSMutableData data];
	NSEnumerator* e = [array objectEnumerator];
	while(id im = [e nextObject])
		[data appendData:[im messageData]];
	return data;
}

- (void)clearFragments:(UInt16)messageId {
	[m_fragmentCache removeObjectForKey:[NSNumber numberWithInt:messageId]];
}

- (BOOL)isAllReceived:(UInt16)messageId {
	NSMutableArray* array = [m_fragmentCache objectForKey:[NSNumber numberWithInt:messageId]];
	if(array == nil)
		return NO;
	
	if([array count] == 0)
		return NO;
	
	id im = [array objectAtIndex:0];
	return [array count] == [im fragmentCount];
}

#pragma mark -
#pragma mark qq listener management

- (void)addQQListener:(id<QQListener>)listener {
	if(!m_notificationCenter) {
		m_notificationCenter = [[QQNotificationCenter alloc] init];
		if(m_notificationCenter)
			[m_notificationCenter addQQListener:self];
	}
	
	[m_notificationCenter addQQListener:listener];
}

- (void)removeQQListener:(id<QQListener>)listener {
	if(m_notificationCenter)
		[m_notificationCenter removeQQListener:listener];
}

- (void)trigger:(QQNotification*)event {
	if(event) {
		[m_notificationCenter postNotification:event];
	}
}

#pragma mark -
#pragma mark debug listener

- (void)addDebugListener:(id<DebugListener>)listener {
	if(m_user != nil)
		[m_user addDebugListener:listener];
}

- (void)removeDebugListener:(id<DebugListener>)listener {
	if(m_user != nil)
		[m_user removeDebugListener:listener];
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventNetworkConnectionEstablished:
			ret = [self handleConnectionEstablished:event];
			break;
		case kQQEventNetworkConnectionReleased:
			ret = [self handleConnectionReleased:event];
			break;
		case kQQEventSelectServerOK:
			ret = [self handleSelectServerOK:event];
			break;
		case kQQEventSelectServerRedirect:
			ret = [self handleSelectServerRedirect:event];
			break;
		case kQQEventGetServerTokenOK:
			ret = [self handleGetServerTokenOK:event];
			break;
		case kQQEventGetLoginTokenOK:
			ret = [self handleGetLoginTokenOK:event];
			break;
		case kQQEventNeedVerifyCode:
			ret = [self handleNeedVerifyCode:event];
			break;
		case kQQEventPasswordVerifyOK:
			ret = [self handlePasswordVerifyOK:event];
			break;
		case kQQEventLoginOK:
			ret = [self handleLoginOK:event];
			break;
		case kQQEventPasswordVerifyFailed:
		case kQQEventLoginFailed:
			[self shutdownNetworkLayer];
			break;
		case kQQEventLoginRedirect:
			ret = [self handleLoginRedirect:event];
			break;
		case kQQEventKeepAliveOK:
			ret = [self handleKeepAliveOK:event];
			break;
		case kQQEventGetKeyOK:
			ret = [self handleGetKeyOK:event];
			break;
		case kQQEventGetOnlineFriendOK:
			ret = [self handleGetOnlineFriendOK:event];
			break;
		case kQQEventChangeStatusOK:
			ret = [self handleChangeStatusOK:event];
			break;
		case kQQEventReceivedIM:
			ret = [self handleReceivedIM:event];
			break;
		case kQQEventTimeoutBasic:
			ret = [self handleTimeout:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleTimeout:(QQNotification*)event {
	OutPacket* packet = [event outPacket];
	switch([packet command]) {
		case kQQCommandSelectServer:
			// increase timeout count
			m_selectServerTimeoutCount++;
			if(m_selectServerTimeoutCount > kLQTCPServerCount) {
				// trigger event
				QQNotification* event = [[QQNotification alloc] initWithId:kQQEventNetworkError connection:[self mainConnectionId]];
				[self trigger:event];
				return YES;
			}
			
			// release reply packet
			if(m_selectServerReplyPacket) {
				[m_selectServerReplyPacket release];
				m_selectServerReplyPacket = nil;
			}
				
			// set redirect flag
			m_redirect = YES;
			
			// request close current connection
			[self releaseConnection:[self mainConnectionId]];
			
			return YES;
		case kQQCommandGetServerToken:
			// trigger event
			QQNotification* event = [[QQNotification alloc] initWithId:kQQEventNetworkError connection:[self mainConnectionId]];
			[self trigger:event];
			return YES;
	}
	return NO;
}

- (BOOL)handleConnectionEstablished:(QQNotification*)event {
	// if the connection is main connection, start login process
	// this maybe a redirect, so we check login token
	if([event connectionId] == [self mainConnectionId]) {
		if(m_selectServerReplyPacket) {
			NSData* data = [ByteTool string2IpData:m_previousServerIpString];
			if(data == nil)
				[self selectServerFirstTime];
			else {
				[self selectServer:[m_selectServerReplyPacket nextTimes]
						  unknown1:[m_selectServerReplyPacket unknown1]
						  unknown2:[m_selectServerReplyPacket unknown2]
						  unknown3:[m_selectServerReplyPacket unknown3]
				  previousServerIp:(const char*)[data bytes]];
			}
			
			// release
			[m_selectServerReplyPacket release];
			m_selectServerReplyPacket = nil;
			[m_previousServerIpString release];
			m_previousServerIpString = nil;
		} else if([m_user loginToken] == nil)
			[self selectServerFirstTime];
		else
			[self login];
	}
	return NO;
}

- (BOOL)handleConnectionReleased:(QQNotification*)event {
	// if the connection is main connection, means we are redirecting login
	if([event connectionId] == [self mainConnectionId] && m_redirect) {
		// reset connection server address
		if(m_selectServerReplyPacket) {
			// save previous server ip
			m_previousServerIpString = [m_mainConnection server];
			NSData* data = [ByteTool string2IpData:m_previousServerIpString];
			if(data == nil) {
				in_addr_t addr = inet_addr([m_previousServerIpString cString]);
				m_previousServerIpString = [ByteTool ip2String:(const char*)&addr];
			}
			[m_previousServerIpString retain];
			
			[m_mainConnection setConnectionId:[NSNumber numberWithInt:[Connection nextAvailableConnectionId]]];
			[m_mainConnection setServer:[ByteTool ip2String:[m_selectServerReplyPacket redirectServerIp]]];
		} else if(m_loginReplyPacket) {
			[m_mainConnection setConnectionId:[NSNumber numberWithInt:[Connection nextAvailableConnectionId]]];
			[m_mainConnection setServer:[ByteTool ip2String:[m_loginReplyPacket redirectServerIp]]];
			[m_loginReplyPacket release];
			m_loginReplyPacket = nil;
		} else {
			[m_mainConnection setConnectionId:[NSNumber numberWithInt:[Connection nextAvailableConnectionId]]];
			[m_mainConnection setServer:LQTCPServers[MIN(MAX(0, kLQTCPServerCount - m_selectServerTimeoutCount), kLQTCPServerCount - 1)]];
		}
		
		// send message
		[self newConnection:m_mainConnection];
		
		// clear redirect flag
		m_redirect = NO;
	}
	
	return NO;
}

- (BOOL)handleSelectServerOK:(QQNotification*)event {
	// login need selected server info, remember first 16 bytes is random key, need skip it
	SelectServerPacket* packet = (SelectServerPacket*)[event outPacket];
	NSData* body = [packet plainBody];
	[m_user setSelectedServer:[body subdataWithRange:NSMakeRange(kQQKeyLength, [body length] - kQQKeyLength)]];
	[self getServerToken];
	return NO;
}

- (BOOL)handleSelectServerRedirect:(QQNotification*)event {
	// refresh key
	[m_user refreshSelectServerRandomKey];
	
	// save reply packet
	SelectServerReplyPacket* packet = [event object];
	[packet retain];
	[m_selectServerReplyPacket release];
	m_selectServerReplyPacket = packet;
	
	// request close current connection
	[self releaseConnection:[self mainConnectionId]];
	
	// set redirect flag
	m_redirect = YES;
	
	return NO;
}

- (BOOL)handleChangeStatusOK:(QQNotification*)event {
	ChangeStatusPacket* packet = (ChangeStatusPacket*)[event outPacket];
	[m_user setStatus:[packet status]];
	
	// change status
	if(m_status == kQQStatusLoggedIn)
		[self internalChangeStatus:kQQStatusReadyToSpeak];
	
	return NO;
}

- (BOOL)handleGetServerTokenOK:(QQNotification*)event {
	GetServerTokenReplyPacket* packet = (GetServerTokenReplyPacket*)[event object];
	[m_user setServerToken:[packet serverToken]];
	[self getLoginToken:[packet serverToken]];
	return NO;
}

- (BOOL)handleGetLoginTokenOK:(QQNotification*)event {
	GetLoginTokenReplyPacket* packet = (GetLoginTokenReplyPacket*)[event object];
	[m_user setLoginToken:[packet token]];
	[m_firstGLTRP release];
	m_firstGLTRP = nil;
	[self verifyPassword];
	return NO;
}

- (BOOL)handleNeedVerifyCode:(QQNotification*)event {
	GetLoginTokenReplyPacket* packet = (GetLoginTokenReplyPacket*)[event object];
	if([packet finished]) {
		if(m_firstGLTRP != nil) {
			NSMutableData* data = [NSMutableData data];
			[data appendData:[m_firstGLTRP puzzleData]];
			[data appendData:[packet puzzleData]];
			[packet setPuzzleData:data];
		}
			
		// if no more fragment, let up layer handle this
		return NO;
	} else {
		if([packet fragmentIndex] == 0) {
			[packet retain];
			[m_firstGLTRP release];
			m_firstGLTRP = packet;
		} else if(m_firstGLTRP != nil) {
			NSMutableData* data = [NSMutableData data];
			[data appendData:[m_firstGLTRP puzzleData]];
			[data appendData:[packet puzzleData]];
			[m_firstGLTRP setPuzzleData:data];
		}
		[self getLoginToken:[m_user serverToken] imageToken:[packet nextFragmentToken] fragmentIndex:[packet nextFragmentIndex]];
		return YES;
	}
}

- (BOOL)handlePasswordVerifyOK:(QQNotification*)event {
	PasswordVerifyReplyPacket* packet = (PasswordVerifyReplyPacket*)[event object];
	[m_user setInitialKey:[packet loginKey]];
	[m_user setPassport:[packet passport]];
	[self login];
	return NO;
}

- (BOOL)handleLoginRedirect:(QQNotification*)event {
	LoginReplyPacket* packet = (LoginReplyPacket*)[event object];
	
	// request close current connection
	[self releaseConnection:[self mainConnectionId]];
	
	// save packet for later use
	[packet retain];
	[m_loginReplyPacket release];
	m_loginReplyPacket = packet;
	
	// set redirect flag
	m_redirect = YES;
	
	return NO;
}

- (BOOL)handleLoginOK:(QQNotification*)event {	
	LoginReplyPacket* packet = (LoginReplyPacket*)[event object];
	
	// set variables
	[m_user setLogged:YES];
	[m_user setSessionKey:[packet sessionKey]];
	[m_user setAuthToken:[packet authToken]];
	[m_user setClientKey:[packet clientKey]];
	[m_user setIp:[packet ip]];
	[m_user setPort:[packet port]];
	[m_user setServerIp:[packet serverIp]];
	[m_user setServerPort:[packet serverPort]];
	[m_user setLastLoginTime:[packet lastLoginTime]];
	[m_user setLastLoginIp:[packet lastLoginIp]];
	[m_user setLoginTime:[packet loginTime]];
	
	// get keys
	[self getKey:kQQSubCommandGet03Key];
	[self getKey:kQQSubCommandGetFileAgentKey];
	[self getKey:kQQSubCommandGet06Key];
	[self getKey:kQQSubCommandGet07Key];
	[self getKey:kQQSubCommandGet08Key];
	[self getKey:kQQSubCommandGet0AKey];
	[self getKey:kQQSubCommandGet0BKey];
	[self getKey:kQQSubCommandGet0CKey];
	[self getKey:kQQSubCommandGet0EKey];
	
	// generate file session key
	NSMutableData* data = [NSMutableData dataWithLength:(4 + kQQKeyLength)];
	char* buffer = (char*)[data mutableBytes];
	ByteBuffer* bb = [ByteBuffer bufferWithBytes:buffer length:(4 + kQQKeyLength)];
	[bb writeUInt32:[m_user QQ]];
	[bb writeBytes:[packet sessionKey]];
	NSData* fileSessionKey = [data MD5];
	[m_user setFileSessionKey:fileSessionKey];
	
	// get my info
	[self getUserInfo:[m_user QQ]];
	
	// change status
	[self changeStatus:[m_user loginStatus]];
	
	// internal change status
	[self internalChangeStatus:kQQStatusLoggedIn];
	
	return NO;
}

- (BOOL)handleGetKeyOK:(QQNotification*)event {	
	GetKeyReplyPacket* packet = (GetKeyReplyPacket*)[event object];
	[m_user set001DKey:[packet subCommand] key:[packet key]];
	[m_user set001DToken:[packet subCommand] token:[packet token]];
	return NO;
}

- (BOOL)handleKeepAliveOK:(QQNotification*)event {
	KeepAliveReplyPacket* packet = (KeepAliveReplyPacket*)[event object];
	
	[m_user setOnlines:[packet online]];
	[self getOnlineFriend];
	return NO;
}

- (BOOL)handleGetOnlineFriendOK:(QQNotification*)event {
	GetOnlineOpReplyPacket* packet = (GetOnlineOpReplyPacket*)[event object];
	[m_onlines addObjectsFromArray:[packet friends]];
	
	// if not finished, continute to get online friends
	if([packet reply] == kQQReplyOK) {
		UInt32 start = 0;
		NSArray* friends = [packet friends];
		NSEnumerator* e = [friends objectEnumerator];
		FriendStatus* fs = nil;
		while(fs = [e nextObject]) {
			if([fs QQ] > start)
				start = [fs QQ] + 1;
		}
		
		// get next
		if(start > 0)
			[self getOnlineFriend:start];
		
		// filter this event until if not fully completed
		return YES;
	} else {
		[packet setFriends:m_onlines];
	}
	return NO;
}

- (BOOL)handleReceivedIM:(QQNotification*)event {
	BOOL ret = NO;
	ReceivedIMPacket* packet = [event object];
	
	// check whether it's a big message, if so, only reply it when all fragments received
	switch([[packet imHeader] type]) {
		case kQQIMTypeFriend:
		case kQQIMTypeStranger:
		case kQQIMTypeFriendEx:
		case kQQIMTypeStrangerEx:
			NormalIM* normalIM = [packet normalIM];
			if([normalIM fragmentCount] > 1) {
				// cache this fragment
				[self addFragment:normalIM];
				
				// check
				if([self isAllReceived:[normalIM messageId]]) {
					NSData* data = [self constructMessage:[normalIM messageId]];
					[normalIM setMessageData:data];
					[self clearFragments:[normalIM messageId]];
				} else {
					// all are not received, so we screen this event until all fragments are ok
					ret = YES;
				}
			} 
			break;
		case kQQIMTypeCluster:
		case kQQIMTypeTempCluster:
		case kQQIMTypeClusterUnknown:
			ClusterIM* clusterIM = [packet clusterIM];
			if([clusterIM fragmentCount] > 1) {
				// cache fragment
				[self addFragment:clusterIM];
				
				// check 
				if([self isAllReceived:[clusterIM messageId]]) {
					NSData* data = [self constructMessage:[clusterIM messageId]];
					[clusterIM setMessageData:data];
					
					// if it isn't last fragment, then need set font style
					if(![clusterIM hasFontStyle]) {
						NSArray* fragments = [m_fragmentCache objectForKey:[NSNumber numberWithInt:[clusterIM messageId]]];
						NSEnumerator* e = [fragments objectEnumerator];
						while(ClusterIM* im = [e nextObject]) {
							if([im hasFontStyle]) {
								[clusterIM setFontStyle:[im fontStyle]];
								break;
							}
						}
					}
					
					// clear fragments
					[self clearFragments:[clusterIM messageId]];
					
					// build custom face list
					CustomFaceList* faceList = [ByteTool buildCustomFaceList:[clusterIM messageData] owner:[[packet imHeader] sender]];
					if(faceList) {
						[m_customFaceListMapping setObject:faceList forKey:packet];
						[self getClusterCustomFaces:faceList];
					}
				} else {
					ret = YES;
				}
			} else {
				// build custom face list
				CustomFaceList* faceList = [ByteTool buildCustomFaceList:[clusterIM messageData] owner:[[packet imHeader] sender]];
				if(faceList) {
					[m_customFaceListMapping setObject:faceList forKey:packet];
					[self getClusterCustomFaces:faceList];
				}
			}
			break;
	}
	
	// send reply
	ReceivedIMReplyPacket* reply = [[ReceivedIMReplyPacket alloc] initWithQQUser:m_user];
	[reply setSequence:[packet sequence]];
	[reply setNeedAck:NO];
	[reply setSender:[[packet imHeader] sender]];
	[reply setReceiver:[[packet imHeader] receiver]];
	[reply setMessageSequence:[[packet imHeader] messageSequence]];
	[reply setSenderIp:[[packet imHeader] senderIp]];
	[self sendPacket:reply];
	[reply release];
	
	return ret;
}

#pragma mark -
#pragma mark common packet send routine

- (void)sendPacket:(OutPacket*)packet {
	if(m_bNetworkStarted) {
		if([packet connectionId] == nil || [[packet connectionId] intValue] < 0)
			[self sendPacket:packet connection:[m_mainConnection connectionId]];
		else
			[self sendPacket:packet connection:[packet connectionId]];
	}
}

- (void)sendPacket:(OutPacket*)packet connection:(NSNumber*)connId {
	if(m_bNetworkStarted) {
		// set connection id
		[packet retain];
		if([packet connectionId] == nil)
			[packet setConnectionId:connId];
		
		// check connection existence
		if([self getConnection:[[packet connectionId] intValue]] == nil)
			return;
		
		// check waiting list size
		if([m_resendQueue count] >= 30) {
			// trigger network busy event
			QQNotification* event = [[QQNotification alloc] initWithId:kQQEventNetworkBusy
																packet:nil];
			[self trigger:event];
			[event release];
			return;
		}
		
		// get encrypted data
		NSData* encryptData = [[packet encrypted] retain];
		
		// set send time and sent count, then add to resend queue
		if([packet needAck]) {
			[packet increaseSendCount];
			[packet setSentDate:[NSDate date]];
			[m_resendQueue addObject:packet];
		}
		
		// create port message component
		NSMutableArray* component = [NSMutableArray arrayWithCapacity:2];
		[component addObject:[connId serialize]];
		[component addObject:encryptData];
		
		// release packet
		[packet release];
		[encryptData release];
		
		// create message and send
		NSPortMessage* msg = [[NSPortMessage alloc] initWithSendPort:m_networkPort
														 receivePort:m_localPort
														  components:component];
		if(msg) {
			[msg setMsgid:kQQMessageSend];
			
			// if this packet doesn't need to be replied, send it for specified times
			if(![packet needAck]) {
				int count = [packet repeatTimeIfNoAck];
				while(count-- > 0) {
					[msg sendBeforeDate:[NSDate date]];
				}
			} else {
				[msg sendBeforeDate:[NSDate date]];
			}
			
			[msg release];
		}
	}
}

#pragma mark -
#pragma mark resend/duplicate management

//
// if the source packet is found and removed, return YES
//
- (OutPacket*)removeResendPacket:(InPacket*)packet {
	int count = [m_resendQueue count];
	for(int i = 0; i < count; i++) {
		OutPacket* outPacket = [m_resendQueue objectAtIndex:i];
		if([outPacket isEqual:packet]) {
			[outPacket retain];
			[m_resendQueue removeObjectAtIndex:i];
			return [outPacket autorelease];
		}
	}
	return nil;
}

- (void)cacheServerInitiativePacket:(InPacket*)packet {
	// cache hash value
	[m_duplicateCache addObject:[NSNumber numberWithInt:[packet hash]]];
	
	// exceed threshold?
	while([m_duplicateCache count] > 30)
		[m_duplicateCache removeObjectAtIndex:0];
}

- (BOOL)isDuplicate:(InPacket*)packet {
	int count = [m_duplicateCache count];
	for(int i = 0; i < count; i++) {
		NSNumber* hash = [m_duplicateCache objectAtIndex:i];
		if([hash unsignedIntValue] == [packet hash])
			return YES;
	}
	
	return NO;
}

#pragma mark -
#pragma mark login methods

- (UInt16)selectServerFirstTime {
	UInt16 seq = 0;
	if(m_bNetworkStarted) {
		SelectServerPacket* packet = [[SelectServerPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)selectServer:(UInt16)times unknown1:(char)unknown1 unknown2:(UInt32)unknown2 unknown3:(UInt32)unknown3 previousServerIp:(const char*)previousServerIp {
	UInt16 seq = 0;
	if(m_bNetworkStarted) {
		SelectServerPacket* packet = [[SelectServerPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setTimes:times];
		[packet setUnknown1:unknown1];
		[packet setUnknown2:unknown2];
		[packet setUnknown3:unknown3];
		[packet setPreviousServerIp:previousServerIp];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getServerToken {
	UInt16 seq = 0;
	if(m_bNetworkStarted) {
		GetServerTokenPacket* packet = [[GetServerTokenPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getLoginToken {
	UInt16 seq = 0;
	if(m_bNetworkStarted) {
		GetLoginTokenPacket* packet = [[GetLoginTokenPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getLoginToken:(NSData*)serverToken {
	return [self getLoginToken:serverToken imageToken:nil fragmentIndex:0];
}

- (UInt16)getLoginToken:(NSData*)serverToken imageToken:(NSData*)imageToken fragmentIndex:(int)fragmentIndex {
	UInt16 seq = 0;
	if(m_bNetworkStarted) {
		GetLoginTokenPacket* packet = [[GetLoginTokenPacket alloc] initWithQQUser:m_user];
		[packet setSubCommand:kQQSubCommandGetLoginTokenEx];
		[packet setFragmentIndex:fragmentIndex];
		if(imageToken != nil)
			[packet setPuzzleToken:imageToken];
		seq = [packet sequence];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)verifyPassword {
	UInt16 seq = 0;
	if(m_bNetworkStarted) {
		PasswordVerifyPacket* packet = [[PasswordVerifyPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)refreshVerifyCodeImage:(NSData*)token {
	UInt16 seq = 0;
	if(m_bNetworkStarted) {
		GetLoginTokenPacket* packet = [[GetLoginTokenPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandSubmitVerifyCodeEx];
		[packet setPuzzleToken:token];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)submitVerifyCode:(NSData*)token verifyCode:(NSString*)code {
	UInt16 seq = 0;
	if(m_bNetworkStarted) {
		GetLoginTokenPacket* packet = [[GetLoginTokenPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandSubmitVerifyCodeEx];
		[packet setPuzzleToken:token];
		[packet setVerifyCode:code];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)login {
	UInt16 seq = 0;
	if(m_bNetworkStarted) {
		LoginPacket* packet = [[LoginPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)logout {
	// pre logout
	[self internalChangeStatus:kQQStatusPreLogout];
	
	UInt16 seq = 0;
	if([m_user logged]) {
		LogoutPacket* packet = [[LogoutPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[self sendPacket:packet];
		[packet release];
		
		[m_user setLogged:NO];
		[m_user setStatus:kQQStatusOffline];
	}
	
	// change status
	[self internalChangeStatus:kQQStatusLoggedOut];
	
	return seq;
}

- (UInt16)changeStatus:(char)status {
	return [self changeStatus:status message:@""];
}

- (UInt16)changeStatus:(char)status message:(NSString*)statusMessage {
	UInt16 seq = 0;
	if([m_user logged]) {
		ChangeStatusPacket* packet = [[ChangeStatusPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setStatus:status];
		[packet setStatusMessage:statusMessage];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)changeStatusMessage:(NSString*)statusMessage {
	UInt16 seq = 0;
	if([m_user logged]) {
		ChangeStatusPacket* packet = [[ChangeStatusPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setStatus:[m_user status]];
		[packet setStatusMessage:statusMessage];
		[packet setStatusVersion:m_statusVersion++];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

#pragma mark -
#pragma mark user related methods

- (UInt16)getUserInfo:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {
		GetUserInfoPacket* packet = [[GetUserInfoPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setQQ:QQ];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getOnlineFriend {
	return [self getOnlineFriend:0];
}

- (UInt16)getOnlineFriend:(UInt32)startPosition {
	UInt16 seq = 0;
	if([m_user logged]) {
		GetOnlineOpPacket* packet = [[GetOnlineOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setStartPosition:startPosition];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getFriendList {
	return [self getFriendList:0];
}

- (UInt16)getFriendList:(UInt16)startPosition {
	UInt16 seq = 0;
	if([m_user logged]) {
		GetFriendListPacket* packet = [[GetFriendListPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setStartPosition:startPosition];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)downloadGroupNames {
	UInt16 seq = 0;
	if([m_user logged]) {
		GroupDataOpPacket* packet = [[GroupDataOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandDownloadGroupName];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)uploadGroupNames:(NSArray*)groupNames {
	UInt16 seq = 0;
	if([m_user logged]) {
		GroupDataOpPacket* packet = [[GroupDataOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandUploadGroupName];
		[packet setGroupNames:groupNames];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getFriendGroup {
	return [self getFriendGroup:0];
}

- (UInt16)getFriendGroup:(UInt32)startPosition {
	UInt16 seq = 0;
	if([m_user logged]) {
		GetFriendGroupPacket* packet = [[GetFriendGroupPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setStartPosition:startPosition];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getFriendLevel:(NSArray*)friends {
	UInt16 seq = 0;
	if([m_user logged]) {
		LevelOpPacket* packet = [[LevelOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet addFriends:friends];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getFriendLevelByQQ:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {
		LevelOpPacket* packet = [[LevelOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet addFriend:QQ];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getUesrProperty {
	return [self getUserProperty:0];
}

- (UInt16)getUserProperty:(UInt16)startPosition {
	UInt16 seq = 0;
	if([m_user logged]) {
		PropertyOpPacket* packet = [[PropertyOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setStartPosition:startPosition];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)modifySignature:(NSString*)signature authInfo:(NSData*)authInfo {
	UInt16 seq = 0;
	if([m_user logged]) {
		SignatureOpPacket* packet = [[SignatureOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandModifySignature];
		[packet setSignature:signature];
		[packet setAuthInfo:authInfo];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)deleteSignature:(NSData*)authInfo {
	UInt16 seq = 0;
	if([m_user logged]) {
		SignatureOpPacket* packet = [[SignatureOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandDeleteSignature];
		[packet setAuthInfo:authInfo];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getSignature:(NSArray*)friends {
	UInt16 seq = 0;
	if([m_user logged]) {
		SignatureOpPacket* packet = [[SignatureOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandGetSignature];
		[packet addFriends:friends];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getSignatureByQQ:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {
		SignatureOpPacket* packet = [[SignatureOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandGetSignature];
		[packet addFriend:QQ];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getRemark:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {
		FriendDataOpPacket* packet = [[FriendDataOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandGetFriendRemark];
		[packet setQQ:QQ];
		[self sendPacket:packet];
		[packet release];
	}	
	return seq;
}

- (UInt16)batchGetRemark:(char)page {
	UInt16 seq = 0;
	if([m_user logged]) {
		FriendDataOpPacket* packet = [[FriendDataOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandBatchGetFriendRemark];
		[packet setPage:page];
		[self sendPacket:packet];
		[packet release];
	}	
	return seq;
}

- (UInt16)uploadRemark:(FriendRemark*)remark {
	UInt16 seq = 0;
	if([m_user logged]) {
		FriendDataOpPacket* packet = [[FriendDataOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandUploadFriendRemark];
		[packet setRemark:remark];
		[self sendPacket:packet];
		[packet release];
	}	
	return seq;
}

- (UInt16)removeFriendFromServerList:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {
		FriendDataOpPacket* packet = [[FriendDataOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandRemoveFriendFromList];
		[packet setQQ:QQ];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)modifyRemarkName:(UInt32)QQ name:(NSString*)name {
	UInt16 seq = 0;
	if([m_user logged]) {
		FriendDataOpPacket* packet = [[FriendDataOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandModifyRemarkName];
		[packet setQQ:QQ];
		[packet setName:name];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)modifyInfo:(ContactInfo*)info authInfo:(NSData*)authInfo {
	UInt16 seq = 0;
	if([m_user logged]) {
		ModifyInfoPacket* packet = [[ModifyInfoPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setContact:info];
		[packet setAuthInfo:authInfo];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getMyQuestion {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthQuestionOpPacket* packet = [[AuthQuestionOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandGetMyQuestion];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getUserQuestion:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthQuestionOpPacket* packet = [[AuthQuestionOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandGetUserQuestion];
		[packet setFriendQQ:QQ];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)modifyQuestion:(NSString*)question answer:(NSString*)answer {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthQuestionOpPacket* packet = [[AuthQuestionOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandModifyQuestion];
		[packet setQuestion:question];
		[packet setAnswer:answer];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)answerQuestion:(UInt32)QQ answer:(NSString*)answer {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthQuestionOpPacket* packet = [[AuthQuestionOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandAnswerQuestion];
		[packet setFriendQQ:QQ];
		[packet setAnswer:answer];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)setSearchMeByQQOnly:(BOOL)selected {
	UInt16 seq = 0;
	if([m_user logged]) {
		PrivacyOpPacket* packet = [[PrivacyOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandSearchMeByQQOnly];
		[packet setSelected:selected];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)setShareGeography:(BOOL)selected {
	UInt16 seq = 0;
	if([m_user logged]) {
		PrivacyOpPacket* packet = [[PrivacyOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandShareGeography];
		[packet setSelected:selected];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)searchOnlineUsers:(UInt32)page {
	UInt16 seq = 0;
	if([m_user logged]) {
		SearchUserPacket* packet = [[SearchUserPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setPage:page];
		[packet setSubCommand:kQQSubCommandSearchAll];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)searchUserByQQ:(UInt32)QQ page:(UInt32)page {
	UInt16 seq = 0;
	if([m_user logged]) {
		SearchUserPacket* packet = [[SearchUserPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setPage:page];
		[packet setQQ:QQ];
		[packet setSubCommand:kQQSubCommandSearchByQQ];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)searchUserByNick:(NSString*)nick page:(UInt32)page {
	UInt16 seq = 0;
	if([m_user logged]) {
		SearchUserPacket* packet = [[SearchUserPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setPage:page];
		[packet setNick:nick];
		[packet setSubCommand:kQQSubCommandSearchByNick];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)advancedSearchUser:(BOOL)online hasCam:(BOOL)hasCam ageIndex:(UInt8)ageIndex genderIndex:(UInt8)genderIndex provinceIndex:(UInt16)provinceIndex cityIndex:(UInt16)cityIndex page:(int)page {
	UInt16 seq = 0;
	if([m_user logged]) {
		AdvancedSearchUserPacket* packet = [[AdvancedSearchUserPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setOnline:online];
		[packet setHasCam:hasCam];
		[packet setAgeIndex:ageIndex];
		[packet setGenderIndex:genderIndex];
		[packet setProvinceIndex:provinceIndex];
		[packet setCityIndex:cityIndex];
		[packet setPage:page];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)addFriend:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {
		AddFriendPacket* packet = [[AddFriendPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setQQ:QQ];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getModifyInfoAuthInfo:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthInfoOpPacket* packet = [[AuthInfoOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandGetAuthInfo];
		[packet setSubSubCommand:kQQSubSubCommandGetModifyUserInfoAuthInfo];
		[packet setQQ:QQ];
		[self sendPacket:packet];
		[packet release];
	}
	
	return seq;
}

- (UInt16)getDeleteUserAuthInfo:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthInfoOpPacket* packet = [[AuthInfoOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandGetAuthInfo];
		[packet setSubSubCommand:kQQSubSubCommandGetDeleteUserAuthInfo];
		[packet setQQ:QQ];
		[self sendPacket:packet];
		[packet release];
	}
	
	return seq;
}

- (UInt16)getUserAuthInfo:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthInfoOpPacket* packet = [[AuthInfoOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandGetAuthInfo];
		[packet setSubSubCommand:kQQSubSubCommandGetUserAuthInfo];
		[packet setQQ:QQ];
		[self sendPacket:packet];
		[packet release];
	}
	
	return seq;
}

- (UInt16)getUserAuthInfo:(UInt32)QQ verifyCode:(NSString*)verifyCode cookie:(NSString*)cookie {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthInfoOpPacket* packet = [[AuthInfoOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandGetAuthInfoByVerifyCode];
		[packet setSubSubCommand:kQQSubSubCommandGetUserAuthInfo];
		[packet setQQ:QQ];
		[packet setVerifyCode:verifyCode];
		[packet setCookie:cookie];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getUserTempSessionIMAuthInfo:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthInfoOpPacket* packet = [[AuthInfoOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandGetAuthInfo];
		[packet setSubSubCommand:kQQSubSubCommandGetUserTempSessionAuthInfo];
		[packet setQQ:QQ];
		[self sendPacket:packet];
		[packet release];
	}
	
	return seq;
}

- (UInt16)getUserTempSessionIMAuthInfo:(UInt32)QQ verifyCode:(NSString*)verifyCode cookie:(NSString*)cookie {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthInfoOpPacket* packet = [[AuthInfoOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandGetAuthInfoByVerifyCode];
		[packet setSubSubCommand:kQQSubSubCommandGetUserTempSessionAuthInfo];
		[packet setQQ:QQ];
		[packet setVerifyCode:verifyCode];
		[packet setCookie:cookie];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)authorize:(UInt32)QQ authInfo:(NSData*)authInfo message:(NSString*)message allowAddMe:(BOOL)allowAddMe group:(int)destGroup {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthorizePacket* packet = [[AuthorizePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandNormalAuthorize];
		[packet setQQ:QQ];
		[packet setAuthInfo:authInfo];
		[packet setMessage:message];
		[packet setAllowAddMe:allowAddMe];
		[packet setDestGroup:destGroup];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)authorize:(UInt32)QQ authInfo:(NSData*)authInfo questionAuthInfo:(NSData*)questionAuthInfo allowAddMe:(BOOL)allowAddMe group:(int)destGroup {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthorizePacket* packet = [[AuthorizePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandDoubleAuthorize];
		[packet setQQ:QQ];
		[packet setAuthInfo:authInfo];
		[packet setQuestionAuthInfo:questionAuthInfo];
		[packet setAllowAddMe:allowAddMe];
		[packet setDestGroup:destGroup];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)approveAuthorization:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthorizePacket* packet = [[AuthorizePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandApproveAuthorization];
		[packet setQQ:QQ];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)approveAuthorizationAndAddHim:(UInt32)QQ message:(NSString*)message {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthorizePacket* packet = [[AuthorizePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandApproveAuthorizationAndAddHim];
		[packet setMessage:message];
		[packet setQQ:QQ];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)rejectAuthorization:(UInt32)QQ message:(NSString*)message {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthorizePacket* packet = [[AuthorizePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandRejectAuthorization];
		[packet setQQ:QQ];
		[packet setMessage:message];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)deleteFriend:(UInt32)QQ authInfo:(NSData*)authInfo {
	UInt16 seq = 0;
	if([m_user logged]) {
		DeleteFriendPacket* packet = [[DeleteFriendPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setAuthInfo:authInfo];
		[packet setQQ:QQ];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)sendTempSessionIM:(UInt32)receiver messageData:(NSData*)messageData senderName:(NSString*)name senderSite:(NSString*)site style:(FontStyle*)style authInfo:(NSData*)authInfo {
	UInt16 seq = 0;
	if([m_user logged]) {		
		TempSessionOpPacket* packet = [[TempSessionOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandSendTempSessionIM];
		[packet setReceiver:receiver];
		[packet setMessageData:messageData];
		[packet setFontStyle:style];
		[packet setSenderName:name];
		[packet setSenderSite:site];
		[packet setAuthInfo:authInfo];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)sendIM:(UInt32)receiver messageData:(NSData*)messageData style:(FontStyle*)style {
	return [self sendIM:receiver
			messageData:messageData
				  style:style
		  fragmentCount:1
		  fragmentIndex:0];
}

- (UInt16)sendIM:(UInt32)receiver messageData:(NSData*)messageData style:(FontStyle*)style fragmentCount:(int)fragmentCount fragmentIndex:(int)fragmentIndex {
	UInt16 seq = 0;
	if([m_user logged]) {		
		SendIMPacket* packet = [[SendIMPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setReceiver:receiver];
		[packet setMessageData:messageData];
		[packet setFontStyle:style];
		[packet setFragmentCount:fragmentCount];
		[packet setFragmentIndex:fragmentIndex];
		[self sendPacket:packet];
		[packet release];
		if(fragmentIndex == fragmentCount - 1)
			[SendIMPacket increaseMessageId];
		[SendIMPacket increaseSessionId];
	}
	return seq;
}

- (UInt16)removeSelfFrom:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {		
		RemoveSelfPacket* packet = [[RemoveSelfPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setQQ:QQ];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)uploadFriendGroup:(NSDictionary*)groupMapping {
	UInt16 seq = 0;
	if([m_user logged]) {		
		UploadFriendGroupPacket* packet = [[UploadFriendGroupPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setGroupMapping:groupMapping];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)sendSMSToQQ:(UInt32)QQ senderName:(NSString*)senderName message:(NSData*)message sequence:(int)sequence {
	UInt16 seq = 0;
	if([m_user logged]) {		
		SendSMSPacket* packet = [[SendSMSPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet addQQ:QQ];
		[packet setName:senderName];
		[packet setMessageData:message];
		[packet setMessageSequence:sequence];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)sendSMSToMobile:(NSString*)mobile senderName:(NSString*)senderName message:(NSData*)message sequence:(int)sequence {
	UInt16 seq = 0;
	if([m_user logged]) {		
		SendSMSPacket* packet = [[SendSMSPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet addMobile:mobile];
		[packet setName:senderName];
		[packet setMessageData:message];
		[packet setMessageSequence:sequence];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

#pragma mark -
#pragma mark cluter methods

- (UInt16)getClusterInfo:(UInt32)internalId {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterGetInfoPacket* packet = [[ClusterGetInfoPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)modifyClusterInfo:(UInt32)internalId authType:(char)authType category:(UInt32)category name:(NSString*)name notice:(NSString*)notice description:(NSString*)description {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterModifyInfoPacket* packet = [[ClusterModifyInfoPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setAuthType:authType];
		[packet setCategory:category];
		[packet setName:name];
		[packet setNotice:notice];
		[packet setDescription:description];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)updateOrganization:(UInt32)internalId {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterUpdateOrganizationPacket* packet = [[ClusterUpdateOrganizationPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getMemberInfo:(UInt32)internalId members:(NSArray*)members {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterGetMemberInfoPacket* packet = [[ClusterGetMemberInfoPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setMembers:members];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getOnlineMember:(UInt32)internalId {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterGetOnlineMemberPacket* packet = [[ClusterGetOnlineMemberPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)searchCluster:(UInt32)internalId {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterSearchPacket* packet = [[ClusterSearchPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getClusterNameCard:(UInt32)internalId QQ:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterGetCardPacket* packet = [[ClusterGetCardPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setQQ:QQ];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)batchGetClusterNameCard:(UInt32)internalId versionId:(UInt32)versionId {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterBatchGetCardPacket* packet = [[ClusterBatchGetCardPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setClusterNameCardVersionId:versionId];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)batchGetClusterNameCard:(UInt32)internalId versionId:(UInt32)versionId startPosition:(UInt32)pos {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterBatchGetCardPacket* packet = [[ClusterBatchGetCardPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setStartPosition:pos];
		[packet setClusterNameCardVersionId:versionId];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getMessageSetting:(NSArray*)clusters {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterGetMessageSettingPacket* packet = [[ClusterGetMessageSettingPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setClusters:clusters];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)modifyMessageSetting:(UInt32)internalId externalId:(UInt32)externalId messageSetting:(char)messagetSetting {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterModifyMessageSettingPacket* packet = [[ClusterModifyMessageSettingPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setExternalId:externalId];
		[packet setMessageSetting:messagetSetting];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)modifyChannelSetting:(UInt32)internalId notificationRight:(char)right {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterModifyChannelSettingPacket* packet = [[ClusterModifyChannelSettingPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setMask:kQQClusterOperationMaskNotificationRight];
		[packet setNotificationRight:right];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)modifyChannelSetting:(UInt32)internalId channelId:(UInt32)channelId {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterModifyChannelSettingPacket* packet = [[ClusterModifyChannelSettingPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setMask:kQQClusterOperationMaskChannel];
		[packet setDefaultChannelId:channelId];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)modifyChannelSetting:(UInt32)internalId notificationRight:(char)right channelId:(UInt32)channelId {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterModifyChannelSettingPacket* packet = [[ClusterModifyChannelSettingPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setMask:(kQQClusterOperationMaskChannel | kQQClusterOperationMaskNotificationRight)];
		[packet setNotificationRight:right];
		[packet setDefaultChannelId:channelId];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getChannelSetting:(UInt32)internalId externalId:(UInt32)externalId {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterGetChannelSettingPacket* packet = [[ClusterGetChannelSettingPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setExternalId:externalId];
		[packet setMask:(kQQClusterOperationMaskChannel | kQQClusterOperationMaskNotificationRight)];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getLastTalkTime:(UInt32)internalId externalId:(UInt32)externalId {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterGetLastTalkTimePacket* packet = [[ClusterGetLastTalkTimePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setExternalId:externalId];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)modifyCard:(UInt32)internalId name:(NSString*)name genderIndex:(int)genderIndex phone:(NSString*)phone email:(NSString*)email remark:(NSString*)remark allowAdminModify:(BOOL)flag {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterModifyCardPacket* packet = [[ClusterModifyCardPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setName:name];
		[packet setGenderIndex:genderIndex];
		[packet setPhone:phone];
		[packet setEmail:email];
		[packet setRemark:remark];
		[packet setAllowAdminModify:flag];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)addMember:(UInt32)internalId members:(NSArray*)members {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterModifyMemberPacket* packet = [[ClusterModifyMemberPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setMembers:members];
		[packet setSubSubCommand:kQQSubSubCommandAddMember];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)removeMember:(UInt32)internalId members:(NSArray*)members {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterModifyMemberPacket* packet = [[ClusterModifyMemberPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setMembers:members];
		[packet setSubSubCommand:kQQSubSubCommandRemoveMember];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)sendClusterIM:(UInt32)internalId messageData:(NSData*)messageData style:(FontStyle*)style {
	return [self sendClusterIM:internalId 
				   messageData:messageData
						 style:style
				 fragmentCount:1
				 fragmentIndex:0];
}

- (UInt16)sendClusterIM:(UInt32)internalId messageData:(NSData*)messageData style:(FontStyle*)style fragmentCount:(int)fragmentCount fragmentIndex:(int)fragmentIndex {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterSendIMExPacket* packet = [[ClusterSendIMExPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setMessageData:messageData];
		[packet setFontStyle:style];
		[packet setFragmentCount:fragmentCount];
		[packet setFragmentIndex:fragmentIndex];
		[self sendPacket:packet];
		[packet release];
		if(fragmentIndex == fragmentCount - 1)
			[ClusterSendIMExPacket increaseMessageId];
	}
	return seq;
}

- (UInt16)exitCluster:(UInt32)internalId {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterExitPacket* packet = [[ClusterExitPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)activateCluster:(UInt32)internalId {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterActivatePacket* packet = [[ClusterActivatePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)setAdminRole:(UInt32)internalId user:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterSetRolePacket* packet = [[ClusterSetRolePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setQQ:QQ];
		[packet setSubSubCommand:kQQSubSubCommandSetAdminRole];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)unsetAdminRole:(UInt32)internalId user:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterSetRolePacket* packet = [[ClusterSetRolePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setQQ:QQ];
		[packet setSubSubCommand:kQQSubSubCommandUnsetAdminRole];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)transferRole:(UInt32)internalId user:(UInt32)QQ {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterTransferRolePacket* packet = [[ClusterTransferRolePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setQQ:QQ];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)dismissCluster:(UInt32)internalId {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterDismissPacket* packet = [[ClusterDismissPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getClusterAuthInfo:(UInt32)externalId {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthInfoOpPacket* packet = [[AuthInfoOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandGetAuthInfo];
		[packet setSubSubCommand:kQQSubSubCommandGetClusterAuthInfo];
		[packet setExternalId:externalId];
		[self sendPacket:packet];
		[packet release];
	}
	
	return seq;
}

- (UInt16)getClusterAuthInfo:(UInt32)externalId verifyCode:(NSString*)verifyCode cookie:(NSString*)cookie {
	UInt16 seq = 0;
	if([m_user logged]) {
		AuthInfoOpPacket* packet = [[AuthInfoOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandGetAuthInfoByVerifyCode];
		[packet setSubSubCommand:kQQSubSubCommandGetClusterAuthInfo];
		[packet setExternalId:externalId];
		[packet setVerifyCode:verifyCode];
		[packet setCookie:cookie];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)joinCluster:(UInt32)internalId {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterJoinPacket* packet = [[ClusterJoinPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)requestJoinCluster:(UInt32)internalId authInfo:(NSData*)authInfo message:(NSString*)message {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterAuthorizePacket* packet = [[ClusterAuthorizePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setSubSubCommand:kQQSubSubCommandRequestJoinCluster];
		[packet setAuthInfo:authInfo];
		[packet setMessage:message];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)approveJoinCluster:(UInt32)internalId receiver:(UInt32)QQ authInfo:(NSData*)authInfo {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterAuthorizePacket* packet = [[ClusterAuthorizePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setReceiver:QQ];
		[packet setSubSubCommand:kQQSubSubCommandApproveJoinCluster];
		[packet setAuthInfo:authInfo];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)rejectJoinCluster:(UInt32)internalId receiver:(UInt32)QQ authInfo:(NSData*)authInfo message:(NSString*)message {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterAuthorizePacket* packet = [[ClusterAuthorizePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setReceiver:QQ];
		[packet setSubSubCommand:kQQSubSubCommandRejectJoinCluster];
		[packet setAuthInfo:authInfo];
		[packet setMessage:message];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getVersionId:(UInt32)internalId {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterGetVersionIdPacket* packet = [[ClusterGetVersionIdPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

#pragma mark -
#pragma mark temp cluster methods

- (UInt16)getSubjectInfo:(UInt32)internalId parent:(UInt32)parentId {
	UInt16 seq = 0;
	if([m_user logged]) {
		TempClusterGetInfoPacket* packet = [[TempClusterGetInfoPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setTempType:kQQTempClusterTypeSubject];
		[packet setInternalId:internalId];
		[packet setParentId:parentId];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getDialogInfo:(UInt32)internalId {
	UInt16 seq = 0;
	if([m_user logged]) {
		TempClusterGetInfoPacket* packet = [[TempClusterGetInfoPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setTempType:kQQTempClusterTypeDialog];
		[packet setInternalId:internalId];
		[packet setParentId:0];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getSubjects:(UInt32)parentId {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterSubOpPacket* packet = [[ClusterSubOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubSubCommand:kQQSubSubCommandGetSubjects];
		[packet setParentId:parentId];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getDialogs {
	UInt16 seq = 0;
	if([m_user logged]) {
		ClusterSubOpPacket* packet = [[ClusterSubOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubSubCommand:kQQSubSubCommandGetDialogs];
		[packet setParentId:0];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)sendTempClusterIM:(UInt32)internalId parent:(UInt32)parentInternalId clusterType:(char)clusterType messageData:(NSData*)messageData style:(FontStyle*)style {
	return [self sendTempClusterIM:internalId
							parent:parentInternalId
					   clusterType:clusterType
					   messageData:messageData
							 style:style
					 fragmentCount:1
					 fragmentIndex:0];
}

- (UInt16)sendTempClusterIM:(UInt32)internalId parent:(UInt32)parentInternalId clusterType:(char)clusterType messageData:(NSData*)messageData style:(FontStyle*)style fragmentCount:(int)fragmentCount fragmentIndex:(int)fragmentIndex {
	UInt16 seq = 0;
	if([m_user logged]) {
		TempClusterSendIMPacket* packet = [[TempClusterSendIMPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setParentId:parentInternalId];
		[packet setType:clusterType];
		[packet setMessageData:messageData];
		[packet setFontStyle:style];
		[packet setFragmentCount:fragmentCount];
		[packet setFragmentIndex:fragmentIndex];
		[self sendPacket:packet];
		[packet release];
		if(fragmentIndex == fragmentCount - 1)
			[ClusterSendIMExPacket increaseMessageId];
	}
	return seq;
}

- (UInt16)createSubject:(NSString*)name parent:(UInt32)parentInternalId members:(NSArray*)members {
	UInt16 seq = 0;
	if([m_user logged]) {
		TempClusterCreatePacket* packet = [[TempClusterCreatePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setParentId:parentInternalId];
		[packet setTempType:kQQTempClusterTypeSubject];
		[packet setName:name];
		[packet setMembers:members];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)createDialog:(NSString*)name members:(NSArray*)members {
	UInt16 seq = 0;
	if([m_user logged]) {
		TempClusterCreatePacket* packet = [[TempClusterCreatePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setParentId:0];
		[packet setTempType:kQQTempClusterTypeDialog];
		[packet setName:name];
		[packet setMembers:members];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)activateSubject:(UInt32)internalId parent:(UInt32)parentId {
	UInt16 seq = 0;
	if([m_user logged]) {
		TempClusterActivatePacket* packet = [[TempClusterActivatePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setParentId:parentId];
		[packet setTempType:kQQTempClusterTypeSubject];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)activateDialog:(UInt32)internalId {
	UInt16 seq = 0;
	if([m_user logged]) {
		TempClusterActivatePacket* packet = [[TempClusterActivatePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setParentId:0];
		[packet setTempType:kQQTempClusterTypeDialog];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)exitSubject:(UInt32)internalId parent:(UInt32)parentId {
	UInt16 seq = 0;
	if([m_user logged]) {
		TempClusterExitPacket* packet = [[TempClusterExitPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setParentId:parentId];
		[packet setTempClsuterType:kQQTempClusterTypeSubject];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)exitDialog:(UInt32)internalId {
	UInt16 seq = 0;
	if([m_user logged]) {
		TempClusterExitPacket* packet = [[TempClusterExitPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setInternalId:internalId];
		[packet setParentId:0];
		[packet setTempClsuterType:kQQTempClusterTypeDialog];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)modifySubjectInfo:(UInt32)internalId parent:(UInt32)parentInternalId name:(NSString*)name {
	UInt16 seq = 0;
	if([m_user logged]) {
		TempClusterModifyInfoPacket* packet = [[TempClusterModifyInfoPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setTempType:kQQTempClusterTypeSubject];
		[packet setInternalId:internalId];
		[packet setParentId:parentInternalId];
		[packet setName:name];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)modifyDialogInfo:(UInt32)internalId name:(NSString*)name {
	UInt16 seq = 0;
	if([m_user logged]) {
		TempClusterModifyInfoPacket* packet = [[TempClusterModifyInfoPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setTempType:kQQTempClusterTypeDialog];
		[packet setInternalId:internalId];
		[packet setParentId:0];
		[packet setName:name];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)addSubjectMember:(UInt32)internalId parent:(UInt32)parentInternalId members:(NSArray*)members {
	UInt16 seq = 0;
	if([m_user logged]) {
		TempClusterModifyMemberPacket* packet = [[TempClusterModifyMemberPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setTempType:kQQTempClusterTypeSubject];
		[packet setInternalId:internalId];
		[packet setParentId:parentInternalId];
		[packet setSubSubCommand:kQQSubSubCommandAddMember];
		[packet setMembers:members];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)removeSubjectMember:(UInt32)internalId parent:(UInt32)parentInternalId members:(NSArray*)members {
	UInt16 seq = 0;
	if([m_user logged]) {
		TempClusterModifyMemberPacket* packet = [[TempClusterModifyMemberPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setTempType:kQQTempClusterTypeSubject];
		[packet setInternalId:internalId];
		[packet setParentId:parentInternalId];
		[packet setSubSubCommand:kQQSubSubCommandRemoveMember];
		[packet setMembers:members];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)addDialogMember:(UInt32)internalId members:(NSArray*)members {
	UInt16 seq = 0;
	if([m_user logged]) {
		TempClusterModifyMemberPacket* packet = [[TempClusterModifyMemberPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setTempType:kQQTempClusterTypeDialog];
		[packet setInternalId:internalId];
		[packet setParentId:0];
		[packet setSubSubCommand:kQQSubSubCommandAddMember];
		[packet setMembers:members];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)removeDialogMember:(UInt32)internalId members:(NSArray*)members {
	UInt16 seq = 0;
	if([m_user logged]) {
		TempClusterModifyMemberPacket* packet = [[TempClusterModifyMemberPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setTempType:kQQTempClusterTypeDialog];
		[packet setInternalId:internalId];
		[packet setParentId:0];
		[packet setSubSubCommand:kQQSubSubCommandRemoveMember];
		[packet setMembers:members];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

#pragma mark -
#pragma mark other methods

- (UInt16)getKey:(char)subCommand {
	UInt16 seq = 0;
	if([m_user logged]) {
		GetKeyPacket* packet = [[GetKeyPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:subCommand];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)getWeather {
	UInt16 seq = 0;
	if([m_user logged]) {
		WeatherOpPacket* packet = [[WeatherOpPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSubCommand:kQQSubCommandGetWeather];
		[packet setIp:[m_user ip]];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

#pragma mark -
#pragma mark connection maintainance

- (UInt16)keepAlive {
	UInt16 seq = 0;
	if([m_user logged]) {
		KeepAlivePacket* packet = [[KeepAlivePacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

#pragma mark -
#pragma mark timer handler

- (void)handleResendTimer:(NSTimer*)theTimer {
	while([m_resendQueue count] > 0) {
		OutPacket* packet = [[m_resendQueue objectAtIndex:0] retain];
		
		if([[NSDate date] timeIntervalSinceDate:[packet sentDate]] >= 5) {	
			// remove from resend queue
			[m_resendQueue removeObjectAtIndex:0];
			
			if([packet sendCount] >= 5) {
				// init timeout event
				NSLog(@"Timeout, family: %d, command: %d, sequence: %d", [packet family], [packet command], [packet sequence]);
				QQNotification* event = [[QQNotification alloc] initWithId:(kQQEventTimeout + [packet family]) packet:nil outPacket:packet];
				[event setConnectionId:[[packet connectionId] intValue]];
				
				// trigger timeout event
				if(event) {
					[self trigger:event];
					[event release];
				}
			} else {				
				// resend
				[self sendPacket:packet];
			}			
			
			[packet release];
		} else {
			[packet release];
			break;
		}
	}
}

- (void)handleKeepAliveTimer:(NSTimer*)theTimer {
	if([m_user logged])
		[self keepAlive];
}

#pragma mark -
#pragma mark custom face method

- (void)sendClusterCustomFaces:(CustomFaceList*)faceList {
	[m_clusterFaceSender addCustomFaceList:faceList];
}

- (void)getClusterCustomFaces:(CustomFaceList*)faceList {
	[m_clusterFaceReceiver addCustomFaceList:faceList];
}

- (UInt16)requestFace:(int)connId sessionId:(UInt32)sessionId owner:(UInt32)owner encryptKey:(NSData*)key {
	UInt16 seq;
	if([m_user logged]) {
		RequestFacePacket* packet = [[RequestFacePacket alloc] initWithQQUser:m_user encryptKey:key];
		seq = [packet sequence];
		[packet setSessionId:sessionId];
		[packet setOwner:owner];
		[packet setConnectionId:[NSNumber numberWithInt:connId]];
		[self sendPacket:packet];
		NSLog(@"request face hash: %d", [packet hash]);
		[packet release];
	}
	return seq;
}

- (UInt16)requestReceiveBegin:(int)connId sessionId:(UInt32)sessionId transferType:(UInt16)transferType encryptKey:(NSData*)key {
	UInt16 seq;
	if([m_user logged]) {
		RequestBeginPacket* packet = [[RequestBeginPacket alloc] initWithQQUser:m_user encryptKey:key];
		seq = [packet sequence];
		[packet setSessionId:sessionId];
		[packet setAgentTransferType:transferType];
		[packet setConnectionId:[NSNumber numberWithInt:connId]];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)requestSendBegin:(int)connId sessionId:(UInt32)sessionId transferType:(UInt16)transferType {
	UInt16 seq;
	if([m_user logged]) {
		RequestBeginPacket* packet = [[RequestBeginPacket alloc] initWithQQUser:m_user encryptKey:[m_user fileAgentKey]];
		seq = [packet sequence];
		[packet setSessionId:sessionId];
		[packet setAgentTransferType:transferType];
		[packet setConnectionId:[NSNumber numberWithInt:connId]];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)replyTransferData:(int)connId sessionId:(UInt32)sessionId {
	UInt16 seq;
	if([m_user logged]) {
		ClientTransferPacket* packet = [[ClientTransferPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setMode:kTransferModeReplyData];
		[packet setSessionId:sessionId];
		[packet setConnectionId:[NSNumber numberWithInt:connId]];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)requestData:(int)connId sessionId:(UInt32)sessionId {
	UInt16 seq;
	if([m_user logged]) {
		ClientTransferPacket* packet = [[ClientTransferPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setMode:kTransferModeRequestData];
		[packet setSessionId:sessionId];
		[packet setConnectionId:[NSNumber numberWithInt:connId]];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)requestAgent:(int)connId owner:(UInt32)owner transferType:(UInt16)type imageSize:(UInt32)imageSize imageMd5:(NSData*)imageMd5 imageFileNameMd5:(NSData*)filenameMd5 {
	UInt16 seq;
	if([m_user logged]) {
		RequestAgentPacket* packet = [[RequestAgentPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setAgentTransferType:type];
		[packet setOwner:owner];
		[packet setImageSize:imageSize];
		[packet setImageMd5:imageMd5];
		[packet setImageFileNameMd5:filenameMd5];
		[packet setConnectionId:[NSNumber numberWithInt:connId]];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)transferImageInfo:(int)connId sessionId:(UInt32)sessionId fileMd5:(NSData*)fileMd5 filenameMd5:(NSData*)filenameMd5 imageSize:(UInt32)imageSize filename:(NSString*)filename {
	UInt16 seq;
	if([m_user logged]) {
		ClientTransferPacket* packet = [[ClientTransferPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSessionId:sessionId];
		[packet setFileMd5:fileMd5];
		[packet setFilenameMd5:filenameMd5];
		[packet setFilename:filename];
		[packet setImageSize:imageSize];
		[packet setConnectionId:[NSNumber numberWithInt:connId]];
		[packet setMode:kTransferImageInfo];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

- (UInt16)transferImageData:(int)connId sessionId:(UInt16)sessionId data:(NSData*)data sequence:(UInt16)sequence {
	UInt16 seq;
	if([m_user logged]) {
		ClientTransferPacket* packet = [[ClientTransferPacket alloc] initWithQQUser:m_user];
		seq = [packet sequence];
		[packet setSequence:sequence];
		[packet setSessionId:sessionId];
		[packet setFileFragmentData:data];
		[packet setConnectionId:[NSNumber numberWithInt:connId]];
		[packet setMode:kTransferImageData];
		[self sendPacket:packet];
		[packet release];
	}
	return seq;
}

#pragma mark -
#pragma mark custom head methods

- (void)getCustomHeadInfo:(NSArray*)friends {
	if([m_user logged] && [[m_customHeadReceiver connectionId] intValue] != -1) {
		GetCustomHeadInfoPacket* packet = [[GetCustomHeadInfoPacket alloc] initWithQQUser:m_user];
		[packet setFriends:friends];
		[packet setConnectionId:[m_customHeadReceiver connectionId]];
		[self sendPacket:packet];
		[packet release];
	}
}

- (void)getCustomHeadData:(CustomHead*)head {
	if([m_user logged] && [[m_customHeadReceiver connectionId] intValue] != -1) {
		[m_customHeadReceiver addCustomHead:head];
	}
}

- (void)getCustomHeadData:(UInt32)QQ timestamp:(UInt32)timestamp {
	[self getCustomHeadData:QQ
				  timestamp:timestamp
					 offset:0xFFFFFFFF
					 length:0];
}

- (void)getCustomHeadData:(UInt32)QQ timestamp:(UInt32)timestamp offset:(UInt32)offset length:(UInt32)length {
	if([m_user logged] && [[m_customHeadReceiver connectionId] intValue] != -1) {
		GetCustomHeadDataPacket* packet = [[GetCustomHeadDataPacket alloc] initWithQQUser:m_user];
		[packet setQQ:QQ];
		[packet setTimestamp:timestamp];
		[packet setOffset:offset];
		[packet setLength:length];
		[packet setConnectionId:[m_customHeadReceiver connectionId]];
		[self sendPacket:packet];
		[packet release];
	}
}

#pragma mark -
#pragma mark setter and getter

- (BOOL)networkStarted {
	return m_bNetworkStarted;
}

- (QQUser*)user {
	return m_user;
}

- (void)setQQUser:(QQUser*)user {
	[user retain];
	[m_user release];
	m_user = user;
}

- (void)setDelegate:(id)delegate {
	[delegate retain];
	[m_delegate release];
	m_delegate = delegate;
}

- (id)delegate {
	return m_delegate;
}

- (Connection*)mainConnection {
	return m_mainConnection;
}

- (CustomFaceList*)getFaceList:(ReceivedIMPacket*)packet {
	return [m_customFaceListMapping objectForKey:packet];
}

- (CustomFaceList*)removeFaceList:(ReceivedIMPacket*)packet {
	CustomFaceList* list = [m_customFaceListMapping objectForKey:packet];
	if(list) {
		[[list retain] autorelease];
		[m_customFaceListMapping removeObjectForKey:packet];
	}	
	return list;
}

- (int)mainConnectionId {
	return [[m_mainConnection connectionId] intValue];
}

#pragma mark -
#pragma mark KeyProvider protocol

- (NSData*)clusterCustomFaceAgentKey {
	// check receiver
	if(m_clusterFaceReceiver == nil)
		return nil;
	
	// get custom face
	CustomFace* face = [m_clusterFaceReceiver getCurrentFace];
	if(face == nil)
		return nil;
	
	// get key
	return [face fileAgentKey];
}

@end
