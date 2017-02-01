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

#import "Weather.h"


@implementation Weather

- (void)read:(ByteBuffer*)buf {
	m_startTime = [buf getUInt32];
	int len = [buf getByte] & 0xFF;
	m_weather = [[buf getString:len] retain];
	len = [buf getByte] & 0xFF;
	m_windBearing = [[buf getString:len] retain];
	m_lowestTemperature = [buf getUInt16];
	m_highestTemperature = [buf getUInt16];
	[buf skip:1];
	len = [buf getByte] & 0xFF;
	m_hint = [[buf getString:len] retain];
}

- (void) dealloc {
	[m_weather release];
	[m_windBearing release];
	[m_hint release];
	[super dealloc];
}

- (UInt32)startTime {
	return m_startTime;
}

- (NSString*)weather {
	return m_weather;
}

- (NSString*)windBearing {
	return m_windBearing;
}

- (short)lowestTemperature {
	return m_lowestTemperature;
}

- (short)highestTemperature {
	return m_highestTemperature;
}

- (NSString*)hint {
	return m_hint;
}

@end
