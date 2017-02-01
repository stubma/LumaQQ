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
#import "ByteBuffer.h"

@interface ContactInfo : NSObject {
	UInt32 m_QQ;
	NSString* m_nick;
	NSString* m_country;
	NSString* m_province;
	NSString* m_zipcode;
	NSString* m_address;
	NSString* m_telephone;
	int m_age;
	NSString* m_gender;
	NSString* m_name;
	NSString* m_email;
	NSString* m_pagerSn;
	NSString* m_pager;
	NSString* m_pagerSp;
	NSString* m_pagerBase;
	NSString* m_pagerType;
	NSString* m_occupation;
	NSString* m_homepage;
	char m_authType;
	NSString* m_unknown1;
	NSString* m_unknown2;
	UInt16 m_head;
	NSString* m_mobile;
	NSString* m_mobileType;
	NSString* m_introduction;
	NSString* m_city;
	NSString* m_unknown3;
	NSString* m_unknown4;
	NSString* m_unknown5;
	NSString* m_unknown6;
	int m_contactVisibility;
	NSString* m_college;
	int m_horoscope;
	int m_zodiac;
	int m_blood;
	int m_userFlag;
	NSString* m_unknown7;
}

- (void)read:(ByteBuffer*)buf;
- (void)write:(ByteBuffer*)buf;
- (BOOL)isMM;

// getter and setter
- (UInt32)QQ;
- (void)setQQ:(UInt32)QQ;
- (NSString*)nick;
- (void)setNick:(NSString*)nick;
- (NSString*)country;
- (void)setCountry:(NSString*)country;
- (NSString*)province;
- (void)setProvince:(NSString*)province;
- (NSString*)zipcode;
- (void)setZipcode:(NSString*)zipcode;
- (NSString*)address;
- (void)setAddress:(NSString*)address;
- (NSString*)telephone;
- (void)setTelephone:(NSString*)telephone;
- (int)age;
- (void)setAge:(int)age;
- (NSString*)gender;
- (void)setGender:(NSString*)gender;
- (NSString*)name;
- (void)setName:(NSString*)name;
- (NSString*)email;
- (void)setEmail:(NSString*)email;
- (NSString*)occupation;
- (void)setOccupation:(NSString*)occupation;
- (NSString*)homepage;
- (void)setHomepage:(NSString*)homepage;
- (char)authType;
- (void)setAuthType:(char)authType;
- (UInt16)head;
- (void)setHead:(UInt16)head;
- (NSString*)mobile;
- (void)setMobile:(NSString*)mobile;
- (NSString*)introduction;
- (void)setIntroduction:(NSString*)introduction;
- (NSString*)city;
- (void)setCity:(NSString*)city;
- (int)contactVisibility;
- (void)setContactVisibility:(int)contactVisibility;
- (NSString*)college;
- (void)setCollege:(NSString*)college;
- (int)horoscope;
- (void)setHoroscope:(int)horoscope;
- (int)zodiac;
- (void)setZodiac:(int)zodiac;
- (int)blood;
- (void)setBlood:(int)blood;
- (int)userFlag;
- (void)setUserFlag:(int)userFlag;

@end
