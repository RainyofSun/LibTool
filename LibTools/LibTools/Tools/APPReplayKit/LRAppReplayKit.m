//
//  LRAppReplayKit.m
//  LibTools
//
//  Created by 刘冉 on 2018/8/21.
//  Copyright © 2018年 LRCY. All rights reserved.
//

#import "LRAppReplayKit.h"

@interface LRAppReplayKit()<RPPreviewViewControllerDelegate>

/** 开始录制 */
@property (nonatomic,strong) UIButton *startRecordBtn;
/** 结束录制 */
@property (nonatomic,strong) UIButton *endRecordBtn;
/** window */
@property (nonatomic,strong) UIWindow *window;

@end

@implementation LRAppReplayKit

+ (instancetype)shareReplay {
    static LRAppReplayKit *replay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        replay = [[LRAppReplayKit alloc] init];
    });
    return replay;
}

- (void)catreButton:(BOOL)isCate {
    if (!isCate) {
        return;
    }
    [self performSelector:@selector(createWindow) withObject:nil afterDelay:1];
}

- (void)createWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor clearColor];
    self.window.windowLevel = UIWindowLevelAlert + 1;
    [self.window makeKeyAndVisible];
    [self.window addSubview:self.startRecordBtn];
    [self.window addSubview:self.endRecordBtn];
}

- (BOOL)isRecording {
    return [RPScreenRecorder sharedRecorder].recording;
}

- (void)startRecord {
    if ([RPScreenRecorder sharedRecorder].recording) {
        NSLog(@"LRAppReplayKit: 已经开始录制");
        return;
    }
    if ([self systemVersionOK]) {
        if ([[RPScreenRecorder sharedRecorder] isAvailable]) {
            NSLog(@"LRAppReplayKit:录制开始初始化");
            [[RPScreenRecorder sharedRecorder] startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"LRAppReplayKit:开始录制error %@",error);
                    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(replayRecordFinishWithVC:errorInfo:)]) {
                        [self.delegate replayRecordFinishWithVC:nil errorInfo:[NSString stringWithFormat:@"LRAppReplayKit:开始录制error %@",error]];
                    }
                } else {
                    NSLog(@"LRAppReplayKit:开始录制");
                    [self.startRecordBtn setTitle:@"正在录制" forState:UIControlStateNormal];
                    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(replayRecordStart)]) {
                        [self.delegate replayRecordStart];
                    }
                }
            }];
        } else {
            NSLog(@"LRAppReplayKit:环境不支持ReplayKit");
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(replayRecordFinishWithVC:errorInfo:)]) {
                [self.delegate replayRecordFinishWithVC:nil errorInfo:[NSString stringWithFormat:@"LRAppReplayKit:环境不支持ReplayKit"]];
            }
        }
    } else {
        NSLog(@"LRAppReplayKit:iOS系统版本需要9.0及以上才可支持ReplayKit框架录制");
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(replayRecordFinishWithVC:errorInfo:)]) {
            [self.delegate replayRecordFinishWithVC:nil errorInfo:[NSString stringWithFormat:@"LRAppReplayKit:iOS系统版本需要9.0及以上才可支持ReplayKit框架录制"]];
        }
    }
}

- (void)stopRecordAndShowVideoPreviewController:(BOOL)isShow {
    NSLog(@"LRAppReplayKit:正在结束录制");
    [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
        [self.startRecordBtn setTitle:@"开始录制" forState:UIControlStateNormal];
        if (error) {
            NSLog(@"LRAppReplayKit:结束录制 error %@",error);
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(replayRecordFinishWithVC:errorInfo:)]) {
                [self.delegate replayRecordFinishWithVC:previewViewController errorInfo:[NSString stringWithFormat:@"LRAppReplayKit:结束录制error %@",error]];
            }
        } else {
            NSLog(@"LRAppReplayKit:录制完成");
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(replayRecordFinishWithVC:errorInfo:)]) {
                [self.delegate replayRecordFinishWithVC:previewViewController errorInfo:@""];
            }
            if (isShow) {
                [self showVideoPreviewController:previewViewController animation:YES];
            }
        }
    }];
}

#pragma mark - RPPreviewViewControllerDelegate
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    [self hideVideoPreviewController:previewController animation:YES];
}

- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet<NSString *> *)activityTypes {
    if ([activityTypes containsObject:@"com.apple.UIKit.activity.SaveToCameraRoll"]) {
        NSLog(@"LRAppReplayKit: 保存到相册成功");
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(saveVideoToAlbumSucess)]) {
            [self.delegate saveVideoToAlbumSucess];
        }
    }
    if ([activityTypes containsObject:@"com.apple.UIKit.activity.CopyToPasteboard"]) {
        NSLog(@"LRAppReplayKit:复制成功");
    }
}

#pragma mark - 点击方法
- (void)startAction {
    [_startRecordBtn setTitle:@"初始化中" forState:UIControlStateNormal];
    [[LRAppReplayKit shareReplay] startRecord];
}

- (void)endAction {
    [_startRecordBtn setTitle:@"开始录制" forState:UIControlStateNormal];
    [[LRAppReplayKit shareReplay] stopRecordAndShowVideoPreviewController:YES];
}

#pragma mark - 私有方法
- (BOOL)systemVersionOK {
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0) {
        return NO;
    } else {
        return YES;
    }
}

- (UIViewController *)getRootVC {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}
// 显示视频预览画面
- (void)showVideoPreviewController:(RPPreviewViewController *)previewController animation:(BOOL)animation {
    previewController.previewControllerDelegate = self;
    __weak UIViewController *rootVC = [self getRootVC];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = [UIScreen mainScreen].bounds;
        if (animation) {
            rect.origin.x += rect.size.width;
            previewController.view.frame = rect;
            rect.origin.x -= rect.size.width;
            [UIView animateWithDuration:0.3 animations:^{
                previewController.view.frame = rect;
            }];
        } else {
            previewController.view.frame = rect;
        }
        [rootVC.view addSubview:previewController.view];
        [rootVC addChildViewController:previewController];
    });
}

- (void)hideVideoPreviewController:(RPPreviewViewController *)previewController animation:(BOOL)animation {
    previewController.previewControllerDelegate = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = previewController.view.frame;
        if (animation) {
            rect.origin.x += rect.size.width;
            [UIView animateWithDuration:0.3 animations:^{
                previewController.view.frame = rect;
            } completion:^(BOOL finished) {
                [previewController.view removeFromSuperview];
                [previewController removeFromParentViewController];
            }];
        } else {
            [previewController.view removeFromSuperview];
            [previewController removeFromParentViewController];
        }
    });
}

#pragma mark - setter
- (UIButton *)startRecordBtn {
    if (!_startRecordBtn) {
        _startRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startRecordBtn.backgroundColor = [UIColor redColor];
        [_startRecordBtn setTitle:@"开始录制" forState:UIControlStateNormal];
        _startRecordBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_startRecordBtn addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startRecordBtn;
}

- (UIButton *)endRecordBtn {
    if (!_endRecordBtn) {
        _endRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _endRecordBtn.backgroundColor = [UIColor redColor];
        [_endRecordBtn setTitle:@"结束录制" forState:UIControlStateNormal];
        _endRecordBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_endRecordBtn addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endRecordBtn;
}
@end
