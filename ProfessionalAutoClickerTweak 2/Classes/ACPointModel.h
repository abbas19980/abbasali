#ifndef ACPointModel_h
#define ACPointModel_h

#import <UIKit/UIKit.h>

@interface ACPointModel : NSObject <NSCoding>

@property (nonatomic, assign) CGPoint location;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) NSTimeInterval timestamp;

- (instancetype)initWithLocation:(CGPoint)location;
- (NSDictionary *)toDictionary;
+ (instancetype)fromDictionary:(NSDictionary *)dict;

#endif /* ACPointModel_h */
