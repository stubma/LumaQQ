#include <IOKit/storage/IOBlockStorageDriver.h>

class edu_tsinghua_lumaqq_QDiskDriver : public IOBlockStorageDriver {
	OSDeclareDefaultStructors(edu_tsinghua_lumaqq_QDiskDriver)
	
private:
	IOMedia* _fakeMedia;
	
public:	
	virtual bool init(OSDictionary* propTable);
	virtual bool start(IOService* provider);
	virtual void stop(IOService*  provider);
    virtual IOService* probe(IOService*	provider, SInt32* score);
	virtual void free();
	
protected:
	virtual IOReturn mediaStateHasChanged(IOMediaState state); 
	virtual IOReturn acceptNewMedia();
	virtual IOReturn decommissionMedia(bool forcible); 
};
