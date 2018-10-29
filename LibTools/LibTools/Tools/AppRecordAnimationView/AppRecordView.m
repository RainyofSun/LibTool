//
//  AppRecordView.m
//  LibTools
//
//  Created by 刘冉 on 2018/10/29.
//  Copyright © 2018 LRCY. All rights reserved.
//

#import "AppRecordView.h"
#import "AppRecordAnimationView.h"
#import "PureLayout.h"

@interface AppRecordView ()

/** imageRecord */
@property (nonatomic,strong) UIImageView *imageRecord;
/** lbContent */
@property (nonatomic,strong) UILabel *lbContent;
/** powerView */
@property (nonatomic,strong) AppRecordAnimationView *powerView;

@end

@implementation AppRecordView

- (void)updateWithPower:(float)power {
    [self.powerView updateAudioPower:power];
}

- (void)updateWithText:(NSString *)newText {
    self.lbContent.text = newText;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setupFrame];
}

- (void)setupFrame {
    
    [self addSubview:self.imageRecord];
    [self addSubview:self.powerView];
    [self addSubview:self.lbContent];
    
    [self.imageRecord autoAlignAxis:ALAxisVertical toSameAxisOfView:self withOffset:-10];
    [self.imageRecord autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:30];
    [self.imageRecord autoSetDimensionsToSize:_imageRecord.image.size];
    
    CGSize powerSize = CGSizeMake(18, 56);
    [self.powerView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.imageRecord];
    [self.powerView autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.imageRecord withOffset:4];
    [self.powerView autoSetDimensionsToSize:powerSize];
    
    [self.lbContent autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:3];
    [self.lbContent autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:3];
    [self.lbContent autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.powerView withOffset:8];
    
    self.powerView.originSize = powerSize;
    [self.powerView updateAudioPower:0];
    
    self.layer.cornerRadius = 10.f;
    self.clipsToBounds = YES;
}

#pragma mark - setter
- (UIImageView *)imageRecord {
    if (!_imageRecord) {
        _imageRecord = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_record"]];
        _imageRecord.backgroundColor = [UIColor clearColor];
    }
    return _imageRecord;
}

- (AppRecordAnimationView *)powerView {
    if (!_powerView) {
        _powerView = [[AppRecordAnimationView alloc] init];
        _powerView.backgroundColor = [UIColor clearColor];
    }
    return _powerView;
}

- (UILabel *)lbContent {
    if (!_lbContent) {
        _lbContent = [[UILabel alloc] init];
        _lbContent.backgroundColor = [UIColor clearColor];
        _lbContent.textColor = [UIColor whiteColor];
        _lbContent.font = [UIFont systemFontOfSize:14];
        _lbContent.numberOfLines = 4;
        _lbContent.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _lbContent.text = @"i like you i like you i like you i like you i like you i like you i like you i like you i like you i like you i like you i like you i like you i like you i like you i like you ";
    }
    return _lbContent;
}

@end
