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

#import "EventRouter.h"
#import "BasicFamilyEventTrigger.h"
#import "AuxiliaryFamilyEventTrigger.h"
#import "AgentFamilyEventTrigger.h"

@implementation EventRouter

+ (void)route:(InPacket*)packet outPacket:(OutPacket*)outPacket connectionId:(int)connectionId client:(QQClient*)client {
	switch([packet family]) {
		case kQQFamilyBasic:
			[BasicFamilyEventTrigger trigger:client packet:packet outPacket:outPacket connectionId:connectionId];
			break;
		case kQQFamilyAuxiliary:
			[AuxiliaryFamilyEventTrigger trigger:client packet:packet outPacket:outPacket connectionId:connectionId];
			break;
		case kQQFamilyAgent:
			[AgentFamilyEventTrigger trigger:client packet:packet outPacket:outPacket connectionId:connectionId];
			break;
	}
}

@end
