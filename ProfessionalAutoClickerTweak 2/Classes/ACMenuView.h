#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ACMenuAction) {
    ACMenuActionPlayPause,
    ACMenuActionAddPoint,
    ACMenuActionClearPoints,
    ACMenuActionSlower,
    ACMenuActionFaster,
    ACMenuActionClose
};

@protocol ACMenuViewDelegate <NSObject>
- (void)menuDidSelectAction:(ACMenuAction)action;
@end

@interface ACMenuView : UIView
@property (nonatomic, weak) id<ACMenuViewDelegate> delegate;
- (void)setRunning:(BOOL)running interval:(NSTimeInterval)interval points:(NSInteger)points;
@end

NS_ASSUME_NONNULL_END
