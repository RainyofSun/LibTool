//
//  UIColor+Hex.h
//  LibTools
//
//  Created by 刘冉 on 2018/8/22.
//  Copyright © 2018年 LRCY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor*)colorWithRGB:(NSUInteger)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor*)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
