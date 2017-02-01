#include <IOKit/IOLib.h>
#import <IOKit/storage/IOBlockStorageDevice.h>
#include "QDiskDriver.h"

// Define my superclass and myself
#define super IOBlockStorageDriver
#define self edu_tsinghua_lumaqq_QDiskDriver

OSDefineMetaClassAndStructors(self, IOBlockStorageDriver)

bool self::init(OSDictionary *dict) {
    bool res = super::init(dict);
    IOLog("Initializing: %d\n", res);
    return res;
}

bool self::start(IOService* provider) {
	IOLog("Starting\n");
	
    // Prepare the block storage driver for operation.
    if (handleStart(provider) == false)
    {
		IOLog("handleStart failed\n");
        provider->close(this);
        return false;
    }
	
    // Initiate the poller mechanism if it is required.
    if (isMediaEjectable() && isMediaPollRequired() && !isMediaPollExpensive())
    {
        lockForArbitration();        // (disable opens/closes; a recursive lock)
		
        if (!isOpen() && !isInactive())
            schedulePoller();        // (schedule the poller, increments retain)
		
        unlockForArbitration();       // (enable opens/closes; a recursive lock)
    }
	
    // Register this object so it can be found via notification requests. It is
    // not being registered to have I/O Kit attempt to have drivers match on it,
    // which is the reason most other services are registered -- that's not the
    // intention of this registerService call.
    registerService();
	
    return true;
}

void self::stop(IOService* provider) {
    IOLog("Stopping\n");
    super::stop(provider);
}

IOService* self::probe(IOService* provider, SInt32* score) {
	IOLog("Probing\n");
	
	// get ATA device
	IOBlockStorageDevice* ataDevice = OSDynamicCast(IOBlockStorageDevice, provider);
	if(ataDevice != NULL) {
		*score = 10000;
		return this;
	}
	
	return super::probe(provider, score);
}

void self::free() {
	IOLog("Freeing\n");
	super::free();
}

IOReturn self::mediaStateHasChanged(IOMediaState state) {
	IOReturn result;
	
	if (state == kIOMediaStateOnline) {
		IOLog("Media is online\n");
		
		lockForArbitration();
				
		result = acceptNewMedia();
		if(result != kIOReturnSuccess)
			IOLog("Create media failed\n");
		
		unlockForArbitration();
	} else {
		IOLog("Media is offline\n");
		
		lockForArbitration();
		
		result = decommissionMedia(true);
		if(result != kIOReturnSuccess)
			IOLog("Create media failed\n");
		
		unlockForArbitration();
	}
	
	return result;
}

IOReturn self::acceptNewMedia() {	
	_fakeMedia = new IOMedia;
	bool result = _fakeMedia->init(0, 
								   1024,
								   512, 
								   true, 
								   true, 
								   true, 
								   "");
	
	if(result) {
		IOLog("Media created\n");
		
		_fakeMedia->setName("QDisk");
		OSBoolean* leaf = OSBoolean::withBoolean(false);
		_fakeMedia->setProperty(kIOMediaLeafKey, leaf);		
		OSBoolean* ejectable = OSBoolean::withBoolean(false);
		_fakeMedia->setProperty(kIOMediaEjectableKey, ejectable);		
		OSBoolean* removable = OSBoolean::withBoolean(false);
		_fakeMedia->setProperty(kIOMediaRemovableKey, removable);	
		OSString* contentMask = OSString::withCString("GUID_partition_scheme");
		_fakeMedia->setProperty(kIOMediaContentMaskKey, contentMask);
		
		result = _fakeMedia->attach(this);
		if(result) {
			IOLog("Media attached\n");
			
			_fakeMedia->registerService();
			return kIOReturnSuccess;
		} else {
			_fakeMedia->release();
			_fakeMedia = NULL;
			return kIOReturnNoMemory;
		}
	} else {
		_fakeMedia->release();
		_fakeMedia = NULL;
		return kIOReturnBadArgument;
	}
}

IOReturn self::decommissionMedia(bool forcible) {
	if(_fakeMedia) {
		if(_fakeMedia->terminate(forcible ? kIOServiceRequired : 0) || forcible) {
			_fakeMedia->release();
			_fakeMedia = NULL;
			return kIOReturnSuccess;
		} else
			return kIOReturnBusy;
	} else
		return kIOReturnNoMedia;
}