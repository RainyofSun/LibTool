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
/** powerView */
@property (nonatomic,strong) AppRecordAnimationView *powerView;

@end

@implementation AppRecordView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)updateWithPower:(float)power {
    [self.powerView updateAudioPower:power];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setupFrame];
}

- (void)setupFrame {
    
    [self addSubview:self.imageRecord];
    [self addSubview:self.powerView];
    
    [self.imageRecord autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:40];
    [self.imageRecord autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:30];
    [self.imageRecord autoSetDimensionsToSize:_imageRecord.image.size];
    
    CGSize powerSize = CGSizeMake(18, 56);
    [self.powerView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.imageRecord];
    [self.powerView autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.imageRecord withOffset:4];
    [self.powerView autoSetDimensionsToSize:powerSize];
    
    self.powerView.originSize = powerSize;
    [self.powerView updateAudioPower:0];
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

@end
