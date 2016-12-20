//
//  UIImage+CQExtra.m
//  Modal
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "UIImage+CQExtra.h"

@implementation UIImage (CQExtra)
- (UIImage *)creatRadiusImage:(CGSize)size strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor
{
    //    CGRect rect = CGRectMake(0, 0, 15,15);
    //    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    //    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //    CGContextAddEllipseInRect(ctx, CGRectMake(2.5, 1, 10, 10));
    //    CGContextSetLineWidth(ctx, 2);
    //    [[UIColor blueColor] setFill];
    //    [[UIColor blackColor] setStroke];
    //    CGContextFillPath(ctx);
    //    CGContextStrokePath(ctx);
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //    path.lineWidth = 5;
    [path addArcWithCenter:CGPointMake(size.width/2, size.height/2) radius:
     (size.width - 5)/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    {
        [strokeColor setStroke];
        [path stroke];
        [fillColor setFill];
        [path fill];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}

@end
