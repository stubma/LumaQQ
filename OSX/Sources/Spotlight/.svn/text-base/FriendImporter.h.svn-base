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

#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFPlugInCOM.h>
#import <CoreServices/CoreServices.h>
#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif
	
// plugin id
#define PLUGIN_ID "D3BCAA73-7228-496A-B85C-1814BC34303B"
	
// metadata
#define MD_NICK @"edu_tsinghua_LumaQQ_friendlock_nick"
	
// plugin struct
typedef struct tagMetadataImporterPluginType {
	MDImporterInterfaceStruct*	conduitInterface;
	CFUUIDRef					factoryID;
	UInt32						refCount;
} MetadataImporterPluginType;

// get metadata
Boolean GetMetadataForFile(void *thisInterface, CFMutableDictionaryRef attributes, CFStringRef contentTypeUTI, CFStringRef pathToFile);
	
// alloc/dealloc plugin
MetadataImporterPluginType* AllocMetadataImporterPluginType(CFUUIDRef inFactoryID);
void DeallocMetadataImporterPluginType(MetadataImporterPluginType *thisInstance);

// COM
HRESULT MetadataImporterQueryInterface(void *thisInstance,REFIID iid,LPVOID *ppv);
void* MetadataImporterPluginFactory(CFAllocatorRef allocator,CFUUIDRef typeID);
ULONG MetadataImporterPluginAddRef(void *thisInstance);
ULONG MetadataImporterPluginRelease(void *thisInstance);

// virtual table
static MDImporterInterfaceStruct interfaceFtbl = {
    NULL,
    MetadataImporterQueryInterface,
    MetadataImporterPluginAddRef,
    MetadataImporterPluginRelease,
    GetMetadataForFile
};

#ifdef __cplusplus
}
#endif