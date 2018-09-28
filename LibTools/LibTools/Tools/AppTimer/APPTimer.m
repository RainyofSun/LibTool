//
//  APPTimer.m
//  LibTools
//
//  Created by 刘冉 on 2018/9/15.
//  Copyright © 2018年 LRCY. All rights reserved.
//

#import "APPTimer.h"
#import <objc/runtime.h>

const char blockMark = '\0';

@implementation NSObject (APPTimerCustom)

- (void)setObjectBlock:(void (^)(void))objectBlock {
    objc_setAssociatedObject(self, &blockMark, objectBlock, OBJC_ASSOCIATION_RETAIN);
}

- (void (^)(void))getObjectBlock {
    return objc_getAssociatedObject(self, &blockMark);
}

@end

@interface APPTimer()

@property(nonatomic,strong)dispatch_source_t appTimer;
@property(nonatomic,strong)NSHashTable* hashTable;

@end

static APPTimer *timer = nil;
@implementation APPTimer

+ (instancetype)sharedAPPTimer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!timer) {
            timer = [[APPTimer alloc] init];
        }
    });
    return timer;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!timer) {
            timer = [super allocWithZone:zone];
        }
    });
    return timer;
}

- (id)copyWithZone:(NSZone *)zone{
    return timer;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return timer;
}

- (void)starTimer {
    if (!_appTimer) {
        __weak typeof(self) weakSelf = self;
        dispatch_queue_t timerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _appTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, timerQueue);
        dispatch_source_set_timer(_appTimer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_appTimer, ^{
            [weakSelf timerFlay];
        });
        dispatch_resume(_appTimer);
    }
}

- (void)pausetimer {
    if (_appTimer) {
        dispatch_suspend(_appTimer);
    }
}

- (void)cancleTimer {
    if (_appTimer) {
        dispatch_source_cancel(_appTimer);
        _appTimer = nil;
    }
}

- (void)timerFlay {
    [_hashTable.allObjects enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.getObjectBlock ? obj.getObjectBlock() : nil;
    }];
}

#pragma mark - 定时器回调
-(void)addTimerObserve:(NSObject *)observe block:(void (^)(void))block {
    if (![self.hashTable containsObject:observe]) {
        [observe setObjectBlock:block];
        [self.hashTable addObject:observe];
    }
}

- (void)removeTimerObserve:(NSObject *)observe {
    if ([self.hashTable containsObject:observe]) {
        [self.hashTable removeObject:observe];
    }
}

#pragma mark - set
- (NSHashTable *)hashTable {
    if (!_hashTable) {
        _hashTable = [NSHashTable weakObjectsHashTable];
    }
    return _hashTable;
}

#pragma mark - 时间转换
//秒数转时间
+ (void)secondsToTime:(NSInteger)seconds d:(NSInteger *)d h:(NSInteger *)h m:(NSInteger *)m s:(NSInteger *)s {
    *d = seconds/(3600 * 24);
    NSInteger ds = seconds - *d * (3600 * 24);
    *h = ds/3600;
    NSInteger ms = (ds - 3600 * *h);
    *m = ms/60;
    *s = ms - 60 * *m;
}


//秒数转时间字符
+ (NSString *)timeTxtFromSeconds:(NSInteger)seconds {
    NSInteger d, h, m, s;
    [self secondsToTime:seconds d:&d h:&h m:&m s:&s];
    return [NSString stringWithFormat:@"%02lu:%02lu",(long)m,(long)s];
    if (d==0&&h==0) {
        return [NSString stringWithFormat:@"%02lu:%02lu",(long)m,(long)s];
    }
    if (d==0) {
        return [NSString stringWithFormat:@"%02lu:%02lu:%02lu",(long)h,(long)m,(long)s];
    }
    return [NSString stringWithFormat:@"%lu %02lu:%02lu:%02lu", (long)d, (long)h,(long)m,(long)s];
}

@end
