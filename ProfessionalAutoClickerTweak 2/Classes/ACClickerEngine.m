#import "ACClickerEngine.h"
#import "ACPointModel.h"
#import "ACLogger.h"

@interface ACClickerEngine ()
@property (nonatomic, strong) NSArray<ACPointModel *> *points;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger cursor;
@property (nonatomic, assign) NSInteger completedCycles;
@property (nonatomic, assign) NSInteger repeatCount;
@property (nonatomic, assign, readwrite, getter=isRunning) BOOL running;
@end

@implementation ACClickerEngine
- (void)startWithPoints:(NSArray<ACPointModel *> *)points interval:(NSTimeInterval)interval repeatCount:(NSInteger)repeatCount {
    [self stop];
    if (points.count == 0) return;
    self.points = [[NSArray alloc] initWithArray:points copyItems:YES];
    self.cursor = 0;
    self.completedCycles = 0;
    self.repeatCount = repeatCount;
    self.running = YES;

    NSTimeInterval safeInterval = MAX(0.05, interval);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:safeInterval target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self tick];
    ACLog(@"Preview engine started with %lu points", (unsigned long)points.count);
}

- (void)tick {
    if (!self.running || self.points.count == 0) return;
    ACPointModel *point = self.points[self.cursor];

    // Safe mode: this is only visual preview. It intentionally does not synthesize system touch events.
    [self.delegate clickerEngineDidPreviewPoint:point];

    self.cursor++;
    if (self.cursor >= self.points.count) {
        self.cursor = 0;
        self.completedCycles++;
        if (self.repeatCount > 0 && self.completedCycles >= self.repeatCount) {
            [self stop];
        }
    }
}

- (void)stop {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    BOOL wasRunning = self.running;
    self.running = NO;
    self.points = @[];
    self.cursor = 0;
    if (wasRunning) [self.delegate clickerEngineDidStop];
}

- (void)dealloc { [self stop]; }
@end
