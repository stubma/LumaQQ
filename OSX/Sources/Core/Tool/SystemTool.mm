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
#import <IOKit/IOKitLib.h>
#import <IOKit/network/IOEthernetInterface.h>
#import <IOKit/network/IONetworkInterface.h>
#import <IOKit/network/IOEthernetController.h>
#import "SystemTool.h"

@implementation SystemTool

+ (NSString*)getMacSerialNumber {
	NSString* sn = @"";
	io_service_t platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault,
																 IOServiceMatching("IOPlatformExpertDevice"));
	
	if (platformExpert) {
		CFTypeRef serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, 
																		   CFSTR(kIOPlatformSerialNumberKey),
																		   kCFAllocatorDefault, 
																		   0);
		if (serialNumberAsCFString) {
			sn = (NSString*)serialNumberAsCFString;
			[sn autorelease];
		}
		
		IOObjectRelease(platformExpert);
	}
	return sn;
}

+ (void)getMACAddress:(char*)output bufferSize:(int)bufferSize {
	// Make sure the caller provided enough buffer space. Protect against buffer overflow problems.
	if (bufferSize < kIOEthernetAddressSize)
		return;
	
	// Initialize the returned address
    bzero(output, bufferSize);
	
	// find matching dictionary
    CFMutableDictionaryRef matchingDict = IOServiceMatching(kIOEthernetInterfaceClass);
    if (matchingDict != NULL) {
        // Each IONetworkInterface object has a Boolean property with the key kIOPrimaryInterface. Only the
        // primary (built-in) interface has this property set to TRUE.		
        CFMutableDictionaryRef propertyMatchDict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0,
																			 &kCFTypeDictionaryKeyCallBacks,
																			 &kCFTypeDictionaryValueCallBacks);
        if (propertyMatchDict != NULL) {
            CFDictionarySetValue(propertyMatchDict, CFSTR(kIOPrimaryInterface), kCFBooleanTrue); 
            CFDictionarySetValue(matchingDict, CFSTR(kIOPropertyMatchKey), propertyMatchDict);
            CFRelease(propertyMatchDict);
        }
    }
    
	// matching
	io_iterator_t iterator;
    kern_return_t kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, &iterator);    
    if (KERN_SUCCESS != kernResult)
        return;
    
    // IOIteratorNext retains the returned object, so release it when we're done with it.
	io_object_t intfService;
	io_object_t controllerService;
    while (intfService = IOIteratorNext(iterator))
    {
        // IONetworkControllers can't be found directly by the IOServiceGetMatchingServices call, 
        // since they are hardware nubs and do not participate in driver matching. In other words,
        // registerService() is never called on them. So we've found the IONetworkInterface and will 
        // get its parent controller by asking for it specifically.
        // IORegistryEntryGetParentEntry retains the returned object, so release it when we're done with it.
        kernResult = IORegistryEntryGetParentEntry(intfService,
												   kIOServicePlane,
												   &controllerService);
		
        if (KERN_SUCCESS == kernResult) {
            // Retrieve the MAC address property from the I/O Registry in the form of a CFData
           CFTypeRef MACAddressAsCFData = IORegistryEntryCreateCFProperty(controllerService,
																		  CFSTR(kIOMACAddress),
																		  kCFAllocatorDefault,
																		  0);
            if (MACAddressAsCFData) {
                CFShow(MACAddressAsCFData); // for display purposes only; output goes to stderr
                
                // Get the raw bytes of the MAC address from the CFData
                CFDataGetBytes((CFDataRef)MACAddressAsCFData, CFRangeMake(0, kIOEthernetAddressSize), (UInt8*)output);
                CFRelease(MACAddressAsCFData);
            }
			
            // Done with the parent Ethernet controller object so we release it.
            IOObjectRelease(controllerService);
        }
        
        // Done with the Ethernet interface object so we release it.
        IOObjectRelease(intfService);
    }
}

@end
