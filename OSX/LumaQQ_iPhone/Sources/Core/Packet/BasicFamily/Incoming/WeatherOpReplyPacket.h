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
#import "BasicInPacket.h"
#import "Weather.h"

/////// format 1 //////////
// header
// --- encrypt start (session key) ---
// sub command, 1 byte
// reply code, 1 byte
// province name length, 1 byte
// NOTE: if province name length is 0, you should stop here and think server can't get weather info
// province name
// city name length, 1 byte
// city name
// unknown 2 bytes
// city 2 name length, 1 byte
// city 2 name
// NOTE: don't understand why there are two cities, we must check them both because any of them maybe empty
// days of weather report, 1 byte, if 72 hours, i.e., 3 days, this field is 0x03
// a. start time of weather report, 4 bytes
// b. weather data length, 1 byte
// c. weather data
// d. wind bearing length, 1 byte
// e. wind bearing
// f. lowest temperature, 2 bytes
// g. highest temperature, 2 bytes
// NOTE: if temperature is under zero, it's a negative number
// h. unknown 1 byte
// i. hint length, 1 byte
// j. hint
// NOTE, if more weather data, repeat a, b, c, d, e, f, g, h, i, j
// unknown 2 bytes
// --- encrypt end ---
// tail

@interface WeatherOpReplyPacket : BasicInPacket {
	int m_days;
	NSString* m_province;
	NSString* m_city;
	NSMutableArray* m_weathers;
}

// getter and setter
- (int)days;
- (NSString*)province;
- (NSString*)city;
- (NSArray*)weathers;

@end
