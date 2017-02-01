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

#import "UIKitComplement.h"

#define kFileMailDB @"~/Library/Mail/Envelope Index"

#define kMailboxInbox @"/INBOX"
#define kMailboxTrash @"/Deleted Messages"

#define kMPEncodingGBK 0x8602
#define kMPEncodingASCII 0x0000
#define kMPEncodingUTF8 0x0001
#define kMPEncodingDefault 0x8602