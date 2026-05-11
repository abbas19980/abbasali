#import "ACMenuView.h"

@implementation ACMenuView {
    UIStackView *_stackView;
    UIButton *_startStopButton;
}

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, 200, 200)];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.95];
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    
    _stackView = [[UIStackView alloc] initWithFrame:CGRectInset(self.bounds, 10, 10)];
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.distribution = UIStackViewDistributionEqualSpacing;
    _stackView.alignment = UIStackViewAlignmentFill;
    [self addSubview:_stackView];
    
    NSArray *titles = @[@"Add Point", @"Start", @"Clear", @"Settings"];
    ACMenuAction actions[] = {ACMenuActionAddPoint, ACMenuActionStartStop, ACMenuActionClear, ACMenuActionSettings};
    
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = actions[i];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:0.8];
        btn.layer.cornerRadius = 5;
        [btn addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [_stackView addArrangedSubview:btn];
        
        if (i == 1) _startStopButton = btn;
    }
}

- (void)handleButtonTap:(UIButton *)button {
    if (self.onAction) {
        self.onAction(button.tag);
    }
}

- (void)setIsRunning:(BOOL)isRunning {
    _isRunning = isRunning;
    [_startStopButton setTitle:isRunning ? @"Stop" : @"Start" forState:UIControlStateNormal];
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
