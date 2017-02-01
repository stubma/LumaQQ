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

#import "FriendDataOpPacket.h"


@implementation FriendDataOpPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandFriendDataOp;
		m_subCommand = kQQSubCommandGetFriendRemark;
	}
	return self;
}

- (void) dealloc {
	[m_remark release];
	[m_name release];
	[super dealloc];
}

- (void)fillBody:(ByteBuffer*)buf {
	[buf writeByte:m_subCommand];
	switch(m_subCommand) {
		case kQQSubCommandBatchGetFriendRemark:
			[buf writeByte:m_page];
			break;
		case kQQSubCommandUploadFriendRemark:
			[buf writeByte:0];
			[m_remark write:buf];
			break;
		case kQQSubCommandRemoveFriendFromList:
		case kQQSubCommandGetFriendRemark:
			[buf writeUInt32:m_QQ];
			break;
		case kQQSubCommandModifyRemarkName:
			[buf writeUInt32:m_QQ];
			[buf writeString:m_name withLength:YES lengthByte:1];
			break;
	}
}

#pragma mark -
#pragma mark getter and setter

- (char)page {
	return m_page;
}

- (void)setPage:(char)page {
	m_page = page;
}

- (FriendRemark*)remark {
	return m_remark;
}

- (void)setRemark:(FriendRemark*)remark {
	[remark retain];
	[m_remark release];
	m_remark = remark;
}

- (UInt32)QQ {
	return m_QQ;
}

- (void)setQQ:(UInt32)QQ {
	m_QQ = QQ;
}

- (NSString*)name {
	return m_name;
}

- (void)setName:(NSString*)name {
	[name retain];
	[m_name release];
	m_name = name;
}

@end
