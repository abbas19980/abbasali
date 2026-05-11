#import "ACMenuView.h"

@interface ACMenuView ()
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *playButton;
@end

@implementation ACMenuView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor.secondarySystemBackgroundColor colorWithAlphaComponent:0.96];
        self.layer.cornerRadius = 18;
        self.layer.shadowColor = UIColor.blackColor.CGColor;
        self.layer.shadowOpacity = 0.22;
        self.layer.shadowRadius = 14;
        self.layer.shadowOffset = CGSizeMake(0, 8);

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, frame.size.width - 32, 24)];
        title.text = @"AutoClicker Panel";
        title.font = [UIFont boldSystemFontOfSize:17];
        title.textColor = UIColor.labelColor;
        [self addSubview:title];

        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 38, frame.size.width - 32, 22)];
        _statusLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _statusLabel.textColor = UIColor.secondaryLabelColor;
        [self addSubview:_statusLabel];

        NSArray<NSString *> *titles = @[@"Play", @"+ Point", @"Clear", @"Slower", @"Faster", @"Close"];
        NSArray<NSNumber *> *actions = @[@(ACMenuActionPlayPause), @(ACMenuActionAddPoint), @(ACMenuActionClearPoints), @(ACMenuActionSlower), @(ACMenuActionFaster), @(ACMenuActionClose)];
        CGFloat x = 16, y = 72, w = (frame.size.width - 44) / 2.0, h = 40;
        for (NSInteger i = 0; i < titles.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(x + (i % 2) * (w + 12), y + (i / 2) * 50, w, h);
            button.layer.cornerRadius = 12;
            button.backgroundColor = [UIColor.tertiarySystemBackgroundColor colorWithAlphaComponent:0.95];
            button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            button.tag = actions[i].integerValue;
            [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            if (i == 0) _playButton = button;
        }
    }
    return self;
}

- (void)buttonTapped:(UIButton *)sender {
    [self.delegate menuDidSelectAction:(ACMenuAction)sender.tag];
}

- (void)setRunning:(BOOL)running interval:(NSTimeInterval)interval points:(NSInteger)points {
    [_playButton setTitle:(running ? @"Stop" : @"Play") forState:UIControlStateNormal];
    self.statusLabel.text = [NSString stringWithFormat:@"Preview: %@  •  %.2fs  •  %ld point%@", running ? @"ON" : @"OFF", interval, (long)points, points == 1 ? @"" : @"s"];
}
@end
