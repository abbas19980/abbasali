#ifndef ACOverlayController_h
#define ACOverlayController_h

#import <UIKit/UIKit.h>
#import "ACFloatingButton.h"
#import "ACMenuView.h"
#import "ACClickerEngine.h"

@interface ACOverlayController : NSObject

+ (instancetype)shared;

- (void)installIfNeeded;
- (void)uninstall;

#endif /* ACOverlayController_h */
