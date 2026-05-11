#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define ACLog(fmt, ...) [ACLogger logWithFunction:__PRETTY_FUNCTION__ line:__LINE__ format:(fmt), ##__VA_ARGS__]

@interface ACLogger : NSObject
+ (void)logWithFunction:(const char *)function line:(int)line format:(NSString *)format, ... NS_FORMAT_FUNCTION(3,4);
@end

NS_ASSUME_NONNULL_END
