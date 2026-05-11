#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACPointModel : NSObject <NSCopying, NSSecureCoding>
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) NSTimeInterval customInterval;
@property (nonatomic, assign) BOOL customIntervalEnabled;
+ (instancetype)modelWithIndex:(NSInteger)index location:(CGPoint)location;
@end

NS_ASSUME_NONNULL_END
