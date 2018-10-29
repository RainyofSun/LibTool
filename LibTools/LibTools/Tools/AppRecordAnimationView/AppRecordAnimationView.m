//
//  AppRecordAnimationView.m
//  LibTools
//
//  Created by 刘冉 on 2018/10/29.
//  Copyright © 2018 LRCY. All rights reserved.
//

#import "AppRecordAnimationView.h"

@interface AppRecordAnimationView ()

/** recordAnimationImg */
@property (nonatomic,strong) UIImageView *recordAnimationImg;
/** maskLayer */
@property (nonatomic,strong) CAShapeLayer *maskLayer;

@end

@implementation AppRecordAnimationView

- (void)dealloc {
    NSLog(@"释放了 %@",NSStringFromClass(self.class));
}

- (void)updateAudioPower:(float)power {
    [self addSubview:_recordAnimationImg];
    [self setupFrame];
    int viewCount = ceil(fabsf(power) * 10);
    if (viewCount == 0) {
        viewCount ++;
    }
    if (viewCount > 9) {
        viewCount = 9;
    }
    
    if (_maskLayer == nil) {
        self.maskLayer = [CAShapeLayer new];
        _maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    }
    
    CGFloat itemHeight  = 3;
    CGFloat itemPadding = 3.5;
    CGFloat maskPadding = itemHeight * viewCount + (viewCount - 1) * itemPadding;

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, _originSize.height - maskPadding, _originSize.width, _originSize.height)];
    _maskLayer.path = path.CGPath;
    _recordAnimationImg.layer.mask = _maskLayer;
    
}

- (void)setupFrame {
    self.recordAnimationImg.frame = CGRectMake(0, 0, _originSize.width, _originSize.height);
    self.recordAnimationImg.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (UIImageView *)recordAnimationImg {
    if (!_recordAnimationImg) {
        _recordAnimationImg = [[UIImageView alloc] init];
        _recordAnimationImg.backgroundColor = [UIColor clearColor];
        _recordAnimationImg.image = [UIImage imageNamed:@"ic_record_ripple"];
    }
    return _recordAnimationImg;
}

@end
