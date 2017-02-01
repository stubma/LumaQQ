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

#import <Cocoa/Cocoa.h>

static const int s_seq_code[][2] = {
	{0, 0x4F},
	{1, 0x42},
	{2, 0x43},
	{3, 0x44},
	{4, 0x45},
	{5, 0x46},
	{6, 0x47},
	{7, 0x48},
	{8, 0x49},
	{9, 0x4A},
	{10, 0x4B},
	{11, 0x4C},
	{12, 0x4D},
	{13, 0x4E},
	{14, 0x41},
	{15, 0x73},
	{16, 0x74},
	{17, 0xA1},
	{18, 0x76},
	{19, 0x77},
	{20, 0x8A},
	{21, 0x8B},
	{22, 0x8C},
	{23, 0x8D},
	{24, 0x8E},
	{25, 0x8F},
	{26, 0x78},
	{27, 0x79},
	{28, 0x7A},
	{29, 0x7B},
	{30, 0x90},
	{31, 0x91},
	{32, 0x92},
	{33, 0x93},
	{34, 0x94},
	{35, 0x95},
	{36, 0x96},
	{37, 0x97},
	{38, 0x98},
	{39, 0x99},
	{40, 0xA2},
	{41, 0xA3},
	{42, 0xA4},
	{43, 0xA5},
	{44, 0xA6},
	{45, 0xA7},
	{46, 0xA8},
	{47, 0xA9},
	{48, 0xAA},
	{49, 0xAB},
	{50, 0xAC},
	{51, 0xAD},
	{52, 0xAE},
	{53, 0xAF},
	{54, 0xB0},
	{55, 0xB1},
	{56, 0x61},
	{57, 0xB2},
	{58, 0xB3},
	{59, 0xB4},
	{60, 0x80},
	{61, 0x81},
	{62, 0x7C},
	{63, 0x62},
	{64, 0x63},
	{65, 0xB5},
	{66, 0x65},
	{67, 0x66},
	{68, 0x67},
	{69, 0x9C},
	{70, 0x9D},
	{71, 0x9E},
	{72, 0x5E},
	{73, 0xB6},
	{74, 0x89},
	{75, 0x6E},
	{76, 0x6B},
	{77, 0x68},
	{78, 0x7F},
	{79, 0x6F},
	{80, 0x70},
	{81, 0x88},
	{82, 0xA0},
	{83, 0xB7},
	{84, 0xB8},
	{85, 0xB9},
	{86, 0xBA},
	{87, 0xBB},
	{88, 0xBC},
	{89, 0xBD},
	{90, 0x5C},
	{91, 0x56},
	{92, 0x58},
	{93, 0x5A},
	{94, 0x5B},
	{95, 0xBE},
	{96, 0xBF},
	{97, 0xC0},
	{98, 0xC1},
	{99, 0xC2},
	{100, 0xC3},
	{101, 0xC4},
	{102, 0xC5},
	{103, 0xC6},
	{104, 0xC7},
	{105, 0x75},
	{106, 0x59},
	{107, 0x57},
	{108, 0x55},
	{109, 0x7D},
	{110, 0x7E},
	{111, 0x9A},
	{112, 0x9B},
	{113, 0x60},
	{114, 0x9F},
	{115, 0x82},
	{116, 0x64},
	{117, 0x83},
	{118, 0x84},
	{119, 0x85},
	{120, 0x86},
	{121, 0x87},
	{122, 0x50},
	{123, 0x51},
	{124, 0x52},
	{125, 0x53},
	{126, 0x54},
	{127, 0x5D},
	{128, 0x5F},
	{129, 0x69},
	{130, 0x6A},
	{131, 0x6C},
	{132, 0x6D},
	{133, 0x71},
	{134, 0x72}
};

#define DEFAULT_FACE_COUNT (sizeof(s_seq_code) / sizeof(int) / 2)

@interface DefaultFace : NSObject {

}

+ (int)index2code:(int)index;
+ (int)code2index:(int)code;
+ (int)count;
+ (NSString*)index2name:(int)index;
+ (NSString*)code2name:(int)code;

@end
