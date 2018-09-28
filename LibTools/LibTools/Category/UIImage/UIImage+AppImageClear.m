//
//  UIImage+AppImageClear.m
//  LibTools
//
//  Created by 刘冉 on 2018/9/28.
//  Copyright © 2018年 LRCY. All rights reserved.
//

#import "UIImage+AppImageClear.h"

@implementation UIImage (AppImageClear)

- (UIImage *)imageToTransparent {
    const int imageWidth = self.size.width;
    const int imageHeight = self.size.height;
    
    size_t bytePerRow = imageWidth * 4;
    uint32_t* rgbImageBuff = (uint32_t*) malloc(bytePerRow * imageHeight);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef contect = CGBitmapContextCreate(rgbImageBuff, imageWidth, imageHeight, 8, bytePerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(contect, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    
    // 遍历像素
    int pixNum = imageWidth * imageHeight;
    uint32_t *pCurptr = rgbImageBuff;
    for (int i = 0; i < pixNum; i ++,pCurptr ++) {
        uint8_t *ptr = (uint8_t *)pCurptr;
        if (ptr[1] >= 200 || ptr[2] >= 200 || ptr[3] >= 200) {
            ptr[0] = 0;
        }
    }
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuff, bytePerRow * imageHeight, nil);
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytePerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGContextRelease(contect);
    CGColorSpaceRelease(colorSpace);
    
    return image;
}

@end
