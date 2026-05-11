#import "ACPreferences.h"

NSString * const ACPreferencesChangedNotification = @"ACPreferencesChangedNotification";
static NSString * const kPrefsPath = @"/var/mobile/Library/Preferences/com.example.professionalautoclicker.plist";

@implementation ACPreferences
+ (instancetype)shared {
    static ACPreferences *prefs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ prefs = [ACPreferences new]; [prefs reload]; });
    return prefs;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _enabled = YES;
        _soundEnabled = NO;
        _previewModeOnly = YES;
        _interval = 0.50;
        _pressDuration = 0.08;
        _repeatCount = 0;
        _targetBundleIdentifier = @"";
    }
    return self;
}

- (void)reload {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:kPrefsPath];
    if (![dict isKindOfClass:NSDictionary.class]) return;
    _enabled = dict[@"enabled"] ? [dict[@"enabled"] boolValue] : YES;
    _soundEnabled = dict[@"soundEnabled"] ? [dict[@"soundEnabled"] boolValue] : NO;
    _previewModeOnly = dict[@"previewModeOnly"] ? [dict[@"previewModeOnly"] boolValue] : YES;
    _interval = dict[@"interval"] ? MAX(0.05, [dict[@"interval"] doubleValue]) : 0.50;
    _pressDuration = dict[@"pressDuration"] ? MAX(0.03, [dict[@"pressDuration"] doubleValue]) : 0.08;
    _repeatCount = dict[@"repeatCount"] ? MAX(0, [dict[@"repeatCount"] integerValue]) : 0;
    _targetBundleIdentifier = [dict[@"targetBundleIdentifier"] isKindOfClass:NSString.class] ? dict[@"targetBundleIdentifier"] : @"";
}

- (void)save {
    NSDictionary *dict = @{
        @"enabled": @(_enabled),
        @"soundEnabled": @(_soundEnabled),
        @"previewModeOnly": @(_previewModeOnly),
        @"interval": @(_interval),
        @"pressDuration": @(_pressDuration),
        @"repeatCount": @(_repeatCount),
        @"targetBundleIdentifier": _targetBundleIdentifier ?: @""
    };
    [dict writeToFile:kPrefsPath atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:ACPreferencesChangedNotification object:nil];
}

- (BOOL)shouldLoadForCurrentBundle {
    if (!self.enabled) return NO;
    NSString *bundle = NSBundle.mainBundle.bundleIdentifier ?: @"";
    if (self.targetBundleIdentifier.length == 0) return YES;
    return [bundle isEqualToString:self.targetBundleIdentifier];
}
@end
