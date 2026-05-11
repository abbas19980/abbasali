#import "ACPointModel.h"

@implementation ACPointModel
+ (BOOL)supportsSecureCoding { return YES; }
+ (instancetype)modelWithIndex:(NSInteger)index location:(CGPoint)location {
    ACPointModel *model = [ACPointModel new];
    model.index = index;
    model.location = location;
    model.customInterval = 0.50;
    model.customIntervalEnabled = NO;
    return model;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.index forKey:@"index"];
    [coder encodeCGPoint:self.location forKey:@"location"];
    [coder encodeDouble:self.customInterval forKey:@"customInterval"];
    [coder encodeBool:self.customIntervalEnabled forKey:@"customIntervalEnabled"];
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _index = [coder decodeIntegerForKey:@"index"];
        _location = [coder decodeCGPointForKey:@"location"];
        _customInterval = [coder decodeDoubleForKey:@"customInterval"];
        _customIntervalEnabled = [coder decodeBoolForKey:@"customIntervalEnabled"];
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone {
    ACPointModel *copy = [ACPointModel new];
    copy.index = self.index;
    copy.location = self.location;
    copy.customInterval = self.customInterval;
    copy.customIntervalEnabled = self.customIntervalEnabled;
    return copy;
}
@end
