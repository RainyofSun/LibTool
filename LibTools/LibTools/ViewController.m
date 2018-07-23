//
//  ViewController.m
//  LibTools
//
//  Created by 刘冉 on 2018/6/27.
//  Copyright © 2018年 LRCY. All rights reserved.
//

#import "ViewController.h"
#import "AppPopMenuView.h"

@interface ViewController ()<AppPopMenuViewDelegate>
{
    UILabel *lable;
    dispatch_source_t timer;
    dispatch_queue_t timeQueue;
    NSInteger max;
    AppPopMenuView *menuView;
    UIButton *btn;
}
@end

@implementation ViewController

- (void)timer {
    lable = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 80, 40)];
    lable.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:lable];
    
    max = 30;
    
    __block NSInteger num = 0;
    timeQueue = dispatch_queue_create("time", DISPATCH_QUEUE_SERIAL);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, timeQueue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        num ++;
        dispatch_async(dispatch_get_main_queue(), ^{
            self->lable.text = [NSString stringWithFormat:@"%ld",num];
        });
        if (num >= self->max) {
            dispatch_source_cancel(self->timer);
        }
    });
    dispatch_resume(timer);
}

- (void)popMenu {
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 80, 30);
    btn.backgroundColor = [UIColor yellowColor];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)click {
    [AppPopMenuView showWithReplayView:btn titles:@[@"吃饭啦",@"吃饭啦",@"吃饭啦",@"吃饭啦",@"吃饭啦",@"吃饭啦",@"吃饭啦"] menuWidth:btn.bounds.size.width delegate:self];
}

- (void)lrPopupMenuDidSelectedAtIndex:(NSInteger)index lrPopupMenu:(AppPopMenuView *)lrPopupMenu {
    NSLog(@"%ld",index);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self popMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
