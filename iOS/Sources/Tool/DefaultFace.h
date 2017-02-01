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

static const unsigned char s_seq_code[] = {
	0x4F, // 0
	0x42, // 1
	0x43, // 2
	0x44, // 3
	0x45, // 4
	0x46, // 5
	0x47, // 6
	0x48, // 7
	0x49, // 8
	0x4A, // 9
	0x4B, // 10
	0x4C, // 11
	0x4D, // 12
	0x4E, // 13
	0x41, // 14
	0x73, // 15
	0x74, // 16
	0xA1, // 17
	0x76, // 18
	0x77, // 19
	0x8A, // 20
	0x8B, // 21
	0x8C, // 22
	0x8D, // 23
	0x8E, // 24
	0x8F, // 25
	0x78, // 26
	0x79, // 27
	0x7A, // 28
	0x7B, // 29
	0x90, // 30
	0x91, // 31
	0x92, // 32
	0x93, // 33
	0x94, // 34
	0x95, // 35
	0x96, // 36
	0x97, // 37
	0x98, // 38 
	0x99, // 39
	0xA2, // 40
	0xA3, // 41
	0xA4, // 42
	0xA5, // 43
	0xA6, // 44
	0xA7, // 45
	0xA8, // 46
	0xA9, // 47
	0xAA, // 48
	0xAB, // 49
	0xAC, // 50
	0xAD, // 51
	0xAE, // 52
	0xAF, // 53
	0xB0, // 54
	0xB1, // 55
	0x61, // 56
	0xB2, // 57
	0xB3, // 58
	0xB4, // 59
	0x80, // 60
	0x81, // 61
	0x7C, // 62
	0x62, // 63
	0x63, // 64
	0xB5, // 65
	0x65, // 66
	0x66, // 67
	0x67, // 68
	0x9C, // 69
	0x9D, // 70
	0x9E, // 71
	0x5E, // 72
	0xB6, // 73
	0x89, // 74
	0x6E, // 75
	0x6B, // 76
	0x68, // 77
	0x7F, // 78
	0x6F, // 79
	0x70, // 80
	0x88, // 81
	0xA0, // 82
	0xB7, // 83
	0xB8, // 84
	0xB9, // 85
	0xBA, // 86
	0xBB, // 87
	0xBC, // 88
	0xBD, // 89
	0x5C, // 90
	0x56, // 91
	0x58, // 92
	0x5A, // 93
	0x5B, // 94
	0xBE, // 95
	0xBF, // 96 
	0xC0, // 97
	0xC1, // 98
	0xC2, // 99
	0xC3, // 100
	0xC4, // 101
	0xC5, // 102
	0xC6, // 103
	0xC7, // 104
	0x75, // 105
	0x59, // 106
	0x57, // 107
	0x55, // 108
	0x7D, // 109
	0x7E, // 110
	0x9A, // 111
	0x9B, // 112
	0x60, // 113
	0x9F, // 114
	0x82, // 115
	0x64, // 116
	0x83, // 117
	0x84, // 118
	0x85, // 119
	0x86, // 120
	0x87, // 121
	0x50, // 122
	0x51, // 123
	0x52, // 124
	0x53, // 125
	0x54, // 126
	0x5D, // 127
	0x5F, // 128
	0x69, // 129
	0x6A, // 130
	0x6C, // 131
	0x6D, // 132
	0x71, // 133
	0x72  // 134
};

static const NSString* s_shortcut[] = {
	@":)", // 0
	@":~",
	@":B",
	@":|",
	@"8-)",
	@":<",
	@":$",
	@":X",
	@":Z",
	@":'(",
	@":-|", // 10
	@":@",
	@":P",
	@":D",
	@":O",
	@":(",
	@":+",
	@"--b",
	@":Q",
	@":T",
	@";P", // 20
	@";-D",
	@":d",
	@";o",
	@":g",
	@"|-)",
	@":!",
	@":L",
	@":>",
	@":;",
	@";f", // 30
	@":-S",
	@"?",
	@";x",
	@";@",
	@":8",
	@";!",
	@"!!!",
	@"xx",
	@"bye",
	@"wipe", // 40
	@"dig",
	@"handclap",
	@"&-(",
	@"B-)",
	@"<@",
	@"@>",
	@":-O",
	@">-|",
	@"P-(",
	@":'|", // 50
	@"X-)",
	@":*",
	@"@x",
	@"8*",
	@"pd",
	@"<W>",
	@"beer",
	@"basketb",
	@"oo",
	@"coffee", // 60
	@"eat",
	@"pig",
	@"rose",
	@"fade",
	@"showlove",
	@"heart",
	@"break",
	@"cake",
	@"li",
	@"bome", // 70
	@"kn",
	@"footb",
	@"ladybug",
	@"shit",
	@"moon",
	@"sun",
	@"gift",
	@"hug",
	@"strong",
	@"weak", // 80
	@"share",
	@"v",
	@"@)",
	@"jj",
	@"@@",
	@"bad",
	@"loveu",
	@"no",
	@"ok",
	@"love", // 90
	@"<L>",
	@"jump",
	@"shake",
	@"<O>",
	@"circle",
	@"kotow",
	@"turn",
	@"skip",
	@"oY",
	@"#-O", // 100
	@"hiphop",
	@"kiss",
	@"<&",
	@"&>"
};

#define USEABLE_FACE_COUNT (sizeof(s_shortcut) / sizeof(NSString*))
#define DEFAULT_FACE_COUNT (sizeof(s_seq_code) / sizeof(unsigned char))

@interface DefaultFace : NSObject {

}

+ (unsigned char)index2code:(int)index;
+ (int)code2index:(unsigned char)code;
+ (int)count;
+ (NSString*)index2name:(int)index;
+ (NSString*)code2name:(unsigned char)code;
+ (unsigned char)parseEscape:(NSString*)string from:(int)from to:(int*)pTo;

@end
