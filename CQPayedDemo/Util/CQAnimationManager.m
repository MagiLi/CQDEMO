//
//  CQAnimation.m
//  CQPayedDemo
//
//  Created by mac on 17/1/4.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import "CQAnimationManager.h"

#define RotationAnimationKey @"rotationAnimationKey"

@implementation CQAnimationManager
+ (instancetype)sharedInsatnce {
    static CQAnimationManager *animation;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        animation = [[self alloc] init];
    });
    return animation;
}
- (BOOL)existRotationAnimation:(CALayer *)layer {
    return (BOOL)[layer animationForKey:RotationAnimationKey];
}
- (void)startRotationAnimation:(CALayer *)layer duration:(CGFloat)duration {
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    baseAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    baseAnimation.duration = duration;
    baseAnimation.cumulative = YES;
    baseAnimation.repeatCount = MAXFLOAT;
    baseAnimation.removedOnCompletion = NO;
    [layer addAnimation:baseAnimation forKey:RotationAnimationKey];
}
- (void)pauseRotationAnimation:(CALayer *)layer {
    CFTimeInterval pauseTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.timeOffset = pauseTime;
    layer.speed = 0;
}
- (void)resumeRotationAnimation:(CALayer *)layer {
    CFTimeInterval pauseTime = layer.timeOffset;
    CFTimeInterval begin = CACurrentMediaTime() - pauseTime;
    [layer setTimeOffset:0];
    [layer setBeginTime:begin];
    layer.speed = 1;
}
- (void)removeRotationAnimation:(CALayer *)layer {
    [layer removeAnimationForKey:RotationAnimationKey];
}

@end
