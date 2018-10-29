//
//  AppRecordAnimationView.h
//  LibTools
//
//  Created by 刘冉 on 2018/10/29.
//  Copyright © 2018 LRCY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppRecordAnimationView : UIView

/** originSize */
@property (nonatomic,assign) CGSize originSize;

/// 更新x音频能量
- (void)updateAudioPower:(float)power;

@end

NS_ASSUME_NONNULL_END
