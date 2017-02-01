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

#import "FriendImporter.h"

#ifdef __cplusplus
extern "C" {
#endif

Boolean GetMetadataForFile(void *thisInterface, CFMutableDictionaryRef attributes, CFStringRef contentTypeUTI, CFStringRef pathToFile) {
    Boolean success = NO;
    NSDictionary *tempDict;
    NSAutoreleasePool *pool;
	
	// Don't assume that there is an autorelease pool around the calling of this function.
    pool = [[NSAutoreleasePool alloc] init];
	
	// load the document at the specified location
//    tempDict = [[NSDictionary alloc] initWithContentsOfFile:(NSString *)pathToFile];
//    if (tempDict) {
		// set metadata
		[(NSMutableDictionary*)attributes setObject:@"fangfang" forKey:MD_NICK];
		
		// return YES so that the attributes are imported
		success = YES;
		
//		// release the loaded document
//		[tempDict release];
//    }
	
	// release pool
    [pool release];
    return success;
}

MetadataImporterPluginType* AllocMetadataImporterPluginType(CFUUIDRef inFactoryID) {
    MetadataImporterPluginType* theNewInstance;
	
    theNewInstance = (MetadataImporterPluginType *)malloc(sizeof(MetadataImporterPluginType));
    memset(theNewInstance,0,sizeof(MetadataImporterPluginType));
	
	/* Point to the function table */
    theNewInstance->conduitInterface = &interfaceFtbl;
	
	/*  Retain and keep an open instance refcount for each factory. */
    theNewInstance->factoryID = (CFUUIDRef)CFRetain(inFactoryID);
    CFPlugInAddInstanceForFactory(inFactoryID);
	
	/* This function returns the IUnknown interface so set the refCount to one. */
    theNewInstance->refCount = 1;
    return theNewInstance;
}

void DeallocMetadataImporterPluginType(MetadataImporterPluginType *thisInstance) {
    CFUUIDRef theFactoryID;
	
    theFactoryID = thisInstance->factoryID;
    free(thisInstance);
    if (theFactoryID) {
        CFPlugInRemoveInstanceForFactory(theFactoryID);
        CFRelease(theFactoryID);
    }
}

HRESULT MetadataImporterQueryInterface(void *thisInstance,REFIID iid,LPVOID *ppv) {
    CFUUIDRef interfaceID;
	
    interfaceID = CFUUIDCreateFromUUIDBytes(kCFAllocatorDefault,iid);
	
    if (CFEqual(interfaceID,kMDImporterInterfaceID) || CFEqual(interfaceID,IUnknownUUID)) {
        ((MetadataImporterPluginType*)thisInstance)->conduitInterface->AddRef(thisInstance);
        *ppv = thisInstance;
        CFRelease(interfaceID);
        return S_OK;
    } else {
		*ppv = NULL;
		CFRelease(interfaceID);
		return E_NOINTERFACE;
    }
}

ULONG MetadataImporterPluginAddRef(void *thisInstance) {
    ((MetadataImporterPluginType *)thisInstance )->refCount += 1;
    return ((MetadataImporterPluginType*) thisInstance)->refCount;
}

ULONG MetadataImporterPluginRelease(void *thisInstance) {
    ((MetadataImporterPluginType*)thisInstance)->refCount -= 1;
    if (((MetadataImporterPluginType*)thisInstance)->refCount == 0) {
        DeallocMetadataImporterPluginType((MetadataImporterPluginType*)thisInstance);
        return 0;
    } else {
        return ((MetadataImporterPluginType*)thisInstance)->refCount;
    }
}

void* MetadataImporterPluginFactory(CFAllocatorRef allocator,CFUUIDRef typeID) {
    MetadataImporterPluginType *result;
    CFUUIDRef                 uuid;

    if (CFEqual(typeID,kMDImporterTypeID)) {
        uuid = CFUUIDCreateFromString(kCFAllocatorDefault,CFSTR(PLUGIN_ID));
        result = AllocMetadataImporterPluginType(uuid);
        CFRelease(uuid);
        return result;
    }

    return NULL;
}

#ifdef __cplusplus
}
#endif