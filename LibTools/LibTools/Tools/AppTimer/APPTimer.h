//
//  APPTimer.h
//  LibTools
//
//  Created by 刘冉 on 2018/9/15.
//  Copyright © 2018年 LRCY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (APPTimerCustom)

-(void)setObjectBlock:(void(^)(void))objectBlock;
-(void(^)(void))getObjectBlock;

@end

@interface APPTimer : NSObject

@property (nonatomic, assign)int timeout;

+ (instancetype)sharedAPPTimer;
- (void)starTimer;
- (void)pausetimer;
- (void)cancleTimer;

- (void)addTimerObserve:(NSObject *)observe block:(void(^)(void))block ;
- (void)removeTimerObserve:(NSObject *)observe ;
//秒数转时间字符
+ (NSString *)timeTxtFromSeconds:(NSInteger)seconds;

@end
