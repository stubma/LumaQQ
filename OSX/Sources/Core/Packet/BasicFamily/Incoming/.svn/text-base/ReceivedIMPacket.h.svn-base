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
#import "ReceivedIMPacketHeader.h"
#import "NormalIMHeader.h"
#import "ClusterIM.h"
#import "NormalIM.h"
#import "MobileIM.h"
#import "SystemIM.h"
#import "ClusterNotification.h"
#import "SignatureChangedNotification.h"
#import "TempSessionIM.h"

////////// format 0x0009 and 0x000A ///////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// NormalIMHeader, see Source/Bean/NormalIMHeader.mm comment
// --- NormalIM start ---
// session id, 2 bytes, if an operation need more than 1 packet, this id should be kept same
// send time, 4 bytes, it's the second from 1970/1/1
// sender head, 2 bytes
// message property flag, 4 bytes, all unknown
// message fragment count, 1 byte
// fragment index of this packet, 1 byte, start from 0
// message id, 2 bytes, messages belong to same fragment family should have same id
// reply type, 1 byte, auto reply or manual reply?
// message, the length equals remaining - fontstyle length
// FontStyle structure, see Source/Bean/FontStyle.mm comment
// --- NormalIM end ---
// --- encrypt end ---
// tail

////////// format 0x0013 ///////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// --- MobileIM start ---
// unknown 1 byte
// sender qq number, 4 bytes
// sender head, 2 bytes
// sender name, 13 bytes, if less than 13, fill zero
// unknown 1 byte
// send time, 4 bytes
// unknown 1 byte
// message, 160 bytes, if less than 160, fill zero
// NOTE: if it's a long message, first two bytes of message are fixed, seems it means a message id, but
// 		 QQ display it as well as the message body, I think it's a bug
// --- encrypt end ---
// tail

////////// format 0x0014 ///////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// --- MobileIM start ---
// unknown 1 byte
// sender mobile number, 18 bytes, if less than 18, fill zero
// unknown 2 bytes
// send time, 4 bytes
// unknown 1 byte
// message, 160 bytes, if less than 160, fill zero
// NOTE: if it's a long message, first two bytes of message are fixed, seems it means a message id, but
// 		 QQ display it as well as the message body, I think it's a bug
// --- encrypt end ---
// tail

////////// format 0x001F ///////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// --- TempSessionIM start ---
// sender qq number, 4 bytes
// unknown 4 bytes
// sender nick length, 1 byte
// sender nick
// sender site length, 1 byte
// sender site
// NOTE: site is where the sender comes from. For example, a user in a cluster, then the site may be cluster name
// unknown 1 byte
// send time, 4 bytes
// length of following bytes, 2 bytes (exclusive)
// NOTE: there are 4 unknown bytes at last, the length doesn't count them
// message, the length equals length - fontstyle length
// FontStyle structure, see Source/Bean/FontStyle.mm comment
// unknown 4 bytes
// --- TempSessionIM end ---
// tail

////////// format 0x0020 ///////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// --- ClusterIM start (using read0020) ---
// external id, 4 bytes
// cluster type, 1 byte
// sender qq number, 4 bytes
// unknown 2 bytes
// message sequence, 2 bytes
// send time, 4 bytes
// cluster version id, 4 bytes
// length of message, 2 bytes
// message
// (NOTE) if has more bytes, then should be FontStyle structure
// --- ClusterIM end ---
// --- encrypt end ---
// tail

////////// format 0x0021 ///////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// external id, 4 bytes
// cluster type, 1 byte
// qq number who joins cluster, 4 bytes
// root cause, 1 byte, 0x03, means admin added him
// qq number who added him, 4 bytes
// length of user role string who added him, 1 byte
// user role string of who added him
// length of unknown token string, 2 bytes
// unknown token string
// --- encrypt end ---
// tail

////////// format 0x0022 (0x01 or 0x02) ///////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// external id, 4 bytes
// cluster type, 1 byte
// qq number who exits cluster, 4 bytes
// root cause, 1 byte, 0x01, means cluster is dismissed, or 0x02, means member exits
// length of unknown token string, 2 bytes
// unknown token string
// --- encrypt end ---
// tail

////////// format 0x0022 (0x03) ///////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// external id, 4 bytes
// cluster type, 1 byte
// qq number who exits cluster, 4 bytes
// root cause, 1 byte, 0x03, means admin kicked him
// qq number who kicked him, 4 bytes
// length of user role string who kicked him, 1 byte
// user role string of who kicked him
// length of unknown token string, 2 bytes
// unknown token string
// --- encrypt end ---
// tail

////////// format 0x0023 ///////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// external id, 4 bytes
// cluster type, 1 byte
// sender qq number, 4 bytes
// length of attached message, 1 byte
// attached message
// length of unknown token string, 2 bytes
// unknown token string
// length of auth info, 2 bytes
// auth info, you should include this in your approve/reject packet
// --- encrypt end ---
// tail

////////// format 0x0024 ///////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// external id, 4 bytes
// cluster type, 1 byte
// sender qq number, 4 bytes
// length of attached message, 1 byte, no use for this packet, so 0x01 here
// attached message, no use for this packet, so 0x2D here, means string "-"
// length of unknown token string, 2 bytes
// unknown token string
// --- encrypt end ---
// tail

////////// format 0x0025 ///////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// external id, 4 bytes
// cluster type, 1 byte
// sender qq number, 4 bytes
// length of attached message, 1 byte
// attached message
// length of unknown token string, 2 bytes
// unknown token string
// --- encrypt end ---
// tail

////////// format 0x0026 ///////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// external id, 4 bytes
// cluster type, 1 byte
// sender qq number, 4 bytes
// length of unknown token string, 2 bytes
// unknown token string
// --- encrypt end ---
// tail

////////// format 0x002A ///////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// NOTE: for temp cluster message, the sender in header is still parent cluster internal id
// --- ClusterIM start (temp cluster message) ---
// parent cluster internal id, 4 bytes
// cluster type, 1 byte
// cluster internal id, 4 bytes
// sender qq, 4 bytes
// unknown 2 bytes
// message sequence, 2 bytes
// send time, 4 bytes
// version id, 4 bytes
// length of following data, 2 bytes, exclusive
// content type, 2 bytes
// fragment count, 1 byte
// fragment index, 1 byte
// message id, 2 bytes
// unknown 4 bytes
// message data
// (NOTE) if this is NOT last fragment, ClusterIM ends here
// FontStyle structure, see Source/Bean/FontStyle.mm comment
// --- ClusterIM end ---
// --- encrypt end ---
// tail

////////// format 0x002B ///////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// --- ClusterIM start ---
// cluster external id, 4 bytes
// cluster type, 1 byte
// sender qq number, 4 bytes
// unknown 2 bytes
// message sequence, 2 bytes
// message send time, 4 bytes, second from 1979/1/1
// cluster version id, 4 bytes
// length of following data (exclusive), 2 bytes
// content type, 2 bytes
// fragment count, 1 byte
// fragment index, 1 byte
// message id, 2 bytes
// unknown 4 bytes
// message data
// (NOTE) if this is NOT last fragment, ClusterIM ends here
// FontStyle structure, see Source/Bean/FontStyle.mm comment
// --- ClusterIM end ---
// --- encrypt end ---
// tail

////////// format 0x002C (0x01 or 0x00) ///////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// external id, 4 bytes
// cluster type, 1 byte
// root cause, 1 byte, 0x01 means admin is set, 0x00 means admin is unset
// qq number of who is set/unset, 4 bytes
// role after set/unset, 1 byte
// --- encrypt end ---
// tail

////////// format 0x002C (0xFF) ///////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// external id, 4 bytes
// cluster type, 1 byte
// root cause, 1 byte, 0xFF, means owner is changed
// old owner qq number, 4 bytes
// new owner qq number, 4 bytes
// --- encrypt end ---
// tail

///////// format 0x0030 ///////////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// system message type, 1 byte
// system message length, 1 byte
// system message
// --- encrypt end ---
// tail

///////// format 0x0041 ///////////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// qq number whose signature is changed, 4 bytes
// change time of signature, 4 bytes
// length of new signature, 1 byte
// new signature
// --- encrypt end ---
// tail

///////// format 0x0049 /////////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// the number of friends whose custom head is changed, 1 byte
// --- CustomHead start ---
// friend qq, 4 bytes
// timestamp of custom head, 4 bytes
// md5 of custom head, 16 bytes
// --- CustomHead end ---
// NOTE: if more, repeat CustomHead structure
// --- encrypt end ---
// tail

//////// format 0x0084 & 0x0085 ////////
// header
// --- encrypt start (session key) ---
// ReceivedIMPacketHeader, see Source/Bean/ReceivedIMPacketHeader.mm comment
// NormalIMHeader, see Source/Bean/NormalIMHeader.mm comment
// --- NormalIM start ---
// session id, 2 bytes, if an operation need more than 1 packet, this id should be kept same
// send time, 4 bytes, it's the second from 1970/1/1
// sender head, 2 bytes
// message property flag, 4 bytes, all unknown
// unknown 8 bytes
// message fragment count, 1 byte
// fragment index of this packet, 1 byte, start from 0
// message id, 2 bytes, messages belong to same fragment family should have same id
// reply type, 1 byte, auto reply or manual reply?
// message, the length equals remaining - fontstyle length
// FontStyle structure, see Source/Bean/FontStyle.mm comment
// --- NormalIM end ---
// --- encrypt end ---
// tail

@interface ReceivedIMPacket : BasicInPacket {
	ReceivedIMPacketHeader* m_imHeader;
	
	// for all normal im
	NormalIMHeader* m_normalIMHeader;
	
	// for 0x0009, 0x000A, 0x0084
	NormalIM* m_normalIM;
	
	// for 0x002B
	ClusterIM* m_clusterIM;
	
	// for 0x0013 and 0x0014
	MobileIM* m_mobileIM;
	
	// for 0x0021, 0x0022, 0x0023, 0x0024, 0x0025, 0x0026, 0x002C
	ClusterNotification* m_clusterNotification;
	
	// for 0x0030
	SystemIM* m_systemIM;
	
	// for 0x0041
	SignatureChangedNotification* m_signatureNotification;
	
	// for 0x0049
	NSMutableArray* m_customHeads;
	
	// for 0x001F
	TempSessionIM* m_tempSessionIM;
}

// getter and setter
- (ReceivedIMPacketHeader*)imHeader;
- (NormalIMHeader*)normalIMHeader;
- (NormalIM*)normalIM;
- (ClusterIM*)clusterIM;
- (MobileIM*)mobileIM;
- (SystemIM*)systemIM;
- (ClusterNotification*)clusterNotification;
- (SignatureChangedNotification*)signatureNotification;
- (TempSessionIM*)tempSessionIM;
- (NSArray*)customHeads;

@end
