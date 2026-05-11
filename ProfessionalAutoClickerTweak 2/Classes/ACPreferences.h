#ifndef ACPreferences_h
#define ACPreferences_h

#import <Foundation/Foundation.h>

@interface ACPreferences : NSObject

+ (instancetype)shared;

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL previewMode;
@property (nonatomic, strong) NSString *targetBundleIdentifier;
@property (nonatomic, assign) CGFloat intervalSeconds;
@property (nonatomic, assign) NSInteger repeatCount;

- (void)reload;
- (void)save;
- (BOOL)shouldActivateForBundle:(NSString *)bundleID;

#endif /* ACPreferences_h */
