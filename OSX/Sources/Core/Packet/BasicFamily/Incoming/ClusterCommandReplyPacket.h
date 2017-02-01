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
#import "BasicInPacket.h"
#import "ByteBuffer.h"
#import "ClusterInfo.h"
#import "Member.h"
#import "SubCluster.h"
#import "ClusterNameCard.h"
#import "ClusterMessageSetting.h"
#import "QQOrganization.h"
#import "Friend.h"
#import "LastTalkTime.h"

//////// format 0x02 /////
// header
// --- encrypt start (session key) ---
// sub command, 1 byte, 0x02
// reply code, 1 byte
// internal id, 4 bytes
// --- encrypt end ---
// tail

//////// format 0x03 /////
// header
// --- encrypt start (session key) ---
// sub command, 1 byte, 0x03
// reply code, 1 byte
// internal id, 4 bytes
// --- encrypt end ---
// tail

///////// format 0x04 /////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x04
// reply code, 1 byte
// ----- ClusterInfo start ----
// internal id, 4 bytes
// external id, 4 bytes
// cluster type, 1 byte
// cluster level flag, 4 bytes
// creator qq number, 4 bytes
// auth type, 1 byte
// QQ 2004 category id, 4 bytes, unused
// unknown 2 bytes
// QQ 2005 category id, 4 bytes, max level 3
// unknown 7 bytes
// version id, 4 bytes
// length of cluster name, 1 byte
// name
// unknown 2 bytes
// length of cluster notice, 1 byte
// notice
// length of cluster description, 1 byte
// decription
// ----- ClusterInfo end --------
// ----- Member start -------
// member qq number, 4 bytes
// member organization id, 1 byte, start from 1, 0 means no organization. organization is not sub cluster, however subject does
// member flag, 1 byte
// ----- Member end -----
// (NOTE) if more member, repeat Member
// ------ encrypt end -----
// tail

///////// format 0x05 --------
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x05
// reply code, 1 byte
// internal id, 4 bytes
// --- encrypt end ---
// tail

///////// format 0x06 --------
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x06
// reply code, 1 byte, 0x00, means ok
// sub sub command, 1 byte
// ----- ClusterInfo start ----
// internal id, 4 bytes
// external id, 4 bytes
// cluster type, 1 byte
// unknown 4 bytes
// creator qq number, 4 bytes
// QQ 2004 category id, 4 bytes, unused
// QQ 2005 category id, 4 bytes, max level 3
// unknown 2 bytes
// length of cluster name, 1 byte
// name
// unknown 2 bytes
// auth type, 1 byte
// length of cluster description, 1 byte
// decription
// unknown 1 byte
// length of unknown id, 1 byte
// unknown id, maybe it has something with cluster sharing
// ----- ClusterInfo end --------
// ---- encrypt end ----
// tail

///////// format 0x07 //////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x07
// reply code, 1 byte
// internal id, 4 bytes
// cluster auth type, 1 byte, in QQ 2006, 0x01 is deprecated, so you need input auth info even the creator set to "no auth"
// --- encrypt end ---
// tail

///////// format 0x08 //////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x08
// reply code, 1 byte
// internal id, 4 bytes
// --- encrypt end ---
// tail

///////// format 0x09 //////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x09
// reply code, 1 byte
// internal id, 4 bytes
// --- encrypt end ---
// tail

///////// format 0x0A //////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x0A
// reply code, 1 byte
// internal id, 4 bytes
// --- encrypt end ---
// tail

///////// format 0x0B //////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x0B
// reply code, 1 byte
// internal id, 4 bytes
// unknown 1 byte
// a. online member qq number, 4 bytes
// (NOTE) if more online member, repeat (a)
// ---- encrypt end -------
// tail

///////// format 0x0C //////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x0C
// reply code, 1 byte
// internal id, 4 bytes
// ---- Friend start (Cluster member version) ----
// friend qq, 4 bytes
// head, 2 bytes
// age, 1 bytes
// gender, 1 bytes
// nick length, 1 bytes
// nick
// user flag, 4 bytes
//		bit 1 => member
// 		bit 5 => mobile QQ
//		bit 6 => mobile bind
//		bit 7 => has camera
//		bit 18 => TM
// ----- Friend end ------
// (NOTE) if more, repeat Friend
// ---- encrypt end ----
// tail

///////// format 0x0E //////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x0E
// reply code, 1 byte
// internal id, 4 bytes
// my qq, 4 bytes
// --- encrypt end ---
// tail

//////// format 0x0F /////////
// header
// ---- encrypt start (session key) -----
// sub command, 1 byte, 0x0F
// reply code, 1 byte
// internal id, 4 bytes
// latest cluster name card version id, 4 bytes
// next start position, 4 bytes, if 0, means no more name card
// a. member qq number, 4 bytes
// b. length of name, 1 byte
// c. name
// (NOTE) if more, repeat (a)(b)(c)
// ---- encrypt end ----
// tail

////////// format 0x10 (reply 0x00) ////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x10
// reply code, 1 byte, 0x00, means ok
// internal id, 4 bytes
// ---- ClusterNameCard start -----
// member qq number, 4 bytes
// length of name, 1 byte
// name
// gender index, 1 byte, 'male', 'female', '-', so 0, 1, 2...
// length of phone, 1 byte
// phone
// length of email, 1 byte
// email
// length of remark, 1 byte
// remark
// ---- ClusterNameCard end -----
// tail

////////// format 0x10 (reply 0x05) ////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x10
// reply code, 1 byte, 0x05, means user doesn't have name card
// internal id, 4 bytes
// user qq number, 4 bytes
// length of error message, 1 byte
// error message
// --- encrypt end ---
// tail

///////// format 0x12 //////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x12
// reply code, 1 byte
// internal id, 4 bytes
// unknown 1 byte
// organization version id, 4 bytes
// (NOTE) if organization version id is 0, body ends here
// number of organization, 1 byte
// ------ QQOrganization start -----
// id of organization, 1 byte
// organization level flag, 4 bytes.
//			bit31 - bit24 => level 0
//			bit23 - bit18 => level 1
//			bit17 - bit12 => level 2
//			bit11 - bit6  => level 3
//			bit5 - bit0	  => reserved
// length of name, 1 byte
// name
// ----- QQOrganization end ----
// (NOTE) if more, repeat QQOrganization
// tail

///////// format 0x19 //////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x19
// unknown version id, 4 bytes
// unknown version id, 4 bytes
// cluster name card version id, 4 bytes
// unknown version id, 4 bytes
// --- encrypt end ---
// tail

///////// format 0x1A //////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x1A
// reply code, 1 byte
// internal id, 4 bytes
// --- encrypt end ---
// tail

///////// format 0x1B //////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x1B
// reply code, 1 byte
// internal id, 4 bytes
// cluster version id, 4 bytes
// qq number whose role is set, 4 bytes
// user role after set, 1 byte
// --- encrypt end ---
// tail

///////// format 0x1C (reply 0x00) //////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x1C
// reply code, 1 byte, 0x00, means ok
// internal id, 4 bytes
// qq number transfer to, 4 bytes
// cluster version id, 4 bytes
// -- encrypt end ---
// tail

///////// format 0x1C (reply non zero) //////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x1C
// reply code, 1 byte, 0x00, means ok
// internal id, 4 bytes
// qq number transfer to, 4 bytes
// error message
// -- encrypt end ---
// tail

///////// format 0x1D //////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x1D
// reply code, 1 byte
// internal id, 4 bytes
// --- encrypt end ---
// tail

////////// format 0x20 /////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x20
// reply code, 1 byte
// cluster count, 1 bytes
// internal id, 4 bytes
// external id, 4 bytes
// message setting, 1 byte
// --- encrypt end ----
// tail

////////// format 0x21 /////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x21
// reply code, 1 byte
// internal id, 4 bytes
// external id, 4 bytes
// ---- encrypt end ---
// tail

////////// format 0x22 /////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x22
// reply code, 1 byte
// unknown 1 byte
// internal id, 4 bytes
// external id, 4 bytes
// member count, 2 bytes
// --- LastTalkTime start ---
// qq number, 4 bytes
// last talk time, 2 bytes, just day number from 1970/1/1
// --- LastTalkTime end ---
// (NOTE) if more, repeat LastTalkTime
// ---- encrypt end ---
// tail

////////// format 0x30 /////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x30
// reply code, 1 byte
// temp cluster type, 1 byte
// parent cluster internal id, 4 bytes
// temp cluster internal id, 4 bytes
// -- encrypt end ---
// tail

////////// format 0x31 ///////////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x31
// reply code, 1 byte
// temp cluster type, 1 byte
// parent cluster internal id, 4 bytes
// temp cluster internal id, 4 bytes
// --- encrypt end ---
// tail

////////// format 0x32 ///////////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x32
// reply code, 1 byte
// temp cluster type, 1 byte
// parent cluster internal id, 4 bytes
// temp cluster internal id, 4 bytes
// --- encrypt end ---
// tail

////////// format 0x33 ///////////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x33
// reply code, 1 byte
// ------ ClusterInfo start (use readTemp) ------
// whether this cluster is a permanent, 1 byte, non-zero means true
// parent cluster internal id, 4 bytes
// internal id, 4 bytes
// creator qq number, 4 bytes
// uknown 4 bytes
// length of cluster name, 1 byte
// name
// ------- ClusterInfo end -----
// ----- Member start (use readTemp) ------
// member qq number, 4 bytes
// organization id, 1 byte, no use for temp cluster
// ----- Member end -------
// (NOTE) if more member, repeat Member
// ----- encrypt end -----
// tail

////////// format 0x34 ///////////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x34
// reply code, 1 byte
// temp cluster type, 1 byte
// parent cluster internal id, 4 bytes
// temp cluster internal id, 4 bytes
// --- encrypt end ---
// tail

///////// format 0x35 /////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x36
// reply code, 1 byte
// temp cluster type, 1 byte
// parent cluster internal id, 4 bytes
// temp cluster internal id, 4 bytes
// --- encrypt end ---
// tail

///////// format 0x36 /////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x36
// reply code, 1 byte
// sub sub command, 1 byte
// parent cluster internal id, 4 bytes
// parent cluster external id, 4 bytes
// ------ SubCluster start ------
// internal id, 4 bytes
// length of name, 1 byte
// name
// ------ SubCluster end -----
// (NOTE) if more, repeat SubCluster
// --- encrypt end ----
// tail

////////// format 0x37 ///////////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x37
// reply code, 1 byte
// temp cluster type, 1 byte
// parent cluster internal id, 4 bytes
// temp cluster internal id, 4 bytes
// a. member qq number, 4 bytes
// (NOTE) if more members, repeat (a)
// --- encrypt end ---
// tail

///////// format 0x70 /////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x70
// reply code, 1 byte
// internal id, 4 bytes
// --- encrypt end ----
// tail

///////// format 0x71 /////////
// header
// ----- encrypt start (session key) -----
// sub command, 1 byte, 0x71
// reply code, 1 byte
// internal id, 4 bytes
// external id, 4 bytes
// channel setting mask, 4 bytes
// (NOTE) according to the mask, following content may exist or not
// notification right, 1 byte
// default channel id, 4 bytes
// ---- encrypt end ----
// tail

@interface ClusterCommandReplyPacket : BasicInPacket {
	// common
	char m_subSubCommand;
	UInt32 m_internalId;
	UInt32 m_externalId;
	UInt32 m_parentId;
	
	// error
	NSString* m_errorMessage;
	
	// for 0x04 or 0x33
	ClusterInfo* m_info;
	NSMutableArray* m_members;
	
	// for 0x06
	NSMutableArray* m_infos;
	
	// for 0x07
	char m_authType;
	
	// for 0x0B, 0x37
	NSMutableArray* m_memberQQs;
	
	// for 0x0C
	NSMutableArray* m_memberInfos;
	
	// for 0x0F
	UInt32 m_nextStartPosition;
	NSMutableArray* m_clusterNameCards;
	
	// for 0x0F, 0x19
	UInt32 m_clusterNameCardVersionId;
	
	// for 0x10
	ClusterNameCard* m_clusterNameCard;
	
	// for 0x12
	NSMutableArray* m_organizations;
	UInt32 m_organizationVersion;
	
	// for 0x1B
	UInt32 m_clusterVersionId;
	char m_memberRole;
	
	// for 0x1B, 0x1C
	UInt32 m_memberQQ;
	
	// for 0x20
	NSMutableArray* m_messageSettings;
	
	// for 0x22
	NSMutableArray* m_lastTalkTimes;
	
	// for 0x30, 0x31, 0x32, 0x34, 0x35, 0x37
	char m_tempClusterType;
	
	// for 0x36
	NSMutableArray* m_subClusters;
	
	// for 0x71
	UInt32 m_mask;
	char m_notificationRight;
	UInt32 m_defaultChannelId;
}

// parse
- (void)parseCreate:(ByteBuffer*)buf;
- (void)parseModifyMember:(ByteBuffer*)buf;
- (void)parseModifyInfo:(ByteBuffer*)buf;
- (void)parseGetInfo:(ByteBuffer*)buf;
- (void)parseActivate:(ByteBuffer*)buf;
- (void)parseSearch:(ByteBuffer*)buf;
- (void)parseJoin:(ByteBuffer*)buf;
- (void)parseAuthorize:(ByteBuffer*)buf;
- (void)parseExit:(ByteBuffer*)buf;
- (void)parseGetOnlineMember:(ByteBuffer*)buf;
- (void)parseGetMemberInfo:(ByteBuffer*)buf;
- (void)parseModifyCard:(ByteBuffer*)buf;
- (void)parseBatchGetCard:(ByteBuffer*)buf;
- (void)parseGetCard:(ByteBuffer*)buf;
- (void)parseCommitOrganization:(ByteBuffer*)buf;
- (void)parseUpdateOrganization:(ByteBuffer*)buf;
- (void)parseCommitMemberGroup:(ByteBuffer*)buf;
- (void)parseGetVersionID:(ByteBuffer*)buf;
- (void)parseSendIMEx:(ByteBuffer*)buf;
- (void)parseSetRole:(ByteBuffer*)buf;
- (void)parseTransferRole:(ByteBuffer*)buf;
- (void)parseDismiss:(ByteBuffer*)buf;
- (void)parseTempCreate:(ByteBuffer*)buf;
- (void)parseTempModifyMember:(ByteBuffer*)buf;
- (void)parseTempExit:(ByteBuffer*)buf;
- (void)parseTempGetInfo:(ByteBuffer*)buf;
- (void)parseTempModifyInfo:(ByteBuffer*)buf;
- (void)parseTempSendIM:(ByteBuffer*)buf;
- (void)parseSubOp:(ByteBuffer*)buf;
- (void)parseTempActivate:(ByteBuffer*)buf;
- (void)parseGetMessageSetting:(ByteBuffer*)buf;
- (void)parseModifyMessageSetting:(ByteBuffer*)buf;
- (void)parseModifyChannelSetting:(ByteBuffer*)buf;
- (void)parseGetChannelSetting:(ByteBuffer*)buf;
- (void)parseGetLastTalkTime:(ByteBuffer*)buf;

// getter and setter
- (char)subSubCommand;
- (UInt32)internalId;
- (UInt32)externalId;
- (UInt32)parentId;
- (ClusterInfo*)info;
- (NSArray*)members;
- (NSString*)errorMessage;
- (UInt32)memberQQ;
- (NSArray*)memberQQs;
- (NSArray*)subClusters;
- (NSArray*)organizations;
- (UInt32)organizationVersion;
- (NSArray*)memberInfos;
- (NSArray*)infos;
- (ClusterNameCard*)clusterNameCard;
- (NSArray*)clusterNameCards;
- (UInt32)clusterNameCardVersionId;
- (UInt32)nextStartPosition;
- (NSArray*)messageSettings;
- (UInt32)mask;
- (char)notificationRight;
- (UInt32)defaultChannelId;
- (NSArray*)lastTalkTimes;
- (char)tempClusterType;
- (UInt32)clusterVersionId;
- (char)memberRole;
- (char)authType;

@end
