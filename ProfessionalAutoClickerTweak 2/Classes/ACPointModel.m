#import "ACPointModel.h"

@implementation ACPointModel

- (instancetype)initWithLocation:(CGPoint)location {
    self = [super init];
    if (self) {
        _location = location;
        _identifier = [[NSUUID UUID] UUIDString];
        _timestamp = [NSDate date].timeIntervalSince1970;
    }
    return self;
}

- (NSDictionary *)toDictionary {
    return @{
        @"x": @(_location.x),
        @"y": @(_location.y),
        @"identifier": _identifier,
        @"timestamp": @(_timestamp)
    };
}

+ (instancetype)fromDictionary:(NSDictionary *)dict {
    ACPointModel *model = [[ACPointModel alloc] initWithLocation:CGPointMake(
        [dict[@"x"] floatValue],
        [dict[@"y"] floatValue]
    )];
    model.identifier = dict[@"identifier"];
    model.timestamp = [dict[@"timestamp"] doubleValue];
    return model;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeFloat:_location.x forKey:@"x"];
    [coder encodeFloat:_location.y forKey:@"y"];
    [coder encodeObject:_identifier forKey:@"identifier"];
    [coder encodeDouble:_timestamp forKey:@"timestamp"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _location = CGPointMake(
            [coder decodeFloatForKey:@"x"],
            [coder decodeFloatForKey:@"y"]
        );
        _identifier = [coder decodeObjectForKey:@"identifier"];
        _timestamp = [coder decodeDoubleForKey:@"timestamp"];
    }
    return self;
}

@end
