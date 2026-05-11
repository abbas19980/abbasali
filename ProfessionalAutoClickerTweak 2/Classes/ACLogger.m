#import "ACLogger.h"

void ACLoggerLog(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    // Log to system
    NSLog(@"%@", message);
}
