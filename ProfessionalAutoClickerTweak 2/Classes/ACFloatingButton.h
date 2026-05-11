#ifndef ACFloatingButton_h
#define ACFloatingButton_h

#import <UIKit/UIKit.h>

@interface ACFloatingButton : UIView

@property (nonatomic, copy) void (^onTap)(void);

- (void)show;
- (void)hide;

#endif /* ACFloatingButton_h */
