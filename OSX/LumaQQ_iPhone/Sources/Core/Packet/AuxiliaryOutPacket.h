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
#import "OutPacket.h"

///////// format ////////////
// header flag, 1 byte, 0x03
// command, 1 byte
// unknown 2 bytes
// NOTE: for the unkonwn 2 bytes, we can fill sequence here, it is ok
// unknown 39 bytes
// sender version, 2 bytes, so we should fill it with client version
// unknown 1 byte
// packet body
// NOTE: this family is not encrypted


@interface AuxiliaryOutPacket : OutPacket {

}

@end
