//
//  ViewController.m
//  LibTools
//
//  Created by 刘冉 on 2018/6/27.
//  Copyright © 2018年 LRCY. All rights reserved.
//

#import "ViewController.h"
#import "AppPopMenuView.h"
#import "LRAppReplayKit.h"
#import "PopAnimationKitVC.h"
#import "APPTimer.h"
#import "UIImage+AppImageClear.h"
#import "AppRecordAnimationView.h"
#import "AppRecordView.h"

@interface ViewController ()<AppPopMenuViewDelegate>
{
    UILabel *lable;
    dispatch_source_t timer;
    dispatch_queue_t timeQueue;
    NSInteger max;
    AppPopMenuView *menuView;
    UIButton *btn;
}
/** animationView */
@property (nonatomic,strong) AppRecordAnimationView *animationView;
/** recordView */
@property (nonatomic,strong) AppRecordView *recordView;
/** fakeTimer */
@property (nonatomic,strong) NSTimer *fakeTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self popMenu];
//    [self replayKit];
//    [self popAnimationKit];
//    [self SingleTimer];
//    [self clearImg];
    [self recordAnimation];
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
    NSLog(@"%ld",(long)index);
}

- (void)replayKit {
    
}

- (void)popAnimationKit {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[PopAnimationKitVC alloc] init]];
        [self presentViewController:nav animated:YES completion:nil];
    });
}

- (void)SingleTimer {
    [[APPTimer sharedAPPTimer] starTimer];
    [[APPTimer sharedAPPTimer] addTimerObserve:self block:^{
        NSLog(@"吃饭了");
    }];
}

- (void)clearImg {
    UIImage *image = [UIImage imageNamed:@"1024"];
    
    UIImageView *imageView_1 = [[UIImageView alloc] initWithImage:image];
    imageView_1.frame = CGRectMake(100, 100, 200, 200);
    
    UIImageView *imageview_2 = [[UIImageView alloc] initWithImage:image.imageToTransparent];
    imageview_2.frame = CGRectMake(100, 350, 200, 200);
    
    [self.view addSubview:imageView_1];
    [self.view addSubview:imageview_2];
}

- (void)recordAnimation {
    self.recordView = [[AppRecordView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    self.recordView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.recordView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fakeTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onFakeTimerTimeOut) userInfo:nil repeats:YES];
    });
}

- (void)onFakeTimerTimeOut {
    dispatch_async(dispatch_get_main_queue(), ^{
        float fakePower = (float)(1+arc4random()%99)/100;
        [self.recordView updateWithPower:fakePower];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
