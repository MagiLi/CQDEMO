//
//  UIImage+CQBlur.m
//  ReadWhats
//
//  Created by mac on 16/11/1.
//  Copyright © 2016年 . All rights reserved.
//

#import "UIImageView+CQBlur.h"

@implementation UIImageView (CQBlur)

- (UIImage *)blurCoreImageWithImage:(UIImage *)image{
    if (!image) return nil;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filterBlur = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filterBlur setValue:inputImage forKey:kCIInputImageKey];
    [filterBlur setValue:@(30.0) forKey:kCIInputRadiusKey];
    CIImage *blurImg=[filterBlur outputImage];
    
    CIFilter *filterBrightness = [CIFilter filterWithName:@"CIColorControls"];
    [filterBrightness setValue:blurImg forKey:kCIInputImageKey];
    [filterBrightness setValue:@(0.1) forKey:kCIInputBrightnessKey];
    [filterBrightness setValue:@(1.0) forKey:kCIInputSaturationKey]; // 饱和度
    [filterBrightness setValue:@(1.0) forKey:kCIInputContrastKey]; // 对比度
    CIImage *brightImg=[filterBrightness outputImage];
    
    CGImageRef cgImage = [context createCGImage:brightImg fromRect:[inputImage extent]];
    UIImage *img = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return img; 
}

- (void)setBlurImage:(UIImage *)image {
    __block UIImage *img = image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block UIImage *image = [self blurCoreImageWithImage:img];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
        });
    });
}

@end
