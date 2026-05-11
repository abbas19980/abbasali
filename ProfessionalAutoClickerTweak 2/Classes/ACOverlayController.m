#import "ACOverlayController.h"
#import "ACFloatingButton.h"
#import "ACMenuView.h"
#import "ACPointView.h"
#import "ACPointModel.h"
#import "ACClickerEngine.h"
#import "ACPreferences.h"
#import "ACLogger.h"

@interface ACOverlayController () <ACMenuViewDelegate, ACPointViewDelegate, ACClickerEngineDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) ACFloatingButton *floatingButton;
@property (nonatomic, strong) ACMenuView *menuView;
@property (nonatomic, strong) NSMutableArray<ACPointModel *> *points;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, ACPointView *> *pointViews;
@property (nonatomic, strong) ACClickerEngine *engine;
@property (nonatomic, assign) BOOL installed;
@end

@implementation ACOverlayController
+ (instancetype)shared {
    static ACOverlayController *controller;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ controller = [ACOverlayController new]; });
    return controller;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _points = [NSMutableArray array];
        _pointViews = [NSMutableDictionary dictionary];
        _engine = [ACClickerEngine new];
        _engine.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferencesChanged) name:ACPreferencesChangedNotification object:nil];
    }
    return self;
}

- (void)installIfNeeded {
    if (self.installed || ![ACPreferences.shared shouldLoadForCurrentBundle]) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIScreen *screen = UIScreen.mainScreen;
        self.window = [[UIWindow alloc] initWithFrame:screen.bounds];
        self.window.windowLevel = UIWindowLevelAlert + 120;
        self.window.backgroundColor = UIColor.clearColor;
        self.window.hidden = NO;
        self.window.userInteractionEnabled = YES;

        UIViewController *root = [UIViewController new];
        root.view.backgroundColor = UIColor.clearColor;
        self.window.rootViewController = root;

        self.floatingButton = [[ACFloatingButton alloc] initWithFrame:CGRectMake(18, 160, 58, 58)];
        [self.floatingButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
        [root.view addSubview:self.floatingButton];

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveFloatingButton:)];
        [self.floatingButton addGestureRecognizer:pan];

        self.installed = YES;
        [self addDefaultPointIfNeeded];
        [self updateMenuStatus];
        ACLog(@"Overlay installed");
    });
}

- (void)remove {
    [self.engine stop];
    self.window.hidden = YES;
    self.window = nil;
    self.installed = NO;
}

- (void)preferencesChanged {
    [ACPreferences.shared reload];
    if (![ACPreferences.shared shouldLoadForCurrentBundle]) [self remove];
    [self updateMenuStatus];
}

- (void)addDefaultPointIfNeeded {
    if (self.points.count > 0) return;
    CGSize size = self.window.bounds.size;
    [self addPointAt:CGPointMake(size.width / 2.0, size.height / 2.0)];
}

- (void)addPointAt:(CGPoint)location {
    NSInteger nextIndex = self.points.count + 1;
    ACPointModel *model = [ACPointModel modelWithIndex:nextIndex location:location];
    [self.points addObject:model];
    ACPointView *view = [[ACPointView alloc] initWithModel:model];
    view.delegate = self;
    [self.window.rootViewController.view insertSubview:view belowSubview:self.floatingButton];
    self.pointViews[@(model.index)] = view;
    [self updateMenuStatus];
}

- (void)toggleMenu {
    if (self.menuView.superview) {
        [self.menuView removeFromSuperview];
        return;
    }
    if (!self.menuView) {
        self.menuView = [[ACMenuView alloc] initWithFrame:CGRectMake(18, 226, 260, 230)];
        self.menuView.delegate = self;
    }
    [self.window.rootViewController.view addSubview:self.menuView];
    [self updateMenuStatus];
}

- (void)moveFloatingButton:(UIPanGestureRecognizer *)pan {
    UIView *container = self.window.rootViewController.view;
    CGPoint translation = [pan translationInView:container];
    CGPoint center = self.floatingButton.center;
    center.x = MIN(MAX(29, center.x + translation.x), container.bounds.size.width - 29);
    center.y = MIN(MAX(29, center.y + translation.y), container.bounds.size.height - 29);
    self.floatingButton.center = center;
    [pan setTranslation:CGPointZero inView:container];
}

- (void)menuDidSelectAction:(ACMenuAction)action {
    ACPreferences *prefs = ACPreferences.shared;
    switch (action) {
        case ACMenuActionPlayPause:
            self.engine.isRunning ? [self.engine stop] : [self.engine startWithPoints:self.points interval:prefs.interval repeatCount:prefs.repeatCount];
            break;
        case ACMenuActionAddPoint:
            [self addPointAt:CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds) + self.points.count * 28)];
            break;
        case ACMenuActionClearPoints:
            [self.engine stop];
            for (ACPointView *view in self.pointViews.allValues) [view removeFromSuperview];
            [self.points removeAllObjects];
            [self.pointViews removeAllObjects];
            [self addDefaultPointIfNeeded];
            break;
        case ACMenuActionSlower:
            prefs.interval = MIN(5.0, prefs.interval + 0.10); [prefs save];
            break;
        case ACMenuActionFaster:
            prefs.interval = MAX(0.05, prefs.interval - 0.05); [prefs save];
            break;
        case ACMenuActionClose:
            [self.menuView removeFromSuperview];
            break;
    }
    [self updateMenuStatus];
}

- (void)pointViewDidMove:(ACPointModel *)model { [self updateMenuStatus]; }

- (void)pointViewDidRequestDelete:(ACPointModel *)model {
    if (self.points.count <= 1) return;
    ACPointView *view = self.pointViews[@(model.index)];
    [view removeFromSuperview];
    [self.pointViews removeObjectForKey:@(model.index)];
    [self.points removeObject:model];
    [self reindexPoints];
    [self updateMenuStatus];
}

- (void)reindexPoints {
    NSArray *old = self.points.copy;
    [self.pointViews removeAllObjects];
    for (NSInteger i = 0; i < old.count; i++) {
        ACPointModel *model = old[i];
        model.index = i + 1;
    }
    for (ACPointView *view in self.window.rootViewController.view.subviews) {
        if ([view isKindOfClass:ACPointView.class]) {
            ACPointView *pointView = (ACPointView *)view;
            self.pointViews[@(pointView.model.index)] = pointView;
        }
    }
}

- (void)clickerEngineDidPreviewPoint:(ACPointModel *)point {
    ACPointView *view = self.pointViews[@(point.index)];
    [view pulse];
}

- (void)clickerEngineDidStop { [self updateMenuStatus]; }

- (void)updateMenuStatus {
    [self.menuView setRunning:self.engine.isRunning interval:ACPreferences.shared.interval points:self.points.count];
}
@end
