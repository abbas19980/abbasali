#import "ACFloatingButton.h"

@implementation ACFloatingButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = MIN(frame.size.width, frame.size.height) / 2.0;
        self.layer.shadowColor = UIColor.blackColor.CGColor;
        self.layer.shadowOpacity = 0.28;
        self.layer.shadowRadius = 10;
        self.layer.shadowOffset = CGSizeMake(0, 6);
        self.backgroundColor = UIColor.systemBlueColor;
        [self setTitle:@"AC" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    return self;
}
@end
