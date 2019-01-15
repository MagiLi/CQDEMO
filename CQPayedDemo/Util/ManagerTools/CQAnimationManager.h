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
- (BOOL)existRotationAnimation:(CALayer *)layer;// 是否存在旋转动画
- (void)startRotationAnimation:(CALayer *)layer duration:(CGFloat)duration;// 开始旋转
- (void)pauseRotationAnimation:(CALayer *)layer;// 暂停
- (void)resumeRotationAnimation:(CALayer *)layer;// 继续
- (void)removeRotationAnimation:(CALayer *)layer;// 移除

@end
