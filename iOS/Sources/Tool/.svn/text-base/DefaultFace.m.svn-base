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

#import "DefaultFace.h"
#import "LocalizedStringTool.h"

@implementation DefaultFace

+ (unsigned char)index2code:(int)index {
	if(index < 0 || index >= DEFAULT_FACE_COUNT)
		return -1;
	return s_seq_code[index];
}

+ (int)code2index:(unsigned char)code {
	int i;
	for(i = 0; i < DEFAULT_FACE_COUNT; i++) {
		if(s_seq_code[i] == code)
			return i;
	}
	return -1;
}

+ (int)count {
	return DEFAULT_FACE_COUNT;
}

+ (NSString*)index2name:(int)index {
	return L([NSString stringWithFormat:@"DefaultFace.%u", index]);
}

+ (NSString*)code2name:(unsigned char)code {
	int index = [DefaultFace code2index:code];
	return [DefaultFace index2name:index];
}

+ (unsigned char)parseEscape:(NSString*)string from:(int)from to:(int*)pTo {
	*pTo = from;
	int length = [string length];
	if(from >= length)
		return 0;
	
	unichar c = [string characterAtIndex:from];
	switch(c) {
		/*
		 	44 B-) huaix
		 */
		case 'B':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			if(c == '-') {
				(*pTo)++;
				c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
				if(c == ')')
					return [self index2code:44];
			}
			break;
			
		/*
		 	49 P-( wq
		*/
		case 'P':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			if(c == '-') {
				(*pTo)++;
				c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
				if(c == '(')
					return [self index2code:49];
			}
			break;
		
		/*
		 	51 X-) yx
		 */
		case 'X':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			if(c == '-') {
				(*pTo)++;
				c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
				if(c == ')')
					return [self index2code:51];
			}
			break;
			
		/*
		39 bye zj
		57 beer pj
		58 basketb lq
		67 break xs
		70 bome zhd
		86 bad cj
		 */
		case 'b':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case 'o':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'm') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'e')
							return [self index2code:70];
					}
					break;
				case 'y':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'e')
						return [self index2code:39];
					break;
				case 'e':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'e') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'r')
							return [self index2code:57];
					}
					break;
				case 'a':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					switch(c) {
						case 'd':
							return [self index2code:86];
						case 's':
							(*pTo)++;
							c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
							if(c == 'k') {
								(*pTo)++;
								c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
								if(c == 'e') {
									(*pTo)++;
									c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
									if(c == 't') {
										(*pTo)++;
										c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
										if(c == 'b')
											return [self index2code:58];
									}
								}
							}
							break;
					}
					break;
				case 'r':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'e') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'a') {
							(*pTo)++;
							c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
							if(c == 'k')
								return [self index2code:67];
						}
					}
					break;
			}
			break;
			
		/*
		 60 coffee kf
		 68 cake dg
		 95 circle zhq
		 */
		case 'c':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case 'o':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'f') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'f') {
							(*pTo)++;
							c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
							if(c == 'e') {
								(*pTo)++;
								c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
								if(c == 'e')
									return [self index2code:60];
							}
						}
					}
					break;
				case 'a':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'k') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'e')
							return [self index2code:68];
					}
					break;
				case 'i':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'r') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'c') {
							(*pTo)++;
							c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
							if(c == 'l') {
								(*pTo)++;
								c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
								if(c == 'e')
									return [self index2code:95];
							}
						}
					}
					break;
			}
			break;
			
		/*
		41 dig kb
		 */
		case 'd':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			if(c == 'i') {
				(*pTo)++;
				c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
				if(c == 'g')
					return [self index2code:41];
			}
			break;
			
		/*
		 	61 eat fan
		 */
		case 'e':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			if(c == 'a') {
				(*pTo)++;
				c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
				if(c == 't')
					return [self index2code:61];
			}
			break;
		
		/*
		 64 fade dx
		 72 footb zq
		 */
		case 'f':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case 'a':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'd') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'e')
							return [self index2code:64];
					}
					break;
				case 'o':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'o') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 't') {
							(*pTo)++;
							c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
							if(c == 'b')
								return [self index2code:72];
						}
					}
					break;
			}
			break;
			
		/*
		 	77 gift lw
		 */
		case 'g':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			if(c == 'i') {
				(*pTo)++;
				c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
				if(c == 'f') {
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 't')
						return [self index2code:77];
				}
			}
			break;
			
		/*
		 42 handclap gz
		 66 heart xin
		 78 hug yb
		 101 hiphop jw
		 */
		case 'h':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case 'a':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'n') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'd') {
							(*pTo)++;
							c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
							if(c == 'c') {
								(*pTo)++;
								c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
								if(c == 'l') {
									(*pTo)++;
									c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
									if(c == 'a') {
										(*pTo)++;
										c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
										if(c == 'p')
											return [self index2code:42];
									}
								}
							}
						}
					}
					break;
				case 'e':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'a') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'r') {
							(*pTo)++;
							c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
							if(c == 't')
								return [self index2code:66];
						}
					}
					break;
				case 'i':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'p') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'h') {
							(*pTo)++;
							c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
							if(c == 'o') {
								(*pTo)++;
								c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
								if(c == 'p')
									return [self index2code:101];
							}
						}
					}
					break;
				case 'u':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'g')
						return [self index2code:78];
					break;
			}
			break;
			
		/*
		 84 jj gy
		 92 jump tiao
		 */
		case 'j':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case 'j':
					return [self index2code:84];
				case 'u':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'm') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'p')
							return [self index2code:92];
					}
					break;
			}
			break;
			
		/*
		 71 kn dao
		 96 kotow kt
		 102 kiss xw
		 */
		case 'k':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case 'n':
					return [self index2code:71];
				case 'i':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 's') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 's')
							return [self index2code:102];
					}
					break;
				case 'o':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 't') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'o') {
							(*pTo)++;
							c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
							if(c == 'w')
								return [self index2code:96];
						}
					}
					break;
			}
			break;
			
		/*
		 69 li shd
		 73 ladybug pch
		 87 loveu aini
		 90 love aiq
		 */
		case 'l':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case 'i':
					return [self index2code:69];
				case 'a':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'd') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'y') {
							(*pTo)++;
							c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
							if(c == 'b') {
								(*pTo)++;
								c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
								if(c == 'u') {
									(*pTo)++;
									c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
									if(c == 'g')
										return [self index2code:73];
								}
							}
						}
					}
					break;
				case 'o':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'v') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'e') {
							(*pTo)++;
							c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
							if(c == 'u')
								return [self index2code:87];
							else {
								(*pTo)--;
								return [self index2code:90];
							}
						}
					}
					break;
			}
			break;
			
		/*
		 	75 moon yl
		 */
		case 'm':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			if(c == 'o') {
				(*pTo)++;
				c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
				if(c == 'o') {
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'n')
						return [self index2code:75];
				}
			}
			break;
			
		/*
		 	88 no bu
		 */
		case 'n':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			if(c == 'o')
				return [self index2code:88];
			break;
			
		/*
		 59 oo pp
		 89 ok hd
		 99 oY hsh
		 */
		case 'o':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case 'o':
					return [self index2code:59];
				case 'k':
					return [self index2code:89];
				case 'Y':
					return [self index2code:99];
			}
			break;
			
		/*
		 55 pd cd
		 62 pig zt
		 */
		case 'p':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case 'd':
					return [self index2code:55];
				case 'i':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'g')
						return [self index2code:62];
					break;
			}
			break;
			
		/*
		 	63 rose mg
		 */
		case 'r':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			if(c == 'o') {
				(*pTo)++;
				c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
				if(c == 's') {
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'e')
						return [self index2code:63];
				}
			}
			break;
			
		/*
		65 showlove sa
		74 shit bb
		76 sun ty
		79 strong qiang
		81 share ws
		93 shake fad
		98 skip tsh
		 */
		case 's':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case 'h':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					switch(c) {
						case 'o':
							(*pTo)++;
							c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
							if(c == 'w') {
								(*pTo)++;
								c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
								if(c == 'l') {
									(*pTo)++;
									c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
									if(c == 'o') {
										(*pTo)++;
										c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
										if(c == 'v') {
											(*pTo)++;
											c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
											if(c == 'e')
												return [self index2code:65];
										}
									}
								}
							}
							break;
						case 'i':
							(*pTo)++;
							c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
							if(c == 't')
								return [self index2code:74];
							break;
						case 'a':
							(*pTo)++;
							c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
							switch(c) {
								case 'k':
									(*pTo)++;
									c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
									if(c == 'e')
										return [self index2code:93];
									break;
								case 'r':
									(*pTo)++;
									c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
									if(c == 'e')
										return [self index2code:81];
									break;
							}
							break;
					}
					break;
				case 'k':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'i') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'p')
							return [self index2code:98];
					}
					break;
				case 't':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'r') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'o') {
							(*pTo)++;
							c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
							if(c == 'n') {
								(*pTo)++;
								c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
								if(c == 'g')
									return [self index2code:79];
							}
						}
					}
					break;
				case 'u':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'n')
						return [self index2code:76];
					break;
			}
			break;
			
		/*
		 	97 turn ht
		 */
		case 't':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			if(c == 'u') {
				(*pTo)++;
				c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
				if(c == 'r') {
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'n')
						return [self index2code:97];
				}
			}
			break;
			
		/*
		82 v shl
		 */
		case 'v':
			return [self index2code:82];
			
		/*
		40 wipe ch
		80 weak ruo
		 */
		case 'w':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case 'i':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'p') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'e')
							return [self index2code:40];
					}
					break;
				case 'e':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'a') {
						(*pTo)++;
						c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
						if(c == 'k')
							return [self index2code:80];
					}
					break;
			}
			break;
			
		/*
		38 xx qiao
		 */
		case 'x':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			if(c == 'x')
				return [self index2code:38];
			break;
			
		/*
		48 >-| bs
		 */
		case '>':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			if(c == '-') {
				(*pTo)++;
				c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
				if(c == '|')
					return [self index2code:48];
			}
			break;
			
		/*
		53 @x xia
		46 @> yhh
		83 @) bq
		85 @@ qt
		 */
		case '@':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case 'x':
					return [self index2code:53];
				case '>':
					return [self index2code:46];
				case ')':
					return [self index2code:83];
				case '@':
					return [self index2code:85];
			}
			break;
			
		/*
		100 #-O jd
		 */
		case '#':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			if(c == '-') {
				(*pTo)++;
				c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
				if(c == 'O')
					return [self index2code:100];
			}
			break;
			
		/*
		43 &-( qd
		104 &> ytj
	 	*/
		case '&':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case '>':
					return [self index2code:104];
				case '-':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == '(')
						return [self index2code:43];
					break;
			}
			break;
			
		/*
		0 :) wx
		1 :~ pz
		2 :B se
		3 :| fd
		5 :< ll
		6 :$ hx
		7 :X bz
		8 :Z shui
		9 :'( dk
		50 :'| kk
		10 :-| gg
		31 :-S zhm
		47 :-O hq
		11 :@ fn
		12 :P tp
		13 :D cy
		14 :O jy
		15 :( ng
		16 :+ kuk
		18 :Q zk
		19 :T tuu
		22 :d baiy
		24 :g jie
		26 :! jk
		27 :L lh
		28 :> hanx
		29 :; db
		35 :8 zhem
		52 :* qq
		 */
		case ':':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case ')':
					return [self index2code:0];
				case '~':
					return [self index2code:1];
				case 'B':
					return [self index2code:2];
				case '|':
					return [self index2code:3];
				case '<':
					return [self index2code:5];
				case '$':
					return [self index2code:6];
				case 'X':
					return [self index2code:7];
				case 'Z':
					return [self index2code:8];
				case '\'':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					switch(c) {
						case '(':
							return [self index2code:9];
						case '|':
							return [self index2code:50];
					}
					break;
				case '-':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					switch(c) {
						case '|':
							return [self index2code:10];
						case 'S':
							return [self index2code:31];
						case 'O':
							return [self index2code:47];
					}
					break;
				case '@':
					return [self index2code:11];
				case 'P':
					return [self index2code:12];
				case 'D':
					return [self index2code:13];
				case 'O':
					return [self index2code:14];
				case '(':
					return [self index2code:15];
				case '+':
					return [self index2code:16];
				case 'Q':
					return [self index2code:18];
				case 'T':
					return [self index2code:19];
				case 'd':
					return [self index2code:22];
				case 'g':
					return [self index2code:24];
				case '!':
					return [self index2code:26];
				case 'L':
					return [self index2code:27];
				case '>':
					return [self index2code:28];
				case ';':
					return [self index2code:29];
				case '8':
					return [self index2code:35];
				case '*':
					return [self index2code:52];
			}
			break;
			
		/*
		20 ;P tx
		21 ;-D ka
		23 ;o am
		30 ;f fendou
		33 ;x xu
		34 ;@ yun
		36 ;! shuai
		 */
		case ';':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case 'P':
					return [self index2code:20];
				case 'o':
					return [self index2code:23];
				case 'f':
					return [self index2code:30];
				case 'x':
					return [self index2code:33];
				case '@':
					return [self index2code:34];
				case '!':
					return [self index2code:36];
				case '-':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == 'D')
						return [self index2code:21];
					break;
			}
			break;
			
		/*
		4 8-) dy
		54 8* kel
		 */
		case '8':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case '*':
					return [self index2code:54];
				case '-':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == ')')
						return [self index2code:4];
					break;
			}
			break;
			
		/*
		17 --b lengh
		 */
		case '-':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			if(c == '-') {
				(*pTo)++;
				c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
				if(c == 'b')
					return [self index2code:17];
			}
			break;
			
		/*
		25 |-) kun
		 */
		case '|':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			if(c == '-') {
				(*pTo)++;
				c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
				if(c == ')')
					return [self index2code:25];
			}
			break;
			
		/*
		32 ? yiw
		 */
		case '?':
			return [self index2code:32];
			
		/*
		37 !!! kl
		 */
		case '!':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			if(c == '!') {
				(*pTo)++;
				c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
				if(c == '!')
					return [self index2code:37];
			}
			break;
			
		/*
		45 <@ zhh
		56 <W> xig
		91 <L> fw
		94 <O> oh
		103 <& ztj
		 */
		case '<':
			(*pTo)++;
			c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
			switch(c) {
				case '@':
					return [self index2code:45];
				case '&':
					return [self index2code:103];
				case 'W':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == '>')
						return [self index2code:56];
					break;
				case 'L':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == '>')
						return [self index2code:91];
					break;
				case 'O':
					(*pTo)++;
					c = (*pTo >= length) ? 0 : [string characterAtIndex:*pTo];
					if(c == '>')
						return [self index2code:94];
					break;
			}
			break;
	}
	
	// no matching
	*pTo = 0;
	return 0;
}

@end
