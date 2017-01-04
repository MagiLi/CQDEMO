//
//  CQAnimation.h
//  CQPayedDemo
//
//  Created by mac on 17/1/4.
//  Copyright © 2017年 wwdx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQAnimationManager : NSObject
+ (instancetype)sharedInsatnce;
- (BOOL)existRotationAnimation:(CALayer *)layer;
- (void)startRotationAnimation:(CALayer *)layer duration:(CGFloat)duration;
- (void)pauseRotationAnimation:(CALayer *)layer;
- (void)resumeRotationAnimation:(CALayer *)layer;
- (void)removeRotationAnimation:(CALayer *)layer;

@end
