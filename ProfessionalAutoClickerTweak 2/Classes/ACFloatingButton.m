#import "ACFloatingButton.h"

@implementation ACFloatingButton {
    UIButton *_button;
    UIPanGestureRecognizer *_panGesture;
}

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, 60, 60)];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = self.bounds;
    _button.backgroundColor = [UIColor colorWithRed:0.1 green:0.5 blue:1.0 alpha:0.9];
    _button.layer.cornerRadius = 30;
    _button.layer.shadowColor = [UIColor blackColor].CGColor;
    _button.layer.shadowOpacity = 0.8;
    _button.layer.shadowRadius = 5;
    
    [_button setTitle:@"AC" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [_button addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:_panGesture];
}

- (void)handleTap {
    if (self.onTap) {
        self.onTap();
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self.superview];
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    }];
}

@end
