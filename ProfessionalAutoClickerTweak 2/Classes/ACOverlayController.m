#import "ACOverlayController.h"
#import "ACPreferences.h"
#import "ACLogger.h"
#import "ACPointView.h"

@implementation ACOverlayController {
    UIWindow *_window;
    ACFloatingButton *_floatingButton;
    ACMenuView *_menuView;
    ACClickerEngine *_engine;
    NSMutableArray *_pointViews;
    BOOL _isInstalled;
}

+ (instancetype)shared {
    static ACOverlayController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ACOverlayController alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _pointViews = [NSMutableArray array];
        _engine = [[ACClickerEngine alloc] init];
        _isInstalled = NO;
    }
    return self;
}

- (void)installIfNeeded {
    if (_isInstalled || ![ACPreferences.shared shouldActivateForBundle:NSBundle.mainBundle.bundleIdentifier]) {
        return;
    }
    
    [self createWindow];
    [self setupFloatingButton];
    [self setupMenuView];
    
    _isInstalled = YES;
    ACLog(@"Overlay installed in bundle: %@", NSBundle.mainBundle.bundleIdentifier);
}

- (void)createWindow {
    _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    _window.windowLevel = UIWindowLevelAlert + 100;
    _window.backgroundColor = [UIColor clearColor];
    _window.userInteractionEnabled = YES;
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor clearColor];
    _window.rootViewController = vc;
    [_window makeKeyAndVisible];
}

- (void)setupFloatingButton {
    _floatingButton = [[ACFloatingButton alloc] init];
    _floatingButton.center = CGPointMake(UIScreen.mainScreen.bounds.size.width - 40, UIScreen.mainScreen.bounds.size.height - 100);
    [_window addSubview:_floatingButton];
    
    __weak typeof(self) weakSelf = self;
    _floatingButton.onTap = ^{
        [weakSelf toggleMenu];
    };
}

- (void)setupMenuView {
    _menuView = [[ACMenuView alloc] init];
    _menuView.center = CGPointMake(UIScreen.mainScreen.bounds.size.width / 2, UIScreen.mainScreen.bounds.size.height / 2);
    _menuView.alpha = 0;
    [_window addSubview:_menuView];
    
    __weak typeof(self) weakSelf = self;
    _menuView.onAction = ^(ACMenuAction action) {
        [weakSelf handleMenuAction:action];
    };
}

- (void)toggleMenu {
    [UIView animateWithDuration:0.3 animations:^{
        self->_menuView.alpha = self->_menuView.alpha > 0.5 ? 0 : 1;
    }];
}

- (void)handleMenuAction:(ACMenuAction)action {
    switch (action) {
        case ACMenuActionAddPoint:
            [self addPointAtCenter];
            break;
        case ACMenuActionStartStop:
            [self toggleEngine];
            break;
        case ACMenuActionClear:
            [self clearAllPoints];
            break;
        case ACMenuActionSettings:
            [self showSettings];
            break;
    }
}

- (void)addPointAtCenter {
    CGPoint center = CGPointMake(UIScreen.mainScreen.bounds.size.width / 2, UIScreen.mainScreen.bounds.size.height / 2);
    ACPointModel *point = [[ACPointModel alloc] initWithLocation:center];
    
    ACPointView *pointView = [[ACPointView alloc] initWithPoint:point];
    [_window addSubview:pointView];
    [_pointViews addObject:pointView];
    
    [_engine addPoint:point];
    ACLog(@"New point added at center");
}

- (void)toggleEngine {
    if (_engine.isRunning) {
        [_engine stop];
    } else {
        [_engine start];
    }
    _menuView.isRunning = _engine.isRunning;
}

- (void)clearAllPoints {
    [_pointViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_pointViews removeAllObjects];
    [_engine clearAllPoints];
    ACLog(@"All points cleared");
}

- (void)showSettings {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Settings" message:@"Professional Auto Clicker" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)uninstall {
    [_window resignKeyWindow];
    _window = nil;
    _isInstalled = NO;
    ACLog(@"Overlay uninstalled");
}

@end
