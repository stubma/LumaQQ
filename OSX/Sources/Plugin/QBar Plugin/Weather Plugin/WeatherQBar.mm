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

#import "WeatherQBar.h"
#import "MainWindowController.h"
#import "WeatherOpReplyPacket.h"
#import "StatusEvent.h"

@implementation WeatherQBar

- (id) init {
	self = [super init];
	if (self != nil) {
		m_activated = NO;
		m_waitingSequence = 0;
	}
	return self;
}

- (NSView*)pluginView {
	return m_view;
}

- (void)awakeFromNib {
}

- (void)installPlugin:(MainWindowController*)domain {
	m_domain = [domain retain];
	[NSBundle loadNibNamed:@"WeatherQBar" owner:self];
}

- (void)uninstallPlugin:(MainWindowController*)domain {
	[m_domain release];
}

- (NSString*)pluginName {
	return @"Weather QBar";
}

- (NSString*)pluginDescription {
	return NSLocalizedStringFromTableInBundle(@"LQPluginDescription", @"WeatherQBar", [NSBundle bundleForClass:[self class]], nil);
}

- (void)pluginActivated {
	m_activated = YES;
	[[m_domain client] addStatusListener:self];
}

- (void)pluginReactivated {
	m_activated = YES;
	[[m_domain client] addStatusListener:self];
}

- (void)pluginDeactivated {
	[[m_domain client] removeStatusListener:self];
	m_activated = NO;
}

- (BOOL)isActivated {
	return m_activated;
}

#pragma mark -
#pragma mark helper

- (NSImage*)weatherImage:(NSString*)weather {
	NSBundle* bundle = [NSBundle bundleForClass:[self class]];
	NSString* sunny = NSLocalizedStringFromTableInBundle(@"LQSunny", @"WeatherQBar", bundle, nil);
	NSString* cloudy = NSLocalizedStringFromTableInBundle(@"LQCloudy", @"WeatherQBar", bundle, nil);
	NSString* overcast = NSLocalizedStringFromTableInBundle(@"LQOverCast", @"WeatherQBar", bundle, nil);
	NSString* shower = NSLocalizedStringFromTableInBundle(@"LQShower", @"WeatherQBar", bundle, nil);
	NSString* thundershower = NSLocalizedStringFromTableInBundle(@"LQThundershower", @"WeatherQBar", bundle, nil);
	NSString* spit = NSLocalizedStringFromTableInBundle(@"LQSpit", @"WeatherQBar", bundle, nil);
	NSString* moderateRain = NSLocalizedStringFromTableInBundle(@"LQModerateRain", @"WeatherQBar", bundle, nil);
	NSString* downfall = NSLocalizedStringFromTableInBundle(@"LQDownfall", @"WeatherQBar", bundle, nil);
	NSString* lightSnow = NSLocalizedStringFromTableInBundle(@"LQLightSnow", @"WeatherQBar", bundle, nil);
	NSString* middleSnow = NSLocalizedStringFromTableInBundle(@"LQMiddleSnow", @"WeatherQBar", bundle, nil);
	NSString* heavySnow = NSLocalizedStringFromTableInBundle(@"LQHeavySnow", @"WeatherQBar", bundle, nil);
	NSString* fog = NSLocalizedStringFromTableInBundle(@"LQFog", @"WeatherQBar", bundle, nil);
	NSString* hail = NSLocalizedStringFromTableInBundle(@"LQHail", @"WeatherQBar", bundle, nil);
	
	// look for "转"
	NSRange range = [weather rangeOfString:NSLocalizedStringFromTableInBundle(@"LQTurnInto", @"WeatherQBar", bundle, nil)];
	if(range.location != NSNotFound)
		weather = [weather substringFromIndex:(range.location + range.length)];
	
	// compare..
	if([weather isEqualToString:sunny])
		return [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"sunny"]] autorelease];
	else if([weather isEqualToString:cloudy])
		return [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"cloudy"]] autorelease];
	else if([weather isEqualToString:overcast])
		return [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"overcast"]] autorelease];
	else if([weather isEqualToString:shower])
		return [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"shower"]] autorelease];
	else if([weather isEqualToString:thundershower])
		return [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"thundershower"]] autorelease];
	else if([weather isEqualToString:spit])
		return [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"spit"]] autorelease];
	else if([weather isEqualToString:moderateRain])
		return [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"moderate_rain"]] autorelease];
	else if([weather isEqualToString:downfall])
		return [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"downfall"]] autorelease];
	else if([weather isEqualToString:lightSnow])
		return [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"light_snow"]] autorelease];
	else if([weather isEqualToString:middleSnow])
		return [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"middle_snow"]] autorelease];
	else if([weather isEqualToString:heavySnow])
		return [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"heavy_snow"]] autorelease];
	else if([weather isEqualToString:fog])
		return [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"fog"]] autorelease];
	else if([weather isEqualToString:hail])
		return [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"hail"]] autorelease];
	else
		return nil;	
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventGetWeatherOK:
			ret = [self handleGetWeatherOK:event];
			break;
	}
	
	return ret;
}

- (BOOL)handleGetWeatherOK:(QQNotification*)event {
	WeatherOpReplyPacket* packet = [event object];
	if(m_waitingSequence == [packet sequence]) {
		// get today component
		NSCalendar* cal = [NSCalendar currentCalendar];
		NSDateComponents* today = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
		
		// find weather bean of today
		Weather* weather = nil;
		NSEnumerator* e = [[packet weathers] objectEnumerator];
		while(weather = [e nextObject]) {
			NSDate* date = [NSDate dateWithTimeIntervalSince1970:[weather startTime]];
			NSDateComponents* comp = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
			if([today year] == [comp year] && [today month] == [comp month] && [today day] == [comp day]) 
				break;
		}
		
		if(weather == nil)
			return NO;
		
		// set info
		NSBundle* bundle = [NSBundle bundleForClass:[self class]];
		NSString* s = NSLocalizedStringFromTableInBundle(@"LQCityWeather", @"WeatherQBar", bundle, nil);
		[m_txtCityWeather setStringValue:[NSString stringWithFormat:s, [packet city], [weather weather]]];
		s = NSLocalizedStringFromTableInBundle(@"LQTemperature", @"WeatherQBar", bundle, nil);
		[m_txtTemperature setStringValue:[NSString stringWithFormat:s, [weather lowestTemperature], [weather highestTemperature]]];
		s = NSLocalizedStringFromTableInBundle(@"LQWindBearing", @"WeatherQBar", bundle, nil);
		[m_txtWind setStringValue:[NSString stringWithFormat:s, [weather windBearing]]];
		
		// load image
		[m_ivWeather setImage:[self weatherImage:[weather weather]]];
	}
	return NO;
}

#pragma mark -
#pragma mark status listener

- (BOOL)handleStatusEvent:(StatusEvent*)event {
	switch([event eventId]) {
		case kQQClientStatusChanged:
			switch([event newStatus]) {
				case kQQStatusReadyToSpeak:
					[[m_domain client] addQQListener:self];
					m_waitingSequence = [[m_domain client] getWeather];
					break;
				case kQQStatusDead:
					[[m_domain client] removeQQListener:self];
					[[m_domain client] removeStatusListener:self];
					break;
				default:
					[[m_domain client] removeQQListener:self];
					break;
			}			
			break;
	}
	return NO;
}

@end
