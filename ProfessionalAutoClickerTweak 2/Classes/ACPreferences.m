#import "ACPreferences.h"
#import "ACLogger.h"

static NSString *const kPrefsFile = @"/var/mobile/Library/Preferences/com.example.professionalautoclicker.plist";

@implementation ACPreferences

+ (instancetype)shared {
    static ACPreferences *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ACPreferences alloc] init];
        [instance reload];
    });
    return instance;
}

- (void)reload {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kPrefsFile];
    
    _enabled = [prefs[@"enabled"] boolValue] ?: YES;
    _previewMode = [prefs[@"previewMode"] boolValue] ?: YES;
    _targetBundleIdentifier = prefs[@"targetBundleIdentifier"] ?: @"";
    _intervalSeconds = [prefs[@"intervalSeconds"] floatValue] ?: 1.0f;
    _repeatCount = [prefs[@"repeatCount"] integerValue] ?: 10;
    
    ACLog(@"Preferences reloaded - enabled:%d, preview:%d", _enabled, _previewMode);
}

- (void)save {
    NSDictionary *prefs = @{
        @"enabled": @(_enabled),
        @"previewMode": @(_previewMode),
        @"targetBundleIdentifier": _targetBundleIdentifier ?: @"",
        @"intervalSeconds": @(_intervalSeconds),
        @"repeatCount": @(_repeatCount)
    };
    
    [prefs writeToFile:kPrefsFile atomically:YES];
    ACLog(@"Preferences saved");
}

- (BOOL)shouldActivateForBundle:(NSString *)bundleID {
    if (!_enabled) return NO;
    if ([_targetBundleIdentifier isEqualToString:@""]) return YES;
    return [bundleID isEqualToString:_targetBundleIdentifier];
}

@end
