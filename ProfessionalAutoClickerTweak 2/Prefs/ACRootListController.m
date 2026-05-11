#import "ACRootListController.h"
#import <Preferences/PSSpecifier.h>

static NSString * const kPrefsPath = @"/var/mobile/Library/Preferences/com.example.professionalautoclicker.plist";

@implementation ACRootListController
- (NSArray *)specifiers {
    if (!_specifiers) {
        NSMutableArray *items = [NSMutableArray array];

        PSSpecifier *group = [PSSpecifier preferenceSpecifierNamed:@"ProfessionalAutoClicker"
                                                            target:nil
                                                               set:nil
                                                               get:nil
                                                            detail:nil
                                                              cell:PSGroupCell
                                                              edit:nil];
        group.properties[@"footerText"] = @"Safe preview overlay. This package does not synthesize real touches.";
        [items addObject:group];

        [items addObject:[self switchNamed:@"Enabled" key:@"enabled" defaultValue:@YES]];
        [items addObject:[self switchNamed:@"Preview Mode Only" key:@"previewModeOnly" defaultValue:@YES]];
        [items addObject:[self switchNamed:@"Sound" key:@"soundEnabled" defaultValue:@NO]];

        PSSpecifier *target = [PSSpecifier preferenceSpecifierNamed:@"Target Bundle ID"
                                                             target:self
                                                                set:@selector(setPreferenceValue:specifier:)
                                                                get:@selector(readPreferenceValue:)
                                                             detail:nil
                                                               cell:PSEditTextCell
                                                               edit:nil];
        target.properties[@"key"] = @"targetBundleIdentifier";
        target.properties[@"default"] = @"";
        target.properties[@"placeholder"] = @"empty = all apps";
        [items addObject:target];

        PSSpecifier *interval = [PSSpecifier preferenceSpecifierNamed:@"Interval"
                                                              target:self
                                                                 set:@selector(setPreferenceValue:specifier:)
                                                                 get:@selector(readPreferenceValue:)
                                                              detail:nil
                                                                cell:PSSliderCell
                                                                edit:nil];
        interval.properties[@"key"] = @"interval";
        interval.properties[@"default"] = @0.50;
        interval.properties[@"min"] = @0.05;
        interval.properties[@"max"] = @5.0;
        interval.properties[@"showValue"] = @YES;
        [items addObject:interval];

        PSSpecifier *repeat = [PSSpecifier preferenceSpecifierNamed:@"Repeat Count"
                                                            target:self
                                                               set:@selector(setPreferenceValue:specifier:)
                                                               get:@selector(readPreferenceValue:)
                                                            detail:nil
                                                              cell:PSEditTextCell
                                                              edit:nil];
        repeat.properties[@"key"] = @"repeatCount";
        repeat.properties[@"default"] = @0;
        repeat.properties[@"placeholder"] = @"0 = infinite preview";
        [items addObject:repeat];

        _specifiers = items.copy;
    }
    return _specifiers;
}

- (PSSpecifier *)switchNamed:(NSString *)name key:(NSString *)key defaultValue:(NSNumber *)defaultValue {
    PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:name
                                                            target:self
                                                               set:@selector(setPreferenceValue:specifier:)
                                                               get:@selector(readPreferenceValue:)
                                                            detail:nil
                                                              cell:PSSwitchCell
                                                              edit:nil];
    specifier.properties[@"key"] = key;
    specifier.properties[@"default"] = defaultValue;
    return specifier;
}

- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:kPrefsPath] ?: @{};
    id value = settings[specifier.properties[@"key"]];
    return value ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSMutableDictionary *settings = [[NSDictionary dictionaryWithContentsOfFile:kPrefsPath] mutableCopy] ?: [NSMutableDictionary dictionary];
    NSString *key = specifier.properties[@"key"];
    if (key) settings[key] = value ?: @"";
    [settings writeToFile:kPrefsPath atomically:YES];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.example.professionalautoclicker/preferences.changed"), NULL, NULL, true);
}
@end
