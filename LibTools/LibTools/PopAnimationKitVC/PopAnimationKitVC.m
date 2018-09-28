//
//  PopAnimationKitVC.m
//  LibTools
//
//  Created by 刘冉 on 2018/9/3.
//  Copyright © 2018年 LRCY. All rights reserved.
//

#import "PopAnimationKitVC.h"
#import <pop/pop.h>

@interface PopAnimationKitVC ()

/** animationView */
@property (nonatomic,strong) IBOutlet UIButton *animationView;

@end

@implementation PopAnimationKitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addGesture];
}

- (void)addGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.animationView addGestureRecognizer:pan];
}

- (void)panGesture:(UIPanGestureRecognizer *)pan {
    CGPoint offset = [pan translationInView:self.view];
    self.animationView.transform = CGAffineTransformTranslate(self.animationView.transform, offset.x, offset.y);
    [pan setTranslation:CGPointZero inView:self.view];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        POPDecayAnimation *decayAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
        CGPoint velocity = [pan velocityInView:self.view];
        decayAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        [self.animationView pop_addAnimation:decayAnimation forKey:@"layer"];
        decayAnimation.animationDidApplyBlock = ^(POPAnimation *anim) {
            POPDecayAnimation *animation = (POPDecayAnimation *)anim;
            BOOL baseViewInsideofSuperView = CGRectContainsRect(self.view.frame, self.animationView.frame);
            if (!baseViewInsideofSuperView) {
                CGPoint currentVelocity = [animation.velocity CGPointValue];
                CGPoint velocity = CGPointMake(currentVelocity.x, -currentVelocity.y);
                POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
                springAnimation.velocity = [NSValue valueWithCGPoint:velocity];
                springAnimation.toValue = [NSValue valueWithCGPoint:self.view.center];
                [self.animationView.layer pop_addAnimation:springAnimation forKey:@"spring"];
            }
        };
    }
}

- (IBAction)animationBtnClick:(UIButton *)sender {
    POPBasicAnimation *bouns = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBounds];
    bouns.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 150, 150)];
    bouns.duration = 2;
    [sender.layer pop_addAnimation:bouns forKey:@"bouns"];
    
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"countDown" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(id obj, CGFloat *values) {
            NSLog(@"%p",values);
        };
        prop.writeBlock = ^(id obj, const CGFloat *values) {
            UIButton *btn = (UIButton *)obj;
            [btn setTitle:[NSString stringWithFormat:@"%02d:%02d:%02d",(int)values[0]/60,(int)values[0]%60,(int)(values[0]*100)%100] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        };
        prop.threshold = 10;
    }];
    
    POPBasicAnimation *anBasic = [POPBasicAnimation linearAnimation];   //秒表当然必须是线性的时间函数
    anBasic.property = prop;    //自定义属性
    anBasic.fromValue = @(0);   //从0开始
    anBasic.toValue = @(3*60);  //180秒
    anBasic.duration = 3*60;    //持续3分钟
    anBasic.beginTime = CACurrentMediaTime();
    [sender pop_addAnimation:anBasic forKey:@"countdown"];
    bouns.animationDidReachToValueBlock = ^(POPAnimation *anim) {
        POPSpringAnimation *Springanim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        // 移动距离
        Springanim.toValue = [[NSNumber alloc] initWithFloat:sender.center.y + 200];
        // 从当前 + 1s后开始
        // 弹力--晃动的幅度 (springSpeed速度)
        Springanim.springBounciness = 15.0f;
        [sender pop_addAnimation:Springanim forKey:@"position"];
        POPSpringAnimation *anim1 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
        anim1.toValue = [NSValue valueWithCGRect:CGRectMake(100, 100, 99, 99)];
        [sender pop_addAnimation:anim1 forKey:@"size"];
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
