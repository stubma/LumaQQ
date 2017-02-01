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

#import <Carbon/Carbon.h>
#import "KeyTool.h"
#import "Constants.h"

@implementation KeyTool

static struct {
	short kchrID;
	char KCHRname[256];
	UInt32 transtable[256];
} keyTable;

typedef struct _tagUnmappedKey {
	NSString* keyString;
	UInt32 keyCode;
} UnmappedKey;

static UnmappedKey unmappedKeyTable[] = {
	{ @"F1", 122 },
	{ @"F2", 120 },
	{ @"F3", 99 },
	{ @"F4", 118 },
	{ @"F5", 96 },
	{ @"F6", 97 },
	{ @"F7", 98 },
	{ @"F8", 100 },
	{ @"F9", 101 },
	{ @"F10", 109 },
	{ @"F11", 103 },
	{ @"F12", 111 },
	{ @"F13", 105 },
	{ @"F14", 107 },
	{ @"F15", 113 },
	{ @"Up Arrow", 122 },
	{ @"Down Arrow", 122 },
	{ @"Left Arrow", 122 },
	{ @"Right Arrow", 122 }
};

static int UNMAPPEDKEY_SIZE = sizeof(unmappedKeyTable) / sizeof(UnmappedKey);

+ (void)initialize {
	[self initAscii2KeyCodeTable];
}

+ (UniChar)string2KeyChar:(NSString*)keyString {
	// get unichar buffer
	int length = [keyString length];
	UniChar* buffer = new UniChar[length];
	[keyString getCharacters:buffer];
	
	// find non-control character
	int start = 0;
	for(; start < length;) {
		if(buffer[start] == kLQUnicodeCommandCharacter ||
		   buffer[start] == kLQUnicodeOptionCharacter ||
		   buffer[start] == kLQUnicodeControlCharacter ||
		   buffer[start] == kLQUnicodeShiftCharacter)
			start++;
		else
			break;
	}
	if(start == length)
		return 0;
	
	// check
	UniChar ret = 0;
	switch(buffer[start]) {
		case kLQUnicodeSpaceCharacter:
			ret =  ' ';
			break;
		case kLQUnicodeEnterCharacter:
			ret = NSCarriageReturnCharacter;
			break;
		case kLQUnicodeEscapeCharacter:
			ret = 27;
			break;
		case kLQUnicodeUpArrow:
			ret = NSUpArrowFunctionKey;
			break;
		case kLQUnicodeDownArrow:
			ret = NSDownArrowFunctionKey;
			break;
		case kLQUnicodeLeftArrow:
			ret = NSLeftArrowFunctionKey;
			break;
		case kLQUnicodeRightArrow:
			ret = NSRightArrowFunctionKey;
			break;
		case 'F':
			if(start == length - 1)
				ret = 'F';
			else {
				int fn = [[NSString stringWithCharacters:(buffer + start + 1) length:(length - start - 1)] intValue];
				ret = NSF1FunctionKey + fn - 1;
			}
			break;
		default:
			ret = buffer[start];
			break;
	}
	
	delete buffer;
	return ret;
}

+ (NSString*)key2String:(unsigned int)modifier character:(UniChar)keyChar {
	// check character
	if([self acceptable:keyChar]) {	
		// check modifiers
		int length = 0;
		UniChar chars[7];			
		
		if((modifier & NSCommandKeyMask) != 0)
			chars[length++] = kLQUnicodeCommandCharacter;
		if((modifier & NSAlternateKeyMask) != 0)
			chars[length++] = kLQUnicodeOptionCharacter;
		if((modifier & NSControlKeyMask) != 0)
			chars[length++] = kLQUnicodeControlCharacter;
		if((modifier & NSShiftKeyMask) != 0)
			chars[length++] = kLQUnicodeShiftCharacter;
		
		switch(keyChar) {
			case ' ':
				chars[length++] = kLQUnicodeSpaceCharacter;
				break;
			case NSCarriageReturnCharacter:
				chars[length++] = kLQUnicodeEnterCharacter;
				break;
			case 27: // escape
				chars[length++] = kLQUnicodeEscapeCharacter;
				break;
			case NSUpArrowFunctionKey:
				chars[length++] = kLQUnicodeUpArrow;
				break;
			case NSDownArrowFunctionKey:
				chars[length++] = kLQUnicodeDownArrow;
				break;
			case NSLeftArrowFunctionKey:
				chars[length++] = kLQUnicodeLeftArrow;
				break;
			case NSRightArrowFunctionKey:
				chars[length++] = kLQUnicodeRightArrow;
				break;
			case NSF1FunctionKey:
			case NSF2FunctionKey:
			case NSF3FunctionKey:
			case NSF4FunctionKey:
			case NSF5FunctionKey:
			case NSF6FunctionKey:
			case NSF7FunctionKey:
			case NSF8FunctionKey:
			case NSF9FunctionKey:
			case NSF10FunctionKey:
			case NSF11FunctionKey:
			case NSF12FunctionKey:
			case NSF13FunctionKey:
			case NSF14FunctionKey:
			case NSF15FunctionKey:
			case NSF16FunctionKey:
			case NSF17FunctionKey:
			case NSF18FunctionKey:
			case NSF19FunctionKey:
			case NSF20FunctionKey:
			case NSF21FunctionKey:
			case NSF22FunctionKey:
			case NSF23FunctionKey:
			case NSF24FunctionKey:
			case NSF25FunctionKey:
			case NSF26FunctionKey:
			case NSF27FunctionKey:
			case NSF28FunctionKey:
			case NSF29FunctionKey:
			case NSF30FunctionKey:
			case NSF31FunctionKey:
			case NSF32FunctionKey:
			case NSF33FunctionKey:
			case NSF34FunctionKey:
			case NSF35FunctionKey:
				int index = keyChar - NSF1FunctionKey + 1;
				NSString* indexStr = [NSString stringWithFormat:@"%u", index];
				chars[length++] = 'F';
				for(int i = 0; i < [indexStr length]; i++)
					chars[length++] = [indexStr characterAtIndex:i];
					break;
			default:
				chars[length++] = keyChar;
				break;
		}
		
		return [NSString stringWithCharacters:chars length:length];
	}
	
	return kStringEmpty;
}

+ (NSString*)key2String:(NSEvent*)theEvent {
	NSString* charString = [theEvent charactersIgnoringModifiers];
	if([charString length] >= 1) {		
		charString = [charString uppercaseString];
		UniChar keyChar = [charString characterAtIndex:0];
		
		return [KeyTool key2String:[theEvent modifierFlags] character:keyChar];
	}
	
	return kStringEmpty;
}

+ (BOOL)acceptable:(UniChar)keyChar {
	if([[NSCharacterSet alphanumericCharacterSet] characterIsMember:keyChar])
		return YES;
	
	if(keyChar >= NSUpArrowFunctionKey && keyChar <= NSF35FunctionKey)
		return YES;
	
	if(keyChar == ' ' || keyChar == NSCarriageReturnCharacter || keyChar == 27 /* escape */)
	   return YES;
	   
	return NO;
}

+ (UInt32)string2Modifier:(NSString*)keyString {
	UInt32 mask = 0;
	int length = [keyString length];
	for(int i = 0; i < length; i++) {
		switch([keyString characterAtIndex:i]) {
			case kLQUnicodeCommandCharacter:
				mask |= NSCommandKeyMask;
				break;
			case kLQUnicodeShiftCharacter:
				mask |= NSShiftKeyMask;
				break;
			case kLQUnicodeOptionCharacter:
				mask |= NSAlternateKeyMask;
				break;
			case kLQUnicodeControlCharacter:
				mask |= NSControlKeyMask;
				break;
		}
	}
	return mask;
}

+ (UInt32)cocoaModifier2CarbonModifier:(UInt32)modifier {
	UInt32 mask = 0;
	if((modifier & NSCommandKeyMask) != 0)
		mask |= cmdKey;
	if((modifier & NSShiftKeyMask) != 0)
		mask |= shiftKey;
	if((modifier & NSAlternateKeyMask) != 0)
		mask |= optionKey;
	if((modifier & NSControlKeyMask) != 0)
		mask |= controlKey;
	return mask;
}

+ (UInt32)string2KeyCode:(NSString*)keyString {
	// get character string
	BOOL bFlag = NO;
	NSString* charString = nil;
	int length = [keyString length];
	for(int i = 0; i < length; i++) {
		switch([keyString characterAtIndex:i]) {
			case kLQUnicodeCommandCharacter:
			case kLQUnicodeShiftCharacter:
			case kLQUnicodeOptionCharacter:
			case kLQUnicodeControlCharacter:
				break;
			default:
				bFlag = YES;
				break;
		}
		
		if(bFlag) {
			charString = [keyString substringFromIndex:i];
			break;
		}
	}
	
	// validate
	if(charString == nil)
		return 0;
	
	// map ascii
	if([charString length] == 1) {
		charString = [charString lowercaseString];
		UniChar keyChar = [charString characterAtIndex:0];
		switch(keyChar) {
			case kLQUnicodeEnterCharacter:
				keyChar = NSCarriageReturnCharacter;
				break;
			case kLQUnicodeSpaceCharacter:
				keyChar = ' ';
				break;
			case kLQUnicodeEscapeCharacter:
				keyChar = 27;
				break;
			case kLQUnicodeUpArrow:
				charString = @"Up Arrow";
				break;
			case kLQUnicodeDownArrow:
				charString = @"Down Arrow";
				break;
			case kLQUnicodeLeftArrow:
				charString = @"Left Arrow";
				break;
			case kLQUnicodeRightArrow:
				charString = @"Right Arrow";
				break;
		}
		
		if((keyChar & 0x0000FF00) == 0) {
			UInt32 keyCode = [self ascii2KeyCode:keyChar];
			if(keyCode != -1)
				return keyCode;
		}
	}
	
	// map special key
	for(int i = 0; i < UNMAPPEDKEY_SIZE; i++) {
		if([charString isEqualToString:unmappedKeyTable[i].keyString]) {
			return unmappedKeyTable[i].keyCode;
		}
	}
	
	return -1;
}

+ (OSStatus)initAscii2KeyCodeTable {
	unsigned char *theCurrentKCHR, *ithKeyTable;
	Handle theKCHRRsrc;
	int kTableCountOffset = 4;
	int kFirstTableOffset = 260;
	int kTableSize = 256;
	for (int i = 0; i < kTableSize; i++) 
		keyTable.transtable[i] = -1;
	
	//find the current kchr resource ID
	keyTable.kchrID = (short) GetScriptVariable(smCurrentScript, smScriptKeys);
	
	//get the current KCHR resource
	theKCHRRsrc = GetResource('KCHR', keyTable.kchrID);
	
	// validate
	if(theKCHRRsrc == NULL)
		return resNotFound;
		
	HLock(theKCHRRsrc);
	theCurrentKCHR = (unsigned char*)*theKCHRRsrc;
	short count = *(short*)(theCurrentKCHR + kTableCountOffset);
	for(int i = 0; i < count; i++){
		ithKeyTable = theCurrentKCHR + kFirstTableOffset + (i * kTableSize);
		for(int j = 0; j < kTableSize; j++) {
		   if(keyTable.transtable[ithKeyTable[j]] == -1)
			   keyTable.transtable[ithKeyTable[j]] = j;
		}
	}
	HUnlock(theKCHRRsrc);
	
	return noErr;		   
}

+ (UInt32)ascii2KeyCode:(unsigned char)asciiCode {
	return keyTable.transtable[asciiCode];
}

@end
