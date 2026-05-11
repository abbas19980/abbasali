#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ACPreferencesChangedNotification;

@interface ACPreferences : NSObject
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL soundEnabled;
@property (nonatomic, assign) BOOL previewModeOnly;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign) NSTimeInterval pressDuration;
@property (nonatomic, assign) NSInteger repeatCount;
@property (nonatomic, copy) NSString *targetBundleIdentifier;

+ (instancetype)shared;
- (void)reload;
- (void)save;
- (BOOL)shouldLoadForCurrentBundle;
@end

NS_ASSUME_NONNULL_END
