//
//  LRAppReplayKit.h
//  LibTools
//
//  Created by 刘冉 on 2018/8/21.
//  Copyright © 2018年 LRCY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReplayKit/ReplayKit.h>

@protocol LRAppReplayKitDelegate <NSObject>

/**
 * 开始录制回调
 */
- (void)replayRecordStart;
/**
 * 录制结束或者错误回调
 */
- (void)replayRecordFinishWithVC:(RPPreviewViewController *)previewViewController errorInfo:(NSString *)errorInfo;
/**
 * 保存到系统相册
 */
- (void)saveVideoToAlbumSucess;

@end

/// iOS系统版本需要9.0及以上才可支持ReplayKit框架录制
@interface LRAppReplayKit : NSObject

/** delegate */
@property (nonatomic,weak) id<LRAppReplayKitDelegate> delegate;
/** 是否正在录制 */
@property (nonatomic,assign,readonly) BOOL isRecording;

/**
 * 单例对象
 */
+ (instancetype)shareReplay;
/**
 * 是否显示录制按钮
 */
- (void)catreButton:(BOOL)isCate;
/**
 * 开始录制
 */
- (void)startRecord;
/**
 * 结束录制
 * isShow 是否录制完后自动展示视频预览页
 */
- (void)stopRecordAndShowVideoPreviewController:(BOOL)isShow;

@end
