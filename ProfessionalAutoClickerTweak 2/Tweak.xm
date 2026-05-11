#import <UIKit/UIKit.h>
#import "Classes/ACOverlayController.h"
#import "Classes/ACPreferences.h"
#import "Classes/ACLogger.h"

static void ACInstallOverlayWhenReady(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!UIApplication.sharedApplication) return;
        [ACPreferences.shared reload];
        [[ACOverlayController shared] installIfNeeded];
    });
}

%hook UIApplication
- (void)applicationDidBecomeActive:(UIApplication *)application {
    %orig;
    ACInstallOverlayWhenReady();
}
%end

%ctor {
    @autoreleasepool {
        ACLog(@"Loaded in bundle: %@", NSBundle.mainBundle.bundleIdentifier);
        ACInstallOverlayWhenReady();
    }
}
