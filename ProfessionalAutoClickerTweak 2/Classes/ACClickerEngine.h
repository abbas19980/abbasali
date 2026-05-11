#import <Foundation/Foundation.h>
@class ACPointModel;

NS_ASSUME_NONNULL_BEGIN

@protocol ACClickerEngineDelegate <NSObject>
- (void)clickerEngineDidPreviewPoint:(ACPointModel *)point;
- (void)clickerEngineDidStop;
@end

@interface ACClickerEngine : NSObject
@property (nonatomic, weak) id<ACClickerEngineDelegate> delegate;
@property (nonatomic, assign, readonly, getter=isRunning) BOOL running;
- (void)startWithPoints:(NSArray<ACPointModel *> *)points interval:(NSTimeInterval)interval repeatCount:(NSInteger)repeatCount;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
