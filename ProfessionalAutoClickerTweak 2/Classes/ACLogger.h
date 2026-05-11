#ifndef ACLogger_h
#define ACLogger_h

#import <Foundation/Foundation.h>

// Macro for safe logging
#define ACLog(fmt, ...) ACLoggerLog(@"[AC] " fmt, ##__VA_ARGS__)

void ACLoggerLog(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);

#endif /* ACLogger_h */