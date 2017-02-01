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

#import "MailPal.h"
#import "Constants.h"
#import "LocalizedStringTool.h"
#import "ByteTool.h"
#import "CWIMAPMessage.h"
#import "NSData-Base64.h"
#import "NSData+Extensions.h"

int _loadMailboxes(void* para, int n_column, char** column_value, char** column_name) {
	NSMutableArray* array = (NSMutableArray*)para;
	
	/*
	 CREATE TABLE mailboxes (ROWID INTEGER PRIMARY KEY,
	 url UNIQUE,
	 total_count INTEGER DEFAULT 0,
	 unread_count INTEGER DEFAULT 0,
	 deleted_count INTEGER DEFAULT 0);
	 */	 
	Mailbox* mailbox = [[Mailbox alloc] init];
	int i;
	for(i = 0; i < n_column; i++) {
		switch(i) {
			case 0:
				[mailbox setIdentifier:[[NSString stringWithUTF8String:column_value[i]] intValue]];
				break;
			case 1:
			{
				[mailbox setUrl:[NSString stringWithUTF8String:column_value[i]]];
				
				// get a display name according to mail box path
				NSURL* url = [[NSURL alloc] initWithString:[mailbox url]];
				NSString* path = [url path];
				if([path isEqualToString:kMailboxInbox])
					[mailbox setDisplayName:L(@"Inbox")];
				else if([path isEqualToString:kMailboxTrash])
					[mailbox setDisplayName:L(@"Trash")];
				else
					return 0;
				break;	
			}
			case 2:
				[mailbox setTotalCount:[[NSString stringWithUTF8String:column_value[i]] intValue]];
				break;
			case 3:
				[mailbox setUnreadCount:[[NSString stringWithUTF8String:column_value[i]] intValue]];
				break;
			case 4:
				[mailbox setDeletedCount:[[NSString stringWithUTF8String:column_value[i]] intValue]];
				break;
		}
	}
	[array addObject:mailbox];
	[mailbox release];
	
	return 0;
}

@implementation MailPal

- (id)initWithFile:(NSString*)file {
	self = [super init];
	if(self) {
		_file = [file retain];
		int err = sqlite3_open([_file fileSystemRepresentation], &_sqlite3);
		if(err != SQLITE_OK)
			return nil;
	}
	return self;
}

- (void)dealloc {
	sqlite3_close(_sqlite3);
	[_file release];
	[super dealloc];
}

- (NSArray*)mailboxes {
	NSMutableArray* array = [NSMutableArray array];
	
	char* errMsg = NULL;
	int err = sqlite3_exec(_sqlite3, "select * from mailboxes", _loadMailboxes, array, &errMsg);
	if(err != SQLITE_OK)
		NSLog(@"failed to get mailboxes");
	
	return array;
}

/*
 * returns an array of row ids. if don't need convert, the id should be 0
 */
- (void)_convertSubjects:(Mailbox*)mailbox row:(int*)p_row rowids:(int**)pp_rowids {	
	/*
	 CREATE TABLE messages (ROWID INTEGER PRIMARY KEY AUTOINCREMENT,
	 remote_id INTEGER, sender,
	 subject,
	 _to,
	 cc,
	 date_sent INTEGER,
	 date_received INTEGER,
	 sort_order INTEGER,
	 mailbox INTEGER,
	 remote_mailbox INTEGER,
	 original_mailbox INTEGER,
	 flags INTEGER,
	 read,
	 flagged,
	 deleted,
	 size INTEGER,
	 color,
	 encoding,
	 content_type);	 
	 */
	
	char* errMsg = NULL;
	int err = 0;
	
	// 2147483648 == 0x80000000
	int i, j;
	int row, col;
	char** result = NULL;
	int* rowids = NULL;
	NSString* selectSQL = [NSString stringWithFormat:@"select rowid, subject from messages where mailbox = %d and flags & 2147483648 = 0 and deleted = '0'", [mailbox identifier]];
	err = sqlite3_get_table(_sqlite3, [selectSQL cString], &result, &row, &col, &errMsg);
	require_noerr(err, Dispose);
	
	// create rowid return array
	*pp_rowids = (int*)calloc(row, sizeof(int));
	*p_row = row;
	
	// log
	NSLog(@"converting %d subjects...", row);
	
	// begin transaction
	err = sqlite3_exec(_sqlite3, "begin transaction", NULL, NULL, &errMsg); 
	require_noerr(err, Dispose);
	
	// prepare message update statement
	sqlite3_stmt* updateStmt = NULL;
	err = sqlite3_prepare(_sqlite3, "update messages set subject = ?, flags = flags | 2147483648 where rowid = ?", 0, &updateStmt, NULL);
	require_noerr(err, Commit);
	
	// update every subject
	char* converted = NULL;
	for(i = col, j = 0; j < row; j++, i += 2) {
		// get rowid and subject
		int rowid = atoi(result[i]);
		(*pp_rowids)[j] = rowid;
		char* subject = result[i + 1];
		
		// convert subject to ISO-8859-1
		int dstLength = 0;
		char* dst = NULL;
		[ByteTool convertBytes:subject
						length:strlen(subject)
						  from:"UTF-8"
							to:"ISO-8859-1"
						outBuf:&dst
					 outLength:&dstLength];
		if(dstLength > 0) {
			// the ISO-8859-1 is actually GB18030, so directly convert it to UTF-8
			char* gbk = NULL;
			[ByteTool convertBytes:dst
							length:dstLength
							  from:"GB18030"
								to:"UTF-8"
							outBuf:&gbk
						 outLength:&dstLength];
			if(dstLength > 0)
				converted = gbk;
			else
				NSLog(@"subject at row %d is not GB18030 originally", rowid);
			
			// free dst
			free(dst);
		} else
			NSLog(@"subject at row %d is not saved as UTF-8", rowid);
		
		// set new text which is in utf-8 format or just not converted
		// we still want to update database because we wanna set a flag
		err = sqlite3_bind_text(updateStmt, 1, converted == NULL ? subject : (const char*)converted, -1, SQLITE_STATIC);
		require_noerr(err, Commit);
		
		// set row id
		err = sqlite3_bind_int(updateStmt, 2, rowid);
		require_noerr(err, Commit);
		
		// update subject
		err = sqlite3_step(updateStmt);
		if(err == SQLITE_DONE) {
			// log
			NSLog(@"converted subject at row %d successfully", rowid);
			
			// need reset when err is DONE
			err = sqlite3_reset(updateStmt);
			require_noerr_string(err, Commit, sqlite3_errmsg(_sqlite3));
		} else {
			NSLog(@"failed to update subject at row %d, error message: %s", rowid, sqlite3_errmsg(_sqlite3));
		}
	}
	
Commit:
	// commit transactions
	err = sqlite3_exec(_sqlite3, "commit transaction", NULL, NULL, &errMsg); 
	require_noerr(err, Dispose);
	
Dispose:
	// release convert buffer
	if(converted)
		free(converted);
	
	// free update statement
	if(updateStmt)
		sqlite3_finalize(updateStmt);
	
	// free table
	if(result)
		sqlite3_free_table(result);
}

- (void)_selectSummary:(int*)rowids row:(int)row datas:(char***)ppp_datas {
	/*
	 CREATE TABLE message_data(message_id INTEGER,
	 part,
	 partial,
	 complete,
	 length,
	 data,
	 UNIQUE(message_id, part));	 
	 */
	
	char* errMsg = NULL;
	int err = 0;
	
	// begin transaction
	err = sqlite3_exec(_sqlite3, "begin transaction", NULL, NULL, &errMsg); 
	require_noerr(err, Dispose);
	
	// prepare select statement
	sqlite3_stmt* selectStmt = NULL;
	err = sqlite3_prepare(_sqlite3, "select data from message_data where message_id = ? and part = 'summary'", 0, &selectStmt, NULL);
	require_noerr(err, Commit);
	
	// create return array
	*ppp_datas = (char**)calloc(row, sizeof(char*));
	
	// convert every row
	int i;
	for(i = 0; i < row; i++) {
		// if 0, skip
		if(rowids[i] == 0)
			continue;
		
		// set row id, if fail, skip
		err = sqlite3_bind_int(selectStmt, 1, rowids[i]);
		if(err != SQLITE_OK)
			continue;
		
		// get data
		err = sqlite3_step(selectStmt);
		if(err == SQLITE_ROW || err == SQLITE_DONE) {
			// get data and length
			char* temp = (char*)sqlite3_column_blob(selectStmt, 0);
			int len = sqlite3_column_bytes(selectStmt, 0);
			
			// copy to buffer
			(*ppp_datas)[i] = (char*)calloc(len + 1, sizeof(char));
			memcpy((*ppp_datas)[i], temp, len);
			
			// reset it
			sqlite3_reset(selectStmt);
		} else
			NSLog(@"failed to find data for row id %d, error message: %s", rowids[i], sqlite3_errmsg(_sqlite3));
	}
	
Commit:
	// commit transactions
	err = sqlite3_exec(_sqlite3, "commit transaction", NULL, NULL, &errMsg); 
	require_noerr(err, Dispose);
	
Dispose:
	// free select statement
	if(selectStmt)
		sqlite3_finalize(selectStmt);
}

- (void)_convertSummary:(int*)rowids row:(int)row datas:(char**)pp_datas {
	/*
	 CREATE TABLE message_data(message_id INTEGER,
	 part,
	 partial,
	 complete,
	 length,
	 data,
	 UNIQUE(message_id, part));	 
	 */
	
	char* errMsg = NULL;
	int err = 0;
	
	// begin transaction
	err = sqlite3_exec(_sqlite3, "begin transaction", NULL, NULL, &errMsg); 
	require_noerr(err, Dispose);
	
	// prepare update statement
	sqlite3_stmt* updateStmt = NULL;
	err = sqlite3_prepare(_sqlite3, "update message_data set data = ? where message_id = ? and part = 'summary'", 0, &updateStmt, NULL);
	require_noerr(err, Commit);
	
	// convert every row
	int i;
	for(i = 0; i < row; i++) {
		// if 0, skip
		if(rowids[i] == 0)
			continue;
		
		// check NULL
		if(pp_datas[i] == NULL) 
			continue;
		
		// get rowid and data
		char* converted = NULL;
		
		// convert data to ISO-8859-1
		int dstLength = 0;
		char* dst = NULL;
		[ByteTool convertBytes:pp_datas[i]
						length:strlen(pp_datas[i])
						  from:"UTF-8"
							to:"ISO-8859-1"
						outBuf:&dst
					 outLength:&dstLength];
		if(dstLength > 0) {
			// the ISO-8859-1 is actually GB18030, so directly convert it to UTF-8
			char* gbk = NULL;
			[ByteTool convertBytes:dst
							length:dstLength
							  from:"GB18030"
								to:"UTF-8"
							outBuf:&gbk
						 outLength:&dstLength];
			if(dstLength > 0)
				converted = gbk;
			else
				NSLog(@"summary at row %d is not GB18030 originally", rowids[i]);
			
			// free dst
			free(dst);
		} else
			NSLog(@"summary at row %d is not saved as UTF-8", rowids[i]);
		
		// check NULL
		if(converted == NULL)
			continue;
		
		// set converted data
		err = sqlite3_bind_text(updateStmt, 1, converted, -1, SQLITE_STATIC);
		if(err != SQLITE_OK) {
			free(converted);
			converted = NULL;
			continue;
		}
		
		// set row id
		err = sqlite3_bind_int(updateStmt, 2, rowids[i]);
		if(err != SQLITE_OK) {
			free(converted);
			converted = NULL;
			continue;
		}
		
		// update data
		err = sqlite3_step(updateStmt);
		if(err == SQLITE_DONE) {
			// log
			NSLog(@"converted summary at row %d successfully", rowids[i]);
			
			// need reset when err is DONE
			err = sqlite3_reset(updateStmt);
			if(err != SQLITE_OK) {
				NSLog(@"can't reset update statement, error message: %s", sqlite3_errmsg(_sqlite3));
				break;
			}
		} else {
			// log
			NSLog(@"failed to update summary at row %d, error message: %s", rowids[i], sqlite3_errmsg(_sqlite3));
		}
		
		// free converted buffer
		free(converted);
		converted = NULL;
	}
	
Commit:
	// commit transactions
	err = sqlite3_exec(_sqlite3, "commit transaction", NULL, NULL, &errMsg); 
	require_noerr(err, Dispose);
	
Dispose:
	// free select statement
	if(updateStmt)
		sqlite3_finalize(updateStmt);
}

- (void)_selectData:(int*)rowids row:(int)row datas:(char***)ppp_datas lengths:(int**)pp_lengths {
	/*
	 CREATE TABLE message_data(message_id INTEGER,
	 part,
	 partial,
	 complete,
	 length,
	 data,
	 UNIQUE(message_id, part));	 
	 */
	
	char* errMsg = NULL;
	int err = 0;
	
	// begin transaction
	err = sqlite3_exec(_sqlite3, "begin transaction", NULL, NULL, &errMsg); 
	require_noerr(err, Dispose);
	
	// prepare select statement
	sqlite3_stmt* selectStmt = NULL;
	err = sqlite3_prepare(_sqlite3, "select data from message_data where message_id = ? and complete = 1", 0, &selectStmt, NULL);
	require_noerr(err, Commit);
	
	// create return array
	*ppp_datas = (char**)calloc(row, sizeof(char*));
	*pp_lengths = (int*)calloc(row, sizeof(int));
	
	// convert every row
	int i;
	for(i = 0; i < row; i++) {
		// if 0, skip
		if(rowids[i] == 0)
			continue;
		
		// set row id, if fail, skip
		err = sqlite3_bind_int(selectStmt, 1, rowids[i]);
		if(err != SQLITE_OK)
			continue;
		
		// get data
		err = sqlite3_step(selectStmt);
		if(err == SQLITE_ROW || err == SQLITE_DONE) {
			// get data and length
			char* temp = (char*)sqlite3_column_blob(selectStmt, 0);
			(*pp_lengths)[i] = sqlite3_column_bytes(selectStmt, 0);
			
			// copy to buffer
			(*ppp_datas)[i] = (char*)calloc((*pp_lengths)[i] + 1, sizeof(char));
			memcpy((*ppp_datas)[i], temp, (*pp_lengths)[i]);
			
			// reset it
			sqlite3_reset(selectStmt);
		} else
			NSLog(@"failed to find data for row id %d, error message: %s", rowids[i], sqlite3_errmsg(_sqlite3));
	}
	
Commit:
	// commit transactions
	err = sqlite3_exec(_sqlite3, "commit transaction", NULL, NULL, &errMsg); 
	require_noerr(err, Dispose);
	
Dispose:
	// free select statement
	if(selectStmt)
		sqlite3_finalize(selectStmt);
}

- (void)_convertData:(int*)rowids row:(int)row datas:(char**)pp_datas lengths:(int*)p_lengths {
	/*
	 CREATE TABLE message_data(message_id INTEGER,
	 part,
	 partial,
	 complete,
	 length,
	 data,
	 UNIQUE(message_id, part));	 
	 */
	
	char* errMsg = NULL;
	int err = 0;
	
	// begin transaction
	err = sqlite3_exec(_sqlite3, "begin transaction", NULL, NULL, &errMsg); 
	require_noerr(err, Dispose);
	
	// prepare update statement
	sqlite3_stmt* updateStmt = NULL;
	err = sqlite3_prepare(_sqlite3, "update message_data set length = ?, data = ? where message_id = ? and complete = 1", 0, &updateStmt, NULL);
	require_noerr(err, Commit);
	
	// convert
	int i;
	for(i = 0; i < row; i++) {
		// if 0, skip
		if(rowids[i] == 0)
			continue;
		
		// check NULL
		if(pp_datas[i] == NULL) 
			continue;
		
		// converted buffer
		char* converted = NULL;
		
		// create CWPart from data
		CWIMAPMessage* message = [[CWIMAPMessage alloc] initWithData:[NSData dataWithBytes:pp_datas[i] length:p_lengths[i]]];
		
		// check content
		if([message content] == nil)
			continue;
		
		// convert according to content type
		if([[message content] isKindOfClass:[NSData class]]) {
			// if content is data, convert to GBK then save
			NSData* contentData = (NSData*)[message content];
			
			// pantomime already convert content to proper encoding
			int dstLength = 0;
			char* dst = NULL;
			[ByteTool convertBytes:[contentData bytes]
							length:[contentData length]
							  from:"GB18030"
								to:"UTF-8"
							outBuf:&dst
						 outLength:&dstLength];
			if(dstLength > 0) {
				// check content type transfer encoding, if base64, go ahead
				if([message contentTransferEncoding] == PantomimeEncodingBase64) {
					// get base64 of utf-8 content
					NSData* dstData = [NSData dataWithBytes:dst length:dstLength];
					dstData = [dstData base64Encode];
					
					// find message body start
					int bodyStart = [ByteTool startOfBytes:"\n\n"
												 subLength:2
														in:pp_datas[i]
													length:p_lengths[i]];
					if(bodyStart != -1) {
						// skip \n\n
						bodyStart += 2;
						
						// create buffer
						converted = (char*)calloc(bodyStart + [dstData length], sizeof(char));
						
						// copy
						memcpy(converted, pp_datas[i], bodyStart);
						memcpy(converted + bodyStart, [dstData bytes], [dstData length]); 
						
						// adjust data len
						p_lengths[i] = bodyStart + [dstData length];
					}
				}
				
				// free gbk
				free(dst);
			} else
				NSLog(@"data at row %d is not GB18030 originally", rowids[i]);
		}
		
		// release message
		[message release];
		
		// check converted buffer
		if(converted == NULL)
			continue;
		
		// set length
		err = sqlite3_bind_int(updateStmt, 1, p_lengths[i]);
		if(err != SQLITE_OK) {
			free(converted);
			converted = NULL;
			continue;
		}
		
		// set data
		err = sqlite3_bind_text(updateStmt, 2, converted, p_lengths[i], SQLITE_STATIC);
		if(err != SQLITE_OK) {
			free(converted);
			converted = NULL;
			continue;
		}
		
		// set row id
		err = sqlite3_bind_int(updateStmt, 3, rowids[i]);
		if(err != SQLITE_OK) {
			free(converted);
			converted = NULL;
			continue;
		}
		
		// update data
		err = sqlite3_step(updateStmt);
		if(err == SQLITE_DONE) {
			// log
			NSLog(@"converted data at row %d successfully", rowids[i]);
			
			// need reset when err is DONE
			err = sqlite3_reset(updateStmt);
			if(err != SQLITE_OK) {
				NSLog(@"can't reset update statement, error message: %s", sqlite3_errmsg(_sqlite3));
				break;
			}
		} else {
			// log
			NSLog(@"failed to update data at row %d, error message: %s", rowids[i], sqlite3_errmsg(_sqlite3));
		}
	}

Commit:
	// commit transactions
	err = sqlite3_exec(_sqlite3, "commit transaction", NULL, NULL, &errMsg); 
	require_noerr(err, Dispose);
	
Dispose:
	// free select statement
	if(updateStmt)
		sqlite3_finalize(updateStmt);
}

- (void)convert:(Mailbox*)mailbox {
	// convert subject, collect row ids which need to be converted
	int* rowids = NULL;
	int row;
	[self _convertSubjects:mailbox row:&row rowids:&rowids];
	
	// select summary
	char** datas = NULL;
	[self _selectSummary:rowids row:row datas:&datas];
	
	// convert summary
	[self _convertSummary:rowids row:row datas:datas];
	
	// free datas
	if(datas) {
		int i;
		for(i = 0; i < row; i++) {
			if(datas[i])
				free(datas[i]);
		}
		free(datas);
		datas = NULL;
	}
	
	// select datas
	int* lengths = NULL;
	[self _selectData:rowids row:row datas:&datas lengths:&lengths];
	
	// convert datas
	[self _convertData:rowids row:row datas:datas lengths:lengths];
	
	// free rowids
	if(rowids)
		free(rowids);
	
	// free datas
	if(datas) {
		int i;
		for(i = 0; i < row; i++) {
			if(datas[i])
				free(datas[i]);
		}
		free(datas);
	}
}

@end
