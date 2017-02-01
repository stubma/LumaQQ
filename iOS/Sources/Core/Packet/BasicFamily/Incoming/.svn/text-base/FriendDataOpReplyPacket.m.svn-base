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


#import "FriendDataOpReplyPacket.h"


@implementation FriendDataOpReplyPacket

- (void) dealloc {
	[m_remark release];
	[m_remarks release];
	[super dealloc];
}

- (void)parseBody:(ByteBuffer*)buf {
	m_subCommand = [buf getByte];
	switch(m_subCommand) {
		case kQQSubCommandBatchGetFriendRemark:
			m_reply = [buf getByte];
			m_remarks = [[NSMutableArray array] retain];
			while([buf hasAvailable]) {
				FriendRemark* remark = [[FriendRemark alloc] init];
				[remark read:buf];
				[m_remarks addObject:remark];
				[remark release];
			}
			break;
		case kQQSubCommandUploadFriendRemark:
		case kQQSubCommandRemoveFriendFromList:
		case kQQSubCommandModifyRemarkName:
			m_reply = [buf getByte];
			break;
		case kQQSubCommandGetFriendRemark:
			if([buf hasAvailable]) {
				m_remark = [[FriendRemark alloc] init];
				[m_remark read:buf];
			}
			break;
	}
}

- (BOOL)finished {
	return m_reply == kQQReplyNoMoreRemark;
}

#pragma mark -
#pragma mark getter and setter

- (NSArray*)remarks {
	return m_remarks;
}

- (FriendRemark*)remark {
	return m_remark;
}

@end
