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

#import "SoundTool.h"
#import <AvailabilityMacros.h>
#import <AudioToolbox/AudioToolbox.h>
#import "PreferenceTool.h"
#import "Constants.h"
#import "FileTool.h"

#define kNumberBuffers 3
typedef struct AQCallbackData {
	AudioStreamBasicDescription mDataFormat; 
	AudioQueueRef mQueue; 
	AudioQueueBufferRef mBuffers[kNumberBuffers]; 
	AudioFileID mAudioFile; 
	UInt32 bufferByteSize; 
	SInt64 mCurrentPacket;
	UInt32 mNumPacketsToRead; 
	AudioStreamPacketDescription *mPacketDescs;
	BOOL mIsRunning;
} AQCallbackData;
AQCallbackData aqData;

extern UInt32 gMyQQ;

static BOOL s_playing = NO;
static NSMutableArray* s_fileQueue;

#pragma mark -
#pragma mark audio queue service callback

static void AQCallback(void* callbackData, AudioQueueRef aqRef, AudioQueueBufferRef aqBufferRef) {
	// check running flag
	AQCallbackData* pAqData = (AQCallbackData*)callbackData;
	if(pAqData->mIsRunning == NO) 
		return;
	
	// read packets
	UInt32 numBytesReadFromFile;
	UInt32 numPackets = pAqData->mNumPacketsToRead;
	AudioFileReadPackets(pAqData->mAudioFile,
						 NO,
						 &numBytesReadFromFile,
						 pAqData->mPacketDescs,
						 pAqData->mCurrentPacket,
						 &numPackets,
						 aqBufferRef->mAudioData);
	
	// enqueue or stop
	if(numPackets > 0) {
		aqBufferRef->mAudioDataByteSize = numBytesReadFromFile;
		AudioQueueEnqueueBuffer(pAqData->mQueue,
								aqBufferRef,
								(pAqData->mPacketDescs ? numPackets : 0),
								pAqData->mPacketDescs);
		pAqData->mCurrentPacket += numPackets;
	} else if(pAqData->mIsRunning) {
		AudioQueueStop(pAqData->mQueue, NO);
		pAqData->mIsRunning = NO;
	}
}

#pragma mark -
#pragma mark helper method

static void DeriveBufferSize(AudioStreamBasicDescription ASBDesc, UInt32 maxPacketSize, Float64 seconds, UInt32* outBufferSize, UInt32* outNumPacketsToRead) {
	static const int maxBufferSize = 0x50000; 
	static const int minBufferSize = 0x4000;
	if(ASBDesc.mFramesPerPacket != 0) {
		Float64 numPacketsForTime = ASBDesc.mSampleRate / ASBDesc.mFramesPerPacket * seconds;
		*outBufferSize = numPacketsForTime * maxPacketSize;
	} else {
		*outBufferSize = maxBufferSize > maxPacketSize ? maxBufferSize : maxPacketSize;
	}
	if(*outBufferSize > maxBufferSize && *outBufferSize > maxPacketSize)
		*outBufferSize = maxBufferSize;
	else if(*outBufferSize < minBufferSize)
		*outBufferSize = minBufferSize;
	*outNumPacketsToRead = *outBufferSize / maxPacketSize;
}

#pragma mark -
#pragma mark sound tool implementation

@implementation SoundTool

+ (void)initialize {
	s_fileQueue = [[NSMutableArray array] retain];
}

+ (void)_enqueue:(NSString*)name {
	@synchronized(self) {
		if([s_fileQueue count] > 0) {
			NSString* last = [s_fileQueue objectAtIndex:([s_fileQueue count] - 1)];
			if(![name isEqualToString:last])
				[s_fileQueue addObject:name];
		} else {
			[s_fileQueue addObject:name];
		}
	}
}

+ (void)_play {
	NSString* name = nil;
	@synchronized(self) {
		if(s_playing)
			return;
		else {
			if([s_fileQueue count] == 0)
				return;
			name = [s_fileQueue objectAtIndex:0];
			s_playing = YES;
			aqData.mIsRunning = YES;
		}
	}
	
	// start to read
	[NSThread detachNewThreadSelector:@selector(_playInBackground:)
							 toTarget:self
						   withObject:name];
}

+ (void)playUserMessageSound {
	if([UIHardware ringerState] == kRingerStateOff)
		return;
	
	PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
	NSString* scheme = [tool stringValue:kPreferenceKeySoundScheme];
	NSString* path = [FileTool getSoundFilePath:@"message" scheme:scheme];
	if(path == nil)
		return;
	
	[SoundTool _enqueue:path];
	[SoundTool _play];
}

+ (void)playSystemMessageSound {
	if([UIHardware ringerState] == kRingerStateOff)
		return;
	
	PreferenceTool* tool = [PreferenceTool toolWithQQ:gMyQQ];
	NSString* scheme = [tool stringValue:kPreferenceKeySoundScheme];
	NSString* path = [FileTool getSoundFilePath:@"system" scheme:scheme];
	if(path == nil)
		return;
	
	[SoundTool _enqueue:path];
	[SoundTool _play];
}

+ (void)_playInBackground:(id)param {
	NSAutoreleasePool* releasePool = [[NSAutoreleasePool alloc] init];
	
	// get file url and open it
	NSURL* url = [NSURL URLWithString:param];
	OSStatus result = AudioFileOpenURL((CFURLRef)url, 
									   fsRdPerm, 
									   0, 
									   &aqData.mAudioFile);
	if(result != noErr)
		goto PlayNext;
	
	// get data format
	UInt32 dataFormatSize = sizeof(aqData.mDataFormat);
	result = AudioFileGetProperty(aqData.mAudioFile,
								  kAudioFilePropertyDataFormat,
								  &dataFormatSize,
								  &aqData.mDataFormat);
	if(result != noErr)
		goto CloseFile;
	
	// create audio queue
	result = AudioQueueNewOutput(&aqData.mDataFormat,
								 AQCallback,
								 &aqData,
								 CFRunLoopGetCurrent(),
								 kCFRunLoopCommonModes,
								 0,
								 &aqData.mQueue);
	if(result != noErr)
		goto CloseFile;
	
	// get max packet size
	UInt32 maxPacketSize = 0;
	UInt32 propertySize = sizeof(maxPacketSize);
	result = AudioFileGetProperty(aqData.mAudioFile,
								  kAudioFilePropertyPacketSizeUpperBound,
								  &propertySize,
								  &maxPacketSize);
	if(result != noErr)
		goto DisposeQueue;
	
	// determine proper buffer size
	DeriveBufferSize(aqData.mDataFormat,
					 maxPacketSize,
					 0.5,
					 &aqData.bufferByteSize,
					 &aqData.mNumPacketsToRead);
	if(result != noErr)
		goto DisposeQueue;
	
	// set packet desc
	BOOL bVBR = aqData.mDataFormat.mBytesPerPacket == 0 || aqData.mDataFormat.mFramesPerPacket == 0;
	if(bVBR) {
		aqData.mPacketDescs = (AudioStreamPacketDescription*)malloc(aqData.mNumPacketsToRead * sizeof(AudioStreamPacketDescription));
	} else {
		aqData.mPacketDescs = NULL;
	}
	
	// allocate buffer	
	int i;
	aqData.mCurrentPacket = 0;
	for(i = 0; i < kNumberBuffers; ++i) {
		result = AudioQueueAllocateBuffer(aqData.mQueue,
										  aqData.bufferByteSize,
										  &aqData.mBuffers[i]);
		if(result != noErr)
			goto DisposeQueue;
		
		AQCallback(&aqData,
				   aqData.mQueue,
				   aqData.mBuffers[i]);
	}
	
	// set volumn to max
	Float32 gain = 1.0; 
	result = AudioQueueSetParameter(aqData.mQueue,
									kAudioQueueParam_Volume, 
									gain);
	if(result != noErr)
		goto DisposeQueue;
	
	// start
	result = AudioQueueStart(aqData.mQueue, NULL);
	if(result != noErr)
		goto DisposeQueue;
	do {
		CFRunLoopRunInMode(kCFRunLoopDefaultMode, 
						   0.25, 
						   NO);
	} while(aqData.mIsRunning);
	CFRunLoopRunInMode(kCFRunLoopDefaultMode,
					   0.5,
					   NO);
	
DisposeQueue:
	// dispose audio queue	
	AudioQueueDispose(aqData.mQueue, YES);
	
CloseFile:
	// close file
	AudioFileClose(aqData.mAudioFile);
	
PlayNext:
	@synchronized(self) {
		// set flag
		s_playing = NO;
		aqData.mIsRunning = NO;
		
		// play next
		[s_fileQueue removeObjectAtIndex:0];
		if([s_fileQueue count] > 0)
			[SoundTool _play];
	}
	
	[releasePool release];
}

@end
