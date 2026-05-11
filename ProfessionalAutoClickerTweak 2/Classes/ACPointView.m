#import "ACPointView.h"

@implementation ACPointView {
    UILabel *_indexLabel;
    CADisplayLink *_pulseLink;
}

- (instancetype)initWithPoint:(ACPointModel *)point {
    self = [super initWithFrame:CGRectMake(point.location.x - 20, point.location.y - 20, 40, 40)];
    if (self) {
        _model = point;
        [self setupUI];
        [self enableDragging];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:0.8];
    self.layer.cornerRadius = 20;
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _indexLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_indexLabel];
}

- (void)enableDragging {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:tap];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.superview];
    CGPoint newCenter = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    self.center = newCenter;
    _model.location = newCenter;
    [recognizer setTranslation:CGPointZero inView:self.superview];
}

- (void)handleTap {
    _isSelected = !_isSelected;
    self.layer.borderColor = _isSelected ? [UIColor yellowColor].CGColor : [UIColor whiteColor].CGColor;
}

- (void)startPulseAnimation {
    _pulseLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePulse)];
    [_pulseLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopPulseAnimation {
    [_pulseLink invalidate];
    _pulseLink = nil;
}

- (void)updatePulse {
    CGFloat scale = 1.0 + 0.2 * sin(CACurrentMediaTime() * 3);
    self.transform = CGAffineTransformMakeScale(scale, scale);
}

@end
