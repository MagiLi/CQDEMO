//
//  UIImage+image.m
//  中盾app
//
//  Created by Xcode on 16/8/4.
//  Copyright © 2016年 Xcode. All rights reserved.
//

#import "UIImage+CQExtern.h"

@implementation UIImage (CQExtern)

+ (UIImage *)scaleImage:(UIImage *)image maxSize:(CGSize)maxSize {
    image = [image fixOrientation];
    CGSize originalSize = image.size;
    if ((originalSize.width <= maxSize.width) &&
        (originalSize.height <= maxSize.height))
    {
        return image;
    } else{
        CGFloat ratio = 0;
        if (originalSize.width > originalSize.height)
        {
            ratio = maxSize.width / originalSize.width;
        }
        else
        {
            ratio = maxSize.height / originalSize.height;
        }
        CGRect rect = CGRectMake(0, 0, originalSize.width * ratio,
                                 originalSize.height * ratio);
        UIGraphicsBeginImageContext(rect.size);
        [image drawInRect:rect];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
}

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect =CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
    
}
+ (UIImage *)imageCornerRadiusWithColor:(UIColor *)color withBound:(CGRect)bound {
    if (!color || bound.size.width <=0 || bound.size.height <=0) return nil;
    UIGraphicsBeginImageContextWithOptions(bound.size,NO, 0);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //    if (radius) {
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:bound byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(bound.size.height, bound.size.height)];
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    //    }
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, bound);

    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
     CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    return image;
    
}
- (UIImage*)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors {
    return  [self gradientImageWithBounds:bounds andColors:colors andGradientType:1 cornerRadius:NO];
}
- (UIImage*)gradientCornersRadiusImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors {
    return [self gradientImageWithBounds:bounds andColors:colors andGradientType:1 cornerRadius:YES];
}
- (UIImage*)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors andGradientType:(int)gradientType cornerRadius:(BOOL)radius {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if (radius) {
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(bounds.size.height, bounds.size.height)];
        CGContextAddPath(context, path.CGPath);
        CGContextClip(context);
    }

    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, bounds.size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(bounds.size.width, 0.0);
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}
+ (instancetype)cq_resizedImageWithImageName:(NSString *)name {
    return [self cq_resizedImageWithImage:[UIImage imageNamed:name]];
}

+ (instancetype)cq_resizedImageWithImage:(UIImage *)image {
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (instancetype)cq_cutImage:(UIImage*)image andSize:(CGSize)newImageSize {
    UIGraphicsBeginImageContextWithOptions(newImageSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height)];
    // 从上下文中取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (instancetype)cq_captureCircleImage:(UIImage *)image {
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    imageW = MIN(imageH, imageW);
    imageH = imageW;
    
    CGFloat border = imageW / 100 * 2;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    CGFloat radius = imageSize.width * 0.5;
    
    CGSize graphicSize = CGSizeMake(imageSize.width + 2 * border, imageSize.height + 2 * border);
    UIGraphicsBeginImageContextWithOptions(graphicSize, NO, 0.0);
    
    // 灰色边框
    [[UIColor darkGrayColor] setFill];
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextAddArc(context,graphicSize.width * 0.5, graphicSize.height * 0.5, radius+border, -M_PI, M_PI, 0);
    CGContextFillPath(context);
    
    // 红色边框
    [[UIColor colorWithRed:247 / 255.0 green:98 / 255.0 blue:46 / 255.0 alpha:1.0] setFill];
    CGContextAddArc(context, graphicSize.width * 0.5, graphicSize.height * 0.5, radius + border, -M_PI * 1.35, M_PI * 0.35, 1);
    CGContextFillPath(context);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(graphicSize.width * 0.5, graphicSize.height * 0.5) radius:radius startAngle:-M_PI endAngle:M_PI clockwise:YES];
    [path addClip];
    
    CGRect imageFrame = CGRectMake(border, border, imageSize.width, imageSize.height);
    [image drawInRect:imageFrame];
    UIImage *finishImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finishImage;
}

+ (instancetype)cq_captureCircleImageWithURL:(NSString *)iconUrl andBorderWith:(CGFloat)border andBorderColor:(UIColor *)color {
    return [self cq_captureCircleImageWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iconUrl]]] andBorderWith:border andBorderColor:color];
}

+ (instancetype)cq_captureCircleImageWithImage:(UIImage *)iconImage andBorderWith:(CGFloat)border andBorderColor:(UIColor *)color {
    CGFloat imageW = iconImage.size.width + border * 2;
    CGFloat imageH = iconImage.size.height + border * 2;
    imageW = MIN(imageH, imageW);
    imageH = imageW;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    // 新建一个图形上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [color set];
    // 画大圆
    CGFloat bigRadius = imageW * 0.5;
    CGFloat centerX = imageW * 0.5;
    CGFloat centerY = imageH * 0.5;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    // 画小圆
    CGFloat smallRadius = bigRadius - border;
    CGContextAddArc(ctx , centerX , centerY , smallRadius ,0, M_PI * 2, 0);
    // 切割
    CGContextClip(ctx);
    // 画图片
    [iconImage drawInRect:CGRectMake(border, border, iconImage.size.width, iconImage.size.height)];
    //从上下文中取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (instancetype)cq_blurredImageWithImage:(UIImage *)image andBlurAmount:(CGFloat)blurAmount {
    return [image cq_blurredImage:blurAmount];
}

+ (instancetype)cq_viewShotWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (instancetype)cq_screenShot {
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    // 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)cq_waterImageWithBgImageName:(NSString *)bgName andWaterImageName:(NSString *)waterImageName {
    UIImage *bgImage = [UIImage imageNamed:bgName];
    CGSize imageViewSize = bgImage.size;
    
    UIGraphicsBeginImageContextWithOptions(imageViewSize, NO, 0.0);
    [bgImage drawInRect:CGRectMake(0, 0, imageViewSize.width, imageViewSize.height)];
    
    UIImage *waterImage = [UIImage imageNamed:waterImageName];
    CGFloat scale = 0.2;
    CGFloat margin = 5;
    CGFloat waterW = imageViewSize.width * scale;
    CGFloat waterH = imageViewSize.height * scale;
    CGFloat waterX = imageViewSize.width - waterW - margin;
    CGFloat waterY = imageViewSize.height - waterH - margin;
    
    [waterImage drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (instancetype)cq_reduceImage:(UIImage *)image percent:(CGFloat)percent {
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    
    return newImage;
}

+ (instancetype)cq_imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (instancetype)cq_imageWithDataSimple:(NSData *)imageData scaledToSize:(CGSize)newSize {
    return [self cq_imageWithImageSimple:[UIImage imageWithData:imageData] scaledToSize:newSize];
}

- (instancetype)cq_blurredImage:(CGFloat)blurAmount {
    if (blurAmount < 0.0 || blurAmount > 3.0) {
        blurAmount = 0.5;
    }
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    int boxSize = blurAmount * 40;
    boxSize = boxSize - (boxSize % 2) + 1;
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (!error) {
//        error = vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (instancetype)cq_blearImageWithBlurLevel:(CGFloat)blurLevel {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setDefaults];
    [blurFilter setValue:inputImage forKey:@"inputImage"];
    // 设值模糊的级别
    [blurFilter setValue:[NSNumber numberWithFloat:blurLevel] forKey:@"inputRadius"];
    CIImage *outputImage = [blurFilter valueForKey:@"outputImage"];
    CGRect rect = inputImage.extent; // Create Rect
    // 设值一下减到图片的白边
    rect.origin.x += blurLevel;
    rect.origin.y += blurLevel;
    rect.size.height -= blurLevel * 2.0f;
    rect.size.width -= blurLevel * 2.0f;
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:rect];
    // 获取新的图片
    UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:0.5 orientation:self.imageOrientation];
    // 释放图片
    CGImageRelease(cgImage);
    
    return newImage;
}

+ (instancetype)cq_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end
