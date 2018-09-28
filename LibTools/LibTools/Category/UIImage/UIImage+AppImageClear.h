//
//  UIImage+AppImageClear.h
//  LibTools
//
//  Created by 刘冉 on 2018/9/28.
//  Copyright © 2018年 LRCY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (AppImageClear)

/// 去除图片背景
- (UIImage *)imageToTransparent;

@end

NS_ASSUME_NONNULL_END
