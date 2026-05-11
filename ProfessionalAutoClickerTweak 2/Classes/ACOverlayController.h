#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACOverlayController : NSObject
+ (instancetype)shared;
- (void)installIfNeeded;
- (void)remove;
@end

NS_ASSUME_NONNULL_END
