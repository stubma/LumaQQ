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

#import "MessageManager.h"
#import "GroupManager.h"
#import "ReceivedIMPacket.h"
#import "PreferenceTool.h"
#import "MessageManagerDelegate.h"
#import "UIMain.h"
#import "MessageRipper.h"
#import "LocalizedStringTool.h"
#import "FileTool.h"

extern UInt32 gMyQQ;

@implementation MessageManager

- (void) dealloc {
	[_userMsgMap release];
	[_clusterMsgMap release];
	[_keyLink release];
	[_delegate release];
	[_sysMsgs release];
	[super dealloc];
}

- (id)initWithMain:(UIMain*)main {
	self = [super init];
	if (self != nil) {
		_main = main;
		_userMsgMap = [[NSMutableDictionary dictionary] retain];
		_clusterMsgMap = [[NSMutableDictionary dictionary] retain];
		_keyLink = [[NSMutableArray array] retain];
		_sysMsgs = [[NSMutableArray array] retain];
		_messageCount = 0;
	}
	return self;
}

- (void)_putIM:(NSDictionary*)dict forCluster:(Cluster*)cluster {
	// insert array
	NSMutableArray* msgArray = [_clusterMsgMap objectForKey:cluster];
	if(msgArray == nil) {
		msgArray = [NSMutableArray array];
		[_clusterMsgMap setObject:msgArray forKey:cluster];
		[_keyLink insertObject:cluster atIndex:[_keyLink count]];
	}
	
	// create dictionary for packet
	[msgArray addObject:dict];
	_messageCount++;
}

- (void)_putIM:(NSDictionary*)dict forUser:(User*)user {
	// insert array
	NSMutableArray* msgArray = [_userMsgMap objectForKey:user];
	if(msgArray == nil) {
		msgArray = [NSMutableArray array];
		[_userMsgMap setObject:msgArray forKey:user];
		[_keyLink insertObject:user atIndex:0];
	}
	
	// add dictionary
	[msgArray addObject:dict];
	_messageCount++;
}

- (void)_putSystemIM:(NSDictionary*)dict {
	[_sysMsgs addObject:dict];
	_messageCount++;
}

- (id)linearLocate:(int)index {
	if(index < 0)
		return nil;
	else if(index >= [_keyLink count]) {
		if(index >= [_keyLink count] + [_sysMsgs count])
			return nil;
		else
			return [_sysMsgs objectAtIndex:(index - [_keyLink count])];
	} else
		return [_keyLink objectAtIndex:index];
}

- (int)itemCount {
	return [_userMsgMap count] + [_clusterMsgMap count];
}

- (int)systemItemCount {
	return [_sysMsgs count];
}

- (int)messageCount {
	return _messageCount;
}

- (int)displayableMessageCount {
	int ret = _messageCount;
	int size = [_keyLink count];
	int i;
	for(i = 0; i < size; i++) {
		id obj = [_keyLink objectAtIndex:i];
		if([obj isMemberOfClass:[Cluster class]]) {
			char messageSetting = [obj messageSetting];
			if(messageSetting == kQQClusterMessageAcceptNoPrompt 
			   || messageSetting == kQQClusterMessageDisplayCount 
			   || messageSetting == kQQClusterMessageBlock) {
				ret -= [self clusterMessageCount:obj];
			}
		}
	}
	return ret;
}

- (void)reset {
	[_userMsgMap removeAllObjects];
	[_clusterMsgMap removeAllObjects];
	[_keyLink removeAllObjects];
	[_sysMsgs removeAllObjects];
	_messageCount = 0;
}

- (id)delegate {
	return _delegate;
}

- (void)setDelegate:(id)delegate {
	[delegate retain];
	[_delegate release];
	_delegate = delegate;
}

- (NSArray*)userMessages:(User*)user {
	return [_userMsgMap objectForKey:user];
}

- (NSArray*)clusterMessages:(Cluster*)cluster {
	return [_clusterMsgMap objectForKey:cluster];
}

- (int)userMessageCount:(User*)user {
	NSArray* array = [self userMessages:user];
	return array == nil ? 0 : [array count];
}

- (int)clusterMessageCount:(Cluster*)cluster {
	NSArray* array = [self clusterMessages:cluster];
	return array == nil ? 0 : [array count];
}

- (void)removeUserMessages:(User*)user {
	NSArray* array = [_userMsgMap objectForKey:user];
	_messageCount -= [array count];
	[_userMsgMap removeObjectForKey:user];
	[_keyLink removeObject:user];
	
	// notify
	[[NSNotificationCenter defaultCenter] postNotificationName:kMessageSourcePopulatedNotificationName
														object:self];
}

- (void)removeClusterMessages:(Cluster*)cluster {
	NSArray* array = [_clusterMsgMap objectForKey:cluster];
	_messageCount -= [array count];
	[_clusterMsgMap removeObjectForKey:cluster];
	[_keyLink removeObject:cluster];
	
	// notify
	[[NSNotificationCenter defaultCenter] postNotificationName:kMessageSourcePopulatedNotificationName
														object:self];
}

- (void)removeSystemMessage:(NSDictionary*)dict {
	[_sysMsgs removeObject:dict];
	_messageCount--;
	
	// notify
	[[NSNotificationCenter defaultCenter] postNotificationName:kMessageSourcePopulatedNotificationName
														object:self];
}

- (void)saveUnread {
	NSMutableArray* unread = [NSMutableArray array];
	
	// unread user
	if([_userMsgMap count] > 0) {
		NSEnumerator* e = [_userMsgMap objectEnumerator];
		NSMutableArray* msgs = nil;
		while(msgs = [e nextObject])
			[unread addObjectsFromArray:msgs];
	}
	
	// unread cluster
	if([_clusterMsgMap count] > 0) {
		NSEnumerator* e = [_clusterMsgMap objectEnumerator];
		NSMutableArray* msgs = nil;
		while(msgs = [e nextObject])
			[unread addObjectsFromArray:msgs];
	}
	
	// unread system
	if([_sysMsgs count] > 0) {
		[unread addObjectsFromArray:_sysMsgs];
	}
	
	// save
	if([unread count] > 0) {
		NSString* path = [FileTool getUnreadChatLogPath:kLQFileUnread];
		[unread writeToFile:path atomically:YES];
	}
}

- (void)loadUnread {
	// load unread
	NSMutableArray* unread = nil;
	NSString* path = [FileTool getUnreadChatLogPath:kLQFileUnread];
	if([FileTool isFileExist:path]) {
		unread = [NSMutableArray arrayWithContentsOfFile:path];
		[FileTool deleteFile:path];
	}
	if(unread == nil)
		return;
	
	// add to maps
	GroupManager* gm = [_main groupManager];
	NSEnumerator* e = [unread objectEnumerator];
	NSDictionary* dict = nil;
	while(dict = [e nextObject]) {
		NSNumber* cId = [dict objectForKey:kChatLogKeyCluster];
		NSNumber* qq = [dict objectForKey:kChatLogKeyQQ];
		if(cId == nil && qq == nil) {
			[self _putSystemIM:dict];
		} else if(cId != nil) {
			Cluster* cluster = [gm cluster:[cId unsignedIntValue]];
			if(cluster != nil) {
				[self _putIM:dict forCluster:cluster];
			}
		} else if(qq != nil) {
			User* user = [gm user:[qq unsignedIntValue]];
			if(user != nil) {
				[self _putIM:dict forUser:user];
			}
		} 
	}
	
	// set message count
	_messageCount = [unread count];
}

- (MessagePushFlag)put:(ReceivedIMPacket*)packet {
	// debug output
//	[packet debug];
	
	// get old display message count
	int oldCount = [self displayableMessageCount];
	
	ReceivedIMPacketHeader* header = [packet imHeader];
	switch([header type]) {
		case kQQIMTypeFriend:
		case kQQIMTypeFriendEx:
		case kQQIMTypeStranger:
		case kQQIMTypeStrangerEx:
		{
			// check normal im type
			if([[packet normalIMHeader] normalIMType] != kQQNormalIMTypeText)
				break;
			
			// get group manager
			GroupManager* gm = [_main groupManager];
			
			// get preference
			PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
			
			// get user relationship with me
			BOOL bBlacklist;
			BOOL bIAmHisStranger;
			BOOL bHeIsMyStranger;
			BOOL bNoUser;
			
			// get user and group
			User* user = [gm user:[header sender]];
			Group* g = (user == nil) ? nil : [gm group:[user groupIndex]];
			
			// check relationship
			bIAmHisStranger = ([header type] == kQQIMTypeStranger || [header type] == kQQIMTypeStrangerEx);
			bNoUser = user == nil || g == nil;
			bHeIsMyStranger = bNoUser || [g isStranger];
			bBlacklist = !bNoUser && [g isBlacklist];
			
			// if user is in blacklist, don't push message into queue
			// or if user is stranger and you set to reject stranger message, don't push...
			if(bBlacklist)
				break;
			if(bNoUser && bIAmHisStranger)
				break;
			if(bHeIsMyStranger && [tool booleanValue:kPreferenceKeyRejectStrangerMessage])
				break;
			
			// create user if user is nil
			if(user == nil) {
				// create user add to friend or stranger group
				user = [[[User alloc] initWithQQ:[header sender]] autorelease];
				[gm addUser:user groupIndex:[gm strangerGroupIndex]];					
				[[_main client] getUserInfo:[user QQ]];
			}
			
			// get user group, if group is nil, make group point to stranger group
			g = [gm group:[user groupIndex]];
			if(g == nil) {
				[gm addUser:user groupIndex:[gm strangerGroupIndex]];
				[_main reloadUserPanel];
				g = [gm strangerGroup];
				[user setGroupIndex:[gm strangerGroupIndex]];
			}
			
			// put 
			NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:[[packet imHeader] sender]], kChatLogKeyQQ,
				[MessageRipper rip:packet], kChatLogKeyMessage,
				[NSNumber numberWithUnsignedInt:[packet sendTime]], kChatLogKeyTime,
				nil];
			if(_delegate == nil || [_delegate shouldInsertPacket:dict forUser:user]) {				
				// put im
				[self _putIM:dict forUser:user];
				
				// notify
				if(oldCount == 0) {
					[[NSNotificationCenter defaultCenter] postNotificationName:kHasMessageUnreadNotificationName
																		object:self];
				}
				
				return kIMPushed;
			}
			
			break;
		}
		case kQQIMTypeTempCluster:
		{
			// get temp cluter
			GroupManager* gm = [_main groupManager];
			QQClient* client = [_main client];
			ClusterIM* clusterIM = [packet clusterIM];
			Cluster* parentCluster = [gm cluster:[clusterIM parentInternalId]];
			
			// get parent cluster, if nil, add it
			if(parentCluster == nil) {
				// add cluster
				if([clusterIM parentInternalId] != 0) {
					parentCluster = [[[Cluster alloc] initWithInternalId:[clusterIM parentInternalId]] autorelease];
					[gm addCluster:parentCluster];
					[_main startClusterJob:[NSArray arrayWithObject:parentCluster]];
				}
			} else if([parentCluster memberCount] == 0)
				[_main startClusterJob:[NSArray arrayWithObject:parentCluster]];
			
			// if sender is me, don't push to queue
			if([[packet clusterIM] sender] != gMyQQ) {
				NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:[[packet clusterIM] sender]], kChatLogKeyQQ,
					[MessageRipper rip:packet], kChatLogKeyMessage,
					[NSNumber numberWithUnsignedInt:[packet sendTime]], kChatLogKeyTime,
					[NSNumber numberWithUnsignedInt:[parentCluster internalId]], kChatLogKeyCluster,
					nil];
				if(_delegate == nil || [_delegate shouldInsertPacket:dict forCluster:parentCluster]) {
					char messageSetting = [parentCluster messageSetting];
					if(messageSetting != kQQClusterMessageBlock)
						[self _putIM:dict forCluster:parentCluster];
					else
						break;
					
					// only return pushed if message setting is accept or auto eject
					if(messageSetting == kQQClusterMessageAcceptNoPrompt || messageSetting == kQQClusterMessageDisplayCount)
						return kIMSilentPushed;
					else {
						// notify
						if(oldCount == 0) {
							[[NSNotificationCenter defaultCenter] postNotificationName:kHasMessageUnreadNotificationName
																				object:self];
						}
						
						return kIMPushed;
					}
				}
			}
			break;
		}
		case kQQIMTypeCluster:
		case kQQIMTypeClusterUnknown:
		{
			GroupManager* gm = [_main groupManager];
			QQClient* client = [_main client];
			Cluster* cluster = [gm cluster:[header sender]];
			if(cluster == nil) {
				// add cluster
				cluster = [[[Cluster alloc] initWithInternalId:[header sender]] autorelease];
				[gm addCluster:cluster];
				[_main startClusterJob:[NSArray arrayWithObject:cluster]];
			} else if([[cluster info] version] < [[packet clusterIM] versionId]) {
				// check version id, get info if local info is out of date
				[[cluster info] setVersion:[[packet clusterIM] versionId]];
				[_main startClusterJob:[NSArray arrayWithObject:cluster]];
			}
			
			// if sender is me, don't push to queue
			if([[packet clusterIM] sender] != gMyQQ) {
				NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:[[packet clusterIM] sender]], kChatLogKeyQQ,
					[MessageRipper rip:packet], kChatLogKeyMessage,
					[NSNumber numberWithUnsignedInt:[packet sendTime]], kChatLogKeyTime,
					[NSNumber numberWithUnsignedInt:[cluster internalId]], kChatLogKeyCluster,
					nil];
				if(_delegate == nil || [_delegate shouldInsertPacket:dict forCluster:cluster]) {
					char messageSetting = [cluster messageSetting];
					if(messageSetting != kQQClusterMessageBlock)
						[self _putIM:dict forCluster:cluster];
					else
						break;
						
					// only return pushed if message setting is accept or auto eject
					if(messageSetting == kQQClusterMessageAcceptNoPrompt || messageSetting == kQQClusterMessageDisplayCount)
						return kIMSilentPushed;
					else {
						// notify
						if(oldCount == 0) {
							[[NSNotificationCenter defaultCenter] postNotificationName:kHasMessageUnreadNotificationName
																				object:self];
						}
						
						return kIMPushed;
					}
				}
			}
			
			break;
		}
		case kQQIMTypeSystem:
		{
			SystemIM* systemIM = [packet systemIM];
			switch([systemIM type]) {
				case kQQSystemIMTypeKickOut:
					[[NSNotificationCenter defaultCenter] postNotificationName:kKickedOutBySystemNotificationName
																		object:nil];
					break;
			}
			break;
		}
		case kQQIMTypeApprovedJoinCluster:		
		case kQQIMTypeRequestJoinCluster:
		case kQQIMTypeClusterCreated:
		case kQQIMTypeJoinedCluster:
		{
			GroupManager* gm = [_main groupManager];
			
			Cluster* cluster = [gm cluster:[header sender]];
			if(cluster == nil) {
				cluster = [[[Cluster alloc] initWithInternalId:[header sender]] autorelease];
				[cluster setExternalId:[[packet clusterNotification] externalId]];
				[gm addCluster:cluster];
				[_main startClusterJob:[NSArray arrayWithObject:cluster]];
			}
			
			int smType;
			switch([header type]) {
				case kQQIMTypeApprovedJoinCluster:		
					smType = kSMTypeApproveJoinCluster;
					break;
				case kQQIMTypeRequestJoinCluster:
					smType = kSMTypeRequestJoinCluster;
					break;
				case kQQIMTypeClusterCreated:
					smType = kSMTypeCreateCluster;
					break;
				case kQQIMTypeJoinedCluster:
					smType = kSMTypeJoinCluster;
					break;
			}
			NSString* msg = SM(packet, [cluster name], gMyQQ);
			NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:msg, kChatLogKeyMessage,
				[NSNumber numberWithInt:smType], kChatLogKeySMType,
				[NSNumber numberWithUnsignedInt:[[packet clusterNotification] sourceQQ]], kChatLogKeySourceQQ,
				[NSNumber numberWithUnsignedInt:[header sender]], kChatLogKeyClusterInternalID,
				nil];
			if(smType == kSMTypeRequestJoinCluster)
				[dict setObject:[[packet clusterNotification] authInfo] forKey:kChatLogKeyAuthInfo];
			[self _putSystemIM:dict];
			
			// notify
			if(oldCount == 0) {
				[[NSNotificationCenter defaultCenter] postNotificationName:kHasMessageUnreadNotificationName
																	object:self];
			}
			
			return kSysIMPushed;
		}
		case kQQIMTypeExitedCluster:
		{
			GroupManager* gm = [_main groupManager];
			ClusterNotification* n = [packet clusterNotification];
			Cluster* cluster = [gm cluster:[header sender]];
			if([n sourceQQ] == gMyQQ) {
				if(cluster) {
					[gm removeCluster:cluster];
					[_main reloadClusterPanel];
				}
			}
			
			NSString* msg = SM(packet, cluster == nil ? nil : [cluster name], gMyQQ);
			NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:msg, kChatLogKeyMessage,
				[NSNumber numberWithInt:kSMTypeExitCluster], kChatLogKeySMType,
				[NSNumber numberWithUnsignedInt:[n sourceQQ]], kChatLogKeySourceQQ,
				[NSNumber numberWithUnsignedInt:[header sender]], kChatLogKeyClusterInternalID,
				nil];
			[self _putSystemIM:dict];
			
			// notify
			if(oldCount == 0) {
				[[NSNotificationCenter defaultCenter] postNotificationName:kHasMessageUnreadNotificationName
																	object:self];
			}
			
			return kSysIMPushed;
		}
		case kQQIMTypeRejectedJoinCluster:	
		{
			NSString* msg = SM(packet, nil, gMyQQ);
			NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:msg, kChatLogKeyMessage,
				[NSNumber numberWithInt:kSMTypeRejectJoinCluster], kChatLogKeySMType,
				[NSNumber numberWithUnsignedInt:[[packet clusterNotification] sourceQQ]], kChatLogKeySourceQQ,
				nil];
			[self _putSystemIM:dict];
			
			// notify
			if(oldCount == 0) {
				[[NSNotificationCenter defaultCenter] postNotificationName:kHasMessageUnreadNotificationName
																	object:self];
			}
			
			return kSysIMPushed;
		}
		case kQQIMTypeSignatureChangedNotification:
		{
			GroupManager* gm = [_main groupManager];
			SignatureChangedNotification* scn = [packet signatureNotification];
			User* user = [gm user:[scn QQ]];
			if(user) {
				[user copyWithSignatureChangedNotification:scn];
				[_main reloadUserPanel];
			}
			break;	
		}
	}
	
	return kIMNotPushed;
}

- (MessagePushFlag)putSystemNotification:(SystemNotificationPacket*)packet {
	// get old display message count
	int oldCount = [self displayableMessageCount];
	
	switch([packet subCommand]) {
		case kQQSubCommandOtherRequestAddMeEx:
		{
			NSString* msg = SM(packet, nil, [packet sourceQQ]);
			NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:msg, kChatLogKeyMessage,
				[NSNumber numberWithInt:([packet allowAddReverse] ? kSMTypeRequestAddMeAndAllowAddHim : kSMTypeRequestAddMe)], kChatLogKeySMType,
								  [NSNumber numberWithUnsignedInt:[packet sourceQQ]], kChatLogKeySourceQQ,
								  nil];
			[self _putSystemIM:dict];
			
			// notify
			if(oldCount == 0) {
				[[NSNotificationCenter defaultCenter] postNotificationName:kHasMessageUnreadNotificationName
																	object:self];
			}
			
			return kSysIMPushed;
		}
		case kQQSubCommandOtherApproveMyRequest:
		{
			NSString* msg = SM(packet, nil, [packet sourceQQ]);
			NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:msg, kChatLogKeyMessage,
								  [NSNumber numberWithInt:kSMTypeApproveMyRequest], kChatLogKeySMType,
								  [NSNumber numberWithUnsignedInt:[packet sourceQQ]], kChatLogKeySourceQQ,
								  nil];
			[self _putSystemIM:dict];
			
			// notify
			if(oldCount == 0) {
				[[NSNotificationCenter defaultCenter] postNotificationName:kHasMessageUnreadNotificationName
																	object:self];
			}
			
			return kSysIMPushed;
		}
		case kQQSubCommandOtherApproveMyRequestAndAddMe:
		{
			NSString* msg = SM(packet, nil, [packet sourceQQ]);
			NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:msg, kChatLogKeyMessage,
								  [NSNumber numberWithInt:kSMTypeApproveMyRequestAndAddMe], kChatLogKeySMType,
								  [NSNumber numberWithUnsignedInt:[packet sourceQQ]], kChatLogKeySourceQQ,
								  nil];
			[self _putSystemIM:dict];
			
			// notify
			if(oldCount == 0) {
				[[NSNotificationCenter defaultCenter] postNotificationName:kHasMessageUnreadNotificationName
																	object:self];
			}
			
			return kSysIMPushed;	
		}
		case kQQSubCommandOtherAddMeEx:
		{
			// add to stranger
			GroupManager* gm = [_main groupManager];
			User* user = [gm user:[packet sourceQQ]];
			if(user == nil) {
				user = [[User alloc] initWithQQ:[packet sourceQQ]];
				[gm addUser:user groupIndex:[gm strangerGroupIndex]];
				[[_main client] getUserInfo:[user QQ]];
				[user release];
			}
			
			NSString* msg = SM(packet, nil, [packet sourceQQ]);
			NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:msg, kChatLogKeyMessage,
								  [NSNumber numberWithInt:kSMTypeAddMe], kChatLogKeySMType,
								  [NSNumber numberWithUnsignedInt:[packet sourceQQ]], kChatLogKeySourceQQ,
								  nil];
			[self _putSystemIM:dict];
			
			// notify
			if(oldCount == 0) {
				[[NSNotificationCenter defaultCenter] postNotificationName:kHasMessageUnreadNotificationName
																	object:self];
			}
			
			return kSysIMPushed;
		}
		case kQQSubCommandOtherRejectMyRequest:
		{
			NSString* msg = SM(packet, nil, [packet sourceQQ]);
			NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:msg, kChatLogKeyMessage,
								  [NSNumber numberWithInt:kSMTypeRejectMyRequest], kChatLogKeySMType,
								  [NSNumber numberWithUnsignedInt:[packet sourceQQ]], kChatLogKeySourceQQ,
								  nil];
			[self _putSystemIM:dict];
			
			// notify
			if(oldCount == 0) {
				[[NSNotificationCenter defaultCenter] postNotificationName:kHasMessageUnreadNotificationName
																	object:self];
			}
			
			return kSysIMPushed;
		}
	}
	return kIMNotPushed;
}

@end
