#ifndef ACPointView_h
#define ACPointView_h

#import <UIKit/UIKit.h>
#import "ACPointModel.h"

@interface ACPointView : UIView

@property (nonatomic, strong) ACPointModel *model;
@property (nonatomic, copy) void (^onDelete)(ACPointModel *);
@property (nonatomic, assign) BOOL isSelected;

- (instancetype)initWithPoint:(ACPointModel *)point;
- (void)startPulseAnimation;
- (void)stopPulseAnimation;

#end /* ACPointView_h */
