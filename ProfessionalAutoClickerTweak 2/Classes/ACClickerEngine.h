#ifndef ACClickerEngine_h
#define ACClickerEngine_h

#import <Foundation/Foundation.h>
#import "ACPointModel.h"

@interface ACClickerEngine : NSObject

@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, strong) NSMutableArray *points;

- (void)addPoint:(ACPointModel *)point;
- (void)removePoint:(ACPointModel *)point;
- (void)clearAllPoints;
- (void)start;
- (void)stop;
- (void)previewPoints;

#endif /* ACClickerEngine_h */
