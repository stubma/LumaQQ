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

#import "Constants.h"
#import "ContactInfo.h"
#import "QQConstants.h"
#import "NSString-Filter.h"

@implementation ContactInfo

static const char DELIMITER = 0x1E;

- (id) init {
	self = [super init];
	if (self != nil) {
		m_QQ = 0;
		m_age = 0;
		m_authType = kQQAuthNo;
		m_head = 0;
		m_contactVisibility = kQQContactVisibilityAll;
		m_horoscope = 1;
		m_zodiac = 1;
		m_blood = 1;
		m_userFlag = 0;
	}
	return self;
}

- (void) dealloc {
	[m_nick release];
	[m_country release];
	[m_province release];
	[m_zipcode release];
	[m_address release];
	[m_telephone release];
	[m_gender release];
	[m_name release];
	[m_email release];
	[m_pagerSn release];
	[m_pager release];
	[m_pagerSp release];
	[m_pagerBase release];
	[m_pagerType release];
	[m_occupation release];
	[m_homepage release];
	[m_unknown1 release];
	[m_unknown2 release];
	[m_mobile release];
	[m_mobileType release];
	[m_introduction release];
	[m_city release];
	[m_unknown3 release];
	[m_unknown4 release];
	[m_unknown5 release];
	[m_unknown6 release];
	[m_college release];
	[m_unknown7 release];
	[super dealloc];
}

- (BOOL)isMM {
	if(m_gender) {
		// compare utf8 code
		const char* gender = [m_gender UTF8String];
		return (gender[0] & 0xFF) == 0xE5 && 
			(gender[1] & 0xFF) == 0xA5 &&
			(gender[2] & 0xFF) == 0xB3;
	} else
		return NO;
}

- (void)read:(ByteBuffer*)buf {
	NSString* str = [buf getStringUntil:DELIMITER];
	m_QQ = [str intValue];	
	m_nick = [[[buf getStringUntil:DELIMITER] normalize] retain];
	m_country = [[buf getStringUntil:DELIMITER] retain];
	m_province = [[buf getStringUntil:DELIMITER] retain];
	m_zipcode = [[buf getStringUntil:DELIMITER] retain];
	m_address = [[buf getStringUntil:DELIMITER] retain];
	m_telephone = [[buf getStringUntil:DELIMITER] retain];
	str = [buf getStringUntil:DELIMITER];
	m_age = [str intValue];
	m_gender = [[buf getStringUntil:DELIMITER] retain];
	m_name = [[[buf getStringUntil:DELIMITER] normalize] retain];
	m_email = [[buf getStringUntil:DELIMITER] retain];
	m_pagerSn = [[buf getStringUntil:DELIMITER] retain];
	m_pager = [[buf getStringUntil:DELIMITER] retain];
	m_pagerSp = [[buf getStringUntil:DELIMITER] retain];
	m_pagerBase = [[buf getStringUntil:DELIMITER] retain];
	m_pagerType = [[buf getStringUntil:DELIMITER] retain];
	m_occupation = [[buf getStringUntil:DELIMITER] retain];
	m_homepage = [[buf getStringUntil:DELIMITER] retain];
	str = [buf getStringUntil:DELIMITER];
	m_authType = [str intValue];
	m_unknown1 = [[buf getStringUntil:DELIMITER] retain];
	m_unknown2 = [[buf getStringUntil:DELIMITER] retain];
	str = [buf getStringUntil:DELIMITER];
	m_head = [str intValue];
	m_mobile = [[buf getStringUntil:DELIMITER] retain];
	m_mobileType = [[buf getStringUntil:DELIMITER] retain];
	m_introduction = [[buf getStringUntil:DELIMITER] retain];
	m_city = [[buf getStringUntil:DELIMITER] retain];
	m_unknown3 = [[buf getStringUntil:DELIMITER] retain];
	m_unknown4 = [[buf getStringUntil:DELIMITER] retain];
	m_unknown5 = [[buf getStringUntil:DELIMITER] retain];
	m_unknown6 = [[buf getStringUntil:DELIMITER] retain];
	str = [buf getStringUntil:DELIMITER];
	m_contactVisibility = [str intValue];
	m_college = [[buf getStringUntil:DELIMITER] retain];
	str = [buf getStringUntil:DELIMITER];
	m_horoscope = [str intValue];
	str = [buf getStringUntil:DELIMITER];
	m_zodiac = [str intValue];
	str = [buf getStringUntil:DELIMITER];
	m_blood = [str intValue];
	str = [buf getStringUntil:DELIMITER];
	m_userFlag = [str intValue];
	m_unknown7 = [[buf getStringUntil:DELIMITER] retain];
}

- (void)write:(ByteBuffer*)buf {
	char delimiter = 0x1F;
	
	if(m_nick)
		[buf writeString:m_nick];
	[buf writeByte:delimiter];
	
	if(m_country)
		[buf writeString:m_country];
	[buf writeByte:delimiter];
	
	if(m_province)
		[buf writeString:m_province];
	[buf writeByte:delimiter];
	
	if(m_zipcode)
		[buf writeString:m_zipcode];
	[buf writeByte:delimiter];
	
	if(m_address)
		[buf writeString:m_address];
	[buf writeByte:delimiter];
	
	if(m_telephone)
		[buf writeString:m_telephone];
	[buf writeByte:delimiter];
	
	[buf writeString:[NSString stringWithFormat:@"%d", m_age]];
	[buf writeByte:delimiter];
	
	if(m_gender)
		[buf writeString:m_gender];
	[buf writeByte:delimiter];
	
	if(m_name)
		[buf writeString:m_name];
	[buf writeByte:delimiter];
	
	if(m_email)
		[buf writeString:m_email];
	[buf writeByte:delimiter];
	
	if(m_pagerSn)
		[buf writeString:m_pagerSn];
	[buf writeByte:delimiter];
	
	if(m_pager)
		[buf writeString:m_pager];
	[buf writeByte:delimiter];
	
	if(m_pagerSp)
		[buf writeString:m_pagerSp];
	[buf writeByte:delimiter];
	
	if(m_pagerBase)
		[buf writeString:m_pagerBase];
	[buf writeByte:delimiter];
	
	if(m_pagerType)
		[buf writeString:m_pagerType];
	[buf writeByte:delimiter];
	
	if(m_occupation)
		[buf writeString:m_occupation];
	[buf writeByte:delimiter];
	
	if(m_homepage)
		[buf writeString:m_homepage];
	[buf writeByte:delimiter];
	
	[buf writeString:[NSString stringWithFormat:@"%d", m_authType]];
	[buf writeByte:delimiter];
	
	if(m_unknown1)
		[buf writeString:m_unknown1];
	[buf writeByte:delimiter];
	
	if(m_unknown2)
		[buf writeString:m_unknown2];
	[buf writeByte:delimiter];
	
	[buf writeString:[NSString stringWithFormat:@"%u", m_head]];
	[buf writeByte:delimiter];
	
	if(m_mobile)
		[buf writeString:m_mobile];
	[buf writeByte:delimiter];
	
	if(m_mobileType)
		[buf writeString:m_mobileType];
	[buf writeByte:delimiter];
	
	if(m_introduction)
		[buf writeString:m_introduction];
	[buf writeByte:delimiter];
	
	if(m_city)
		[buf writeString:m_city];
	[buf writeByte:delimiter];
	
	if(m_unknown3)
		[buf writeString:m_unknown3];
	[buf writeByte:delimiter];
	
	if(m_unknown4)
		[buf writeString:m_unknown4];
	[buf writeByte:delimiter];
	
	if(m_unknown5)
		[buf writeString:m_unknown3];
	[buf writeByte:delimiter];
	
	if(m_unknown6)
		[buf writeString:m_unknown6];
	[buf writeByte:delimiter];
	
	[buf writeString:[NSString stringWithFormat:@"%d", m_contactVisibility]];
	[buf writeByte:delimiter];
	
	if(m_college)
		[buf writeString:m_college];
	[buf writeByte:delimiter];
	
	[buf writeString:[NSString stringWithFormat:@"%d", m_horoscope]];
	[buf writeByte:delimiter];
	
	[buf writeString:[NSString stringWithFormat:@"%d", m_zodiac]];
	[buf writeByte:delimiter];
	
	[buf writeString:[NSString stringWithFormat:@"%d", m_blood]];
	[buf writeByte:delimiter];
	
	[buf writeString:[NSString stringWithFormat:@"%u", m_userFlag]];
	[buf writeByte:delimiter];
	
	if(m_unknown7)
		[buf writeString:m_unknown7];
	[buf writeByte:delimiter];
}

#pragma mark -
#pragma mark getter and setter

- (UInt32)QQ {
	return m_QQ;
}

- (void)setQQ:(UInt32)QQ {
	m_QQ = QQ;
}

- (NSString*)nick {
	return m_nick ? m_nick : kStringEmpty;
}

- (void)setNick:(NSString*)nick {
	[nick retain];
	[m_nick release];
	m_nick = nick;
}

- (NSString*)country {
	return m_country ? m_country : kStringEmpty;
}

- (void)setCountry:(NSString*)country {
	[country retain];
	[m_country release];
	m_country = country;
}

- (NSString*)province {
	return m_province ? m_province : kStringEmpty;
}

- (void)setProvince:(NSString*)province {
	[province retain];
	[m_province release];
	m_province = province;
}

- (NSString*)zipcode {
	return m_zipcode ? m_zipcode : kStringEmpty;
}

- (void)setZipcode:(NSString*)zipcode {
	[zipcode retain];
	[m_zipcode release];
	m_zipcode = zipcode;
}

- (NSString*)address {
	return m_address ? m_address : kStringEmpty;
}

- (void)setAddress:(NSString*)address {
	[address retain];
	[m_address release];
	m_address = address;
}

- (NSString*)telephone {
	return m_telephone ? m_telephone : kStringEmpty;
}

- (void)setTelephone:(NSString*)telephone {
	[telephone retain];
	[m_telephone release];
	m_telephone = telephone;
}

- (int)age {
	return m_age;
}

- (void)setAge:(int)age {
	m_age = age;
}

- (NSString*)gender {
	return m_gender ? m_gender : kStringEmpty;
}

- (void)setGender:(NSString*)gender {
	[gender retain];
	[m_gender release];
	m_gender = gender;
}

- (NSString*)name {
	return m_name ? m_name : kStringEmpty;
}

- (void)setName:(NSString*)name {
	[name retain];
	[m_name release];
	m_name = name;
}

- (NSString*)email {
	return m_email ? m_email : kStringEmpty;
}

- (void)setEmail:(NSString*)email {
	[email retain];
	[m_email release];
	m_email = email;
}

- (NSString*)occupation {
	return m_occupation ? m_occupation : kStringEmpty;
}

- (void)setOccupation:(NSString*)occupation {
	[occupation retain];
	[m_occupation release];
	m_occupation = occupation;
}

- (NSString*)homepage {
	return m_homepage ? m_homepage : kStringEmpty;
}

- (void)setHomepage:(NSString*)homepage {
	[homepage retain];
	[m_homepage release];
	m_homepage = homepage;
}

- (char)authType {
	return m_authType;
}

- (void)setAuthType:(char)authType {
	m_authType = authType;
}

- (UInt16)head {
	return m_head;
}

- (void)setHead:(UInt16)head {
	m_head = head;
}

- (NSString*)mobile {
	return m_mobile ? m_mobile : kStringEmpty;
}

- (void)setMobile:(NSString*)mobile {
	[mobile retain];
	[m_mobile release];
	m_mobile = mobile;
}

- (NSString*)introduction {
	return m_introduction ? m_introduction : kStringEmpty;
}

- (void)setIntroduction:(NSString*)introduction {
	[introduction retain];
	[m_introduction release];
	m_introduction = introduction;
}

- (NSString*)city {
	return m_city ? m_city : kStringEmpty;
}

- (void)setCity:(NSString*)city {
	[city retain];
	[m_city release];
	m_city = city;
}

- (int)contactVisibility {
	return m_contactVisibility;
}

- (void)setContactVisibility:(int)contactVisibility {
	m_contactVisibility = contactVisibility;
}

- (NSString*)college {
	return m_college ? m_college : kStringEmpty;
}

- (void)setCollege:(NSString*)college {
	[college retain];
	[m_college release];
	m_college = college;
}

- (int)horoscope {
	return m_horoscope;
}

- (void)setHoroscope:(int)horoscope {
	m_horoscope = horoscope;
}

- (int)zodiac {
	return m_zodiac;
}

- (void)setZodiac:(int)zodiac {
	m_zodiac = zodiac;
}

- (int)blood {
	return m_blood;
}

- (void)setBlood:(int)blood {
	m_blood = blood;
}

- (int)userFlag {
	return m_userFlag;
}

- (void)setUserFlag:(int)userFlag {
	m_userFlag = userFlag;
}

@end
