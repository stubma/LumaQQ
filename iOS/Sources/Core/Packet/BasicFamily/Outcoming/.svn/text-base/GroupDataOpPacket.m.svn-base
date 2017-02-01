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
#import "GroupDataOpPacket.h"


@implementation GroupDataOpPacket

- (id)initWithQQUser:(QQUser*)user {
	self = [super initWithQQUser:user];
	if(self) {
		m_command = kQQCommandGroupDataOp;
		m_subCommand = kQQSubCommandDownloadGroupName;
		m_groupNames = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[m_groupNames release];
	[super dealloc];
}

- (void)fillBody:(ByteBuffer*)buf {
	NSEnumerator* e;
	int i;
	
	[buf writeByte:m_subCommand];
	switch(m_subCommand) {
		case kQQSubCommandDownloadGroupName:
			[buf writeByte:2];
			[buf writeUInt32:0];
			break;
		case kQQSubCommandUploadGroupName:
			e = [m_groupNames objectEnumerator];
			NSString* name = nil;
			i = 1;
			while(name = [e nextObject]) {
				[buf writeByte:i++];
				[buf writeString:name maxLength:16 fillZero:YES];
			}				
			break;
	}
}

#pragma mark -
#pragma mark getter and setter

- (NSArray*)groupNames {
	return m_groupNames;
}

- (void)setGroupNames:(NSArray*)groupNames {
	[m_groupNames removeAllObjects];
	[m_groupNames addObjectsFromArray:groupNames];
}

@end
