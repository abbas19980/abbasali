#import "ACPointView.h"
#import "ACPointModel.h"

@interface ACPointView ()
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong, readwrite) ACPointModel *model;
@end

@implementation ACPointView
- (instancetype)initWithModel:(ACPointModel *)model {
    self = [super initWithFrame:CGRectMake(model.location.x - 24, model.location.y - 24, 48, 48)];
    if (self) {
        _model = model;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.01];
        self.layer.cornerRadius = 24;
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = UIColor.systemBlueColor.CGColor;

        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(6, 6, 36, 36)];
        dot.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        dot.backgroundColor = [UIColor.systemBlueColor colorWithAlphaComponent:0.18];
        dot.layer.cornerRadius = 18;
        dot.userInteractionEnabled = NO;
        [self addSubview:dot];

        _indexLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.font = [UIFont boldSystemFontOfSize:16];
        _indexLabel.textColor = UIColor.labelColor;
        _indexLabel.text = [NSString stringWithFormat:@"%ld", (long)model.index];
        [self addSubview:_indexLabel];

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.minimumPressDuration = 0.45;
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    UIView *container = self.superview;
    if (!container) return;
    CGPoint translation = [pan translationInView:container];
    CGPoint center = self.center;
    center.x += translation.x;
    center.y += translation.y;
    center.x = MIN(MAX(24, center.x), container.bounds.size.width - 24);
    center.y = MIN(MAX(24, center.y), container.bounds.size.height - 24);
    self.center = center;
    self.model.location = center;
    [pan setTranslation:CGPointZero inView:container];
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        [self.delegate pointViewDidMove:self.model];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)press {
    if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate pointViewDidRequestDelete:self.model];
    }
}

- (void)pulse {
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.08 animations:^{
        self.transform = CGAffineTransformMakeScale(1.22, 1.22);
        self.alpha = 0.65;
    } completion:^(__unused BOOL finished) {
        [UIView animateWithDuration:0.12 animations:^{
            self.transform = CGAffineTransformIdentity;
            self.alpha = 1.0;
        }];
    }];
}
@end
