#import <UIKit/UIKit.h>
@class ACPointModel;

NS_ASSUME_NONNULL_BEGIN

@protocol ACPointViewDelegate <NSObject>
- (void)pointViewDidMove:(ACPointModel *)model;
- (void)pointViewDidRequestDelete:(ACPointModel *)model;
@end

@interface ACPointView : UIView
@property (nonatomic, strong, readonly) ACPointModel *model;
@property (nonatomic, weak) id<ACPointViewDelegate> delegate;
- (instancetype)initWithModel:(ACPointModel *)model;
- (void)pulse;
@end

NS_ASSUME_NONNULL_END
