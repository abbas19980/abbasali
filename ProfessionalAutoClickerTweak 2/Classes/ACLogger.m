#import "ACLogger.h"

@implementation ACLogger
+ (void)logWithFunction:(const char *)function line:(int)line format:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    NSLog(@"[ProfessionalAutoClicker] %s:%d %@", function, line, message);
}
@end
