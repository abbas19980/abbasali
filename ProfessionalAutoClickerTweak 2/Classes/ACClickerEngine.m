#import "ACClickerEngine.h"
#import "ACPreferences.h"
#import "ACLogger.h"

@implementation ACClickerEngine {
    NSTimer *_executionTimer;
    NSInteger _currentIndex;
    NSInteger _repeatCounter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _points = [NSMutableArray array];
        _isRunning = NO;
        _currentIndex = 0;
        _repeatCounter = 0;
    }
    return self;
}

- (void)addPoint:(ACPointModel *)point {
    [_points addObject:point];
    ACLog(@"Point added at (%.0f, %.0f)", point.location.x, point.location.y);
}

- (void)removePoint:(ACPointModel *)point {
    [_points removeObject:point];
    ACLog(@"Point removed");
}

- (void)clearAllPoints {
    [_points removeAllObjects];
    ACLog(@"All points cleared");
}

- (void)start {
    if (_points.count == 0) {
        ACLog(@"No points to execute");
        return;
    }
    
    _isRunning = YES;
    _currentIndex = 0;
    _repeatCounter = 0;
    
    ACLog(@"Engine started with %ld points", (long)_points.count);
    [self executeNextPoint];
}

- (void)stop {
    _isRunning = NO;
    [_executionTimer invalidate];
    _executionTimer = nil;
    ACLog(@"Engine stopped");
}

- (void)executeNextPoint {
    if (!_isRunning || _points.count == 0) return;
    
    if (_currentIndex >= _points.count) {
        _currentIndex = 0;
        _repeatCounter++;
        
        if (_repeatCounter >= ACPreferences.shared.repeatCount) {
            [self stop];
            return;
        }
    }
    
    ACPointModel *point = _points[_currentIndex];
    ACLog(@"Executing point %ld at (%.0f, %.0f)", (long)_currentIndex, point.location.x, point.location.y);
    
    _currentIndex++;
    
    __weak typeof(self) weakSelf = self;
    _executionTimer = [NSTimer scheduledTimerWithTimeInterval:ACPreferences.shared.intervalSeconds repeats:NO block:^(NSTimer * _Nonnull timer) {
        [weakSelf executeNextPoint];
    }];
}

- (void)previewPoints {
    ACLog(@"Preview mode: %ld points will be executed", (long)_points.count);
    for (ACPointModel *point in _points) {
        ACLog(@"  -> Point at (%.0f, %.0f)", point.location.x, point.location.y);
    }
}

@end
