/*
 * MailPal - A Garbage Code Terminator for iPhone Mail
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
#import <sqlite3.h>
#import "Mailbox.h"

@interface MailPal : NSObject {
	NSString* _file;
	sqlite3* _sqlite3;
}

- (id)initWithFile:(NSString*)file;
- (NSArray*)mailboxes;
- (void)convert:(Mailbox*)mailbox;
- (void)_convertSubjects:(Mailbox*)mailbox row:(int*)row rowids:(int**)rowids;
- (void)_selectSummary:(int*)rowids row:(int)row datas:(char***)ppp_datas;
- (void)_convertSummary:(int*)rowids row:(int)row datas:(char**)pp_datas;
- (void)_selectData:(int*)rowids row:(int)row datas:(char***)ppp_datas lengths:(int**)pp_lengths;
- (void)_convertData:(int*)rowids row:(int)row datas:(char**)pp_datas lengths:(int*)p_lengths;

@end
