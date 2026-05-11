#ifndef ACMenuView_h
#define ACMenuView_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ACMenuAction) {
    ACMenuActionAddPoint,
    ACMenuActionStartStop,
    ACMenuActionClear,
    ACMenuActionSettings
};

@interface ACMenuView : UIView

@property (nonatomic, copy) void (^onAction)(ACMenuAction action);
@property (nonatomic, assign) BOOL isRunning;

- (void)show;
- (void)hide;

#endif /* ACMenuView_h */
