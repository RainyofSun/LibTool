//
//  AppPopMenuView.h
//  LibTools
//
//  Created by 刘冉 on 2018/7/6.
//  Copyright © 2018年 LRCY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppPopMenuView;
@protocol AppPopMenuViewDelegate<NSObject>

@optional;
///
- (void)lrPopupMenuBeganDismiss;
///
- (void)lrPopupMenuDidDismiss;
/// 点击事件回调
- (void)lrPopupMenuDidSelectedAtIndex:(NSInteger)index lrPopupMenu:(AppPopMenuView *)lrPopupMenu;

@end

@interface AppPopMenuView : UIView

/**
 圆角半径 Default is 5.0
 */
@property (nonatomic, assign) CGFloat cornerRadius;
/**
 是否显示阴影 Default is YES
 */
@property (nonatomic, assign , getter=isShadowShowing) BOOL isShowShadow;
/**
 设置字体大小 Default is 15
 */
@property (nonatomic, assign) CGFloat fontSize;
/**
 背景透明度
 */
@property (nonatomic, assign) CGFloat bgViewAlpha;
/**
 设置字体颜色 Default is [UIColor blackColor]
 */
@property (nonatomic, strong) UIColor * textColor;
/**
 delegate
 */
@property (nonatomic,weak) id<AppPopMenuViewDelegate> delegate;

/**
 * 初始化
 */
+ (instancetype)showWithReplayView:(UIView *)replayView titles:(NSArray *)title menuWidth:(CGFloat)menuW delegate:(id<AppPopMenuViewDelegate>)delegate;

@end
