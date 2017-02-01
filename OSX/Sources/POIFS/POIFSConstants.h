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

static const UInt64 kPOIFSMagicNumber = 0xE11AB1A1E011CFD0LL;

static const int OFFSET_BAT_COUNT = 0x002C;
static const int OFFSET_XBAT_START = 0x0044;
static const int OFFSET_XBAT_COUNT = 0x0048;
static const int OFFSET_BAT_ARRAY = 0x004C;
static const int OFFSET_SBAT_START = 0x003C;
static const int OFFSET_SBAT_COUNT = 0x0040;
static const int OFFSET_PROPERTIES_START_BLOCK = 0x0030;
static const int OFFSET_PROPERTY_NAME_SIZE = 0x0040;
static const int OFFSET_PROPERTY_TYPE = 0x0042;
static const int OFFSET_PROPERTY_START_BLOCK = 0x0074;
static const int OFFSET_PROPERTY_SIZE = 0x0078;
static const int OFFSET_NEXT_PROPERTY = 0x0048;
static const int OFFSET_PREV_PROPERTY = 0x0044;
static const int OFFSET_FIRST_CHILD = 0x004C;

static const int BAT_ARRAY_MAX = 109;

static const int FLAG_UNUSED = -1;
static const int FLAG_END = -2;
static const int FLAG_SPECIAL = -3;

static const int PROPERTY_TYPE_DIRECTORY = 1;
static const int PROPERTY_TYPE_FILE = 2;
static const int PROPERTY_TYPE_ROOT = 5;

static const int CHAR_SIZE = 1;
static const int SHORT_SIZE = 2;
static const int INT_SIZE = 4;
static const int LONG_SIZE = 8;

static const int SMALL_FILE_SIZE = 4096;
static const int BLOCK_SIZE = 512;
static const int SMALL_BLOCK_SIZE = 64;
static const int PROPERTY_SIZE = 128;
static const int SMALL_BLOCK_COUNT = BLOCK_SIZE / SMALL_BLOCK_SIZE;
static const int INDEX_COUNT = BLOCK_SIZE / INT_SIZE;
static const int PROPERTY_COUNT = BLOCK_SIZE / PROPERTY_SIZE;