#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>
#import "MailPalApp.h"

@implementation MailPalApp

- (void)applicationDidFinishLaunching:(GSEventRef)event {
	// create UI controller
	_uiController = [[UIController alloc] init];
	
	// show account manage
	[_uiController transitTo:kUIUnitMain style:kTransitionStyleUpSlide data:nil];
	
	// show window
	[_uiController show];
}

@end
