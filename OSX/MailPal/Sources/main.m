#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MailPalApp.h"

int main(int argc, char *argv[]) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int ret = UIApplicationMain(argc, argv, [MailPalApp class]);
	[pool release];
	return ret;
}
