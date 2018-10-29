//
//  AppRecordView.h
//  LibTools
//
//  Created by 刘冉 on 2018/10/29.
//  Copyright © 2018 LRCY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppRecordView : UIView

/// 更新音频能量
- (void)updateWithPower:(float)power;

@end

NS_ASSUME_NONNULL_END
